Global MoveActive

Overlay()
{
    Run, Resources\Scripts\WindowMonitor.ahk
    RefreshOverlay()
    Return
}

RefreshOverlay()
{
    Gui, Overlay:Destroy
    OverlayPath := OverlayIni()
    IniRead, Height, %OverlayPath%, Overlay Position, Height
    IniRead, Width, %OverlayPath%, Overlay Position, Width
    IniRead, OverlayOrientation, %OverlayPath%, Overlay Position, Orientation
    IniRead, IconHeight, %OverlayPath%, Size, Height
    IniRead, OverlayFont, %OverlayPath%, Size, Font
    If (OverlayOrientation = "Horizontal")
    {
        OverlayOrientation := "yn"
    }
    If (OverlayOrientation = "Vertical")
    {
        OverlayOrientation := "xn"
    }
    ReadMechanics()
    MechanicsActive()
    InfluenceActive()
    mechanictest = 0

    For each, Mechanic in StrSplit(MechanicSearch, "|")
    {
        mechanicon = %Mechanic%On
        mechanicactive = %Mechanic%Active
        If (%mechanicon% = 1) or (%mechanicon% = 2)
        {
            If (%mechanicactive% = 1)
            {
                Gui, Overlay:Add, Picture, Section g%Mechanic% %OverlayOrientation% w-1 h%IconHeight%, Resources/Images/%Mechanic%_selected.png
                If (Mechanic = "Incursion")
                    {
                        MechanicsIni := MechanicsIni()
                        IniRead, IncursionCount, %MechanicsIni%, Incursion Track, Current Count
                        Gui, Overlay:Font, cWhite s%OverlayFont%
                        TrackOffset := IconHeight/2 - OverlayFont/2 - 6
                        If (IncursionCount = 0) or (IncursionCount = "Error")
                            {
                                IncursionCount := BlankVariable
                            }
                        Gui, Overlay:Add, Text, xs+%TrackOffset%, %IncursionCount%
                    }
                If (Mechanic = "Ritual")
                    {
                        MechanicsIni := MechanicsIni()
                        IniRead, Ritualcount, %MechanicsIni%, Ritual Track, Count, %A_Space%
                        Gui, Overlay:Font, cWhite s%OverlayFont%
                        TrackOffset := IconHeight/2 - OverlayFont/2 - 6
                        Gui, Overlay:Add, Text, xs+%TrackOffset%, %Ritualcount%
                    }
                If (Mechanic = "Einhar")
                    {
                        MechanicsIni := MechanicsIni()
                        IniRead, EinharCount, %MechanicsIni%, Einhar Track, Current Count, ""
                        If (EinharCount = 0)
                            {
                                EinharCount := BlankVariable
                            }
                        TrackOffset := IconHeight/2 - OverlayFont/2 - 6
                        Gui, Overlay:Font, cWhite s%OverlayFont%
                        Gui, Overlay:Add, Text, xs+%TrackOffset%, %EinharCount%
                    }
                If (Mechanic = "Niko")
                    {
                        MechanicsIni := MechanicsIni()
                        IniRead, NikoCount, %MechanicsIni%, Niko Track, Current Count, ""
                        If (NikoCount = 0)
                            {
                                NikoCount := BlankVariable
                            }
                        TrackOffset := IconHeight/2 - OverlayFont/2 - 6
                        Gui, Overlay:Font, cWhite s%OverlayFont%
                        Gui, Overlay:Add, Text, xs+%TrackOffset%, %NikoCount%
                    }
                If (Mechanic = "Betrayal")
                    {
                        MechanicsIni := MechanicsIni()
                        IniRead, BetrayalCount, %MechanicsIni%, Betrayal Track, Current Count, ""
                        If (BetrayalCount = 0)
                            {
                                BetrayalCount := BlankVariable
                            }
                        TrackOffset := IconHeight/2 - OverlayFont/2 - 6
                        Gui, Overlay:Font, cWhite s%OverlayFont%
                        Gui, Overlay:Add, Text, xs+%TrackOffset%, %BetrayalCount%
                    }
            }
            If (%mechanicon% = 1) and !(%mechanicactive% = 1)
            {
                Gui, Overlay:Add, Picture, Section g%Mechanic% %OverlayOrientation% w-1 h%IconHeight%, Resources/Images/%Mechanic%.png
                If (Mechanic = "Incursion")
                {
                    MechanicsIni := MechanicsIni()
                    IniRead, IncursionCount, %MechanicsIni%, Incursion Track, Current Count, %BlankVariable%
                    Gui, Overlay:Font, cWhite s%OverlayFont%
                    TrackOffset := IconHeight/2 - OverlayFont/2 - 6
                    If (IncursionCount = 0) or (IncursionCount = "Error")
                        {
                            IncursionCount := BlankVariable
                        }
                    Gui, Overlay:Add, Text, xs+%TrackOffset%, %IncursionCount%
                    }
            }
        }
        mechanictest ++
    }
    
    If (InfluenceActive != "None")
    {
        MechanicsPath := MechanicsIni()
        IniRead, InfluenceCount, %MechanicsPath%, Influence Track, %InfluenceActive%
        Gui, Overlay:Add, Picture, g%InfluenceActive% %OverlayOrientation% w-1 h%IconHeight% Section, Resources/Images/%InfluenceActive%.png
        Gui, Overlay:Font, cWhite s%OverlayFont%
        TrackOffset := IconHeight/2 - OverlayFont/2 - 1
        Gui, Overlay:Add, Text, xs+%TrackOffset%, %InfluenceCount%
    }
    Gui, Overlay:Color, 1e1e1e
    ShowTitle := "-0xC00000"
    Activate := "NoActivate"
    OverlayTitle := "Overlay"
    If (MoveActive = 1)
    {
        LockPosition := "xn x5"
        If (OverlayOrientation = "yn")
        {
            LockPosition := "yn y5"
        }
        Gui, Overlay:Add, Button, %LockPosition%, Lock
        WinClose, %A_ScriptDir%\Resources\Scripts\WindowMonitor.ahk ahk_class AutoHotkey
        Tooltip, Drag the overlay around and press "Lock" to store it's location.
        ShowTitle := ""
        Activate := ""
        Gui, Overlay:Color, %Background%
        OverlayTitle := "Overlay Setup"
    }
    TransparencyPath := TransparencyIni()
    IniRead, OverlayTransparency, %TransparencyPath%, Transparency, Overlay, 255
    Gui, Overlay:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
    Gui, Overlay:+AlwaysOnTop +ToolWindow +HwndOverlayHwnd
    Gui, Overlay:Show, %Activate% x%width% y%height%, %OverlayTitle%
    WinSet, Style, %ShowTitle%, Overlay
    If (MoveActive != 1)
    {
        WinSet, TransColor, 1e1e1e %OverlayTransparency%, Overlay
    }
    Return
}

