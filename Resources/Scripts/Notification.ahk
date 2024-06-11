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

NotificationSettings(*)
{
    NotificationGui := GuiTemplate("NotificationGui", "Notification Settings", 1000)
    CurrentTheme := GetTheme()
    NotificationGui.SetFont("s12 Bold c" CurrentTheme[3])
    Headers := ["Notification Type", "Enabled", "Sound Settings", "Transparency Settings", "Additional Settings"]
    For Header in Headers
        {
            AddSection := "YS"
            If (A_Index = 1)
                {
                    AddSection := "Section"
                }
            NotificationGui.Add("Text", "R1 Center w190 " AddSection, Header)
        }
    NotificationGui.SetFont("s8 Norm c" CurrentTheme[2])
    For Header in Headers
        {
            AddSection := "YS"
            If (Header = "Notification Type")
                {
                    AddSection := "XM Section"
                    NotificationGui.Add("Text", "R1 w190 " AddSection,)
                }
            Else If (Header = "Sound Settings")
                {
                    NotificationGui.Add("Text", "R1 " AddSection, "Active")
                    NotificationGui.Add("Text", "R1 x+15.5 " AddSection, "Sound")
                    NotificationGui.Add("Text", "R1 " AddSection, "Test")
                    NotificationGui.Add("Text", "R1 " AddSection, "Volume")  
                }
            Else If (Header = "Transparency Settings")
                {
                    NotificationGui.Add("Text", "R1 x+66 " AddSection, "Test")
                    NotificationGui.Add("Text", "R1 " AddSection, "Close")
                    NotificationGui.SetFont("s8 Underline c" CurrentTheme[2])
                    NotificationGui.Add("Text", "R1 Section " AddSection, "Opactiy").OnEvent("Click", ExplainNote.Bind("Opacity"))
                    NotificationGui.SetFont("s8 Norm c" CurrentTheme[2])
                    NotificationGui.Add("Text", "R1 XS", "(0-255)")
                }
            Else
                {
                    NotificationGui.Add("Text", "R1 w190 " AddSection,)
                }
        }
    NotificationGui.SetFont("s12 Bold c" CurrentTheme[3])
    NotificationTypes := ["Overlay", "Quick Notification", "Mechanic Notification", "Custom Reminder", "Influence Notification", "Maven Notification"]
    NotificationGui.SetFont("s10 Norm c" CurrentTheme[3])
    PlayIcon := ImagePath("Play Button", "No") ; get play icon
    VolumeIcon := ImagePath("Volume Button", "No") ; get volume icon
    For Header in NotificationTypes
        {
            NotificationGui.Add("Text", "w280 XM Section", Header) ; add header
            NotificationIni := IniPath("Notifications")
            DefaultStatus := [3, 1, 1, 0, 1, 1]
            CheckStatus := IniRead(NotificationIni, Header, "Active", DefaultStatus[A_Index])
            If (Header = "Overlay")
                {
                    CheckStatus := "3 Check3 Disabled"
                }
            NotificationGui.Add("Checkbox", "YS w105 Center Checked" CheckStatus).OnEvent("Click", EnableCheck.Bind(Header)) ; add Enabled checkbox
            If (Header = "Overlay")
                {
                    NotificationGui.Add("Text", "YS X+148",) ; add spacer
                }
            If !(Header = "Overlay")
                {
                    CheckStatus := IniRead(NotificationIni, Header, "Sound Active", 0)
                    NotificationGui.Add("Checkbox", "YS w30 Center Checked" CheckStatus).OnEvent("Click", SoundCheck.Bind(Header)) ; add sound checkbox
                    NotificationGui.Add("Picture", "Checked1 YS w-1 h22", VolumeIcon).OnEvent("Click", SoundAction.Bind(Header, "Sound")) ; add volume icon
                    NotificationGui.Add("Picture", "w-1 h20 YS Center ", PlayIcon).OnEvent("Click", SoundAction.Bind(Header, "Test")) ; Add Sound Play Icon
                    NotificationGui.Add("Edit", "Center w50 YS Background" CurrentTheme[2]).OnEvent("Change", VolumeAdjust.Bind(Header)) ;add edit box
                    CurrentVolume := IniRead(NotificationIni, Header, "Volume", 100)
                    NotificationGui.Add("UpDown", "Center YS Range0-100", CurrentVolume) ; add up/down
                }

            NotificationGui.Add("Text", "w85 ") ; add spacer
            NotificationGui.Add("Picture", "w-1 h20 YS Center ", PlayIcon).OnEvent("Click", TestGui.Bind(Header, "Test")) ; Add Transparency Play Icon
            StopIcon := ImagePath("Stop Button", "No") ; get stop icon
            NotificationGui.Add("Picture", "w-1 h20 YS Center x+25 ", StopIcon).OnEvent("Click", TestGui.Bind(Header, "Destroy")) ; Add Transparency Play Icon
            NotificationGui.Add("Edit", "Center w50 YS Background" CurrentTheme[2]).OnEvent("Change", TransparencyAdjust.Bind(Header)) ;add transparency edit box
            CurrentOpacity := IniRead(NotificationIni, Header, "Transparency", 255)
            If (Header = "Overlay")
            {
                CurrentOpacity := IniPath("Overlay", "Read", , "Transparency", "Transparency", 255)
            }
            NotificationGui.Add("UpDown", "Center YS Range0-255", CurrentOpacity) ; add up/down

            If (Header = "Overlay")
                {
                    NotificationGui.Add("Text", "Center YS w45")
                    NotificationGui.Add("Button", "Center YS w50", "Move").OnEvent("Click", MoveOverlay)
                    NotificationGui.Add("Button", "Center YS w50", "Layout").OnEvent("Click", OverlaySettingsRun)
                }
            If (Header = "Quick Notification")
                {
                    NotificationGui.Add("Text", "Center YS w45")
                    NotificationGui.Add("Button", "Center YS w50", "Move").OnEvent("Click", MoveQuick)
                    NotificationGui.SetFont("s8 Norm c" CurrentTheme[3])
                    NotificationGui.Add("Text", "Center YS-15 Section", "Duration (Seconds)")
                    NotificationGui.SetFont("s10 Norm c" CurrentTheme[3])
                    NotificationGui.Add("Edit", "Center w50 XS+15 YP+18 Background" CurrentTheme[2]).OnEvent("Change", QuickDurationChange) ;add transparency edit box
                    QuickDuration := IniRead(NotificationIni, Header, "Duration", 3)
                    NotificationGui.Add("UpDown", "Center YS Range0-255", QuickDuration) ; add up/down
                }
            If (Header = "Mechanic Notification")
                {
                    NotificationGui.SetFont("s8 Bold Underline c" CurrentTheme[3])
                    NotificationGui.Add("Text", "Center YS-15 w100 Section", "Triggers").OnEvent("Click", ExplainNote.Bind("Triggers"))
                    HideoutTrigger := IniRead(NotificationIni, Header, "Hideout Trigger", 1)
                    NotificationGui.Add("Checkbox","XS+15 YP+18 Checked" HideoutTrigger).OnEvent("Click", MechanicChecks.Bind("Hideout Trigger"))
                    NotificationGui.SetFont("s8 Norm c" CurrentTheme[3])
                    NotificationGui.Add("Text", "Center XS+2 YP+18", "Hideout")

                    HotkeyTrigger := IniRead(NotificationIni, Header, "Hotkey Trigger", 0)
                    NotificationGui.Add("Checkbox","YS+19 x+30 Checked" HotkeyTrigger).OnEvent("Click", MechanicChecks.Bind("Hotkey Trigger"))
                    NotificationGui.SetFont("s8 Norm c" CurrentTheme[3])
                    NotificationGui.Add("Text", "Center XP-9 YP+18 Section", "Hotkey")
                    
                    NotificationGui.SetFont("s8 Bold Underline c" CurrentTheme[3])
                    NotificationGui.Add("Text", "YS-35 w120 Section", "Quick Notification").OnEvent("Click", ExplainNote.Bind("Quick"))
                    QuickStatus := IniRead(NotificationIni, Header, "Use Quick", 0)
                    NotificationGui.Add("Checkbox","XS+45 YP+18 Checked" QuickStatus).OnEvent("Click", MechanicChecks.Bind("Use Quick"))

                    NotificationGui.Add("Text", "YS w100 Section", "Chat Delay").OnEvent("Click", ExplainNote.Bind("Delay"))
                    NotificationGui.SetFont("s10 Norm c" CurrentTheme[3])
                    NotificationGui.Add("Edit", "Center w50 XS+5 YP+18 Background" CurrentTheme[2]).OnEvent("Change", ChatDelayUpdate) ;add transparency edit box
                    ChatDelay := IniRead(NotificationIni, Header, "Chat Delay", 0)
                    NotificationGui.Add("UpDown", "Center YS Range0-100", ChatDelay) ; add up/down
                }
            If (Header = "Custom Reminder")
                {
                    NotificationGui.Add("Text", "Center YS w85")
                    NotificationGui.Add("Button", "YS","Configure").OnEvent("Click", CustomNotificationSetup)
                }
        }
    NotificationGui.Opt("-DPIScale")
    NotificationGui.Show
    NotificationGui.OnEvent("Close", NotificationGuiDestroy)
}

