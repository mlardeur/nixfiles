import Quickshell
import QtQuick

Item {
    id: root

    property string label: ""
    property string icon: ""
    signal triggered()

    width: 84
    height: 84

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: Theme.radius
        color: mouse.containsMouse ? Theme.surfaceHover : Theme.background
        border.width: 1
        border.color: Theme.border
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.triggered()
    }

    Column {
        anchors.centerIn: parent
        spacing: 8

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 32
            height: 32
            source: root.icon !== "" ? Quickshell.iconPath(root.icon, true) : ""
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.label
            color: Theme.text
            font.pixelSize: 13
        }
    }
}
