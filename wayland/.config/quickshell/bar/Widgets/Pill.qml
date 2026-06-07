import QtQuick
import qs.Commons

Item {
  id: root

  property string icon: ""
  property int    iconPixelSize: Theme.iconSize
  property string label: ""
  property color  textColor: Theme.fg
  property color  iconColor: textColor
  property int    labelMaxWidth: 0
  property string tooltipText: ""
  property bool   interactive: true

  readonly property bool labelVisible: label.length > 0

  signal clicked()
  signal rightClicked()
  signal scrolled(real dy)

  implicitWidth: capsule.implicitWidth
  implicitHeight: Theme.capsuleHeight
  anchors.verticalCenter: parent ? parent.verticalCenter : undefined

  Rectangle {
    id: capsule
    anchors.fill: parent
    radius: Theme.radius
    color: Theme.capsule
    implicitWidth: contentRow.implicitWidth + Theme.padH * 2

    Row {
      id: contentRow
      anchors.centerIn: parent
      spacing: 5

      Text {
        id: iconText
        visible: root.icon.length > 0
        anchors.verticalCenter: parent.verticalCenter
        font.family: Icons.fontFamily
        font.pixelSize: root.iconPixelSize
        color: root.iconColor
        text: Icons.get(root.icon)
      }

      Item {
        id: labelClip
        anchors.verticalCenter: parent.verticalCenter
        height: labelText.implicitHeight
        clip: true
        readonly property real fullWidth: root.labelMaxWidth > 0
          ? Math.min(labelText.implicitWidth, root.labelMaxWidth) : labelText.implicitWidth
        width: root.labelVisible ? fullWidth : 0
        opacity: root.labelVisible ? 1 : 0
        Behavior on width   { NumberAnimation { duration: Theme.animNormal; easing.type: Easing.OutCubic } }
        Behavior on opacity { NumberAnimation { duration: Theme.animNormal } }

        Text {
          id: labelText
          anchors { left: parent.left; verticalCenter: parent.verticalCenter }
          width: labelClip.fullWidth
          font.family: Theme.fontFamily
          font.pixelSize: Theme.fontSize
          color: root.textColor
          text: root.label
          elide: Text.ElideRight
        }
      }
    }
  }

  MouseArea {
    id: ma
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: root.interactive ? Qt.PointingHandCursor : Qt.ArrowCursor
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: mouse => mouse.button === Qt.RightButton ? root.rightClicked() : root.clicked()
    onWheel: wheel => root.scrolled(wheel.angleDelta.y)
    onEntered: tip.show()
    onExited: tip.hide()
  }

  Tooltip {
    id: tip
    anchorItem: root
    text: root.tooltipText
  }
}
