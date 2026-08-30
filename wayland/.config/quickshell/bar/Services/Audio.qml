pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

Singleton {
  id: root

  readonly property PwNode sink: Pipewire.defaultAudioSink
  readonly property bool ready: sink !== null && sink.audio !== null
  readonly property real volume: ready ? sink.audio.volume : 0
  readonly property bool muted: ready ? sink.audio.muted : false

  readonly property PwNode source: Pipewire.defaultAudioSource
  readonly property bool sourceReady: source !== null && source.audio !== null
  readonly property real sourceVolume: sourceReady ? source.audio.volume : 0
  readonly property bool sourceMuted: sourceReady ? source.audio.muted : false

  // AudioOutStream включает в себя биты AudioSink, поэтому одного битового
  // совпадения мало: поток приложения иначе попадает в список устройств вывода.
  // Разделяем штатным isStream.
  function _ofType(flag, wantStream) {
    var out = []
    var vals = Pipewire.nodes.values
    for (var i = 0; i < vals.length; i++) {
      var n = vals[i]
      if ((n.type & flag) === flag && n.isStream === wantStream) out.push(n)
    }
    return out
  }

  readonly property var sinks:   _ofType(PwNodeType.AudioSink,      false)
  readonly property var sources: _ofType(PwNodeType.AudioSource,    false)
  readonly property var streams: _ofType(PwNodeType.AudioOutStream, true)

  // Без отслеживания у узла не заполнено audio, и ползунки были бы мёртвыми.
  // Трекер обязан покрывать всё, что показывает панель, а не только текущий вывод.
  PwObjectTracker { objects: root.sinks.concat(root.sources, root.streams) }

  function label(n) {
    if (!n) return ""
    var app = n.properties ? n.properties["application.name"] : ""
    if (app) return app
    return n.description !== "" ? n.description : n.name
  }

  function toggleMute() { if (ready) sink.audio.muted = !sink.audio.muted }
  function setVolume(v) { if (ready) sink.audio.volume = Math.max(0, Math.min(1, v)) }

  function toggleSourceMute() { if (sourceReady) source.audio.muted = !source.audio.muted }
  function setSourceVolume(v) { if (sourceReady) source.audio.volume = Math.max(0, Math.min(1, v)) }

  function setSink(n)   { if (n) Pipewire.preferredDefaultAudioSink = n }
  function setSource(n) { if (n) Pipewire.preferredDefaultAudioSource = n }
}
