pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import qs.Commons

Singleton {
  id: root

  property int cpu: 0
  property int mem: 0
  property var _prev: null

  property real cpuFreq: 0
  property int  cpuTemp: 0
  property int  disk: 0
  property real diskUsedGb: 0
  property real diskTotalGb: 0
  property string _tempPath: ""

  readonly property int warnPct: 80
  readonly property int critPct: 90
  readonly property int warnTemp: 75
  readonly property int critTemp: 90

  function _pctColor(v) { return v >= critPct ? Theme.crit : v >= warnPct ? Theme.warn : Theme.primary }
  readonly property color cpuColor:  _pctColor(cpu)
  readonly property color memColor:  _pctColor(mem)
  readonly property color diskColor: _pctColor(disk)
  readonly property color tempColor: cpuTemp >= critTemp ? Theme.crit : cpuTemp >= warnTemp ? Theme.warn : Theme.primary

  function _tick() {
    statFile.reload(); memFile.reload()
    if (root._tempPath) tempFile.reload()
    freqFile.reload()
  }

  FileView {
    id: statFile
    path: "/proc/stat"
    onLoaded: {
      var first = statFile.text().split("\n")[0]
      var v = first.trim().split(/\s+/).slice(1).map(Number)
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

  Process {
    running: true
    command: ["sh", "-c",
      "for d in /sys/class/hwmon/hwmon*; do " +
      "  [ \"$(cat $d/name 2>/dev/null)\" = coretemp ] || continue; " +
      "  for l in $d/temp*_label; do " +
      "    [ \"$(cat $l 2>/dev/null)\" = 'Package id 0' ] && { echo \"${l%_label}_input\"; exit 0; }; " +
      "  done; " +
      "done; " +
      "for z in /sys/class/thermal/thermal_zone*; do " +
      "  [ \"$(cat $z/type 2>/dev/null)\" = x86_pkg_temp ] && { echo \"$z/temp\"; exit 0; }; " +
      "done"]
    stdout: StdioCollector {
      onStreamFinished: { root._tempPath = text.trim(); tempFile.reload() }
    }
  }

  FileView {
    id: tempFile
    path: root._tempPath
    onLoaded: { var n = parseInt(tempFile.text()); if (!isNaN(n)) root.cpuTemp = Math.round(n / 1000) }
  }

  FileView {
    id: freqFile
    path: "/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq"
    onLoaded: { var n = parseInt(freqFile.text()); if (!isNaN(n)) root.cpuFreq = n / 1000000 }
  }

  Process {
    id: dfProc
    command: ["df", "-P", "-k", "/"]
    stdout: StdioCollector {
      onStreamFinished: {
        var lines = text.trim().split("\n")
        if (lines.length < 2) return
        var f = lines[lines.length - 1].trim().split(/\s+/)
        var totalK = parseInt(f[1]), usedK = parseInt(f[2])
        if (totalK > 0) {
          root.disk = Math.round(usedK / totalK * 100)
          root.diskUsedGb = usedK / 1048576
          root.diskTotalGb = totalK / 1048576
        }
      }
    }
  }
  Timer { interval: 30000; running: true; repeat: true; triggeredOnStart: true; onTriggered: dfProc.running = true }

  Timer { interval: 2000; running: true; repeat: true; onTriggered: root._tick() }
}
