import QtQuick
import Quickshell
import qs.Commons

PopupWindow {
  id: root

  required property var anchorItem
  property int panelWidth: 320
  property int pad: 10
  property bool alignRight: true
  default property alias content: col.data

  anchor.item: anchorItem
  anchor.rect.x: anchorItem ? (alignRight ? anchorItem.width - width : 0) : 0
  anchor.rect.y: anchorItem ? anchorItem.height + 6 : 0

  implicitWidth: panelWidth
  implicitHeight: col.implicitHeight + pad * 2
  visible: false
  grabFocus: true
  color: "transparent"

  function toggle() { root.visible = !root.visible }
  function close()  { root.visible = false }

  data: Rectangle {
    anchors.fill: parent
    color: Theme.surfaceVariant
    radius: Theme.radius
    border.width: 1
    border.color: Theme.outline

    Column {
      id: col
      anchors { left: parent.left; right: parent.right; top: parent.top; margins: root.pad }
      spacing: 10
    }
  }
}
