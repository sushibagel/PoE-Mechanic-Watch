#Include <Gdip_All>

Global BlightAuto
Global ExpeditionAuto 
Global IncursionAuto
Global MetamorphAuto
Global RitualAuto
Global AutoMechanicSearch
Global Sample1
Global Sample2
Global Sample3
Global Sample4
Global Sample5
Global Sample6
Global Sample7
Global Sample8
Global Sample9
Global Sample10
Global LastHwnd
Global Button1
Global Button2
Global Button3
Global Button4
Global Button5
Global Button6
Global Button7
Global Button8
Global Button9
Global Button10
Global SamplePressed

SelectAuto()
{
    ReadAutoMechanics()
    Sleep, 100
    Gui, Auto:-Border -Caption
    Gui, Auto:Color, %Background%
    Gui, Auto:Font, c%Font% s5
    Gui, Auto:Add, Text, Section,
    Gui, Auto:Font, c%Font% s13
    AutoMechanicSearch := AutoMechanics()
    For each, Mechanic in StrSplit(AutoMechanicSearch, "|")
    {
        autochecked := % mechanic "Auto"
        autochecked := % %autochecked%
        Gui, Auto:Add, Checkbox, xs v%Mechanic% Checked%autochecked%, %Mechanic%
        Gui, Auto:Font, c%Font% s6
        If (Mechanic = "Metamorph") or (Mechanic = "Ritual")
            {
                FootNote := 2
            }
        Else
            {
                FootNote := 1
            }
        Gui, Auto:Add, Text, x+.5 yp, %FootNote%
        Gui, Auto:Font, c%Font% s13
    }
    Gui, Auto:Font, c%Font% s5
    Gui, Auto:Add, Text, xs Section,
    Gui, Auto:Font, s10
    Gui, Auto:Add, Text, xs +Wrap w250, 1 : to use this Auto Mechanic the corresponding mechanic must be turned on in the "Select Mechanics" menu. You must also have "Output Dialog To Chat" turned on in the games UI Settings panel. 
    Gui, Auto:Font, c%Font% s5
    Gui, Auto:Add, Text, xs Section,
    Gui, Auto:Font, s10
    Gui, Auto:Add, Text, xs +Wrap w250, 2 : to use this Auto Mechanic the corresponding mechanic must be turned on in the "Select Mechanics" menu. You may also need to calibrate the Search Tool by clicking the "Calibrate Search" button when you have it active in game.
    Gui, Auto:Font, c%Font% s5
    Gui, Auto:Add, Text, xs Section,
    Gui, Auto:Font, s10
    Gui, Auto:Add, Button, xs Section w80 h40, Select Mechanics
    Gui, Auto:Add, Button, ys w80 h40, Calibrate Search
    Gui, Auto:Add, Button, ys w80 h40, OK
    Gui, Auto:Font, c%Font% s5
    Gui, Auto:Add, Text, xs Section,
    Gui, Auto:Show, , Auto Enable/Disable (Beta)
    Return
}

AutoButtonOk()
{
    AutoWrite()
    FirstRunPath := FirstRunIni()
    IniRead, Active, %FirstRunPath%, Active, Active
    If (Active = 1)
    {
        FirstRunPath := FirstRunIni()
        Iniwrite, 1, %FirstRunPath%, Completion, AutoMechanic
        FirstRun()
    }
    Return
}

AutoWrite()
{
    Gui, Submit, NoHide 
    AutoMechanicSearch := AutoMechanics()
    MechanicsPath := MechanicsIni()
    For each, Mechanic in StrSplit(AutoMechanicSearch, "|")
    {
        mechanicvalue := % %Mechanic%
        IniWrite, %mechanicvalue%, %MechanicsPath%, Auto Mechanics, %Mechanic%
    }
    Gui, Auto:Destroy
}

AutoButtonSelectMechanics()
{
    AutoWrite()
    SelectMechanics(True)
}

ReadAutoMechanics()
{
    AutoMechanicSearch := AutoMechanics()
    MechanicsPath := MechanicsIni()
    AutoMechanicsActive = 0
    For each, Mechanic in StrSplit(AutoMechanicSearch, "|")
    {
        IniRead, %Mechanic%, %MechanicsPath%, Auto Mechanics, %Mechanic%
        If (%Mechanic% = 1)
        {
            %Mechanic%Auto := 1
            AutoMechanicsActive ++
        }
        Else
        {
            %Mechanic%Auto := 0
        }
    }
    Return
}

