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

import QtQuick 2.7
import QtQuick.Controls 2.2
import utils 1.0

Item {
    id: root

    signal draggedOntoPos(var pos)
    signal dragStarted(var pos)
    signal dragEnded()
    signal closeClicked()

    property bool buttonsVisible: true
    readonly property bool active: appInfo ? appInfo.active : false
    property var appInfo

    BorderImage {
        id: bgImage
        anchors.fill: parent
        anchors.leftMargin: -30
        anchors.rightMargin: -30
        anchors.topMargin: -30
        anchors.bottomMargin: -30
        border { left: 60; right: 60; top: 60; bottom: 60 }
        horizontalTileMode: BorderImage.Stretch
        verticalTileMode: BorderImage.Stretch
        source: Style.gfx2("widget-bg")
    }

    Connections {
        target: root.appInfo ? root.appInfo : null
        onWindowChanged: {
            root.updateState()
        }
    }
    onAppInfoChanged: updateState()

    function updateState() {
        if (!root.appInfo)
            return;

        var window = root.appInfo.window
        if (window) {
            window.parent = root;
            window.width = Qt.binding(function() { return root.width; });
            window.height = Qt.binding(function() { return root.height; });
            window.z = 2
            loadingStateGroup.state = "live"
        } else {
            loadingStateGroup.state = "loading"
        }
    }

    BusyIndicator {
        id: busyIndicator
        running: true
        anchors.fill: parent
        z: 1
    }

    StateGroup {
        id: loadingStateGroup
        state: "loading"
        states: [
            State {
                name: "loading"
            },
            State {
                name: "live"
                PropertyChanges { target: busyIndicator; running: false; visible: false }
            }
        ]
    }

    // Drag handle
    MouseArea {
        id: dragHandle
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 10
        width: Style.hspan(1)
        height: width
        z: 3
        visible: root.buttonsVisible

        onMouseYChanged: root.draggedOntoPos(dragHandle.mapToItem(root, mouseX, mouseY))
        onPressed: root.dragStarted(dragHandle.mapToItem(root, mouseX, mouseY))
        onReleased: root.dragEnded()

        Image {
            anchors.fill: parent
            anchors.centerIn: parent
            source: Style.symbol("ic-widget-draghandle", false /* active */)
            fillMode: Image.Pad
        }
    }

    // Close button
    MouseArea {
        id: closeButton
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 10
        width: Style.hspan(1)
        height: width
        z: dragHandle.z + 1
        visible: root.buttonsVisible

        onClicked: root.closeClicked()

        Image {
            anchors.fill: parent
            anchors.centerIn: parent
            source: Style.symbol("ic-widget-close", false /* active */)
            fillMode: Image.Pad
        }
    }
}