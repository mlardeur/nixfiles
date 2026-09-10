import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

PanelWindow {
    id: root

    property var modelData
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: Math.max((screen.height - implicitHeight) / 2, 0)
        left: Math.max((screen.width - 800) / 2, Theme.radius)
        right: Math.max((screen.width - 800) / 2, Theme.radius)
    }

    aboveWindows: true
    exclusiveZone: 0
    focusable: true
    visible: false
    color: "transparent"
    implicitHeight: 420

    property var filteredApps: []

    function refreshFilter() {
        var q = search.text.toLowerCase();
        var res = [];
        var apps = DesktopEntries.applications.values;
        for (var i = 0; i < apps.length; i++) {
            if (apps[i].name.toLowerCase().indexOf(q) !== -1) {
                res.push(apps[i]);
            }
        }
        filteredApps = res;
        appList.currentIndex = res.length > 0 ? 0 : -1;
    }

    function moveSelection(delta) {
        var idx = appList.currentIndex + delta;
        if (idx < 0) {
            idx = 0;
        } else if (idx >= filteredApps.length) {
            idx = filteredApps.length - 1;
        }
        appList.currentIndex = idx;
        appList.positionViewAtIndex(idx, ListView.Contain);
    }

    function launchCurrent() {
        var idx = appList.currentIndex;
        if (idx >= 0 && idx < filteredApps.length) {
            filteredApps[idx].execute();
            root.visible = false;
        }
    }

    function toggle() {
        if (visible) {
            visible = false;
        } else {
            search.text = "";
            refreshFilter();
            search.forceActiveFocus();
            visible = true;
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius
        color: Theme.surface

        Keys.onEscapePressed: root.visible = false

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 8

            TextField {
                id: search
                Layout.fillWidth: true
                color: Theme.text
                font.pixelSize: 22
                focus: true
                leftPadding: 0
                background: null
                placeholderTextColor: Theme.textMuted
                placeholderText: "Search applications..."

                Keys.onDownPressed: root.moveSelection(1)
                Keys.onUpPressed: root.moveSelection(-1)
                Keys.onReturnPressed: root.launchCurrent()
                Keys.onEnterPressed: root.launchCurrent()

                onTextChanged: root.refreshFilter()
            }

            ListView {
                id: appList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 2
                model: root.filteredApps
                currentIndex: 0

                delegate: Item {
                    width: appList.width
                    height: 40

                    Rectangle {
                        anchors.fill: parent
                        radius: 6
                        color: (index === appList.currentIndex) || appMouse.containsMouse
                            ? Theme.surfaceHover
                            : "transparent"
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        spacing: 12

                        Image {
                            source: Quickshell.iconPath(modelData.icon, "application-x-executable")
                            sourceSize.width: 24
                            sourceSize.height: 24
                        }

                        Text {
                            Layout.fillWidth: true
                            text: modelData.name
                            color: Theme.text
                            font.pixelSize: 15
                            elide: Text.ElideRight
                        }
                    }

                    MouseArea {
                        id: appMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            appList.currentIndex = index;
                            root.launchCurrent();
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: refreshFilter()
}
