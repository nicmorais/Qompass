
/*
 * Copyright (C) 2023 Nicolas Morais
 * This program is free software; you can redistribute
 * it and/or modify it under the terms of the GNU
 * General Public License as published by the Free
 * Software Foundation; either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it
 * will be useful, but WITHOUT ANY WARRANTY;
 * without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.

 * You should have received a copy of the GNU General
 * Public License along with this program; if not, see
 * <https://www.gnu.org/licenses>.
 */
import QtQuick
import QtQuick.Window
import QtSensors
import QtQuick.Controls

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    Compass {
        id: compass
    }
    Timer {
        id: timer
        interval: 200
        triggeredOnStart: true
        repeat: true
        onTriggered: {
            degreesIndicator.rotation = Math.abs(compass.reading.azimuth)
            degreesText.text = Math.round(Math.abs(
                                              compass.reading.azimuth)) + "°"
            calibrationLevel.text = "Calibration Level: " + Math.floor(
                        compass.reading.calibrationLevel * 100) + " %"
        }
    }

    Component.onCompleted: {
        compass.start()
        timer.start()
    }

    Image {
        id: degreesIndicator
        anchors.centerIn: parent
        height: Math.max(parent.width, parent.height) / 2
        width: height
        source: "qrc:/images/degrees_indicator.png"
        Behavior on rotation {
            NumberAnimation {
                duration: 200
            }
        }
    }

    Image {
        id: northIndicator
        height: 50
        width: 50
        anchors.centerIn: degreesIndicator
        source: "qrc:/images/north_indicator.png"
    }

    Text {
        id: degreesText
        text: "Loading"
        anchors.top: northIndicator.bottom
        anchors.horizontalCenter: northIndicator.horizontalCenter
    }

    Button {
        text: "about"
        onPressed: aboutPopup.open()
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 5
        anchors.bottomMargin: 5
    }

    Popup {
        id: aboutPopup
        height: parent.height * 0.8
        width: parent.width * 0.8
        anchors.centerIn: parent
        dim: true
        background: Rectangle {
            color: "white"
            anchors.fill: parent
        }
        Column {
            width: parent.width
            Text {
                width: parent.width
                text: "Author: Nicolas Morais"
                font.pixelSize: 15
                font.bold: true
            }
            Text {
                width: parent.width
                wrapMode: Text.WordWrap
                text: "Source code available at https://github.com/nicmorais/qompass"
            }
        }
        Text {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            text: "Version: " + Qt.application.version
        }
    }
    Text {
        id: calibrationLevel
        text: "Calibration level"
        font.pointSize: 10
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
    }
}
