Global Influences  
Global SearingActive  
Global EaterActive
Global InfluenceTrack
Global ReminderText

InfluenceTrack()
{
    MapTrack := NewLine
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
            If InStr(MapList, MapName) and ((MapName != LastMap) or (Seednumber != LastSeed))
            {
                LastMap := MapName
                LastSeed := SeedNumber
                OldTrack = %InfluenceTrack%
                InfluenceTrack ++
                If (InfluenceTrack >= 29)
                {
                    InfluenceTrack = 1
                }
                ControlSetText, %OldTrack%, %InfluenceTrack%, Overlay
                MechanicsIni := MechanicsIni()
                IniWrite, %InfluenceTrack%, %MechanicsIni%, InfluenceTrack, %InfluenceActive%
                InfluenceMapNotification()
                SetTimer, CloseGui, -3000
                If (InfluenceTrack = 14) or (InfluenceTrack = 28)
                {
                    If (InfluenceTrack = 14)
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
                    If (InfluenceTrack = 28) 
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
                    ReminderText = This is your %InfluenceTrack% map. Don't forget to kill the boss for your %InvitationType% Invitation
                    NotificationPrep(Influence)
                    EldritchReminder()
                }
            }
        }
    }
}

CloseGui()
{
    Gui, Influence:Destroy
    Return
}

ReminderButtonOK()
{
    WinActivate, Path of Exile
    Gui, Reminder:Destroy
    MechanicsIni := MechanicsIni()
    If (InfluenceTrack = 28)
    {
        IniWrite, 0, %MechanicsIni%, InfluenceTrack, %InfluenceActive%
    }
    Return
}


ReminderButtonRevertCount:
{
    WinActivate, Path of Exile
    Gui, Reminder:Destroy
    SubtractOne()
    Return
}

SubtractOne()
{
    InfluenceActive()
    InfluenceActive = 
    InfluenceTrack = 
    MechanicsIni := MechanicsIni()
    If (EaterActive = 1)
    {
        IniRead, InfluenceTrack, %MechanicsIni%, InfluenceTrack, Eater
        OldTrack := InfluenceTrack
        InfluenceTrack := InfluenceTrack - 1
        If(InfluenceTrack = -1)
        {
            InfluenceTrack = 27
        }
        IniWrite, %InfluenceTrack%, %MechanicsIni%, InfluenceTrack, Eater
    }
    If (SearingActive = 1)
    {
        IniRead, InfluenceTrack, %MechanicsIni%, InfluenceTrack, Searing
        OldTrack := InfluenceTrack
        InfluenceTrack := InfluenceTrack - 1
            If(InfluenceTrack = -1)
        {
            InfluenceTrack = 27
        }
        IniWrite, %InfluenceTrack%, %MechanicsIni%, InfluenceTrack, Searing
    }
    Sleep, 100
    ControlSetText, %OldTrack%, %InfluenceTrack%, Overlay
    Return
}

InfluenceActive()
{
    MechanicsIni := MechanicsIni()
    Influences := Influences()
    For each, Influence in StrSplit(Influences, "|")
    {
        IniRead, %Influence%, %MechanicsIni%, Influence, %Influence%
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

Influences() ;List of Influences
{
    Return, "Eater|Searing"
}

InfluenceMapNotification() ;Map tracking notification
{
    NotificationPrep(Map)
    HotkeyCheck()
    Winwait, Overlay
    WinGetPos,Width, Height, Length,, Overlay
    height := height - 50
    Length := Length - 10
    Gui, Influence:Color, %Background%
    Gui, Influence:Font, c%Font% s10
    Gui, Influence:-Border +AlwaysOnTop
    Gui, Influence:Add, Text,,You just entered a new map, press %HK%  to subtract 1 map
    Gui, Influence:Show, NoActivate x-1000 y%height%, Influence
    WinGetPos, Xi, Yi, Widthi, Heighti, Influence
    Gui, Influence:Hide
    If (widthset = "")
    {
        widthset := Width  + (Length/2) - (Widthi/2)
    }
    Gui, Influence:Show, NoActivate x%widthset% y%height%, Influence
    WinSet, Style, -0xC00000, Influence
    WinSet, Transparent, %MapTransparency%, Influence
    Return
}