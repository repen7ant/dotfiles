import qs.Commons
import qs.Widgets
import qs.Services

Pill {
  icon: Audio.muted ? "volume-off"
      : Audio.volume <= 0.5 ? "volume-2" : "volume"
  label: Audio.muted ? "" : Math.round(Audio.volume * 100) + "%"
  textColor: Audio.muted ? Theme.fgDim : Theme.fg
  onClicked: Audio.toggleMute()
  onScrolled: dy => Audio.setVolume(Audio.volume + (dy > 0 ? 0.05 : -0.05))
}
