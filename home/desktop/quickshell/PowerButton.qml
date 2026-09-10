import Quickshell
import QtQuick

Item {
    id: root

    property string label: ""
    property string glyph: ""
    signal triggered()

    width: 84
    height: 84

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: Theme.radius
        color: mouse.containsMouse ? Theme.surfaceHover : Qt.alpha(Theme.background, 0.5)
        border.width: 1
        border.color: mouse.containsMouse ? Theme.accent : Theme.border
        Behavior on border.color {
            ColorAnimation {
                duration: 120
            }
        }
        Behavior on color {
            ColorAnimation {
                duration: 120
            }
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.triggered()
    }

    Column {
        anchors.centerIn: parent
        spacing: 8

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.glyph
            font.family: "FiraCode Nerd Font"
            font.pixelSize: 28
            color: mouse.containsMouse ? Theme.accent : Theme.text
            Behavior on color {
                ColorAnimation {
                    duration: 120
                }
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.label
            color: Theme.text
            font.pixelSize: 13
        }
    }
}
