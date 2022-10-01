#SingleInstance, force
#Persistent
#NoEnv
#NoTrayIcon
;#Warn

Global ColorMode
Global Background
Global Font
Global Secondary

OnMessage(0x01112, "Reminder")
OnMessage(0x01113, "ReminderDestroy")

Loop
{
    LogMonitorIni := LogMonitorIni()
    IniRead, LogEvent, %LogMonitorIni%, Log Monitor, Log Event
    If (LogEvent = "Hideout")
    {
        IniWrite, InHideout, %LogMonitorIni%, Log Monitor, Log Event
        MechanicsActive()
        If (MechanicsActive >= 1)
        {
            Reminder()
        }
    }
}

CheckTheme()
{
    ThemeItems := "Font|Background|Secondary"
    ThemeFile := ThemeIni()
    IniRead, ColorMode, %ThemeFile%, Theme, Theme
    For each, Item in StrSplit(ThemeItems, "|")
    {
        IniRead, %Item%, %ThemeFile%, %ColorMode%, %Item%
    }
    Return, %ColorMode%
}

#IncludeAgain, Resources/Scripts/Ini.ahk
#IncludeAgain, Resources/Scripts/Mechanics.ahk
#IncludeAgain, Resources/Scripts/Reminder.ahk
#IncludeAgain, Resources/Scripts/ReminderGui.ahk
#IncludeAgain, Resources/Scripts/NotificationSounds.ahk
#IncludeAgain, Resources/Scripts/Transparency.ahk