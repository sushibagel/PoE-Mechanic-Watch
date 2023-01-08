Global Edit
Global Edit2
Global Edit3
Global Edit4
Global Edit5
Global Edit6
Global Edit7
Global Edit8
Global Edit9
Global Edit10
Global OverlayTran
Global QuickActive
Global QuickSoundActive
Global QuickVolume
Global QuickTran
Global NotificationTran
Global NotificationActive
Global NotificationSoundActive
Global NotificationVolume
Global InfluenceActive
Global InfluenceSoundActive
Global InfluenceTran
Global InfluenceVolume
Global RecapActive
Global RecapSoundActive
Global RecapTran
Global RecapVolume

Global MavenTran
Global SoundButtonChange
Global FormedCheck
Global ForgottenCheck
Global FearedCheck
Global TwistedCheck
Global HiddenCheck
Global ElderslayersCheck

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
    Gui, NotificationSettings:Destroy
    If (ColorMode = "Dark")
    {
        IconColor = Resources/Images/volume white.png
        RefreshColor = Resources/Images/refresh white.png
        PlayColor = Resources/Images/play white.png
        StopColor = Resources/Images/stop white.png
    }
    If (ColorMode = "Light")
    {
        IconColor = Resources/Images/volume.png
        RefreshColor = Resources/Images/refresh.png
        PlayColor = Resources/Images/play.png
        StopColor = Resources/Images/stop.png
    }
    TransparencyFile := TransparencyIni()
    NotificationIni := NotificationIni()
    Gui, NotificationSettings:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
    Gui, NotificationSettings:Font, c%Font% s13 Bold
    Width := A_ScreenWidth*.53
    Width := Round(96/A_ScreenDPI*Width)
    BoxH := Round(96/A_ScreenDPI*43)
    Box:= Width - Round(96/A_ScreenDPI*12)
    BoxHeight := Round(96/A_ScreenDPI*210)
    TW := Width - 20
    fw := Round(96/A_ScreenDPI*12)
    fw1 := Round(96/A_ScreenDPI*15)
    fw2 := Round(96/A_ScreenDPI*11)
    Check1 := Round(96/A_ScreenDPI*285)
    Check2 := Round(96/A_ScreenDPI*355)
    SpeakerButton := Round(96/A_ScreenDPI*400)
    PlayButton := Round(96/A_ScreenDPI*440)
    Edit := Round(96/A_ScreenDPI*470)
    PlayButton2 := Round(96/A_ScreenDPI*570)
    StopButton := Round(96/A_ScreenDPI*625)
    Edit2 := Round(96/A_ScreenDPI*665)
    Offset := Round(96/A_ScreenDPI*0)
    EditOffset := Round(96/A_ScreenDPI*1)
    ActiveOffset := Round(96/A_ScreenDPI*315)
    TextOffset := Round(96/A_ScreenDPI*14)
    MavenInvitations := Round(96/A_ScreenDPI*25)

    Gui, NotificationSettings:Add, Text, w%Width% +Center, Notification Settings
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font% s1
    Gui, NotificationSettings:Add, GroupBox, w%Width% +Center x0 h1
    Space = y+2
    Gui, NotificationSettings: -Caption
    
    ; Headings 
    Gui, NotificationSettings:Font, c%Font% s%fw1% Bold Underline
    Gui, NotificationSettings:Add, Text, xs x25 Section, Notification Type
    XOff := Round(96/A_ScreenDPI*50)
    Gui, NotificationSettings:Add, Text, x+%XOff% ys, Enabled
    XOff := Round(96/A_ScreenDPI*30)
    Gui, NotificationSettings:Add, Text, x+%XOff% ys, Sound Settings
    XOff := Round(96/A_ScreenDPI*45)
    Gui, NotificationSettings:Add, Text, x+%XOff% ys, Transparency Settings
    XOff := Round(96/A_ScreenDPI*33)
    Gui, NotificationSettings:Add, Text, x+%XOff% ys, Additional Settings

    ; Sub Headings
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font% s%fw2%
    Gui, NotificationSettings:Add, Text, xs+%ActiveOffset% Section, Active
    XOff := Round(96/A_ScreenDPI*5)
    Gui, NotificationSettings:Add, Text, x+%XOff% ys, Sound
    Gui, NotificationSettings:Add, Text, x+%XOff% ys, Test
    XOff := Round(96/A_ScreenDPI*10)
    Gui, NotificationSettings:Add, Text, x+%XOff% ys, Volume
    XOff := Round(96/A_ScreenDPI*50)
    Gui, NotificationSettings:Add, Text, x+%XOff% ys, Test
    XOff := Round(96/A_ScreenDPI*20)
    Gui, NotificationSettings:Add, Text, x+%XOff% ys, Close
    Gui, NotificationSettings:Add, Text, x+%XOff% ys Section, Opacity
    XOff := Round(96/A_ScreenDPI*15)
    Gui, NotificationSettings:Add, Text, xs-1 ys+%XOff% Section, (0 to 255)

    ; Overlay Section
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Add, Text, xs y-2 x25, 
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font%
    Gui, NotificationSettings:Add, GroupBox, w%Box% +Center x5 h%Boxh%
    Gui, NotificationSettings:Font, c%Font% s%fw% Bold
    Gui, NotificationSettings:Add, Text, yp+%TextOffset% x25 Section, Overlay
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%Check1% Checked1 Disabled
    Gui, NotificationSettings:Add, Picture, gOverlayTest ys-%Offset% x%PlayButton2% w15 h15, %PlayColor%
    Gui, NotificationSettings:Add, Picture, gOverlayStop ys-%Offset% x%StopButton% w15 h15, %StopColor%
    Gui, NotificationSettings:Font, cBlack 
    IniRead, Value, %TransparencyFile%, Transparency, Overlay, 255
    Gui, NotificationSettings:Add, Edit, Center ys-%EditOffset% x%Edit2% h20 w50 vOverlayTran
    Gui, NotificationSettings:Add, UpDown, Range0-255, %Value% x270 h20 
    XOff := Round(96/A_ScreenDPI*815) 
    Gui, NotificationSettings:Add, Button, gOverlaySettings ys+%Offset% x%XOff% w50, Layout
    Gui, NotificationSettings:Add, Button, gMove ys+%Offset% w50, Move

