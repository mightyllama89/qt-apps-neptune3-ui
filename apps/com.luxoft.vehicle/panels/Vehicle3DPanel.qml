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

import QtQuick 2.0
import Qt3D.Core 2.0
import Qt3D.Render 2.9
import Qt3D.Extras 2.9
import Qt3D.Input 2.0
import Qt3D.Logic 2.0
import QtQuick.Scene3D 2.0
import QtQuick.Controls 2.3

import shared.Sizes 1.0

import "../helpers"  1.0
import "../3d/materials" 1.0
import "../3d/entities" 1.0
import "../3d/settings" 1.0

Item {
    id: root
    anchors.fill: parent

    property real lastCameraAngle: 0.0
    property string modelVersion

    //ToDo: This is a part of a work around for the Scene3D windows&macOS bug
    property real roofOpenProgress: 0.0
    property bool leftDoorOpen: false
    property bool rightDoorOpen: false
    property bool trunkOpen: false

    property bool readyToChanges: false

    // in some cases Scene3D doesn't create anything, such cases are really hard to reproduce
    // but we need to have some flag to verify
    property bool renderStarted: false


    Scene3D {
        height: Sizes.dp(380)
        width: Sizes.dp(960)
        anchors.verticalCenterOffset: Sizes.dp(80)
        anchors.centerIn: parent
        aspects: ["input", "logic"]
        focus: false

        Entity {
            RenderSettings {
                id: renderSettings
                activeFrameGraph: FrameGraph {
                    clearColor: "transparent"
                    camera: camera
                }
                // NB: this should work once https://codereview.qt-project.org/#/c/208218/ is merged
                renderPolicy: RenderSettings.OnDemand
            }

            InputSettings {
                id: inputSettings
            }

            FrameAction {
                id: frameCounter
            }

            components: [inputSettings, renderSettings, frameCounter]


            Connections {
                id: readyToChangeConnection
                target: frameCounter
                property int fc: 0
                onTriggered: {
                    if (!root.renderStarted) {
                        root.renderStarted = true;
                    }

                    if (body.bodyLoaded) {
                        fc += 1;
                        // skip first 5 frames to be sure that all content is ready
                        if (fc > 5) {
                            readyToChangeConnection.target = null;
                            root.readyToChanges = true;
                        }
                    }
                }
            }

            Camera {
                id: camera
                projectionType: CameraLens.PerspectiveProjection
                fieldOfView: 15
                nearPlane: 0.1
                farPlane: 100.0
                position:   Qt.vector3d(0.0, 5.0, 18.0)
                viewCenter: Qt.vector3d(0.0, 0.6, 0.0)
                upVector:   Qt.vector3d(0.0, 1.0, 0.0)
            }

            CameraController {
                camera: camera
                enabled: true
                onCameraPanAngleChanged: root.lastCameraAngle = cameraPanAngle
            }

            CookTorranceMaterial {
                id: rubberMaterial
                albedo: "black"
                metalness: 0.9
                roughness: 0.5
            }

            CookTorranceMaterial {
                id: wheelChromeMaterial
                albedo: "black"
                metalness: 0.1
                roughness: 0.7
            }

            CookTorranceMaterial {
                id: taillightsMaterial
                albedo: "red"
                metalness: 0.1
                roughness: 0.2
                alpha: 0.5
            }

            CookTorranceMaterial {
                id: blackMaterial
                albedo: "black"
                metalness: 0.5
                roughness: 0.8
            }

            CookTorranceMaterial {
                id: whiteHood
                albedo: "white"
                metalness: 0.1
                roughness: 0.35
            }

            CookTorranceMaterial {
                id: chromeMaterial
                albedo: "black"
                metalness: 0.1
                roughness: 0.2
            }

            CookTorranceMaterial {
                id: interiorMaterial
                albedo: "gray"
                metalness: 1.0
                roughness: 0.1
            }

            CookTorranceMaterial {
                id: whiteMaterial
                albedo: "white"
                metalness: 0.5
                roughness: 0.5
            }

            CookTorranceMaterial {
                id: glassMaterial
                albedo: "black"
                metalness: 0.1
                roughness: 0.1
                alpha: 0.8
            }

            Shadow {}
            AxisFront {
                version: root.modelVersion
            }
            AxisRear {
                version: root.modelVersion
            }
            Seats {
                version: root.modelVersion
            }
            RearDoor {
                id: trunk
                open: root.trunkOpen
                version: root.modelVersion
            }
            LeftDoor {
                id: leftDoor
                open: root.leftDoorOpen
                version: root.modelVersion
            }
            RightDoor {
                id: rightDoor
                open: root.rightDoorOpen
                version: root.modelVersion
            }
            Roof {
                id: roof
                openProgress: root.roofOpenProgress
                version: root.modelVersion
            }
            Body {
                id: body
                version: root.modelVersion
                onBodyLoadedChanged: {
                    if (bodyLoaded) {
                        camera.panAboutViewCenter(lastCameraAngle, Qt.vector3d(0, 1, 0));
                    }
                }
            }
        }
    }
}
