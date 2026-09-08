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
        id: power
        anchors { left: clock.right; leftMargin: Theme.gap; verticalCenter: parent.verticalCenter }
      }

      Row {
        id: right
        anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: Theme.gap }
        spacing: Theme.gap

        // Every widget here is a fixed size except the network SSID, so the
        // SSID gets whatever room is left before the row would reach the power
        // button. Read from the siblings rather than from `right.width` — using
        // the row's own width here would be a binding loop.
        function slot(item) { return item.visible ? item.width + Theme.gap : 0 }

        readonly property real netLabelBudget:
          panel.width - power.x - power.width - Theme.gap * 2
          - slot(bell) - slot(kb) - slot(sys)
          - slot(volPill) - slot(briPill) - slot(bat) - slot(tray)
          - net.chromeWidth

        NotifBell { id: bell }
        KbLayout { id: kb }
        SysMon { id: sys }
        Network {
          id: net
          // Below ~32px an elided name is unreadable, so drop it and keep the
          // icon only; the full name stays available in the tooltip.
          labelMaxWidth: right.netLabelBudget < 32 ? 0
                       : Math.min(180, Math.floor(right.netLabelBudget))
        }
        Volume { id: volPill }
        Brightness { id: briPill }
        Battery { id: bat }
        Tray { id: tray }
      }

      Osd {
        volumeAnchor: volPill
        brightnessAnchor: briPill
      }
    }
  }
}