OverlayGuiClose()
{
    Tooltip
    MoveActive := 0
    RefreshOverlay()
    Return
}

OverlayKill()
{
    Gui, Overlay:Destroy
    Return
}

MechanicToggle(ToggleMechanic)
{
    MechanicsActive()
    ActiveCheck := ToggleMechanic "Active"
    MechanicsPath := MechanicsIni()
    If (%ActiveCheck% = 0)
    {
        IniWrite, 1, %MechanicsPath%, Mechanic Active, %ToggleMechanic%
        RefreshOverlay()
        Return
    }
    If (%ActiveCheck% = 1)
    {
        IniWrite, 0, %MechanicsPath%, Mechanic Active, %ToggleMechanic%
        ReminderActive := 0
        PostSetup()
        PostMessage, 0x01118,,,, WindowMonitor.ahk - AutoHotkey ;Deactivate Reminder tracker
        PostRestore()
        If (ToggleMechanic = "Einhar")
            {
                MechanicsIni := MechanicsIni()
                IniWrite, %BlankVariable%, %MechanicsIni%, Einhar Track, Current Count
            }
        If (ToggleMechanic = "Ritual")
        {
            MechanicsIni := MechanicsIni()
            IniWrite, 1, %MechanicsIni%, Ritual Track, Status
            IniWrite, %A_Space%, %MechanicsIni%, Ritual Track, Count
        }
        If (ToggleMechanic = "Niko")
            {
                MechanicsIni := MechanicsIni()
                IniWrite, %A_Space%, %MechanicsIni%, Niko Track, Current Count
            }
        If (ToggleMechanic = "Betrayal")
            {
                MechanicsIni := MechanicsIni()
                IniWrite, %A_Space%, %MechanicsIni%, Betrayal Track, Current Count
            }
        If (ToggleMechanic = "Incursion")
            {
                MechanicsIni := MechanicsIni()
                IniWrite, %A_Space%, %MechanicsIni%, Incursion Track, Current Count
            }
        MechanicsActive()
        If (MechanicsActive = 0)
        {
            NotificationIni := NotificationIni()
            IniWrite, 0, %NotificationIni%, Notification Active, Mechanic Notification Active
        }
        RefreshOverlay()
        Return
    }
}

