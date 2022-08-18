LogMonitor: ;Monitor the PoE client.txt

ReadFile := "C:\Users\drwsi\Documents\PoE Mechanic Watch\PoE-Mechanic-Watch\Resources\Data\Incursiondialogsdisable.txt"
FileRead, Read1, %ReadFile%
IncursionGo := StrReplace(Read1, "`r`n" , ",")

Gosub, GetLogPath
Gosub, ReadAutoMechanics

IfWinNotActive, ahk_group PoeWindow
{
    Sleep, 100
    IfWinNotActive, ahk_group PoeWindow
    {
        Gui, 1:Destroy
        Gui, 2:Destroy
        Loop
        {
            IfWinActive, ahk_group PoeWindow
            {
                Gosub, Overlay
                Gosub, LogMonitor
                Break
            }
        }
    }
}

FullSearch =
MyDialogs = 
MyDialogsDisable =
For each, Mechanic in StrSplit(AutoMechanicSearch, "|")
{
    autocheck = %Mechanic%Auto
    if (%autocheck% = 1)
    {
        Loop, Read, Resources/Data/%Mechanic%dialogs.txt
        {
            if (MyDialogs = "")
            {
                MyDialogs = %A_LoopReadLine%
            }
            Else
            {
                MyDialogs = %MyDialogs%,%A_LoopReadLine%
            }
        }
        Loop, Read, Resources/Data/%Mechanic%dialogsdisable.txt
        {
            if (MyDialogsDisable = "")
            {
                MyDialogsDisable = %A_LoopReadLine%
            }
            Else
            {
                MyDialogsDisable = %MyDialogsDisable%,%A_LoopReadLine%
            }
        }
    }
}
Gosub, InfluenceTracking
lt := new CLogTailer(LogPath, Func("SearchOnNewLine"))
Logwait = 

SearchOnNewLine(text)
{
If (MyDialogsDisable != "")
{
    FullSearch = %MyHideout%,%MyDialogs%,%MyDialogsDisable%
}
Else
{
    FullSearch = %MyHideout%
}
Hideout := % text
If Hideout contains %FullSearch%
    {
        Logwait = 1
        Return, Stop
    }
}

Loop
{
    IfWinNotActive, ahk_group PoeWindow
    {
        Sleep, 200
        IfWinNotActive, ahk_group PoeWindow
        {
            Gui, 2:Destroy
            Gosub, Monitor
        }
    }
    If (LogWait = 1)
    {
        LogWait =
        Break
    }

}

SearchText:
FullSearch = %MyDialogs%,%MyHideout%,%MyDialogsDisable%
If Hideout contains %FullSearch% 
{
    If Hideout contains %MyHideout%
    {
        If (sleepmechanic != "")
        {
            %sleepmechanic% = 0
        }
        GoSub, MechanicsActive
        If (MechanicsActive >= 1)
        {
            GoSub, Reminder
            WinwaitClose, Reminder
            Return
        }
        Else
        {
            Gosub, LogMonitor
        }
    }
Gosub, MechanicsActive
If Hideout contains %MyDialogs%
    {
        For each, Mechanic in StrSplit(AutoMechanicSearch, "|")
        Loop, Read, Resources/Data/%Mechanic%dialogs.txt
        {
            activecheck = %Mechanic%Active
            sleepmechanic = %Mechanic%Sleep
            automechanic = %Mechanic%Auto
            If Hideout contains %A_LoopReadLine%
            {
                If (%activecheck% != 1) and (%sleepmechanic% != 1) and (%automechanic% = 1)
                {
                    GoSub, %Mechanic%
                    Gosub, LogMonitor
                }
                If Hideout contains %IncursionGo%
                {
                    GetLogCode := StrSplit(Hideout, A_Space)
                    Code = % GetLogCode[3]
                    If (Code = IncursionCode) and (Code != "")
                    {
                        Break
                    }
                    IncursionCode := Code
                    IncursionSleep ++
                    If (IncursionSleep = 4)
                    {
                        GoSub, Incursion
                        Gosub, LogMonitor
                    }
                }
            }
        }
    }
If Hideout contains %MyDialogsDisable%
    {
        For each, Mechanic in StrSplit(AutoMechanicSearch, "|")
        Loop, Read, Resources/Data/%Mechanic%dialogsdisable.txt
        {
            If Hideout contains %A_LoopReadLine%
            {
            activecheck = %Mechanic%Active
            sleepmechanic = %Mechanic%Sleep
            automechanic = %Mechanic%Auto
                If (%activecheck% = 1) and (%sleepmechanic% != 1) and (%Mechanic% != Incursion)
                {
                    %sleepmechanic% = 1
                    GoSub, %Mechanic%
                    Break 
                }  
            }
        }
    }
}
IfWinActive, First2
{
    Return
}
Return
