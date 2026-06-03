import Quickshell
import QtQuick
import qs.Commons
import qs.Widgets

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: panel
      required property var modelData
      screen: modelData

      anchors { top: true; left: true; right: true }
      implicitHeight: Theme.barHeight
      color: Theme.surface

      // LEFT
      Row {
        id: left
        anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: Theme.gap }
        spacing: Theme.gap
        Workspaces {}
        Media {}
      }

      // CENTER
      Row {
        id: center
        anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
        spacing: Theme.gap
        Clock {}
      }

      // RIGHT
      Row {
        id: right
        anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: Theme.gap }
        spacing: Theme.gap
        SysMon {}
        Network {}
        Volume {}
        Brightness {}
        Battery {}
        Tray { panelWindow: panel }
        PowerMenu {}
      }
    }
  }
}
