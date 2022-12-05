Global Width2
Global Height2
Global InfluenceCount
Global InfluenceTransparency
Global InfluenceReminderActive

EldritchReminder()
{
	Gui, InfluenceReminder:Destroy
	CheckTheme()
	TransparencyFile := TransparencyIni()
    IniRead, InfluenceTransparency, %TransparencyFile%, Transparency, Influence
	If (InfluenceTransparency = "ERROR")
	{
		InfluenceTransparency = 255
	}
	If WinExist("Transparency")
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
		If (height2 != "")
		{
			height1 := height2
			width1 := width2
		}
		If WinExist("Transparency")
		{
			height1 := 750
		}
		Gui, InfluenceReminder:Font, s10
		Gui, InfluenceReminder:Color, %Background%
		Gui, InfluenceReminder:+AlwaysOnTop -Border
		Gui, InfluenceReminder:Add, Button, x150 y40, OK
		Gui, InfluenceReminder:Add, Button, x300 y40, Revert Count
		Gui, InfluenceReminder:Show, NoActivate x%width1% y%height1%, InfluenceReminder
		WinSet, Style, -0xC00000, InfluenceReminder
		WinSet, Transparent, %InfluenceTransparency%, InfluenceReminder
		InfluenceNotificationSound()
		PostSetup()
		PostMessage, 0x01192,,,, WindowMonitor.ahk - AutoHotkey ; Active alt tab reminder for influences 
		PostRestore()
		Return
	}
	Return
}

EldritchReminderDestroy()
{
	Gui, InfluenceReminder:Destroy
}