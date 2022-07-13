;have file with eldritch influences listed. 
;Read file and use in variable. 
;Show counter on icon
;give warning each time it is incremented.use hotkey to decrease by 1 (Allow selectable hotkey) 
#Include tf.ahk
Global SearingActive
Global EaterActive
Global InfluenceTrack
Global Influences
Global InfluenceActive
Global width
Global heigth
Global Length

LogPath = C:\Program Files (x86)\Steam\steamapps\common\Path of Exile\logs\Client.txt
StringTrimRight, UpOneLevel, A_ScriptDir, 7

WinGetPos,Width, Height, Length,, Overlay
height := height - 50
Length := Length - 10
InfluenceTrack:
FileRead, Influences, %UpOneLevel%Data/Influences.txt
For each, Influence in StrSplit(Influences, "|")
{
    If (Influence = "Eater of Worlds")
    {
        Influence = Eater
    }
    If (Influence = "Searing Exarch")
    {
        Influence = Searing
    }
    IniRead, %Influence%, %UpOneLevel%/Settings/Mechanics.ini, Influences, %Influence%
    If (%Influence% = 1)
    %Influence%Active := 1
    InfluenceActive = %Influence%
    If (%Influence% = 0)
    %Influence%Active := 0
}

FileRead, map, %UpOneLevel%Data\maplist.txt
Loop
For each, MapName in StrSplit(Map, "`n")
{
MapTrack  := TF_Tail(LogPath, 2)
If MapTrack contains %MapName%
{
    IniRead, InfluenceTrack, %UpOneLevel%/Settings/Mechanics.ini, InfluenceTrack, %InfluenceActive%
    InfluenceTrack ++
    IniWrite, %InfluenceTrack%, %UpOneLevel%/Settings/Mechanics.ini, InfluenceTrack, %InfluenceActive%
    Gui, Influence:Color, 4e4f53
    Gui, Influence:Font, cWhite s10
    Gui, Influence:-Border
    Gui, Influence:+AlwaysOnTop
    Gui, Influence:Add, Text,,You just entered a new map, press X to subtract 1 map
    Gui, Influence:Show, NoActivate x-1000 y%height%, Influence
    WinSet, Style, -0xC00000, Influence
    WinGetPos, Xi, Yi, Widthi, Heighti, Influence
    Gui, Influence:Hide
    width := Width  + (Length/2) - (Widthi/2)
    Gui, Influence:Show, NoActivate x%width% y%height%, Influence
    SetTimer, CloseGui, -3000

    If (InfluenceTrack = 14)
        {
            If (InfluenceActive = "Searing")
            {
                Msgbox, This is your 14th map. Don't forget to kill the boss for your Polaric Invitation
            }
            If (InfluenceActive = "Eater")
            {
                Msgbox, This is your 14th map. Don't forget to kill the boss for your Writhing Invitation
            }
        }
    If (InfluenceTrack = 28)
            {
            If (InfluenceActive = "Searing")
            {
                Msgbox, This is your 28th map. Don't forget to kill the boss for your Incandescent Invitation
                IniWrite, 0, %UpOneLevel%/Settings/Mechanics.ini, InfluenceTrack, %InfluenceActive%
            }
            If (InfluenceActive = "Eater")
            {
                Msgbox, This is your 28th map. Don't forget to kill the boss for your Screaming Invitation
                IniWrite, 0, %UpOneLevel%/Settings/Mechanics.ini, InfluenceTrack, %InfluenceActive%
            }
        }
    Loop
    {
        MapTrack  := TF_Tail(LogPath, 2)
        If MapTrack not contains %MapName%
        {
            Gosub, InfluenceTrack
        }
    }
}
}

CloseGui:
    Gui, Influence:Destroy
    Return