NotificationGuiDestroy(NotificationGui)
{
    NotificationGui.Destroy()
}

ExplainNote(NoteSelected, *)
{
    If (NoteSelected = "Opacity")
        {
            GuiInfo := "The opacity setting determines how visible/transparent (opaque) the notification is. If set to 0 the notification will be invisible at 255 notification will be 100% opaque."
        }
    If (NoteSelected = "Triggers")
        {
            GuiInfo := "There are two trigger settings `"Hideout`" and `"Hotkey`". When enabled the Hideout trigger will trigger Mechanic Notifications upon returning to your hideout. The Hotkey trigger will cause notifications to be triggered when a configured hotkey is pressed (See the Hotkey menu item to configure the key).`r`rIf the `"Hotkey`" trigger is active it's highly recommended to setup your `"Chat Delay`" hotkey and utilize `"Quick Notificaitons`"."
        }
    If (NoteSelected = "Quick")
        {
            GuiInfo := "If checked Quick Notifications will be used instead of Permanent Notifications (Permanent notifications will stay open unless a button is clicked). To change the duration, location and transparency of the quick notifcations see the settings in the `"Quick Notification`" section."
        }
    If (NoteSelected = "Delay")
        {
            GuiInfo := "`"Chat Delay`" is the number of seconds the Notification Trigger Hotkey will be disabled for each time the Chat Hotkey (Enter by default) is pressed. This is done to help prevent accidental activation while typing in chat. To disable set to `"0`"."
        }
    TriggeredBy := "Notification Settings"
    WinGetPos(&X, &Y, &W, &H, TriggeredBy)
    XPos := X + W
    YPos := Y
    WPos := A_ScreenWidth-(X+W+75)
    ActivateFootnoteGui(GuiInfo, XPos, YPos, WPos)
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
            ScriptInfo := WinGetProcessName("test")
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
            WinMinimize("Notification Settings")
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
                    Text := "You just entered a new map press" A_Space  "Hotkey" A_Space "to subtract 1 map"
                    QuickNotify(Text, 3)
                }
            If (Action = "Destroy")
                {
                    QuickNotifyDestroy()
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
                    If WinActive("PoE Mechanic Watch Notification")
                        {
                            NotificationBigDestroy()
                        }
                    If WinActive("Quick Notification")
                        {
                            QuickNotifyDestroy()
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
                    If WinActive("PoE Mechanic Watch Notification")
                        {
                            NotificationBigDestroy()
                        }                  
                }
        }
        GroupAdd("Notifications", "Notification ahk_class AutoHotkeyGUI")
        GroupAdd("QuickNotification", "Notification ahk_class AutoHotkeyGUI")
        WinWait("ahk_group Notifications")
        WinWaitClose
        If WinExist("Notification Settings")
        {
            WinRestore "Notification Settings"
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
    Message := "You just entered a new map press FIXTHIS to subtract 1 map"
    QuickNotify(Message, 3, 1)
}

LockQuick(Type, VerticalCheck, HorizontalCheck, *)
{
    WinGetPos &Xpos, &Ypos,,,"Quick Notification"
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