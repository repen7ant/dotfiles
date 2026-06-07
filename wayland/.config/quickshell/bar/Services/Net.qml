pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property string type: "disconnected"
  property string name: ""

  function _read() { status.running = true }

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

  Process {
    id: monitor
    command: ["nmcli", "monitor"]
    running: true
    onRunningChanged: if (!running) running = true
    stdout: SplitParser { onRead: line => root._read() }
  }
}