; Quick Notification Section
    NotificaitonIni := NotificationIni()
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font%
    Gui, NotificationSettings:Add, GroupBox, w%Box% +Center x5 h%Boxh%
    Gui, NotificationSettings:Font, c%Font% s%fw% Bold
    Gui, NotificationSettings:Add, Text, yp+%TextOffset% x25 Section, Quick Notification
    Gui, NotificationSettings:Font
    IniRead, QuickActive, %NotificationIni%, Active, Quick, 1
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%Check1% Checked%QuickActive% vQuickActive
    IniRead, Value, %NotificationIni%, Sound Active, Quick, 0
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%Check2% Checked%Value% vQuickSoundActive
    IniRead, QuickSound, %NotificationIni%, Sounds, Quick
    Gui, NotificationSettings:Add, Picture, ys-%Offset% x%SpeakerButton% w15 h15 gSoundButtonQuick, %IconColor%
    Gui, NotificationSettings:Add, Picture, gTestQuickSound ys-%Offset% x%PlayButton% w15 h15, %PlayColor%
    Gui, NotificationSettings:Font, cBlack
    Gui, NotificationSettings:Color, Edit, %Secondary% -Caption -Border
    IniRead, Value, %NotificationIni%, Volume, Quick, 100
    Gui, NotificationSettings:Add, Edit, Center ys-%Offset% x%Edit% h20 w50 vQuickVolume
    Gui, NotificationSettings:Add, UpDown, Range0-100, %Value% x270 h20  
    Gui, NotificationSettings:Add, Picture, gQuickTest ys-%Offset% x%PlayButton2% w15 h15, %PlayColor%
    Gui, NotificationSettings:Add, Picture, gQuickStop ys-%Offset% x%StopButton% w15 h15, %StopColor%
    IniRead, Value, %TransparencyFile%, Transparency, Quick, 255
    Gui, NotificationSettings:Add, Edit, Center ys-%Offset% x%Edit2% h20 w50 vQuickTran
    Gui, NotificationSettings:Add, UpDown, Range0-255, %Value% x270 h20  
    XOff := Round(96/A_ScreenDPI*855) 
    Gui, NotificationSettings:Add, Button, gMoveMap ys+%Offset% x%XOff% w50, Move

