#SingleInstance, force
#Persistent
#NoEnv
#NoTrayIcon
Global MechanicsActive
;#Warn
SetTitleMatchMode, 3

GroupAdd, PoeWindow, Reminder
GroupAdd, PoeWindow, InfluenceReminder
GroupAdd, PoeWindow, Influence
GroupAdd, PoeWindow, Transparency 
GroupAdd, PoeWindow, Path of Exile 
GroupAdd, PoeWindow, Overlay
GroupAdd, PoeWindow, Quick Notify
GroupAdd, PoeWindow, ahk_exe PoE Instant Messenger.exe
; GroupAdd, PoeWindow, Awakened PoE Trade

Global ReminderActive
Global InfluenceReminderActive

OnMessage(0x01118, "DeactivateReminder")
OnMessage(0x01192, "ActivateInfluenceReminder")
OnMessage(0x01155, "DeactivateInfluenceReminder")

Start()
Return

;Post Functions
PostSetup()
{
    Prev_DetectHiddenWindows := A_DetectHiddenWIndows
    Prev_TitleMatchMode := A_TitleMatchMode
    SetTitleMatchMode 2
    DetectHiddenWindows On
}

PostRestore()
{
    DetectHiddenWindows, %Prev_DetectHiddenWindows%
    SetTitleMatchMode, %A_TitleMatchMode%
}

;Variable functions
DeactivateReminder()
{
    ReminderActive := 0
}

DeactivateInfluenceReminder()
{
    InfluenceReminderActive := 0
}

ActivateInfluenceReminder()
{
    InfluenceReminderActive := 1
}

;Script start. This is the main running portion. 
Start()
{
    PostSetup()
    PostMessage, 0x01111,,,, PoE Mechanic Watch.ahk - AutoHotkey ; activate reminder
    PostRestore()
    
    MechanicsActive := MechanicsActive()
    If (MechanicsActive >= 1)
        {
            PostMessage, 0x01112,,,, Tail.ahk - AutoHotkey ;Activate reminder again
        }
    ; If (ReminderActive = 1)
    ; {
    ;     ReminderActive := 0
    ;     PostMessage, 0x01112,,,, Tail.ahk - AutoHotkey ;Activate reminder again
    ; }
    If (InfluenceReminderActive = 1)
    {
        ReminderActive := 0
        PostMessage, 0x01123,,,, Tail.ahk - AutoHotkey ;Activate Influence reminder again
    }
    DetectHiddenWindows, %Prev_DetectHiddenWindows%
    SetTitleMatchMode, %A_TitleMatchMode%
    Sleep, 100
    If !WinExist("Overlay")
    {
        PostMessage, 0x01111,,,, PoE Mechanic Watch.ahk - AutoHotkey ; activate reminder
    }
    Monitor()
    Return
}

Monitor()
{
    tooltip ;intentional
    OnWin("NotActive", "Path of Exile", Func("Kill"))
}

Kill()
{
    Sleep, 200
    If WinActive("ahk_group PoeWindow")
    {
        If !WinActive("Overlay")
        {
            Monitor()
        }
        Exit
    }
    Else
    {
        Gui, InfluenceReminder:Destroy
        PostSetup()
        PostMessage, 0x012222,,,, PoE Mechanic Watch.ahk - AutoHotkey ; destroy Overlay
        PostRestore()  
        SetTitleMatchMode, 3
        If WinExist("Reminder")
        {
            PostSetup()
            ReminderActive := 1
            PostMessage, 0x01113,,,, Tail.ahk - AutoHotkey ; destroy reminder 
            PostRestore()
        }
        SetTitleMatchMode, 3
        If WinExist("InfluenceReminder")
        {
            PostSetup()
            InfluenceReminderActive := 1
            PostMessage, 0x01122,,,, Tail.ahk - AutoHotkey ; destroy reminder 
            PostRestore()
        }
        SetTitleMatchMode, 2
        Loop
        {
            OnWin("Active", "Path of Exile", Func("Start"))
            Break
        }
    }
}

MechanicsActive()
{
    MechanicsActive := 0
    MechanicsPath := "Resources\Settings\Mechanics.ini"
    MechanicSearch := Mechanics()
    For each, Mechanic in StrSplit(MechanicSearch, "|")
    {
        IniRead, %Mechanic%, %MechanicsPath%, Mechanic Active, %Mechanic%
        If (%Mechanic% = 1)
        {
            %Mechanic%Active := 1
            MechanicsActive ++
        }
        If (%Mechanic% = 0)
        {
            %Mechanic%Active := 0
        }
    }
    Return
}

Mechanics() ;List of Mechanics
{
    Return, "Abyss|Blight|Breach|Expedition|Harvest|Incursion|Legion|Metamorph|Ritual|Generic"
}