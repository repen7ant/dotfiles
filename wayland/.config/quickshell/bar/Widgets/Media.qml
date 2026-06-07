import qs.Commons
import qs.Widgets
import qs.Services
import qs.Panels

Pill {
  id: media
  visible: Player.hasPlayer && (Player.isPlaying || Player.title.length > 0)
  labelMaxWidth: 460
  icon: Player.isPlaying ? "player-pause-filled" : "player-play-filled"
  label: Player.title + (Player.artist ? " — " + Player.artist : "")

  onClicked: Player.playPause()
  onRightClicked: panel.toggle()

  MediaPanel {
    id: panel
    anchorItem: media
  }
}
