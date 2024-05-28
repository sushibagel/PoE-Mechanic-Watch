Notify(ActiveMechanics)
{
    NotificationIni := IniPath("Notifications")
    UseQuick := IniRead(NotificationIni, "Mechanic Notification", "Use Quick", 0)
    If (UseQuick = 0)
        {
            NotificationBig(ActiveMechanics, "Mechanic")
        }
    If (UseQuick = 1)
        {
            QuickNotify(ActiveMechanics, 1)
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
    If (Type = "Mechanic")
        {
            MechanicNotificationSetup(ActiveMechanics)
            If (NotificationInfo[5] = 1)
                {
                    NotificationSound(NotificationInfo[6], NotificationInfo[7])
                }
        }
    If (Type = "Custom Reminder")
        {
            MapNotificationSetup(ActiveMechanics)
            NotificationInfo := NotificationVars("Custom Reminder")
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
            NotificationInfo := NotificationVars("Custom Reminder")
            PosY:= NotificationInfo[2]
            PosX:= NotificationInfo[3]
        }
    If (MechanicVersion = 3)
        {
            MechanicText := Mechanics
            NotificationInfo := NotificationVars("Custom Reminder")
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
    NotificationGuiDestroy()
    CurrentTheme := GetTheme()
    NotificationGui.BackColor := CurrentTheme[1]
    NotificationGui.SetFont("s15 Bold c" CurrentTheme[3])
    NotificationGui.Add("Text", "w1000 Center", "Notification Settings")
    NotificationGui.AddText("w1150 h1 Background" CurrentTheme[3])
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
                    NotificationGui.Add("Text", "R1 Section " AddSection, "Opactiy").OnEvent("Click", OpacityExplain)
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
            NotificationGui.Add("Edit", "Center w50 YS Background" CurrentTheme[2]) ;add transparency edit box
            CurrentOpacity := IniRead(NotificationIni, Header, "Transparency", 255)
            NotificationGui.Add("UpDown", "Center YS Range0-255", CurrentOpacity) ; add up/down

            If (Header = "Overlay")
                {
                    NotificationGui.Add("Text", "Center YS w45")
                    NotificationGui.Add("Button", "Center YS w50", "Move")
                    NotificationGui.Add("Button", "Center YS w50", "Layout")
                }
            If (Header = "Quick Notification")
                {
                    NotificationGui.Add("Text", "Center YS w45")
                    NotificationGui.Add("Button", "Center YS w50", "Move")
                    NotificationGui.SetFont("s8 Norm c" CurrentTheme[3])
                    NotificationGui.Add("Text", "Center YS-15 Section", "Duration (Seconds)")
                    NotificationGui.SetFont("s10 Norm c" CurrentTheme[3])
                    NotificationGui.Add("Edit", "Center w50 XS+15 YP+18 Background" CurrentTheme[2]) ;add transparency edit box
                    QuickDuration := IniRead(NotificationIni, Header, "Duration", 3)
                    NotificationGui.Add("UpDown", "Center YS Range0-255", QuickDuration) ; add up/down
                }
            If (Header = "Mechanic Notification")
                {
                    NotificationGui.SetFont("s8 Bold Underline c" CurrentTheme[3])
                    NotificationGui.Add("Text", "Center YS-15 w100 Section", "Triggers")
                    HideoutTrigger := IniRead(NotificationIni, Header, "Hideout Trigger", 1)
                    NotificationGui.Add("Checkbox","XS+15 YP+18 Checked" HideoutTrigger)
                    NotificationGui.SetFont("s8 Norm c" CurrentTheme[3])
                    NotificationGui.Add("Text", "Center XS+2 YP+18", "Hideout")

                    HotkeyTrigger := IniRead(NotificationIni, Header, "Hotkey Trigger", 0)
                    NotificationGui.Add("Checkbox","YS+19 x+30 Checked" HotkeyTrigger)
                    NotificationGui.SetFont("s8 Norm c" CurrentTheme[3])
                    NotificationGui.Add("Text", "Center XP-9 YP+18 Section", "Hotkey")
                    
                    NotificationGui.SetFont("s8 Bold Underline c" CurrentTheme[3])
                    NotificationGui.Add("Text", "YS-35 w120 Section", "Quick Notification")
                    QuickStatus := IniRead(NotificationIni, Header, "Quick Notification", 0)
                    NotificationGui.Add("Checkbox","XS+45 YP+18 Checked" QuickStatus)

                    NotificationGui.Add("Text", "YS w100 Section", "Chat Delay")
                    NotificationGui.SetFont("s10 Norm c" CurrentTheme[3])
                    NotificationGui.Add("Edit", "Center w50 XS+5 YP+18 Background" CurrentTheme[2]) ;add transparency edit box
                    ChatDelay := IniRead(NotificationIni, Header, "Chat Delay", 3)
                    NotificationGui.Add("UpDown", "Center YS Range0-100", ChatDelay) ; add up/down
                }
            If (Header = "Custom Reminder")
                {
                    NotificationGui.Add("Text", "Center YS w85")
                    NotificationGui.Add("Button", "YS","Configure")
                    ; NotificationGui.SetFont("s8 Bold Underline c" CurrentTheme[3])
                    ; NotificationGui.Add("Text", "Center YS-15 w200 Section", "Custom Message")
                    ; NotificationGui.SetFont("s10 Norm c" CurrentTheme[3])
                    ; CurrentMessage := IniRead(NotificationIni, Header, "Message", "Don't forget to activate your buffs!")
                    ; NotificationGui.Add("Edit", "XS+15 YP+18 w190 R1 Background" CurrentTheme[2], CurrentMessage)
                }

        }
    NotificationGui.Opt("-DPIScale")
    NotificationGui.Show
}

NotificationGuiDestroy()
{
    If WinExist("Notification Settings1")
        {
            NotificationGui.Destroy()
        }
    Global NotificationGui := Gui(,"Notification Settings1")
}

OpacityExplain(*)
{
    GuiInfo := "The opacity setting determines how visible/transparent (opaque) the notification is. If set to 0 the notification will be invisible at 255 notification will be 100% opaque."
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
    If (NotificationType = "Overlay")
        {
            If (Action = "Test")
                {
                    CreateOverlay()
                }
            If (Action = "Destroy")
                {
                    DestroyOverlay()
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
    If (NotificationType = "Mechanic Notification")
        {
            If (Action = "Test")
                {
                    Mechanics := ["Betrayal", "Ritual"]
                    Notify(Mechanics)
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

    ; msgbox Notificationtype "|" Action
}

^a::
{
    NotificationSettings()
    ; MapReminder()
}