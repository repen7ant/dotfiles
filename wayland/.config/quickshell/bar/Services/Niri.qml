pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property var workspaces: []
  property string kbLayout: ""

  function focusWorkspace(ref) {
    Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", String(ref)])
  }

  function _handle(evt) {
    if (evt.WorkspacesChanged) {
      var ws = evt.WorkspacesChanged.workspaces.slice()
      ws.sort((a, b) => a.idx - b.idx)
      root.workspaces = ws
    } else if (evt.WorkspaceActivated) {
      var id = evt.WorkspaceActivated.id
      var copy = root.workspaces.map(w => Object.assign({}, w,
        { is_active: w.id === id, is_focused: w.id === id }))
      root.workspaces = copy
    } else if (evt.KeyboardLayoutsChanged) {
      var k = evt.KeyboardLayoutsChanged.keyboard_layouts
      root.kbLayout = k.names[k.current_idx] || ""
    }
  }

  Process {
    id: stream
    command: ["niri", "msg", "--json", "event-stream"]
    running: true
    onRunningChanged: if (!running) running = true
    stdout: SplitParser {
      onRead: line => {
        try { root._handle(JSON.parse(line)) }
        catch (e) {}
      }
    }
  }
}
