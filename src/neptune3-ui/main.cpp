/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
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

#include <QtAppManCommon/global.h>
#include <QtAppManCommon/logging.h>
#include <QtAppManCommonVersion>
#include <QtIviCore/QtIviCoreVersion>
#include <QtAppManMain/main.h>
#include <QtAppManMain/defaultconfiguration.h>
#include <QtAppManPackage/package.h>
#include <QtAppManInstaller/sudo.h>
#include <QtAppManWindow/touchemulation.h>
#include <QGuiApplication>
#include <QTranslator>
#include <QLibraryInfo>
#include <QFileInfo>
#include <QDir>
#include <QProcess>
#include <QTouchDevice>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <QDebug>

QT_USE_NAMESPACE_AM

// code to transform a macro into a string literal
#define QUOTE(name) #name
#define STR(macro) QUOTE(macro)

void startRemoteSettingsServer(const QString &argv) {
    QFileInfo fi(argv);
    QProcess *serverProcess = new QProcess(qApp);
    QObject::connect(serverProcess, &QProcess::stateChanged, [serverProcess] (QProcess::ProcessState state) {
        if (state == QProcess::Running) {
            qCInfo(LogSystem) << "Attempted automatic start of RemoteSettingsServer, pid:" << serverProcess->processId();
        }
    });
    QObject::connect(qApp, &QCoreApplication::aboutToQuit, [serverProcess] () {
        serverProcess->terminate();
    });
    serverProcess->start(QStringLiteral("%1/RemoteSettingsServer").arg(fi.canonicalPath()), QProcess::ReadOnly);
}

Q_DECL_EXPORT int main(int argc, char *argv[])
{

    QCoreApplication::setApplicationName(qSL("Neptune UI"));
    QCoreApplication::setOrganizationName(qSL("Pelagicore AG"));
    QCoreApplication::setOrganizationDomain(qSL("pelagicore.com"));
    QCoreApplication::setApplicationVersion(NEPTUNE_VERSION);

    Logging::initialize();

    Package::ensureCorrectLocale();

    try {
        QStringList deploymentWarnings;
        Sudo::forkServer(Sudo::DropPrivilegesPermanently, &deploymentWarnings);

        qputenv("QTIVIMEDIA_SIMULATOR_DATABASE", QFile::encodeName(QDir::homePath() + "/media.db"));
        qputenv("QT_IM_MODULE", "qtvirtualkeyboard");

        Main a(argc, argv);

        // start the server; the server itself will ensure one instance only
        startRemoteSettingsServer(QFile::decodeName(argv[0]));

        // load the Qt translations
        QTranslator qtTranslator;
        if (qtTranslator.load(QLocale(), qSL("qt_"), QString(), QLibraryInfo::location(QLibraryInfo::TranslationsPath))) {
            a.installTranslator(&qtTranslator);
        }

        DefaultConfiguration cfg(QStringList(qSL("am-config.yaml")), QString());
        cfg.parse();
        a.setup(&cfg, deploymentWarnings);

        // setup touch emulation manually at runtime, if it's available _and_ there are no native touch devices
        if (TouchEmulation::isSupported() && QTouchDevice::devices().isEmpty())
            TouchEmulation::createInstance();

        a.loadQml(cfg.loadDummyData());
        a.showWindow(cfg.fullscreen() && !cfg.noFullscreen());

        auto ctx = a.qmlEngine()->rootContext();
        ctx->setContextProperty("qtamVersion", QTAPPMANCOMMON_VERSION_STR);
        ctx->setContextProperty("qtiviVersion", QTIVICORE_VERSION_STR);

        return MainBase::exec();
    } catch (const std::exception &e) {
        qCCritical(LogSystem) << "ERROR:" << e.what();
        return 2;
    }
}
