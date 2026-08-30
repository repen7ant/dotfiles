import QtQuick
import qs.Commons

Item {
  id: root

  property real value: 0          // 0..1, задаётся снаружи
  property int  trackHeight: 6
  property color fillColor: Theme.primary

  // Ползунок не меняет value сам: сообщает наружу, а значение возвращается
  // привязкой от источника. Иначе UI и PipeWire разъезжаются при внешних правках.
  signal moved(real v)

  implicitHeight: 16
  implicitWidth: 120

  readonly property real _v: Math.max(0, Math.min(1, value))

  function _emitAt(x) {
    root.moved(Math.max(0, Math.min(1, x / Math.max(1, root.width))))
  }

  Rectangle {
    anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter }
    height: root.trackHeight
    radius: height / 2
    color: Theme.surface

    Rectangle {
      width: parent.width * root._v
      height: parent.height
      radius: parent.radius
      color: root.fillColor
      Behavior on width { enabled: !ma.pressed; NumberAnimation { duration: Theme.animFast } }
    }
  }

  Rectangle {
    width: 12
    height: 12
    radius: 6
    color: Theme.fg
    anchors.verticalCenter: parent.verticalCenter
    x: (root.width - width) * root._v
    opacity: ma.containsMouse || ma.pressed ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: Theme.animFast } }
  }

  MouseArea {
    id: ma
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onPressed: mouse => root._emitAt(mouse.x)
    onPositionChanged: mouse => { if (pressed) root._emitAt(mouse.x) }
    onWheel: wheel => root.moved(Math.max(0, Math.min(1,
               root._v + (wheel.angleDelta.y > 0 ? 0.05 : -0.05))))
  }
}
