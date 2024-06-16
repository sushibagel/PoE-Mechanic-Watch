CalibrationTool(*)
{
    CalibrationGui := GuiTemplate("CalibrationGui", "Calibration Tool", 500)
    CurrentTheme := GetTheme()
    CalibrationGui.SetFont("s12 Norm c" CurrentTheme[3])
    LoopCategories := ["Quest Tracker Text", "Ritual Icon", "Ritual Text", "Ritual Shop", "Influence Count"]
    LoopFootnote := ["1", "2", "1", "2", "3"]
    For Category in LoopCategories
        {
            CalibrationGui.Add("Text", "Section XM Right w140", Category)
            CalibrationGui.SetFont("s8 Underline c" CurrentTheme[2])
            CalibrationGui.Add("Text", " x+.8", LoopFootnote[A_Index]).OnEvent("Click",FootnoteShow.Bind(LoopFootnote[A_Index]))
            CalibrationGui.SetFont("s12 Norm c" CurrentTheme[3])
            CalibrationGui.Add("Text", "YS w120",) ;For consistent Spacing
            CalibrationGui.Add("Button", "YS", "Calibrate").OnEvent("Click", CalibrateMechanic.Bind(Category))
            CalibrationGui.Add("Button", "YS", "Sample").OnEvent("Click", SampleMechanic.Bind(Category, CalibrationGui))
        }
    Influences := VariableStore("Influences")
    TextWidth := ["w36", "w50", "w48"]
    SpacerWidth := ["w154", "w136", "w143"]
    SpacerWidth2 := ["w219", "w201", "w207"]
    MechanicsIni := IniPath("Mechanics")
    Global SearingValue := ""
    Global EaterValue := ""
    Global MavenValue := ""
    For Influence in Influences
        {
            CalibrationGui.Add("Text", "Section XM Right w140", Influence " Completion")
            CalibrationGui.SetFont("s8 Underline c" CurrentTheme[2])
            Footnote := 4
            UpDownRange := "Range0-28"
            If (Influence = "Maven")
                {
                    Footnote := 6
                    UpDownRange := "Range0-10"
                }
            CalibrationGui.Add("Text", " x+.8", Footnote).OnEvent("Click",FootnoteShow.Bind(Footnote))
            CalibrationGui.SetFont("s12 Norm c" CurrentTheme[3])
            CalibrationGui.Add("Text", "YS w62",) ;For consistent Spacing
            CurrentCount := IniRead(MechanicsIni, "Influence Track", Influence, 0)
            CalibrationGui.Add("Edit", "YS+5 w40 h25 Number Center Background" CurrentTheme[2], "Calibrate")
            %Influence%Value := CalibrationGui.Add("UpDown", "YS " UpDownRange, CurrentCount) ;### Needs event Handler
            CalibrationGui.Add("Button", "YS", "Calibrate").OnEvent("Click", CalibrateMechanic.Bind(Influence " Completion"))
            CalibrationGui.Add("Button", "YS", "Sample").OnEvent("Click", SampleMechanic.Bind(Influence " Completion", CalibrationGui))

            CalibrationGui.Add("Text", "Section XM Right w140", Influence " On")
            CalibrationGui.SetFont("s8 Underline c" CurrentTheme[2])
            CalibrationGui.Add("Text", " x+.8", "5").OnEvent("Click",FootnoteShow.Bind("5"))
            CalibrationGui.SetFont("s12 Norm c" CurrentTheme[3])
            CalibrationGui.Add("Text", "YS w120",) ;For consistent Spacing
            CalibrationGui.Add("Button", "YS", "Calibrate").OnEvent("Click", CalibrateMechanic.Bind(Influence " On"))
            CalibrationGui.Add("Button", "YS", "Sample").OnEvent("Click", SampleMechanic.Bind(Influence " On", CalibrationGui))
        }
    CalibrationGui.Show
    CalibrationGui.OnEvent("Close", CalibrationToolClose)
}

DestroyCalibrationGui(CalibrationGui)
{
    CalibrationGui.Destroy()
}

