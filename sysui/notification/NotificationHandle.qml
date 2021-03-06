/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
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

import QtQuick 2.13
import QtQuick.Controls 2.2

import shared.Sizes 1.0
import shared.utils 1.0
import shared.Style 1.0

ToolButton {
    id: root

    implicitWidth: root.notificationCounterVisible ? Sizes.dp(255) : Sizes.dp(205)
    implicitHeight: Sizes.dp(Config.statusBarHeight)

    property alias dragActive: handler.active
    property alias dragTarget: handler.target
    property int prevDragY: 0
    property int dragDelta: 0
    property int dragOrigin: 0
    property int minimumY: 0
    property int maximumY: 0

    property bool swipe: Math.abs(root.prevDragY - root.dragTarget.y) > 0

    property alias dragFilterTimer: dragFilterTimer

    property int notificationCount
    property bool notificationCounterVisible

    signal activeChanged(var active)

    DragHandler {
        id: handler
        target: root.dragTarget
        yAxis.minimum: root.minimumY
        yAxis.maximum: root.maximumY
        onActiveChanged: {
            root.activeChanged(active);
        }
    }

    contentItem: Item {
        width: parent.width
        height: Sizes.dp(30)
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: root.notificationCounterVisible ? Sizes.dp(100) : Sizes.dp(200)
            height: Sizes.dp(4)
            color: Style.contrastColor
        }

        Rectangle {
            width: Sizes.dp(45)
            height: Sizes.dp(30)
            radius: height / 2
            anchors.centerIn: parent
            opacity: root.notificationCounterVisible ? 1 : 0
            visible: opacity > 0
            color: "transparent"
            border.color: Style.contrastColor

            Label {
                id: countLabel
                anchors.centerIn: parent
                font.pixelSize: Sizes.fontSizeXS
                text: root.notificationCount
                color: Style.contrastColor
            }
        }

        Rectangle {
            width: Sizes.dp(100)
            height: Sizes.dp(4)
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            opacity: root.notificationCounterVisible ? 1 : 0
            visible: opacity > 0
            color: Style.contrastColor
        }
    }

    Timer {
        id: dragFilterTimer
        interval: 100
        repeat: true
        onTriggered: {
            root.prevDragY = root.dragTarget.y;
        }
    }
}
