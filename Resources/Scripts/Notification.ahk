Notify(ActiveMechanics)
{
    NotificationIni := IniPath("Notifications")
    UseQuick := IniRead(NotificationIni, "Mechanic Notification", "Use Quick", 0)
    If (UseQuick = 0)
        {
            NotificationBig(ActiveMechanics)
        }
}

NotificationBig(ActiveMechanics, MoveNotification:=0) ;will need to replace last comma with "and"
{
    NotificationBigDestroy()
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
    If (MoveNotification =1)
        {
            Notification.Opt("-Caption")
        }
    NotificationInfo := NotificationVars("Mechanic Notification")
    Notification.Show
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
    Loop ActiveMechanics.Length
        {
            Toggle(ActiveMechanics[A_Index])
        }
    RefreshOverlay()
}

^a::
{
    test := ["Blight", "Betrayal", "Expedition", "Ritual"]
    NotificationBig(test)
}
