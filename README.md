# AutoHotkey Scripts

This repository contains various AutoHotkey utility scripts that I personally use on my Windows machine.

## Running scripts on Windows startup

1. Press **Windows + R** to open the Run dialog
2. Type `shell:startup` and press Enter to open the Windows Startup folder
3. Create shortcuts for any scripts you want to run at startup:
   - Right-click on the `.ahk` script file (e.g., `touchpad_scroll.ahk`)
   - Drag it to the Startup folder
   - Select "Create shortcut here" when you release the right mouse button

Example:
```powershell
# Path to startup folder
%AppData%\Microsoft\Windows\Start Menu\Programs\Startup\touchpad_scroll.ahk - Shortcut
```