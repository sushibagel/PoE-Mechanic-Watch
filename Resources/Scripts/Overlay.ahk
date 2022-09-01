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
            if (%mechanicactive% = 1)
            {
                Gui, Overlay:Add, Picture, g%Mechanic% yn y5 w50 h40, Resources/Images/%Mechanic%_selected.png
            }
            Else
            {
                Gui, Overlay:Add, Picture, g%Mechanic% yn y5 w50 h40, Resources/Images/%Mechanic%.png
            }
            mechanictest ++
        }
    }
    If (InfluenceActive != "None")
    {
        MechanicsIni := MechanicsIni()
        IniRead, InfluenceCount, %MechanicsIni%, Influence Track, %InfluenceActive%
        Gui, Overlay:Add, Picture, g%InfluenceActive% yn y5 w45 h40 Section, Resources/Images/%InfluenceActive%.png
        Gui, Overlay:Font, cWhite s12
        Gui, Overlay:Add, Text, yp+41 x+-27, %InfluenceCount%
    }
    Gui, Overlay:Color, 1e1e1e
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
    Gui, Overlay:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
    Gui, Overlay:+AlwaysOnTop +ToolWindow +Owner%PoeID% +HWNDOverlay
    Gui, Overlay:Show, NoActivate x%width% y%height%, Overlay
    WinSet, Style, -0xC00000, Overlay
    WinSet, TransColor, 1e1e1e %OverlayTransparency%, Overlay
    WindowMonitor()
    Return
}

WindowMonitor()
{
    Loop 
    {
        If !WinActive("ahk_group PoEWindow")
        {
            Sleep, 200
            If !WinActive("ahk_group PoEWindow")
            {
                Gui, Overlay:Destroy
                If WinActive("Reminder")
                {
                    ReminderGui = Active
                }
                Loop
                If WinActive("ahk_group PoEWindow")
                {
                    Overlay()
                    If (ReminderGui = "Active")
                    {
                        ReminderGui =
                        EldritchReminder()
                    }
                }
            } 
            Else
            {
                WindowMonitor()
            }  
        }
    }
}

Abyss()
{
    Return
}
Blight()
{
    Return
}
Breach()
{
    Return
}
Expedition()
{
    Return
}
Harvest()
{
    Return
}
Incursion()
{
    Return
}
Metamorph()
{
    Return
}
Ritual()
{
    Return
}
Generic()
{
    Return
}
Eater()
{
    Return
}
Searing()
{
    Return
}