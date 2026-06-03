import QtQuick
import qs.Commons
import qs.Services

Row {
  spacing: Theme.gap

  Repeater {
    model: Niri.workspaces

    Rectangle {
      required property var modelData
      radius: Theme.radius
      color: modelData.is_focused ? Theme.primary
           : modelData.is_active  ? Theme.surfaceVariant
           : "transparent"
      border.width: modelData.is_urgent ? 1 : 0
      border.color: Theme.error
      implicitHeight: Theme.barHeight - 8
      implicitWidth: label.implicitWidth + Theme.padH * 2
      anchors.verticalCenter: parent.verticalCenter

      Text {
        id: label
        anchors.centerIn: parent
        text: modelData.name && modelData.name.length ? modelData.name : modelData.idx
        color: modelData.is_focused ? Theme.surface : Theme.fg
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Niri.focusWorkspace(
          parent.modelData.name && parent.modelData.name.length
            ? parent.modelData.name : parent.modelData.idx)
      }
    }
  }
}