; Mechanic Notification Section
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font%
    Gui, NotificationSettings:Add, GroupBox, w%Box% +Center x5 h%Boxh%
    Gui, NotificationSettings:Font, c%Font% s%fw% Bold
    Gui, NotificationSettings:Add, Text, yp+%TextOffset% x25 Section, Death Recap
    Gui, NotificationSettings:Font
    MiscIni := MiscIni()
    IniRead, Value, %MiscIni%, On Death, Active, 0
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%Check1% Checked%Value% vRecapActive
    IniRead, Value, %NotificationIni%, Sound Active, Recap, 0
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%Check2% Checked%Value% vRecapSoundActive
    Gui, NotificationSettings:Add, Picture, gSoundsButtonRecap ys-%Offset% x%SpeakerButton% w15 h15, %IconColor%
    Gui, NotificationSettings:Add, Picture, gTestRecapSound ys-%Offset% x%PlayButton% w15 h15, %PlayColor%
    Gui, NotificationSettings:Font, cBlack
    Gui, NotificationSettings:Color, Edit, %Secondary% -Caption -Border
    IniRead, Value, %NotificationIni%, Volume, Recap, 100
    Gui, NotificationSettings:Add, Edit, Center ys-%Offset% x%Edit% h20 w50 vRecapVolume
    Gui, NotificationSettings:Add, UpDown, Range0-100, %Value% x270 h20  
    Gui, NotificationSettings:Add, Picture, gRecapTest ys-%Offset% x%PlayButton2% w15 h15, %PlayColor% 
    Gui, NotificationSettings:Add, Picture, gRecapStop ys-%Offset% x%StopButton% w15 h15, %StopColor% 
    IniRead, Value, %TransparencyFile%, Transparency, Recap, 255
    Gui, NotificationSettings:Add, Edit, Center ys-%Offset% x%Edit2% h20 w50 vRecapTran
    Gui, NotificationSettings:Add, UpDown, Range0-255, %Value% x270 h20 

; Mechanic Notification Section
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font%
    Gui, NotificationSettings:Add, GroupBox, w%Box% +Center x5 h%Boxh%
    Gui, NotificationSettings:Font, c%Font% s%fw% Bold
    Gui, NotificationSettings:Add, Text, yp+%TextOffset% x25 Section, Mechanic Notification
    Gui, NotificationSettings:Font
    IniRead, Value, %NotificationIni%, Active, Notification, 1
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%Check1% Checked%Value% vNotificationActive
    IniRead, Value, %NotificationIni%, Sound Active, Notification, 0
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%Check2% Checked%Value% vNotificationSoundActive
    Gui, NotificationSettings:Add, Picture, gSoundsButtonNotification ys-%Offset% x%SpeakerButton% w15 h15, %IconColor%
    Gui, NotificationSettings:Add, Picture, gTestNotificationSound ys-%Offset% x%PlayButton% w15 h15, %PlayColor%
    Gui, NotificationSettings:Font, cBlack
    Gui, NotificationSettings:Color, Edit, %Secondary% -Caption -Border
    IniRead, Value, %NotificationIni%, Volume, Notification, 100
    Gui, NotificationSettings:Add, Edit, Center ys-%Offset% x%Edit% h20 w50 vNotificationVolume
    Gui, NotificationSettings:Add, UpDown, Range0-100, %Value% x270 h20  
    Gui, NotificationSettings:Add, Picture, gNotificationTest ys-%Offset% x%PlayButton2% w15 h15, %PlayColor% 
    Gui, NotificationSettings:Add, Picture, gNotificationStop ys-%Offset% x%StopButton% w15 h15, %StopColor% 
    IniRead, Value, %TransparencyFile%, Transparency, Notification, 255
    Gui, NotificationSettings:Add, Edit, Center ys-%Offset% x%Edit2% h20 w50 vNotificationTran
    Gui, NotificationSettings:Add, UpDown, Range0-255, %Value% x270 h20 

