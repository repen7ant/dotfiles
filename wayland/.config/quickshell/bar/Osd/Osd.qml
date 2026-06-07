import QtQuick
import Quickshell
import qs.Commons
import qs.Services

Item {
  id: osd

  property var volumeAnchor
  property var brightnessAnchor

  property string mode: ""
  property int value: 0
  property bool muted: false
  property bool _ready: false
  property bool shown: false

  readonly property var anchorItem: mode === "brightness" ? brightnessAnchor : volumeAnchor

  function show(m, v, mut) {
    if (!_ready) return
    mode = m; value = v; muted = mut || false
    shown = true
    hideTimer.restart()
  }

  Timer { id: hideTimer; interval: 1500; onTriggered: osd.shown = false }
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

  PopupWindow {
    id: win
    visible: osd.shown || bg.opacity > 0.01
    color: "transparent"
    anchor.item: osd.anchorItem
    anchor.rect.x: osd.anchorItem ? osd.anchorItem.width - width : 0
    anchor.rect.y: osd.anchorItem ? osd.anchorItem.height + 6 : 0
    implicitWidth: 240
    implicitHeight: 44

    Rectangle {
      id: bg
      anchors.fill: parent
      color: Theme.surfaceVariant
      radius: Theme.radius
      border.width: 1
      border.color: Theme.outline
      opacity: osd.shown ? 1 : 0
      Behavior on opacity { NumberAnimation { duration: Theme.animNormal } }

      Row {
        anchors { fill: parent; margins: 10 }
        spacing: 10

        Text {
          anchors.verticalCenter: parent.verticalCenter
          font.family: Icons.fontFamily
          font.pixelSize: Theme.iconSize
          color: Theme.fg
          text: Icons.get(osd.mode === "brightness"
                  ? (osd.value <= 50 ? "brightness-low" : "brightness-high")
                  : (osd.muted ? "volume-off"
                    : osd.value <= 50 ? "volume-2" : "volume"))
        }

        Rectangle {
          anchors.verticalCenter: parent.verticalCenter
          width: parent.width - 90
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
