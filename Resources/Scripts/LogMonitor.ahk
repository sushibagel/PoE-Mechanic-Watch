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
            NotifyActiveMechanics()
        }
    If !InStr(LogLine, HideoutText) ; If new line doesn't have hideout defined. 
        {
            HideoutStatus := IniPath("Hideout", "Read", , "In Hideout", "In Hideout", 0)
            If (HideoutStatus = 0)
                {
                    NotHideoutLog(LogLine)
                }
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
    Else
        {
            CheckDialogs(LogLine)
        }
}

GetMapName(LogLine)
{
    If InStr(LogLine, "MapWorlds")
        {
            MapReminder()
            MapString := StrSplit(LogLine, "MapWorlds")
            AreaLevel := MapString[1]
            MapString := StrSplit(MapString[2], "`"")
            MapName := MapString[1]
            MapSeed := StrSplit(MapString[2], "with seed ")
            MapSeed := MapSeed[2]
            MapList := IniPath("Map List")
            MapList := FileRead(MapList)
            MiscIni := IniPath("Misc Data")
            LastMap := IniRead(MiscIni, "Map", "Last Map", "Error")
            LastSeed := IniRead(MiscIni, "Map", "Last Seed", "Error")
            AreaLevel := StrSplit(AreaLevel, "Generating level")
            AreaLevel := StrSplit(AreaLevel[2], A_Space)
            AreaLevel := AreaLevel[2]
            If InStr(MapList, MapName) and (MapName != "") and ((MapName != LastMap) or (MapSeed != LastSeed))
                {
                    IniWrite(MapName, MiscIni, "Map", "Last Map")
                    IniWrite(MapSeed, MiscIni, "Map", "Last Seed")
                    ActiveInfluence := GetInfluence()
                    If !(ActiveInfluence = "Maven") and (AreaLevel > 80)
                        {
                            IniWrite("False", MiscIni, "Map", "Maven Map")
                            IncrementInfluence(ActiveInfluence)
                        }
                    If (ActiveInfluence = "Maven") and (AreaLevel > 80)
                        {
                            IniWrite("True", MiscIni, "Map", "Maven Map")
                        }
                }
            Return 1
        }
    Else
        {
            Return 0
        }
} 

CheckDialogs(LogLine)
{
    GetSearches := VariableStore("LogSearch")
    MechanicsIni := IniPath("Mechanics")
    For Mechanic in GetSearches
        {
            Active := IniRead(MechanicsIni, "Mechanics", Mechanic, 0)
            AutoActive := IniRead(MechanicsIni, "Auto Mechanics", Mechanic, 0)
            If (Active > 1) and (AutoActive = 1) ; Check if the mechanic is active and if the auto mechanic is on. 
                {
                    If (Mechanic = "Incursion")
                        {
                           
                        }
                    Else
                        {
                            DialogMatch := CheckDialogText(LogLine, Mechanic)
                            If !(DialogMatch = 1)
                                {
                                    DialogMatch := CheckDialogText(LogLine, Mechanic, "Disable")
                                }
                        }
                }
        }
}

CheckDialogText(LogLine, Mechanic, Version:="")
{
    DialogsPath := "Resources/Data/" Mechanic "dialogs" Version ".txt"
    Loop Read DialogsPath
        {
            If InStr(LogLine, A_LoopReadLine)
                {
                    If (Version = "")
                        {
                            ToggleMechanic(Mechanic, 1, "On")
                        }
                    Else
                        {
                            ToggleMechanic(Mechanic, 1, "Off")
                        }
                    Return 1
                }
        }
}