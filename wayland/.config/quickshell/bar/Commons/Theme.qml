pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  readonly property int  barHeight: 30
  readonly property int  fontSize:  13
  readonly property int  iconSize:  17
  readonly property string fontFamily: "JetBrainsMono Nerd Font"
  readonly property int  radius:    10
  readonly property int  gap:       6
  readonly property int  padH:      8

  readonly property int   capsuleHeight: barHeight - 6
  readonly property int   animFast:   150
  readonly property int   animNormal: 300

  property color error:           "#c34043"
  property color primary:         "#76946a"
  property color secondary:       "#c0a36e"
  property color surface:         "#1f1f28"
  property color surfaceVariant:  "#2a2a37"
  property color fg:              "#c8c093"
  property color fgDim:           "#717c7c"
  property color outline:         "#363646"

  readonly property color capsule: Qt.lighter(surface, 1.22)
  readonly property color hover: Qt.rgba(primary.r, primary.g, primary.b, 0.18)
  readonly property color warn:  secondary
  readonly property color crit:  error

  function _apply(j) {
    if (j.mError)            error           = j.mError
    if (j.mPrimary)          primary         = j.mPrimary
    if (j.mSecondary)        secondary       = j.mSecondary
    if (j.mSurface)          surface         = j.mSurface
    if (j.mSurfaceVariant)   surfaceVariant  = j.mSurfaceVariant
    if (j.mOnSurface)        fg              = j.mOnSurface
    if (j.mOnSurfaceVariant) fgDim           = j.mOnSurfaceVariant
    if (j.mOutline)          outline         = j.mOutline
  }

  FileView {
    id: file
    path: Quickshell.env("HOME") + "/.config/quickshell/bar/colors.json"
    watchChanges: true
    onFileChanged: reload()
    onLoaded: {
      try { root._apply(JSON.parse(file.text())) }
      catch (e) { console.warn("Theme: bad colors.json:", e) }
    }
  }
}
