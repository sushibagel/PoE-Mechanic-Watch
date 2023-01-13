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
GroupAdd, PoeWindow, Overlay Setup
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
Start()

Start()
{
    WinWaitActive, ahk_group PoeWindow
    PostSetup()
    PostMessage, 0x01111,,,, PoE Mechanic Watch.ahk - AutoHotkey ; activate Overlay
    Reminders := Reminders()
    For each, Item in StrSplit(Reminders, "|")
    {
       If WinExist(Item)
       {
            WinShow, %Item%
       }
    }
    PostRestore()
    WaitActive()
    Exit
}

WaitActive()
{
    WinWaitNotActive, ahk_group PoeWindow
    {
        Sleep, 200
        If WinActive("ahk_group PoeWindow")
        {
            Start()
        }
        PostSetup()
        PostMessage, 0x012222,,,, PoE Mechanic Watch.ahk - AutoHotkey ; destroy Overlay
            Reminders := Reminders()
        For each, Item in StrSplit(Reminders, "|")
        If WinExist(Item)
        {
            WinHide, %Item%
        }
        PostRestore()  
        Start()
    }
}

Reminders()
{
    Return, "InfluenceReminder|Reminder|Death Recap|Prompt Delete"
}