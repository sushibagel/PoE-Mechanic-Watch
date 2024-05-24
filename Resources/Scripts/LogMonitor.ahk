StartWatch()
{
    LaunchIni := IniPath("Launch")
    FolderToWatch := IniRead(LaunchIni ,"POE", "Directory")
    FileToWatch := FolderToWatch "\logs\Client.txt"
    Global lt := CLogTailer(FileToWatch, CheckLogLine)
}

class CLogTailer 
{
	__New(logfile, callback)
	{
		this.file := FileOpen(logfile, "r-d")
		If (!IsObject(this.file)){
            MsgBox("Unable to load file: " logfile "`nmake sure your Path of Exile client is open and reload the script.")
        }
		this.callback := callback
		; Move seek to end of file
		this.file.Seek(0, 2)
		fn := this.WatchLog.Bind(this)
        this.ReadFn := fn
		SetTimer(fn,100)
	}
	
	WatchLog()
	{
		Loop{
			p := this.file.Pos
			l := this.file.Length
			line := this.file.ReadLine(), "`r`n"
			len := StrLen(line)
			if (len){
				RegExMatch(line, "[\r\n]+", &matches)
				if (line == matches)
					continue
				this.callback.Call(Trim(line, "`r`n"))
                Return line
			}
		}  until (p == l)
	}

    ; Starts tailing
    Start(){
        fn := this.ReadFn
        SetTimer(fn,100)
    }
    
    ; Stops tailing
    Stop(){
        fn := this.ReadFn
        SetTimer(fn,0)
    }
}

CheckLogLine(LogLine)
{
    HideoutText := "You have entered " GetHideout()
    If InStr(LogLine, HideoutText)
        {
            HideoutIni := IniPath("Hideout")
            IniWrite(1, HideoutIni, "In Hideout", "In Hideout")
            MechanicsIni := IniPath("Mechanics")
            Mechanics := VariableStore("Mechanics")
            ActiveMechanics := Array()
            For Mechanic in Mechanics
                {
                    MechanicVar := Mechanic "Status"
                    MechanicVar:= IniRead(MechanicsIni, "Mechanic Active", Mechanic, 0)
                    If (MechanicVar = 1)
                        {
                            ActiveMechanics.Push(Mechanic)
                        }
                ;     If (TotalActive > 0) and (MechanicVar =1)
                ;         {
                ;             ActiveMechanics := ActiveMechanics ", " Mechanic
                ;             TotalActive++
                ;         }
                ;     If (TotalActive = 0) and (MechanicVar =1)
                ;         {
                ;             ActiveMechanics := Mechanic
                ;             TotalActive++
                ;         }
                }
            If (ActiveMechanics.Length > 0)
            {
                Notify(ActiveMechanics)
            }
        }
    If !InStr(LogLine, HideoutText)
        {
            HideoutIni := IniPath("Hideout")
            InHideout := IniRead(HideoutIni, "In Hideout", "In Hideout", 0) ;Get Hideout status
        }
        
}
 