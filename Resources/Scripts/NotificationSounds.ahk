Global Notification
Global Influence
Global NotificationActive
Global InfluenceActive
Global SoundActive
Global NotificationSound
Global NotificationVolume

UpdateNotification()
{
    CheckTheme()
    Notifications := NotificationTypes()
    NotificationPath := NotificationIni()
    If (ColorMode = "Dark")
    {
        IconColor = volume white.png
        PlayColor = play white.png
    }
    If (ColorMode = "Light")
    {
        IconColor = volume.png
        PlayColor = play.png
    }
    For each, Item in StrSplit(Notifications, "|")
    {
        Gui, Sounds:Font, c%Font% s10
        IniRead, %Item%Active, %NotificationPath%, Active, %Item%
        IniRead, %Item%Volume, %NotificationPath%, Volume, %Item%
        IniRead, %Item%Sound, %NotificationPath%, Sounds, %Item%
        ItemActive := % %Item%Active
        ItemVolume := %Item%Volume
        Gui, Sounds:Add, Checkbox, v%Item% Checked%ItemActive% xn x10, %Item%
        Gui, Sounds:Add, Picture, gSoundsButtonChange%Item% x165 yp w20 h20, Resources\Images\%IconColor%
        Gui, Sounds:Add, Picture, gtest%Item% x195 yp w20 h20, Resources\Images\%PlayColor%
        Gui, Sounds:Font, cBlack
        Gui, Sounds:Color, Edit, %Secondary% -Caption -Border
        Gui, Sounds:Add, Edit, x220 yp h20 w50 v%Item%Edit
        Gui, Sounds:Add, UpDown, Range0-100, %ItemVolume% x270 h20  
    }
    Gui, Sounds:-Border -Caption
    Gui, Sounds:Color, %Background%
    Gui, Sounds:Font, s8 Bold
    Gui, Sounds:Add, Button, x190 y60 w80 h30, OK
    Gui, Sounds:Show, W280 h95, Sounds
    Return
}

NotificationTypes()
{
    Return, "Notification|Influence"
}

SoundsButtonOk()
{
    Notifications := NotificationTypes()
    NotificationPath := NotificationIni()
    Gui, Submit, NoHide 
    For each, Item in StrSplit(Notifications, "|")
    {
        ItemActive := %Item%
        IniWrite, %ItemActive%, %NotificationPath%, Active, %Item%
        IniWrite, %NotificationEdit%, %NotificationPath%, Volume, %Item%
    }
    Gui, Destroy
    Return
} 

SoundsButtonChangeNotification()
{
    Gui, Submit, NoHide
    NotificationPath := NotificationIni()
    IniWrite, %Notification%, %NotificationPath%, Active, Notification
    FileSelectFile, NewSound, 1, %A_ScriptDir%\Resources\Sounds, Please select the new sound file you would like, Audio (*.wav; *.mp2; *.mp3)
    If (NewSound != "")
    {
        IniWrite, %NewSound%, %NotificationPath%, Sounds, Notification
    }
    Return
}

SoundsButtonChangeInfluence()
{
    Gui, Submit, NoHide
    NotificationPath := NotificationIni()
    IniWrite, %Influence%, %NotificationPath%, Active, Influence
    FileSelectFile, NewSound, 1, %A_ScriptDir%\Resources\Sounds, Please select the new sound file you would like, Audio (*.wav; *.mp2; *.mp3)
    If (NewSound != "")
    {
        IniWrite, %NewSound%, %NotificationPath%, Sounds, Influence
    }
    Return
}

testNotification()
{
    Gui, Sounds:Submit, NoHide
    NotificationPath := NotificationIni()
    IniRead, TestSound, %NotificationPath%, Sounds, Notification
    TestVolume = %NotiEdit%
    TestSound()
}

testInfluence()
{
    Gui, Sounds:Submit, NoHide
    NotificationPath := NotificationIni()
    IniRead, TestSound, %NotificationPath%, Sounds, Influence
    TestVolume = %NotiEditInfluence%
    TestSound()
    Return
}

TestSound()
{
    SoundPlay, Resources\Sounds\blank.wav ;;;;; super hacky workaround but works....
    SetTitleMatchMode, 2
    WinGet, AhkExe, ProcessName, Sounds
    SetTitleMatchMode, 1
    SetWindowVol(AhkExe, 0)
    SetWindowVol(AhkExe, TestVolume)
    SoundPlay, %TestSound%
    Return
}

CheckSounds(Notification)
{
    NotificationPath := NotificationIni()
    IniRead, Sound, %NotificationPath%, Sounds, %Notification%
    Return, %Sound%
}

CheckVolume(Volume)
{
    NotificationPath := NotificationIni()
    IniRead, Volume, %NotificationPath%, Volume, %Volume%
    Return, %Volume%
}

CheckSoundActive(Active)
{
    NotificationPath := NotificationIni()
    IniRead, Active, %NotificationPath%, Active, %Active%
    Return, %Active% 
}

NotificationPrep(NotificationType)
{
    ColorMode := CheckTheme()
    SoundActive := CheckSoundActive(NotificationType)
    NotificationVolume := CheckVolume(NotificationType)
    NotificationSound := CheckSounds(NotificationType)
}