pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  readonly property var profiles: ["power-saver", "balanced", "performance"]
  property string current: ""

  function setProfile(p) {
    Quickshell.execDetached(["powerprofilesctl", "set", p])
    root.current = p
    refresh.restart()
  }

  function iconFor(p) {
    return p === "power-saver" ? "leaf"
         : p === "performance" ? "rocket"
         :                       "scale"
  }

  function labelFor(p) {
    return p === "power-saver" ? "Power Saver"
         : p === "performance" ? "Performance"
         :                       "Balanced"
  }

  Process {
    id: getProc
    command: ["powerprofilesctl", "get"]
    running: true
    stdout: StdioCollector { onStreamFinished: root.current = text.trim() }
  }

  Timer { id: refresh; interval: 400; onTriggered: getProc.running = true }
  Timer { interval: 8000; running: true; repeat: true; onTriggered: getProc.running = true }
}
