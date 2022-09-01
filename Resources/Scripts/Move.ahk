Move()
{
    OverlayIni := OverlayIni()
    IniRead, Height, %OverlayIni%, Overlay Position, Height
    IniRead, Width, %OverlayIni%, Overlay Position, Width
    heightoff := Height - 30
    widthoff := Width - 5

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
                Gui, Move:Add, Picture, g%Mechanic% yn y5 w50 h40, Resources/Images/%Mechanic%_selected.png
            }
            Else
            {
                Gui, Move:Add, Picture, g%Mechanic% yn y5 w50 h40, Resources/Images/%Mechanic%.png
            }
            mechanictest ++
        }
    }
    If (InfluenceActive != "None")
    {
        MechanicsIni := MechanicsIni()
        IniRead, InfluenceCount, %MechanicsIni%, Influence Track, %InfluenceActive%
        Gui, Move:Add, Picture, g%InfluenceActive% yn y5 w45 h40 Section, Resources/Images/%InfluenceActive%.png
        Gui, Move:Font, cWhite s12
        Gui, Move:Add, Text, yp+41 x+-27, %InfluenceCount%
        Gui, Move:Font, c%Font% s10
        Gui, Move:Add, Button, gLock yn y12, &Lock
    }
    Gui, Move:Color, %Background%
    Gui, Move:Font, cWhite s12
    Gui, Move:Add, Text, xn x10,Drag around and press "Lock" to reposition overlay.
    Gui, Move:+AlwaysOnTop

    Gui, Move:Show, x%widthoff% y%heightoff% , Move
    Return
}

Lock:
DetectHiddenWindows, On
WinGetPos,newwidth, newheight
Gui, Move:Submit
Gui, Move:Destroy
setheight:=newheight + 5
setwidth:=newwidth + 15

FileDelete, Resources/Settings/overlayposition.txt
FileAppend, height=%setheight% `n, Resources/Settings/overlayposition.txt
FileAppend, width=%setwidth%, Resources/Settings/overlayposition.txt
Return

MoveGuiClose()
{
    Gui, Move:Destroy
}

#3::
Overlay()
Return