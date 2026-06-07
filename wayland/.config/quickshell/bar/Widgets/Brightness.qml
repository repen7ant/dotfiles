import qs.Commons
import qs.Widgets
import qs.Services

Pill {
  // No backlight (desktop) → act as a pure night-light toggle.
  readonly property bool hasBacklight: Backlight.device !== ""

  icon: hasBacklight
      ? (Backlight.percent <= 1 ? "sun-off"
       : Backlight.percent <= 50 ? "brightness-low" : "brightness-high")
      : (NightLight.active ? "moon" : "moon-off")
  iconPixelSize: hasBacklight ? Theme.iconSize : Theme.fontSize + 1
  label: hasBacklight ? Backlight.percent + "%" : ""
  iconColor: NightLight.active ? Theme.primary : Theme.fg
  tooltipText: NightLight.active ? "Night light: on" : "Night light: off"
  onScrolled: dy => { if (hasBacklight) Backlight.changeBy(dy > 0 ? 5 : -5) }
  onClicked: NightLight.toggle()
}
