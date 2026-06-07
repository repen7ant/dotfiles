import Quickshell
import QtQuick
import qs.Commons
import qs.Widgets
import qs.Osd

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

      Row {
        id: left
        anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: Theme.gap }
        spacing: Theme.gap
        Workspaces {}
        Media {}
      }

      Clock {
        id: clock
        anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
      }

      PowerMenu {
        anchors { left: clock.right; leftMargin: Theme.gap; verticalCenter: parent.verticalCenter }
      }

      Row {
        id: right
        anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: Theme.gap }
        spacing: Theme.gap
        SysMon {}
        Network {}
        Volume { id: volPill }
        Brightness { id: briPill }
        Battery {}
        Tray {}
      }

      Osd {
        volumeAnchor: volPill
        brightnessAnchor: briPill
      }
    }
  }
}