AutoMechanics()
{
    Return, "Blight|Expedition|Incursion|Metamorph|Ritual"
}

AutoButtonCalibrateSearch()
{
    Gui, Auto:Destroy
    Gui, Calibrate:Color, %Background%
    Gui, Calibrate:Font, c%Font% s5
    Gui, Calibrate:Add, Text, Section,
    Gui, Calibrate:Font, c%Font% s18
    GuiW := Round(96/A_ScreenDPI*630)
    Gui, Calibrate:Add, Text, Section +Center w%GuiW%, Screen Search Calibration Tool
    Gui, Calibrate:Font, c%Font% s10
    Gui, Calibrate:Add, Text, +Wrap Section w%GuiW%, Note: Calibration may not be necessary for your system, only perform a calibration if auto search doesnt work on your system. Each mechanic has several calibration steps. You'll need to have the mechanic available in each stage to calibrate the stage. The calibrate button will open the "Snipping Tool" on your computer, verify the "Rectanglular Snip" Mode is enabled, press "New" and carefully select a section of your screen similar to the samples shown. Be sure that your screenshot only includes a static image if you have any background (part of your map) it can result in the tool to fail to recognize future instances. Once you are happy with the screenshot close the tool without saving. 
    BoxH := Round(96/A_ScreenDPI*1)
    Gui, Calibrate:Font, s1
    Gui, Calibrate:Add, Text,,
    Gui, Calibrate:Add, GroupBox, +Center x5 w%GuiW% h%BoxH%OpenImage
    Gui, Calibrate:Add, Text,,
    MySearches := MetamorphSearch() "|" RitualSearch()
    MySearches := StrSplit(MySearches, "|")
    LoopCount := MySearches.MaxIndex()
    Gui, Calibrate:Font, c%Font% s12
    Loop, %LoopCount%
        {
            Gui, Calibrate:Add, Text, Section xs, % MySearches[A_Index]
            XBut := Round(96/A_ScreenDPI*425)
            Gui, Calibrate:Add, Button, ys x%XBut% w80 gButton%A_Index%, Calibrate
            Gui, Calibrate:Font, c1177bb Normal Underline 
            XSample := Round(96/A_ScreenDPI*570)
            Gui, Calibrate:Add, Text, ys x+10 w80 HwndSample%A_Index% gOpenImage, Sample
            Gui, Calibrate:Font, c%Font% Normal
        }
    Gui, Calibrate:Add, Text, Section,
    Gui, Calibrate:Show, , Calibration Tool
    OnMessage(0x0200, "MouseMove")
    Return
}

