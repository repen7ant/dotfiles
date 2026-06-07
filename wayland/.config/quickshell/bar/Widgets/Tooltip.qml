import QtQuick
import Quickshell
import qs.Commons

PopupWindow {
  id: root

  required property var anchorItem
  property string text: ""

  anchor.item: anchorItem
  anchor.rect.x: anchorItem ? Math.round(anchorItem.width / 2 - width / 2) : 0
  anchor.rect.y: anchorItem ? anchorItem.height + 6 : 0

  implicitWidth: label.implicitWidth + 16
  implicitHeight: label.implicitHeight + 10
  visible: false
  color: "transparent"

  function show() { if (root.text.length > 0) delay.restart() }
  function hide() { delay.stop(); root.visible = false }

  Timer { id: delay; interval: 300; onTriggered: root.visible = true }

  Rectangle {
    anchors.fill: parent
    color: Theme.surfaceVariant
    radius: Theme.radius
    border.width: 1
    border.color: Theme.outline

    Text {
      id: label
      anchors.centerIn: parent
      text: root.text
      color: Theme.fg
      font.family: Theme.fontFamily
      font.pixelSize: Theme.fontSize
    }
  }
}
