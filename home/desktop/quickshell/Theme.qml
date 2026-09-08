pragma Singleton

import Quickshell
import QtQuick

Singleton {
    // Base16 "Tokyo Night Terminal Dark" palette (mirrors colors.txt / colors.css)
    readonly property color base00: "#16161e"
    readonly property color base01: "#1a1b26"
    readonly property color base02: "#2f3549"
    readonly property color base03: "#444b6a"
    readonly property color base04: "#787c99"
    readonly property color base05: "#787c99"
    readonly property color base06: "#cbccd1"
    readonly property color base07: "#d5d6db"
    readonly property color base08: "#f7768e"
    readonly property color base09: "#ff9e64"
    readonly property color base0a: "#e0af68"
    readonly property color base0b: "#41a6b5"
    readonly property color base0c: "#7dcfff"
    readonly property color base0d: "#7aa2f7"
    readonly property color base0e: "#bb9af7"
    readonly property color base0f: "#d18616"

    // Semantic aliases used by the widgets
    readonly property color background: base00
    readonly property color surface: base01
    readonly property color surfaceHover: base02
    readonly property color border: base03
    readonly property color text: base07
    readonly property color textMuted: base04
    readonly property color accent: base0e

    // Shared styling
    readonly property int radius: 12
}
