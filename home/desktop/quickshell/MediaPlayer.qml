import QtQuick
import Quickshell.Services.Mpris

Item {
    id: root

    property var player: Mpris.players.values.find(p => p.isPlaying)
        ?? (Mpris.players.values.length > 0 ? Mpris.players.values[0] : null)

    visible: root.player !== null
    height: 16
    width: Math.min(mediaRow.width, 260)

    readonly property string artist: root.player && root.player.trackArtist
        ? root.player.trackArtist
        : "Unknown Artist"
    readonly property string title: root.player && root.player.trackTitle
        ? root.player.trackTitle
        : "Unknown Title"

    Row {
        id: mediaRow
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6

        Item {
            id: artBox
            width: 16
            height: 16
            anchors.verticalCenter: parent.verticalCenter

            Image {
                id: artImage
                anchors.fill: parent
                source: root.player ? root.player.trackArtUrl : ""
                sourceSize.width: 32
                sourceSize.height: 32
                asynchronous: true
                fillMode: Image.PreserveAspectCrop
                visible: status === Image.Ready
            }

            Text {
                anchors.centerIn: parent
                text: "\uFA9D"
                font.family: "FiraCode Nerd Font"
                font.pixelSize: 13
                color: Theme.textMuted
                visible: !artImage.visible
            }
        }

        Text {
            id: stateGlyph
            anchors.verticalCenter: parent.verticalCenter
            text: root.player && root.player.isPlaying ? "\uF04C" : "\uF04B"
            font.family: "FiraCode Nerd Font"
            font.pixelSize: 13
            color: root.player && root.player.isPlaying ? Theme.text : Theme.textMuted
        }

        Text {
            id: trackText
            anchors.verticalCenter: parent.verticalCenter
            text: root.artist + " \u2014 " + root.title
            width: implicitWidth > 220 ? 220 : implicitWidth
            elide: Text.ElideRight
            font.family: "FiraCode Nerd Font"
            font.pixelSize: 13
            color: root.player && root.player.isPlaying ? Theme.text : Theme.textMuted
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (root.player && root.player.canTogglePlaying)
                root.player.togglePlaying()
        }
        onWheel: wheel => {
            if (!root.player) return
            if (wheel.angleDelta.y > 0) {
                if (root.player.canGoNext) root.player.next()
            } else if (wheel.angleDelta.y < 0) {
                if (root.player.canGoPrevious) root.player.previous()
            }
        }
    }
}
