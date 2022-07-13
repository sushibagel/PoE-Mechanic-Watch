LogMonitor: ;Monitor the PoE client.txt
Global IncursionGo
Global IncursionGo1
Global IncursionGo2
IncursionGo = Master Explorer: Let,Master Explorer: It's time,Master Explorer: Time to

Gosub, GetLogPath
Gosub, ReadAutoMechanics
Loop 
{
    FullSearch = %MyHideout%
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
    FullSearch = %MyDialogs%,%MyHideout%,%MyDialogsDisable%
    Hideout  := TF_Tail(LogPath, 2)
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
                Break
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
                    }
                    If Hideout contains %IncursionGo%
                    {
                        IncursionSleep ++
                        If (IncursionSleep = 3)
                        {
                            Loop
                            {
                            Hideout  := TF_Tail(LogPath, 2)
                            If Hideout not contains %IncursionGo%
                            {
                                Break
                            }
                            }
                            GoSub, Incursion
                        }
                        If (IncursionSleep <= 2)
                        {
                            Loop
                            {
                            Hideout  := TF_Tail(LogPath, 2)
                            If Hideout not contains %IncursionGo%
                            {
                                Break
                            }
                            }
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
}
Return
