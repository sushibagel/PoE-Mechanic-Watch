Global CBScreenCapHotkey
Global ScreenCapHotkey
Global DeathWatchActive
Global DeathPrompt 
Global CharacterName
Global StorageLocation
Global CB1

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
    Gui, Death:Add, Text, Wrap w%TW%, Note: For on death review you must enable screen recording in your GPU software (NVIDIA ShadowPlay or AMD ReLive) and setup the hotkey below. A character name is not required but will prevent saving recordings when another player in your group dies, the name put in the Character Name box just needs to contain  part of your character's name this will allow you to reduce accidental triggers while not having to change the setting for every character (Example: if you put in ChrisWilson: ChrisWilson123, ChrisWilsonRules, ImChrisWilson will all work). If you use the "Delete Recording" function I highly recommend setting a dedicated folder for saving the your videos, I AM NOT RESPONSIBLE IF YOUR HOMEWORK OR IMPORTANT FILES GET DELETED. 
    Gui, Death:Font, c%Font% s1
    Gui, Death:Add, GroupBox, w%Width% +Center x0 h1
    Space = y+2
    Gui, Death: -Caption
    
    Gui, Death:Font, c%Font% s11 Bold Underline
    Gui, Death:Add, Text, xs x25 Section, Active
    Gui, Death:Font
    Gui, Death:Font, c%Font% s%fw%
    MiscIni := MiscIni()
    IniRead, DeathActive, %MiscIni%, On Death, Active, 0
    Gui, Death:Add, Checkbox, xs+15 +Center VDeathWatchActive Checked%DeathActive%
    Gui, Death:Font, c%Font% s11 Bold Underline
    Gui, Death:Add, Text, xs, Prompt
    Gui, Death:Font
    Gui, Death:Font, c%Font% s%fw%
    IniRead, DeathPrompt, %MiscIni%, On Death, Prompt, 0
    Gui, Death:Add, Checkbox, xs+15 +Center VDeathPrompt Checked%DeathPrompt%
    
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
  StorageLocationWidth := Width - 150
  Gui, Death:Font, c%Font% s11 Bold Underline
  Location := Round(96/A_ScreenDPI*80)
  Location := Width/2 - Location 
  Gui, Death:Add, Text, x%Location%, Storage Location
  Gui, Death:Font
  Gui, Death:Font, cBlack s8
  IniRead, StorageLocation, %A_ScriptDir%\Resources\Settings\Misc.Ini, On Death, Storage Location
  Gui, Death:Add, Edit, x25 Section Center w%StorageLocationWidth% vStorageLocation, %StorageLocation%
  Gui, Death:Add, Button, ys w80, Change

  Gui, Death:Font, c%Font% s1
  Gui, Death:Add, GroupBox, w%Width% +Center x0 h1
  Gui, Death:Font, c%Font% s10
  Gui, Death:Add, Link, x10 -Wrap w%TW%, For instructions on NVIDIA GeForce Experience Setup click <a href="https://beebom.com/how-setup-instant-replay-geforce-experience/">HERE</a>
  AMDLink := "https://www.amd.com/en/support/kb/faq/dh-023#:~:text=To%20use%20Radeon%20ReLive%2C%20it,setting%20the%20feature%20to%20On."
  Gui, Death:Add, Link, x10 w%TW%, For instructions on AMD Adrenaline Setup click <a href="%AMDLink%">HERE</a>

  Gui, Death:Font, c%Font% s10
  Gui, Death:Add, Button, x20 w50, Close
  Gui, Death:Show, w%Width%, Death Review Settings
  Return
}

DeathButtonClose()
{
  Gui, Death:Submit
  Gui, Death:Destroy
  MiscIni := MiscIni()
  IniWrite, %ScreenCapHotkey%, %MiscIni%, On Death, Screen Record
  IniWrite, %DeathWatchActive%, %MiscIni%, On Death, Active
  IniWrite, %CharacterName%, %MiscIni%, On Death, Character Name
  IniWrite, %DeathPrompt%, %MiscIni%, On Death, Prompt
  IniWrite, %StorageLocation%, %A_ScriptDir%\Resources\Settings\Misc.Ini, On Death, Storage Location
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
  IniRead, StorageLocation, %A_ScriptDir%\Resources\Settings\Misc.Ini, On Death, Storage Location
  IniRead, Prompt, %MiscIni%, On Death, Prompt, 0
  IniRead, Delay, %MiscIni%, On Death, Delay, 0
  Sleep, %Delay%
  If InStr(Newline, CharacterName) and (OnDeathActive = 1)
  {
    Loop, 24
    {
      FKey := "f" A_Index
      If InStr(DeathHotkey, FKey) and !InStr(DeathHotkey, 0)
      {
        DeathHotkey1 := StrReplace(DeathHotkey, FKey, "{" FKey "}" )
      }
    }
    If !(DeathHotkey1 = "")
    {
      DeathHokey := Deathhokey1
    }
    SendLevel, 1
    Send, !{f10} ;%DeathHotkey%
    If (Prompt = 1)
    {
      OnDeathPrompt()
    }
  }
}

DeathButtonChange()
{
  DeathButtonClose()
  Gui, Death:Destroy
  FileSelectFolder, NewFolder,, 2, Select the folder where your recordings are stored. 
  MiscIni := MiscIni()
  IniWrite, %NewFolder%, %A_ScriptDir%\Resources\Settings\Misc.Ini, On Death, Storage Location
  DeathReviewSetup()
}

