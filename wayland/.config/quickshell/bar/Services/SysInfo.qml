pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property int cpu: 0   // percent
  property int mem: 0   // percent
  property var _prev: null   // {total, idle}

  function _tick() { statFile.reload(); memFile.reload() }

  FileView {
    id: statFile
    path: "/proc/stat"
    onLoaded: {
      var first = statFile.text().split("\n")[0]             // "cpu  u n s idle iowait ..."
      var v = first.trim().split(/\s+/).slice(1).map(Number) // drop the "cpu" label
      var idle = v[3] + (v[4] || 0)
      var total = v.reduce((a, b) => a + b, 0)
      if (root._prev) {
        var dt = total - root._prev.total
        var di = idle - root._prev.idle
        if (dt > 0) root.cpu = Math.round((1 - di / dt) * 100)
      }
      root._prev = { total: total, idle: idle }
    }
  }

  FileView {
    id: memFile
    path: "/proc/meminfo"
    onLoaded: {
      var t = 0, a = 0
      var lines = memFile.text().split("\n")
      for (var i = 0; i < lines.length; i++) {
        if (lines[i].startsWith("MemTotal:"))          t = parseInt(lines[i].replace(/\D+/g, ""))
        else if (lines[i].startsWith("MemAvailable:")) a = parseInt(lines[i].replace(/\D+/g, ""))
      }
      if (t > 0) root.mem = Math.round((1 - a / t) * 100)
    }
  }

  Timer { interval: 2000; running: true; repeat: true; onTriggered: root._tick() }
}
