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
    If (Mechanic = "Quest Tracker Text")
        {
            OCRCalibrate("Side Area")
        }
    Else If (Mechanic = "Ritual Text")
        {
            OCRCalibrate("Ritual Area")
        }
    Else If (Mechanic ~= "i)\A(Ritual Icon|Ritual Shop|Eater Completion|Searing Completion|Maven Completion|Eater On|Maven On|Searing On)\z")
        {
            ImageCalibration(Mechanic)
        }
    Else If (Mechanic = "Influence Count")
        {
            OCRCalibrate("Influence Area")
        }
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

ImageCalibration(Mechanic)
{
    MsgBox(Mechanic " calibration is not currently implemented. Check back in future releases.")
    ; TestImage := "C:\Users\drwsi\Desktop\test\test.png"
    ; ; ScreenShot := ImagePutBuffer({Window: "ahk_Group PoeWindow"}) ; Screen capture
    ; ScreenShot := ImagePutBuffer(0) 
    ; ; Search := ImagePutBuffer(TestImage) ; Convert File -> Buffer
    ; SearchVariation := 0
    ; ; Loop 10 ;255
    ; ;     {

    ;         pic := ImagePutBuffer(0)                               ; Screen capture
    ;         ; pic.show() ; or ImageShow(pic)                         ; Show image
    ;         if xy := pic.ImageSearch("C:\Users\drwsi\Desktop\test\2.png", 150) {           ; Search image
    ;         MouseMove xy[1], xy[2]                             ; Move cursor
    ;                           ; MsgBox pic[xy*]
    ;         }

            ; if xy := pic.ImageSearch("test_image.png") {           ; Search image
            ;     MouseMove xy[1], xy[2]    
            
            ; ; ToolTip SearchVariation
            ; If xy := ScreenShot.ImageSearch("C:\Users\drwsi\Desktop\test\test.png", 10) ; Look in "ScreenShot" for "Search"
            ;     MouseMove xy[1], xy[2] 
            ;     ; {
            ;     ;     msgbox "Match! " A_Index
            ;     ; }
;             SearchVariation++
;         }
;     ToolTip
}

;OCR Zone
OCRCalibrate(Mechanic)
{
    If WinExist("Set Area")
    {
        WinClose
    }
    If WinExist("Calibrate Background")
        {
            WinClose
        }
    OCRSet := Gui(,"Set Area")
    CurrentTheme := GetTheme()
    OCRSet.BackColor := "Blue"
    WinActivate("ahk_group PoeOnly")
    WinWaitActive("ahk_group PoeOnly")
    PoeHWND := WinGetID("ahk_group PoeOnly")
    WinGetPos(&XOCR, &YOCR, &WOCR, &HOCR, "ahk_group PoeOnly")
    OCRSet.SetFont("s15 c" CurrentTheme[3])
    ScreenSearchIni := IniPath("ScreenSearch")
    XArea := IniRead(ScreenSearchIni, Mechanic, "X", XOCR)
    YArea := IniRead(ScreenSearchIni, Mechanic, "Y", YOCR)
    WArea := IniRead(ScreenSearchIni, Mechanic, "W", WOCR)
    HArea := IniRead(ScreenSearchIni, Mechanic, "H", HOCR)
    OCRSet.Add("Text", " w" WOCR-20 " y" HOCR/2-100 " Wrap" , "To set your calibration area position your mouse according to the boundry you are trying to set and press the assigned hotkey. Upon pressing the assigned hotkey the assigned number values should update. If for some reason the numbers are not updating click this text and try again.")
    OCRSet.Add("Text", "w75 XM Section", "Top")
    OCRSet.Add("Text", "w120 YS", "(Control + T)")
    OCRSet.Add("Text", "YS", "=")
    Global TopValue := OCRSet.Add("Text", "w80 YS Section", YArea)
    OCRSet.Add("Text", "w75 XM Section", "Bottom")
    OCRSet.Add("Text", "w120 YS", "(Control + B)")
    OCRSet.Add("Text", "YS", "=")
    Global BottomValue := OCRSet.Add("Text", "w80 YS Section", HArea)
    OCRSet.Add("Text", "w75 XM Section", "Left")
    OCRSet.Add("Text", "w120 YS", "(Control + L)")
    OCRSet.Add("Text", "YS", "=")
    Global LeftValue := OCRSet.Add("Text", "w80 YS Section", XArea)
    OCRSet.Add("Text", "w75 XM Section", "Right")
    OCRSet.Add("Text", "w120 YS", "(Control + R)")
    OCRSet.Add("Text", "YS", "=") 
    WinSetTransColor "Blue", OCRSet
    OCRSet.Opt("-Caption")
    OCRSet2 := Gui(,"Calibrate Background")
    OCRSet2.Opt("AlwaysOnTop -Caption +E0x08000000 +Owner" PoeHWND)
    OCRSet.Opt("AlwaysOnTop +Owner" OCRSet2.Hwnd)
    Global RightValue := OCRSet.Add("Text", "w80 YS Section", WArea)
    OCRSet.SetFont("s12 c" CurrentTheme[3])
    OCRSet.Add("Button", "XM Y+50", "Close").OnEvent("Click", CloseOCRSet.Bind(OCRSet, OCRSet2))
    OCRSet2.BackColor := CurrentTheme[1]
    WinSetTransparent(150, OCRSet2)
    OCRSet.SetFont("s1 cBlue")
    Global OCRSetMechanic := OCRSet.Add("Text", "YS", Mechanic) 
    OCRSet2.Show( "NoActivate x" XOCR " y" YOCR " h" HOCR " w" WOCR )
    OCRSet.Show( "x" XOCR " y" YOCR " h" HOCR " w" WOCR )
}

#HotIf WinActive("Set Area")

^t::
{
    NewValue := GetCalPosition("Y", OCRSetMechanic)
    TopValue.Text := NewValue
}

^b::
{
    NewValue := GetCalPosition("H", OCRSetMechanic)
    BottomValue.Text := NewValue
}

^l::
{
    NewValue := GetCalPosition("X", OCRSetMechanic)
    LeftValue.Text := NewValue
}

^r::
{
    NewValue := GetCalPosition("W", OCRSetMechanic)
    RightValue.Text := NewValue
}

#HotIf

GetCalPosition(Position, Mechanic)
{
    WinHide("Set Area")
    WinHide("Calibrate Background")
    CoordMode("Mouse", "Window")
    WinActivate("ahk_group PoeOnly")
    MouseGetPos(&MouseX, &MouseY)
    WinShow("Set Area")
    WinShow("Calibrate Background")
    WinActivate("Set Area")
    CoordMode("Mouse", "Screen")
    If (Position = "Y") or (Position = "H")
    {
        IniPath("ScreenSearch", "Write", MouseY, Mechanic.Text, Position)
        NewValue := MouseY
    }
    If (Position = "X") or (Position = "W")
    {
        IniPath("ScreenSearch", "Write", MouseX, Mechanic.Text, Position)
        NewValue := MouseX
    }
    Return NewValue
}

CloseOCRSet(OCRSet, OCRSet2, *)
{
    OCRSet.Destroy
    OCRSet2.Destroy
}