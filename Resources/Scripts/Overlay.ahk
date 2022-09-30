Overlay()
{
    RefreshOverlay()
    Run, Resources\Scripts\WindowMonitor.ahk
    Return
}

RefreshOverlay()
{
    Gui, Overlay:Destroy
    OverlayPath := OverlayIni()
    IniRead, Height, %OverlayPath%, Overlay Position, Height
    IniRead, Width, %OverlayPath%, Overlay Position, Width
    IniRead, IconHeight, %OverlayPath%, Icon Size, Height
    ReadMechanics()
    MechanicsActive()
    InfluenceActive()
    mechanictest = 0
    
    For each, Mechanic in StrSplit(MechanicSearch, "|")
    {
        mechanicon = %Mechanic%On
        mechanicactive = %Mechanic%Active
        If (%mechanicon% = 1)
        {
            if (%mechanicactive% = 1)
            {
                Gui, Overlay:Add, Picture, g%Mechanic% yn y5 w-1 h%IconHeight%, Resources/Images/%Mechanic%_selected.png
            }
            Else
            {
                Gui, Overlay:Add, Picture, g%Mechanic% yn y5 w-1 h%IconHeight%, Resources/Images/%Mechanic%.png
            }
            mechanictest ++
        }
    }
    If (InfluenceActive != "None")
    {
        MechanicsPath := MechanicsIni()
        IniRead, InfluenceCount, %MechanicsPath%, Influence Track, %InfluenceActive%
        Gui, Overlay:Add, Picture, g%InfluenceActive% yn y5 w-1 h%IconHeight% Section, Resources/Images/%InfluenceActive%.png
        Gui, Overlay:Font, cWhite s12
        Gui, Overlay:Add, Text, yp+41 x+-29, %InfluenceCount%
    }
    Gui, Overlay:Color, 1e1e1e
    ; Loop
    ; {
    ;     WinGet, PoeID, ID, Path of Exile
    ;     If (PoeID = "")
    ;     {
    ;         IfWinActive, Transparency
    ;         {
    ;             Break
    ;         }
    ;         Else
    ;         {
    ;             WinWait, Path of Exile
    ;         }
    ;     }
    ;     If (PoeID != "")
    ;     {
    ;         Break
    ;     }
    ; }
    TransparencyPath := TransparencyIni()
    IniRead, OverlayTransparency, %TransparencyPath%, Transparency, Overlay, 255
    Gui, Overlay:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
    Gui, Overlay:+AlwaysOnTop +ToolWindow +Owner%PoeID% +HWNDOverlay
    Gui, Overlay:Show, NoActivate x%width% y%height%, Overlay
    WinSet, Style, -0xC00000, Overlay
    WinSet, TransColor, 1e1e1e %OverlayTransparency%, Overlay
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
        Gui, Overlay:Destroy
        Overlay()
        Return
    }
    If (%ActiveCheck% = 1)
    {
        IniWrite, 0, %MechanicsPath%, Mechanic Active, %ToggleMechanic%
        Gui, Overlay:Destroy
        ReminderActive := 0
        Overlay()
        Return
    }
}

Abyss()
{
    MechanicToggle("Abyss")
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
Metamorph()
{
    MechanicToggle("Metamorph")
    Return
}
Ritual()
{
    MechanicToggle("Ritual")
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
    ControlSetText, %OldTrack%, %Eater%, Overlay
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
    ControlSetText, %OldTrack%, %Searing%, Overlay
    Return
}