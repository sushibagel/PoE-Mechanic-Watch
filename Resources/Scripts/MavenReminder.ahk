Global MavenReminderActive
Global MavenReminderType

MavenReminder()
{
    Gui, MavenReminder:Destroy
    CheckTheme()
    NotificationHeight := (A_ScreenHeight / 2) - 100
    TransparencyFile := TransparencyIni()
    IniRead, NotificationTransparency, %TransparencyFile%, Transparency, Notification
    Gui, MavenReminder:Font, c%Font% s12
    If WinExist("Notification Settings")
    {
        MavenReminderText := "You have just entered a Maven's Crucible click ""Yes"" to view/reset tracking."
    }
    Gui, MavenReminder:Add, Text,,%MavenReminderText%
    Gui, MavenReminder:Font, s10
    Gui, MavenReminder:Color, %Background%
    Gui, MavenReminder:+AlwaysOnTop -Border
    NotificationIni := NotificationIni()
    DisabledReminder := ""
    IniRead, DisabledReminder, %NotificationIni%, Active, %MavenReminderType%
    If !(DisabledReminder = 0)
    {
        Gui, MavenReminder:Show, NoActivate y%NotificationHeight%, Maven Reminder
    }
    DetectHiddenWindows, On
    WinGetPos,xpos,, Width, Height, Maven Reminder
    bx := Width/2
    bx := Round(96/A_ScreenDPI*bx)
    bx2 := bx - 100
    bx := bx + 50
    bx3 := bx*2-Round(96/A_ScreenDPI*225)
    Gui, MavenReminder:Hide
    WinSet, Style, -0xC00000, Maven Reminder
    gheight := height + 40
    ReminderTypes := "Map", "The Formed"
    If !(MavenReminderType = "Map") and !(MavenReminderType = "The Formed") and !(MavenReminderType = "The Forgotten") and !(MavenReminderType = "The Feared") and !(MavenReminderType = "The Twisted") and !(MavenReminderType = "The Hidden") and !(MavenReminderType = "The Elderslayers")
    {
        Gui, MavenReminder:Add, Button, xn x%bx2% Section w50, Yes
        Gui, MavenReminder:Add, Button, x%bx% ys w50, No
    }
    Else
    {
        If !(MavenReminderType = "Map")
        {
            Gui, MavenReminder:Add, Button, xn y+20 x%bx2% Section w100, Stop Reminding
            Gui, MavenReminder:Add, Button, ys x%bx% Section w50, Okay
        } 
        Else
        {
            Gui, MavenReminder:Add, Button, x%bx3% y+20 Section w50, Okay
        }
    }
    If !(DisabledReminder = 0)
    {
        If WinExist("Notification Settings")
        {
            NotificationHeight := 850
        }
        Gui, MavenReminder:+AlwaysOnTop -Border
        Gui, MavenReminder:Show, y%NotificationHeight% h%gheight% NoActivate, Maven Reminder
        WinSet, Style, -0xC00000, Maven Reminder
        WinSet, Transparent, %NotificationTransparency%, Reminder
        MavenNotificationSound()
        WinWaitClose, Reminder
    }
    Return
}

MavenReminderButtonNo()
{
    Gui, MavenReminder:Destroy
}

MavenReminderButtonYes()
{
    Gui, MavenReminder:Destroy
    ViewMaven()
}

MavenReminderButtonOkay()
{
    Gui, MavenReminder:Destroy
}

MavenReminderButtonStopReminding()
{
    NotificationIni := NotificationIni()
    Gui, MavenReminder:Destroy
    IniWrite, 0, %NotificationIni%, Active, %MavenReminderType%
}

MavenNotificationSound()
{
    NotificationPrep("Maven")
    If (SoundActive = 1)
    {
        SoundPlay, Resources\Sounds\blank.wav ;;;;; super hacky workaround but works....
        SetTitleMatchMode, 2
        WinGet, AhkExe, ProcessName, Reminder
        SetTitleMatchMode, 1
        SetWindowVol(AhkExe, NotificationVolume)
        SoundPlay, %NotificationSound%
    }
}