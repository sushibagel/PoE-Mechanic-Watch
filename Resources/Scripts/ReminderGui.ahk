Global ReminderActive

MechanicReminder()
{
    Gui, Reminder:Destroy
    CheckTheme()
    NotificationHeight := (A_ScreenHeight / 2) - 100
    TransparencyFile := TransparencyIni()
    IniRead, NotificationTransparency, %TransparencyFile%, Transparency, Notification
    Gui, Reminder:Font, c%Font% s12
    If WinExist("Transparency")
    {
        ReminderText := "Blight"
    }
    Gui, Reminder:Add, Text,,Did you forget to complete your %ReminderText%?
    Gui, Reminder:Font, s10
    Gui, Reminder:Color, %Background%
    Gui, Reminder:+AlwaysOnTop -Border
    Gui, Reminder:Show, NoActivate y%NotificationHeight%, Reminder
    DetectHiddenWindows, On
    WinGetPos,xpos,, Width, Height, Reminder
    xpos := xpos/2
    bx := Width/2
    adjust := Round(96/A_ScreenDPI*125)
    bx2 := Width/2-adjust
    Gui, Reminder:Hide
    WinSet, Style, -0xC00000, Reminder
    gheight := height + 40
    If WinExist("Transparency")
    {
        NotificationHeight := 750
    }
    Gui, Reminder:Add, Button, xn x%bx2% Section w50, Yes
    Gui, Reminder:Add, Button, x%bx% ys w50, No
    Gui, Reminder:+AlwaysOnTop -Border
    Gui, Reminder:Show, y%NotificationHeight% h%gheight% NoActivate, Reminder
    WinSet, Style, -0xC00000, Reminder
    WinSet, Transparent, %NotificationTransparency%, Reminder
    Return
}