; Influence Notification Section
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font%
    Gui, NotificationSettings:Add, GroupBox, w%Box% +Center x5 h%Boxh%
    Gui, NotificationSettings:Font, c%Font% s%fw% Bold
    Gui, NotificationSettings:Add, Text, yp+%TextOffset% x25 Section, Influence Notification
    Gui, NotificationSettings:Font
    IniRead, Value, %NotificationIni%, Active, Influence, 1
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%Check1% Checked%Value% vInfluenceActive
    IniRead, Value, %NotificationIni%, Sound Active, Influence, 0
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%Check2% Checked%Value% vInfluenceSoundActive
    Gui, NotificationSettings:Add, Picture, gSoundsButtonInfluence ys-%Offset% x%SpeakerButton% w15 h15, %IconColor%
    Gui, NotificationSettings:Add, Picture, gTestInfluenceSound ys-%Offset% x%PlayButton% w15 h15, %PlayColor%
    Gui, NotificationSettings:Font, cBlack
    Gui, NotificationSettings:Color, Edit, %Secondary% -Caption -Border
    Gui, NotificationSettings:Add, Edit, Center ys-%Offset% x%Edit% h20 w50 vInfluenceVolume
    IniRead, Value, %NotificationIni%, Volume, Notification, 100
    Gui, NotificationSettings:Add, UpDown, Range0-100, %Value% x270 h20  
    Gui, NotificationSettings:Add, Picture, gInfluenceTest ys-%Offset% x%PlayButton2% w15 h15, %PlayColor%
    Gui, NotificationSettings:Add, Picture, gInfluenceStop ys-%Offset% x%StopButton% w15 h15, %StopColor%
    IniRead, Value, %TransparencyFile%, Transparency, Influence, 255
    Gui, NotificationSettings:Add, Edit, Center ys-%Offset% x%Edit2% h20 w50 vInfluenceTran
    Gui, NotificationSettings:Add, UpDown, Range0-255, %Value% x270 h20 