MouseMove(wParam, lParam, Msg, Hwnd) {
    If InStr(A_GuiControl, "Sample") and (SamplePressed != 1)
        {
            MouseGetPos,,,, mHwnd, 2
            If Instr(mHwnd, Sample1) and (mHwnd != LastHwnd)
                {
                    ImageH := 300
                    ImageW := 100
                    ShowImage("MetamorphAssem", ImageH, ImageW)
                    LastHwnd := mHwnd
                }
            If Instr(mHwnd, Sample2) and (mHwnd != LastHwnd)
                {
                    ImageH := 100
                    ImageW := 100
                    ShowImage("MetamorphIcon", ImageH, ImageW)
                    LastHwnd := mHwnd
                }
            If Instr(mHwnd, Sample3) and (mHwnd != LastHwnd)
                {
                    ImageH := 100
                    ImageW := 80
                    ShowImage("RitualCount13", ImageH, ImageW)
                    LastHwnd := mHwnd
                }
            If Instr(mHwnd, Sample4) and (mHwnd != LastHwnd)
                {
                    ImageH := 100
                    ImageW := 80
                    ShowImage("RitualCount23", ImageH, ImageW)
                    LastHwnd := mHwnd
                }
            If Instr(mHwnd, Sample5) and (mHwnd != LastHwnd)
                {
                    ImageH := 100
                    ImageW := 80
                    ShowImage("RitualCount33", ImageH, ImageW)
                    LastHwnd := mHwnd
                }
            If Instr(mHwnd, Sample6) and (mHwnd != LastHwnd)
                {
                    ImageH := 100
                    ImageW := 80
                    ShowImage("RitualCount14", ImageH, ImageW)
                    LastHwnd := mHwnd
                }
            If Instr(mHwnd, Sample7) and (mHwnd != LastHwnd)
                {
                    ImageH := 100
                    ImageW := 80
                    ShowImage("RitualCount24", ImageH, ImageW)
                    LastHwnd := mHwnd
                }
            If Instr(mHwnd, Sample8) and (mHwnd != LastHwnd)
                {
                    ImageH := 100
                    ImageW := 80
                    ShowImage("RitualCount34", ImageH, ImageW)
                    LastHwnd := mHwnd
                }
            If Instr(mHwnd, Sample9) and (mHwnd != LastHwnd)
                {
                    ImageH := 100
                    ImageW := 80
                    ShowImage("RitualCount44", ImageH, ImageW)
                    LastHwnd := mHwnd
                }
            If Instr(mHwnd, Sample10) and (mHwnd != LastHwnd)
                {
                    ImageH := 100
                    ImageW := 100
                    ShowImage("RitualShop", ImageH, ImageW)
                    LastHwnd := mHwnd
                }
        }
    If !InStr(A_GuiControl, "Sample") and (SamplePressed != 1)
        {
            Gui, ImageView:Destroy
            LastHwnd :=
        }
 }
 
ShowImage(SelectedImage, ImageH, ImageW, Caption:= "-Caption")
{
    MouseGetPos, MouseX, MouseY,,,
    WinGetPos, GuiX,, GuiW,, Calibration Tool
    ImgShow := Guix + GuiW
    MouseY := MouseY + 150
    Gui, ImageView:-Border %Caption%
    Gui, ImageView:Color, c1e1e1e
    Gui, ImageView:Add, Picture,w%ImageW% h%ImageH%, Resources\Images\Image Search\%SelectedImage%.png
    Gui, ImageView:Show, x%ImgShow% y%MouseY%,ImageView
    WinSet, TransColor, 1e1e1e 255, ImageView
}

MetamorphSearch()
{
    Return, "Metamorph Assembler|Metamorph Icon"
}

RitualSearch()
{
    Return, "Ritual 1/3|Ritual 2/3|Ritual 3/3|Ritual 1/4|Ritual 2/4|Ritual 3/4|Ritual 4/4|Ritual Shop"
}

OpenImage()
{    
    MouseGetPos,,,, mHwnd, 
    Gui, ImageView:Destroy
    SamplePressed :=
    If Instr(mHwnd, "Static7")
        {
            SamplePressed := 1
            ImageH := 350
            ImageW := 150
            ShowImage("MetamorphAssem", ImageH, ImageW, "+Caption")
            LastHwnd := mHwnd
        }
    If Instr(mHwnd, "Static9")
        {
            SamplePressed := 1
            ImageH := 150
            ImageW := 150
            ShowImage("MetamorphIcon", ImageH, ImageW, "+Caption")
            LastHwnd := mHwnd
        }
    If Instr(mHwnd, "Static11")
        {
            SamplePressed := 1
            ImageH := 150
            ImageW := 130
            ShowImage("RitualCount13", ImageH, ImageW, "+Caption")
            LastHwnd := mHwnd
        }
    If Instr(mHwnd, "Static13")
        {
            SamplePressed := 1
            ImageH := 150
            ImageW := 130
            ShowImage("RitualCount23", ImageH, ImageW, "+Caption")
            LastHwnd := mHwnd
        }
    If Instr(mHwnd, "Static15")
        {
            SamplePressed := 1
            ImageH := 150
            ImageW := 130
            ShowImage("RitualCount33", ImageH, ImageW, "+Caption")
            LastHwnd := mHwnd
        }
    If Instr(mHwnd, "Static17")
        {
            SamplePressed := 1
            ImageH := 150
            ImageW := 130
            ShowImage("RitualCount14", ImageH, ImageW, "+Caption")
            LastHwnd := mHwnd
        }
    If Instr(mHwnd, "Static19")
        {
            SamplePressed := 1
            ImageH := 150
            ImageW := 130
            ShowImage("RitualCount24", ImageH, ImageW, "+Caption")
            LastHwnd := mHwnd
        }
    If Instr(mHwnd, "Static21")
        {
            SamplePressed := 1
            ImageH := 150
            ImageW := 130
            ShowImage("RitualCount34", ImageH, ImageW, "+Caption")
            LastHwnd := mHwnd
        }
    If Instr(mHwnd, "Static23")
        {
            SamplePressed := 1
            ImageH := 150
            ImageW := 130
            ShowImage("RitualCount44", ImageH, ImageW, "+Caption")
            LastHwnd := mHwnd
        }
    If Instr(mHwnd, "Static25")
        {
            SamplePressed := 1
            ImageH := 150
            ImageW := 150
            ShowImage("RitualShop", ImageH, ImageW, "+Caption")
            LastHwnd := mHwnd
        }
}

