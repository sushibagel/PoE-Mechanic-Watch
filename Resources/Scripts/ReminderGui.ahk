Global ReminderActive

MechanicReminder()
{
    CheckTheme()
    NotificationHeight := (A_ScreenHeight / 2) - 100
    NotificationWidth := (A_ScreenWidth / 2)-180
    TransparencyFile := TransparencyIni()
    IniRead, NotificationTransparency, %TransparencyFile%, Transparency, Notification
    Gui, Reminder:Font, c%Font% s12
    Gui, Reminder:Add, Text,,Did you forget to complete your %ReminderText%?
    Gui, Reminder:Font, s10
    Gui, Reminder:Color, %Background%
    Gui, Reminder:+AlwaysOnTop -Border
    Gui, Reminder:Show, NoActivate x%NotificationWidth% y%NotificationHeight%, Reminder
    WinGetPos,,, Width, Height, Reminder
    Gui, Reminder:Hide,
    WinSet, Style, -0xC00000, Reminder
    xpos := (width/4)
    xpos2 := xpos+80
    gheight := height + 40
    nwidth := NotificationWidth - xpos
    Gui, Reminder:Add, Button, x%xpos% y40, Yes
    Gui, Reminder:Add, Button,x%xpos2% y40, No
    Gui, Reminder:Show, x%nwidth% y%NotificationHeight% h%gheight% NoActivate, Reminder
    WinSet, Transparent, %NotificationTransparency%, Reminder
    ReminderActive := 1
    Return
}