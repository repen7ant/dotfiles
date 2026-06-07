pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
  id: root

  readonly property var player: {
    var ps = Mpris.players.values
    var fallback = null
    var titled = null
    for (var i = 0; i < ps.length; i++) {
      var p = ps[i]
      if (!p.canControl) continue
      if (p.dbusName && p.dbusName.indexOf("playerctld") !== -1) continue
      if (p.playbackState === MprisPlaybackState.Stopped) continue
      if (p.isPlaying) return p
      if (!titled && p.trackTitle && p.trackTitle.length > 0) titled = p
      if (!fallback) fallback = p
    }
    return titled || fallback
  }

  readonly property bool   hasPlayer: player !== null
  readonly property string title:  hasPlayer ? (player.trackTitle  || "") : ""
  readonly property string artist: hasPlayer ? (player.trackArtist || "") : ""
  readonly property string artUrl: hasPlayer ? (player.trackArtUrl || "") : ""
  readonly property bool   isPlaying: hasPlayer && player.isPlaying
  readonly property real   length: hasPlayer ? (player.length || 0) : 0
  readonly property bool   canGoNext:     hasPlayer && player.canGoNext
  readonly property bool   canGoPrevious: hasPlayer && player.canGoPrevious
  readonly property bool   canSeek:       hasPlayer && player.canSeek

  property real position: 0

  function playPause() { if (hasPlayer) player.isPlaying = !player.isPlaying }
  function next()      { if (canGoNext) player.next() }
  function previous()  { if (canGoPrevious) player.previous() }
  function seek(ratio) {
    if (canSeek && length > 0) {
      var p = Math.max(0, Math.min(1, ratio)) * length
      player.position = p
      root.position = p
    }
  }

  Timer {
    interval: 1000; repeat: true; running: root.isPlaying
    onTriggered: root.position = root.hasPlayer ? root.player.position : 0
  }
  onPlayerChanged: root.position = root.hasPlayer ? root.player.position : 0
}
