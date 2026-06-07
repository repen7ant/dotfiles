import Quickshell.Services.UPower
import qs.Commons
import qs.Widgets
import qs.Panels

Pill {
  id: bat
  readonly property var dev: UPower.displayDevice
  readonly property int pct: dev && dev.isLaptopBattery ? Math.round(dev.percentage * 100) : -1
  readonly property bool charging: dev && (dev.state === UPowerDeviceState.Charging
                                        || dev.state === UPowerDeviceState.FullyCharged)

  visible: pct >= 0
  icon: charging          ? "battery-charging"
      : pct <= 10         ? "battery-exclamation"
      : pct <= 30         ? "battery-1"
      : pct <= 60         ? "battery-2"
      : pct <= 85         ? "battery-3" : "battery-4"
  label: pct + "%"
  textColor: (!charging && pct <= 15) ? Theme.crit : Theme.fg
  iconColor: charging ? Theme.primary : ((!charging && pct <= 15) ? Theme.crit : Theme.fg)

  onClicked: profileMenu.toggle()

  BatteryPanel {
    id: profileMenu
    anchorItem: bat
  }
}
