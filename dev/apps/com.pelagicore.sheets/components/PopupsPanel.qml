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

import QtQuick 2.8
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import controls 1.0
import utils 1.0

import "../popups"

import com.pelagicore.styles.neptune 3.0

Item {
    id: root
    anchors.horizontalCenter: parent ? parent.horizontalCenter : null
    anchors.top: parent ? parent.top : null
    anchors.topMargin: NeptuneStyle.dp(40)
    anchors.bottom: parent ? parent.bottom : null

    Button {
        id: button
        width: NeptuneStyle.dp(300)
        height: NeptuneStyle.dp(200)
        anchors.centerIn: parent
        customBackgroundColor: NeptuneStyle.accentDetailColor
        text: "ListView Popup"
        onClicked: {
            var pos = this.mapToItem(root.parent, this.width/2, this.height/2);
            popupWithList.originItemX = pos.x;
            popupWithList.originItemY = pos.y;
            popupWithList.popupWidth = 910;
            popupWithList.popupHeight = 450;
            popupWithList.openPopup = true;
        }
    }

    PopupWithList {
        id: popupWithList
    }
}
