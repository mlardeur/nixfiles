import Quickshell
import QtQuick

Item {
    id: root

    property int tagId: 1
    property string label: ""
    property var screen: null

    signal clicked()

    readonly property bool active: River.isTagActive(screen, tagId)
    readonly property bool occupied: River.isTagOccupied(screen, tagId)
    readonly property bool urgent: River.isTagUrgent(screen, tagId)

    width: 30
    height: 30

    Rectangle {
        id: pill
        anchors.fill: parent
        radius: Theme.radius
        color: root.active ? Theme.surfaceHover
             : root.urgent ? Qt.alpha(Theme.base08, 0.25)
             : "transparent"
        border.width: root.urgent ? 1 : 0
        border.color: Theme.base08
    }

    Text {
        anchors.centerIn: parent
        text: root.label
        font.family: "FiraCode Nerd Font"
        font.pixelSize: 16
        color: root.urgent ? Theme.base08
             : root.active ? Theme.text
             : root.occupied ? Theme.textMuted
             : Theme.base03
    }

    Rectangle {
        visible: root.occupied
        width: 4
        height: 4
        radius: 2
        color: root.active ? Theme.accent : Theme.textMuted
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 3
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
