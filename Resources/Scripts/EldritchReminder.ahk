EldritchReminder:
IniRead, InfluenceTransparency, %UpOneLevel%Settings\Transparency.ini, Transparency, Influence
If (InfluenceTransparency = "ERROR")
{
    IniRead, InfluenceTransparency, Resources\Settings\Transparency.ini, Transparency, Influence
}
If (InfluenceTransparency = "ERROR")
{
    InfluenceTransparency = 255
}

If (InfluenceTrack = 14) or (InfluenceTrack = 28)
{
	Gui, Reminder:Font, c%Font% s12
	Gui, Reminder:Add, Text,,%ReminderText%
	height1 := (A_ScreenHeight / 2) - 100
	width1 := (A_ScreenWidth / 2)-180
    If (height2 != "")
    {
        height1 := height2
        width1 := width2
    }
	Gui, Reminder:Font, s10
	Gui, Reminder:Color, %Background%
	Gui, Reminder:-Border +AlwaysOnTop
	Gui, Reminder:Add, Button, x150 y40, OK
	Gui, Reminder:Add, Button, x300 y40, Revert Count
	Gui, Reminder:Show, NoActivate x%width1% y%height1%, Reminder
	WinSet, Style, -0xC00000, Reminder
    WinSet, Transparent, %InfluenceTransparency%, Reminder
	Return
}
Return