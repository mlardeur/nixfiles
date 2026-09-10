import Quickshell
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
    color: "transparent"

    readonly property real barHeight: 30
    property date now: new Date()
    property int viewYear: now.getFullYear()
    property int viewMonth: now.getMonth()
    property var selectedDate: null
    readonly property int firstDayOfWeek: 1
    readonly property var monthNames: [
        "janvier", "février", "mars", "avril", "mai", "juin",
        "juillet", "août", "septembre", "octobre", "novembre", "décembre"
    ]
    readonly property var dayNames: [
        "dimanche", "lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi"
    ]
    readonly property var narrowDayNames: ["D", "L", "M", "M", "J", "V", "S"]

    function longDate(d) {
        var s = dayNames[d.getDay()] + " " + d.getDate() + " "
            + monthNames[d.getMonth()] + " " + d.getFullYear()
        return s.charAt(0).toUpperCase() + s.slice(1)
    }

    function isToday(y, m, d) {
        return now.getFullYear() === y && now.getMonth() === m && now.getDate() === d
    }

    function prevMonth() {
        var dt = new Date(viewYear, viewMonth - 1, 1)
        viewYear = dt.getFullYear()
        viewMonth = dt.getMonth()
    }

    function nextMonth() {
        var dt = new Date(viewYear, viewMonth + 1, 1)
        viewYear = dt.getFullYear()
        viewMonth = dt.getMonth()
    }

    function resetToToday() {
        viewYear = now.getFullYear()
        viewMonth = now.getMonth()
        selectedDate = null
    }

    function toggle() {
        if (visible) {
            close()
        } else {
            now = new Date()
            resetToToday()
            visible = true
            card.forceActiveFocus()
        }
    }

    function close() {
        visible = false
    }

    readonly property var daysModel: {
        var first = new Date(viewYear, viewMonth, 1)
        var daysInMonth = new Date(viewYear, viewMonth + 1, 0).getDate()
        var daysBefore = (first.getDay() - firstDayOfWeek + 7) % 7
        var total = Math.ceil((daysBefore + daysInMonth) / 7) * 7
        var days = []
        for (var i = 0; i < total; i++) {
            var d = new Date(viewYear, viewMonth, i - daysBefore + 1)
            days.push({
                "day": d.getDate(),
                "month": d.getMonth(),
                "year": d.getFullYear(),
                "inMonth": d.getMonth() === viewMonth
            })
        }
        return days
    }

    Timer {
        interval: 1000
        running: root.visible
        repeat: true
        onTriggered: root.now = new Date()
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.close()
    }

    Rectangle {
        id: card
        anchors {
            top: parent.top
            topMargin: root.barHeight
            horizontalCenter: parent.horizontalCenter
        }
        width: 340
        height: content.implicitHeight + 32
        radius: Theme.radius
        color: Qt.alpha(Theme.surface, 0.95)
        border.width: 1
        border.color: Qt.alpha(Theme.border, 0.9)

        focus: true
        Keys.onEscapePressed: root.close()

        MouseArea {
            anchors.fill: parent
        }

        WheelHandler {
            onWheel: function (event) {
                if (event.angleDelta.y > 0)
                    root.prevMonth()
                else if (event.angleDelta.y < 0)
                    root.nextMonth()
                event.accepted = true
            }
        }

        ColumnLayout {
            id: content
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 16
            }
            spacing: 12

            Column {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    text: Qt.formatTime(root.now, "HH:mm")
                    color: Theme.text
                    font.pixelSize: 34
                    font.weight: Font.Bold
                }

                Text {
                    text: root.longDate(root.now)
                    color: Theme.textMuted
                    font.pixelSize: 13
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 6

                Text {
                    Layout.fillWidth: true
                    text: (root.monthNames[root.viewMonth] + " " + root.viewYear).toUpperCase()
                    color: Theme.text
                    font.pixelSize: 14
                    font.weight: Font.Bold
                }

                Repeater {
                    model: 3
                    delegate: Rectangle {
                        required property int index
                        width: 26
                        height: 26
                        radius: 6
                        color: navMouse.containsMouse ? Theme.surfaceHover : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: parent.index === 0 ? "\uF053" : parent.index === 1 ? "\uF073" : "\uF054"
                            font.family: "FiraCode Nerd Font"
                            font.pixelSize: 13
                            color: Theme.textMuted
                        }

                        MouseArea {
                            id: navMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (index === 0)
                                    root.prevMonth()
                                else if (index === 1)
                                    root.resetToToday()
                                else
                                    root.nextMonth()
                            }
                        }
                    }
                }
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 7
                columnSpacing: 4
                rowSpacing: 4

                Repeater {
                    model: 7
                    delegate: Item {
                        required property int index
                        implicitWidth: 36
                        implicitHeight: 16

                        Text {
                            anchors.centerIn: parent
                            text: root.narrowDayNames[(root.firstDayOfWeek + index) % 7]
                            color: Theme.textMuted
                            font.pixelSize: 11
                            font.weight: Font.Bold
                        }
                    }
                }

                Repeater {
                    model: root.daysModel
                    delegate: Rectangle {
                        required property var modelData
                        implicitWidth: 36
                        implicitHeight: 30
                        radius: 6

                        readonly property bool isToday: root.isToday(modelData.year, modelData.month, modelData.day)
                        readonly property bool isSelected: root.selectedDate !== null
                            && root.selectedDate.getFullYear() === modelData.year
                            && root.selectedDate.getMonth() === modelData.month
                            && root.selectedDate.getDate() === modelData.day

                        color: isToday ? Theme.accent
                            : dayMouse.containsMouse ? Theme.surfaceHover : "transparent"
                        border.width: isSelected ? 1 : 0
                        border.color: Theme.accent

                        Text {
                            anchors.centerIn: parent
                            text: parent.modelData.day
                            color: parent.isToday ? Theme.base00 : Theme.text
                            opacity: parent.modelData.inMonth ? 1.0 : 0.4
                            font.pixelSize: 12
                            font.weight: parent.isToday ? Font.Bold : Font.Normal
                        }

                        MouseArea {
                            id: dayMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.selectedDate = new Date(modelData.year, modelData.month, modelData.day)
                        }
                    }
                }
            }

            Text {
                visible: root.selectedDate !== null
                Layout.fillWidth: true
                Layout.topMargin: -4
                text: root.selectedDate === null ? "" : root.longDate(root.selectedDate)
                color: Theme.textMuted
                font.pixelSize: 12
            }
        }
    }
}
