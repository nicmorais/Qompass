
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
import QtQuick.Controls.Material

ApplicationWindow {
    width: Screen.width
    height: Screen.height
    visible: true
    color: Theme.background
//    property real lastAzimuth

    Compass {
        id: compass
    }
    Timer {
        id: timer
        interval: 200
        triggeredOnStart: true
        repeat: true
        onTriggered: {
            let azimuth = compass.reading.azimuth
            //trick below prevents the number animation on
            //rotation from doing a great turn when degrees
            //change between positive and negative values
            if(Math.sign(degreesIndicator.rotation) !== Math.sign(azimuth)) {
                rotationSmoother.enabled = false
            } else {
                rotationSmoother.enabled = true
            }
            degreesIndicator.rotation = azimuth
            degreesText.text = Math.round(azimuth) + "°"
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
        source: Theme.isDark ? "qrc:/images/degrees_indicator_dark_theme.svg" : "qrc:/images/degrees_indicator.svg"
        Behavior on rotation {
            id: rotationSmoother
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
        source: "qrc:/images/north_indicator.svg"
    }

    Text {
        id: degreesText
        text: "Loading"
        color: Theme.foreground
        anchors.top: northIndicator.bottom
        anchors.horizontalCenter: northIndicator.horizontalCenter
    }

    Button {
        background: Rectangle {
            anchors.fill: parent
            color: Theme.background
            border.width: 1
            border.color: Theme.foreground
            radius: width / 10
        }

        contentItem: Text {
            text: "About"
            color: Theme.foreground
        }

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 5
        anchors.bottomMargin: 5
        onPressed: aboutPopup.open()
    }

    Popup {
        id: aboutPopup
        height: parent.height * 0.8
        width: parent.width * 0.8
        anchors.centerIn: parent
        dim: true
        background: Rectangle {
            color: Theme.background
            anchors.fill: parent
        }
        Column {
            width: parent.width
            Text {
                width: parent.width
                text: "Author: Nicolas Morais"
                color: Theme.foreground
                font.pixelSize: 15
                font.bold: true
            }
            Text {
                width: parent.width
                color: Theme.foreground
                wrapMode: Text.WordWrap
                text: "Source code available at https://github.com/nicmorais/qompass"
            }
            Row {
                Text {
                    text: "Dark Theme:"
                    color: Theme.foreground
                }
                Switch {
                    checked: Theme.isDark
                    onClicked: Theme.toggleDarkTheme()
                }
            }
        }

        Text {
            text: "Version: " + Qt.application.version
            color: Theme.foreground
            anchors.left: parent.left
            anchors.bottom: parent.bottom
        }
    }
    Text {
        id: calibrationLevel
        text: "Calibration level"
        color: Theme.foreground
        font.pointSize: 10
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
    }
}
