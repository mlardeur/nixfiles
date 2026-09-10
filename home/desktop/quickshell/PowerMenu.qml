import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: root

    property var modelData
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    aboveWindows: true
    exclusiveZone: 0
    focusable: true
    visible: false
    color: Qt.alpha("#000000", 0.5)

    function toggle() {
        if (visible) {
            close();
        } else {
            visible = true;
            panel.forceActiveFocus();
        }
    }

    function close() {
        visible = false;
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.close()
    }

    Rectangle {
        id: panel
        anchors.centerIn: parent
        width: Math.min(720, parent.width - 2 * Theme.radius)
        height: 130
        radius: Theme.radius
        color: Qt.alpha(Theme.surface, 0.75)
        border.width: 1
        border.color: Qt.alpha(Theme.border, 0.9)

        focus: true
        Keys.onEscapePressed: root.close()

        MouseArea {
            anchors.fill: parent
        }

        Rectangle {
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: Theme.radius
            }
            height: 1
            color: Qt.alpha(Theme.text, 0.08)
        }

        RowLayout {
            anchors.centerIn: parent
            spacing: 16

            PowerButton {
                label: "Lock"
                glyph: "\uF023"
                onTriggered: {
                    root.close();
                    Quickshell.execDetached({ command: ["loginctl", "lock-session"] });
                }
            }

            PowerButton {
                label: "Suspend"
                glyph: "\uF186"
                onTriggered: {
                    root.close();
                    Quickshell.execDetached({ command: ["systemctl", "suspend"] });
                }
            }

            PowerButton {
                label: "Hibernate"
                glyph: "\uF1DC"
                onTriggered: {
                    root.close();
                    Quickshell.execDetached({ command: ["systemctl", "hibernate"] });
                }
            }

            PowerButton {
                label: "Reboot"
                glyph: "\uF021"
                onTriggered: {
                    root.close();
                    Quickshell.execDetached({ command: ["systemctl", "reboot"] });
                }
            }

            PowerButton {
                label: "Shutdown"
                glyph: "\uF011"
                onTriggered: {
                    root.close();
                    Quickshell.execDetached({ command: ["systemctl", "poweroff"] });
                }
            }

            PowerButton {
                label: "Logout"
                glyph: "\uF08B"
                onTriggered: {
                    root.close();
                    Quickshell.execDetached({
                        command: ["loginctl", "terminate-session", Quickshell.env("XDG_SESSION_ID")]
                    });
                }
            }
        }
    }
}
