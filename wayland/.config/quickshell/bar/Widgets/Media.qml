import Quickshell.Services.Mpris

Stat {
  readonly property var player: {
    var ps = Mpris.players.values
    for (var i = 0; i < ps.length; i++) if (ps[i].canControl) return ps[i]
    return null
  }

  visible: player !== null
  labelMaxWidth: 280
  icon: player ? (player.isPlaying ? String.fromCodePoint(0xF03E4)    // md-pause (click to pause)
                                   : String.fromCodePoint(0xF040A))   // md-play (click to play)
               : ""
  label: player ? (player.trackTitle + (player.trackArtist ? " — " + player.trackArtist : "")) : ""
  onClicked: if (player) player.isPlaying = !player.isPlaying
}
