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
            If (Mechanic = "Eater") or (Mechanic = "Searing")
            {
                IniRead, InfluenceCount, Resources/Settings/Mechanics.ini, InfluenceTrack, %Mechanic%
                Gui, Move:Font, cWhite s12
                x2 := mechanicx +17
                Gui, Move:Add, Text, x%x2% y45 w50 h50, %InfluenceCount%
            }
            if (%mechanicactive% = 1)
            {
                If (Mechanic = "Eater") or (Mechanic = "Searing")
                {
                    Gui, Move:Add, Picture, g%Mechanic% yn y5 w50 h40, Resources/Images/%Mechanic%.png
                }
                Else
                {
                    Gui, Move:Add, Picture, g%Mechanic% yn y5 w50 h40, Resources/Images/%Mechanic%_selected.png
                }
            }
            Else
            {
                Gui, Move:Add, Picture, g%Mechanic% yn y5 w50 h40, Resources/Images/%Mechanic%.png
            }
            mechanictest ++
        }
    }

    Gui, Move:Add, Button, gLock x20 y50, &Lock
    If (mechanicx < 200)
    {
        mechanicx = 190
    }
    Gui, Move:Color, %Background%
    Gui, Move:Font, c%Font% s11
    Gui, Move:Add, Text, y53 x70,Drag around and press "Lock" to reposition overlay.
    Gui, Move:+AlwaysOnTop

    Gui, Move:Show, x%widthoff% y%heightoff% w800, Move
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