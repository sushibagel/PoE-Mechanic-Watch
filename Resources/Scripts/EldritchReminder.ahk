Global Width2
Global Height2
Global InfluenceCount
Global NotificationTransparency
Global InfluenceReminderActive

EldritchReminder()
{
	Gui, InfluenceReminder:Destroy
	CheckTheme()
	NotificationHeight := (A_ScreenHeight / 2) - Round(96/A_ScreenDPI*100)
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
		Gui, InfluenceReminder:Add, Text, Section,%ReminderText%
		Gui, InfluenceReminder:Show, NoActivate y%NotificationHeight%, Reminder
		DetectHiddenWindows, On
		WinGetPos,xpos,, Width, Height, Reminder
		bx := Width/2
		bx := Round(96/A_ScreenDPI*bx)
		bx2 := bx - 150
		bx := bx + 50
		Gui, InfluenceReminder:Hide
		WinSet, Style, -0xC00000, InfluenceReminder
    	gheight := height + 10
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
		Gui, InfluenceReminder:Font, s2
		Gui, InfluenceReminder:Color, %Background%
		Gui, InfluenceReminder:+AlwaysOnTop -Border
		Gui, InfluenceReminder:Add, Text, xs, %A_Space%
		Gui, InfluenceReminder:Font, s10
		Gui, InfluenceReminder:Add, Button, xn x%bx2% w50 Section , OK
		Gui, InfluenceReminder:Add, Button, x%bx% ys w100, Revert Count
		If (NotificationActive = 1)
		{
			Gui, InfluenceReminder:Show, NoActivate y%NotificationHeight% h%gheight%, InfluenceReminder
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