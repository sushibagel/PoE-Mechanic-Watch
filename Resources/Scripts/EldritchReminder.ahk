Global Width2
Global Height2
Global InfluenceCount
Global NotificationTransparency
Global InfluenceReminderActive

EldritchReminder()
{
	Gui, InfluenceReminder:Destroy
	CheckTheme()
	TransparencyFile := TransparencyIni()
    IniRead, NotificationTransparency, %TransparencyFile%, Transparency, Influence
	If (NotificationTransparency = "ERROR")
	{
		NotificationTransparency = 255
	}
	If WinExist("Notification Settings")
	{
		ReminderText := "This is your 28th map. Don't forget to kill the boss for your Incandescent Invitation"
		InfluenceCount := 14
	}
	If (InfluenceCount = 14) or (InfluenceCount = 28)
	{
		Gui, InfluenceReminder:Font, c%Font% s12
		Gui, InfluenceReminder:Add, Text,,%ReminderText%
		height1 := (A_ScreenHeight / 2) - 100
		width1 := (A_ScreenWidth / 2)-180
		NotificationIni := NotificationIni()
		IniRead, NotificationActive, %NotificationIni%, Active, Influence, 1
		If (height2 != "")
		{
			height1 := height2
			width1 := width2
		}
		If WinExist("Notification Settings")
		{
			height1 := 850
			NotificationActive := 1
		}
		Gui, InfluenceReminder:Font, s10
		Gui, InfluenceReminder:Color, %Background%
		Gui, InfluenceReminder:+AlwaysOnTop -Border
		Gui, InfluenceReminder:Add, Button, x150 y40, OK
		Gui, InfluenceReminder:Add, Button, x300 y40, Revert Count
		If (NotificationActive = 1)
		{
			Gui, InfluenceReminder:Show, NoActivate y%height1%, InfluenceReminder
			WinSet, Style, -0xC00000, InfluenceReminder
			WinSet, Transparent, %NotificationTransparency%, InfluenceReminder
			Return
		}
		Else
		{
			Gui, InfluenceReminder:Destroy
		}
	}
	Return
}

EldritchReminderDestroy()
{
	Gui, InfluenceReminder:Destroy
}