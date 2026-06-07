import qs.Commons
import qs.Widgets
import qs.Services

Pill {
  icon: Net.type === "wifi"     ? "wifi"
      : Net.type === "ethernet" ? "ethernet"
      :                           "wifi-off"
  label: Net.type === "disconnected" ? "off" : Net.name
  textColor: Net.type === "disconnected" ? Theme.fgDim : Theme.fg
}
