pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  // --- sizing / typography (single source of truth) ---
  readonly property int  barHeight: 30
  readonly property int  fontSize:  13
  readonly property string fontFamily: "JetBrainsMono Nerd Font"
  readonly property int  radius:    6
  readonly property int  gap:       6      // spacing between widgets
  readonly property int  padH:      8      // horizontal padding inside pills

  // --- colors (populated from colors.json, with Kanagawa fallbacks) ---
  property color error:           "#c34043"
  property color primary:         "#76946a"
  property color secondary:       "#c0a36e"
  property color tertiary:        "#7e9cd8"
  property color surface:         "#1f1f28"
  property color surfaceVariant:  "#2a2a37"
  property color fg:              "#c8c093"
  property color fgDim:           "#717c7c"
  property color outline:         "#363646"

  function _apply(j) {
    if (j.mError)            error           = j.mError
    if (j.mPrimary)          primary         = j.mPrimary
    if (j.mSecondary)        secondary       = j.mSecondary
    if (j.mTertiary)         tertiary        = j.mTertiary
    if (j.mSurface)          surface         = j.mSurface
    if (j.mSurfaceVariant)   surfaceVariant  = j.mSurfaceVariant
    if (j.mOnSurface)        fg              = j.mOnSurface
    if (j.mOnSurfaceVariant) fgDim           = j.mOnSurfaceVariant
    if (j.mOutline)          outline         = j.mOutline
  }

  FileView {
    id: file
    // colors.json sits at the config root, next to shell.qml
    path: Quickshell.env("HOME") + "/.config/quickshell/bar/colors.json"
    watchChanges: true
    onFileChanged: reload()
    onLoaded: {
      try { root._apply(JSON.parse(file.text())) }
      catch (e) { console.warn("Theme: bad colors.json:", e) }
    }
  }
}
