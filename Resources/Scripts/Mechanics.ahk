MechanicsSelect(*)
{
    Global MechanicSelectGui := Gui(,"Mechanics")
    Global Footnote1 := ""
    Global Footnote2 := ""
    Global Footnote3 := ""
    DestroyMechanicsGui()
    CurrentTheme := GetTheme()
    MechanicSelectGui.BackColor := CurrentTheme[1]
    MechanicSelectGui.SetFont("s12 Bold c" CurrentTheme[3]) 
    Headers := ["Mechanic", "On", "Active Only", "Off", "Auto"]
    FootnoteIndex := 0
    For Title in Headers
        {
            HeaderWidth := "w100"
            If (Title = "On") or (Title = "Active Only") or (Title = "Auto")
                {
                    HeaderWidth := ""
                    FootnoteIndex++
                }
            LayoutSet := "YP"
            If (A_Index = 1)
                {
                    LayoutSet := "XM"
                }
            MechanicSelectGui.Add("Text", LayoutSet " Left " HeaderWidth, Title)
            If (Title = "On") or (Title = "Active Only") or (Title = "Auto")
                {
                    MechanicSelectGui.SetFont("s8 Underline Bold c" CurrentTheme[2])  
                    Footnote%FootnoteIndex% := MechanicSelectGui.Add("Text","YP w70 Left " HeaderWidth, FootnoteIndex)
                    Footnote%FootnoteIndex%.OnEvent("Click", ShowFootnote.Bind(FootnoteIndex))
                    MechanicSelectGui.SetFont("s12 Norm Bold c" CurrentTheme[3])  
                }
        } 
    MechanicSelectGui.AddText("w580 h1 XM Background" CurrentTheme[3])
    Mechanics := VariableStore("Mechanics")
    MechanicsIni := IniPath("Mechanics")
    For Mechanic in Mechanics
        {
            Active := IniRead(MechanicsIni, "Mechanics", Mechanic, 0)
            Auto := IniRead(MechanicsIni, "Auto Mechanics", Mechanic, 0)
            MechanicSelectGui.SetFont("s8 Underline c" CurrentTheme[2])
            FootnoteNum := ""
            AutoAvailable := 0
            If (Mechanic = "Betrayal") or (Mechanic = "Einhar") or (Mechanic = "Niko")
                {
                    FootnoteNum := 1
                    AutoAvailable := 1
                } 
            If (Mechanic = "Blight")
                {
                    FootnoteNum := 2
                    AutoAvailable := 1
                } 
            If (Mechanic = "Ultimatum") or (Mechanic = "Expedition")
                {
                    FootnoteNum := 3
                    AutoAvailable := 1
                } 
            If (Mechanic = "Incursion")
                {
                    FootnoteNum := 4
                    AutoAvailable := 1
                } 
            If (Mechanic = "Ritual")
                {
                    FootnoteNum := 5
                    AutoAvailable := 1
                } 
            MechanicSelectGui.Add("Text","XM Right w10", FootnoteNum).OnEvent("Click", ShowMechanicFootnote.Bind(FootnoteNum))
            MechanicSelectGui.SetFont("s10 Norm c" CurrentTheme[3]) 
            MechanicSelectGui.Add("Text","YP Left w85", Mechanic ":")
            OnCheck := ""
            OnlyCheck := ""
            OffCheck := ""
            If (Active = 1)
                {
                    OnCheck := "Checked"
                }
            If (Active = 2)
                {
                    OnlyCheck := "Checked"
                }
            If (Active = 0)
                {
                    OffCheck := "Checked"
                }
            MechanicSelectGui.Add("Radio","YP Left w135 " OnCheck).OnEvent("Click",OnSelected.Bind(Mechanic))
            MechanicSelectGui.Add("Radio","YP Left w135 " OnlyCheck).OnEvent("Click",ActiveSelected.Bind(Mechanic))
            MechanicSelectGui.Add("Radio","YP Left w110 " OffCheck).OnEvent("Click",OffSelected.Bind(Mechanic))
            If (AutoAvailable = 1)
                {
                    AutoChecked := ""
                    If (Auto = 1)
                        {
                            AutoChecked := "Checked"
                        }
                    MechanicSelectGui.Add("Checkbox","YP Left " AutoChecked).OnEvent("Click",AutoSelected.Bind(Mechanic))
                }
        }
    MechanicSelectGui.SetFont("s12 Bold c" CurrentTheme[3])
    MechanicSelectGui.AddText("w580 h1 XM Background" CurrentTheme[3])
    MechanicSelectGui.AddText("w150 Center XM Section", "Mechanic")
    MechanicSelectGui.AddText("w50 Center YS",)
    MechanicSelectGui.AddText("w200 Right YS", "Auto Switching/Tracking")
    MechanicSelectGui.SetFont("s8 Underline Bold c" CurrentTheme[2])  
    Global EldritchFootnoteHandler := MechanicSelectGui.Add("Text","YP w70 Left", 1)
    EldritchFootnoteHandler.OnEvent("Click", EldritchFootnote)
    Influences := VariableStore("Influences")
    MechanicSelectGui.SetFont("s10 Norm c" CurrentTheme[3])
    NoneChecked := "Checked"
    For Influence in Influences
        {
            Active := IniRead(MechanicsIni, "Influence", Influence, 0)
            OnCheck := ""
            SectionSet := ""
            If (Active = 1)
                {
                    OnCheck := "Checked"
                    NoneChecked := ""
                }
            If (A_Index = 1)
                {
                    SectionSet := "Section"
                }
            MechanicSelectGui.Add("Radio","XM Left x60 w135 " OnCheck " " SectionSet, Influence).OnEvent("Click",InfluenceSelected.Bind(Influence))
        }
    MechanicSelectGui.Add("Radio","XM Left x60 w135 " NoneChecked, "None").OnEvent("Click",InfluenceSelected.Bind("None"))
    MechanicSelectGui.Add("Text","YS Left w135 " OnCheck,).OnEvent("Click",InfluenceSelected.Bind("None"))
    Active := IniRead(MechanicsIni,"Auto Mechanics", "Eldritch", 0)
    IsChecked := ""
    If (Active = 1)
        {
            IsChecked := "Checked"
        }
    MechanicSelectGui.Add("Checkbox", IsChecked " YS Left w135 Section " OnCheck,).OnEvent("Click",InfluenceTracking)
    MechanicSelectGui.Add("Button", "XS-50 y+50", "Calibrate Search",).OnEvent("Click",CalibrateSearchButton)
    MechanicSelectGui.Show
    MechanicSelectGui.OnEvent("Close", MechanicSelectClose)
}

