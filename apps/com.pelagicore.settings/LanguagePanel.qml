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
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import utils 1.0

Control {
    id: root


    property ListModel model

    property string currentLanguage

    signal languageRequested(string language)

    ButtonGroup {
        id: languageGroup
        exclusive: true
    }

    contentItem: Item {
        implicitWidth: Style.hspan(12)
        implicitHeight: Style.vspan(12)
        ListView {
            id: view
            anchors.fill: parent
            clip: true
            spacing: Style.vspan(0.2)
            header: Label {
                padding: Style.vspan(0.2)
                font.pixelSize: Style.fontSizeXL
                text: qsTr("Language")
            }
            model: root.model
            delegate: AbstractButton {
                width: ListView.view.width
                height: Style.hspan(2)
                onClicked: root.languageRequested(model.language)
                contentItem: GridLayout {
                    columns: 2
                    rows: 3
                    RadioButton {
                        Layout.column: 0
                        Layout.row: 0
                        ButtonGroup.group: languageGroup
                        Layout.maximumWidth: Layout.preferredWidth
                        checked: model.language === root.currentLanguage
                        enabled: false
                    }
                    Label {
                        Layout.fillWidth: true
                        Layout.column: 1
                        Layout.row: 0
                        text: model.title
                    }
                    Label {
                        Layout.column: 1
                        Layout.row: 1
                        Layout.fillWidth: true
                        text: model.subtitle
                        font.pixelSize: Style.fontSizeS
                        font.weight: Style.fontWeight
                    }
                    Item {
                        Layout.column: 0
                        Layout.row: 2
                        Layout.columnSpan: 2
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}