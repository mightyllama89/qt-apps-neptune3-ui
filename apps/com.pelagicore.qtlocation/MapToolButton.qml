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
import QtQuick.Controls 2.2
import utils 1.0
import com.pelagicore.styles.triton 1.0

ToolButton {
    id: root
    property string iconSource
    property color labelColor: TritonStyle.primaryTextColor

    property string extendedText: ""
    property color extendedTextColor: "red"
    property int extendedTextFontSize: TritonStyle.fontSizeS

    property string secondaryText: ""
    property color secondaryTextColor: TritonStyle.primaryTextColor
    property int secondaryTextFontSize: TritonStyle.fontSizeS

    contentItem: Item {
        Row {
            spacing: Style.hspan(0.5)
            anchors.centerIn: parent
            Image {
                id: bottonImage
                anchors.verticalCenter: parent.verticalCenter
                source: root.iconSource
            }
            Column {
                spacing: Style.hspan(0.1)
                anchors.verticalCenter: parent.verticalCenter
                Row {
                    spacing: Style.hspan(0.3)
                    Label {
                        id: primaryButtonText
                        anchors.verticalCenter: parent.verticalCenter
                        font: root.font
                        color: root.labelColor
                        text: root.text
                    }
                    Label {
                        id: extendedButtonText
                        anchors.verticalCenter: parent.verticalCenter
                        color: root.extendedTextColor
                        font.pixelSize: root.extendedTextFontSize
                        text: root.extendedText
                    }
                }
                Label {
                    id: secondaryButtonText
                    color: root.secondaryTextColor
                    font.pixelSize: root.secondaryTextFontSize
                    text: root.secondaryText
                }
            }
        }
    }
}