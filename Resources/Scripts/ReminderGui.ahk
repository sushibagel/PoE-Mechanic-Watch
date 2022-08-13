MechanicReminder:
IniRead, NotificationTransparency, %TransparencyPath%, Transparency, Notification
Gui, 1:Font, c%Font% s12
Gui, 1:Add, Text,,Did you forget to complete your %ReminderText%?
Gui, 1:Font, s10
Gui, 1:Color, %Background%
Gui, 1:+AlwaysOnTop -Border +Owner2
Gui, 1:Show, NoActivate x%width9% y%height9%, Reminder
WinGetPos,,, Width, Height, Reminder
Gui, 1:Hide,
WinSet, Style, -0xC00000, Reminder
xpos := (width/4)
xpos2 := xpos+80
gheight := height + 40
nwidth := width9 - xpos
Gui, 1:Add, Button, x%xpos% y40, Yes!
Gui, 1:Add, Button,x%xpos2% y40, No
Gui, 1:Show, x%nwidth% y%height9% h%gheight% NoActivate, Reminder
WinSet, Transparent, %NotificationTransparency%, Reminder
Return