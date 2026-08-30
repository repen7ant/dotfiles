import QtQuick
import Quickshell
import qs.Commons
import qs.Widgets
import qs.Services

Panel {
  id: root
  panelWidth: 320

  // ---------- Output ----------
  Text {
    text: "Output"
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize - 2
    color: Theme.fgDim
  }

  Repeater {
    model: Audio.sinks

    delegate: Item {
      required property var modelData
      readonly property bool current: Audio.sink === modelData

      width: parent.width
      height: 22

      Rectangle {
        id: dot
        anchors { left: parent.left; verticalCenter: parent.verticalCenter }
        width: 8
        height: 8
        radius: 4
        color: parent.current ? Theme.primary : "transparent"
        border.width: parent.current ? 0 : 1
        border.color: Theme.fgDim
      }

      Text {
        anchors { left: dot.right; leftMargin: 8; right: parent.right; verticalCenter: parent.verticalCenter }
        text: Audio.label(parent.modelData)
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        color: parent.current ? Theme.fg : Theme.fgDim
        elide: Text.ElideRight
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Audio.setSink(parent.modelData)
      }
    }
  }

  Item {
    width: parent.width
    height: 20

    Text {
      id: outIcon
      anchors { left: parent.left; verticalCenter: parent.verticalCenter }
      text: Icons.get(Audio.muted ? "volume-off" : "volume")
      font.family: Icons.fontFamily
      font.pixelSize: Theme.iconSize
      color: Audio.muted ? Theme.fgDim : Theme.fg
      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Audio.toggleMute()
      }
    }

    Slider {
      anchors { left: outIcon.right; leftMargin: 10; right: outPct.left; rightMargin: 10; verticalCenter: parent.verticalCenter }
      value: Audio.volume
      fillColor: Audio.muted ? Theme.fgDim : Theme.primary
      onMoved: v => Audio.setVolume(v)
    }

    Text {
      id: outPct
      anchors { right: parent.right; verticalCenter: parent.verticalCenter }
      width: 34
      horizontalAlignment: Text.AlignRight
      text: Math.round(Audio.volume * 100) + "%"
      font.family: Theme.fontFamily
      font.pixelSize: Theme.fontSize - 1
      color: Theme.fgDim
    }
  }

  // ---------- Input ----------
  Text {
    text: "Input"
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize - 2
    color: Theme.fgDim
  }

  Repeater {
    model: Audio.sources

    delegate: Item {
      required property var modelData
      readonly property bool current: Audio.source === modelData

      width: parent.width
      height: 22

      Rectangle {
        id: sdot
        anchors { left: parent.left; verticalCenter: parent.verticalCenter }
        width: 8
        height: 8
        radius: 4
        color: parent.current ? Theme.primary : "transparent"
        border.width: parent.current ? 0 : 1
        border.color: Theme.fgDim
      }

      Text {
        anchors { left: sdot.right; leftMargin: 8; right: parent.right; verticalCenter: parent.verticalCenter }
        text: Audio.label(parent.modelData)
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        color: parent.current ? Theme.fg : Theme.fgDim
        elide: Text.ElideRight
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Audio.setSource(parent.modelData)
      }
    }
  }

  Item {
    width: parent.width
    height: 20

    Text {
      id: inIcon
      anchors { left: parent.left; verticalCenter: parent.verticalCenter }
      text: Icons.get(Audio.sourceMuted ? "mic-off" : "mic")
      font.family: Icons.fontFamily
      font.pixelSize: Theme.iconSize
      color: Audio.sourceMuted ? Theme.fgDim : Theme.fg
      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Audio.toggleSourceMute()
      }
    }

    Slider {
      anchors { left: inIcon.right; leftMargin: 10; right: inPct.left; rightMargin: 10; verticalCenter: parent.verticalCenter }
      value: Audio.sourceVolume
      fillColor: Audio.sourceMuted ? Theme.fgDim : Theme.primary
      onMoved: v => Audio.setSourceVolume(v)
    }

    Text {
      id: inPct
      anchors { right: parent.right; verticalCenter: parent.verticalCenter }
      width: 34
      horizontalAlignment: Text.AlignRight
      text: Math.round(Audio.sourceVolume * 100) + "%"
      font.family: Theme.fontFamily
      font.pixelSize: Theme.fontSize - 1
      color: Theme.fgDim
    }
  }

  // ---------- Apps ----------
  Text {
    visible: Audio.streams.length > 0
    text: "Apps"
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize - 2
    color: Theme.fgDim
  }

  Repeater {
    model: Audio.streams

    delegate: Column {
      required property var modelData
      readonly property bool has: modelData.audio !== null

      width: parent.width
      spacing: 2

      Text {
        width: parent.width
        text: Audio.label(parent.modelData)
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        color: Theme.fg
        elide: Text.ElideRight
      }

      Item {
        width: parent.width
        height: 18

        Slider {
          anchors { left: parent.left; right: appPct.left; rightMargin: 10; verticalCenter: parent.verticalCenter }
          value: parent.parent.has ? parent.parent.modelData.audio.volume : 0
          onMoved: v => { if (parent.parent.has) parent.parent.modelData.audio.volume = v }
        }

        Text {
          id: appPct
          anchors { right: parent.right; verticalCenter: parent.verticalCenter }
          width: 34
          horizontalAlignment: Text.AlignRight
          text: (parent.parent.has ? Math.round(parent.parent.modelData.audio.volume * 100) : 0) + "%"
          font.family: Theme.fontFamily
          font.pixelSize: Theme.fontSize - 1
          color: Theme.fgDim
        }
      }
    }
  }

  // ---------- Advanced ----------
  Rectangle {
    width: parent.width
    height: 1
    color: Theme.outline
  }

  Text {
    id: adv
    text: "Advanced…"
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize
    color: advMa.containsMouse ? Theme.fg : Theme.fgDim
    Behavior on color { ColorAnimation { duration: Theme.animFast } }

    MouseArea {
      id: advMa
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: { Quickshell.execDetached(["pavucontrol"]); root.close() }
    }
  }
}
