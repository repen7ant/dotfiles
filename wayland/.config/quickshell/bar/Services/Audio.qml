pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

Singleton {
  id: root

  readonly property PwNode sink: Pipewire.defaultAudioSink
  readonly property bool ready: sink !== null && sink.audio !== null
  readonly property real volume: ready ? sink.audio.volume : 0
  readonly property bool muted: ready ? sink.audio.muted : false

  PwObjectTracker { objects: root.sink ? [root.sink] : [] }

  function toggleMute() { if (ready) sink.audio.muted = !sink.audio.muted }
  function setVolume(v) { if (ready) sink.audio.volume = Math.max(0, Math.min(1, v)) }
}
