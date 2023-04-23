Global Width2
Global Height2
Global InfluenceCount
Global NotificationTransparency
Global InfluenceReminderActive

EldritchReminder()
{
	InfluenceReminder := Gui()
	InfluenceReminder.Destroy()
	CheckTheme()
	NotificationHeight := (A_ScreenHeight / 2) - Round(96/A_ScreenDPI*100)
	TransparencyFile := TransparencyIni()
    NotificationTransparency := IniRead(TransparencyFile, "Transparency", "Influence")
	If (NotificationTransparency = "ERROR")
	{
		NotificationTransparency := "255"
	}
	If WinExist("Notification Settings")
	{
		ReminderText := "This is your 28th map. Don't forget to kill the boss for your Incandescent Invitation"
		InfluenceCount := 14
	}
	If (InfluenceCount = 14) or (InfluenceCount = 28)
	{
		InfluenceReminder.SetFont("c" . Font . " s12")
		InfluenceReminder.Add("Text", "Section", ReminderText)
		InfluenceReminder.Title := "Reminder"
		InfluenceReminder.Show("NoActivate y" . NotificationHeight)
		DetectHiddenWindows(true)
		WinGetPos(&xpos, , &Width, &Height, "Reminder")
		bx := Width/2
		bx := Round(96/A_ScreenDPI*bx)
		bx2 := bx - 150
		bx := bx + 50
		InfluenceReminder.Hide()
		WinSetStyle(-12582912, "InfluenceReminder")
    	gheight := height + Round(96/A_ScreenDPI*20)
		NotificationIni := NotificationIni()
		NotificationActive := IniRead(NotificationIni, "Active", "Influence", 1)
		If (height2 != "")
		{
			height1 := height2
			width1 := width2
		}
		If WinExist("Notification Settings")
		{
			NotificationHeight := 850
			NotificationActive := 1
		}
		InfluenceReminder.SetFont("s2")
		InfluenceReminder.BackColor := Background
		InfluenceReminder.Opt("+AlwaysOnTop -Border")
		InfluenceReminder.Add("Text", "xs", A_Space)
		InfluenceReminder.SetFont("s10")
		ogcButtonOK := InfluenceReminder.Add("Button", "xn x" . bx2 . " w50 Section", "OK")
		ogcButtonOK.OnEvent("Click", InfluenceReminderButtonOK.Bind("Normal"))
		ogcButtonRevertCount := InfluenceReminder.Add("Button", "x" . bx . " ys w100", "Revert Count")
		ogcButtonRevertCount.OnEvent("Click", InfluenceReminderButtonRevertCount.Bind("Normal"))
		If (NotificationActive = 1)
		{
			InfluenceReminder.Title := "InfluenceReminder"
			InfluenceReminder.Show("NoActivate y" . NotificationHeight . " h" . gheight)
			WinSetStyle(-12582912, "InfluenceReminder")
			WinSetTransparent(NotificationTransparency, "InfluenceReminder")
			Return
		}
		Else
		{
			InfluenceReminder.Destroy()
		}
	}
	Return
}

EldritchReminderDestroy()
{
	InfluenceReminder.Destroy()
}