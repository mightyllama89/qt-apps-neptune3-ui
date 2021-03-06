/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
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

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtLocation 5.9
import QtPositioning 5.9
import shared.animations 1.0


/// class that takes route segments, prepares demo from it, and produces
/// points and vehicle(arrow marker / map bearing) angle
QtObject {
    id: root
    // input properties
    property var model
    property bool active

    // output properties
    property var location: QtPositioning.coordinate()
    property real angle: 0.0

    // inner properties
    property var segmentsList
    property int segmentsListCurrentIdx: 0

    property var path
    property int pathCurrentPointIdx: 0

    property var currentSegment
    property int currentSegment_PathCurrentPointIdx: 0

    // m/s ~ 75km/h
    readonly property real speed: 20.8

    onActiveChanged: {
        if (active) {
            if (root.model.status !== RouteModel.Ready
                    || root.model.count <= 0) {
                return;
            }

            var route = root.model.get(0);
            pathCurrentPointIdx = 0;
            currentSegment_PathCurrentPointIdx = 0;
            segmentsListCurrentIdx = 0;
            segmentsList = route.segments;
            currentSegment = route.segments[0];
            path = route.path;

            root.location = currentSegment.path[0];
            root.angle = path[0].azimuthTo(path[1]);

            setNextAnimation();
        } else if (movementAnimation.running) {
            movementAnimation.stop()
        }
    }

    function setNextAnimation() {
        if (!root.active) {
            return;
        }

        // suppose that it is equal to path[pathIdx]
        var startPos = path[pathCurrentPointIdx];
        var endPos = path[++pathCurrentPointIdx];

        if (!endPos) {
            // arrived;
            return;
        }

        // segment, path inside it
        if (++currentSegment_PathCurrentPointIdx >= currentSegment.path.length) {
            currentSegment_PathCurrentPointIdx = 0
            currentSegment = segmentsList[++segmentsListCurrentIdx];
        }

        // Calculate new direction
        var oldDir = root.angle;
        var newDir = startPos.azimuthTo(endPos);

        // Calculate the duration of the animation
        var azimuthDelta = Math.max(oldDir, newDir) - Math.min(oldDir, newDir);
        var azimuthDeltaShifted = azimuthDelta < 180.0 ? azimuthDelta: azimuthDelta - 180.0;
        movementAnimation.azimuthDt = azimuthDeltaShifted;

        if (azimuthDeltaShifted < 20)
            movementAnimation.rotationDuration = 500;
        else if (azimuthDeltaShifted < 45)
            movementAnimation.rotationDuration = 1000;
        else if (azimuthDeltaShifted < 90)
            movementAnimation.rotationDuration = 2000;
        else if (azimuthDeltaShifted < 135)
            movementAnimation.rotationDuration = 2500;
        else
            movementAnimation.rotationDuration = 3000;

        var pathDistance = startPos.distanceTo(endPos);

        // uniform motion :(
        movementAnimation.coordinateDuration = pathDistance / speed * 1000;
        movementAnimation.rotationDirection = newDir;
        movementAnimation.targetCoordinate = endPos;
        movementAnimation.start();
    }

    readonly property SequentialAnimation movementAnimation: SequentialAnimation{
        id: movementAnimation
        property real rotationDuration: 0
        property real rotationDirection: 0
        property real coordinateDuration: 0
        property var targetCoordinate
        property real azimuthDt: 0
        readonly property real angleThreshold: 25.0

        readonly property bool rotateInMotion: {
            azimuthDt <= angleThreshold;
        }
        readonly property bool rotateInPlace: {
            azimuthDt > angleThreshold;
        }

        SequentialAnimation {
            RotationAnimation {
                target: movementAnimation.rotateInPlace ? root : null
                property: movementAnimation.rotateInPlace ? "angle" : ""
                duration: movementAnimation.rotateInPlace
                          ? movementAnimation.rotationDuration
                          : 0
                to: movementAnimation.rotationDirection
                direction: RotationAnimation.Shortest
            }

            ParallelAnimation {
                RotationAnimation {
                    target: movementAnimation.rotateInMotion ? root : null
                    property: movementAnimation.rotateInMotion ? "angle" : ""
                    duration: movementAnimation.rotateInMotion
                              ? movementAnimation.rotationDuration
                              : 0
                    to: movementAnimation.rotationDirection
                    direction: RotationAnimation.Shortest
                }

                CoordinateAnimation {
                    target: root
                    property: "location"
                    duration: movementAnimation.coordinateDuration
                    to: movementAnimation.targetCoordinate
                }
            }
        }

        onStopped: setNextAnimation()
    }
}