OnDeathPrompt()
{
  If WinActive!("Notification Settings")
  {
    Sleep, 3000
  }
  Gui, Recap:Destroy
  CheckTheme()
  NotificationHeight := (A_ScreenHeight / 2) - 100
  TransparencyFile := TransparencyIni()
  IniRead, NotificationTransparency, %TransparencyFile%, Transparency, Recap, 255
  Gui, Recap:Font, c%Font% s12
  Gui, Recap:Add, Text,,You just died! Would you like to see what happened? 
  Gui, Recap:Font, s10
  Gui, Recap:Color, %Background%
  Gui, Recap:+AlwaysOnTop -Border
  NotificationIni := NotificationIni()
  IniRead, NotificationActive, %NotificationIni%, Active, Recap, 1
  If (NotificationActive = 1)
  {
    Gui, Recap:Show, NoActivate y%NotificationHeight%, Death Recap
  }
  DetectHiddenWindows, On
  WinGetPos,xpos,, Width, Height, Death Recap
  bx := Width/2
  bx := Round(96/A_ScreenDPI*bx)
  bx2 := bx - 150
  bx3 := bx + 50
  bx := bx-50
  Gui, Recap:Hide
  WinSet, Style, -0xC00000, Recap
  gheight := height + Round(96/A_ScreenDPI*60)
  If WinExist("Notification Settings")
  {
      NotificationHeight := 850
  }
  Gui, Recap:Add, Text, xn Section, %A_Space%
  Gui, Recap:Add, Button, xn x%bx2% Section w50, Yes
  Gui, Recap:Add, Button, x%bx% ys w50, No
  Gui, Recap:Add, Button, x%bx3% ys, Delete and Close
  Gui, Recap:+AlwaysOnTop -Border
  If (NotificationActive = 1)
  {
    Gui, Recap:Show, y%NotificationHeight% h%gheight% NoActivate, Death Recap
    WinSet, Style, -0xC00000, Death Recap
    WinSet, Transparent, %NotificationTransparency%, Death Recap
  }
  NotificationPrep("Recap")
  IniRead, SoundActive, %NotificationIni%, Sound Active, Recap
  If (SoundActive = 1)
  {
      SoundPlay, Resources\Sounds\blank.wav ;;;;; super hacky workaround but works....
      SetTitleMatchMode, 2
      WinGet, AhkExe, ProcessName, Reminder
      SetTitleMatchMode, 1
      SetWindowVol(AhkExe, NotificationVolume)
      SoundPlay, %NotificationSound%
  }
  Return
}

RecapButtonYes()
{
  Gui, Recap:Destroy
  FullPath := GetLastFile()
  Run,  %FullPath%
  WinWaitActive, Path of Exile
  PromptDelete()
}

RecapButtonNo()
{
  Gui, Recap:Destroy
}

RecapButtonDeleteandClose()
{
  Gui, Recap:Destroy
  FullPath := GetLastFile()
  FileDelete, %FullPath%
}

GetLastFile()
{
  MiscIni := MiscIni()
  IniRead, StorageLocation, %A_ScriptDir%\Resources\Settings\Misc.Ini, On Death, Storage Location

   Loop, %StorageLocation%\*
  {
    FileGetTime, Time, %A_LoopFileFullPath%, C
    If (Time > Time_Orig)
    {
          Time_Orig := Time
          File := A_LoopFileName
    }
  }
  FullPath=%StorageLocation%\%File%
  Return, %FullPath%
}

PromptDelete()
{
  Gui, PromptDelete:Destroy
  CheckTheme()
  NotificationHeight := (A_ScreenHeight / 2) - 100
  TransparencyFile := TransparencyIni()
  IniRead, NotificationTransparency, %TransparencyFile%, Transparency, Recap, 255
  Gui, PromptDelete:Font, c%Font% s12
  Gui, PromptDelete:Add, Text,, Welcome back! Do you want to delete that video?
  Gui, PromptDelete:Font, s10
  Gui, PromptDelete:Color, %Background%
  Gui, PromptDelete:+AlwaysOnTop -Border
  Gui, PromptDelete:Show, NoActivate y%NotificationHeight%, Prompt Delete
  DetectHiddenWindows, On
  WinGetPos,xpos,, Width, Height, Prompt Delete
  bx := Width/2
  bx := Round(96/A_ScreenDPI*bx)
    bx2 := bx - 100
    bx := bx + 50
  Gui, PromptDelete:Hide
  WinSet, Style, -0xC00000, Prompt Delete
  gheight := height + (96/A_ScreenDPI*55)
  If WinExist("Notification Settings")
  {
      NotificationHeight := 850
  }
  Gui, PromptDelete:Font, s5
  Gui, PromptDelete:Add, Text, xn Section, %A_Space%
  Gui, PromptDelete:Font, s10
  Gui, PromptDelete:Add, Button, xn x%bx2% Section w50, Yes
  Gui, PromptDelete:Add, Button, x%bx% ys w50 Section, No
  Gui, PromptDelete:+AlwaysOnTop -Border
  Gui, PromptDelete:Show, y%NotificationHeight% h%gheight% NoActivate, Prompt Delete
  WinSet, Style, -0xC00000, Prompt Delete
  WinSet, Transparent, %NotificationTransparency%, Prompt Delete
}

PromptDeleteButtonNo()
{
  Gui, PromptDelete:Destroy
}

PromptDeleteButtonYes()
{
  Gui, PromptDelete:Destroy
  FullPath := GetLastFile()
  FileDelete, %FullPath%
}