DestroyMechanicsGui()
{
    If WinExist("Mechanics")
        {
            MechanicSelectGui.Destroy()
        }
    Global MechanicSelectGui := Gui(,"Mechanics")
}

ShowFootnote(FootnoteSelected, NA1, NA2)
{
    If (FootnoteSelected = 1)
        {
            GuiInfo := "The `"On`" setting will enable the mechanic associated, adding an image to the overlay. Tracking for the mechanic can be enabled by clicking on the mechanic image or with an associated hotkey."
        }
    If (FootnoteSelected = 2)
        {
            GuiInfo := "The `"Active Only`" setting will enable the mechanic associated but the overlay image will not be present unless the mechanic is made active either by hotkey or an auto mechanic trigger."
        }
    If (FootnoteSelected = 3)
        {
            GuiInfo := "The `"Auto Mechanics`" setting allows mechanics to be triggered using a combination of Optical Character Recognition (OCR), Image Matching and reading game logs. Note: Not all mechanics will have an `"Auto`" trigger ability, this is mostly due to how they are implemented into the game. Some Auto Mechanics will may need calibration or setup, this can be done by navigating to the `"Calibrate Search`" option. You can learn more about how each mechanics auto tracking works by clicking on the number next to the mechanic."
        }
    If !(GuiInfo = "")
        {
            TriggeredBy := "Mechanics"
            WinGetPos(&X, &Y, &W, &H, TriggeredBy)
            Footnote%FootnoteSelected%.GetPos(,&ControlY)
            XPos := X + W
            YPos := Y + ControlY
            ActivateFootnoteGui(GuiInfo, XPos, YPos)
        }
}

