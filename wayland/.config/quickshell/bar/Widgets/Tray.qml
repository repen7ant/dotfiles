import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import qs.Commons

Row {
  id: root

  spacing: Theme.gap
  anchors.verticalCenter: parent ? parent.verticalCenter : undefined

  Repeater {
    model: SystemTray.items

    delegate: Item {
      id: entry
      required property var modelData
      readonly property int sz: 18
      implicitWidth: sz
      implicitHeight: sz
      anchors.verticalCenter: parent.verticalCenter

      Image {
        anchors.centerIn: parent
        width: entry.sz
        height: entry.sz
        source: entry.modelData.icon
        sourceSize.width: entry.sz * 2
        sourceSize.height: entry.sz * 2
        fillMode: Image.PreserveAspectFit
        smooth: true
        mipmap: true
      }

      QsMenuAnchor {
        id: trayMenu
        menu: entry.modelData.menu
        anchor.item: entry
        anchor.rect.x: entry.width / 2
        anchor.rect.y: entry.height + 4
      }

      MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
        onClicked: mouse => {
          if (mouse.button === Qt.LeftButton) {
            if (entry.modelData.onlyMenu && entry.modelData.hasMenu)
              trayMenu.open()
            else
              entry.modelData.activate()
          } else if (mouse.button === Qt.MiddleButton) {
            entry.modelData.secondaryActivate()
          } else if (mouse.button === Qt.RightButton && entry.modelData.hasMenu) {
            trayMenu.open()
          }
        }
        onWheel: wheel => entry.modelData.scroll(wheel.angleDelta.y, false)
      }
    }
  }
}
