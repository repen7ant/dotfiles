pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
  id: root

  signal posted(var notif)

  readonly property var list: server.trackedNotifications
  readonly property int count: server.trackedNotifications.values.length
  property bool dnd: false

  function clearAll() {
    var vals = server.trackedNotifications.values
    for (var i = vals.length - 1; i >= 0; i--)
      vals[i].tracked = false
  }

  NotificationServer {
    id: server
    keepOnReload: true
    bodySupported: true
    bodyMarkupSupported: true
    imageSupported: true
    actionsSupported: false
    inlineReplySupported: false

    onNotification: notif => {
      // posted идёт первым: Popups снимает копию полей, пока объект жив.
      // transient после этого уничтожается — в историю он не попадает.
      root.posted(notif)
      notif.tracked = !notif.transient
    }
  }
}