ImageViewGuiClose()
{
    Gui, ImageView:Destroy
    SamplePressed :=
}

Button1()
{
    FileName := "Resources\Images\Image Search\MetamorphAssem.png"
    ScreenShotTool(FileName)
    GdipTest(Filename)
}

Button2()
{
    FileName := "Resources\Images\Image Search\MetamorphIcon.png"
    ScreenShotTool(FileName)
    GdipTest(Filename)
}

Button3()
{
    FileName := "Resources\Images\Image Search\RitualCount13.png"
    ScreenShotTool(FileName)
    GdipTest(Filename)
}

Button4()
{
    FileName := "Resources\Images\Image Search\RitualCount23.png"
    ScreenShotTool(FileName)
    GdipTest(Filename)
}

Button5()
{
    FileName := "Resources\Images\Image Search\RitualCount33.png"
    ScreenShotTool(FileName)
    GdipTest(Filename)
}

Button6()
{
    FileName := "Resources\Images\Image Search\RitualCount14.png"
    ScreenShotTool(FileName)
    GdipTest(Filename)
}

Button7()
{
    FileName := "Resources\Images\Image Search\RitualCount24.png"
    ScreenShotTool(FileName)
    GdipTest(Filename)
}

Button8()
{
    FileName := "Resources\Images\Image Search\RitualCount34.png"
    ScreenShotTool(FileName)
    GdipTest(Filename)
}

Button9()
{
    FileName := "Resources\Images\Image Search\RitualCount44.png"
    ScreenShotTool(FileName)
    GdipTest(Filename)
}

Button10()
{
    FileName := "Resources\Images\Image Search\RitualShop.png"
    ScreenShotTool(FileName)
    GdipTest(Filename)
}

ScreenShotTool(path)
{
    Gui, Calibrate:Minimize
    Run, SnippingTool
    WinWaitActive, Snipping Tool
    WinWaitClose, Snipping Tool
    snToken := Gdip_Startup()
    ClipWait, , 1
    pBitmap := Gdip_CreateBitmapFromClipboard()
    Gdip_SaveBitmapToFile(pBitmap, path)
    Gdip_DisposeImage(pBitmap)
    Gdip_Shutdown(snToken)
}

GdipTest(FileName)
{
    rnToken := Gdip_Startup()
    Global PngSearch := Gdip_CreateBitmapFromFile(FileName)
    ; Global bmpHaystack := Gdip_BitmapFromScreen() ; For testing purposes
    Global bmpHaystack := Gdip_BitmapFromHWND(PoeHwnd, 1)
    Sleep, 2000
    Loop, 255
        {
            If (Gdip_ImageSearch(bmpHaystack,PngSearch,LIST,,0,0,0,A_Index,0xFFFFFF,1,0) > 0)
                {
                    msgbox, test
                    VariationAmt := A_Index + 10 ; Find matchpoint and add 10 for safety. 
                    Break
                }
        }
        IniTitle := StrSplit(Filename, "\")
        IniTitle := StrSplit(IniTitle[4],".png")
        IniTitle := IniTitle[1]
        ScreenIni := ScreenIni()
        IniWrite, %VariationAmt%, %ScreenIni%, Variation, %IniTitle%
        Gdip_DisposeImage(bmpHaystack)
        Gdip_DisposeImage(PngSearch)
        Gdip_Shutdown(rnToken)
        Return, %VariationAmt%
}
Return