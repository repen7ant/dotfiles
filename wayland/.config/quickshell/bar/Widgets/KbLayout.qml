import QtQuick
import qs.Commons
import qs.Widgets
import qs.Services

Pill {
  id: kb

  readonly property var codes: ({
    "English": "EN",
    "Russian": "RU"
  })

  function shortCode(name) {
    if (!name) return ""
    var word = name.split(" ")[0]
    return codes[word] !== undefined ? codes[word] : word.slice(0, 2).toUpperCase()
  }

  visible: Niri.kbNames.length > 1
  label: shortCode(Niri.kbLayout)
  tooltipText: Niri.kbLayout

  onClicked: Niri.switchLayout()
}
