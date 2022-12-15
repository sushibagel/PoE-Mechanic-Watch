#SingleInstance, force
#Persistent
#NoEnv
#NoTrayIcon
;#Warn
SetTitleMatchMode, 3

; GroupAdd, PoeWindow, ahk_exe Code.exe
GroupAdd, PoeWindow, ahk_exe PathOfExileSteam.exe
GroupAdd, PoeWindow, ahk_exe PathOfExile.exe 
GroupAdd, PoeWindow, ahk_exe PathOfExileEGS.exe
GroupAdd, PoeWindow, ahk_class POEWindowClass
GroupAdd, PoeWindow, Reminder
GroupAdd, PoeWindow, InfluenceReminder
GroupAdd, PoeWindow, Overlay
GroupAdd, PoeWindow, Awakened PoE Trade 
GroupAdd, PoeWindow, Influence
GroupAdd, PoeWindow, Transparency 

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
    If (ReminderActive = 1)
    {
        ReminderActive := 0
        PostMessage, 0x01112,,,, Tail.ahk - AutoHotkey ;Activate reminder again
    }
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
    SetTitleMatchMode, 2
    Loop
    {
        OnWin("NotActive", "Path of Exile", Func("Kill"))
        Break
    }
}

Kill()
{
    Gui, InfluenceReminder:Destroy
    WinClose, Overlay
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
    CheckActive()
}

CheckActive()
{
    Loop
    {
        OnWin("Show", "Path of Exile", Func("Start"))
        Break
    }
}