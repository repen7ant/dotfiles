pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property string device: ""
  property int current: 0
  property int max: 1
  readonly property int percent: max > 0 ? Math.round(current / max * 100) : 0

  // Set brightness via logind D-Bus (no root / video group / udev rule needed;
  // works because we are the active graphical session). Value is raw (0..max).
  function setRaw(raw) {
    if (!device) return
    var v = Math.max(1, Math.min(root.max, Math.round(raw)))
    Quickshell.execDetached(["busctl", "call", "org.freedesktop.login1",
      "/org/freedesktop/login1/session/auto",
      "org.freedesktop.login1.Session", "SetBrightness", "ssu",
      "backlight", root.device, String(v)])
    root.current = v   // optimistic update so the widget/OSD react instantly
  }
  function set(pct) { setRaw(pct / 100 * root.max) }
  function changeBy(deltaPct) { set(percent + deltaPct) }

  // detect device, then read max + current
  Process {
    id: detect
    command: ["sh", "-c", "ls -1 /sys/class/backlight | head -1"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: {
        root.device = text.trim()
        maxFile.reload()
        curFile.reload()
      }
    }
  }

  FileView {
    id: maxFile
    path: root.device ? "/sys/class/backlight/" + root.device + "/max_brightness" : ""
    onLoaded: { var n = parseInt(maxFile.text()); if (n > 0) root.max = n }
  }

  // sysfs has no inotify, so re-read current on a timer
  FileView {
    id: curFile
    path: root.device ? "/sys/class/backlight/" + root.device + "/brightness" : ""
    onLoaded: { var n = parseInt(curFile.text()); if (!isNaN(n)) root.current = n }
  }

  Timer {
    interval: 300; running: root.device !== ""; repeat: true
    onTriggered: curFile.reload()
  }

  // niri brightness keys call these (single code path through logind)
  IpcHandler {
    target: "brightness"
    function up(): void { root.changeBy(5) }
    function down(): void { root.changeBy(-5) }
  }
}
