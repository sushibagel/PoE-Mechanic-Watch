Global SearingActive  
Global EaterActive
Global MavenActive
Global ReminderText
Global Influence
Global InfluenceReminderActive
Global MapMove

InfluenceTrack(NewLine)
{
    MapTrack := NewLine
    PostSetup()
    PostMessage(0x01118, , , , "WindowMonitor.ahk - AutoHotkey")
    PostRestore()
    InfluenceActive()
    If (InfluenceActive != "None")
    {
        MapList := Fileread("Resources\Data\maplist.txt")
        FirstSplit := StrSplit(MapTrack, A_Space)
        AreaLevel := FirstSplit[10]
        SeedNumber := FirstSplit[15]
        If (AreaLevel >= 81)
        {
            GetMap := FirstSplit[12]
            SecondSplit := StrSplit(GetMap, '"')
            GetMap := SecondSplit[2]
            MapName := StrSplit(GetMap, "MapWorlds")
            MapName := MapName[2]
            MapList := Fileread("Resources\Data\maplist.txt")
            VariablePath := VariableIni()
            LastMap := IniRead(VariablePath, "Map", "Last Map")
            LastSeed := IniRead(VariablePath, "Map", "Last Seed")
            If InStr(MapList, MapName) and (MapName != "") and ((MapName != LastMap) or (SeedNumber != LastSeed))
            {
                IniWrite(MapName, VariablePath, "Map", "Last Map")
                IniWrite(SeedNumber, VariablePath, "Map", "Last Seed")
                If (InfluenceActive = "Maven")
                {
                    IniWrite("Yes", VariablePath, "Map", "Maven Map")
                    Exit()
                }
                InfluenceCount := InfluenceCountFunc()
                OldTrack := InfluenceCount
                InfluenceCount ++
                If (InfluenceCount >= 29)
                {
                    InfluenceCount := "1"
                }
                RefreshOverlay()
                MechanicsPath := MechanicsIni()
                IniWrite(InfluenceCount, MechanicsPath, "Influence Track", InfluenceActive)
                InfluenceMapNotification()
                SetTimer(CloseGui,-3000)
                If (InfluenceCount = 14) or (InfluenceCount = 28)
                {
                    If (InfluenceCount = 14)
                    {
                        If (InfluenceActive = "Searing")
                        {
                            InvitationType := "Polaric"
                        }
                        If (InfluenceActive = "Eater")
                        {
                            InvitationType := "Writhing"
                        }
                    }
                    If (InfluenceCount = 28) 
                    {
                        If (InfluenceActive = "Searing")
                        {
                            InvitationType := "Incandescent"
                        }
                        If (InfluenceActive = "Eater")
                        {
                            InvitationType := "Screaming"
                        }
                    }   
                    ReminderText := "This is your " . InfluenceCount . " map. Don't forget to kill the boss for your " . InvitationType . " Invitation"
                    EldritchReminder()
                    InfluenceNotificationSound()
                }
            }
        }
    }
}

InfluenceNotificationSound()
{
    NotificationPrep("Influence")
    If (SoundActive = 1)
    {
        SoundPlay("Resources\Sounds\blank.wav") ;;;;; super hacky workaround but works....
        SetTitleMatchMode(2)
        AhkExe := WinGetProcessName("Reminder")
        SetTitleMatchMode(1)
        SetWindowVol(AhkExe, NotificationVolume)
        SoundPlay(NotificationSound)
    }
}

CloseGui()
{
    Quick := Gui()
    Quick.Destroy()
    ToolTip()
    Return
}

QuickGuiClose()
{
    ToolTip()
    MapMove := 0
    Return 
}

InfluenceReminderButtonOK()
{
    WinActivate("Path of Exile")
    InfluenceReminder := Gui()
    InfluenceReminder.Destroy()
    MechanicsPath := MechanicsIni()
    If (InfluenceCount = 28)
    {
        IniWrite(0, MechanicsPath, "Influence Track", InfluenceActive)
    }
    Return
}

