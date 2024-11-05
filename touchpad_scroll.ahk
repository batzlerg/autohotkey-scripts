#Requires AutoHotkey v2.0
#SingleInstance Force

; Configuration
INVERT_SCROLL := true      ; Set to true to invert scroll direction (touch-like)
SCROLL_THRESHOLD := 20     ; Virtual pixels needed to trigger a scroll
RESET_THRESHOLD := 1       ; Physical pixels before resetting cursor position
POLLING_RATE := 16         ; Milliseconds between checks (16ms ≈ 60fps)
SCROLL_MULTIPLIER := 1     ; Number of scroll events per threshold exceeded
ENABLE_DEBUG := false      ; Show debug tooltips
DEBUG_DURATION := 1000     ; How long debug tooltips stay visible (ms)

ShowDebug(text) {
  if (ENABLE_DEBUG) {
    ToolTip(text)
    SetTimer () => ToolTip(), -DEBUG_DURATION
  }
}

~LCtrl:: {
  ; Store initial cursor position
  MouseGetPos(&startX, &startY)
  ShowDebug("Control pressed at: " startX "," startY)

  virtualMovement := 0    ; Track accumulated virtual movement
  lastY := startY        ; Track position for small increments

  while GetKeyState("LCtrl", "P") {
    MouseGetPos(&currentX, &currentY)

    ; Calculate small movement since last position
    incrementalMovement := currentY - lastY

    ; If moved enough to trigger reset
    if (Abs(incrementalMovement) >= RESET_THRESHOLD) {
      ; Accumulate the virtual movement
      virtualMovement += incrementalMovement

      ; Reset cursor position
      MouseMove(startX, lastY)
      lastY := lastY    ; Keep lastY the same since we reset position

      ShowDebug("Virtual movement: " virtualMovement)

      ; Check if virtual movement exceeds scroll threshold
      if (Abs(virtualMovement) >= SCROLL_THRESHOLD) {
        Loop SCROLL_MULTIPLIER {
          if (virtualMovement > 0) {
            Send(INVERT_SCROLL ? "{WheelUp}" : "{WheelDown}")
            ShowDebug("Scroll " (INVERT_SCROLL ? "Up" : "Down") ": " virtualMovement)
          } else {
            Send(INVERT_SCROLL ? "{WheelDown}" : "{WheelUp}")
            ShowDebug("Scroll " (INVERT_SCROLL ? "Down" : "Up") ": " virtualMovement)
          }
        }
        ; Reset virtual movement but maintain direction for remainder
        virtualMovement := Mod(virtualMovement, SCROLL_THRESHOLD)
      }
    }

    Sleep(POLLING_RATE)
  }
}

~LCtrl Up:: {
  ShowDebug("Control released")
}

^Esc:: ExitApp

ShowDebug("Script started - Press Ctrl+Esc to exit")