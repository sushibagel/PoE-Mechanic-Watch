#SingleInstance, force
#Persistent
#NoEnv
;#Warn

Loop
{
    LogMonitorIni := LogMonitorIni()
    IniRead, LogEvent, %LogMonitorIni%, Log Monitor, Log Event
    If (LogEvent = "Hideout")
    {
        IniWrite, InHideout, %LogMonitorIni%, Log Monitor, Log Event
        Msgbox, Hideout Entered!
    }
}

#IncludeAgain, Resources/Scripts/Ini.ahk