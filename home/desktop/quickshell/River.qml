pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// River tag state, fed by the river-status daemon (see river-status/).
// river-status prints one TSV line per output per change:
//   <output-name>\t<focused>\t<view>\t<urgent>
// where the three masks are 32-bit tag bitfields (tag N = bit N-1).
// Dispatch to river is done via riverctl (which acts on the focused output).
Singleton {
    id: root

    property var outputs: ({})
    property int revision: 0

    function _parse(line) {
        var parts = line.split("\t")
        if (parts.length < 4) return

        var name = parts[0]
        var focused = parseInt(parts[1]) || 0
        var view = parseInt(parts[2]) || 0
        var urgent = parseInt(parts[3]) || 0

        var rec = root.outputs[name]
        if (!rec) {
            rec = Qt.createQmlObject(
                "import QtQuick; \
                QtObject { \
                    property string name; \
                    property int focused; \
                    property int view; \
                    property int urgent; \
                }",
                root,
                "riverOutput"
            )
            rec.name = name
            root.outputs[name] = rec
        }

        if (rec.focused !== focused) rec.focused = focused
        if (rec.view !== view) rec.view = view
        if (rec.urgent !== urgent) rec.urgent = urgent

        root.revision++
    }

    // The output record for a QML screen, matched by wl_output name.
    // Falls back to the single record on a single-monitor setup.
    function outputForScreen(screen) {
        // Establish a dependency on `revision` so callers re-evaluate whenever
        // any output state changes (the JS objects in `outputs` are not
        // themselves observable through the `var outputs` property).
        if (root.revision < 0) return null

        var name = screen ? screen.name : ""
        if (root.outputs[name]) return root.outputs[name]

        var keys = Object.keys(root.outputs)
        if (keys.length === 1) return root.outputs[keys[0]]
        return null
    }

    function focusedForScreen(screen) {
        var rec = outputForScreen(screen)
        return rec ? rec.focused : 0
    }

    function viewedForScreen(screen) {
        var rec = outputForScreen(screen)
        return rec ? rec.view : 0
    }

    function urgentForScreen(screen) {
        var rec = outputForScreen(screen)
        return rec ? rec.urgent : 0
    }

    function isTagActive(screen, tag) {
        return (focusedForScreen(screen) & (1 << (tag - 1))) !== 0
    }

    function isTagOccupied(screen, tag) {
        return (viewedForScreen(screen) & (1 << (tag - 1))) !== 0
    }

    function isTagUrgent(screen, tag) {
        return (urgentForScreen(screen) & (1 << (tag - 1))) !== 0
    }

    function setFocusedTag(screen, tag) {
        var mask = 1 << (tag - 1)
        dispatchProc.exec(["riverctl", "set-focused-tags", String(mask)])
    }

    function toggleTag(screen, tag) {
        var mask = 1 << (tag - 1)
        dispatchProc.exec(["riverctl", "toggle-focused-tags", String(mask)])
    }

    Process {
        id: dispatchProc
    }

    // Tail the daemon. It stays alive for the life of the shell and prints on
    // events, so no polling is needed.
    Process {
        id: statusProc
        command: ["river-status"]
        running: true

        stdout: SplitParser {
            onRead: data => root._parse(data)
        }

        onExited: code => restartTimer.restart()
    }

    Timer {
        id: restartTimer
        interval: 1000
        onTriggered: statusProc.running = true
    }
}
