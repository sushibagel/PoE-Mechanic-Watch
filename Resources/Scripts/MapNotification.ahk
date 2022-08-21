InfluenceMapNotification:
Gosub, HotkeyCheck
Winwait, Overlay
WinGetPos,Width, Height, Length,, Overlay
height := height - 50
Length := Length - 10
IniRead, MapTransparency, %UpOneLevel%Settings\Transparency.ini, Transparency, Map
If (MapTransparency = "ERROR")
{
    IniRead, MapTransparency, Resources\Settings\Transparency.ini, Transparency, Map
}
If (MapTransparency = "ERROR")
{
    MapTransparency = 255
}
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