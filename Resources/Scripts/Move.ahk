Move:
FileReadLine, heightVar, Resources/Settings/overlayposition.txt, 1
StringTrimLeft, height, heightVar, 7
FileReadLine, widthVar, Resources/Settings/overlayposition.txt, 2
StringTrimLeft, width, widthVar, 6
heightoff := height - 30
widthoff := width - 5

GoSub, ReadMechanics
GoSub, MechanicsActive
mechanictest = 0
Gui, 3:Color, %Background%
Gui, 3:Font, c%Font% s11
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
        if (%mechanicactive% = 1) 
        {
            If (Mechanic = "Eater") or (Mechanic = "Searing")
            {
                    Gui, 2:Add, Picture, g%Mechanic% x%mechanicx% y5 w50 h40, Resources/Images/%Mechanic%.png
            }
            Else
            {
                Gui, 2:Add, Picture, g%Mechanic% x%mechanicx% y5 w50 h40, Resources/Images/%Mechanic%_selected.png
            }
        }
        Else
        {
            Gui, 3:Add, Picture, g%mechanic% x%mechanicx% y5 w50 h40 , Resources/Images/%mechanic%.png
        }
        mechanictest ++
    }
}

    Gui, 3:Add, Button, gLock x20 y50, &Lock
    If (mechanicx < 200)
    {
        mechanicx = 190
    }
    Gui, 3:Add, Text, +Wrap w%mechanicx% y53 x70,Drag around and press "Lock" to reposition overlay.
    Gui, 3:+AlwaysOnTop
    GuiWidth := ((AbyssOn + BlightOn + BreachOn + ExpeditionOn + HarvestOn + IncursionOn + MetamorphOn + RitualOn + GenericOn + SearingOn + EaterOn)*55)+15
    If (GuiWidth < 250)
    {
        GuiWidth := 250
    }
    Gui, 3:Show, x%widthoff% y%heightoff% w%GuiWidth%, Move
Return

Lock:
DetectHiddenWindows, On
WinGetPos,newwidth, newheight
Gui, 3:Submit
Gui, 3:Destroy
setheight:=newheight + 5
setwidth:=newwidth + 15

FileDelete, Resources/Settings/overlayposition.txt
FileAppend, height=%setheight% `n, Resources/Settings/overlayposition.txt
FileAppend, width=%setwidth%, Resources/Settings/overlayposition.txt
Return