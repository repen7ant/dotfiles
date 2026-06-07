import QtQuick
import Quickshell
import qs.Commons
import qs.Widgets

Pill {
  interactive: false
  label: Qt.formatDateTime(clock.date, "HH:mm ddd, MMM dd")

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }
}
