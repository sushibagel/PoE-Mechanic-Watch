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
    PostMessage, 0x01118,,,, WindowMonitor.ahk - AutoHotkey
    PostRestore()
    InfluenceActive()
    If (InfluenceActive != "None")
    {
        FileRead, MapList, Resources\Data\maplist.txt 
        FirstSplit := StrSplit(MapTrack, A_Space)
        AreaLevel = % FirstSplit[10]
        SeedNumber = % FirstSplit[15]
        If (AreaLevel >= 81)
        {
            SplitDelim = `"
            GetMap = % FirstSplit[12]
            SecondSplit := StrSplit(GetMap, SplitDelim)
            GetMap = % SecondSplit[2]
            MapName := StrSplit(GetMap, "MapWorlds")
            MapName = % MapName[2]
            FileRead, MapList, Resources\Data\maplist.txt
            VariablePath := VariableIni()
            IniRead, LastMap, %VariablePath%, Map, Last Map
            IniRead, LastSeed, %VariablePath%, Map, Last Seed
            If InStr(MapList, MapName) and (MapName != "") and ((MapName != LastMap) or (SeedNumber != LastSeed))
            {
                IniWrite, %MapName%, %VariablePath%, Map, Last Map
                IniWrite, %SeedNumber%, %VariablePath%, Map, Last Seed
                If (InfluenceActive = "Maven")
                {
                    IniWrite, Yes, %VariablePath%, Map, Maven Map
                    Exit
                }
                InfluenceCount := InfluenceCount()
                OldTrack = %InfluenceCount%
                InfluenceCount ++
                If (InfluenceCount >= 29)
                {
                    InfluenceCount = 1
                }
                RefreshOverlay()
                MechanicsPath := MechanicsIni()
                IniWrite, %InfluenceCount%, %MechanicsPath%, Influence Track, %InfluenceActive%
                InfluenceMapNotification()
                SetTimer, CloseGui, -3000
                If (InfluenceCount = 14) or (InfluenceCount = 28)
                {
                    If (InfluenceCount = 14)
                    {
                        If (InfluenceActive = "Searing")
                        {
                            InvitationType = Polaric
                        }
                        If (InfluenceActive = "Eater")
                        {
                            InvitationType = Writhing
                        }
                    }
                    If (InfluenceCount = 28) 
                    {
                        If (InfluenceActive = "Searing")
                        {
                            InvitationType = Incandescent
                        }
                        If (InfluenceActive = "Eater")
                        {
                            InvitationType = Screaming
                        }
                    }   
                    ReminderText = This is your %InfluenceCount% map. Don't forget to kill the boss for your %InvitationType% Invitation
                    EldritchReminder()
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
        SoundPlay, Resources\Sounds\blank.wav ;;;;; super hacky workaround but works....
        SetTitleMatchMode, 2
        WinGet, AhkExe, ProcessName, Reminder
        SetTitleMatchMode, 1
        SetWindowVol(AhkExe, NotificationVolume)
        SoundPlay, %NotificationSound%
    }
}

CloseGui()
{
    Gui, Quick:Destroy
    Tooltip
    Return
}

QuickGuiClose()
{
    Tooltip
    MapMove := 0
    Return  
}

InfluenceReminderButtonOK()
{
    WinActivate, Path of Exile
    Gui, InfluenceReminder:Destroy
    MechanicsPath := MechanicsIni()
    If (InfluenceCount = 28)
    {
        IniWrite, 0, %MechanicsPath%, InfluenceTrack, %InfluenceActive%
    }
    Return
}

InfluenceReminderButtonRevertCount:
{
    InfluenceReminderActive := 0
    WinActivate, Path of Exile
    Gui, InfluenceReminder:Destroy
    SubtractOne()
    Return
}

SubtractOne()
{
    InfluenceActive()
    InfluenceActive = 
    InfluenceCount = 
    MechanicsPath := MechanicsIni()
    InfluenceCount := InfluenceCount()
    If (EaterActive = 1)
    {
        IniRead, InfluenceCount, %MechanicsPath%, Influence Track, Eater
        OldTrack := InfluenceCount
        InfluenceCount := InfluenceCount - 1
        If(InfluenceCount = -1)
        {
            InfluenceCount = 27
        }
        IniWrite, %InfluenceCount%, %MechanicsPath%, Influence Track, Eater
    }
    If (SearingActive = 1)
    {
        IniRead, InfluenceCount, %MechanicsPath%, Influence Track, Searing
        OldTrack := InfluenceCount
        InfluenceCount := InfluenceCount - 1
            If(InfluenceCount = -1)
        {
            InfluenceCount = 27
        }
        IniWrite, %InfluenceCount%, %MechanicsPath%, Influence Track, Searing
    }
    If (MavenActive = 1)
    {
        IniRead, InfluenceCount, %MechanicsPath%, Influence Track, Maven
        OldTrack := InfluenceCount
        InfluenceCount := InfluenceCount - 1
        If(InfluenceCount = -1)
        {
            InfluenceCount = 10
        }
        IniWrite, %InfluenceCount%, %MechanicsPath%, Influence Track, Maven
    }
    Sleep, 100
    RefreshOverlay()
    Return
}

InfluenceActive()
{
    MechanicsPath := MechanicsIni()
    InfluencesTypes := Influences()
    For each, Influence in StrSplit(InfluencesTypes, "|")
    {
        IniRead, %Influence%, %MechanicsPath%, Influence, %Influence%
        If (%Influence% = 1)
        %Influence%Active := 1
        InfluenceActive = %Influence%
        If (%Influence% = 0)
        %Influence%Active := 0
    }

    If (SearingActive = 1)
    {
        InfluenceActive = Searing
    }
    If (EaterActive = 1)
    {
        InfluenceActive = Eater
    }
    If (MavenActive = 1)
    {
        InfluenceActive = Maven
    }
    If (EaterActive = 0) and (SearingActive = 0) and (MavenActive = 0)
    {
        InfluenceActive = None
    }
    Return
}

InfluenceCount()
{
    MechanicsPath := MechanicsIni()
    IniRead, InfluenceCount, %MechanicsPath%, Influence Track, %InfluenceActive%
    Return, %InfluenceCount%
}

Influences() ;List of Influences
{
    Return, "Eater|Searing|Maven"
}

InfluenceMapNotification() ;Map tracking notification
{
    NotificationPrep("Map")
    PostSetup()
    PostMessage, 0x01741,,,, PoE Mechanic Watch.ahk - AutoHotkey ;Hotkey check
    PostRestore()
    InfluenceHotkey := InfluenceHotkey()
    Notification := "You just entered a new map press" A_Space InfluenceHotkey A_Space "to subtract 1 map"
    QuickNotify(Notification)
    Return
}

QuickButtonLock()
{
    WinGetPos, newwidth, newheight,,, Quick Notify
    newheight := newheight + 30
    ToolTip
    Gui, Quick:Destroy
    NotificationIni := NotificationIni()
    IniWrite, %newheight%, %NotificationIni%, Map Notification Position, Vertical
    IniWrite, %newwidth%, %NotificationIni%, Map Notification Position, Horizontal
    Return
}

MoveMap()
{
    MapMove := 1
    InfluenceMapNotification()
}

MapNotificationDestroy()
{
    Gui, Quick:Destroy
}

PostSetup()
{
    Prev_DetectHiddenWindows := A_DetectHiddenWIndows
    Prev_TitleMatchMode := A_TitleMatchMode
    SetTitleMatchMode 2
    DetectHiddenWindows On
}

PostRestore()
{
    DetectHiddenWindows, %Prev_DetectHiddenWindows%
    SetTitleMatchMode, %A_TitleMatchMode%
}

ToggleInfluence()
{
    MechanicsIni := MechanicsIni()
    Influences := Influences()
    For each, Influence in StrSplit(Influences, "|")
    {
        IniRead, CheckInfluence, %MechanicsIni%, Influence, %Influence%
        If (CheckInfluence = 1)
        {
            If (Influence = "Eater")
            {
                IniWrite, 0, %MechanicsIni%, Influence, Eater
                IniWrite, 1, %MechanicsIni%, Influence, Searing
                NewInfluence := "Searing Exarch"
                Break
            }
            If (Influence = "Searing")
            {
                IniWrite, 0, %MechanicsIni%, Influence, Searing
                IniWrite, 1, %MechanicsIni%, Influence, Maven
                NewInfluence := "Maven"
                Break
            }
            If (Influence = "Maven")
            {
                IniWrite, 0, %MechanicsIni%, Influence, Maven
                IniWrite, 1, %MechanicsIni%, Influence, Eater
                NewInfluence := "Eater of Worlds"
                Break
            }
        }
    }
    Notification := "Switching influence tracking to" A_Space NewInfluence  
    QuickNotify(Notification)
    RefreshOverlay()
    SetTimer, CloseGui, -3000
}

QuickNotify(Notification)
{
    Gui, Quick:Destroy
    NotificationIni := NotificationIni()
    IniRead, Vertical, %NotificationIni%, Map Notification Position, Vertical
    IniRead, Horizontal, %NotificationIni%, Map Notification Position, Horizontal
    Gui, Quick:Color, %Background%
    Gui, Quick:Font, c%Font% s10
    ShowTitle := "-0xC00000"
    ShowBorder := "-Border"
    If (MapMove = 1)
    {
        InfluenceHotkey := InfluenceHotkey()
        Notification := "You just entered a new map press" A_Space InfluenceHotkey A_Space "to subtract 1 map"
    }
    Gui, Quick:Add, Text,,%Notification%
    If (MapMove = 1)
    {
        Gui, Quick:Add, Button, yn y5, Lock
        Tooltip, Drag the overlay around and press "Lock" to store it's location.
        ShowTitle := ""
        ShowBorder := ""
        MapMove := 0
        ; PostSetup()
        ; PostMessage, 0x01111,,,, Tail.ahk - AutoHotkey
        ; PostRestore()
        ; RefreshOverlay()
    }
    If InStr(Notification, "Switching Influence")
    {
       Horizontal := Horizontal + Round(96/A_ScreenDPI*110)
    }
    Gui, Quick: +AlwaysOnTop %ShowBorder%
    Gui, Quick:Show, NoActivate x%Horizontal% y%Vertical%, Quick Notify
    MapTransparency := TransparencyCheck("Quick")
    WinSet, Style,  %ShowTitle%, Quick Notify
    WinSet, Transparent, %MapTransparency%, Quick Notify
}
