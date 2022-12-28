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
#IncludeAgain, Resources/Scripts/Mechanics.ahk
#IncludeAgain, Resources/Scripts/NotificationSounds.ahk
#IncludeAgain, Resources/Scripts/Reminder.ahk
#IncludeAgain, Resources/Scripts/ReminderGui.ahk
#IncludeAgain, Resources/Scripts/Transparency.ahk
