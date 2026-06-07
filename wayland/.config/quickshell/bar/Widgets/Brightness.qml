import qs.Commons
import qs.Widgets
import qs.Services

Pill {
  icon: Backlight.percent <= 1 ? "sun-off"
      : Backlight.percent <= 50 ? "brightness-low" : "brightness-high"
  label: Backlight.percent + "%"
  iconColor: NightLight.active ? Theme.primary : Theme.fg
  tooltipText: NightLight.active ? "Night light: on" : "Night light: off"
  onScrolled: dy => Backlight.changeBy(dy > 0 ? 5 : -5)
  onClicked: NightLight.toggle()
}
