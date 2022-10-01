#SingleInstance, force
#Persistent
#NoEnv
#NoTrayIcon
;#Warn

GroupAdd, PoeWindow, ahk_exe PathOfExileSteam.exe
GroupAdd, PoeWindow, ahk_exe PathOfExile.exe 
GroupAdd, PoeWindow, ahk_exe PathOfExileEGS.exe
GroupAdd, PoeWindow, ahk_class POEWindowClass
GroupAdd, PoeWindow, Reminder
GroupAdd, PoeWindow, InfluenceReminder
GroupAdd, PoeWindow, Overlay
GroupAdd, PoeWindow, ahk_exe code.exe  

Global ReminderActive

Loop 
{
    If !WinActive("ahk_group PoEWindow")
    {
        Sleep, 200
        If !WinActive("ahk_group PoEWindow")
        {
            Gui, InfluenceReminder:Destroy
            WinClose, Overlay,,,Visual Studio Code
            If WinExist("Reminder")
            {
                PostSetup()
                ReminderActive := 1
                PostMessage, 0x01113,,,, NotificationMonitor.ahk - AutoHotkey
            }
            Loop
            If WinActive("ahk_group PoEWindow")
            {
                Prev_DetectHiddenWindows := A_DetectHiddenWIndows
                Prev_TitleMatchMode := A_TitleMatchMode
                SetTitleMatchMode 2
                DetectHiddenWindows On
                PostMessage, 0x01111,,,, New.ahk - AutoHotkey
                PostRestore()
                If (ReminderActive = 1)
                {
                    ReminderActive := 0
                    PostMessage, 0x01112,,,, NotificationMonitor.ahk - AutoHotkey
                }
                ; If (InfluenceReminderActive = 1)
                ; {
                ;     ; SetTimer, EldritchReminder, 500
                ;     ; SetTimer, InfluenceNotificationSound, 500
                ;     InfluenceReminderActive := 0
                ; }
                DetectHiddenWindows, %Prev_DetectHiddenWindows%
                SetTitleMatchMode, %A_TitleMatchMode%
                Break
            }
        } 
    }
}

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