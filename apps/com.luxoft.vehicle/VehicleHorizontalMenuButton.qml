/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AB
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
import QtQuick 2.9
import QtQuick.Controls 2.2

ToolButton {
    id: root

    width: 740 / 4

    states: [
        State {
            name: "LEFT"
            PropertyChanges {
                target: buttonSideRectangel
                width: buttonBackgroundItem.width - buttonSideRectangel.height / 2
                x: buttonSideRectangel.height / 2
            }
        },
        State {
            name: "MIDDLE"
            PropertyChanges {
                target: buttonSideRectangel
                width: buttonBackgroundItem.width
                x: 0
            }
        },
        State {
            name: "RIGHT"
            PropertyChanges {
                target: buttonSideRectangel
                width: buttonBackgroundItem.width - buttonSideRectangel.height / 2
                x: 0
            }
        }
    ]
    state: "MIDDLE"

    contentItem: Text {
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        text: root.text
        font {
            pixelSize: 22
            family: "Open Sans"
        }
        opacity: 0.6
        color: "#faf9f9"
    }

    background: Item{
        id: buttonBackgroundItem

        implicitHeight: 44
        implicitWidth: root.width

        Rectangle {
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            color: root.down ? "#41403f" : "#a4a09e"
            radius: height / 2
        }

        Rectangle {
            id: buttonSideRectangel

            height: parent.height
            color: root.down ? "#41403f" : "#a4a09e"
        }
    }
}
