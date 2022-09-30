#SingleInstance, force
#Persistent
#NoEnv
;#Warn

GroupAdd, PoeWindow, ahk_exe PathOfExileSteam.exe
GroupAdd, PoeWindow, ahk_exe PathOfExile.exe 
GroupAdd, PoeWindow, ahk_exe PathOfExileEGS.exe
GroupAdd, PoeWindow, ahk_class POEWindowClass
GroupAdd, PoeWindow, Reminder
GroupAdd, PoeWindow, InfluenceReminder
GroupAdd, PoeWindow, Overlay
GroupAdd, PoeWindow, ahk_exe code.exe  

Loop 
{
    If !WinActive("ahk_group PoEWindow")
    {
        Sleep, 200
        If !WinActive("ahk_group PoEWindow")
        {
            Gui, Reminder:Destroy
            Gui, InfluenceReminder:Destroy
            Gui, Overlay:Destroy
            WinClose, Overlay
            Loop
            If WinActive("ahk_group PoEWindow")
            {
                Prev_DetectHiddenWindows := A_DetectHiddenWIndows
                Prev_TitleMatchMode := A_TitleMatchMode
                SetTitleMatchMode 2
                DetectHiddenWindows On
                PostMessage, 0x01111,,,, New.ahk - AutoHotkey
                DetectHiddenWindows, %Prev_DetectHiddenWindows%
                SetTitleMatchMode, %A_TitleMatchMode%
                ; If (ReminderActive = 1)
                ; {
                ;     ReminderActive := 0
                ;     ; SetTimer, Reminder, 500
                ; }
                ; If (InfluenceReminderActive = 1)
                ; {
                ;     ; SetTimer, EldritchReminder, 500
                ;     ; SetTimer, InfluenceNotificationSound, 500
                ;     InfluenceReminderActive := 0
                ; }
                Break
            }
        } 
    }
}