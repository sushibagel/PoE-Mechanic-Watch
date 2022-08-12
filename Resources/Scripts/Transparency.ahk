UpdateTransparency:
Gosub, GetOverlayItems

Space = y+5
Gui, Transparency:Font, c%Font% s11
Gui, Transparency:Add, Text, w350 +Center, Select the desired opacity for each Overlay Type
Gui, Transparency:Add, Text, %Space% w350 +Center, Opacity can any value 0 (Invisible) to 255 (Opaque)
Gui, Transparency:Color, Edit, %Secondary% -Caption -Border
Gui, Transparency:Color, %Background% 
Gui, Transparency:Add, GroupBox, w350 h10 xn x10
Space = y+2


For each, OverlayItem in StrSplit(OverlayList, "|")
{
    Space := 40 + (A_Index * 10)
    IniRead, %OverlayItem%Value, %TransparencyPath%, Transparency, %OverlayItem%, 255
    Gui, Transparency:Font, c%Font% s12
    ItemText = %OverlayItem%
    If (OverlayItem = "Map")
    {
        ItemText = Map Notification
    }
    If (OverlayItem = "Notification")
    {
        ItemText = Mechanic Notification
    }
    If (OverlayItem = "Influence")
    {
        ItemText = Invitation Reminder
    }
    Gui, Transparency:Add, Text, xn x40 Section, %ItemText% 
    Gui, Transparency:Font, cBlack s10
    Value := %OverlayItem%Value
    Gui, Transparency:Add, Edit, Center v%OverlayItem%Edit ys x240 w50
    Gui, Transparency:Add, UpDown, Range0-255, %Value% ;;;; 0 = invisible 255 = Opaque 
}

Gui, Transparency:-Caption -Border +ToolWindow
Gui, Transparency:Add, Button, y+5 x+0 w80 h30, OK
Gui, Transparency:Show, w375, Transparency
WinWait, Path of Exile
Return

TransparencyGuiClose:
TransparencyButtonOk: 
Gui, Submit, NoHide 
For each, OverlayItem in StrSplit(OverlayList, "|")
{
    Edit := %OverlayItem%Edit
    IniWrite, %Edit%, %TransparencyPath%, Transparency, %OverlayItem%
}
Gui, Transparency:Destroy
Gosub, ReadTransparency
Return

GetOverlayItems:
OverlayList := "Overlay|Notification|Influence|Map"
TransparencyPath := "Resources\Settings\Transparency.ini"
Return

ReadTransparency:
Gosub, GetOverlayItems
For each, OverlayItem in StrSplit(OverlayList, "|")
{
    IniRead, %OverlayItem%Transparency, %TransparencyPath%, Transparency, %OverlayItem%, 255
}
Return