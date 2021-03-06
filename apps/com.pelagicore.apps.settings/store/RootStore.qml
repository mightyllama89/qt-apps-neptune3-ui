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

import QtQml 2.2
import QtQml.Models 2.3
import shared.utils 1.0
import shared.Style 1.0
import shared.Connectivity 1.0
import shared.com.pelagicore.remotesettings 1.0

import "../helper"

QtObject {
    id: root

    readonly property WiFi wifi: WiFi {}
    readonly property int connectivityStatusConnecting: WiFi.Connecting
    readonly property int connectivityStatusConnected: WiFi.Connected
    readonly property int connectivityStatusDisconnecting: WiFi.Disconnecting
    readonly property int connectivityStatusDisconnected: WiFi.Disconnected

    readonly property Helper helper: Helper {}

    // Time And Date Segment
    readonly property bool twentyFourHourTimeFormat: uiSettings.twentyFourHourTimeFormat !== undefined ?
                                                         uiSettings.twentyFourHourTimeFormat
                                                         // "ap" here indicates the presence of AM/PM suffix;
                                                         // Locale has no other way of telling whether it uses 12 or 24h time format
                                                       : Qt.locale().timeFormat(Locale.ShortFormat).indexOf("AP") === -1

    // Language Segment
    readonly property string currentLanguage: uiSettings.language ? uiSettings.language : Config.languageLocale
    readonly property ListModel languageModel: ListModel {}

    function populateLanguages() {
        languageModel.clear()
        var translations = uiSettings.languages.length !== 0 ? uiSettings.languages : Config.translation.availableTranslations;
        for (var i=0; i<translations.length; i++) {
            var locale = Qt.locale(translations[i]);
            languageModel.append({
                title: locale.nativeLanguageName,
                subtitle: locale.nativeCountryName,
                language: locale.name
            });
        }
    }

    function updateLanguage(languageCode, language) {
        console.log(helper.category, 'updateLanguage: ' + languageCode)
        uiSettings.setLanguage(languageCode);
        helper.showNotification(qsTr("UI Language changed"), qsTr("UI Language changed into %1 (%2)").arg(language).arg(languageCode));
    }

    function update24HourTimeFormat(value) {
        console.log(helper.category, 'update24HourTimeFormat: ', value)
        uiSettings.setTwentyFourHourTimeFormat(value);
    }

    // Accent Colors & themes segment
    property bool startupAccentColor: true
    property var accentColorsModel: Config._initAccentColors(uiSettings.theme)
    property string lighThemeLastAccColor: "#d35756"
    property string darkThemeLastAccColor: "#b75034"

    readonly property ListModel themeModel: ListModel {
        // TODO: This data will be populated from settings server later
        // the server stores the "theme" as an integer
        ListElement { title: QT_TR_NOOP('Light'); theme: 'light' }
        ListElement { title: QT_TR_NOOP('Dark'); theme: 'dark' }
    }

    readonly property UISettings uiSettings: UISettings {
        onAccentColorChanged: {
            root.accentColorsModel.forEach(function(element) {
                var c1 = Qt.lighter(element.color, 1.0)
                var c2 = Qt.lighter(accentColor, 1.0)
                element.selected = Qt.colorEqual(element.color, accentColor)
                        ||  Math.abs(c1.r - c2.r) + Math.abs(c1.g - c2.g) + Math.abs(c1.b - c2.b) < 0.01;

            });
            if (startupAccentColor) {
                //Prevent setting back light theme's last accent color in cases when the UI
                //was closed with light theme set. If this is the case, reset dark theme's
                //default accent color.
                var accColorInPalette = root.accentColorsModel.find(function(color) {
                    return (color.color === accentColor);
                });
                if (accColorInPalette === undefined) {
                    uiSettings.accentColor = accentColorsModel[0].color;
                }
                startupAccentColor = false;
            }
        }
    }

    function updateAccentColor(value) {
        uiSettings.accentColor = value;
    }

    function updateTheme(value) {
        if (value === 1 && (root.lighThemeLastAccColor !== uiSettings.accentColor)) {
            root.lighThemeLastAccColor = uiSettings.accentColor;
        } else if (value === 0 && (root.darkThemeLastAccColor !== uiSettings.accentColor)) {
            root.darkThemeLastAccColor = uiSettings.accentColor;
        }
        uiSettings.setTheme(value);
        //set previous to theme accentColor
        if (lighThemeLastAccColor !== "" && value === 0) {
            updateAccentColor(root.lighThemeLastAccColor);
        } else if (darkThemeLastAccColor !== "" && value === 1) {
            updateAccentColor(root.darkThemeLastAccColor);
        } else {
            updateAccentColor(root.accentColorsModel[0].color);
        }
    }

    // Initialization
    Component.onCompleted: {
        populateLanguages();
    }
}
