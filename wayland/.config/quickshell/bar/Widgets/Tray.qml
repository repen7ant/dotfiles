import QtQuick
import Quickshell.Services.SystemTray
import qs.Commons

Row {
  id: root
  property var panelWindow: null

  spacing: Theme.gap
  anchors.verticalCenter: parent ? parent.verticalCenter : undefined

  Repeater {
    model: SystemTray.items

    delegate: Item {
      id: entry
      required property var modelData
      implicitWidth: Theme.fontSize + 6
      implicitHeight: Theme.fontSize + 6
      anchors.verticalCenter: parent.verticalCenter

      Image {
        anchors.fill: parent
        source: entry.modelData.icon
        fillMode: Image.PreserveAspectFit
        smooth: true
      }

      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
          if (mouse.button === Qt.LeftButton) {
            entry.modelData.activate()
          } else if (mouse.button === Qt.RightButton && entry.modelData.hasMenu) {
            var p = entry.mapToItem(null, 0, entry.height)
            entry.modelData.display(root.panelWindow, p.x, p.y)
          }
        }
      }
    }
  }
}