InfluenceReminderButtonRevertCount:
{
    InfluenceReminderActive := 0
    WinActivate("Path of Exile")
    InfluenceReminder.Destroy()
    SubtractOne()
    Return
}

SubtractOne()
{
    InfluenceActive()
    InfluenceActive := ""
    InfluenceCount := ""
    MechanicsPath := MechanicsIni()
    InfluenceCount := InfluenceCountFunc()
    If (EaterActive = 1)
    {
        InfluenceCount := IniRead(MechanicsPath, "Influence Track", "Eater")
        OldTrack := InfluenceCount
        InfluenceCount := InfluenceCount - 1
        If(InfluenceCount = -1)
        {
            InfluenceCount := "27"
        }
        IniWrite(InfluenceCount, MechanicsPath, "Influence Track", "Eater")
    }
    If (SearingActive = 1)
    {
        InfluenceCount := IniRead(MechanicsPath, "Influence Track", "Searing")
        OldTrack := InfluenceCount
        InfluenceCount := InfluenceCount - 1
            If(InfluenceCount = -1)
        {
            InfluenceCount := "27"
        }
        IniWrite(InfluenceCount, MechanicsPath, "Influence Track", "Searing")
    }
    If (MavenActive = 1)
    {
        InfluenceCount := IniRead(MechanicsPath, "Influence Track", "Maven")
        OldTrack := InfluenceCount
        InfluenceCount := InfluenceCount - 1
        If(InfluenceCount = -1)
        {
            InfluenceCount := "10"
        }
        IniWrite(InfluenceCount, MechanicsPath, "Influence Track", "Maven")
    }
    Sleep(100)
    RefreshOverlay()
    Return
}

InfluenceActive()
{
    MechanicsPath := MechanicsIni()
    InfluencesTypes := Influences()
    For each, Influence in StrSplit(InfluencesTypes, "|")
    {
        %Influence% := IniRead(MechanicsPath, "Influence", Influence)
        If (%Influence% = 1)
        %Influence%Active := 1
        InfluenceActive := Influence
        If (%Influence% = 0)
        %Influence%Active := 0
    }

    If (SearingActive = 1)
    {
        InfluenceActive := "Searing"
    }
    If (EaterActive = 1)
    {
        InfluenceActive := "Eater"
    }
    If (MavenActive = 1)
    {
        InfluenceActive := "Maven"
    }
    If (EaterActive = 0) and (SearingActive = 0) and (MavenActive = 0)
    {
        InfluenceActive := "None"
    }
    Return
}

InfluenceCountFunc()
{
    MechanicsPath := MechanicsIni()
    InfluenceCount := IniRead(MechanicsPath, "Influence Track", InfluenceActive)
    return InfluenceCount
}

Influences() ;List of Influences
{
    Return "Eater|Searing|Maven"
}

InfluenceMapNotification() ;Map tracking notification
{
    NotificationPrep("Map")
    PostSetup()
    PostMessage(0x01741, , , , "PoE Mechanic Watch.ahk - AutoHotkey") ;Hotkey check
    PostRestore()
    InfluenceHotkey := InfluenceHotkey()
    Notification := "You just entered a new map press" A_Space InfluenceHotkey A_Space "to subtract 1 map"
    QuickNotify(Notification)
    Return
}

QuickButtonLock()
{
    WinGetPos(&newwidth, &newheight, , , "Quick Notify")
    newheight := newheight + 30
    ToolTip()
    Quick.Destroy()
    NotificationIni := NotificationIni()
    IniWrite(newheight, NotificationIni, "Map Notification Position", "Vertical")
    IniWrite(newwidth, NotificationIni, "Map Notification Position", "Horizontal")
    Return
}

MoveMap()
{
    MapMove := 1
    RefreshOverlay()
    InfluenceMapNotification()
}

