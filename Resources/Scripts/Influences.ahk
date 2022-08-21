Global LogPath
Global SearingActive
Global EaterActive
Global InfluenceTrack
Global Influences
Global InfluenceActive
Global width
Global height
Global Length
Global HK
Global NotMaps
Global MyHideout
Global Background
Global Font
Global Secondary
Global CurrentInfluence
Global InfluenceSound
Global InfluenceSoundActive
Global ReminderText
Global LastMap
Global LastSeed
Global widthset
Global BreakLoop

InfluenceTracking:
IniRead, InfluenceSound, Resources\Settings\notification.ini, Sounds, Influence
IniRead, InfluenceSoundActive, Resources\Settingsnotification.ini, Active, Influence
IniRead, ColorMode, Resources\Settings\Theme.ini, Theme, Theme

Winwait, Overlay
WinGetPos,Width, Height, Length,, Overlay
height := height - 50
Length := Length - 10
Return

InfluenceTrack:
MapTrack := NewLine
Gosub, InfluenceActive

FileRead, MapList, Resources\Data\maplist.txtFirstSplit := StrSplit(MapTrack, A_Space)

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
        If (CurrentInfluence != None)
        {
            IniRead, InfluenceTrack, Resources\Settings\Mechanics.ini, InfluenceTrack, %InfluenceActive%
            OldTrack = %InfluenceTrack%
            InfluenceTrack ++
            ControlSetText, %OldTrack%, %InfluenceTrack%, Overlay
            IniWrite, %InfluenceTrack%, Resources\Settings\Mechanics.ini, InfluenceTrack, %InfluenceActive%
            Gosub, InfluenceMapNotification
            SetTimer, CloseGui, -3000

            If (InfluenceTrack = 14)
            {
                If (InfluenceActive = "Searing")
                {
                    ReminderText = This is your 14th map. Don't forget to kill the boss for your Polaric Invitation
                }
                If (InfluenceActive = "Eater")
                {
                    ReminderText = This is your 14th map. Don't forget to kill the boss for your Writhing Invitation
                }
                Gosub, EldritchReminder
                Gosub, NotificationSound
                Gosub, InfluenceReminderLoop
            }
            If (InfluenceTrack = 28)
            {
                If (InfluenceActive = "Searing")
                {
                    ReminderText = This is your 28th map. Don't forget to kill the boss for your Incandescent Invitation
                }
                If (InfluenceActive = "Eater")
                {
                    ReminderText = This is your 28th map. Don't forget to kill the boss for your Screaming Invitation
                }
                Gosub, EldritchReminder
                Gosub, NotificationSound
                Gosub, InfluenceReminderLoop
            }
        }
    }
}
Return

InfluenceReminderLoop:
Loop
{
    IfWinNotActive, Path of Exile
    {
        Sleep, 200
        IfWinNotActive, Path of Exile
        {
            Gui, Reminder:Destroy
            Gui, 2:Destroy
            Loop
            {
                IfWinActive, Path of Exile
                {
                    Gosub, Overlay
                    Gosub, EldritchReminder
                    Break
                }
            }
        }
    }
    If (BreakLoop = 1)
    {
        BreakLoop =
        Break
    }

}
Return

CloseGui:
Gui, Influence:Destroy
Return

ReminderButtonOK:
WinActivate, Path of Exile
Gui, Reminder:Destroy
If (InfluenceTrack = 28)
{
    IniWrite, 0, Resources\Settings\Mechanics.ini, InfluenceTrack, %InfluenceActive%
}
Return

ReminderButtonRevertCount:
WinActivate, Path of Exile
Gui, Reminder:Destroy
Gosub, SubtractOne
Return

SubtractOne:
Gosub, InfluenceActive
InfluenceActive = 
InfluenceTrack = 
If (EaterActive = 1)
{
    IniRead, InfluenceTrack, Resources\Settings\Mechanics.ini, InfluenceTrack, Eater
    OldTrack := InfluenceTrack
    InfluenceTrack := InfluenceTrack - 1
	If(InfluenceTrack = -1)
	{
		InfluenceTrack = 27
	}
    IniWrite, %InfluenceTrack%, Resources\Settings\Mechanics.ini, InfluenceTrack, Eater
}
If (SearingActive = 1)
{
    IniRead, InfluenceTrack, Resources\Settings\Mechanics.ini, InfluenceTrack, Searing
    OldTrack := InfluenceTrack
    InfluenceTrack := InfluenceTrack - 1
		If(InfluenceTrack = -1)
	{
		InfluenceTrack = 27
	}
    IniWrite, %InfluenceTrack%, Resources\Settings\Mechanics.ini, InfluenceTrack, Searing
}
Sleep, 100
ControlSetText, %OldTrack%, %InfluenceTrack%, Overlay
Return

InfluenceActive:
FileRead, Influences, Resources\Data\Influences.txt
For each, Influence in StrSplit(Influences, "|")
{
    IniRead, %Influence%, Resources\Settings\Mechanics.ini, Influence, %Influence%
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
	CurrentInfluence = None
}
Else
{
	CurrentInfluence = %InfluenceActive%
}
Return

NotificationSound:
IniRead, InfluenceSoundActive, Resources\Settings\notification.ini, Active, Influence
If (InfluenceSoundActive = 1)
{
    IniRead, InfluenceVolume, Resources\Settings\notification.ini, Volume, Influence
    IniRead, InfluenceSound, Resources\Settings\notification.ini, Sounds, Influence
	SoundPlay, Resources\Sounds\blank.wav ;;;;; super hacky workaround but works....
    SetTitleMatchMode, 2
    WinGet, AhkExe, ProcessName, Reminder
    SetTitleMatchMode, 1
    SetWindowVol(AhkExe, 0)
    SetWindowVol(AhkExe, InfluenceVolume)
    SoundPlay, %InfluenceSound% 
}
Return