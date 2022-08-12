Overlay:
FileReadLine, heightVar, Resources/Settings/overlayposition.txt, 1
StringTrimLeft, height, heightVar, 7
FileReadLine, widthVar, Resources/Settings/overlayposition.txt, 2
StringTrimLeft, width, widthVar, 6
Gosub, ReadMechanics
Gosub, MechanicsActive
mechanictest = 0

    Loop, 1
    For each, Mechanic in StrSplit(MechanicSearch, "|")
    {
        mechanicon = %Mechanic%On
        mechanicactive = %Mechanic%Active
        if (%mechanicon% = 1)
        {
            if (mechanictest = 0)
            {
                mechanicx=5
            }
            else
            {
                mechanicx := (mechanictest*55)+5
            }
            If (Mechanic = "Eater") or (Mechanic = "Searing")
            {
                IniRead, InfluenceCount, Resources/Settings/Mechanics.ini, InfluenceTrack, %Mechanic%
                Gui, 2:Font, cWhite s12
                x2 := mechanicx +17
                Gui, 2:Add, Text, x%x2% y45 w50 h50, %InfluenceCount%
            }
            if (%mechanicactive% = 1)
            {
                Gui, 2:Add, Picture, g%Mechanic% x%mechanicx% y5 w50 h40, Resources/Images/%Mechanic%_selected.png
            }
            Else
            {
                Gui, 2:Add, Picture, g%Mechanic% x%mechanicx% y5 w50 h40, Resources/Images/%Mechanic%.png
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
        WinWait, Path of Exile
    }
    If (PoeID != "")
    {
        Break
    }
}
Gui, 2:+AlwaysOnTop +ToolWindow +Owner%PoeID% +HWNDOverlay
Gui, 2:Show, NoActivate x%width% y%height%, Overlay
WinSet, Style, -0xC00000, Overlay
WinSet, TransColor, 1e1e1e %OverlayTransparency%, Overlay
If (WarningActive = "Yes")
{
    Gosub, Reminder
}
Return
