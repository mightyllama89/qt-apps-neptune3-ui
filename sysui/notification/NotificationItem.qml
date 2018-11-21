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
import QtQuick.Controls 2.0
import shared.controls 1.0
import shared.Style 1.0
import shared.Sizes 1.0

Control {
    id: root

    property string notificationText
    property string notificationSubtext
    property url notificationIcon
    property string notificationActionText
    property url notificationImage
    property bool dividerVisible: false

    signal buttonClicked()
    signal closeClicked()

    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding
    topPadding: Sizes.dp(27)
    bottomPadding: Sizes.dp(27)

    background: Rectangle {
        color: Style.offMainColor
    }

    contentItem: ListItemFlatButton {
        wrapText: true
        icon.source: root.notificationIcon
        text: root.notificationText
        subText: root.notificationSubtext
        closeButtonVisible: true
        textFlatButton: root.notificationActionText
        symbolFlatButton: root.notificationImage
        dividerVisible: root.dividerVisible
        onFlatButtonClicked: root.buttonClicked()
        onCloseButtonClicked: root.closeClicked()
    }
}
