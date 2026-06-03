pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property string type: "disconnected"   // "wifi" | "ethernet" | "disconnected"
  property string name: ""

  function _read() { status.running = true }

  // one-shot status read; parses the first physically-connected device
  Process {
    id: status
    command: ["nmcli", "-t", "-f", "TYPE,STATE,CONNECTION", "device", "status"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: {
        var found = false
        var lines = text.trim().split("\n")
        for (var i = 0; i < lines.length; i++) {
          var p = lines[i].split(":")
          if ((p[0] === "wifi" || p[0] === "ethernet") && p[1] === "connected") {
            root.type = p[0]; root.name = p[2] || ""; found = true; break
          }
        }
        if (!found) { root.type = "disconnected"; root.name = "" }
      }
    }
  }

  // long-running monitor: any line means NM state changed → re-read
  Process {
    id: monitor
    command: ["nmcli", "monitor"]
    running: true
    onRunningChanged: if (!running) running = true
    stdout: SplitParser { onRead: line => root._read() }
  }
}