; Maven Notification Section
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font%
    Gui, NotificationSettings:Add, GroupBox, w%Box% +Center x5 h%Boxheight%
    Gui, NotificationSettings:Font, c%Font% s%fw% Bold
    Gui, NotificationSettings:Add, Text, yp+%TextOffset% x25 Section, Maven Notification
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%Check1% Checked1
    IniRead, Value, %NotificationIni%, Active, Maven, 0
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%Check2% Checked%Value%
    Gui, NotificationSettings:Add, Picture, gSoundsButtonChange ys-1 x%SpeakerButton% w15 h15, %IconColor%
    Gui, NotificationSettings:Add, Picture, gtest ys-%Offset% x%PlayButton% w15 h15, %PlayColor%
    Gui, NotificationSettings:Font, cBlack
    Gui, NotificationSettings:Color, Edit, %Secondary% -Caption -Border
    Gui, NotificationSettings:Add, Edit, Center ys-%Offset% x%Edit% h20 w50 vEdit9
    IniRead, Value, %NotificationIni%, Volume, Maven, 100
    Gui, NotificationSettings:Add, UpDown, Range0-100, %Value% x270 h20  
    Gui, NotificationSettings:Add, Picture, gtest ys-%Offset% x%PlayButton2% w15 h15, %PlayColor%
    Gui, NotificationSettings:Add, Picture, gtest ys-%Offset% x%StopButton% w15 h15, %StopColor%
    IniRead, Value, %TransparencyFile%, Transparency, Maven, 255
    Gui, NotificationSettings:Add, Edit, Center ys-%Offset% x%Edit2% h20 w50 vMavenTran
    Gui, NotificationSettings:Add, UpDown, Range0-255, %Value% x270 h20 

    ; Invitation Stuff
    Invitations := Witnesses()
    For each, Invitation in StrSplit(Invitations, "|")
    {
        IniRead, %Invitation%Current, %NotificationIni%, Active, The %Invitation%
    }
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font% s%fw2%
    Gui, NotificationSettings:Add, Text, Section xs yp+%MavenInvitations%, The Formed Notification
    Gui, NotificationSettings:Add, Checkbox, ys+1 x%Check1% Checked%FormedCurrent% vFormedCheck
    Gui, NotificationSettings:Add, Text, Section xs x25, The Forgotten Notification
    Gui, NotificationSettings:Add, Checkbox, ys+1 x%Check1% Checked%ForgottenCurrent% vForgottenCheck
    Gui, NotificationSettings:Add, Text, Section xs x25, The Feared Notification
    Gui, NotificationSettings:Add, Checkbox, ys+1 x%Check1% Checked%FearedCurrent% vFearedCheck
    Gui, NotificationSettings:Add, Text, Section xs x25, The Twisted Notification
    Gui, NotificationSettings:Add, Checkbox, ys+1 x%Check1% Checked%TwistedCurrent% vTwistedCheck
    Gui, NotificationSettings:Add, Text, Section xs x25, The Hidden Notification
    Gui, NotificationSettings:Add, Checkbox, ys+1 x%Check1% Checked%HiddenCurrent% vHiddenCheck
    Gui, NotificationSettings:Add, Text, Section xs x25, The Elderslayers Notification
    Gui, NotificationSettings:Add, Checkbox, ys+1 x%Check1% Checked%ElderslayersCurrent% vElderslayersCheck


    Gui, NotificationSettings:Font, c%Font% s1
    Gui, NotificationSettings:Add, GroupBox, w%Width% +Center x0 h1

    Gui, NotificationSettings:Font, c%Font% s10
    Gui, NotificationSettings:Add, Button, x20 w50, Close
    Gui, NotificationSettings:Color, %Background%
    Gui, NotificationSettings:Show, y150 W%Width%, Notification Settings
  Return
}

NotificationSettingsButtonClose(){
    Gui, NotificationSettings:Submit
    Gui, NotificationSettings:Destroy
    Gui, Quick:Destroy
    RecapButtonNo()
    PostSetup()
    PostMessage, 0x01113,,,, Tail.ahk - AutoHotkey ;Destroy Reminder
    PostMessage, 0x01122,,,, Tail.ahk - AutoHotkey ;Destroy Eldritch Reminder
    PostRestore()
    Gui, Reminder:Destroy
    Invitations := Witnesses()
    NotificaitonIni := NotificationIni()
    TransparencyIni := TransparencyIni()
    For each, Invitation in StrSplit(Invitations, "|")
    {
        Value := Invitation "Check"
        Value := %Value%
        IniWrite, %Value%, %NotificaitonIni%, Active, The %Invitation%    
    }
    Categories := "Quick|Notification|Influence|Maven"
    For each, Item in StrSplit(Categories, "|")
    {
        Active := Item "Active"
        Active := %Active%
        Sound := Item "SoundActive"
        Sound := %Sound%
        Volume := Item "Volume"
        Volume := %Volume%
        Tran := Item "Tran"
        Tran := %Tran%
        IniWrite, %Active%, %NotificaitonIni%, Active, %Item%
        IniWrite, %Sound%, %NotificaitonIni%, Sound Active, %Item%
        IniWrite, %Volume%, %NotificaitonIni%, Volume, %Item%
        IniWrite, %Tran%, %TransparencyIni%, Transparency, %Item%
    }
    MiscIni := MiscIni()
    IniWrite, %RecapActive%, %MiscIni%, On Death, Active
    IniWrite, %RecapSoundActive%, %NotificaitonIni%, Sound Active, Recap
    IniWrite, %RecapVolume%, %NotificaitonIni%, Volume, Recap
    IniWrite, %RecapTran%, %TransparencyIni%, Transparency, Recap
}