MapNotificationDestroy()
{
    Quick.Destroy()
}

PostSetup()
{
    Prev_DetectHiddenWindows := A_DetectHiddenWIndows
    Prev_TitleMatchMode := A_TitleMatchMode
    SetTitleMatchMode(2)
    DetectHiddenWindows(true)
}

PostRestore()
{
    DetectHiddenWindows(Prev_DetectHiddenWindows)
    SetTitleMatchMode(A_TitleMatchMode)
}

ToggleInfluence()
{
    MechanicsIni := MechanicsIni()
    Influences := Influences()
    For each, Influence in StrSplit(Influences, "|")
    {
        CheckInfluence := IniRead(MechanicsIni, "Influence", Influence)
        If (CheckInfluence = 1)
        {
            If (Influence = "Eater")
            {
                IniWrite(0, MechanicsIni, "Influence", "Eater")
                IniWrite(1, MechanicsIni, "Influence", "Searing")
                NewInfluence := "Searing Exarch"
                Break
            }
            If (Influence = "Searing")
            {
                IniWrite(0, MechanicsIni, "Influence", "Searing")
                IniWrite(1, MechanicsIni, "Influence", "Maven")
                NewInfluence := "Maven"
                Break
            }
            If (Influence = "Maven")
            {
                IniWrite(0, MechanicsIni, "Influence", "Maven")
                IniWrite(1, MechanicsIni, "Influence", "Eater")
                NewInfluence := "Eater of Worlds"
                Break
            }
        }
    }
    Notification := "Switching influence tracking to" A_Space NewInfluence  
    QuickNotify(Notification)
    RefreshOverlay()
    SetTimer(CloseGui,-3000)
}

QuickNotify(Notification)
{
    Quick.Destroy()
    NotificationIni := NotificationIni()
    Vertical := IniRead(NotificationIni, "Map Notification Position", "Vertical")
    Horizontal := IniRead(NotificationIni, "Map Notification Position", "Horizontal")
    Quick.BackColor := Background
    Quick.SetFont("c" . Font . " s10")
    ShowTitle := "-0xC00000"
    ShowBorder := "-Border"
    If (MapMove = 1)
    {
        InfluenceHotkey := InfluenceHotkey()
        Notification := "You just entered a new map press" A_Space InfluenceHotkey A_Space "to subtract 1 map"
    }
    Quick.Add("Text", , Notification)
    If (MapMove = 1)
    {
        ogcButtonLock := Quick.Add("Button", "yn y5", "Lock")
        ogcButtonLock.OnEvent("Click", QuickButtonLock.Bind("Normal"))
        ToolTip("Drag the overlay around and press `"Lock`" to store it's location.")
        ShowTitle := ""
        ShowBorder := ""
        MapMove := 0
    }
    If InStr(Notification, "Switching Influence")
    {
       Horizontal := Horizontal + Round(96/A_ScreenDPI*110)
    }
    Quick.Opt("+AlwaysOnTop " . ShowBorder)
    Notificationpath := NotificationIni()
    Active := IniRead(NotificationPath, "Active", "Quick", 1)
    If (Active = 1)
    {
        Quick.Title := "Quick Notify"
        Quick.Show("NoActivate x" . Horizontal . " y" . Vertical)
        MapTransparency := TransparencyCheck("Quick")
        WinSetStyle(ShowTitle, "Quick Notify")
        WinSetTransparent(MapTransparency, "Quick Notify")
    }
    NotificationPrep("Quick")
    If (SoundActive = 1)
    {
        SoundPlay("Resources\Sounds\blank.wav") ;;;;; super hacky workaround but works....
        SetTitleMatchMode(2)
        AhkExe := WinGetProcessName("Quick")
        SetTitleMatchMode(1)
        SetWindowVol(AhkExe, NotificationVolume)
        SoundPlay(NotificationSound)
    }
}