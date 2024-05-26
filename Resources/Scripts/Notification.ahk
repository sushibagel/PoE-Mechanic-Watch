Notify(ActiveMechanics)
{
    NotificationIni := IniPath("Notifications")
    UseQuick := IniRead(NotificationIni, "Mechanic Notification", "Use Quick", 0)
    If (UseQuick = 0)
        {
            NotificationBig(ActiveMechanics)
        }
    If (UseQuick = 1)
        {
            QuickNotify(ActiveMechanics, 1)
        }
}

NotificationBig(ActiveMechanics) ;will need to replace last comma with "and"
{
    NotificationBigDestroy()
    NotificationInfo := NotificationVars("Mechanic Notification")
    If (NotificationInfo[1] = 0)
        {
            Return
        }
    CurrentTheme := GetTheme()
    Notification.BackColor := CurrentTheme[1]
    Notification.SetFont("s12 c" CurrentTheme[3])
    If (ActiveMechanics.Length = 1)
        {
            MechanicText := ActiveMechanics[1] " is still active. Did you forget to complete it?"
        }
    If (ActiveMechanics.Length > 1)
        {
            Loop ActiveMechanics.Length
                {
                    If (A_Index = 1)
                        {
                            MechanicText := ActiveMechanics[A_Index]
                        }
                    Else If (A_Index = ActiveMechanics.Length)
                        {
                            MechanicText := MechanicText " and " ActiveMechanics[A_Index] " are still active. Did forget to complete them?"
                        }
                    Else
                        {
                            MechanicText := MechanicText ", " ActiveMechanics[A_Index]
                        }
                }
        }
    Notification.Add("Text", "Center w500", MechanicText)
    Notification.Add("Button", "XM Section x125 w50", "Yes").OnEvent("Click", NotificationBigDestroy)
    Notification.Add("Button", "YS x350 w50", "No").OnEvent("Click", NoReminderButton.Bind(ActiveMechanics))
    Notification.Opt("-Caption")
    If (NotificationInfo[5] = 1)
        {
            NotificationSound(NotificationInfo[6], NotificationInfo[7])
        }
    Notification.Show
    WinSetTransparent(NotificationInfo[4], "PoE Mechanic Watch Notification")
}

NotificationBigDestroy(*)
{
    If WinExist("PoE Mechanic Watch Notification")
        {
            Notification.Destroy
        }
    Global Notification := Gui(,"PoE Mechanic Watch Notification")
}

NoReminderButton(ActiveMechanics, *)
{
    NotificationBigDestroy()
    For Mechanic in ActiveMechanics
        {
            Toggle(Mechanic, 0)
        }
    RefreshOverlay()
}

NotificationSound(SoundPath, SoundVolume)
{
    SoundPlay("Resources\Sounds\blank.wav", False)
    DetectHiddenWindows True
    ScriptInfo := WinGetProcessName("test")
    AppVol("AutoHotkey64.exe", SoundVolume)
    SoundPlay(SoundPath, False)
}

QuickNotify(Mechanics, MechanicVersion:=0, MoveQuick:=0)
{
    QuickNotifyDestroy()
    NotificationInfo := NotificationVars("Quick Notification")
    If (NotificationInfo[1] = 0)
        {
            Return
        }
    PosY := NotificationInfo[2]
    PosX := NotificationInfo[3]
    QuickDuration := NotificationInfo[8]
    CurrentTheme := GetTheme()
    QuickNotification.BackColor := CurrentTheme[1]
    QuickNotification.SetFont("s12 c" CurrentTheme[3])
    If (MechanicVersion = 1)
        {
            MechanicText := MechanicQuickText(Mechanics)
            NotificationInfo := NotificationVars("Mechanic Notification")
        }
    If (MechanicVersion = 2)
        {
            MechanicText := Mechanics
            NotificationInfo := NotificationVars("Map Notification")
        }
    If (MoveQuick = 0)
    {
        QuickNotification.Opt("-Caption")
    }
    QuickNotification.Add("Text",, MechanicText)

    If (NotificationInfo[5] = 1)
        {
            NotificationSound(NotificationInfo[6], NotificationInfo[7])
        }
    
    QuickNotification.Show(PosX PosY)
    WinSetTransparent(NotificationInfo[4], "Quick Notification")
    SetTimer QuickNotifyDestroy, QuickDuration
}

QuickNotifyDestroy()
{
    If WinExist("Quick Notification")
        {
            QuickNotification.Destroy
        }
    Global QuickNotification := Gui(,"Quick Notification")
    SetTimer QuickNotifyDestroy, 0
}

MechanicQuickText(Mechanics)
{
    If (Mechanics.Length = 1)
        {
            MechanicText := Mechanics[1] " is still active. Don't forget to complete it."
        }
    If (Mechanics.Length > 1)
        {
            Loop Mechanics.Length
                {
                    If (A_Index = 1)
                        {
                            MechanicText := Mechanics[A_Index]
                        }
                    Else If (A_Index = Mechanics.Length)
                        {
                            MechanicText := MechanicText " and " Mechanics[A_Index] " are still active. Don't forget to complete them."
                        }
                    Else
                        {
                            MechanicText := MechanicText ", " Mechanics[A_Index]
                        }
                }
        }
    Return MechanicText
}

MapReminder()
{
    NotificationIni := IniPath("Notifications")
    MapReminderActive := IniRead(NotificationIni, "Map Notification", "Active", 0)
    If (MapReminderActive = 1)
        {
            MapReminderType := IniRead(NotificationIni, "Map Notification", "Type", "Quick")
            NotificationText := IniRead(NotificationIni, "Map Notification", "Notification Text", "Don't forget to enable your buffs!")
            If (MapReminderType = "Quick")
                {
                    QuickNotify(NotificationText, 2)
                }
        }
}