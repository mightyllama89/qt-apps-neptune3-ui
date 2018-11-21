/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 IVI UI.
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

import QtQuick 2.8
import application.windows 1.0
import shared.utils 1.0
import shared.controls 1.0
import shared.animations 1.0

import "stores" 1.0
import "views" 1.0

import shared.Style 1.0
import shared.Sizes 1.0

QtObject {
    property var mainWindow: ApplicationCCWindow {
        id: mainWindow

        MultiPointTouchArea {
            id: multiPoint
            anchors.fill: parent
            anchors.margins: 30
            touchPoints: [ TouchPoint { id: touchPoint1 } ]

            property int count: 0
            onReleased: {
                count += 1;
                mainWindow.setWindowProperty("activationCount", count);
            }
        }

        ScalableBorderImage {

            x: mainWindow.exposedRect.x
            y: mainWindow.exposedRect.y - Sizes.dp(224)
            width: mainWindow.exposedRect.width
            height: tunerAppContent.fullscreenTopHeight + mainWindow.exposedRect.y - y
            border.top: sourceSize.height - Sizes.dp(1)

            opacity: (mainWindow.neptuneState === "Maximized") ? 1.0 : 0.0
            Behavior on opacity { DefaultNumberAnimation {} }
            visible: opacity > 0

            source: Config.gfx("app-fullscreen-top-bg", Style.theme)
        }

        TunerView {
            id: tunerAppContent
            x: mainWindow.exposedRect.x
            y: mainWindow.exposedRect.y
            width: mainWindow.exposedRect.width
            height: mainWindow.exposedRect.height
            store: TunerStore { }
        }
    }
}
