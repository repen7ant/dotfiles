import qs.Commons
import qs.Services

Stat {
  icon: Net.type === "wifi"     ? String.fromCodePoint(0xF05A9)   // md-wifi
      : Net.type === "ethernet" ? String.fromCodePoint(0xF0319)   // md-lan
      :                           String.fromCodePoint(0xF05AA)   // md-wifi-off
  label: Net.type === "disconnected" ? "off" : Net.name
  textColor: Net.type === "disconnected" ? Theme.fgDim : Theme.fg
}
