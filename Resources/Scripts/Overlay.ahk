
#Q::
Overlay()
{
    OverlayIni := OverlayIni()
    IniRead, Height, %OverlayIni%, Overlay Position, Height
    IniRead, Width, %OverlayIni%, Overlay Position, Width
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
            If (Mechanic = "Eater") or (Mechanic = "Searing")
            {
                IniRead, InfluenceCount, Resources/Settings/Mechanics.ini, InfluenceTrack, %Mechanic%
                Gui, 2:Font, cWhite s12
                x2 := mechanicx +17
                Gui, 2:Add, Text, x%x2% y45 w50 h50, %InfluenceCount%
            }
            if (%mechanicactive% = 1)
            {
                If (Mechanic = "Eater") or (Mechanic = "Searing")
                {
                    Gui, 2:Add, Picture, g%Mechanic% yn y5 w50 h40, Resources/Images/%Mechanic%.png
                }
                Else
                {
                    Gui, 2:Add, Picture, g%Mechanic% yn y5 w50 h40, Resources/Images/%Mechanic%_selected.png
                }
            }
            Else
            {
                Gui, 2:Add, Picture, g%Mechanic% yn y5 w50 h40, Resources/Images/%Mechanic%.png
            }
            mechanictest ++
        }
    }
    Gui, 2:Color, 1e1e1e
    Loop
    {
        WinGet, PoeID, ID, Path of Exile
        If (PoeID = "")
        {
            IfWinActive, Transparency
            {
                Break
            }
            Else
            {
                    WinWait, Path of Exile
            }
        }
        If (PoeID != "")
        {
            Break
        }
    }
    IniRead, OverlayTransparency, Resources\Settings\Transparency.ini, Transparency, Overlay, 255
    Gui, 2:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
    Gui, 2:+AlwaysOnTop +ToolWindow +Owner%PoeID% +HWNDOverlay
    Gui, 2:Show, NoActivate x%width% y%height%, Overlay
    WinSet, Style, -0xC00000, Overlay
    WinSet, TransColor, 1e1e1e %OverlayTransparency%, Overlay
    Return
}

