import QtQuick
import qs.Commons
import qs.Widgets
import qs.Services

Panel {
  id: root
  panelWidth: 340

  Item {
    width: parent.width
    height: 22

    Text {
      anchors { left: parent.left; verticalCenter: parent.verticalCenter }
      text: "Notifications"
      font.family: Theme.fontFamily
      font.pixelSize: Theme.fontSize
      color: Theme.fg
    }

    Row {
      anchors { right: parent.right; verticalCenter: parent.verticalCenter }
      spacing: 12

      Text {
        visible: Notifs.count > 0
        text: Icons.get("trash")
        font.family: Icons.fontFamily
        font.pixelSize: Theme.iconSize
        color: Theme.fgDim
        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: Notifs.clearAll()
        }
      }
    }
  }

  Text {
    width: parent.width
    visible: Notifs.count === 0
    text: "No notifications"
    horizontalAlignment: Text.AlignHCenter
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize
    color: Theme.fgDim
  }

  Flickable {
    width: parent.width
    height: Math.min(contentHeight, 320)
    visible: Notifs.count > 0
    contentHeight: listCol.implicitHeight
    clip: true
    boundsBehavior: Flickable.StopAtBounds

    Column {
      id: listCol
      width: parent.width
      spacing: 8

      Repeater {
        model: Notifs.list

        delegate: Rectangle {
          id: row
          required property var modelData

          width: listCol.width
          implicitHeight: info.implicitHeight + 16
          height: implicitHeight
          radius: Theme.radius
          color: rowMa.containsMouse ? Theme.hover : Theme.surface
          Behavior on color { ColorAnimation { duration: Theme.animFast } }

          Column {
            id: info
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: 8 }
            spacing: 2

            Text {
              width: parent.width
              text: row.modelData.appName
              font.family: Theme.fontFamily
              font.pixelSize: Theme.fontSize - 2
              color: Theme.primary
              elide: Text.ElideRight
            }

            Text {
              width: parent.width
              text: row.modelData.summary !== "" ? row.modelData.summary : row.modelData.appName
              font.family: Theme.fontFamily
              font.pixelSize: Theme.fontSize
              color: Theme.fg
              elide: Text.ElideRight
            }

            Text {
              width: parent.width
              visible: row.modelData.body !== ""
              text: row.modelData.body
              textFormat: Text.StyledText
              font.family: Theme.fontFamily
              font.pixelSize: Theme.fontSize - 1
              color: Theme.fgDim
              wrapMode: Text.Wrap
              maximumLineCount: 2
              elide: Text.ElideRight
            }
          }

          MouseArea {
            id: rowMa
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: row.modelData.tracked = false
          }
        }
      }
    }
  }
}
