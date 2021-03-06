/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 UI.
**
** $QT_BEGIN_LICENSE:GPL-QTAS$
** Commercial License Usage
** Licensees holding valid commercial Qt Automotive Suite licenses may use
** this file in accordance with the commercial license agreement provided
** with the Software or, alternatively, in accordance with the terms
** contained in a written agreement between you and The Qt Company.  For
** licensing terms and conditions see https://www.qt.io/terms-conditions.
** For further information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
** SPDX-License-Identifier: GPL-3.0
**
****************************************************************************/


/*
Note that this example is NOT implemented according Misra C++ 2008 nor ISO26262
functional safety standards and it depends on Qt classes.

You should not use this example in production environment.
*/
#include <QtGui>

#include <QtSafeRenderer/qsafelayout.h>
#include <QtSafeRenderer/qsafechecksum.h>

#include "neptunesafestatemanager.h"
#include "safewindow.h"
#include "tcpmsghandler.h"
#include "icsettingshandler.h"


int main(int argc, char **argv)
{
    QGuiApplication app(argc, argv);

    QDir::setCurrent(qApp->applicationDirPath());

    SafeRenderer::QSafeLayoutFileReader layout("qsr-safelayout/SafeTelltalesPanel.srl");

    //Demo case, update window position on Cluster window move
    QSettings settings(QStringLiteral("Luxoft Sweden AB"), QStringLiteral("QSRCluster"));
    bool stickToCluster = settings.value(QStringLiteral("gui/stick_to_cluster"), true).toBool();

    SafeRenderer::QSafeSize screenSize;
    if (stickToCluster) {
        screenSize.setWidth(layout.size().width());
        screenSize.setHeight(layout.size().height());
    } else {
        screenSize.setWidth(static_cast<SafeRenderer::quint32>(qApp->primaryScreen()->size().width()));
        screenSize.setHeight(static_cast<SafeRenderer::quint32>(qApp->primaryScreen()->size().height()));
    }

    SafeWindow telltaleWindow(screenSize, layout.size());
    telltaleWindow.setFlag(Qt::WindowDoesNotAcceptFocus, true);

    NeptuneSafeStateManager stateManager(telltaleWindow, layout);

    //light up all telltales and texts
    for (unsigned int i=0U; i<layout.count(); i++) {
        SafeRenderer::QSafeEventVisibility visible;
        visible.setId(layout.item(i).id());
        visible.setValue(1U);
        stateManager.handleEvent(visible);
    }

    //TCP server
    TcpMsgHandler msgHandler(&stateManager);

    if (qgetenv("QSR_SHOW_TEXT_ON_STARTUP").isNull()) {
        //hide "safe" label replacements for "non-safe" UI and prevent from text update
        msgHandler.onErrorTextVisibilityChanged(false);
        msgHandler.onPowerLabelsVisibilityChanged(false);
        msgHandler.onSpeedLabelsVisibilityChanged(false);
    } else {
        msgHandler.onErrorTextVisibilityChanged(true);
        msgHandler.onPowerLabelsVisibilityChanged(true);
        msgHandler.onSpeedLabelsVisibilityChanged(true);
    }


    if (stickToCluster) {
        QObject::connect(&msgHandler, &TcpMsgHandler::mainWindowPosGot, &telltaleWindow, &SafeWindow::moveWindow);
    }

    //Remote settings server client
    ICSettingsHandler icSettingsHandler(&stateManager);

    telltaleWindow.show();

    return app.exec();
}
