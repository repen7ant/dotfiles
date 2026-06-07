import QtQuick
import qs.Commons
import qs.Widgets
import qs.Services

Panel {
  id: root
  panelWidth: 150

  CircleStat {
    anchors.horizontalCenter: parent.horizontalCenter
    icon: "cpu-usage"
    ratio: SysInfo.cpu / 100
    value: SysInfo.cpu + "%"
    fillColor: SysInfo.cpuColor
  }
  CircleStat {
    anchors.horizontalCenter: parent.horizontalCenter
    icon: "cpu-temperature"
    ratio: SysInfo.cpuTemp / 100
    value: SysInfo.cpuTemp + "°"
    fillColor: SysInfo.tempColor
  }
  CircleStat {
    anchors.horizontalCenter: parent.horizontalCenter
    icon: "memory"
    ratio: SysInfo.mem / 100
    value: SysInfo.mem + "%"
    fillColor: SysInfo.memColor
  }
  CircleStat {
    anchors.horizontalCenter: parent.horizontalCenter
    icon: "storage"
    ratio: SysInfo.disk / 100
    value: SysInfo.disk + "%"
    fillColor: SysInfo.diskColor
  }
}
