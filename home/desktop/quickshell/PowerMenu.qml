import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: Math.max((screen.height - implicitHeight) / 2, 0)
        left: Math.max((screen.width - 720) / 2, Theme.radius)
        right: Math.max((screen.width - 720) / 2, Theme.radius)
    }

    aboveWindows: true
    exclusiveZone: 0
    focusable: true
    visible: false
    color: "transparent"
    implicitHeight: 130

    function toggle() {
        visible = !visible;
    }

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius
        color: Theme.surface

        focus: true
        Keys.onEscapePressed: root.visible = false

        RowLayout {
            anchors.centerIn: parent
            spacing: 16

            PowerButton {
                label: "Lock"
                icon: "system-lock-screen"
                onTriggered: Quickshell.execDetached({ command: ["loginctl", "lock-session"] })
            }

            PowerButton {
                label: "Suspend"
                icon: "system-suspend"
                onTriggered: Quickshell.execDetached({ command: ["systemctl", "suspend"] })
            }

            PowerButton {
                label: "Hibernate"
                icon: "system-suspend-hibernate"
                onTriggered: Quickshell.execDetached({ command: ["systemctl", "hibernate"] })
            }

            PowerButton {
                label: "Reboot"
                icon: "system-reboot"
                onTriggered: Quickshell.execDetached({ command: ["systemctl", "reboot"] })
            }

            PowerButton {
                label: "Shutdown"
                icon: "system-shutdown"
                onTriggered: Quickshell.execDetached({ command: ["systemctl", "poweroff"] })
            }

            PowerButton {
                label: "Logout"
                icon: "system-log-out"
                onTriggered: Quickshell.execDetached({
                    command: ["loginctl", "terminate-session", Quickshell.env("XDG_SESSION_ID")]
                })
            }
        }
    }
}
