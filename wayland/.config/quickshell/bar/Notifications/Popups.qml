import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import qs.Commons
import qs.Services

PanelWindow {
  id: popups

  readonly property int maxVisible: 3

  // Карточки хранят СНИМОК полей, а не ссылку на Notification: transient-уведомления
  // уничтожаются сразу после показа, и живая ссылка обращалась бы в null на глазах.
  // Поле n нужно только для dismiss() и может стать null — все обращения защищены.
  property var cards: []

  function iconFor(n) {
    if (n.image !== "") return n.image
    if (n.appIcon === "") return ""
    return (n.appIcon.indexOf("/") === 0 || n.appIcon.indexOf("file://") === 0)
      ? n.appIcon
      : Quickshell.iconPath(n.appIcon)
  }

  function push(n) {
    if (cards.length >= maxVisible) return
    var ms = n.expireTimeout > 0
      ? n.expireTimeout
      : (n.urgency === NotificationUrgency.Low ? 3000 : 5000)
    var never = n.urgency === NotificationUrgency.Critical || n.expireTimeout === 0
    var a = cards.slice()
    a.unshift({
      n: n,
      until: never ? 0 : Date.now() + ms,
      summary: n.summary !== "" ? n.summary : n.appName,
      body: n.body,
      icon: popups.iconFor(n),
      critical: n.urgency === NotificationUrgency.Critical
    })
    cards = a
  }

  function drop(card) {
    cards = cards.filter(function (c) { return c !== card })
  }

  screen: Quickshell.screens[0]
  anchors { top: true; right: true }
  margins { top: Theme.barHeight + Theme.gap; right: Theme.gap }
  implicitWidth: 340
  implicitHeight: Math.max(1, col.implicitHeight)
  color: "transparent"
  visible: cards.length > 0
  exclusionMode: ExclusionMode.Ignore
  aboveWindows: true

  Connections {
    target: Notifs
    function onPosted(notif) {
      if (Notifs.dnd && notif.urgency !== NotificationUrgency.Critical) return
      popups.push(notif)
    }
  }

  Timer {
    interval: 250
    repeat: true
    running: popups.cards.length > 0
    onTriggered: {
      var now = Date.now()
      var live = popups.cards.filter(function (c) { return c.until === 0 || c.until > now })
      if (live.length !== popups.cards.length) popups.cards = live
    }
  }

  Column {
    id: col
    width: parent.width
    spacing: Theme.gap

    Repeater {
      model: popups.cards

      delegate: Rectangle {
        id: card
        required property var modelData

        width: col.width
        implicitHeight: body.implicitHeight + 20
        height: implicitHeight
        radius: Theme.radius
        color: Theme.surfaceVariant
        border.width: 1
        border.color: modelData.critical ? Theme.error : Theme.outline

        Row {
          id: body
          anchors { left: parent.left; right: parent.right; top: parent.top; margins: 10 }
          spacing: 10

          Item {
            width: 32
            height: 32

            Image {
              id: avatar
              anchors.fill: parent
              source: card.modelData.icon
              visible: source !== "" && status === Image.Ready
              fillMode: Image.PreserveAspectCrop
              smooth: true
            }

            Text {
              anchors.centerIn: parent
              visible: !avatar.visible
              text: Icons.get("bell")
              font.family: Icons.fontFamily
              font.pixelSize: Theme.iconSize
              color: Theme.fgDim
            }
          }

          Column {
            width: body.width - 42
            spacing: 2

            Text {
              width: parent.width
              text: card.modelData.summary
              font.family: Theme.fontFamily
              font.pixelSize: Theme.fontSize
              color: Theme.fg
              elide: Text.ElideRight
            }

            Text {
              width: parent.width
              visible: card.modelData.body !== ""
              text: card.modelData.body
              textFormat: Text.StyledText
              font.family: Theme.fontFamily
              font.pixelSize: Theme.fontSize - 1
              color: Theme.fgDim
              wrapMode: Text.Wrap
              maximumLineCount: 3
              elide: Text.ElideRight
            }
          }
        }

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            if (card.modelData.n) card.modelData.n.dismiss()
            popups.drop(card.modelData)
          }
        }
      }
    }
  }
}
