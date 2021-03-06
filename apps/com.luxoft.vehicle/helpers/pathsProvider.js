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

.pragma library

function doesFileExist(url) {
    var req = new XMLHttpRequest();
    req.open('HEAD', url, false);
    req.send();
    return req.status == 200;
}


// see vehicle app info.yaml for description
function getModelPath(name, version) {
    version = version || "original";

    if (version === "original" || version === "optimized") {
        return Qt.resolvedUrl("../assets/models/" + version + "/" + name + ".obj")
    }

    if (version === "mixedFormats") {
        var pathObj = Qt.resolvedUrl("../assets/models/" + version + "/" + name + ".obj")
        var pathStl = Qt.resolvedUrl("../assets/models/" + version + "/" + name + ".stl")
        return doesFileExist(pathObj) ? pathObj : pathStl
    }
}

function getImagePath(name) {
    return Qt.resolvedUrl("../assets/images/" + name)
}

function getMaterialPath(name) {
    return Qt.resolvedUrl("../assets/shaders/" + name)
}

function localQt3DStudioPresentationAsset(relativePresentationPath) {
    return "../assets/3dCar/" + relativePresentationPath;
}
