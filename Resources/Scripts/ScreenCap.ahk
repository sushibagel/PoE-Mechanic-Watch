Global CBScreenCapHotkey
Global ScreenCapHotkey
Global DeathWatchActive
Global CharacterName
Global CB1

DeathReviewSetup()
Exit

DeathReviewSetup()
{
    Gui, Death:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
    Gui, Death:Font, c%Font% s13 Bold
    Width := A_ScreenWidth*.29
    Width := Round(96/A_ScreenDPI*Width)
    TW := Width - 20
    fw := Round(96/A_ScreenDPI*10)
    Gui, Death:Add, Text, w%Width% +Center, Death Review Settings
    Gui, Death:Font
    Gui, Death:Font, c%Font% s10
    Gui, Death:Add, Text, Wrap w%TW%, Note: For on death review you must enable screen recording in your GPU software (NVIDIA ShadowPlay or AMD ReLive) and setup the hotkey below. A character name is not required but will prevent saving recordings when another player in your group dies. If you use the "Delete Recording" function I highly recommend setting a dedicated folder for saving the your videos, I AM NOT RESPONSIBLE IF YOUR HOMEWORK OR IMPORTANT FILES GET DELETED. 
    Gui, Death:Font, c%Font% s1
    Gui, Death:Add, GroupBox, w%Width% +Center x0 h1
    Space = y+2
    Gui, Death: -Caption
    
    Gui, Death:Font, c%Font% s11 Bold Underline
    Gui, Death:Add, Text, xs x25 Section, Active
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
      Gui, Death:Add, CheckBox, xs vCB1 Checked%ErrorLevel%, Win Key  ;Add checkboxes to allow the Windows key (#) as a modifier...
      Gui, Death:Add, Hotkey, xs w80 vScreenCapHotkey gLabel, %noMods%           ;Add hotkey controls and show saved hotkeys.
    }
  
  IniRead, CharacterName, %MiscIni%, On Death, Character Name
  Gui, Death:Font, c%Font% s11 Bold Underline
  Gui, Death:Add, Text, ys Section w200 Center, Character Name
  Gui, Death:Font
  Gui, Death:Font, c%Font% s8
  Gui, Death:Add, Text, xs w200 Center, (Not Required)
  Gui, Death:Font, cBlack s8
  Gui, Death:Add, Edit, Center w200 vCharacterName, %CharacterName%

  Gui, Death:Font, c%Font% s1
  Gui, Death:Add, GroupBox, w%Width% +Center x0 h1
  Gui, Death:Font, c%Font% s10
  Gui, Death:Add, Link, x10 -Wrap w%TW%, For instructions on NVIDIA GeForce Experience Setup click <a href="https://beebom.com/how-setup-instant-replay-geforce-experience/">HERE</a>
  AMDLink := "https://www.amd.com/en/support/kb/faq/dh-023#:~:text=To%20use%20Radeon%20ReLive%2C%20it,setting%20the%20feature%20to%20On."
  Gui, Death:Add, Link, x10 w%TW%, For instructions on AMD Adrenaline Setup click <a href="%AMDLink%">HERE</a>

  Gui, Death:Font, c%Font% s10
  Gui, Death:Add, Button, x20 w50, Close
  Gui, Death:Show, w%Width%, Death Review Settings
  return
}

DeathButtonClose()
{
  Gui, Death:Submit
  Gui, Death:Destroy
  MiscIni := MiscIni()
  IniWrite, %ScreenCapHotkey%, %MiscIni%, On Death, Screen Record
  IniWrite, %DeathWatchActive%, %MiscIni%, On Death, Active
  IniWrite, %CharacterName%, %MiscIni%, On Death, Character Name
}

GuiClose()
{
  Gui, Death:Destroy
}

OnDeath(Newline)
{
  MiscIni := MiscIni()
  IniRead, OnDeathActive, %MiscIni%, On Death, Active
  IniRead, DeathHotkey, %MiscIni%, On Death, Screen Record
  IniRead, CharacterName, %MiscIni%, On Death, Character Name, %A_Space%
  If Instr(NewLine, %CharacterName%) and (OnDeathActive = 1)
  {
    msgbox, test
    SendLevel, 1
    Send, !{f10}
  }
}