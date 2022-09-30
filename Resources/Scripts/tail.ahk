#SingleInstance, force
#Persistent
#NoEnv
;#Warn

Global CLogTailer
Global NewLine

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
			InfluenceReminderActive := 0
			LogMonitorIni := LogMonitorIni()
			IniWrite, Hideout, %LogMonitorIni%, Log Monitor, Log Event
			; HideoutEntered()
			Exit
		}
		If NewLine contains %MyDialogs%,%MyDialogsDisable%
		{
			; SearchText(NewLine)
			Exit
		}
		If InStr(NewLine, "Generating level") and InStr(NewLine, "with seed")
		{
			; InfluenceTrack(NewLine)
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

#IncludeAgain, Resources/Scripts/LogMonitor.ahk
#IncludeAgain, Resources/Scripts/Ini.ahk
#IncludeAgain, Resources/Scripts/Mechanics.ahk
#IncludeAgain, Resources/Scripts/AutoMechanic.ahk
#IncludeAgain, Resources/Scripts/Influences.ahk
#IncludeAgain, Resources/Scripts/NotificationSounds.ahk
#IncludeAgain, Resources/Scripts/HotkeySelect.ahk
#IncludeAgain, Resources/Scripts/Transparency.ahk