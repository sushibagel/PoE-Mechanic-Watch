Notify(ActiveMechanics, Type)
{
    NotificationIni := IniPath("Notifications")
    UseQuick := IniRead(NotificationIni, Type, "Use Quick", 0)
    If (UseQuick = 0)
        {
            NotificationBig(ActiveMechanics, Type)
        }
    If (UseQuick = 1)
        {
            If (Type = "Mechanic Notification")
                {
                    Version := 1
                }
            If (Type = "Custom Reminder")
                {
                    Version := 2
                }
            QuickNotify(ActiveMechanics, Version)
        }
}

NotificationBig(ActiveMechanics, Type)
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
    If (Type = "Mechanic Notification")
        {
            MechanicNotificationSetup(ActiveMechanics)
            If (NotificationInfo[5] = 1)
                {
                    NotificationSound(NotificationInfo[6], NotificationInfo[7])
                }
        }
    If (Type = "Custom Reminder") or (Type = "Influence Notification") or (Type = "Maven Notification")
        {
            MapNotificationSetup(ActiveMechanics)
            NotificationInfo := NotificationVars(Type)
            If (NotificationInfo[5] = 1)
                {
                    NotificationSound(NotificationInfo[6], NotificationInfo[7])
                }
        }
    Notification.Opt("-Caption")
    Notification.Show
    WinSetTransparent(NotificationInfo[4], "PoE Mechanic Watch Notification")
}

MechanicnotificationSetup(ActiveMechanics)
{
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
}

MapNotificationSetup(MechanicText)
{
    Notification.Add("Text", "Center", MechanicText)
    Notification.Add("Button", "XM Section w50", "OK").OnEvent("Click", NotificationBigDestroy)
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
    MechanicsIni := IniPath("Mechanics")
    For Mechanic in ActiveMechanics
        {
            CurrentStatus := IniRead(MechanicsIni, "Mechanic Active", Mechanic, 0)
            If (CurrentStatus = 1)
            {
                ToggleMechanic(Mechanic, 0)
            }
        }
    RefreshOverlay()
}

