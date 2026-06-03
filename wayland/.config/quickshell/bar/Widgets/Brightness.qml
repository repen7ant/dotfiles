import qs.Commons
import qs.Services

Stat {
  icon: String.fromCodePoint(0xF00E0)   // nf-md-brightness-7 (sun)
  label: Backlight.percent + "%"
  onScrolled: Backlight.changeBy(dy > 0 ? 5 : -5)
}
