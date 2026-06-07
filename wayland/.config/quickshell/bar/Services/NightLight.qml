pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property bool active: false
  readonly property int temp: 4000

  function toggle() {
    if (root.active)
      Quickshell.execDetached(["pkill", "-x", "wlsunset"])
    else
      Quickshell.execDetached(["wlsunset", "-S", "23:59", "-s", "00:00", "-d", "1",
                               "-t", String(root.temp), "-T", "6500"])
    root.active = !root.active
    refresh.restart()
  }

  Process {
    id: checkProc
    command: ["pgrep", "-x", "wlsunset"]
    running: true
    stdout: StdioCollector { onStreamFinished: root.active = text.trim().length > 0 }
  }

  Timer { id: refresh; interval: 400; onTriggered: checkProc.running = true }
  Timer { interval: 8000; running: true; repeat: true; onTriggered: checkProc.running = true }
}
