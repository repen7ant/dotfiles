import QtQuick
import Quickshell
import qs.Commons
import qs.Widgets
import qs.Services

Panel {
  id: root
  panelWidth: 360
  alignRight: false

  Image {
    id: artProbe
    visible: false
    asynchronous: true
    source: Player.artUrl
  }

  Item {
    width: parent.width
    readonly property real aspect: (artProbe.status === Image.Ready && artProbe.sourceSize.height > 0)
      ? artProbe.sourceSize.width / artProbe.sourceSize.height : 1
    height: Player.artUrl.length > 0 ? Math.min(Math.round(width / Math.max(aspect, 0.001)), width) : Math.round(width * 0.5)
    clip: true

    Rectangle {
      anchors.fill: parent
      radius: Theme.radius
      color: Theme.surface

      Image {
        anchors.fill: parent
        source: Player.artUrl
        fillMode: Image.PreserveAspectFit
        visible: Player.artUrl.length > 0
        asynchronous: true
      }
      Text {
        anchors.centerIn: parent
        visible: Player.artUrl.length === 0
        text: Icons.get("music")
        font.family: Icons.fontFamily
        font.pixelSize: 48
        color: Theme.fgDim
      }
    }
  }

  Text {
    width: parent.width
    text: Player.title || "Nothing playing"
    color: Theme.fg
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize + 1
    elide: Text.ElideRight
  }
  Text {
    width: parent.width
    visible: Player.artist.length > 0
    text: Player.artist
    color: Theme.fgDim
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize
    elide: Text.ElideRight
  }

  Item {
    width: parent.width
    height: 18

    Rectangle {
      id: track
      anchors.verticalCenter: parent.verticalCenter
      width: parent.width
      height: 6
      radius: 3
      color: Theme.surface

      Rectangle {
        height: parent.height
        radius: 3
        width: parent.width * (Player.length > 0 ? Math.min(1, Player.position / Player.length) : 0)
        color: Theme.primary
      }

      MouseArea {
        anchors.fill: parent
        enabled: Player.canSeek
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: mouse => Player.seek(mouse.x / width)
      }
    }
  }

  Text {
    width: parent.width
    horizontalAlignment: Text.AlignHCenter
    text: root.fmt(Player.position) + " / " + root.fmt(Player.length)
    color: Theme.fgDim
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize - 2
  }

  Row {
    anchors.horizontalCenter: parent.horizontalCenter
    spacing: 18

    Text {
      anchors.verticalCenter: parent.verticalCenter
      text: Icons.get("player-skip-back-filled")
      font.family: Icons.fontFamily
      font.pixelSize: Theme.fontSize + 6
      color: Player.canGoPrevious ? Theme.fg : Theme.fgDim
      MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: Player.previous() }
    }
    Text {
      anchors.verticalCenter: parent.verticalCenter
      text: Icons.get(Player.isPlaying ? "player-pause-filled" : "player-play-filled")
      font.family: Icons.fontFamily
      font.pixelSize: Theme.fontSize + 10
      color: Theme.fg
      MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: Player.playPause() }
    }
    Text {
      anchors.verticalCenter: parent.verticalCenter
      text: Icons.get("player-skip-forward-filled")
      font.family: Icons.fontFamily
      font.pixelSize: Theme.fontSize + 6
      color: Player.canGoNext ? Theme.fg : Theme.fgDim
      MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: Player.next() }
    }
  }

  function fmt(s) {
    if (!s || s < 0) return "0:00"
    var m = Math.floor(s / 60)
    var sec = Math.floor(s % 60)
    return m + ":" + (sec < 10 ? "0" + sec : sec)
  }
}
