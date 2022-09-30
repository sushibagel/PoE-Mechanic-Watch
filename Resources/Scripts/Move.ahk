Move()
{
    OverlayPath := OverlayIni()
    IniRead, Height, %OverlayPath%, Overlay Position, Height
    IniRead, Width, %OverlayPath%, Overlay Position, Width
    IniRead, OverlayOrientation, %OverlayPath%, Overlay Position, Orientation
    IniRead, IconHeight, %OverlayPath%, Icon Size, Height
    If (OverlayOrientation = "Horizontal")
    {
        OverlayOrientation := "yn"
    }
    If (OverlayOrientation = "Vertical")
    {
        OverlayOrientation := "xn"
    }
    heightoff := Height - 30
    widthoff := Width - 42

    ReadMechanics()
    MechanicsActive()
    InfluenceActive()
    mechanictest = 0
    Gui, Move:Add, Button, gLock xn x5, &Lock
    For each, Mechanic in StrSplit(MechanicSearch, "|")
    {
        mechanicon = %Mechanic%On
        mechanicactive = %Mechanic%Active
        If (%mechanicon% = 1)
        {
            if (%mechanicactive% = 1)
            {
                Gui, Move:Add, Picture, g%Mechanic% %OverlayOrientation% w-1 h%IconHeight%, Resources/Images/%Mechanic%_selected.png
            }
            Else
            {
                Gui, Move:Add, Picture, g%Mechanic% %OverlayOrientation% w-1 h%IconHeight%, Resources/Images/%Mechanic%.png
            }
            mechanictest ++
        }
    }
    If (InfluenceActive != "None")
    {
        MechanicsPath := MechanicsIni()
        IniRead, InfluenceCount, %MechanicsPath%, Influence Track, %InfluenceActive%
        Gui, Move:Add, Picture, g%InfluenceActive% %OverlayOrientation% w-1 h%IconHeight% Section, Resources/Images/%InfluenceActive%.png
        Gui, Move:Font, cWhite s12
        Gui, Move:Add, Text, yp+41 x+-27, %InfluenceCount%
        Gui, Move:Font, c%Font% s10
    }
    Gui, Move:Color, %Background%
    Gui, Move:Font, cWhite s12
    Gui, Move:Add, Text, xn x10,Drag around and press "Lock" to reposition overlay.
    Gui, Move:+AlwaysOnTop
    Gui, Move:Show, x%widthoff% y%heightoff% , Move
    WinSet, Transparent, 100, Move
    Return
}

Lock()
{
    DetectHiddenWindows, On
    WinGetPos,newwidth, newheight
    Gui, Move:Submit
    Gui, Move:Destroy
    setheight:=newheight + 5
    setwidth:=newwidth - 10
    OverlayPath := OverlayIni()
    IniWrite, %setheight%, %OverlayPath%, Overlay Position, Height
    IniWrite, %setwidth%, %OverlayPath%, Overlay Position, Width
    RefreshOverlay()
    Return
}

MoveGuiClose()
{
    Gui, Move:Destroy
}