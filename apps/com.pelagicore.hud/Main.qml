/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 Cluster UI.
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
import QtQuick.Controls 2.2
import application.windows 1.0
import shared.com.pelagicore.settings 1.0
import shared.com.pelagicore.styles.neptune 3.0

NeptuneWindow {
    id: root

    width: NeptuneStyle.dp(480)
    height: NeptuneStyle.dp(240)

    property real currentSpeed: clusterSettings.speed
    Behavior on currentSpeed {
        NumberAnimation { easing.type: Easing.OutCubic; duration: 5000 }
    }

    Component.onCompleted: {
        setWindowProperty("windowType", "hud");
    }

    InstrumentCluster {
        id: clusterSettings
    }

    Item {
        anchors.fill: parent

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: NeptuneStyle.dp(-30)
            text: Math.round(root.currentSpeed)
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignHCenter
            font.weight: Font.DemiBold
            color: NeptuneStyle.accentColor
            opacity: NeptuneStyle.opacityHigh
            font.pixelSize: NeptuneStyle.fontSizeL
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: NeptuneStyle.dp(30)
            text: qsTr("km/h")
            font.weight: Font.Light
            color: NeptuneStyle.accentColor
            opacity: NeptuneStyle.opacityLow
            font.pixelSize: NeptuneStyle.fontSizeM
        }
    }
}