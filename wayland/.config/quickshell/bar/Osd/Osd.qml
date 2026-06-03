import QtQuick
import Quickshell
import qs.Commons
import qs.Services

Scope {
  id: osd

  property string mode: ""      // "volume" | "brightness"
  property int value: 0
  property bool muted: false
  property bool _ready: false

  function show(m, v, mut) {
    if (!_ready) return
    mode = m; value = v; muted = mut || false
    win.visible = true
    hideTimer.restart()
  }

  Timer { id: hideTimer; interval: 1500; onTriggered: win.visible = false }
  // ignore the property settling that happens during startup
  Timer { interval: 800; running: true; onTriggered: osd._ready = true }

  Connections {
    target: Audio
    function onVolumeChanged() { osd.show("volume", Math.round(Audio.volume * 100), Audio.muted) }
    function onMutedChanged()  { osd.show("volume", Math.round(Audio.volume * 100), Audio.muted) }
  }

  Connections {
    target: Backlight
    function onPercentChanged() { osd.show("brightness", Backlight.percent, false) }
  }

  PanelWindow {
    id: win
    visible: false
    anchors { bottom: true }
    margins { bottom: 120 }
    implicitWidth: 260
    implicitHeight: 56
    color: "transparent"
    exclusiveZone: 0

    Rectangle {
      anchors.fill: parent
      color: Theme.surfaceVariant
      radius: Theme.radius
      border.width: 1
      border.color: Theme.outline

      Row {
        anchors { fill: parent; margins: 12 }
        spacing: 12

        Text {
          anchors.verticalCenter: parent.verticalCenter
          font.family: Theme.fontFamily
          font.pixelSize: Theme.fontSize + 4
          color: Theme.fg
          text: osd.mode === "brightness" ? String.fromCodePoint(0xF00E0)
              : osd.muted                 ? String.fromCodePoint(0xF026)
              :                             String.fromCodePoint(0xF028)
        }

        Rectangle {
          anchors.verticalCenter: parent.verticalCenter
          width: parent.width - 100
          height: 8
          radius: 4
          color: Theme.surface
          Rectangle {
            height: parent.height
            radius: 4
            width: parent.width * Math.max(0, Math.min(100, osd.value)) / 100
            color: osd.muted ? Theme.fgDim : Theme.primary
          }
        }

        Text {
          anchors.verticalCenter: parent.verticalCenter
          font.family: Theme.fontFamily
          font.pixelSize: Theme.fontSize
          color: Theme.fg
          text: osd.value + "%"
        }
      }
    }
  }
}
