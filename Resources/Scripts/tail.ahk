StartLogging:
Global Shores
Shores := "Karui Shores"
LogPath := "C:\Program Files (x86)\Steam\steamapps\common\Path of Exile\logs\Client.txt"
;msgbox, %Logpath% %FullSearch%
lt := new CLogTailer(LogPath, Func("NewLine"))

; This function gets called each time there is a new line
NewLine(text)
{
if text contains %FullSearch%,%Shore%
	{
    	;MsgBox %text% -- was found
        Hideout := text
        ;msgbox, %hideout%
        return
	}
}
Return

class CLogTailer {
	__New(logfile, callback){
		this.file := FileOpen(logfile, "r-d")
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