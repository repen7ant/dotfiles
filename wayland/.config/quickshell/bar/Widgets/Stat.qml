import QtQuick
import qs.Commons

// Reusable bar item: optional icon glyph + optional label, with click/scroll.
Item {
  id: root

  property string icon: ""
  property string label: ""
  property color textColor: Theme.fg
  property int spacing: 5
  property int labelMaxWidth: 0   // 0 = unlimited; otherwise elide with "…"

  signal clicked()
  signal scrolled(real dy)

  implicitWidth: row.implicitWidth
  implicitHeight: Theme.barHeight
  anchors.verticalCenter: parent ? parent.verticalCenter : undefined

  Row {
    id: row
    anchors.centerIn: parent
    spacing: root.spacing

    Text {
      visible: root.icon.length > 0
      anchors.verticalCenter: parent.verticalCenter
      font.family: Theme.fontFamily
      font.pixelSize: Theme.fontSize
      color: root.textColor
      text: root.icon
    }

    Text {
      visible: root.label.length > 0
      anchors.verticalCenter: parent.verticalCenter
      font.family: Theme.fontFamily
      font.pixelSize: Theme.fontSize
      color: root.textColor
      text: root.label
      elide: Text.ElideRight
      width: root.labelMaxWidth > 0 ? Math.min(implicitWidth, root.labelMaxWidth) : implicitWidth
    }
  }

  MouseArea {
    anchors.fill: parent
    onClicked: root.clicked()
    onWheel: root.scrolled(wheel.angleDelta.y)
  }
}
