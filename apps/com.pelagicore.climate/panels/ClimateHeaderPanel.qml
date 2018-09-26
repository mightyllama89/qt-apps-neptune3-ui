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

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import shared.com.pelagicore.styles.neptune 3.0
import shared.utils 1.0

import "../controls"

Item {
    id: root

    property alias temperatureDriverSeat: tempLabelLeft.text
    property alias temperaturePassengerSeat: tempLabelRight.text

    property bool zoneSynchronizationEnabled

    signal driverSeatTemperatureIncreased()
    signal driverSeatTemperatureDecreased()
    signal passengerSeatTemperatureIncreased()
    signal passengerSeatTemperatureDecreased()

    signal linkToggled(bool linked)

    Row {
        anchors.centerIn: parent
        spacing: NeptuneStyle.dp(22)
        Column {
            anchors.verticalCenter: parent.verticalCenter
            ClimateButton {
                width: NeptuneStyle.dp(90)
                height: NeptuneStyle.dp(90)
                anchors.horizontalCenter: parent.horizontalCenter
                checkable: false
                font.pixelSize: NeptuneStyle.fontSizeXL
                icon.name: "ic-temperature-plus"
                onClicked: root.driverSeatTemperatureIncreased()
            }
            Label {
                id: tempLabelLeft
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: NeptuneStyle.fontSizeXL
                font.weight: Font.DemiBold
                opacity: NeptuneStyle.opacityMedium
            }
            ClimateButton {
                width: NeptuneStyle.dp(90)
                height: NeptuneStyle.dp(90)
                anchors.horizontalCenter: parent.horizontalCenter
                checkable: false
                font.pixelSize: NeptuneStyle.fontSizeXL
                icon.name: "ic-temperature-minus"
                onClicked: root.driverSeatTemperatureDecreased()
            }
        }

        ClimateButton {
            id: linkTemp
            anchors.verticalCenter: parent.verticalCenter
            icon.name: checked ? "ic-link_ON" : "ic-link_OFF"
            icon.width: NeptuneStyle.dp(24)
            icon.height: NeptuneStyle.dp(24)
            checked: root.zoneSynchronizationEnabled
            onToggled: root.linkToggled(checked)
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            ClimateButton {
                width: NeptuneStyle.dp(90)
                height: NeptuneStyle.dp(90)
                anchors.horizontalCenter: parent.horizontalCenter
                checkable: false
                font.pixelSize: NeptuneStyle.fontSizeXL
                icon.name: "ic-temperature-plus"
                onClicked: root.passengerSeatTemperatureIncreased()
            }
            Label {
                id: tempLabelRight
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: NeptuneStyle.fontSizeXL
                font.weight: Font.DemiBold
                opacity: NeptuneStyle.opacityMedium
            }
            ClimateButton {
                width: NeptuneStyle.dp(90)
                height: NeptuneStyle.dp(90)
                anchors.horizontalCenter: parent.horizontalCenter
                checkable: false
                font.pixelSize: NeptuneStyle.fontSizeXL
                icon.name: "ic-temperature-minus"
                onClicked: root.passengerSeatTemperatureDecreased()
            }
        }
    }
}