OverlayTest()
{
    ReadMechanics()
    If (MechanicsOn = 0) or (MechanicsOn = "")
    {
        yh := (A_ScreenHeight/2) -150
        xh := (A_ScreenWidth/2) - 225
        Gui, NotificationSettings:Destroy
        Gui, TransparencyWarning:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
        Gui, TransparencyWarning:Color, %Background%
        Gui, TransparencyWarning:Font, c%Font% s11
        Gui, TransparencyWarning:Add, Text, w530 +Center, You don't currently have any mechanic tracking on. You must have at least 1 mechanic on to test this overlay.
        Gui, TransparencyWarning:Add, Button, y50 x50, OKAY
        Gui, TransparencyWarning: +AlwaysOnTop -Caption
        Gui, TransparencyWarning:Show, NoActivate x%xh% y%yh% w550, TransparencyWarning
        WinWaitClose, TransparencyWarning
    }
    Gui, NotificationSettings:Submit, NoHide
    TransparencyFile := TransparencyIni()
    IniWrite, %OverlayTran%, %TransparencyFile%, Transparency, Overlay
    NotificationPrep(Overlay)
    RefreshOverlay()
    Return
}

;;;;; Overlay Controls
OverlayStop()
{
    Gui, Overlay:Destroy
    Return
} 

; Quick Notificaiton Controls
SoundButtonQuick()
{
    Gui, NotificationSettings:Submit, NoHide
    NotificationIni := NotificationIni()
    IniWrite, %QuickSoundActive%, %NotificationIni%, Active, Quick
    FileSelectFile, NewSound, 1, %A_ScriptDir%\Resources\Sounds, Please select the new sound file you would like, Audio (*.wav; *.mp2; *.mp3)
    If (NewSound != "")
    {
        IniWrite, %NewSound%, %NotificationIni%, Sounds, Quick
    }
    Return
}

TestQuickSound()
{
    Gui, NotificationSettings:Submit, NoHide
    IniRead, TestSound, %NotificationPath%, Sounds, Quick
    IniRead, TestVolume, %NotificationPath%, Volume, Quick
    TestSound("Quick")
    Return
}

TestSound(Notification)
{
    NotificationPath := NotificationIni()
    TestVolume := Notification "Volume"
    TestVolume := %TestVolume%
    IniRead, TestSound, %NotificationPath%, Sounds, %Notification%, Resources\Sounds\reminder.wav
    SoundPlay, Resources\Sounds\blank.wav ;;;;; super hacky workaround but works....
    SetTitleMatchMode, 2
    WinGet, AhkExe, ProcessName, NotificationSettings
    SetTitleMatchMode, 1
    SetWindowVol(AhkExe, 0)
    SetWindowVol(AhkExe, TestVolume)
    SoundPlay, %TestSound%
}

OverlaySettings()
{
    NotificationSettingsButtonClose()
    OverlaySetup()
    WinWaitClose, OverlaySetup
    NotificationSetup()
}

QuickTest()
{
    Gui, Quick:Destroy
    Gui, NotificationSettings:Submit, NoHide
    TransparencyIni := TransparencyIni()
    IniWrite, %QuickTran%, %TransparencyIni%, Transparency, Quick
    HotkeyIni := HotkeyIni()
    IniRead, Hotkey1, %HotkeyIni%, Hotkeys, 1
    Hk := Hotkey1
    WinGetPos, Width, Height, Length, , Notification Settings
    Height := Height + 350
    InfluenceMapNotification()
    Return
}

QuickStop()
{
    Gui, Quick:Destroy
    Return
}

; Mechanic Notification Settings
SoundsButtonNotification()
{
    Gui, NotificationSettings:Submit, NoHide
    NotificationIni := NotificationIni()
    IniWrite, %NotificationSoundActive%, %NotificationIni%, Active, Notification
    FileSelectFile, NewSound, 1, %A_ScriptDir%\Resources\Sounds, Please select the new sound file you would like, Audio (*.wav; *.mp2; *.mp3)
    If (NewSound != "")
    {
        IniWrite, %NewSound%, %NotificationIni%, Sounds, Notification
    }
    Return
}

