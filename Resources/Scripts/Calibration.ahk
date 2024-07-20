FootnoteShow(FootnoteNum, *)
{
    FootnoteMenu := Menu()
    If (FootnoteNum = 1)
        {
            FootnoteMenu.Add("Note: Calibration of this tool shouldn't be", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("necessary but may help make faster on", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("slower systems.", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add(A_Space, DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("Upon selecting `"Calibrate`" the Calibration", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("Tool will minimize, simply click and drag", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("(a yellow box should appear as you drag) to", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("select the `"Calibrated`" area. It's", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("recommended to select a larger area than may", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("seem necessary to make sure the text is", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("completely captured.", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    If (FootnoteNum = 2)
        {
            FootnoteMenu.Add("Upon selecting `"Calibrate`" the `"Snipping Tool`"", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("will open on your computer, verify the", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("`"Rectangular Snip`" mode is enabled and press", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("`"New`". This should change your cursor to a", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("crosshair, carefully select the section of your", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("screen similar to the samples shown when", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("clicking the `"Sample`" button. Be sure that", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("your screenshot only includes a static image,", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("if you have any background (any background", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("game elements like your map ground) it can", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("result in the tool failing to recognize future", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("instances. Once you are happy with the", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("screenshot you took, close the", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("`"Snipping Tool`" without saving.", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    If (FootnoteNum = 3)
        {
            FootnoteMenu.Add("The Influence Count is used to verify/update", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("your progress on the Eldritch Influences", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("mechanics (Searing Exarch, Eater of Worlds", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("and Maven). For this to update you will", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("need to mouse over the influence buttons", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("to show the `"Progress`" text.", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add(A_Space, DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("Note: Calibration of this tool shouldn't be", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("necessary but it may help it be faster on", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("slower systems. If you decide to calibrate", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("this tool it is very important to read and", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("follow the instructions to make sure that", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("the entire area needed is being captured.", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add(A_Space, DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("When calibrating first check the layout of", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("the text for each of the three mechanics", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("with your inventory both open and closed,", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("this is to help give you an idea of the", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("total area needed. Once you select the", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("`"Calbirate`" button the Calibration Tool", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("will minimize, simply click and drag", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("(a yellow box should appear as you drag)", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("to select the `"Calibrated`" area.", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("It's recommended to select a larger area", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("than may seem necessary to make sure the", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("text is completely captured.", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    If (FootnoteNum = 4)
        {
            FootnoteMenu.Add("Tracking for the mechanic can be enabled by", DestroyFootnoteMenu.Bind(FootnoteMenu))

            FootnoteMenu.Add("To calibrate Eldritch Influence Completion", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("you will need to have each stage (0-28)", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("available. Set the number in the entry box", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("to match the completion you want to calibrate", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("by typing in the number or using the up/down", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("arrows and press the `"Calibrate`" button.", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("Upon selecting `"Calibrate`" the `"Snipping", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add(" Tool`" will open on your computer, verify", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("the `"Rectangular Snip`" mode is enabled and", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("press `"New`". This should change your cursor", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("to a crosshair, carefully select the section", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("of your screen similar to the samples shown", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("when clicking the `"Sample`" button. Once", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("you are happy with the screenshot you took,", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("close the `"Snipping Tool`" without saving.", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    If (FootnoteNum = 5)
        {
            FootnoteMenu.Add("The Eldritch Influence `"On`" search function", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("is used is currently selected. When active it", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("will attempt to switch between the three", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("mechanics when necessary. Upon selecting", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("`"Calibrate`" the `"Snipping Tool`" will open", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("n your computer, verify the `"Rectangular Snip`"", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("mode is enabled and press `"New`". This should", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("change your cursor to a crosshair, carefully", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("select the section of your screen similar to", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("the samples shown when clicking the `"Sample`"", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("button. Once you are happy with the screenshot", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("you took, close the `"Snipping Tool`"", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("without saving.", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add(A_Space, DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("Note: when calibrating the `"On`" search function", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("be careful to not select any of the colored outer", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("ring area in your screenshot as it will cause", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("issues with detection at various completion stages.", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    If (FootnoteNum = 6)
        {
            FootnoteMenu.Add("To calibrate Eldritch Influence Completion", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("you will need to have each stage (0-10)", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("available. Set the number in the entry box", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("to match the completion you want to calibrate", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("by typing in the number or using the up/down", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("arrows and press the `"Calibrate`" button.", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("Upon selecting `"Calibrate`" the `"Snipping", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("Tool`" will open on your computer, verify the", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add(" `"Rectangular Snip`" mode is enabled and", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("press `"New`". This should change your cursor", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("to a crosshair, carefully select the section", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("of your screen similar to the samples shown", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("when clicking the `"Sample`" button. Once", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("you are happy with the screenshot you took,", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("close the `"Snipping Tool`" without saving.", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    FootnoteMenu.Show() 
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

SampleMechanic(Mechanic, CalibrationGui, ButtonInfo *)
{
    ControlGetPos(&XPos,&YPos,&WPos,,ButtonInfo[1])
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
    TriggeredBy := "Settings"
    WinGetPos(&X, &Y, &W, &H, TriggeredBy)
    XPos := XPos + X + WPos + 10
    ; YPos := ((Y + H)/2) - 32
    ImageFile := ImagePath(Mechanic, "No")
    ActivateSampleGui(Mechanic, ImageFile, XPos, YPos)
}

ActivateSampleGui(GuiInfo, ImageFile, X:="", Y:="", W:="", H:="")
{
    DestroySampleGui()
    CurrentTheme := GetTheme()
    SampleGui.BackColor := CurrentTheme[1]
    SampleGui.SetFont("s13 c" CurrentTheme[3])
    GuiPosX := ""
    GuiPosY := ""
    GuiPosW := ""
    GuiPosH := ""
    LocationVariable := ["X", "Y", "W", "H"]
    For Location in LocationVariable
        {
            If !(%Location% = "")
                {
                    GuiPos%Location% := Location %Location%
                }
        }
    SampleGui.Add("Picture", "XM", ImageFile)
    SampleGui.Show( GuiPosX GuiPosY GuiPosW GuiPosH)
    WinGetClientPos(,,&W,,"Image Sample")
    If (W > 600) or (W + X > A_ScreenWidth)
    {
        WinMove(X-W,Y,,,"Image Sample")
    }   
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
    A_Clipboard := "" ; Make sure clipboard is empty so we can tell if a screenshot was taken.
    TestImage := "Resources/Images/Image Search/Custom/Test.png"
    If FileExist(TestImage)
    {
        FileDelete(TestImage)
    }
    WinMinimize("Settings")
    Run("SnippingTool") 
    WinWait("Snipping Tool")
    WinWaitClose("Snipping Tool")
    ClipWait(,1)
    Sleep(1000)
    WinWaitClose("Snipping Tool")
    
    ImagePutFile(ClipboardAll(), TestImage) ;Temporarily save as Test.png
    Try 
    {
        ScreenShot := ImagePutBuffer({Window: "ahk_Group PoeOnly"}) ; Screen capture
    }
    Catch Error
    {
        WinActivate("Settings")
        FootnoteMenu := Menu()
        FootnoteMenu.Add(Mechanic " Calibration failed try again!", DestroyFootnoteMenu.Bind(FootnoteMenu))
        WinWaitActive("Settings")
        WinGetPos(&X, &Y, &W, &H, "Settings")
        FootnoteMenu.Show(X+W/2, Y+H/2) 
    }
    Else
    {
        ScreenShot := ImagePutBuffer(0)
        Search := ImagePutBuffer(TestImage) ; Convert File -> Buffer 
        If ScreenShot.ImageSearch(Search) ; Look in "ScreenShot" for "Search"
        {
            NewImage := ImagePath(Mechanic, "Force") ;Get path for file. 
            Try 
            {
                ImagePutFile(ClipboardAll(), NewImage) ; Save file 
            } 
            Catch Error
            {
                WinActivate("Settings")
                FootnoteMenu := Menu()
                FootnoteMenu.Add(Mechanic " Calibration failed try again!", DestroyFootnoteMenu.Bind(FootnoteMenu))
                WinWaitActive("Settings")
                WinGetPos(&X, &Y, &W, &H, "Settings")
                FootnoteMenu.Show(X+W/2, Y+H/2) 
            }
            Else
            {
                FileDelete(TestImage)
                WinRestore("Settings")
                FootnoteMenu := Menu()
                FootnoteMenu.Add( Mechanic " Calibration was successful!", DestroyFootnoteMenu.Bind(FootnoteMenu))
                WinWaitActive("Settings")
                WinGetPos(&X, &Y, &W, &H, "Settings")
                FootnoteMenu.Show(X+W/2, Y+H/2) 
            }
        }
        Else
        {
            WinActivate("Settings")
            FootnoteMenu := Menu()
            FootnoteMenu.Add(Mechanic " Calibration failed try again!", DestroyFootnoteMenu.Bind(FootnoteMenu))
            WinWaitActive("Settings")
            WinGetPos(&X, &Y, &W, &H, "Settings")
            FootnoteMenu.Show(X+W/2, Y+H/2) 
        }
    }
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
    If WinExist("Settings")
        {
            WinMinimize
        } 
    OCRSet := Gui(,"Set Area")
    CurrentTheme := GetTheme()
    OCRSet.BackColor := "Blue"
    If WinExist("ahk_group PoeOnly")
    {
        WinActivate("ahk_group PoeOnly")
    }
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