pragma Singleton

import QtQuick
import Quickshell

Singleton {
  id: root

  readonly property string fontFamily: loader.name

  readonly property var icons: ({
    "brightness-low":  "\u{fb23}",
    "brightness-high": "\u{fb24}",
    "sun-off":         "\u{ed63}",
    "volume":     "\u{eb51}",
    "volume-2":   "\u{eb4f}",
    "volume-off": "\u{f1c3}",
    "wifi":         "\u{eb52}",
    "wifi-off":     "\u{ecfa}",
    "ethernet":     "\u{eccc}",
    "battery-1":          "\u{ea2f}",
    "battery-2":          "\u{ea30}",
    "battery-3":          "\u{ea31}",
    "battery-4":          "\u{ea32}",
    "battery-charging":   "\u{ea33}",
    "battery-exclamation":"\u{ff1d}",
    "cpu-usage":        "\u{fa77}",
    "cpu-temperature":  "\u{ec2c}",
    "memory":           "\u{ef8e}",
    "storage":          "\u{ea88}",
    "music":                     "\u{eafc}",
    "player-play-filled":        "\u{f691}",
    "player-pause-filled":       "\u{f690}",
    "player-skip-back-filled":   "\u{f693}",
    "player-skip-forward-filled":"\u{f694}",
    "power": "\u{eb0d}",
    "lock":  "\u{eae2}",
    "moon":     "\u{eaf8}",
    "moon-off": "\u{f162}",
    "leaf":   "\u{ed4f}",
    "scale":  "\u{ebc2}",
    "rocket": "\u{ec45}",
    "check":  "\u{ea5e}"
  })

  function get(name) {
    return root.icons[name] !== undefined ? root.icons[name] : ""
  }

  FontLoader {
    id: loader
    source: Quickshell.shellDir + "/Assets/Fonts/tabler/tabler-icons.ttf"
  }
}
