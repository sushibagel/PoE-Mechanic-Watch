Global Permanent
Global Temporary
Global None
Global CustomMessage

MapReminder(NewLine)
    {
        MiscIni := MiscIni()
        IniRead, MapMessageActive, %MiscIni%, Map Message, Active, 0
        If (MapMessageActive = 1)
        {
            MapTrack := NewLine
            FirstSplit := StrSplit(MapTrack, A_Space)
            SplitDelim = `"
            GetMap = % FirstSplit[12]
            SecondSplit := StrSplit(GetMap, SplitDelim)
            GetMap = % SecondSplit[2]
            MapName := StrSplit(GetMap, "MapWorlds")
            MapName = % MapName[2]
            FileRead, MapList, Resources\Data\maplist.txt
            If InStr(MapList, MapName) and (MapName != "")
                {
                    IniRead, CustomMessage, %MiscIni%, Map Message, Map Message, Did you enable your buffs?
                    IniRead, NotificationType, %MiscIni%, Map Message, Notification Type, Permanent
                    If (NotificationType = "Permanent")
                        {
                            PermanentNotification(CustomMessage) ; not displaying on top for some reason. 
                        }
                    If (NotificationType = "Temporary")
                        {
                            NotificationPrep("Map")
                            Notification := CustomMessage
                            QuickNotify(Notification)
                            NotificationIni := NotificationIni()
                            IniRead, CloseDuration, %NotificationIni%, Map Notification Position, Duration, 3000
                            SetTimer, CloseGui, -%CloseDuration%
                        }
                }
        }
        Return
    }

    PermanentNotification(CustomMessage)
    {
        Gui, PermanentNotification:Destroy
        ReminderText := CustomMessage
        CheckTheme()
        NotificationHeight := (A_ScreenHeight / 2) - 100
        TransparencyFile := TransparencyIni()
        IniRead, NotificationTransparency, %TransparencyFile%, Transparency, Notification, 255
        Gui, PermanentNotification:Font, c%Font% s12
        If WinExist("Notification Settings")
        {
            ReminderText := "Did you enable your buffs?"
        }
        Gui, PermanentNotification:Add, Text,,%ReminderText%
        Gui, PermanentNotification:Font, s10
        Gui, PermanentNotification:Color, %Background%
        Gui, PermanentNotification:+AlwaysOnTop -Border
        Gui, PermanentNotification:Show, NoActivate y%NotificationHeight%, Reminder
        DetectHiddenWindows, On
        WinGetPos,xpos,, Width, Height, Reminder
        bx := Width/2
        bx := Round(96/A_ScreenDPI*bx)
        bx2 := bx - 100
        bx := bx + 50
        Gui, PermanentNotification:Hide
        WinSet, Style, -0xC00000, PermanentNotification
        gheight := height + 40
        NotificationIni := NotificationIni()
        IniRead, NotificationActive, %NotificationIni%, Active, Notification, 1
        If WinExist("Notification Settings")
        {
            NotificationHeight := 850
            NotificationActive := 1
        }
        Gui, PermanentNotification:Add, Button, xn x%bx2% Section w50, OK
        Gui, PermanentNotification:+AlwaysOnTop -Border
        If (NotificationActive = 1)
        {
            Gui, PermanentNotification:Show, y%NotificationHeight% h%gheight% NoActivate, PermanentNotification
            WinSet, Style, -0xC00000, PermanentNotification
            WinSet, Transparent, %NotificationTransparency%, PermanentNotification
            NotificationPrep("Notification")
            If (SoundActive = 1)
            {
                SoundPlay, Resources\Sounds\blank.wav ;;;;; super hacky workaround but works....
                SetTitleMatchMode, 2
                WinGet, AhkExe, ProcessName, PermanentNotification
                SetTitleMatchMode, 1
                SetWindowVol(AhkExe, NotificationVolume)
                SoundPlay, %NotificationSound%
            }
        }
        If (NotificationActive = 0)
        {
            Gui, PermanentNotification:Destroy
            Return
        }
        Return
    }

    PermanentNotificationButtonOK()
    {
        WinActivate, Path of Exile
        Gui, PermanentNotification:Destroy
        MechanicsPath := MechanicsIni()
        Return
    }

    MapSettings()
    {
        CheckTheme()
        Gui, MapSettingsSetup:Destroy
        Gui, MapSettingsSetup:Font, c%Font% s12 Bold
        Gui, MapSettingsSetup:-Border -Caption
        Gui, MapSettingsSetup:Color, %Background%
        Gui, MapSettingsSetup:Add, Text, w300 +Center ,Mapping Reminder Settings
        Gui, MapSettingsSetup:Font, s8 c%Secondary%
        Gui, MapSettingsSetup:Add, Text,w300,The Mapping Reminder allows you to set a reminder that would activate each time you enter a map.
        Gui, MapSettingsSetup:Font, s2
        Gui, MapSettingsSetup:Add, Text, w300 0x10
        Gui, MapSettingsSetup:Font, Bold s11
        Gui, MapSettingsSetup:Add, Text,, Notification Type
        Gui, MapSettingsSetup:Font, Normal s8
        Gui, MapSettingsSetup:Add, Text,xs,(Select One)
        Gui, MapSettingsSetup:Font, s1 c%Font%
        Gui, MapSettingsSetup:Font, Normal s10
        MiscIni := MiscIni()
        IniRead, CustomMessage, %MiscIni%, Map Message, Map Message, Did you enable your buffs?
        IniRead, NotificationType, %MiscIni%, Map Message, Notification Type, None
        PermanentActive := 0
        TemporaryActive := 0
        NoneActive := 1
        If (NotificationType = "Permanent")
            {
                PermanentActive := 1
                NoneActive := 0
            }
        If (NotificationType = "Temporary")
            {
                TemporaryActive := 1
                NoneActive := 0
            }
        Gui, MapSettingsSetup:Add, Radio, vPermanent Checked%PermanentActive%, Permanent
        Gui, MapSettingsSetup:Add, Radio, vTemporary Checked%TemporaryActive%, Temporary
        Gui, MapSettingsSetup:Add, Radio, vNone Checked%NoneActive%, None
        Gui, MapSettingsSetup:Font, Bold s11 c%Secondary%
        Gui, MapSettingsSetup:Add, Text,, Notification Message:
        Gui, MapSettingsSetup:Font, cBlack s10 Normal
        Gui, MapSettingsSetup:Add, Edit, w300 vCustomMessage, %CustomMessage%
        Gui, MapSettingsSetup:Font, c%Font%
        Gui, MapSettingsSetup:Add,Text
        Gui, MapSettingsSetup:Add, Button, xp w80 h20, OK
        Gui, MapSettingsSetup:Show,,MapSettingsSetup
        Return
    }

    MapSettingsSetupButtonOK()
    {
        Gui, Submit, NoHide
        MiscIni := MiscIni()
        If (Permanent = 1)
            {
                IniWrite, Permanent, %MiscIni%, Map Message, Notification Type
            }
        If (Temporary = 1)
            {
                IniWrite, Temporary, %MiscIni%, Map Message, Notification Type
            }
        If (None = 1)
            {
                IniWrite, None, %MiscIni%, Map Message, Notification Type
            }
        IniWrite, %CustomMessage%, %MiscIni%, Map Message, Map Message
        Gui, MapSettingsSetup:Destroy
        Return
    }