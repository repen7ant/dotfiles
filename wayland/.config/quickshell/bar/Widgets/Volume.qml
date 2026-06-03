import qs.Commons
import qs.Services

Stat {
  icon: Audio.muted ? String.fromCodePoint(0xF026) : String.fromCodePoint(0xF028)
  label: Audio.muted ? "muted" : Math.round(Audio.volume * 100) + "%"
  textColor: Audio.muted ? Theme.fgDim : Theme.fg
  onClicked: Audio.toggleMute()
  onScrolled: Audio.setVolume(Audio.volume + (dy > 0 ? 0.05 : -0.05))
}
