import qs.Commons
import qs.Widgets
import qs.Services

Pill {
  icon: Net.type === "wifi"     ? "wifi"
      : Net.type === "ethernet" ? "ethernet"
      :                           "wifi-off"
  label: Net.type === "disconnected" ? "off" : Net.name
  // Bar gives this a width budget; the fallback keeps a stray long SSID
  // from blowing up the pill if the widget is used outside the bar.
  labelMaxWidth: 180
  tooltipText: Net.type === "disconnected" ? "" : Net.name
  textColor: Net.type === "disconnected" ? Theme.fgDim : Theme.fg
}
