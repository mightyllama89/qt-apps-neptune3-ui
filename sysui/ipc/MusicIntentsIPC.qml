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

import QtQuick 2.0
import QtApplicationManager 1.0

/*!
    \qmltype MusicIntentsIPC
    \inqmlmodule service
    \inherits ApplicationIPCInterface
    \brief An IPC for music intents

    The MusicIntentsIPC is meant to be used only for the music intents use case, enabling music,
    tuner and webradio apps to know whether spotify and/or webradio are installed from the appstore,
    or added / removed. This interface can be accessed only from the mentioned apps.
*/

ApplicationIPCInterface {
    id: root

    /*!
        \qmlproperty rect MusicIntentsIPC::spotifyInstalled

        This property holds whether spotify application is installed or not in Neptune 3.
    */

    property bool spotifyInstalled: false

    /*!
        \qmlproperty rect MusicIntentsIPC::webradioInstalled

        This property holds whether web radio application is installed or not in Neptune 3.
    */

    property bool webradioInstalled: false

    /*!
        \qmlproperty rect MusicIntentsIPC::appmanCnx

        This property is used to listen to the ApplicationManager to get the status of
        external application in Neptune 3.
    */

    property var appmanCnx: Connections {
        target: ApplicationManager
        onApplicationAdded: {
            if (id === "com.pelagicore.spotify") {
                root.spotifyInstalled = true;
            }
            if (id === "com.pelagicore.webradio") {
                root.webradioInstalled = true;
            }
        }
        onApplicationAboutToBeRemoved: {
            if (id === "com.pelagicore.spotify") {
                root.spotifyInstalled = false;
            }
            if (id === "com.pelagicore.webradio") {
                root.webradioInstalled = false;
            }
        }
    }

    Component.onCompleted: {
        ApplicationIPCManager.registerInterface(root, "neptune.musicintents.interface",
                                                { "applicationIds": [ "com.pelagicore.music",
                                                                      "com.pelagicore.tuner",
                                                                      "com.pelagicore.webradio" ] })

        if (ApplicationManager.applicationIds().indexOf("com.pelagicore.spotify") >= 0) {
            root.spotifyInstalled = true;
        }

        if (ApplicationManager.applicationIds().indexOf("com.pelagicore.webradio") >= 0) {
            root.webradioInstalled = true;
        }
    }
}
