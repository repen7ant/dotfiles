import QtQuick
import qs.Commons
import qs.Widgets
import qs.Services
import qs.Panels

Item {
  id: sys
  implicitWidth: capsule.implicitWidth
  implicitHeight: Theme.capsuleHeight
  anchors.verticalCenter: parent ? parent.verticalCenter : undefined

  Rectangle {
    id: capsule
    anchors.fill: parent
    radius: Theme.radius
    color: Theme.capsule
    implicitWidth: row.implicitWidth + Theme.padH * 2

    Row {
      id: row
      anchors.centerIn: parent
      spacing: 5

      Text {
        anchors.verticalCenter: parent.verticalCenter
        text: Icons.get("cpu-usage")
        font.family: Icons.fontFamily
        font.pixelSize: Theme.iconSize
        color: Theme.fg
      }
      Text {
        anchors.verticalCenter: parent.verticalCenter
        text: SysInfo.cpu + "%"
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        color: Theme.fg
      }
      Text {
        anchors.verticalCenter: parent.verticalCenter
        leftPadding: 3
        text: Icons.get("memory")
        font.family: Icons.fontFamily
        font.pixelSize: Theme.iconSize
        color: Theme.fg
      }
      Text {
        anchors.verticalCenter: parent.verticalCenter
        text: SysInfo.mem + "%"
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        color: Theme.fg
      }
    }
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: panel.toggle()
    onEntered: tip.show()
    onExited: tip.hide()
  }

  Tooltip {
    id: tip
    anchorItem: sys
    text: "CPU " + SysInfo.cpu + "% · " + SysInfo.cpuFreq.toFixed(1) + " GHz · " + SysInfo.cpuTemp + "°C"
        + "\nRAM " + SysInfo.mem + "%"
        + "\nDisk " + SysInfo.disk + "% (" + SysInfo.diskUsedGb.toFixed(0) + "/" + SysInfo.diskTotalGb.toFixed(0) + " GiB)"
  }

  PerfPanel {
    id: panel
    anchorItem: sys
  }
}