TestNotificationSound()
{
    Gui, NotificationSettings:Submit, NoHide
    IniRead, TestSound, %NotificationPath%, Sounds, Notification
    IniRead, TestVolume, %NotificationPath%, Volume, Notification
    TestSound("Notification")
    Return
}

NotificationTest()
{
    Gui, Reminder:Destroy
    Gui, Overlay:Destroy
    Gui, NotificationSettings:Submit, NoHide
    TransparencyPath := TransparencyIni()
    IniWrite, %NotificationTran%, %TransparencyPath%, Transparency, Notification
    RefreshOverlay()
    Gui, Overlay:Hide
    height9 := (A_ScreenHeight / 2) + 200
    width9 := (A_ScreenWidth / 2)-100
    PostSetup()
    PostMessage, 0x01112,,,, Tail.ahk - AutoHotkey ;Activate Reminder
    PostRestore()
    Return
}

NotificationStop()
{
    PostSetup()
    PostMessage, 0x01113,,,, Tail.ahk - AutoHotkey
    PostMessage, 0x01118,,,, WindowMonitor.ahk - AutoHotkey
    PostRestore()
    Return
}

; Influence Notification Settings
SoundsButtonInfluence()
{
    Gui, NotificationSettings:Submit, NoHide
    NotificationIni := NotificationIni()
    IniWrite, %InfluenceSoundActive%, %NotificationIni%, Active, Influence
    FileSelectFile, NewSound, 1, %A_ScriptDir%\Resources\Sounds, Please select the new sound file you would like, Audio (*.wav; *.mp2; *.mp3)
    If (NewSound != "")
    {
        IniWrite, %NewSound%, %NotificationIni%, Sounds, Influence
    }
    Return
}

TestInfluenceSound()
{
    Gui, NotificationSettings:Submit, NoHide
    IniRead, TestSound, %NotificationPath%, Sounds, Influence
    IniRead, TestVolume, %NotificationPath%, Volume, Influence
    TestSound("Influence")
    Return
}

InfluenceTest()
{
    Gui, Reminder:Destroy
    Gui, NotificationSettings:Submit, NoHide
    TransparencyIni := TransparencyIni()
    IniWrite, %InfluenceTran%, %TransparencyIni%, Transparency, Influence
    PostSetup()
    PostMessage, 0x01123,,,, Tail.ahk - AutoHotkey
    PostRestore()
    Return
}

InfluenceStop()
{
    PostSetup()
    PostMessage, 0x01122,,,, Tail.ahk - AutoHotkey ;Destroy Eldritch Reminder
    PostMessage, 0x01155,,,, WindowMonitor.ahk - AutoHotkey
    PostRestore()
    Return
}

; Recap Notification Settings
SoundsButtonRecap()
{
    Gui, NotificationSettings:Submit, NoHide
    NotificationIni := NotificationIni()
    IniWrite, %RecapSoundActive%, %NotificationIni%, Active, Recap
    FileSelectFile, NewSound, 1, %A_ScriptDir%\Resources\Sounds, Please select the new sound file you would like, Audio (*.wav; *.mp2; *.mp3)
    If (NewSound != "")
    {
        IniWrite, %NewSound%, %NotificationIni%, Sounds, Recap
    }
    Return
}

TestRecapSound()
{
    Gui, NotificationSettings:Submit, NoHide
    IniRead, TestSound, %NotificationPath%, Sounds, Recap
    IniRead, TestVolume, %NotificationPath%, Volume, Recap
    TestSound("Recap")
    Return
}

RecapTest()
{
    Gui, Reminder:Destroy
    Gui, Overlay:Destroy
    Gui, NotificationSettings:Submit, NoHide
    TransparencyPath := TransparencyIni()
    IniWrite, %RecapTran%, %TransparencyPath%, Transparency, Recap
    OnDeathPrompt()
    Return
}

RecapStop()
{
    RecapButtonNo()
}