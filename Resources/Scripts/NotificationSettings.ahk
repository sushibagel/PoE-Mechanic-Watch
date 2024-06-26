Global OverlayTran
Global QuickActive
Global QuickSoundActive
Global QuickVolume
Global QuickDuration
Global QuickTran
Global NotificationTran
Global NotificationActive
Global NotificationSoundActive
Global NotificationVolume
Global InfluenceActive
Global InfluenceSoundActive
Global InfluenceTran
Global InfluenceVolume
Global MavenActive
Global MavenSoundActive
Global MavenVolume
Global MavenTran
Global SoundButtonChange
Global FormedCheck
Global ForgottenCheck
Global FearedCheck
Global TwistedCheck
Global HiddenCheck
Global ElderslayersCheck
Global HideoutNotification
Global HotkeyNotification
Global UseQuick
Global ChatDelay
Global NoteSelected

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
    If (ColorMode = "Custom")
        {
            If (Icons = "White")
                {
                    IconColor = Resources/Images/volume white.png
                    RefreshColor = Resources/Images/refresh white.png
                    PlayColor = Resources/Images/play white.png
                    StopColor = Resources/Images/stop white.png
                }
            If (Icons = "Black")
                {
                    IconColor = Resources/Images/volume.png
                    RefreshColor = Resources/Images/refresh.png
                    PlayColor = Resources/Images/play.png
                    StopColor = Resources/Images/stop.png
                }
        }
    TransparencyFile := TransparencyIni()
    NotificationIni := NotificationIni()
    Gui, NotificationSettings:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
    Gui, NotificationSettings:Font, c%Font% s13 Bold
    Width := Round(A_ScreenWidth*.51)
    BoxH := Round(96/A_ScreenDPI*49)
    Box:= Round(A_ScreenWidth*.5)
    BoxHeight := Round(96/A_ScreenDPI*230)
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

    Gui, NotificationSettings:Add, Text, w%Box% +Center, Notification Settings
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
    Boxh2 := Boxh + 20
    Gui, NotificationSettings:Add, GroupBox, w%Box% +Center x5 h%Boxh2%
    Gui, NotificationSettings:Font, c%Font% s%fw% Bold
    test2 := TextOffset+15
    Gui, NotificationSettings:Add, Text, yp+%test2% x25 Section, Quick Notification
    Gui, NotificationSettings:Font
    IniRead, QuickActive, %NotificationIni%, Active, Quick, 1
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%Check1% Checked%QuickActive% vQuickActive
    IniRead, Value, %NotificationIni%, Sound Active, Quick, 0
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%Check2% Checked%Value% vQuickSoundActive
    IniRead, QuickSound, %NotificationIni%, Sounds, Quick
    Gui, NotificationSettings:Add, Picture, ys-%Offset% x%SpeakerButton% w15 h15 gSoundButtonQuick, %IconColor%
    Gui, NotificationSettings:Add, Picture, gTestQuickSound ys-%Offset% x%PlayButton% w15 h15, %PlayColor%
    Gui, NotificationSettings:Font, cBlack
    IniRead, Value, %NotificationIni%, Volume, Quick, 100
    Gui, NotificationSettings:Add, Edit, Center ys-%Offset% x%Edit% h20 w50 vQuickVolume
    Gui, NotificationSettings:Add, UpDown, Range0-100, %Value% x270 h20
    Gui, NotificationSettings:Add, Picture, gQuickTest ys-%Offset% x%PlayButton2% w15 h15, %PlayColor%
    Gui, NotificationSettings:Add, Picture, gQuickStop ys-%Offset% x%StopButton% w15 h15, %StopColor%
    IniRead, Value, %TransparencyFile%, Transparency, Quick, 255
    Gui, NotificationSettings:Add, Edit, Center ys-%Offset% x%Edit2% h20 w50 vQuickTran
    Gui, NotificationSettings:Add, UpDown, Range0-255, %Value% x270 h20
    XOff := Round(96/A_ScreenDPI*815)
    Gui, NotificationSettings:Add, Button, gMoveMap ys+%Offset% x%XOff% w50, Move
    Gui, NotificationSettings:Font, c%Font%
    XOff := Round(96/A_ScreenDPI*890)
    Gui, NotificationSettings:Add, Text, ys-15 x%XOff%, Duration (Seconds)
    Gui, NotificationSettings:Font, cBlack
    XOff := Round(96/A_ScreenDPI*905)
    IniRead, Duration, %NotificationIni%, Map Notification Position, Duration, 3000
    QuickDuration := Duration / 1000
    Gui, NotificationSettings:Add, Edit, Center yp ys-1 x%XOff% h20 w50 vQuickDuration
    Gui, NotificationSettings:Add, UpDown, Range0-60, %QuickDuration% x270 h20
    
    ; Mechanic Notification Section
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font%
    Boxh2 := Boxh + 40
    Gui, NotificationSettings:Add, GroupBox, w%Box% +Center x5 h%Boxh2%
    Gui, NotificationSettings:Font, c%Font% s%fw% Bold
    test2 := TextOffset+20
    Gui, NotificationSettings:Add, Text, yp+%test2% x25 Section, Mechanic Notification
    Gui, NotificationSettings:Font
    IniRead, Value, %NotificationIni%, Active, Notification, 1
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%Check1% Checked%Value% vNotificationActive
    IniRead, Value, %NotificationIni%, Sound Active, Notification, 0
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%Check2% Checked%Value% vNotificationSoundActive
    Gui, NotificationSettings:Add, Picture, gSoundsButtonNotification ys-%Offset% x%SpeakerButton% w15 h15, %IconColor%
    Gui, NotificationSettings:Add, Picture, gTestNotificationSound ys-%Offset% x%PlayButton% w15 h15, %PlayColor%
    Gui, NotificationSettings:Font, cBlack
    IniRead, Value, %NotificationIni%, Volume, Notification, 100
    Gui, NotificationSettings:Add, Edit, Center ys-%Offset% x%Edit% h20 w50 vNotificationVolume
    Gui, NotificationSettings:Add, UpDown, Range0-100, %Value% x270 h20
    Gui, NotificationSettings:Add, Picture, gNotificationTest ys-%Offset% x%PlayButton2% w15 h15, %PlayColor%
    Gui, NotificationSettings:Add, Picture, gNotificationStop ys-%Offset% x%StopButton% w15 h15, %StopColor%
    IniRead, Value, %TransparencyFile%, Transparency, Notification, 255
    Gui, NotificationSettings:Add, Edit, Center ys-%Offset% x%Edit2% h20 w50 vNotificationTran
    Gui, NotificationSettings:Add, UpDown, Range0-255, %Value% x270 h20
    
    XOff := Round(96/A_ScreenDPI*815)
    IniRead, Value, %NotificationIni%, Notification Trigger, Hideout, 1
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%XOff% w50 Checked%Value% vHideoutNotification
    Gui, NotificationSettings:Font, c%Font%
    XOffAdjust := XOff - 10
    Gui, NotificationSettings:Add, Text, ys+20 x%XOffAdjust%, Hideout
    Gui, NotificationSettings:Font, cBlack
    Gui, NotificationSettings:Font, c%Font%

    XOff := Round(96/A_ScreenDPI*830)
    Gui, NotificationSettings:Font, c%Font% s9 Bold Underline
    Gui, NotificationSettings:Add, Text, ys-20 x%XOff% HwndNotificationFootnote1 gOpenNotificationFootnote, Triggers
    Gui, NotificationSettings:Font, s6 Normal
    Gui, NotificationSettings:Add, Text, x+.5 yp HwndNotificationFootnote1 gOpenNotificationFootnote, 1
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, cBlack

    XOff := Round(96/A_ScreenDPI*885)
    Gui, NotificationSettings:Font, cBlack
    IniRead, Value, %NotificationIni%, Notification Trigger, Hotkey, 0
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%XOff% w50 Checked%Value% vHotkeyNotification gUseHotkey
    Gui, NotificationSettings:Font, c%Font%
    XOffAdjust := XOff - 10
    Gui, NotificationSettings:Add, Text, ys+20 x%XOffAdjust%, Hotkey

    XOff := Round(96/A_ScreenDPI*960)
    Gui, NotificationSettings:Font, c%Font% s9 Bold Underline
    XOffAdjust := XOff - 30
    Gui, NotificationSettings:Add, Text, ys-20 x%XOffAdjust% HwndNotificationFootnote2 gOpenNotificationFootnote, Quick Notification
    Gui, NotificationSettings:Font, s6 Normal
    Gui, NotificationSettings:Add, Text, x+.5 yp HwndNotificationFootnote2 gOpenNotificationFootnote, 2
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, cBlack
    IniRead, Value, %NotificationIni%, Notification Trigger, Use Quick, 0
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%XOff%+10 w50 Checked%Value% vUseQuick 

    XOff := Round(96/A_ScreenDPI*1120)
    Gui, NotificationSettings:Font, c%Font% s9 Bold Underline
    XOffAdjust := XOff - 30
    Gui, NotificationSettings:Add, Text, ys-20 x%XOffAdjust% HwndNotificationFootnote2 gOpenNotificationFootnote, Chat Delay
    Gui, NotificationSettings:Font, s6 Normal
    Gui, NotificationSettings:Add, Text, x+.5 yp HwndNotificationFootnote3 gOpenNotificationFootnote, 3
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, cBlack
    IniRead, Value, %NotificationIni%, Notification Trigger, Chat Delay, 0
    Value := Value / 1000
    XOffAdjust := XOff - 25
    Gui, NotificationSettings:Add, Edit, Center ys+%Offset% x%XOffAdjust% h20 w50 vChatDelay
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
    IniRead, Value, %NotificationIni%, Active, Maven, 1
    Gui, NotificationSettings:Add,Checkbox, ys+%Offset% x%Check1% Checked%Value% vMavenActive
    IniRead, Value, %NotificationIni%, Sound Active, Maven, 0
    Gui, NotificationSettings:Add,Checkbox, ys+%Offset% x%Check2% Checked%Value% vMavenSoundActive
    Gui, NotificationSettings:Add, Picture, gSoundsButtonMaven ys-1 x%SpeakerButton% w15 h15, %IconColor%
    Gui, NotificationSettings:Add, Picture, gTestMavenSound ys-%Offset% x%PlayButton% w15 h15, %PlayColor%
    Gui, NotificationSettings:Font, cBlack
    Gui, NotificationSettings:Add, Edit, Center ys-%Offset% x%Edit% h20 w50 vMavenVolume
    IniRead, Value, %NotificationIni%, Volume, Maven, 100
    Gui, NotificationSettings:Add, UpDown, Range0-100, %Value% x270 h20
    Gui, NotificationSettings:Add, Picture, gMavenTest ys-%Offset% x%PlayButton2% w15 h15, %PlayColor%
    Gui, NotificationSettings:Add, Picture, gMavenStop ys-%Offset% x%StopButton% w15 h15, %StopColor%
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
    OnMessage(0x0200, "MouseWatch")
    Return
}

