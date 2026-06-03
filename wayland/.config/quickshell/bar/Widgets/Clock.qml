import QtQuick
import Quickshell
import qs.Commons

Text {
  color: Theme.fg
  font.family: Theme.fontFamily
  font.pixelSize: Theme.fontSize
  text: Qt.formatDateTime(clock.date, "HH:mm ddd, MMM dd")

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }
}
