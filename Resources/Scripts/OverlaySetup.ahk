Global HeightEdit
Global FontEdit
Global OrientationChoice

OverlaySetup()
{
    Gui, OverlaySetup:Destroy
    CheckTheme()
    OverlayPath := OverlayIni()
    IniRead, OverlayOrientation, %OverlayPath%, Overlay Position, Orientation
    DDSelect := 2
    If(OverlayOrientation = "Horizontal")
    {
        DDSelect := 1
    }
    Gui, OverlaySetup:Font, c%Font% s11
    Gui, OverlaySetup:Add, Text, Section x20, Layout:
    Gui, OverlaySetup:Font, s10
    Gui, OverlaySetup:Add, DropDownList, xp x100 Choose%DDSelect% gOrientationChoice vOrientationChoice Section, Horizontal|Vertical
    If (ColorMode = "Dark")
    {
        RefreshColor = refresh white.png
    }
    If (ColorMode = "Light")
    {
        RefreshColor = refresh.png
    }
    If (ColorMode = "Custom")
    {
        If (Icons = "White")
            {
                RefreshColor = refresh white.png
            }
        If (Icons = "Black")
            {
                RefreshColor = refresh.png
            }
    }

    Gui, OverlaySetup:Add, Picture, gTestOverlay w25 h25 ys x+45, Resources/Images/%RefreshColor%
    Space = y+5
    Gui, OverlaySetup:Font, cBlack s11
    Gui, OverlaySetup:Color, %Background%
    Gui, OverlaySetup:Add, GroupBox, w350 h10 xn x10
    Space = y+2
    OverlayList := "Height|Font"
    For each, OverlayItem in StrSplit(OverlayList, "|")
    {
        IniRead, %OverlayItem%Value, %OverlayPath%, Size, %OverlayItem%
        Gui, OverlaySetup:Font, c%Font% s11
        If (OverlayItem = "Height")
        {
            ItemText = Icon Size:
        }
        If (OverlayItem = "Font")
        {
            ItemText = Font Size:
        }
        Gui, OverlaySetup:Add, Text, xn x20 Section, %ItemText%
        Gui, OverlaySetup:Font, cBlack s10
        Value := %OverlayItem%Value
        Gui, OverlaySetup:Add, Edit, Center v%OverlayItem%Edit g%OverlayItem%Edit ys x200 w50
        Gui, OverlaySetup:Add, UpDown, Range0-255, %Value% ;;;; 0 = invisible 255 = Opaque
    }
    Gui, OverlaySetup:-Caption -Border
    Gui, OverlaySetup:Add, Button, xn x20 w80 h30, Move
    Gui, OverlaySetup:Add, Button, xp x270 w80 h30, OK
    Gui, OverlaySetup:Show, w375, +AlwaysOnTop OverlaySetup
    Return
}

TestOverlay()
{
    RefreshOverlay()
}

OrientationChoice()
{
    Gui, OverlaySetup:Submit, NoHide
    OverlayPath := OverlayIni()
    IniWrite, %OrientationChoice%, %OverlayPath%, Overlay Position, Orientation
}

FontEdit()
{
    Gui, OverlaySetup:Submit, NoHide
    OverlayPath := OverlayIni()
    IniWrite, %FontEdit%, %OverlayPath%, Size, Font
}

HeightEdit()
{
    Gui, OverlaySetup:Submit, NoHide
    OverlayPath := OverlayIni()
    IniWrite, %HeightEdit%, %OverlayPath%, Size, Height
}

OverlaySetupButtonOk()
{
    OrientationChoice()
    FontEdit()
    HeightEdit()
    RefreshOverlay()
    Gui, OverlaySetup:Destroy
}

OverlaySetupButtonMove()
{
    Move()
}