NotificationSettingsButtonClose(){
    Gui, NotificationSettings:Submit, NoHide
    Gui, MavenReminder:Destroy
    Gui, Quick:Destroy
    Gui, FootnoteInfo:Destroy
    PostSetup()
    PostMessage, 0x01113,,,, Tail.ahk - AutoHotkey ;Destroy Reminder
    PostMessage, 0x01122,,,, Tail.ahk - AutoHotkey ;Destroy Eldritch Reminder
    PostRestore()
    Gui, Reminder:Destroy
    Invitations := Witnesses()
    NotificaitonIni := NotificationIni()
    TransparencyIni := TransparencyIni()
    If (NotificationActive = 1) and (HideoutNotification < 1) and (HotkeyNotification < 1)
        {
            NotificationSettingsError()
        }
    Else
        {
            IniWrite, %HideoutNotification%, %NotificaitonIni%, Notification Trigger, Hideout
            IniWrite, %HotkeyNotification%, %NotificaitonIni%, Notification Trigger, Hotkey
            IniWrite, %UseQuick%, %NotificaitonIni%, Notification Trigger, Use Quick
            ChatDelay := ChatDelay * 1000
            IniWrite, %ChatDelay%, %NotificaitonIni%, Notification Trigger, Chat Delay
            Gui, NotificationSettings:Destroy
        }
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
    QuickDuration := QuickDuration * 1000
    IniWrite, %QuickDuration%, %NotificaitonIni%, Map Notification Position, Duration
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

; Maven Notification Settings
SoundsButtonMaven()
{
    Gui, NotificationSettings:Submit, NoHide
    NotificationIni := NotificationIni()
    IniWrite, %MavenSoundActive%, %NotificationIni%, Active, Maven
    FileSelectFile, NewSound, 1, %A_ScriptDir%\Resources\Sounds, Please select the new sound file you would like, Audio (*.wav; *.mp2; *.mp3)
    If (NewSound != "")
    {
        IniWrite, %NewSound%, %NotificationIni%, Sounds, Maven
    }
    Return
}

TestMavenSound()
{
    Gui, NotificationSettings:Submit, NoHide
    IniRead, TestSound, %NotificationPath%, Sounds, Maven
    IniRead, TestVolume, %NotificationPath%, Volume, Maven
    TestSound("Maven")
    Return
}

MavenTest()
{
    Gui, Reminder:Destroy
    Gui, NotificationSettings:Submit, NoHide
    TransparencyIni := TransparencyIni()
    IniWrite, %MavenTran%, %TransparencyIni%, Transparency, Maven
    MavenReminder()
    Return
}

MavenStop()
{
    MavenReminderButtonNo()
    Return
}

NotificationSettingsError()
{
    Gui, NotificationError:Destroy
    Gui, NotificationError:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
    Gui, NotificationError:Font, c%Font% s10
    Gui, NotificationError:Add, Text, w490 +Wrap ,Error! Your Mechanic Notifications are enabled but a trigger hasn't been selected. Please select a trigger. For more information on what the triggers do click on the "Triggers" text in the settings menu. 
    Gui, NotificationError:Font, c%Font% s10
    Gui, NotificationError:Add, Button, x20 w50, Close
    Gui, NotificationError:Color, %Background%
    test := (A_ScreenHeight/2)+50
    Gui, NotificationError:Show, W500 y%test%, Settings Error
}

NotificationErrorButtonClose()
{
    Gui, NotificationError:Destroy
}

UseHotkey()
{
    Gui, NotificationSettings:Submit, NoHide
    If (UseQuick = 0) and (HotkeyNotification = 1)
        {
            Gui, HotkeyWarning:Destroy
            Gui, HotkeyWarning:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
            Gui, HotkeyWarning:Font, c%Font% s10
            Gui, HotkeyWarning:Add, Text, w490 +Wrap , It's recommended to use the Hotkey Notification in conjunction with the "Quick Notification" Setting. The normal notification will create a permanent notification which may get in the way if trying to escape a map quickly or while typing. Quick Notifications are smaller with an automatic timeout resulting in a less intrusive notification. 
            Gui, HotkeyWarning:Font, c%Font% s10
            Gui, HotkeyWarning:Add, Button, x20 w50, Close
            Gui, HotkeyWarning:Color, %Background%
            test := (A_ScreenHeight/2)+50
            Gui, HotkeyWarning:Show, W500 y%test%, Hotkey Warning
        }
}

HotkeyWarningButtonClose()
{
    Gui, HotkeyWarning:Destroy
}

MouseWatch(wParam, lParam, Msg, Hwnd) {
    IF (NoteSelected != 1)
    {
        MouseGetPos,,,, mHwnd, 2
        If InStr(A_GuiControl, "1") or InStr(A_GuiControl, "Triggers") 
            {
                ViewNotificationFootnote(1)
                LastHwnd := mHwnd
                Return
            }
        If InStr(A_GuiControl, "2") or InStr(A_GuiControl, "Quick Notification") 
            {
                ViewNotificationFootnote(2)
                LastHwnd := mHwnd
                Return
            }
        If InStr(A_GuiControl, "3") or InStr(A_GuiControl, "Chat Delay") 
            {
                ViewNotificationFootnote(3)
                LastHwnd := mHwnd
                Return
            }
        If !InStr(A_GuiControl, "2") and (NoteSelected != 1) or !InStr(A_GuiControl, "Quick Notification") and (NoteSelected != 1) or !InStr(A_GuiControl, "1") and (NoteSelected != 1) or !InStr(A_GuiControl, "Triggers") and (NoteSelected != 1) or !InStr(A_GuiControl, "Chat Delay") and (NoteSelected != 1) or !InStr(A_GuiControl, "3") and (NoteSelected != 1)
            {
                Gui, FootnoteInfo:Destroy
            }
    }
}

OpenNotificationFootnote()
{
    Gui, NotificationFootnote:Destroy
    If InStr(A_GuiControl, "1") or InStr(A_GuiControl, "Triggers") 
        {
            NoteSelected := 1
            ViewNotificationFootnote(1)
            LastHwnd := mHwnd
            Return
        }
    If InStr(A_GuiControl, "2") or InStr(A_GuiControl, "Quick Notification") 
        {
            NoteSelected := 1
            ViewNotificationFootnote(2)
            LastHwnd := mHwnd
            Return
        }
    If InStr(A_GuiControl, "3") or InStr(A_GuiControl, "Chat Delay") 
        {
            NoteSelected := 1
            ViewNotificationFootnote(3)
            LastHwnd := mHwnd
            Return
        }
}

ViewNotificationFootnote(FootnoteNum)
{
    Gui, FootnoteInfo:Destroy
    If (FootnoteNum = 1)
    {
        CustomText := ""
        Caption := "-Caption"
        If (SamplePressed = 1)
        {
            Caption := "+Caption"
        }
        CustomText := "Triggers are the condition that will trigger your mechanic notifications. The Hideout Trigger is triggered when you enter your hideout. The Hotkey Trigger is triggered when you press the configured hotkey while not in your hideout."
    }

    If (FootnoteNum = 2)
        {
            CustomText := ""
            Caption := "-Caption"
            If (SamplePressed = 1)
            {
                Caption := "+Caption"
            }
            CustomText := "Quick Notifications are a smaller temporary nottification that can be used instead of the larger normal notifications. This is highly recommended if the Hotkey Trigger is being used as the normal notifications are permanent until dismissed and significantly larger, which can be problematic while mapping if you want to exit quickly or are typing a message. To adjust the size and timeout see the ""Quick Notification"" section."
        }
    
    If (FootnoteNum = 3)
        {
            CustomText := ""
            Caption := "-Caption"
            If (SamplePressed = 1)
            {
                Caption := "+Caption"
            }
            CustomText := "Chat Delay is a timer (in seconds) that will cause the configured Hotkey for notifcations to be ignored. This is usefult if you have your Portal Hotkey on a letter key as it will allow you to avoid triggering notifications while typing messages. Set your Chat Trigger key in the ""Change Hotkey"" tool."
        }
    WinGetPos, NSX, NSY, NSW, NSH, Notification Settings
    Gui, FootnoteInfo:Destroy
    Gui, FootnoteInfo:Color, %Background%
    Gui, FootnoteInfo:Font, c%Font% s10
    Gui, FootnoteInfo:Add, Text,w135 +Wrap,%CustomText%
    NSX := NSX + NSW + 20
    NSH := NSH - 150
    Gui, FootnoteInfo:-Border -Caption
    If (NoteSelected = 1)
        {
            Gui, FootnoteInfo:Add, Button, gCloseFootnote y+50 w50, Close
        }
    Gui, FootnoteInfo:Show, NoActivate w150 x%NSX% y%NSY% h%NSH%, Footnote Info
}

CloseFootnote()
{
    Gui, FootnoteInfo:Destroy
    NoteSelected := 0
}