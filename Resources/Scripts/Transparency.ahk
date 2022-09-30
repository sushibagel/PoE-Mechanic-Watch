Global OverlayEdit
Global NotificationEdit
Global InfluenceEdit
Global MapEdit
Global PlayColor

UpdateTransparency()
{
    CheckTheme()
    TransparencyFile := TransparencyIni()
    OverlayList := GetOverlayItems()
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
        IniRead, %OverlayItem%Value, %TransparencyFile%, Transparency, %OverlayItem%, 255
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
    Return
}

TransparencyButtonOk()
{
    Gui, Transparency:Submit, NoHide 
    OverlayList := GetOverlayItems()
    TransparencyFile := TransparencyIni()
    For each, OverlayItem in StrSplit(OverlayList, "|")
    {
        Edit := %OverlayItem%Edit
        IniWrite, %Edit%, %TransparencyFile%, Transparency, %OverlayItem%
    }
    Gui, Influence:Destroy
    Gui, Reminder:Destroy
    Gui, 1:Destroy
    Gui, Overlay:Destroy
    Gui, Transparency:Destroy
    ReadTransparency()
    Return
}

GetOverlayItems()
{
    Return, "Overlay|Notification|Influence|Map"
}


ReadTransparency()
{
    OverlayList := GetOverlayItems()
    TransparencyFile := TransparencyIni()
    For each, OverlayItem in StrSplit(OverlayList, "|")
    {
        IniRead, %OverlayItem%Transparency, %TransparencyFile%, Transparency, %OverlayItem%, 255
    }
    Return
}

;;;;;;;;;;;;;;;;;;;;;;;;;; Labels for each Overlay ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
OverlayTest()
{
    ReadMechanics()
    If (MechanicsOn = 0) or (MechanicsOn = "")
    {
        yh := (A_ScreenHeight/2) -150
        xh := (A_ScreenWidth/2) - 225
        Gui, Transparency:Destroy
        Gui, TransparencyWarning:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
        Gui, TransparencyWarning:Color, %Background%
        Gui, TransparencyWarning:Font, c%Font% s11
        Gui, TransparencyWarning:Add, Text, w530 +Center, You don't currently have any mechanics any mechanic tracking on. You must have at least 1 mechanic on to test this overlay.
        Gui, TransparencyWarning:Add, Button, y50 x50, OKAY
        Gui, TransparencyWarning: +AlwaysOnTop -Caption
        Gui, TransparencyWarning:Show, NoActivate x%xh% y%yh% w550, TransparencyWarning
        WinWaitClose, TransparencyWarning
    }
    Gui, Overlay:Destroy
    Gui, Transparency:Submit, NoHide
    NotificationPrep(Overlay)
    ; Overlay()
    Return
}


OverlayStop()
{
    Gui, Overlay:Destroy
    Return
}

NotificationTest:
{
    Gui, 1:Destroy
    Gui, Overlay:Destroy
    Gui, Transparency:Submit, NoHide
    IniWrite, %NotificationEdit%, %TransparencyPath%, Transparency, Notification
    ; Overlay()
    Gui, Overlay:Hide
    height9 := (A_ScreenHeight / 2) + 200
    width9 := (A_ScreenWidth / 2)-100
    ReminderText = Ritual and Metamorph
    ; MechanicReminder()
    Return
}

NotificationStop:
{
    Gui, 1:Destroy
    Gui, Overlay:Destroy
    Return
}

InfluenceTest:
{
    Gui, Reminder:Destroy
    Gui, Transparency:Submit, NoHide
    TransparencyIni := TransparencyIni()
    IniWrite, %InfluenceEdit%, %TransparencyIni%, Transparency, Influence
    InfluenceTrack = 28
    ReminderText = This is your 28th map. Don't forget to kill the boss for your Incandescent Invitation
    WinGetPos, X, Y, Length, Height, Transparency
    height2 := Height + Y + 100
    width2 := (Length/2) + X - 300
    ; EldritchReminder()
    ;Set influence count and active influence back just in case
    ; Influences := Influences()
    For each, Influence in StrSplit(Influences, "|")
    MechanicsIni := MechanicsIni()
    IniRead, %Influence%, %MechanicsIni%, Influence, %Influence%
    If (SearingActive = 1)
    {
        InfluenceActive = Searing
    }
    If (EaterActive = 1)
    {
        InfluenceActive = Eater
    }
    IniRead, InfluenceTrack, %MechanicsIni%, InfluenceTrack, %InfluenceActive%
    height2 =
    width2 =
    Return
}

InfluenceStop()
{
    Gui, Reminder:Destroy
    Return
}

MapTest:
{
    Gui, Influence:Destroy
    Gui, Transparency:Submit, NoHide
    TransparencyIni := TransparencyIni()
    IniWrite, %MapEdit%, %TransparencyIni%, Transparency, Map
    HotkeyIni := HotkeyIni()
    IniRead, Hotkey1, %HotkeyIni%, Hotkeys, 1
    Hk := Hotkey1
    WinGetPos, Width, Height, Length, , Transparency
    Height := Height + 350
    ; InfluenceMapNotification()
    Return
}


MapStop:
{
    Gui, Influence:Destroy
    Return
}

TransparencyWarningButtonOKAY:
{
    Gui, TransparencyWarning:Destroy
    UpdateTransparency()
    Return
}

TransparencyCheck(NotificationTransparency)
{
   TransparencyIniPath := TransparencyIni()
   IniRead, NotificationTransparency, %TransparencyIniPath%, Transparency, %NotificationTransparency%
   Return, %NotificationTransparency%
}