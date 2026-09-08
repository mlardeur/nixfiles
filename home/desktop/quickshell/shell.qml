import Quickshell
import Quickshell.Io

Scope {
    Launcher { id: launcher }
    PowerMenu { id: powermenu }

    IpcHandler {
        target: "launcher"
        function toggle(): void {
            powermenu.visible = false;
            launcher.toggle();
        }
    }

    IpcHandler {
        target: "powermenu"
        function toggle(): void {
            launcher.visible = false;
            powermenu.toggle();
        }
    }
}
