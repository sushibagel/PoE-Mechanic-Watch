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
msgbox, 1
Gosub, InfluenceTracking
Return 

HideoutEntered:
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
Return

SearchText:
FullSearch = %MyDialogs%,%MyHideout%,%MyDialogsDisable%
Gosub, MechanicsActive
If NewLine contains %MyDialogs%
    {
        For each, Mechanic in StrSplit(AutoMechanicSearch, "|")
        Loop, Read, Resources/Data/%Mechanic%dialogs.txt
        {
            activecheck = %Mechanic%Active
            sleepmechanic = %Mechanic%Sleep
            automechanic = %Mechanic%Auto
            If NewLine contains %A_LoopReadLine%
            {
                If (%activecheck% != 1) and (%sleepmechanic% != 1) and (%automechanic% = 1)
                {
                    GoSub, %Mechanic%
                    Break
                }
                If NewLine contains %IncursionGo%
                {
                    GetLogCode := StrSplit(NewLine, A_Space)
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
                        Break
                    }
                }
            }
        }
    }
If NewLine contains %MyDialogsDisable%
{
    For each, Mechanic in StrSplit(AutoMechanicSearch, "|")
    Loop, Read, Resources/Data/%Mechanic%dialogsdisable.txt
    {
        If NewLine contains %A_LoopReadLine%
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

IfWinActive, First2
{
    Return
}
Return