NotificationSound(SoundPath, SoundVolume)
{
    SoundPlay("Resources\Sounds\blank.wav", False)
    DetectHiddenWindows True
    ScriptInfo := WinGetProcessName("PoE Mechanic Watch")
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
    PosY := NotificationInfo[3]
    PosX := NotificationInfo[2]
    QuickDuration := NotificationInfo[8]
    CurrentTheme := GetTheme()
    QuickNotification.BackColor := CurrentTheme[1]
    QuickNotification.SetFont("s12 c" CurrentTheme[3])
    If (MechanicVersion = 1)
        {
            MechanicText := MechanicQuickText(Mechanics)
            NotificationInfo := NotificationVars("Mechanic Notification")
            Type := "Mechanic Notification"
        }
    If (MechanicVersion = 2)
        {
            MechanicText := Mechanics
            NotificationInfo := NotificationVars("Custom Reminder")
            PosY:= NotificationInfo[2]
            PosX:= NotificationInfo[3]
            Type := "Custom Reminder"
            QuickDuration := NotificationInfo[8]
        }
    If (MechanicVersion = 3)
        {
            MechanicText := Mechanics
            NotificationInfo := NotificationVars("Quick Notification")
            Type := "Quick Notification"
        }
    If (MechanicVersion = 4)
        {
            MapHotkey := GetMapHotkey()
            MechanicText := "You just entered a new map press" A_Space  MapHotkey A_Space "to subtract 1 map"
            NotificationInfo := NotificationVars("Quick Notification")
            Type := "Quick Notification"
        }
    QuickNotification.Add("Text",, MechanicText)
    If (MoveQuick = 0)
        {
            QuickNotification.Opt("-Caption +AlwaysOnTop")
            SetTimer QuickNotifyDestroy, QuickDuration
        }
    If (MoveQuick = 1)
        {
            QuickNotification.SetFont("s8 c" CurrentTheme[3])
            NotificationIni := IniPath("Notifications")
            VerticalStatus := IniRead(NotificationIni, Type, "Vertical", 0)
            HorizontalStatus := IniRead(NotificationIni, Type, "Horizontal", 0)
            If VerticalStatus = ""
                {
                    VerticalStatus := 1
                }
            If (HorizontalStatus = "")
                {
                    HorizontalStatus := 1
                }
            VerticalCheck := QuickNotification.Add("Checkbox", "YM Section Checked" VerticalStatus, "Center Vertically")
            HorizontalCheck := QuickNotification.Add("Checkbox", "XP Checked" HorizontalStatus, "Center Horizontally")
            QuickNotification.OnEvent("Close",QuickNotifyDestroy)
            QuickNotification.SetFont("s10 c" CurrentTheme[3])
            QuickNotification.Add("Button", "YM", "Lock").OnEvent("Click", LockQuick.Bind(Type, VerticalCheck, HorizontalCheck))
            QuickNotification.SetFont("s8 Bold c" CurrentTheme[2])
            QuickNotification.Add("Text", "XM", "Drag the notification around and press `"Lock`" to store it's location.")
            QuickNotification.SetFont("s10 c" CurrentTheme[3])
        }
    If (NotificationInfo[5] = 1)
        {
            NotificationSound(NotificationInfo[6], NotificationInfo[7])
        }
    QuickNotification.Show(PosX PosY "NoActivate")
    WinSetTransparent(NotificationInfo[4], "Simple Notification")
}

QuickNotifyDestroy(*)
{
    If WinExist("Simple Notification")
        {
            QuickNotification.Destroy
            If WinExist("Custom Reminder Setup")
                {
                    WinRestore
                }
        }
    Global QuickNotification := Gui(,"Simple Notification")
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
    MapReminderActive := IniRead(NotificationIni, "Custom Reminder", "Active", 0)
    If (MapReminderActive = 1)
        {
            MapReminderType := IniRead(NotificationIni, "Custom Reminder", "Type", "Quick")
            NotificationText := IniRead(NotificationIni, "Custom Reminder", "Notification Text", "Don't forget to enable your buffs!")
            If (MapReminderType = "Quick")
                {
                    QuickNotify(NotificationText, 2)
                }
            If (MapReminderType = "Permanent")
                {
                    NotificationBig(NotificationText, "Custom Reminder")
                }
        }
}

NotificationGuiDestroy(NotificationGui)
{
    NotificationGui.Destroy()
}

ExplainNote(NoteSelected, *)
{
    FootnoteMenu := Menu()
    If (NoteSelected = "Opacity")
        {
            FootnoteMenu.Add("The opacity setting determines how visible/transparent (opaque)", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("the notification is. If set to 0 the notification will be", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("invisible at 255 notification will be 100% opaque.", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    If (NoteSelected = "Triggers")
        {
            FootnoteMenu.Add("There are two trigger settings `"Hideout`" and `"Hotkey`".", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("When enabled the Hideout trigger will trigger Mechanic", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("Notifications upon returning to your hideout. The Hotkey", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("trigger will cause notifications to be triggered when a", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("configured hotkey is pressed (See the Hotkey menu item", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("to configure the key).", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add(A_Space, DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("If the `"Hotkey`" trigger is active it's highly recommended", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("to setup your `"Chat Delay`" hotkey and utilize", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("`"Quick Notificaitons`".", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    If (NoteSelected = "Quick")
        {
            FootnoteMenu.Add("If checked Quick Notifications will be used instead of", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("Permanent Notifications (Permanent notifications will stay", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("open unless a button is clicked). To change the duration,", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("location and transparency of the quick notifcations see", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("the settings in the `"Quick Notification`" section.", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    If (NoteSelected = "Delay")
        {
            FootnoteMenu.Add("`"Chat Delay`" is the number of seconds the Notification Trigger Hotkey", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("will be disabled for each time the Chat Hotkey (Enter by default) is", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("pressed. This is done to help prevent accidental activation while", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("typing in chat. To disable set to `"0`".", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    FootnoteMenu.Show()
}

EnableCheck(NotificationType, Status, *)
{
    NotificationIni := IniPath("Notifications")
    IniWrite(Status.Value, NotificationIni, NotificationType, "Active")
}

SoundCheck(NotificationType, Status, *)
{
    NotificationIni := IniPath("Notifications")
    IniWrite(Status.Value, NotificationIni, NotificationType, "Sound Active")
}

SoundAction(NotificationType, Button, *)
{
    NotificationIni := IniPath("Notifications")
    If (Button = "Sound")
        {
            SelectedFile := FileSelect("S1", A_MyDocuments, "Select an Audio File", "Audio (*.wav; *.mp2; *.mp3)")
            If !(SelectedFile = "")
                {
                    IniWrite(SelectedFile, NotificationIni, NotificationType, "Sound Path")
                }
        }
    If (Button = "Test")
        {
            SoundFile := NotificationVars(NotificationType)
            SoundPlay("Resources\Sounds\blank.wav", False)
            DetectHiddenWindows True
            ScriptInfo := WinGetProcessName("PoE Mechanic Watch - Settings")
            AppVol("AutoHotkey64.exe", SoundFile[7])
            SoundPlay(SoundFile[6], False)
        }
}

VolumeAdjust(NotificationType, Status, *)
{
    NotificationIni := IniPath("Notifications")
    IniWrite(Status.Value, NotificationIni, NotificationType, "Volume")
}

TestGui(NotificationType, Action, *)
{
    If (Action = "Test") and !(NotificationType = "Overlay")
        {
            WinMinimize("PoE Mechanic Watch - Settings")
        }
    If (NotificationType = "Overlay")
        {
            If (Action = "Test")
                {
                    CreateOverlay()
                    Return
                }
            If (Action = "Destroy")
                {
                    DestroyOverlay()
                    Return
                }
        }
    If (NotificationType = "Quick Notification")
        {
            If (Action = "Test")
                {
                    MapHotkey := GetMapHotkey()
                    Text := "You just entered a new map press" A_Space  MapHotkey A_Space "to subtract 1 map"
                    QuickNotify(Text, 3)
                }
            If (Action = "Destroy")
                {
                    If WinExist("Simple Notification")
                    {
                        WinClose
                        Settings(4)
                    }
                }
        }
    If (NotificationType = "Mechanic Notification") or (NotificationType = "Custom Reminder")
        {
            If (Action = "Test") and (NotificationType = "Mechanic Notification")
                {
                    Mechanics := ["Betrayal", "Ritual"]
                    Notify(Mechanics, NotificationType)
                }
            If (Action = "Test") and (NotificationType = "Custom Reminder")
                {
                    NotificationsIni := IniPath("Notifications")
                    Message := IniRead(NotificationsIni, "Custom Reminder", "Message", "Don't forget to activate your buffs!")
                    Notify(Message, NotificationType)
                }
            If (Action = "Destroy")
                {
                    If WinExist("PoE Mechanic Watch Notification")
                        {
                            WinClose
                        }
                    If WinExist("Quick Notification")
                        {
                            WinClose
                            Settings(4)
                        }
                }
        }       
    If (NotificationType = "Influence Notification") or (NotificationType = "Maven Notification")
        {
            If (Action = "Test") and (NotificationType = "Influence Notification")
                {
                    Text := "This is your 28th map. Don't forget to kill the boss for your Screaming Invitation."
                    NotificationBig(Text, "Influence Notification")
                }
            If (Action = "Test") and (NotificationType = "Maven Notification")
                {
                    Text := "You've completed 10 Maven Witnessed maps. Don't forget to complete an invitation."
                    NotificationBig(Text, "Maven Notification")
                }
            If (Action = "Destroy")
                {
                    If WinExist("PoE Mechanic Watch Notification")
                        {
                            WinClose
                        }                  
                }
        }
        If !(Action = "Destroy")
        {
            GroupAdd("Notifications", "Notification ahk_class AutoHotkeyGUI")
            GroupAdd("QuickNotification", "Notification ahk_class AutoHotkeyGUI")
            GroupAdd("Notification", "Notification ahk_class AutoHotkeyGUI")
            WinWait("ahk_group Notifications",,1000)
            WinWaitClose("ahk_group Notifications",,1000)
            If WinExist("PoE Mechanic Watch - Settings")
            {
                WinRestore "PoE Mechanic Watch - Settings"
            } 
        }
}

TransparencyAdjust(NotficationType, Status, *)
{
    If (NotficationType = "Overlay")
        {
            OverlayIni := IniPath("Overlay")
            IniWrite(Status.Value, OverlayIni, "Transparency", "Transparency")
        }
    Else
        {
            NotificationIni := IniPath("Notifications")
            IniWrite(Status.Value, NotificationIni, NotficationType, "Transparency")   
        }
}

MoveQuick(*)
{
    MapHotkey := GetMapHotkey()
    Message := "You just entered a new map press " MapHotkey " to subtract 1 map"
    QuickNotify(Message, 3, 1)
}

LockQuick(Type, VerticalCheck, HorizontalCheck, *)
{
    WinGetPos &Xpos, &Ypos,,,"Simple Notification"
    YPos := "y" YPos + 32
    XPos := "x" Xpos
    If (VerticalCheck.Value = 1)
        {
            Ypos := ""
        }
    If (HorizontalCheck.Value = 1)
        {
            Xpos := ""
        }
    NotificationIni := IniPath("Notifications")
    IniWrite(Xpos, NotificationIni, Type, "Horizontal")
    IniWrite(Ypos, NotificationIni, Type, "Vertical")
    QuickNotifyDestroy()
}

QuickDurationChange(Status, *)
{
    NotificationIni := IniPath("Notifications")
    IniWrite(Status.Value, NotificationIni, "Quick Notification", "Duration") 
}

MechanicChecks(Type, Status, *)
{
    NotificationIni := IniPath("Notifications")
    IniWrite(Status.Value, NotificationIni, "Mechanic Notification", Type) 
}

ChatDelayUpdate(Status, *)
{
    NotificationIni := IniPath("Notifications")
    IniWrite(Status.Value, NotificationIni, "Mechanic Notification", "Chat Delay") 
}

CustomNotificationSetup(*)
{
    If WinExist("Notification Settings")
        {
            WinMinimize "Notification Settings"
        } 
    CustomSettings := GuiTemplate("CustomSettings", "Custom Reminder Setup", 500)
    CurrentTheme := GetTheme()
    CustomSettings.BackColor := CurrentTheme[1]
    NotificationIni := IniPath("Notifications")
    CurrentMessage := IniRead(NotificationIni, "Custom Reminder", "Message", "Don't forget to activate your buffs!")
    CustomSettings.Add("Text", "w500 Center", "The Custom Reminder allows you to setup a custom message to be displayed when you enter a map. The reminder can be set as a permanent reminder that would need to be dismissed or a timed `"Quick`" reminder.")
    CustomSettings.SetFont("s12")
    CustomSettings.Add("Text", "Section", "Set Reminder:")
    CustomSettings.Add("Edit", "w350 YS R1 Background" CurrentTheme[2], CurrentMessage).OnEvent("Change", CustomEditUpdate.Bind("Message"))
    CustomSettings.Add("Text", "XM Section", "Reminder Type:")
    QuickActive := IniRead(NotificationIni, "Custom Reminder", "Use Quick", 1)
    PermanentActive := 1
    If (QuickActive = 1)
        {
            PermanentActive := 0
        }
    CustomSettings.Add("Radio", "YS Checked" QuickActive, "Quick").OnEvent("Click", ToggleType.Bind("Quick"))
    CustomSettings.Add("Radio", "YS Checked" PermanentActive, "Permanent").OnEvent("Click", ToggleType.Bind("Permanent"))
    CustomSettings.Add("Text", "YS", "Test:")
    PlayIcon := ImagePath("Play Button", "No")
    CustomSettings.Add("Picture", "w-1 h20 YS Center ", PlayIcon).OnEvent("Click", TestGui.Bind("Custom Reminder", "Test"))
    CustomSettings.AddText("w500 XM h1 Background" CurrentTheme[3])
    CustomSettings.SetFont("s12 Bold c" CurrentTheme[3])
    CustomSettings.Add("Text", "XM Center w500", "Quick Reminder Settings")
    CustomSettings.SetFont("s10 Norm")
    CustomSettings.Add("Button", "XM Section x150", "Move").OnEvent("Click", MoveCustom.Bind("Custom"))
    CustomSettings.Add("Text", "YS w100")
    CurrentDuration := IniRead(NotificationIni, "Custom Reminder", "Duration", 3)
    CustomSettings.Add("Edit", "YS R1 w50 Center Background" CurrentTheme[2], CurrentDuration).OnEvent("Change", CustomEditUpdate.Bind("Duration"))
    CustomSettings.Add("UpDown",,CurrentDuration)
    CustomSettings.Show
    CustomSettings.OnEvent("Close", CustomSetupDestroy)
}

CustomSetupDestroy(CustomSettings)
{
    CustomSettings.Destroy
    If WinExist("Notification Settings")
        {
            WinRestore "Notification Settings"
        } 
}

CustomEditUpdate(EditType, Status, *)
{
    NotificationIni := IniPath("Notifications")
    If (EditType = "Message")
        {
            IniWrite(Status.Value, NotificationIni, "Custom Reminder", "Message")
        }
    If (EditType = "Duration")
        {
            IniWrite(Status.Value, NotificationIni, "Custom Reminder", "Duration")
        }
}

ToggleType(Type, Status, *)
{
    NotificationIni := IniPath("Notifications")
    If (Type = "Quick") and (Status.Value = 1)
        {
            IniWrite(1, NotificationIni, "Custom Reminder", "Use Quick")
        }
    If (Type = "Permanent") and (Status.Value = 1)
        {
            IniWrite(0, NotificationIni, "Custom Reminder", "Use Quick")
        }
}

MoveCustom(*)
{
    If WinExist("Custom Reminder Setup")
        {
            WinMinimize
        }
    NotificationIni := IniPath("Notifications")
    Message := IniRead(NotificationIni, "Custom Reminder", "Message", "Don't forget to activate your buffs!")
    QuickNotify(Message, 2, 1)
}