import Quickshell.Services.UPower
import qs.Commons

Stat {
  readonly property var dev: UPower.displayDevice
  readonly property int pct: dev && dev.isLaptopBattery ? Math.round(dev.percentage * 100) : -1
  readonly property bool charging: dev && (dev.state === UPowerDeviceState.Charging
                                        || dev.state === UPowerDeviceState.FullyCharged)

  visible: pct >= 0
  icon: charging ? String.fromCodePoint(0xF0084)   // md-battery-charging
                 : String.fromCodePoint(0xF0079)   // md-battery
  label: pct + "%"
  textColor: (!charging && pct <= 15) ? Theme.error : Theme.fg
}
