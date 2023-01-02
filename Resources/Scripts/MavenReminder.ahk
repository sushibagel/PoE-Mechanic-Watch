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
    Gui, MavenReminder:Add, Text,,%MavenReminderText%
    Gui, MavenReminder:Font, s10
    Gui, MavenReminder:Color, %Background%
    Gui, MavenReminder:+AlwaysOnTop -Border
    Gui, MavenReminder:Show, NoActivate y%NotificationHeight%, Maven Reminder
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
    If !(MavenReminderType = "Map")
    {
        Gui, MavenReminder:Add, Button, xn x%bx2% Section w50, Yes
        Gui, MavenReminder:Add, Button, x%bx% ys w50, No
    }
    Else
    {
        Gui, MavenReminder:Add, Button, x%bx3% y+20 Section w50, Okay
    }

    Gui, MavenReminder:+AlwaysOnTop -Border
    Gui, MavenReminder:Show, y%NotificationHeight% h%gheight% NoActivate, Reminder
    WinSet, Style, -0xC00000, Reminder
    WinSet, Transparent, %NotificationTransparency%, Reminder
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