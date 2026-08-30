import qs.Commons
import qs.Widgets
import qs.Services
import qs.Panels

Pill {
  id: vol

  // Osd спрашивает это, чтобы не дублировать панель всплывающим индикатором
  readonly property bool panelOpen: panel.visible

  icon: Audio.muted ? "volume-off"
      : Audio.volume <= 0.5 ? "volume-2" : "volume"
  label: Audio.muted ? "" : Math.round(Audio.volume * 100) + "%"
  textColor: Audio.muted ? Theme.fgDim : Theme.fg

  onClicked: panel.toggle()
  onRightClicked: Audio.toggleMute()
  onScrolled: dy => Audio.setVolume(Audio.volume + (dy > 0 ? 0.05 : -0.05))

  AudioPanel {
    id: panel
    anchorItem: vol
  }
}
