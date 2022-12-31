Global CBScreenCapHotkey
Global ScreenCapHotkey

DeathReviewSetup()
Exit

DeathCapture()
{
    SendLevel, 1
    Send, !{f10}
}

DeathReviewSetup()
{
    Gui, Death:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
    Gui, Death:Font, c%Font% s13 Bold
    Width := A_ScreenWidth*.65
    Width := Round(96/A_ScreenDPI*Width)
    Gui, Death:Add, Text, w%Width% +Center, Death Review Settings
    Gui, Death:Font
    Gui, Death:Font, c%Font% s10
    Gui, Death:Add, Text,% dpi("w810" "h1"), Note: For on death review you must enable screen recording in your GPU software (NVIDIA ShadowPlay or AMD ReLive) and setup the hotkey below. A character name is not required but will prevent saving recordings when another player in your group dies. If you use the "Delete Recording" function I highly recommend setting a dedicated folder for saving the your videos, I AM NOT RESPONSIBLE IF YOUR HOMEWORK OR IMPORTANT FILES GET DELETED. 
    Gui, Death:Font, c%Font% s1
    Gui, Maven:Add, GroupBox, w%Width% +Center x0 h1
    Space = y+2
    Gui, Death: -Caption
    Gui, Death:Font, c%Font% s11 Bold Underline
    Gui, Death:Add, Text, xs x10 Section, Hotkey
    Gui, Death:Font
    Gui, Death:Font, c%Font% s%fw%
    Gui, Death:Font, c%Font%
    Gui, Death:Color, %Background%
    #ctrls = 1  ;How many Hotkey controls to add.
    Loop,% #ctrls 
    {
      HotkeyIin := HotkeyIni()
      IniRead, ScreenCapHotkey, %HotkeyIni%, Screen Record, Screen Record, %A_Space%
      ; If %ScreenCapHotkey%                                   ;Check for saved hotkeys in INI file.
      ; Hotkey, %ScreenCapHotkey%, DeathCapture, UseErrorLevel               ;Activate saved hotkeys if found.
      ; StringReplace, noMods, ScreenCapHotkey, ~                  ;Remove tilde (~) and Win (#) modifiers...
      ; StringReplace, noMods, noMods, #,,UseErrorLevel              ;They are incompatible with hotkey controls (cannot be shown).
      Gui, Death:Add, CheckBox, Section xs +Left vCBScreenCapHotkey Checked%ErrorLevel%, Win  ;Add checkboxes to allow the Windows key (#) as a modifier...
      Gui, Death:Add, Hotkey, ys w150 vScreenCapHotkey gSetLabel, %noMods%           ;Add hotkey controls and show saved hotkeys.
    }
  Gui, Death:Add, Button, x20 w50 Section, Close
  Gui, Death:Show, w%Width%, Death Review Settings
  return
}

SetLabel()
{
  If %A_GuiControl% in +,^,!,+^,+!,^!,+^!    ;If the hotkey contains only modifiers, return to wait for a key.
    return
  num := SubStr(A_GuiControl,3)              ;Get the index number of the hotkey control.
  If (ScreenCapHotkey != "") {                       ;If the hotkey is not blank...
    Gui, Hotkey:Submit, NoHide
    If CBScreenCapHotkey                                ;  If the 'Win' box is checked, then add its modifier (#).
    ScreenCapHotkey := "#" ScreenCapHotkey
    If !RegExMatch(ScreenCapHotkey,"[#!\^\+]")        ;  If the new hotkey has no modifiers, add the (~) modifier.
    ScreenCapHotkey := "~" ScreenCapHotkey                   ;    This prevents any key from being blocked.
    Loop,% #ctrls
    {
      GuiControl,,ScreenCapHotkey,% ScreenCapHotkey :=""      ;    Delete the hotkey and clear the control.
      break
    }
  }
  If (savedScreenCapHotkey || ScreenCapHotkey)
    setSC(num, savedScreenCapHotkey, ScreenCapHotkey)
  return
}

SetSC(num,INI,GUI) 
{
  HotkeyPath := HotkeyIni()
  If INI
    Hotkey, %INI%, Label%num%, Off, UseErrorLevel
  If GUI
  Hotkey, %GUI%, Label%num%, On, UseErrorLevel
  IniWrite,% GUI ? GUI:null, %HotkeyPath%, Hotkeys, %num%
  savedHK%num%  := HK%num%
  TrayTip, Map Hotkey Changed, % !INI ? GUI " ON":!GUI ? INI " OFF":GUI " ON`n" INI " OFF"
}

DeathButtonClose()
{
  Gui, Death:Destroy
}

GuiClose()
{
  Gui, Death:Destroy
}