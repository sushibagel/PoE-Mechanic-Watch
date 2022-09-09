Global CLogTailer
Global NewLine

; This function gets called each time there is a new line
LogTail(text)
	{
		NewLine = % text
		FullSearch = %MyDialogs%,%MyHideout%,%MyDialogsDisable%
		If NewLine contains %MyHideout%
		{
			BreakLoop = 1
			HideoutEntered()
			Exit
		}
		If NewLine contains %MyDialogs%,%MyDialogsDisable%
		{
			SearchText(NewLine)
			Exit
		}
		If InStr(NewLine, "Generating level") and InStr(NewLine, "with seed")
		{
			EndLoop = 1
			InfluenceTrack(NewLine)
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