FootnoteShow(FootnoteNum, NA1, NA2)
{
    TriggeredBy := "Calibration Tool"
    WinGetPos(&X, &Y, &W, &H, TriggeredBy)
    XPos := X + W
    YPos := ((Y + H)/2) - 32
    If (FootnoteNum = 1)
        {
            GuiInfo := "Note: Calibration of this tool shouldn't be necessary but may help make it be faster on slower systems.`r`rUpon selecting `"Calibrate`" the Calibration Tool will minimize, simply click and drag (a yellow box should appear as you drag) to select the `"Calibrated`" area. It's recommended to select a larger area than may seem necessary to make sure the text is completely captured."
        }
    If (FootnoteNum = 2)
        {
            GuiInfo := "Upon selecting `"Calibrate`" the `"Snipping Tool`" will open on your computer, verify the `"Rectangular Snip`" mode is enabled and press `"New`". This should change your cursor to a crosshair, carefully select the section of your screen similar to the samples shown when clicking the `"Sample`" button. Be sure that your screenshot only includes a static image, if you have any background (any background game elements like your map ground) it can result in the tool failing to recognize future instances. Once you are happy with the screenshot you took, close the `"Snipping Tool`" without saving."
        }
    If (FootnoteNum = 3)
        {
            YPos := Y
            GuiInfo := "The Influence Count is used to verify/update your progress on the Eldritch Influences mechanics (Searing Exarch, Eater of Worlds and Maven). For this to update you will need to mouse over the influence buttons to show the `"Progress`" text.`r`rNote: Calibration of this tool shouldn't be necessary but it may help it be faster on slower systems. If you decide to calibrate this tool it is very important to read and follow the instructions to make sure that the entire area needed is being captured.`r`rWhen calibrating first check the layout of the text for each of the three mechanics with your inventory both open and closed, this is to help give you an idea of the total area needed. Once you select the `"Calbirate`" button the Calibration Tool will minimize, simply click and drag (a yellow box should appear as you drag) to select the `"Calibrated`" area. It's recommended to select a larger area than may seem necessary to make sure the text is completely captured."
        }
    If (FootnoteNum = 4)
        {
            GuiInfo := "To calibrate Eldritch Influence Completion you will need to have each stage (0-28) available. Set the number in the entry box to match the completion you want to calibrate by typing in the number or using the up/down arrows and press the `"Calibrate`" button. Upon selecting `"Calibrate`" the `"Snipping Tool`" will open on your computer, verify the `"Rectangular Snip`" mode is enabled and press `"New`". This should change your cursor to a crosshair, carefully select the section of your screen similar to the samples shown when clicking the `"Sample`" button. Once you are happy with the screenshot you took, close the `"Snipping Tool`" without saving."
        }
    If (FootnoteNum = 5)
        {
            YPos := Y
            GuiInfo := "The Eldritch Influence `"On`" search function is used is currently selected. When active it will attempt to switch between the three mechanics when necessary. Upon selecting `"Calibrate`" the `"Snipping Tool`" will open on your computer, verify the `"Rectangular Snip`" mode is enabled and press `"New`". This should change your cursor to a crosshair, carefully select the section of your screen similar to the samples shown when clicking the `"Sample`" button. Once you are happy with the screenshot you took, close the `"Snipping Tool`" without saving.`r`rNote: when calibrating the `"On`" search function be carefult to not select any of the colored outer ring area in your screenshot as it will cause issues with detection at various completion stages."
        }
    If (FootnoteNum = 6)
        {
            GuiInfo := "To calibrate Eldritch Influence Completion you will need to have each stage (0-10) available. Set the number in the entry box to match the completion you want to calibrate by typing in the number or using the up/down arrows and press the `"Calibrate`" button. Upon selecting `"Calibrate`" the `"Snipping Tool`" will open on your computer, verify the `"Rectangular Snip`" mode is enabled and press `"New`". This should change your cursor to a crosshair, carefully select the section of your screen similar to the samples shown when clicking the `"Sample`" button. Once you are happy with the screenshot you took, close the `"Snipping Tool`" without saving."
        }
    ActivateFootnoteGui(GuiInfo, XPos, YPos)
}

CalibrateMechanic(Mechanic, *)
{
    msgbox Mechanic
}

SampleMechanic(Mechanic, CalibrationGui, *)
{
    CalibrationGui.Submit(False)
    If InStr(Mechanic, "Completion")
        {
            ValueName := StrSplit(Mechanic, " ")
            ValueName := ValueName[1] 
            If (ValueName = "Eater")
                {
                    ValueSearch := EaterValue.Value
                }
            If (ValueName = "Searing")
                {
                    ValueSearch := SearingValue.Value
                }
            If (ValueName = "Maven")
                {
                    ValueSearch := MavenValue.Value
                }
            Mechanic := ValueName ValueSearch
        }
    TriggeredBy := "Calibration Tool"
    WinGetPos(&X, &Y, &W, &H, TriggeredBy)
    XPos := X + W
    YPos := ((Y + H)/2) - 32
    ImageFile := ImagePath(Mechanic, "No")
    ActivateSampleGui(Mechanic, ImageFile, XPos, YPos)
}

CalibrationToolClose(*)
{
    DestroyFootnote()
    DestroySampleGui()
}

ActivateSampleGui(GuiInfo, ImageFile, X:="", Y:="", W:="", H:="")
{
    DestroySampleGui()
    CurrentTheme := GetTheme()
    SampleGui.BackColor := CurrentTheme[1]
    SampleGui.SetFont("s13 c" CurrentTheme[3])
    GuiX := ""
    GuiY := ""
    GuiW := ""
    GuiH := ""
    LocationVariable := ["X", "Y", "W", "H"]
    For Location in LocationVariable
        {
            If !(%Location% = "")
                {
                    Gui%Location% := Location %Location%
                }
        }
    SampleGui.Add("Picture", "XM", ImageFile)    
    SampleGui.Show( GuiX GuiY GuiW GuiH)
    WinGetClientPos(,,&W,,"Image Sample")
    If (W > 600)
        WinMove(W/2,0,,,"Image Sample")
}

DestroySampleGui()
{
    If WinExist("Image Sample")
        {
            SampleGui.Destroy()
        }
    Global SampleGui := Gui(,"Image Sample")
}

;Ritual OCR Zone
RitualOCRCalibrate()
{
    ScreenSearchIni := IniPath("ScreenSearch")
    If WinActive("ahk_group PoeWindow")
        {
            WinGetPos(&XOCR, &YOCR, &WOCR, &HOCR, "A")
        }
        YOCR := HOCR - HOCR // 3
        XOCR := IniRead(ScreenSearchIni, "Ritual Area", "X", XOCR)
        YOCR := IniRead(ScreenSearchIni, "Ritual Area", "Y", YOCR)
        WOCR := IniRead(ScreenSearchIni, "Ritual Area", "W", WOCR)
        HOCR := IniRead(ScreenSearchIni, "Ritual Area", "H", HOCR)
        CalibrationZoneGui(XOCR, YOCR, WOCR, HOCR, "Ritual")
}

CalibrationZoneGui(XZone, YZone, WZone, HZone, Mechanic)
{
    msgbox XZone "|" YZone "|" WZone "|" HZone "|" A_ScreenWidth "|" A_ScreenHeight
    CalibrationGui := Gui("Resize","Calibration Zone")
    CurrentTheme := GetTheme()
    CalibrationGui.BackColor := "1e1e1e"
    CalibrationGui.SetFont("s13 c" CurrentTheme[3])
    CalibrationGui.Add("Link", "w" WZone " +Wrap Background" CurrentTheme[1], "Move and resize this window to fit the `"Calibration` Zone. Note: It is recommended to make the zone slightly larger than necessary. Click  <a href=`"  `">here.</a> to view a sample image of the area needed." XZone "|" YZone "|" WZone "|" HZone)
    WZone := WZone - 700
    CalibrationGui.Show("w" WZone "h" HZone)
    WinMove(XZone, YZone, , , "Calibration Zone")
    WinSetTransparent(100, "Calibration Zone")

}