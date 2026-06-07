import QtQuick
import qs.Commons

Item {
  id: root

  property real   ratio: 0
  property string icon: ""
  property string value: ""
  property color  fillColor: Theme.primary
  property int    size: 64
  property int    thickness: 6

  implicitWidth: size
  implicitHeight: size

  Canvas {
    id: canvas
    anchors.fill: parent
    onPaint: {
      var ctx = getContext("2d")
      var w = width, h = height
      var cx = w / 2, cy = h / 2
      var r = Math.min(w, h) / 2 - root.thickness / 2
      ctx.reset()
      ctx.lineWidth = root.thickness
      ctx.lineCap = "round"
      ctx.beginPath()
      ctx.arc(cx, cy, r, 0, Math.PI * 2)
      ctx.strokeStyle = Theme.surface
      ctx.stroke()
      var start = -Math.PI / 2
      ctx.beginPath()
      ctx.arc(cx, cy, r, start, start + Math.PI * 2 * Math.max(0, Math.min(1, root.ratio)))
      ctx.strokeStyle = root.fillColor
      ctx.stroke()
    }
  }

  onRatioChanged: canvas.requestPaint()
  onFillColorChanged: canvas.requestPaint()

  Column {
    anchors.centerIn: parent
    spacing: 1

    Text {
      anchors.horizontalCenter: parent.horizontalCenter
      visible: root.icon.length > 0
      text: Icons.get(root.icon)
      font.family: Icons.fontFamily
      font.pixelSize: root.size * 0.28
      color: root.fillColor
    }
    Text {
      anchors.horizontalCenter: parent.horizontalCenter
      text: root.value
      font.family: Theme.fontFamily
      font.pixelSize: root.size * 0.22
      color: Theme.fg
    }
  }
}