Abyss()
{
    MechanicToggle("Abyss")
    Return
}
Betrayal()
{
    MechanicToggle("Betrayal")
    Return
}
Blight()
{
    MechanicToggle("Blight")
    Return
}
Breach()
{
    MechanicToggle("Breach")
    Return
}
Einhar()
{
    MechanicToggle("Einhar")
    Return
}
Expedition()
{
    MechanicToggle("Expedition")
    Return
}
Harvest()
{
    MechanicToggle("Harvest")
    Return
}
Incursion()
{
    MechanicToggle("Incursion")
    Return
}
Legion()
{
    MechanicToggle("Legion")
    Return
}
Niko()
{
    MechanicToggle("Niko")
    Return
}
Ritual()
{
    MechanicToggle("Ritual")
    Return
}
Ultimatum()
{
    MechanicToggle("Ultimatum")
    Return
}
Generic()
{
    MechanicToggle("Generic")
    Return
}
Eater()
{
    MechanicsFilePath := MechanicsIni()
    IniRead, Eater, %MechanicsFilePath%, Influence Track, Eater
    OldTrack := Eater
    Eater ++
    If(Eater = 29)
    {
        Eater = 0
    }
    IniWrite, %Eater%, %MechanicsFilePath%, Influence Track, Eater
    RefreshOverlay()
    Return
}
Searing()
{
    MechanicsFilePath := MechanicsIni()
    IniRead, Searing, %MechanicsFilePath%, Influence Track, Searing
    OldTrack := Searing
    Searing ++
    If(Searing = 29)
    {
        Searing = 0
    }
    IniWrite, %Searing%, %MechanicsFilePath%, Influence Track, Searing
    RefreshOverlay()
    Return
}

Maven()
{
    MechanicsFilePath := MechanicsIni()
    IniRead, Maven, %MechanicsFilePath%, Influence Track, Maven
    OldTrack := Maven
    Maven ++
    If (Maven > 10)
        {
            Maven := 10
        }
    IniWrite, %Maven%, %MechanicsFilePath%, Influence Track, Maven
    RefreshOverlay()
    Return
}

OverlayButtonLock()
{
    Gui, Overlay:Submit, NoHide
    WinGetPos, newwidth, newheight,,,Overlay
    newheight := newheight + 25
    Tooltip
    MoveActive := 0
    OverlayPath := OverlayIni()
    Run, %A_ScriptDir%\Resources\Scripts\WindowMonitor.ahk ahk_class AutoHotkey
    IniWrite, %newheight%, %OverlayPath%, Overlay Position, Height
    IniWrite, %newwidth%, %OverlayPath%, Overlay Position, Width
    RefreshOverlay()
    Return
}

Move()
{
    MoveActive := 1
    RefreshOverlay()
}

WM_RBUTTONDOWN() {
    If (GetKeyState("Alt", "P"))
    {
        ; Get the ID of the control that received the message.
        ObjectClicked := A_GuiControl
        MechanicsFilePath := MechanicsIni()
        CheckMechanic := "Searing|Eater|Maven|Incursion"
        For each, CountObject in StrSplit(CheckMechanic, "|")
        {
            If InStr(ObjectClicked, CountObject)
            {
                IniWrite, 0, %MechanicsFilePath%, Influence Track, %CountObject%
            }
        }
    }
    RefreshOverlay()
}