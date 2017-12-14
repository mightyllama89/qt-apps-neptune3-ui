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

import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import utils 1.0
import animations 1.0
import controls 1.0

import "models"

ListView {
    id: root
    clip: true

    opacity: visible ? 1 : 0
    Behavior on opacity { DefaultNumberAnimation { } }

    signal callRequested(string handle)

    delegate: ItemDelegate { // FIXME right component?
        width: ListView.view.width
        contentItem: Column {
            spacing: Style.vspan(.2)
            RowLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: Style.hspan(.5)
                RoundImage {
                    height: parent.height
                    width: height
                    source: "assets/profile_photos/%1.jpg".arg(model.handle)
                }
                Label {
                    text: model.firstName + " " + model.surname
                    font.weight: Font.Light
                }
                Item { // spacer
                    Layout.fillWidth: true
                }
                Tool {
                    symbol: Style.symbol("ic-message-contrast")
                }
                Tool {
                    symbol: Style.symbol("ic-call-contrast")
                    onClicked: root.callRequested(model.handle)
                }
            }
            Rectangle { // separator
                width: parent.width
                height: 1
                color: "lightgray" // FIXME correct color
            }
        }
    }
}
