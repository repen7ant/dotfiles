import QtQuick
import Quickshell
import qs.Commons

Item {
  id: pm
  implicitWidth: btn.implicitWidth + Theme.padH
  implicitHeight: Theme.barHeight
  anchors.verticalCenter: parent ? parent.verticalCenter : undefined

  Text {
    id: btn
    anchors.centerIn: parent
    text: String.fromCodePoint(0xF0425)   // md-power
    color: Theme.fg
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize + 2

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: popup.visible = !popup.visible
    }
  }

  PopupWindow {
    id: popup
    anchor.item: pm
    anchor.rect.x: pm.width - width   // right-align popup to the button
    anchor.rect.y: pm.height + 4      // just below the bar
    implicitWidth: 150
    implicitHeight: col.implicitHeight + 8
    visible: false
    grabFocus: true                   // click outside dismisses
    color: "transparent"

    Rectangle {
      anchors.fill: parent
      color: Theme.surfaceVariant
      radius: Theme.radius
      border.width: 1
      border.color: Theme.outline

      Column {
        id: col
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: 4 }

        Repeater {
          model: [
            { label: "Lock",     act: ["qs", "-c", Quickshell.env("HOME") + "/.config/quickshell/bar", "ipc", "call", "lock", "lock"] },
            { label: "Suspend",  act: ["systemctl", "suspend"] },
            { label: "Logout",   act: ["niri", "msg", "action", "quit", "-s"] },
            { label: "Reboot",   act: ["systemctl", "reboot"] },
            { label: "Poweroff", act: ["systemctl", "poweroff"] }
          ]

          delegate: Rectangle {
            required property var modelData
            width: parent.width
            height: 28
            radius: Theme.radius
            color: ma.containsMouse ? Theme.primary : "transparent"

            Text {
              anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: Theme.padH }
              text: modelData.label
              color: ma.containsMouse ? Theme.surface : Theme.fg
              font.family: Theme.fontFamily
              font.pixelSize: Theme.fontSize
            }

            MouseArea {
              id: ma
              anchors.fill: parent
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
              onClicked: { Quickshell.execDetached(modelData.act); popup.visible = false }
            }
          }
        }
      }
    }
  }
}
