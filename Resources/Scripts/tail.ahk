; This function gets called each time there is a new line
Loop
{
LogTail(text)
	{
		NewLine = % text
		FullSearch = %MyDialogs%,%MyHideout%,%MyDialogsDisable%
		if NewLine contains %MyHideout%
		{
			MsgBox, %MyHideout%
			BreakLoop = 1
			SetTimer, BreakLoopClear, 500
			NewLine =
			HideoutEntered()
			Exit
		}
		if NewLine contains %MyDialogs%,%MyDialogsDisable%
		{
			NewLine =
			Gosub, SearchText
			Return
		}
		If InStr(NewLine, "Generating level") and If InStr(NewLine, "with seed")
		{
			EndLoop = 1
			SetTimer, EndLoopClear, 1000
			NewLine =
			InfluenceTrack()
			Exit
		}
	}
}
Return

BreakLoopClear:
SetTimer, BreakLoopClear, Off
BreakLoop =
Exit

EndLoopClear:
SetTimer, EndLoopClear, Off
EndLoop =
Exit

class CLogTailer {
	__New(logfile, callback){
		this.file := FileOpen(logfile, "r-d")
		if (!IsObject(this.file)){
            MsgBox % "Unable to load file: " logfile "`nmake sure your Path of Exile client is open and reload the script."
        }
		this.callback := callback
		; Move seek to end of file
		this.file.Seek(0, 2)
		fn := this.WatchLog.Bind(this)
		SetTimer, % fn, 100
	}
	
	WatchLog(){
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