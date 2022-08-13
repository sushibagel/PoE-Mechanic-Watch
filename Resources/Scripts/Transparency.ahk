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

If (ColorMode = "Dark")
{
    RefreshColor = refresh white.png
    PlayColor = play white.png
    StopColor = stop white.png
}
If (ColorMode = "Light")
{
    RefreshColor = refresh.png
    PlayColor = play.png
    StopColor = stop.png
}

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
    Gui, Transparency:Add, Text, xn x20 Section, %ItemText% 
    Gui, Transparency:Font, cBlack s10
    Value := %OverlayItem%Value
    Gui, Transparency:Add, Edit, Center v%OverlayItem%Edit ys x200 w50
    Gui, Transparency:Add, UpDown, Range0-255, %Value% ;;;; 0 = invisible 255 = Opaque 
    Gui, Transparency:Add, Picture, g%OverlayItem%Test w25 h25 ys, Resources/Images/%PlayColor%
    Gui, Transparency:Add, Picture, g%OverlayItem%Test w25 h25 ys, Resources/Images/%RefreshColor%
    Gui, Transparency:Add, Picture, g%OverlayItem%Stop w25 h25 ys, Resources/Images/%StopColor%
}

Gui, Transparency:-Caption -Border
Gui, Transparency:Add, Button, xn x270 w80 h30, OK
Gui, Transparency:Show, w375, Transparency
WinWait, Path of Exile
Return

TransparencyGuiClose:
TransparencyButtonOk: 
Gui, Transparency:Submit, NoHide 
For each, OverlayItem in StrSplit(OverlayList, "|")
{
    Edit := %OverlayItem%Edit
    IniWrite, %Edit%, %TransparencyPath%, Transparency, %OverlayItem%
}
Gui, Influence:Destroy
Gui, Reminder:Destroy
Gui, 1:Destroy
Gui, 2:Destroy
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

;;;;;;;;;;;;;;;;;;;;;;;;;; Labels for each Overlay ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
OverlayTest:
Gui, 2:Destroy
Gui, Transparency:Submit, NoHide
IniWrite, %OverlayEdit%, %TransparencyPath%, Transparency, Overlay
Gosub, Overlay
Return

OverlayStop:
Gui, 2:Destroy
Return

NotificationTest:
Gui, 1:Destroy
Gui, Transparency:Submit, NoHide
IniWrite, %NotificationEdit%, %TransparencyPath%, Transparency, Notification
Gosub, Overlay
Gui, 2:Hide
height9 := (A_ScreenHeight / 2) + 200
width9 := (A_ScreenWidth / 2)-100
ReminderText = Ritual and Metamorph
Gosub, MechanicReminder
Return

NotificationStop:
Gui, 1:Destroy
Gui, 2:Destroy
Return

InfluenceTest:
Gui, Reminder:Destroy
Gui, Transparency:Submit, NoHide
IniWrite, %InfluenceEdit%, %TransparencyPath%, Transparency, Influence
InfluenceTrack = 28
ReminderText = This is your 28th map. Don't forget to kill the boss for your Incandescent Invitation
WinGetPos, X, Y, Length, Height, Transparency
height2 := Height + Y + 100
width2 := (Length/2) + X - 300
Gosub, EldritchReminder
;Set influence count and active influence back just in case
FileRead, Influences, Resources\Data\Influences.txt
For each, Influence in StrSplit(Influences, "|")
IniRead, %Influence%, Resources\Settings\Mechanics.ini, Influence, %Influence%
If (SearingActive = 1)
{
    InfluenceActive = Searing
}
If (EaterActive = 1)
{
    InfluenceActive = Eater
}
IniRead, InfluenceTrack, Resources\Settings\Mechanics.ini, InfluenceTrack, %InfluenceActive%
height2 =
width2 =
Return

InfluenceStop:
Gui, Reminder:Destroy
Return

MapTest:
Gui, Influence:Destroy
Gui, Transparency:Submit, NoHide
IniWrite, %MapEdit%, %TransparencyPath%, Transparency, Map
IniRead, Hotkey1, Resources/Settings/Hotkeys.ini, Hotkeys, 1
Hk := Hotkey1
WinGetPos, Width, Height, Length, , Transparency
Height := Height + 350
Gosub, InfluenceMapNotification
Return

MapStop:
Gui, Influence:Destroy
Return