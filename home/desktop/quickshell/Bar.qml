import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: bar

    anchors {
        top: true
        left: true
        right: true
    }

    exclusiveZone: 30
    color: Qt.alpha(Theme.surface, 0.85)
    implicitHeight: 30

    // 9 river tags; labels mirror waybar's river/tags.tag-labels.
    readonly property var tagLabels: [
        "\uF120",
        "\uF268",
        "\uF13B",
        "\uE7B5",
        "\uF269",
        "\uE8DA",
        "7",
        "8",
        "\uDB80\uDF86"
    ]

    property string timeText: Qt.formatTime(new Date(), "HH:mm")

    property string volumeText: "--"
    property bool muted: false

    property string networkText: "Disconnected"
    property string networkGlyph: "\uF071"

    property string cpuText: "--"
    property string memText: "--"
    property string diskText: "--"

    function parseStats(line) {
        var parts = line.split(" ")
        if (parts.length < 2) return
        var val = parts[1] + "%"
        if (parts[0] === "cpu") bar.cpuText = val
        else if (parts[0] === "mem") bar.memText = val
        else if (parts[0] === "disk") bar.diskText = val
    }

    function parseVolume(line) {
        var match = line.match(/Volume:\s*([0-9.]+)/)
        if (match) {
            var pct = Math.round(parseFloat(match[1]) * 100)
            bar.volumeText = pct + "%"
        }
        bar.muted = line.indexOf("MUTED") !== -1
    }

    function parseNetwork(line) {
        var parts = line.split(":")
        if (parts.length < 3 || parts[1] !== "connected") return
        var type = parts[0]
        var conn = parts[2] ? parts[2] : type
        bar.networkText = conn
        bar.networkGlyph = type === "wifi" ? "\uF1EB" : "\uF796"
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: bar.timeText = Qt.formatTime(new Date(), "HH:mm")
    }

    Process {
        id: volumeProc
        stdout: SplitParser { onRead: d => bar.parseVolume(d) }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: volumeProc.exec(["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"])
    }

    Process {
        id: netProc
        stdout: SplitParser { onRead: d => bar.parseNetwork(d) }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            bar.networkText = "Disconnected"
            bar.networkGlyph = "\uF071"
            netProc.exec(["sh", "-c",
                "nmcli -t -f TYPE,STATE,CONNECTION device status | grep ':connected:' | head -1"])
        }
    }

    Process {
        id: statsProc
        stdout: SplitParser { onRead: d => bar.parseStats(d) }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: statsProc.exec(["sh", "-c",
            "cpu1=$(awk '/^cpu /{i=$5+$6;t=0;for(j=2;j<=NF;j++)t+=$j;print i,t}' /proc/stat); sleep 0.4; cpu2=$(awk '/^cpu /{i=$5+$6;t=0;for(j=2;j<=NF;j++)t+=$j;print i,t}' /proc/stat); set -- $cpu1 $cpu2; di=$(($3-$1)); dt=$(($4-$2)); if [ $dt -gt 0 ]; then c=$(( (100*(dt-di))/dt )); else c=0; fi; m=$(awk '/MemTotal/{t=$2}/MemAvailable/{a=$2}END{if(t>0)print int((100*(t-a))/t);else print 0}' /proc/meminfo); d=$(df -P / | awk 'NR==2{print substr($5,1,length($5)-1)}'); echo cpu $c; echo mem $m; echo disk $d"])
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 12

        Row {
            id: tagsRow
            spacing: 2
            Layout.alignment: Qt.AlignVCenter

            Repeater {
                model: 9
                delegate: Tag {
                    tagId: index + 1
                    label: bar.tagLabels[index]
                    screen: bar.screen
                    onClicked: River.setFocusedTag(bar.screen, tagId)
                }
            }
        }

        Item { Layout.fillWidth: true }

        Text {
            Layout.alignment: Qt.AlignVCenter
            text: bar.timeText
            color: Theme.text
            font.pixelSize: 14
        }

        Item { Layout.fillWidth: true }

        Row {
            id: rightRow
            spacing: 14
            Layout.alignment: Qt.AlignVCenter

            Item {
                width: statsRow.width
                height: 16

                Row {
                    id: statsRow
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "\uF2DB " + bar.cpuText
                        font.family: "FiraCode Nerd Font"
                        font.pixelSize: 13
                        color: Theme.text
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "\uF039 " + bar.memText
                        font.family: "FiraCode Nerd Font"
                        font.pixelSize: 13
                        color: Theme.text
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "\uF0A0 " + bar.diskText
                        font.family: "FiraCode Nerd Font"
                        font.pixelSize: 13
                        color: Theme.text
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Quickshell.execDetached({
                        command: ["kitty", "-e", "htop"]
                    })
                }
            }

            Item {
                width: volumeLabel.width
                height: 16

                Text {
                    id: volumeLabel
                    anchors.verticalCenter: parent.verticalCenter
                    text: (bar.muted ? "\uF026" : "\uF028") + " " + bar.volumeText
                    font.family: "FiraCode Nerd Font"
                    font.pixelSize: 13
                    color: Theme.text
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton)
                            Quickshell.execDetached({ command: ["pavucontrol"] })
                        else
                            Quickshell.execDetached({
                                command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
                            })
                    }
                }
            }

            Item {
                width: networkLabel.width
                height: 16

                Text {
                    id: networkLabel
                    anchors.verticalCenter: parent.verticalCenter
                    text: bar.networkGlyph + " " + bar.networkText
                    font.family: "FiraCode Nerd Font"
                    font.pixelSize: 13
                    color: Theme.text
                }
            }

            Repeater {
                model: SystemTray.items
                delegate: Image {
                    source: modelData.icon
                    width: 16
                    height: 16
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: mouse => {
                            if (mouse.button === Qt.LeftButton)
                                modelData.activate()
                            else
                                modelData.display(bar, mouse.x, mouse.y)
                        }
                    }
                }
            }

            Item {
                width: 16
                height: 16

                Text {
                    anchors.centerIn: parent
                    text: "\uF011"
                    font.family: "FiraCode Nerd Font"
                    font.pixelSize: 14
                    color: Theme.text
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Quickshell.execDetached({
                        command: ["quickshell", "ipc", "call", "powermenu", "toggle"]
                    })
                }
            }
        }
    }
}