ShowMechanicFootnote(FootnoteSelected, NA1, NA2)
{
    If (FootnoteSelected = 1)
        {
            GuiInfo := "The `"Auto`" setting for this mechanic uses Optical Character Recognition (OCR) to read text on your screen and recognize when certain mechanics are active in game. To use it you MUST have `"Quest Tracking`" enabled in the in-game settings and the corresponding mechanic must be set to `"On`" or `"Active Only`". If necessary you can adjust the OCR Zone in the Calibration Tool, but it should not be needed."
        }
    If (FootnoteSelected = 2)
        {
            GuiInfo := "The `"Auto`" setting for this mechanic uses a combination of Image Matching and reading the game logs to detect its status. To use it you MUST have `"Output Dialog to Chat`" enabled in the in-game settings and the corresponding mechanic must be set to `"On`" or `"Active Only`". You may need to calibrate the Image Matching Tool, this can be done by clicking the `"Calibrate Search`" button (Note: to calibrate you will need to have the mechanic active in game)."
        }
    If (FootnoteSelected = 3)
        {
            GuiInfo := "The `"Auto`" setting for this mechanic reads the game logs to determine its satus. To use it you MUST have `"Output Dialog to Chat`" enabled in the in-game settings and the corresponding mechanic must be set to `"On`" or `"Active Only`"."
        }
    If (FootnoteSelected = 4)
        {
            GuiInfo := "The `"Auto`" setting for this mechanic uses a combination of reading the game logs and Optical Character Recognition (OCR) to detect its status. To use it you MUST have `"Output Dialog to Chat`" enabled in the in-game settings and the corresponding mechanic must be set to `"On`" or `"Active Only`". If necessary you can adjust the OCR Zone in the Calibration Tool, but it should not be needed."
        }
    If (FootnoteSelected = 5)
        {
            GuiInfo := "The `"Auto`" setting for this mechanic uses a combination Image Matching and Optical Character Recognition (OCR) to detect its status. To use it the correstponding mechanic must be set to `"On`" or `"Active Only`". You may need to calibrate the Image Matching Tool, this can be done by clicking the `"Calibrate Search`" button (Note: to calibrate you will need to have the mechanic active in game). If necessary you can adjust the OCR Zone in the Calibration Tool, but it should not be needed."
        }
    If !(GuiInfo = "")
        {
            TriggeredBy := "Mechanics"
            WinGetPos(&X, &Y, &W, &H, TriggeredBy)
            Footnote2.GetPos(,&ControlY)
            XPos := X + W
            YPos := ((Y + H)/2) - 32
            ActivateFootnoteGui(GuiInfo, XPos, YPos)
        }
}

EldritchFootnote(*)
{
    GuiInfo := "This `"Auto Switching/Tracking`" setting incorporates all three Eldritch mechanics (Eater of Worlds, Searing Exarch and Maven) and will attempt to track completion numbers and switch between the three mechanics when possible. This is accomplished through a combination of reading the game logs, Optical Character Recognition (OCR) and Image Matching. `r `rHow it works: when in your hideout the Image Search feature will begin looking for the Eldritch map device icons, once it identifies which mechanic is currently active it will try to update the current completion total if it's within +/-2 completion. If at any time the completion count isn't updating correctly or it is outside of +/-2 completions you can hover your mouse over the active mechanics icon and OCR will be used to update the count. For more information on why the +/-2 complitions was used see <a href=`"https://github.com/sushibagel/PoE-Mechanic-Watch/discussions/51`">here.</a> Completion counts can be incremented by clicking the icon in the overlay or reset (to zero) by holding `"Alt`" and clicking."
    TriggeredBy := "Mechanics"
    WinGetPos(&X, &Y, &W, &H, TriggeredBy)
    EldritchFootnoteHandler.GetPos(,&ControlY)
    XPos := X + W
    YPos := Y + ControlY - 50 ;- 50 only used because of he wall of text... 
    WTotal := 350
    ActivateFootnoteGui(GuiInfo, XPos, YPos, WTotal)
}

ActiveSelected(MechanicSelected, NA1, NA2)
{
    MechanicsIni := IniPath("Mechanics")
    IniWrite(2, MechanicsIni, "Mechanics", MechanicSelected)
}

OnSelected(MechanicSelected, NA1, NA2)
{
    MechanicsIni := IniPath("Mechanics")
    IniWrite(1, MechanicsIni, "Mechanics", MechanicSelected)
}

OffSelected(MechanicSelected, NA1, NA2)
{
    MechanicsIni := IniPath("Mechanics")
    IniWrite(0, MechanicsIni, "Mechanics", MechanicSelected)
}

AutoSelected(MechanicSelected, Status, NA2)
{
    MechanicsIni := IniPath("Mechanics")
    IniWrite(Status.Value, MechanicsIni, "Auto Mechanics", MechanicSelected)
}

InfluenceSelected(MechanicSelected, Status, NA2)
{
    MechanicsIni := IniPath("Mechanics")
    Influences := VariableStore("Influences")
    For Influence in Influences
        {
            IniWrite(0, MechanicsIni, "Influence", Influence)
        }
    If !(MechanicSelected = "None")
        {
            IniWrite(Status.Value, MechanicsIni, "Influence", MechanicSelected)
        }
}

InfluenceTracking(Status, NA2)
{
    MechanicsIni := IniPath("Mechanics")
    IniWrite(Status.Value, MechanicsIni, "Auto Mechanics", "Eldritch")
}

MechanicSelectClose(*)
{
    DestroyFootnote()
}

CalibrateSearchButton(*)
{
    DestroyMechanicsGui()
    CalibrationTool()
}