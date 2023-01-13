#SingleInstance, force
#Persistent
#NoEnv
#NoTrayIcon

Global CLogTailer
Global NewLine

OnMessage(0x01113, "ReminderDestroy")
OnMessage(0x01112, "Reminder")
OnMessage(0x01122, "EldritchReminderDestroy")
OnMessage(0x01123, "EldritchReminder")
LogMonitor()

LogPath := GetLogPath()

lt := new CLogTailer(LogPath, Func("LogTail"))
Exit

; This function gets called each time there is a new line
LogTail(text)
{
	NewLine = % text
	FullSearch = %MyDialogs%,%MyHideout%,%MyDialogsDisable%
	If NewLine contains %MyHideout%
	{
		PostSetup()
		PostMessage, 0x01155,,,, WindowMonitor.ahk - AutoHotkey ; Deactive alt tab reminder for influences 
		PostRestore()
		MechanicsActive()
		If (MechanicsActive >= 1)
		{
			Reminder()
			NotificationIni := NotificationIni()
			IniWrite, 1, %NotificationIni%, Notification Active, Mechanic Notification Active
		}
		MechanicsIni := MechanicsIni()
		IniRead, MavenMap, %MechanicsIni%, Maven Map, Maven Map 10, 0
		{
			If !(MavenMap = 0) and !(MavenMap = "")
			{
				MavenReminderText := "You've completed 10 Maven Witnessed maps. Don't forget to complete an invitation." 
				MavenReminderType := "Map"
				MavenReminder()
			}
		}
		FormedMechanics := Formed()
		FormedComplete := 0
		For each, Item in StrSplit(FormedMechanics, "|")
		{
			Iniread, FormedItem, %MechanicsIni%, The Formed, %Item%
			If (FormedItem = 1)
			FormedComplete ++
		}
		If (FormedComplete = 4)
		{
			MavenReminderText := "You've completed the witnessing for The Formed Invitation. Don't forget to complete an invitation." 
			MavenReminderType := "The Formed"
			MavenReminder()
		}
		ForgottenMechanics := Forgotten()
		ForgottenComplete := 0
		For each, Item in StrSplit(ForgottenMechanics, "|")
		{
			Iniread, ForgottenItem, %MechanicsIni%, The Forgotten, %Item%
			If (ForgottenItem = 1)
			ForgottenComplete ++
		}
		If (ForgottenComplete = 4)
		{
			MavenReminderText := "You've completed the witnessing for The Forgotten Invitation. Don't forget to complete an invitation." 
			MavenReminderType := "The Forgotten"
			MavenReminder()
		}
		FearedMechanics := Feared()
		FearedComplete := 0
		For each, Item in StrSplit(FearedMechanics, "|")
		{
			Iniread, FearedItem, %MechanicsIni%, The Feared, %Item%
			If (FearedItem = 1)
			FearedComplete ++
		}
		If (FearedComplete = 5)
		{
			MavenReminderText := "You've completed the witnessing for The Feared Invitation. Don't forget to complete an invitation." 
			MavenReminderType := "The Feared"
			MavenReminder()
		}
		TwistedMechanics := Twisted()
		TwistedComplete := 0
		For each, Item in StrSplit(TwistedMechanics, "|")
		{
			Iniread, TwistedItem, %MechanicsIni%, The Twisted, %Item%
			If (TwistedItem = 1)
			TwistedComplete ++
		}
		If (TwistedComplete = 4)
		{
			MavenReminderText := "You've completed the witnessing for The Twisted Invitation. Don't forget to complete an invitation." 
			MavenReminderType := "The Twisted"
			MavenReminder()
		}
		HiddenMechanics := Hidden()
		HiddenComplete := 0
		For each, Item in StrSplit(HiddenMechanics, "|")
		{
			Iniread, HiddenItem, %MechanicsIni%, The Hidden, %Item%
			If (HiddenItem = 1)
			HiddenComplete ++
		}
		If (HiddenComplete = 4)
		{
			MavenReminderText := "You've completed the witnessing for The Hidden Invitation. Don't forget to complete an invitation." 
			MavenReminderType := "The Hidden"
			MavenReminder()
		}
		ElderslayersMechanics := Elderslayers()
		ElderslayersComplete := 0
		For each, Item in StrSplit(ElderslayersMechanics, "|")
		{
			Iniread, ElderslayersItem, %MechanicsIni%, The Elderslayers, %Item%
			If (ElderslayersItem = 1)
			ElderslayersComplete ++
		}
		If (ElderslayersComplete = 4)
		{
			MavenReminderText := "You've completed the witnessing for The Elderslayers Invitation. Don't forget to complete an invitation." 
			MavenReminderType := "The Elderslayers"
			MavenReminder()
		}
		Exit
	}
	If NewLine contains %MyDialogs%,%MyDialogsDisable%
	{
		SearchText(NewLine)
		Exit
	}
	If InStr(NewLine, "Generating level") and InStr(NewLine, "with seed")
	{
		InfluenceTrack(NewLine)
		Exit
	}
	If InStr(NewLine, "The Maven:")
	{
		MavenTrack()
		Exit
	}
	If Instr(NewLine, "You have entered The Maven's Crucible.")
	{
		ResetMaven()
		Exit
	}
	If NewLine contains %MavenSearch%
	{
		MavenMatch(Newline)
		Exit
	}
	If InStr(NewLine, "has been slain")
	{
		OnDeath(Newline)
		Exit
	}
}

class CLogTailer 
{
	__New(logfile, callback)
	{
		this.file := FileOpen(logfile, "r-d")
		If (!IsObject(this.file)){
            MsgBox % "Unable to load file: " logfile "`nmake sure your Path of Exile client is open and reload the script."
        }
		this.callback := callback
		; Move seek to end of file
		this.file.Seek(0, 2)
		fn := this.WatchLog.Bind(this)
		SetTimer, % fn, 100
	}
	WatchLog()
	{
		Loop {
			p := this.file.Tell()
			l := this.file.Length
			line := this.file.ReadLine(), "`r`n"
			len := StrLen(line)
			if (len){
				RegExMatch(line, "[\r\n]+", matches)
				if (line == matches)
					continue
				this.callback.Call(Trim(line, "`r`n"))
			}
		} until (p == l)
	}
}

RefreshOverlay()
{
	PostSetup()
    PostMessage, 0x01111,,,, PoE Mechanic Watch.ahk - AutoHotkey
	PostRestore()
}

TransparencyCheck(NotificationTransparency)
{
   TransparencyIniPath := TransparencyIni()
   IniRead, NotificationTransparency, %TransparencyIniPath%, Transparency, %NotificationTransparency%, 255
   Return, %NotificationTransparency%
}

FirstRun()
{
	
}
#IncludeAgain, Resources/Scripts/AutoMechanic.ahk
#IncludeAgain, Resources/Scripts/EldritchReminder.ahk
#IncludeAgain, Resources/Scripts/HotkeySelect.ahk
#IncludeAgain, Resources/Scripts/Influences.ahk
#IncludeAgain, Resources/Scripts/Ini.ahk
#IncludeAgain, Resources/Scripts/LogMonitor.ahk
#IncludeAgain, Resources/Scripts/Maven.ahk
#IncludeAgain, Resources/Scripts/MavenReminder.ahk
#IncludeAgain, Resources/Scripts/Mechanics.ahk
#IncludeAgain, Resources/Scripts/NotificationSounds.ahk
#IncludeAgain, Resources/Scripts/Reminder.ahk
#IncludeAgain, Resources/Scripts/ReminderGui.ahk
#IncludeAgain, Resources/Scripts/ScreenCap.ahk
