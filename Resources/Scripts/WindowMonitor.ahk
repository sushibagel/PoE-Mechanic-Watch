#SingleInstance, force
#Persistent
#NoEnv
#NoTrayIcon
Global MechanicsActive
Global WaitKill
SetTitleMatchMode, 2

GroupAdd, PoeWindow, Reminder
GroupAdd, PoeWindow, InfluenceReminder
GroupAdd, PoeWindow, Influence
GroupAdd, PoeWindow, Transparency 
GroupAdd, PoeWindow, Path of Exile 
GroupAdd, PoeWindow, Overlay
GroupAdd, PoeWindow, OverlaySetup
GroupAdd, PoeWindow, Quick Notify
GroupAdd, PoeWindow, Notification Settings
GroupAdd, PoeWindow, Awakened PoE Trade
GroupAdd, PoeWindow, ahk_exe Code.exe

; OnMessage(0x01192, "ActivateInfluenceReminder")
; OnMessage(0x01155, "DeactivateInfluenceReminder")
; Waitkill := 0
; Start()
; Return

; ;Post Functions
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

SetTitleMatchMode 2
DetectHiddenWindows On

Loop
{
    WinWaitActive, ahk_group PoeWindow
    PostSetup()
    PostMessage, 0x01111,,,, PoE Mechanic Watch.ahk - AutoHotkey ; activate Overlay
    Reminders := Reminders()
    SetTitleMatchMode 3
    For each, Item in StrSplit(Reminders, "|")
    {
       If WinExist(Item)
       {
            WinShow, %Item%
       }
    }
    PostRestore()
    WaitActive()
}

WaitActive()
{
    WinWaitNotActive, ahk_group PoeWindow
    {
        Sleep, 200
        If WinActive("ahk_group PoeWindow")
        {
            Return
        }
        PostSetup()
        PostMessage, 0x012222,,,, PoE Mechanic Watch.ahk - AutoHotkey ; destroy Overlay
        Reminders := Reminders()
        SetTitleMatchMode 3
        For each, Item in StrSplit(Reminders, "|")
        If WinExist(Item)
        {
            WinHide, %Item%
            PostRestore()  
            Return
        }
        DetectHiddenWindows, On
        If !WinExist("Path of Exile")
        {
            WinWaitActive, Path of Exile
            PostSetup()
            PostMessage, 0x01783,,,, PoE Mechanic Watch.ahk - AutoHotkey ;timed update on PoE launch
            PostRestore()
        }
        PostRestore()  
        Return
    }
}

Reminders()
{
    Return, "InfluenceReminder|Maven Reminder|Reminder|Death Recap|Prompt Delete"
}