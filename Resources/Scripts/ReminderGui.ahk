MechanicReminder()
{
    TransparencyPath := TransparencyIni()
    IniRead, NotificationTransparency, %TransparencyPath%, Transparency, Notification
    Gui, Reminder:Font, c%Font% s12
    Gui, Reminder:Add, Text,,Did you forget to complete your %ReminderText%?
    Gui, Reminder:Font, s10
    Gui, Reminder:Color, %Background%
    Gui, Reminder:+AlwaysOnTop -Border +Owner2
    Gui, Reminder:Show, NoActivate x%width9% y%height9%, Reminder
    WinGetPos,,, Width, Height, Reminder
    Gui, Reminder:Hide,
    WinSet, Style, -0xC00000, Reminder
    xpos := (width/4)
    xpos2 := xpos+80
    gheight := height + 40
    nwidth := width9 - xpos
    Gui, Reminder:Add, Button, x%xpos% y40, Yes!
    Gui, Reminder:Add, Button,x%xpos2% y40, No
    Gui, Reminder:Show, x%nwidth% y%height9% h%gheight% NoActivate, Reminder
    WinSet, Transparent, %NotificationTransparency%, Reminder
    Return
}