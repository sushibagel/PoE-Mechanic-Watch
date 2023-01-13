Global ReminderText
Global Font
Global Background
Global Secondary

Reminder()
{
    Gui, Reminder:Destroy
    ;;;;;;;;;;;;;;;;;; Read Status of Mechanics ;;;;;;;;;;;;;;;;
    MechanicsActive()
    Active = 
    MechanicsActive := 0
    MechanicSearch := Mechanics()
    For each, Mechanic in StrSplit(MechanicSearch, "|")
    {
        mechanicactive = %Mechanic%Active
        If (%mechanicactive% = 1)
        {
            Active = %Active% %Mechanic%
            MechanicsActive ++
        }
    }
    If (MechanicsActive >= 3)
    {
        TMech := MechanicsActive - 2
        ReminderText1 := StrReplace(Active, A_Space,",",, TMech)
        Active1 := StrReplace(ReminderText1, A_Space, "and",, 1)
        ReminderText2 := StrReplace(Active1, ",", ","A_Space)
        Active2 := StrReplace(ReminderText2, "and", A_Space "and"A_Space)
        ReminderText := Active2
    }

    If (MechanicsActive = 2)
    {
        ReminderText := StrReplace(Active, A_Space, A_Space "and" A_Space,, 1)
    }

    If (MechanicsActive = 1)
    {
        ReminderText := Active
    }

    If ReminderText contains Searing
    {
        StringReplace, ReminderText, ReminderText,`, Searing,
    }
    If ReminderText contains Eater
    {
        StringReplace, ReminderText, ReminderText,`, Eater,
    }
    MechanicReminder()
    NotificationPrep("Notification")
    If (SoundActive = 1)
    {
        SoundPlay, Resources\Sounds\blank.wav ;;;;; super hacky workaround but works....
        SetTitleMatchMode, 2
        WinGet, AhkExe, ProcessName, Reminder
        SetTitleMatchMode, 1
        SetWindowVol(AhkExe, NotificationVolume)
        SoundPlay, %NotificationSound%
}
}

ReminderButtonYes()
{
    Gui, Reminder:Submit
    PostSetup()
    RefreshOverlay()
    OnMessage(0x01111, "RefreshOverlay")
    PostRestore()
    Return
}

ReminderButtonNo()
{
    Gui, Reminder:Submit
    MechanicIniPath := MechanicsIni()
    MechanicSearch := Mechanics()
    For each, Mechanic in StrSplit(MechanicSearch, "|")
    {
        IniWrite, 0, %MechanicIniPath%, Mechanic Active, %Mechanic%
    }
    VariablePath := VariableIni()
    IniWrite, 0, %VariablePath%, Incursion, Sleep Count
    NotificationIni := NotificationIni()
    IniWrite, 0, %NotificationIni%, Notification Active, Mechanic Notification Active
    Gui, Reminder:Destroy
    OnMessage(0x01111, "RefreshOverlay")
    RefreshOverlay()
    Return
}

ReminderDestroy()
{
    Gui, Reminder:Destroy
}