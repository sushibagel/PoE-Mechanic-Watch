Font := "Black"
NotificationSetup()
Exit

NotificationSetup()
{
    Gui, NotificationSettings:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
    Gui, NotificationSettings:Font, c%Font% s13 Bold
    Width := A_ScreenWidth*.29
    Width := Round(96/A_ScreenDPI*Width)
    TW := Width - 20
    fw := Round(96/A_ScreenDPI*12)
    fw1 := Round(96/A_ScreenDPI*15)
    fw2 := Round(96/A_ScreenDPI*11)
    Gui, NotificationSettings:Add, Text, w%Width% +Center, Notification Settings
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font% s1
    Gui, NotificationSettings:Add, GroupBox, w%Width% +Center x0 h1
    Space = y+2
    Gui, NotificationSettings: -Caption
    
    Gui, NotificationSettings:Font, c%Font% s%fw1% Bold Underline
    Gui, NotificationSettings:Add, Text, xs x25 Section, Notification Type
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, cBlack s%fw% Bold
    Gui, NotificationSettings:Add, Text, xs x25, 
    Gui, NotificationSettings:Add, Text, xs x25, Mechanic Notification
    Gui, NotificationSettings:Add, Text, xs x25, Influence Notification
    Gui, NotificationSettings:Add, Text, xs x25, Map Notification
    Gui, NotificationSettings:Add, Text, xs x25, Maven Notification
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, cBlack s%fw2%
    Gui, NotificationSettings:Add, Text, xs x25, The Formed Notification
    Gui, NotificationSettings:Add, Text, xs x25, The Forgotten Notification
    Gui, NotificationSettings:Add, Text, xs x25, The Feared Notification
    Gui, NotificationSettings:Add, Text, xs x25, The Twisted Notification
    Gui, NotificationSettings:Add, Text, xs x25, The Hidden Notification
    Gui, NotificationSettings:Add, Text, xs x25, The Elderslayers Notification

    
    Gui, NotificationSettings:Font, c%Font% s%fw1% Bold Underline
    Gui, NotificationSettings:Add, Text, ys Section, Sound Settings
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font% s%fw%
    Gui, NotificationSettings:Font, c%Font%
    Gui, NotificationSettings:Color, %Background%
    #ctrls = 1  ;How many Hotkey controls to add.
    Loop,% #ctrls 
    {
    ;   MiscIni := MiscIni()
      IniRead, ScreenCapHotkey, %MiscIni%, On Death, Screen Record, %A_Space%
      If %ScreenCapHotkey%                                   ;Check for saved hotkeys in INI file.
      Hotkey, %ScreenCapHotkey%, DeathCapture, UseErrorLevel               ;Activate saved hotkeys if found.
      StringReplace, noMods, ScreenCapHotkey, ~                  ;Remove tilde (~) and Win (#) modifiers...
      StringReplace, noMods, noMods, #,,UseErrorLevel              ;They are incompatible with hotkey controls (cannot be shown).
    ;   Gui, NotificationSettings:Add, CheckBox, xs vCB1 Checked%ErrorLevel%, Win Key  ;Add checkboxes to allow the Windows key (#) as a modifier...
    ;   Gui, NotificationSettings:Add, Hotkey, xs w80 vScreenCapHotkey gLabel, %noMods%           ;Add hotkey controls and show saved hotkeys.
    }
  
  IniRead, CharacterName, %MiscIni%, On Death, Character Name
  Gui, NotificationSettings:Font, c%Font% s%fw1% Bold Underline
  Gui, NotificationSettings:Add, Text, ys Section w200 Center, Transparency Settings
  Gui, NotificationSettings:Font
  Gui, NotificationSettings:Font, c%Font% s8
  Gui, NotificationSettings:Add, Text, xs w200 Center, (Not Required)
  Gui, NotificationSettings:Font, cBlack s8
;   Gui, NotificationSettings:Add, Edit, Center w200 vCharacterName, %CharacterName%

  Gui, NotificationSettings:Font, c%Font% s1
  Gui, NotificationSettings:Add, GroupBox, w%Width% +Center x0 h1
  Gui, NotificationSettings:Font, c%Font% s10
  Gui, NotificationSettings:Add, Link, x10 -Wrap w%TW%, For instructions on NVIDIA GeForce Experience Setup click <a href="https://beebom.com/how-setup-instant-replay-geforce-experience/">HERE</a>
  AMDLink := "https://www.amd.com/en/support/kb/faq/dh-023#:~:text=To%20use%20Radeon%20ReLive%2C%20it,setting%20the%20feature%20to%20On."
  Gui, NotificationSettings:Add, Link, x10 w%TW%, For instructions on AMD Adrenaline Setup click <a href="%AMDLink%">HERE</a>

  Gui, NotificationSettings:Font, c%Font% s10
  Gui, NotificationSettings:Add, Button, x20 w50, Close
  Gui, NotificationSettings:Show, , Notification Settings
  Return
}

NotificationSettingsButtonClose(){
    Gui, NotificationSettings:Destroy
}