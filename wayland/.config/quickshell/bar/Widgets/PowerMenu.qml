import QtQuick
import Quickshell
import qs.Commons
import qs.Widgets

Pill {
  id: pm
  icon: "power"

  onClicked: menu.toggle()

  Panel {
    id: menu
    anchorItem: pm
    panelWidth: 160

    Repeater {
      model: [
        { label: "Lock",     icon: "lock",  act: ["qs", "-c", "bar", "ipc", "call", "lock", "lock"] },
        { label: "Suspend",  icon: "power", act: ["systemctl", "suspend"] },
        { label: "Logout",   icon: "power", act: ["niri", "msg", "action", "quit", "-s"] },
        { label: "Reboot",   icon: "power", act: ["systemctl", "reboot"] },
        { label: "Poweroff", icon: "power", act: ["systemctl", "poweroff"] }
      ]

      delegate: Rectangle {
        required property var modelData
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
            text: Icons.get(modelData.icon)
            font.family: Icons.fontFamily
            font.pixelSize: Theme.iconSize
            color: Theme.fg
          }
          Text {
            anchors.verticalCenter: parent.verticalCenter
            text: modelData.label
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            color: Theme.fg
          }
        }

        MouseArea {
          id: rowMa
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: { Quickshell.execDetached(modelData.act); menu.close() }
        }
      }
    }
  }
}
