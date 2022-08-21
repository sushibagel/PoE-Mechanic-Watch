
;lt := new CLogTailer(LogPath, Func("NewLine"))
;Return
; This function gets called each time there is a new line
;NewLine(text)
;{
;ToolTip, % text
;If text contains %FullSearch% ;This is intentially redundant for now. I may use it later for future improvements. 
;	{
;		Hideout := text
;		If Hideout contains %FullSearch%
;		{
;			Gosub, LogItem
;			Return
;		}
;	}
;}

class CLogTailer {
	__New(logfile, callback){
		this.file := FileOpen(logfile, "r-d")
		if (!IsObject(this.file)){
            MsgBox % "Unable to load file " logfile "`n check if the file path is correct"
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