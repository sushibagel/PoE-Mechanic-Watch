Global OverlayEdit
Global NotificationEdit
Global InfluenceEdit
Global MapEdit
Global PlayColor

UpdateTransparency()
{
    Gui, Transparency:Destroy
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
    PostSetup()
    PostMessage, 0x01113,,,, Tail.ahk - AutoHotkey
    PostMessage, 0x01118,,,, WindowMonitor.ahk - AutoHotkey
    PostMessage, 0x01122,,,, Tail.ahk - AutoHotkey
    PostMessage, 0x01155,,,, WindowMonitor.ahk - AutoHotkey
    PostRestore()
    Gui, Transparency:Destroy
    Gui, Influence:Destroy
    Gui, Reminder:Destroy
    RefreshOverlay()
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
        Gui, TransparencyWarning:Add, Text, w530 +Center, You don't currently have any mechanic tracking on. You must have at least 1 mechanic on to test this overlay.
        Gui, TransparencyWarning:Add, Button, y50 x50, OKAY
        Gui, TransparencyWarning: +AlwaysOnTop -Caption
        Gui, TransparencyWarning:Show, NoActivate x%xh% y%yh% w550, TransparencyWarning
        WinWaitClose, TransparencyWarning
    }
    Gui, Transparency:Submit, NoHide
    TransparencyFile := TransparencyIni()
    IniWrite, %OverlayEdit%, %TransparencyFile%, Transparency, Overlay
    NotificationPrep(Overlay)
    RefreshOverlay()
    Return
}


OverlayStop()
{
    Gui, Overlay:Destroy
    Return
}

NotificationTest()
{
    Gui, Reminder:Destroy
    Gui, Overlay:Destroy
    Gui, Transparency:Submit, NoHide
    TransparencyPath := TransparencyIni()
    IniWrite, %NotificationEdit%, %TransparencyPath%, Transparency, Notification
    RefreshOverlay()
    Gui, Overlay:Hide
    height9 := (A_ScreenHeight / 2) + 200
    width9 := (A_ScreenWidth / 2)-100
    ReminderText = Ritual and Metamorph
    PostSetup()
    PostMessage, 0x01112,,,, Tail.ahk - AutoHotkey ;Activate Reminder
    PostRestore()
    Return
}

NotificationStop:
{
    PostSetup()
    PostMessage, 0x01113,,,, Tail.ahk - AutoHotkey
    PostMessage, 0x01118,,,, WindowMonitor.ahk - AutoHotkey
    PostRestore()
    Return
}

InfluenceTest:
{
    Gui, Reminder:Destroy
    Gui, Transparency:Submit, NoHide
    TransparencyIni := TransparencyIni()
    IniWrite, %InfluenceEdit%, %TransparencyIni%, Transparency, Influence
    PostSetup()
    PostMessage, 0x01123,,,, Tail.ahk - AutoHotkey
    PostRestore()
    Return
}

InfluenceStop()
{
    PostSetup()
    PostMessage, 0x01122,,,, Tail.ahk - AutoHotkey
    PostMessage, 0x01155,,,, WindowMonitor.ahk - AutoHotkey
    PostRestore()
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
    InfluenceMapNotification()
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