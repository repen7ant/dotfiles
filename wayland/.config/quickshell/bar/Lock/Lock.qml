import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam
import qs.Commons

Scope {
  id: root
  property string _pending: ""

  IpcHandler {
    target: "lock"
    function lock(): void { lockSession.locked = true }
  }

  WlSessionLock {
    id: lockSession
    locked: false

    WlSessionLockSurface {
      color: Theme.surface
      Component.onCompleted: pw.forceActiveFocus()

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
