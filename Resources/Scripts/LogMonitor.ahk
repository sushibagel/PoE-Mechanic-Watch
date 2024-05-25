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
    If InStr(LogLine, HideoutText) ; If hideout is entered
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
                }
            If (ActiveMechanics.Length > 0)
            {
                Notify(ActiveMechanics)
            }
        }
    If !InStr(LogLine, HideoutText) ; If new line doesn't have hideout defined. 
        {
            NotHideoutLog(LogLine)
        }
        
}
 
NotHideoutLog(LogLine)
{
    ;Check new lines against active mechanics with dialogs
    If InStr(LogLine, "Generating level") and InStr(LogLine, "with seed") ;These lines indicate a new zone has been entered. 
        {
            HideoutIni := IniPath("Hideout")
            HideoutStatus := IniRead(HideoutIni,"In Hideout", "In Hideout", 0)
            If (HideoutStatus = 1)
                {
                    IniWrite(0, HideoutIni, "In Hideout", "In Hideout")
                }
            GetMapName(LogLine)
        } 
}

GetMapName(LogLine)
{
    If InStr(LogLine, "MapWorlds")
        {
            MapString := StrSplit(LogLine, "MapWorlds")
            MapString := StrSplit(MapString[2], "`"")
            MapName := MapString[1]
            MapList := IniPath("Map List")
            MapList := FileRead(MapList)
            If InStr(MapList, MapName) and (MapName != "")
                {
                    msgbox "test"
                    ;insert map message code
                }
        }
}


^a::
{
    GetMapName("2022/09/05 06:45:01 575734343 118693cb [DEBUG Client 31600] Generating level 83 area `"MapWorldsRacecourse_`" with seed 667343842")
}