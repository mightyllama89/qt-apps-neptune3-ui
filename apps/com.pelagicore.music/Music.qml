/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton IVI UI.
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
import utils 1.0

AppUIScreen {
    id: root
    title: "Triton Music Player"

    color: "transparent"

    Component.onCompleted: {
        root.setWindowProperty("windowType", "widget");
    }

    Rectangle {
        opacity: 0.3
        color: "blue"
        anchors.fill: parent

        Rectangle {
            color: touchPoint1.pressed ? "red" : "green"
            anchors.fill: parent
            anchors.margins: 30
        }
    }

    MultiPointTouchArea {
        anchors.fill: parent
        touchPoints: [ TouchPoint { id: touchPoint1 } ]

        property int count: 0
        onReleased: {
            count += 1;
            root.setWindowProperty("activationCount", count);
        }
    }
}


/*
import controls 1.0
import utils 1.0
import "models"
import "."

AppUIScreen {
    id: root
    title: "Triton Music Player"

    onClusterKeyPressed: {
        if (key === Qt.Key_Down) {
            MusicModel.next()
        }
        else if (key === Qt.Key_Up) {
            MusicModel.previous()
        }
    }

    cluster: ClusterWidget {}


    AppStackView {
        id: stack
        anchors.fill: parent
        initialItem: currentTrack
        Component {
            id: currentTrack
            CurrentTrackScreen {
                onBackScreen: {
                    root.back()
                }
                onShowAlbums: {
                    stack.push(albums)
                }
            }
        }

        Component {
            id: albums
            AlbumScreen {
                onBackScreen: {
                    stack.pop()
                }

            }
        }
    }
}
*/
