#SingleInstance force
Global Secondary := "White"
Global Background := "White"
Global Font := "Black"
Global IconColor := "C:\Users\drwsi\Documents\PoE Mechanic Watch\PoE-Mechanic-Watch\Resources\Images\volume.png"
Global PlayColor := "C:\Users\drwsi\Documents\PoE Mechanic Watch\PoE-Mechanic-Watch\Resources\Images\play.png"
Global Edit
Global SoundButtonChange
Test()
{
    Exit
}
SoundsButtonChange()
{
    Exit
}
NotificationSetup()
Exit

NotificationSetup()
{
    Gui, NotificationSettings:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
    Gui, NotificationSettings:Font, c%Font% s13 Bold
    Width := A_ScreenWidth*.5
    Width := Round(96/A_ScreenDPI*Width)
    TW := Width - 20
    fw := Round(96/A_ScreenDPI*12)
    fw1 := Round(96/A_ScreenDPI*15)
    fw2 := Round(96/A_ScreenDPI*11)
    fw3 := Round(96/A_ScreenDPI*355)
    SpeakerButton := Round(96/A_ScreenDPI*400)
    PlayButton := Round(96/A_ScreenDPI*440)
    Edit := Round(96/A_ScreenDPI*470)

    Gui, NotificationSettings:Add, Text, w%Width% +Center, Notification Settings
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font% s1
    Gui, NotificationSettings:Add, GroupBox, w%Width% +Center x0 h1
    Space = y+2
    Gui, NotificationSettings: -Caption
    
    ; Headings 
    Gui, NotificationSettings:Font, c%Font% s%fw1% Bold Underline
    Gui, NotificationSettings:Add, Text, xs x25 Section, Notification Type
    Gui, NotificationSettings:Add, Text, x+50 ys, Enabled
    Gui, NotificationSettings:Add, Text, x+20 ys, Sound Settings
    Gui, NotificationSettings:Add, Text, x+80 ys, Transparency Settings

    ; Sub Headings
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font% s%fw2%
    Gui, NotificationSettings:Add, Text, xs+252 Section, Active
    Gui, NotificationSettings:Add, Text, x+5 ys, Sound
    Gui, NotificationSettings:Add, Text, x+5 ys, Test
    Gui, NotificationSettings:Add, Text, x+10 ys, Volume

    ; Overlay Section
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Add, Text, xs y-2 x25, 
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font%
    Gui, NotificationSettings:Add, GroupBox, w%Width% +Center x5 h30
    Gui, NotificationSettings:Font, cBlack s%fw% Bold
    Gui, NotificationSettings:Add, Text, yp+10 x25 Section, Overlay
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Add, Checkbox, ys+1 x%fw3% Checked1
    Gui, NotificationSettings:Add, Picture, gSoundsButtonChange%Item% ys-1 x%SpeakerButton% w15 h15, %IconColor%
    Gui, NotificationSettings:Add, Picture, gtest%Item% ys-1 x%PlayButton% w15 h15, %PlayColor%
    Gui, NotificationSettings:Font, cWhite
    Gui, NotificationSettings:Color, Edit, %Secondary% -Caption -Border
    Gui, NotificationSettings:Add, Edit, Center ys-2 x%Edit% h20 w50 v%Item%Edit
    Gui, NotificationSettings:Add, UpDown, Range0-100, %ItemVolume% x270 h20  




    Gui, NotificationSettings:Font, cBlack s%fw% Bold
    Gui, NotificationSettings:Add, Text, xs x25, Map Notification
    Gui, NotificationSettings:Add, Text, xs x25, Mechanic Notification

    Gui, NotificationSettings:Add, Text, xs x25, Influence Notification

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
 
    Gui, NotificationSettings:Font, c%Font% s%fw1% Bold Underline

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

  Gui, NotificationSettings:Font
  Gui, NotificationSettings:Font, c%Font% s8

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


; Volume Part
NotificationTypes()
{
    Return, "Notification|Influence"
}