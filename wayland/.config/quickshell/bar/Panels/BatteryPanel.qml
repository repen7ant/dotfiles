import QtQuick
import qs.Commons
import qs.Widgets
import qs.Services

Panel {
  id: root
  panelWidth: 180

  Repeater {
    model: PowerProfile.profiles

    delegate: Rectangle {
      id: profileRow
      required property var modelData
      readonly property bool active: PowerProfile.current === modelData
      width: parent.width
      height: 30
      radius: Theme.radius
      color: rowMa.containsMouse ? Theme.hover : "transparent"
      Behavior on color { ColorAnimation { duration: Theme.animFast } }

      Row {
        anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: Theme.padH }
        spacing: 8

        Text {
          anchors.verticalCenter: parent.verticalCenter
          text: Icons.get(PowerProfile.iconFor(modelData))
          font.family: Icons.fontFamily
          font.pixelSize: Theme.iconSize
          color: profileRow.active ? Theme.primary : Theme.fg
        }
        Text {
          anchors.verticalCenter: parent.verticalCenter
          text: PowerProfile.labelFor(modelData)
          font.family: Theme.fontFamily
          font.pixelSize: Theme.fontSize
          color: profileRow.active ? Theme.primary : Theme.fg
        }
      }

      Text {
        anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: Theme.padH }
        visible: profileRow.active
        text: Icons.get("check")
        font.family: Icons.fontFamily
        font.pixelSize: Theme.iconSize
        color: Theme.primary
      }

      MouseArea {
        id: rowMa
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: { PowerProfile.setProfile(modelData); root.close() }
      }
    }
  }
}
