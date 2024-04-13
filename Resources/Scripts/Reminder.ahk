Global ReminderText
Global Font
Global Background
Global Secondary

Reminder()
{
    Gui, Reminder:Destroy
    ReminderText := 
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
    NotificationIni := NotificationIni()
    IniRead, QuickCheck, %NotificationIni%, Notification Trigger, Quick Triggered, 0
    IniRead, UseQuick, %NotificationIni%, Notification Trigger, Use Quick, 0
    If (QuickCheck = 1) and (UseQuick = 1)
        {
            Gui, Quick:Destroy
            IniRead, Duration, %NotificationIni%, Map Notification Position, Duration, 3000
            If (MechanicsActive > 1)
                {
                    ReminderText := Remindertext " are still active. Don't forget to complete them."
                }
            Else
                {
                    ReminderText := Remindertext " is still active. Don't forget to complete it."
                }
            QuickNotify(ReminderText)
            SetTimer, QuickDestroy, %Duration%
        }
    Else
        {
            MechanicReminder()
        }
    IniWrite, 0, %NotificationIni%, Notification Trigger, Quick Triggered
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
    Gui, Reminder:Destroy
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
    NotificationIni := NotificationIni()
    Gui, Reminder:Destroy
    OnMessage(0x01111, "RefreshOverlay")
    RefreshOverlay()
    Return
}

ReminderDestroy()
{
    Gui, Reminder:Destroy
}

QuickDestroy()
{
    Gui, Quick:Destroy
}