Global SearingActive  
Global EaterActive
Global ReminderText
Global Influence
Global InfluenceReminderActive

InfluenceTrack(NewLine)
{
    MapTrack := NewLine
    ReminderAcitve := 0
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
                InfluenceCount := InfluenceCount()
                OldTrack = %InfluenceCount%
                InfluenceCount ++
                If (InfluenceCount >= 29)
                {
                    InfluenceCount = 1
                }
                ControlSetText, %OldTrack%, %InfluenceCount%, Overlay
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
                    InfluenceNotificationSound()
                }
            }
        }
    }
}

InfluenceNotificationSound()
{
    SetTimer, InfluenceNotificationSound, Off
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
    Gui, Influence:Destroy
    Return
}

InfluenceReminderButtonOK()
{
    InfluenceReminderActive := 0
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
    Sleep, 100
    ControlSetText, %OldTrack%, %InfluenceCount%, Overlay
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
    If (EaterActive = 0) and (SearingActive = 0)
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
    Return, "Eater|Searing"
}

InfluenceMapNotification() ;Map tracking notification
{
    NotificationPrep("Map")
    HotkeyCheck()
    InfluenceHotkey := InfluenceHotkey()
    Winwait, Overlay
    WinGetPos,Width, Height, Length,, Overlay
    height := height - 50
    Length := Length - 10
    Gui, Influence:Color, %Background%
    Gui, Influence:Font, c%Font% s10
    Gui, Influence:-Border +AlwaysOnTop
    Gui, Influence:Add, Text,,You just entered a new map, press %InfluenceHotkey%  to subtract 1 map
    Gui, Influence:Show, NoActivate x-1000 y%height%, Influence
    WinGetPos, Xi, Yi, Widthi, Heighti, Influence
    Gui, Influence:Hide
    widthset := Width  + (Length/2) - (Widthi/2)
    Gui, Influence:Show, NoActivate x%widthset% y%height%, Influence
    MapTransparency := TransparencyCheck("Map")
    WinSet, Style, -0xC00000, Influence
    WinSet, Transparent, %MapTransparency%, Influence
    Return
}