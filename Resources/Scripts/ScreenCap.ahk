Global CBScreenCapHotkey
Global ScreenCapHotkey
Global DeathWatchActive

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
    fw := Round(96/A_ScreenDPI*10)
    Gui, Death:Add, Text, w%Width% +Center, Death Review Settings
    Gui, Death:Font
    Gui, Death:Font, c%Font% s10
    Gui, Death:Add, Text,% dpi("w810" "h1"), Note: For on death review you must enable screen recording in your GPU software (NVIDIA ShadowPlay or AMD ReLive) and setup the hotkey below. A character name is not required but will prevent saving recordings when another player in your group dies. If you use the "Delete Recording" function I highly recommend setting a dedicated folder for saving the your videos, I AM NOT RESPONSIBLE IF YOUR HOMEWORK OR IMPORTANT FILES GET DELETED. 
    Gui, Death:Font, c%Font% s1
    Gui, Death:Add, GroupBox, w%Width% +Center x0 h1
    Space = y+2
    Gui, Death: -Caption
    
    Gui, Death:Font, c%Font% s11 Bold Underline
    Gui, Death:Add, Text, xs x10 Section, Active
    Gui, Death:Font
    Gui, Death:Font, c%Font% s%fw%
    MiscIni := MiscIni()
    IniRead, DeathActive, %MiscIni%, On Death, Active, %A_Space%
    Gui, Death:Add, Checkbox, xs+15 +Center VDeathWatchActive Checked%DeathActive%
    
    Gui, Death:Font, c%Font% s11 Bold Underline
    Gui, Death:Add, Text, ys Section, Hotkey
    Gui, Death:Font
    Gui, Death:Font, c%Font% s%fw%
    Gui, Death:Font, c%Font%
    Gui, Death:Color, %Background%
    #ctrls = 1  ;How many Hotkey controls to add.
    Loop,% #ctrls 
    {
      MiscIni := MiscIni()
      IniRead, ScreenCapHotkey, %MiscIni%, On Death, Screen Record, %A_Space%
       If %ScreenCapHotkey%                                   ;Check for saved hotkeys in INI file.
      Hotkey, %ScreenCapHotkey%, DeathCapture, UseErrorLevel               ;Activate saved hotkeys if found.
      StringReplace, noMods, ScreenCapHotkey, ~                  ;Remove tilde (~) and Win (#) modifiers...
      StringReplace, noMods, noMods, #,,UseErrorLevel              ;They are incompatible with hotkey controls (cannot be shown).
      Gui, Death:Add, CheckBox, Section xs vCBScreenCapHotkey Checked%ErrorLevel%, Win Key  ;Add checkboxes to allow the Windows key (#) as a modifier...
      Gui, Death:Add, Hotkey, xs w80 vScreenCapHotkey gLabel, %noMods%           ;Add hotkey controls and show saved hotkeys.
    }
  Gui, Death:Add, Button, x20 w50 Section, Close
  Gui, Death:Show, w%Width%, Death Review Settings
  return
}

DeathButtonClose()
{
  Gui, Death:Submit
  Gui, Death:Destroy
  MiscIni := MiscIni()
  msgbox,%ScreenCapHotkey%
  IniWrite, %ScreenCapHotkey%, %MiscIni%, On Death, Screen Record
  IniWrite, %DeathWatchActive%, %MiscIni% On Death, Active
}

GuiClose()
{
  Gui, Death:Destroy
}