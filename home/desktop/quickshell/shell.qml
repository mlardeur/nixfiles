import Quickshell
import Quickshell.Io

Scope {
    id: root

    Variants {
        id: bars
        model: Quickshell.screens
        Bar { }
    }

    Variants {
        id: launchers
        model: Quickshell.screens
        Launcher { }
    }

    Variants {
        id: powermenus
        model: Quickshell.screens
        PowerMenu { }
    }

    Variants {
        id: calendars
        model: Quickshell.screens
        Calendar { }
    }

    function hideAll(variants) {
        var insts = variants.instances;
        for (var i = 0; i < insts.length; i++) {
            insts[i].visible = false;
        }
    }

    function togglePrimary(variants) {
        var insts = variants.instances;
        var primary = insts.length > 0 ? insts[0] : null;
        var wasVisible = primary !== null && primary.visible;
        root.hideAll(launchers);
        root.hideAll(powermenus);
        root.hideAll(calendars);
        if (primary !== null && !wasVisible) {
            primary.toggle();
        }
    }

    IpcHandler {
        target: "shell"
        function reload(): void {
            Quickshell.reload(true);
        }
    }

    IpcHandler {
        target: "launcher"
        function toggle(): void {
            root.togglePrimary(launchers);
        }
    }

    IpcHandler {
        target: "powermenu"
        function toggle(): void {
            root.togglePrimary(powermenus);
        }
    }

    IpcHandler {
        target: "calendar"
        function toggle(): void {
            root.togglePrimary(calendars);
        }
    }
}
