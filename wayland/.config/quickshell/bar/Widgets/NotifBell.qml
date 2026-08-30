import QtQuick
import qs.Commons
import qs.Widgets
import qs.Services
import qs.Panels

Pill {
  id: bell

  icon: Notifs.dnd ? "bell-off"
      : Notifs.count > 0 ? "bell-ringing" : "bell"
  label: Notifs.count > 0 ? String(Notifs.count) : ""
  iconColor: Notifs.dnd ? Theme.fgDim : Theme.fg
  tooltipText: Notifs.dnd
    ? "Do not disturb"
    : Notifs.count === 0
      ? "No notifications"
      : Notifs.count + (Notifs.count === 1 ? " notification" : " notifications")

  onClicked: panel.toggle()
  onRightClicked: Notifs.dnd = !Notifs.dnd

  NotifPanel {
    id: panel
    anchorItem: bell
  }
}
