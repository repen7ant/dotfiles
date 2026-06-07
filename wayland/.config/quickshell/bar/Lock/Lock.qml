import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam
import qs.Commons

Scope {
  id: root
  property string _pending: ""
  property string wallpaper: ""

  function lockNow() {
    wpProc.running = true
    lockSession.locked = true
  }

  IpcHandler {
    target: "lock"
    function lock(): void { root.lockNow() }
  }

  Process {
    id: wpProc
    running: true
    command: ["sh", "-c", "for p in $(pgrep -x swaybg); do tr '\\0' '\\n' < /proc/$p/cmdline; done | grep -A1 -x -- -i | tail -1"]
    stdout: StdioCollector { onStreamFinished: root.wallpaper = text.trim() }
  }

  Process {
    id: sleepMonitor
    running: true
    command: ["gdbus", "monitor", "--system", "--dest", "org.freedesktop.login1", "--object-path", "/org/freedesktop/login1"]
    stdout: SplitParser {
      onRead: line => {
        if (line.indexOf("PrepareForSleep") !== -1 && line.indexOf("true") !== -1)
          root.lockNow()
      }
    }
  }

  WlSessionLock {
    id: lockSession
    locked: false

    WlSessionLockSurface {
      color: Theme.surface
      Component.onCompleted: pw.forceActiveFocus()

      Image {
        id: wp
        anchors.fill: parent
        source: root.wallpaper ? "file://" + root.wallpaper : ""
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: true
        visible: false
      }

      MultiEffect {
        anchors.fill: parent
        source: wp
        visible: wp.status === Image.Ready
        blurEnabled: true
        blur: 1.0
        blurMax: 64
      }

      Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.45
      }

      Column {
        anchors.centerIn: parent
        spacing: 16
        width: 320

        Text {
          anchors.horizontalCenter: parent.horizontalCenter
          text: Qt.formatDateTime(lockClock.date, "HH:mm")
          color: Theme.fg
          font.family: Theme.fontFamily
          font.pixelSize: 64
          SystemClock { id: lockClock; precision: SystemClock.Minutes }
        }

        Rectangle {
          width: parent.width
          height: 40
          radius: Theme.radius
          color: Theme.surfaceVariant
          border.width: 1
          border.color: pam.active ? Theme.primary : Theme.outline

          TextInput {
            id: pw
            anchors { fill: parent; margins: 10 }
            verticalAlignment: TextInput.AlignVCenter
            echoMode: TextInput.Password
            color: Theme.fg
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            focus: true
            enabled: !pam.active
            onAccepted: {
              if (text.length === 0) return
              errorText.text = ""
              root._pending = text
              pam.start()
            }
          }
        }

        Text {
          id: errorText
          anchors.horizontalCenter: parent.horizontalCenter
          text: ""
          color: Theme.error
          font.family: Theme.fontFamily
          font.pixelSize: Theme.fontSize
        }
      }
    }
  }

  PamContext {
    id: pam
    config: "login"

    onPamMessage: {
      if (pam.responseRequired) pam.respond(root._pending)
    }

    onCompleted: result => {
      root._pending = ""
      if (result === PamResult.Success) {
        lockSession.locked = false
        pw.text = ""
        errorText.text = ""
      } else {
        pw.text = ""
        errorText.text = "Authentication failed"
        pw.forceActiveFocus()
      }
    }

    onError: {
      root._pending = ""
      pw.text = ""
      errorText.text = "Authentication error"
    }
  }
}
