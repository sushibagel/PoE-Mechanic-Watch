#Include <Gdip_All>
#Include <Gdip_ImageSearch>

Global BlightAuto
Global ExpeditionAuto 
Global IncursionAuto
Global MetamorphAuto
Global RitualAuto
Global EldritchAuto
Global Eldritch
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
Global CWindow
Global NoteSelected
Global EaterVar
Global SearingVar
Global MavenVar
Global SampleEater
Global SampleSearing
Global SampleMaven

GroupAdd, PoeScreen, ahk_exe PathOfExileSteam.exe
GroupAdd, PoeScreen, ahk_exe PathOfExile.exe 
GroupAdd, PoeScreen, ahk_exe PathOfExileEGS.exe
GroupAdd, PoeScreen, ahk_class POEWindowClass

SelectAuto()
{
    Gui, Auto:Destroy
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
        Gui, Auto:Font, s8 c1177bb Normal Underline 
        If (Mechanic = "Eldritch")
            {
                FootNote := 3
            }
        If (Mechanic = "Metamorph") or (Mechanic = "Ritual")
            {
                FootNote := 2
            }
        If (Mechanic = "Blight") or (Mechanic = "Expedition") or (Mechanic = "Incursion")
            {
                FootNote := 1
            }
        Gui, Auto:Add, Text, x+.5 yp HwndFootnote%A_Index% gOpenFootnote, %FootNote%
        Gui, Auto:Font
        Gui, Auto:Font, c%Font% s13
    }
    Gui, Auto:Font, c%Font% s5
    Gui, Auto:Add, Text, xs Section,
    Gui, Auto:Font, s10 c%Background%
    Gui, Auto:Add, Text, xs +Wrap w250 vText, 3 : Eldritch refers to Maven, Eater of Worlds and Searing Exarch. The tool will automatically check for whichever is active when the map device is,used in your hideout (make sure to keep your hideout updated using the "Set Hideout" tool) You may also need to calibrate the Search Tool by clicking the "Calibrate Search" button when you have it active in game.
    Gui, Auto:Font, c%Font% s5
    Gui, Auto:Font, c%Font% s5
    Gui, Auto:Add, Text, xs Section,
    Gui, Auto:Font, s10
    Gui, Auto:Add, Button, xs Section w80 h40, Select Mechanics
    Gui, Auto:Add, Button, ys w80 h40, Calibrate Search
    Gui, Auto:Add, Button, ys w80 h40, OK
    Gui, Auto:Font, c%Font% s5
    Gui, Auto:Add, Text, xs Section,
    Gui, Auto:Show, , Auto Enable/Disable (Beta)
    OnMessage(0x0200, "MouseMove")
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
    ReloadScreenSearch()
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
    Return, "Blight|Expedition|Incursion|Metamorph|Ritual|Eldritch"
}

AutoButtonCalibrateSearch()
{
    Gui, Auto:Destroy
    Gui, Calibrate:Destroy
    Gui, Calibrate:Color, %Background%
    Gui, Calibrate:Font, c%Font% s5
    Gui, Calibrate:Add, Text, Section,
    Gui, Calibrate:Font, c%Font% s18
    GuiW := Round(96/A_ScreenDPI*630)
    Gui, Calibrate:Add, Text, Section +Center w%GuiW%, Screen Search Calibration Tool
    Gui, Calibrate:Font, c%Font% s10
    Gui, Calibrate:Add, Text, +Wrap Section w%GuiW%, Note: Calibration may not be necessary for your system, only perform a calibration if auto search doesnt work on your system. Each mechanic has several calibration steps. You'll need to have the mechanic available in each stage to calibrate the stage. The calibrate button will open the "Snipping Tool" on your computer, verify the "Rectangular Snip" Mode is enabled, press "New" and carefully select a section of your screen similar to the samples shown. Be sure that your screenshot only includes a static image, if you have any background (part of your map) it can result in the tool to failing to recognize future instances. Once you are happy with the screenshot close the tool without saving. 
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
    Influences := Influences()
    For each, boss in StrSplit(Influences, "|")
        {
            Gui, Calibrate:Add, Text, Section xs, %boss%
            Gui, Calibrate:Font, s8 c1177bb Normal Underline 
            If (boss = "Maven")
                {
                    FootNote := 2
                }
            Else
                {
                    FootNote := 1  
                }
            Gui, Calibrate:Add, Text, x+.5 yp HwndFootnote%A_Index% gOpenFootnote, %FootNote%
            Gui, Calibrate:Font
            XEdit := Round(96/A_ScreenDPI*325)
            EditOffset := 5
            Gui, Calibrate:Font, cBlack Normal
            Gui, Calibrate:Add, Edit, Center ys+%EditOffset% x%XEdit% h20 w50 v%boss%Var
            Gui, Calibrate:Font, c%Font% s12
            ERange := "0-27"
            If (boss = "Maven")
                {
                    ERange := "0-10"
                }
            Gui, Calibrate:Add, UpDown, Range%ERange%, %Value% x270 h20 
            XBut := Round(96/A_ScreenDPI*425)
            Gui, Calibrate:Add, Button, ys x%XBut% w80 gButton%boss%, Calibrate
            Gui, Calibrate:Font, c1177bb Normal Underline 
            XSample := Round(96/A_ScreenDPI*570)
            Gui, Calibrate:Add, Text, ys x+10 w80 HwndSample%boss% g%boss%Image, Sample
            Gui, Calibrate:Font, c%Font% Normal
        }
    Gui, Calibrate:Add, Text, Section,
    Gui, Calibrate:Show, , Calibration Tool
    OnMessage(0x0200, "MouseMove")
    Return
}

MouseMove(wParam, lParam, Msg, Hwnd) {
    MouseGetPos,,,, mHwnd, 2
    If InStr(A_GuiControl, "1") and (NoteSelected != 1)
        {
            NoteSelected := 0
            ViewFootnote(1)
            LastHwnd := mHwnd
            Return
        }
    If InStr(A_GuiControl, "2") and (NoteSelected != 2)
        {
            NoteSelected := 0
            ViewFootnote(2)
            LastHwnd := mHwnd
            Return
        }
    If InStr(A_GuiControl, "3") and (NoteSelected != 3)
        {
            NoteSelected := 0
            ViewFootnote(3)
            LastHwnd := mHwnd
            Return
        }
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
            If Instr(mHwnd, SampleEater) and (mHwnd != LastHwnd)
                {
                    ImageH := 100
                    ImageW := 130
                    ShowImage("Eldritch/eater5", ImageH, ImageW)
                    LastHwnd := mHwnd
                }
            If Instr(mHwnd, SampleSearing) and (mHwnd != LastHwnd)
                {
                    ImageH := 100
                    ImageW := 130
                    ShowImage("Eldritch/searing5", ImageH, ImageW)
                    LastHwnd := mHwnd
                }
            If Instr(mHwnd, SampleMaven) and (mHwnd != LastHwnd)
                {
                    ImageH := 100
                    ImageW := 130
                    ShowImage("Eldritch/maven5", ImageH, ImageW)
                    LastHwnd := mHwnd
                }
        }
    If !InStr(A_GuiControl, "Sample") and (SamplePressed != 1)
        {
            Gui, ImageView:Destroy
            LastHwnd :=
        }
    If !InStr(A_GuiControl, "1") and !InStr(A_GuiControl, "2") and !InStr(A_GuiControl, "3") and (NoteSelected !>= 1)
        {
            GuiControl, Auto:, Text,
            Gui, FootnoteView:Destroy
            LastHwnd :=
        }
 }
 
ShowImage(SelectedImage, ImageH, ImageW, Caption:= "-Caption", CustomText := "", GuiTranparent := 1)
{
    MouseGetPos, MouseX, MouseY,,,
    WinGetPos, GuiX,, GuiW,, Calibration Tool
    ImgShow := Guix + GuiW
    MouseY := MouseY + 150
    Gui, ImageView: %Caption%
    Gui, ImageView:Color, %Background%
    Gui, ImageView:Add, Picture,w%ImageW% h%ImageH%, Resources\Images\Image Search\%SelectedImage%.png
    Gui, ImageView:Font, c%Font% s10
    If (CustomText != "")
        {
           Gui, ImageView:Add, Text, w200 +Wrap , %CustomText%
           CustomText :=
           Gui, ImageView:Add, Text, w200 +Wrap ,
        }
    WinGetPos,,,, winHeight, Calibration Tool
    winHeight := (A_ScreenHeight/2) - (ImageH/2)
    Gui, ImageView:Show, x%ImgShow% y%winHeight%,ImageView
    If (GuiTranparent  != 0)
        {
            WinSet, TransColor, %Background% 255, ImageView
        }
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
            ImageH := 300
            ImageW := 100
            ShowImage("MetamorphAssem", ImageH, ImageW, "+Caption")
            LastHwnd := mHwnd
        }
    If Instr(mHwnd, "Static9")
        {
            SamplePressed := 1
            ImageH := 100
            ImageW := 100
            ShowImage("MetamorphIcon", ImageH, ImageW, "+Caption")
            LastHwnd := mHwnd
        }
    If Instr(mHwnd, "Static11")
        {
            SamplePressed := 1
            ImageH := 100
            ImageW := 80
            ShowImage("RitualCount13", ImageH, ImageW, "+Caption")
            LastHwnd := mHwnd
        }
    If Instr(mHwnd, "Static13")
        {
            SamplePressed := 1
            ImageH := 100
            ImageW := 80
            ShowImage("RitualCount23", ImageH, ImageW, "+Caption")
            LastHwnd := mHwnd
        }
    If Instr(mHwnd, "Static15")
        {
            SamplePressed := 1
            ImageH := 100
            ImageW := 80
            ShowImage("RitualCount33", ImageH, ImageW, "+Caption")
            LastHwnd := mHwnd
        }
    If Instr(mHwnd, "Static17")
        {
            SamplePressed := 1
            ImageH := 100
            ImageW := 80
            ShowImage("RitualCount14", ImageH, ImageW, "+Caption")
            LastHwnd := mHwnd
        }
    If Instr(mHwnd, "Static19")
        {
            SamplePressed := 1
            ImageH := 100
            ImageW := 80
            ShowImage("RitualCount24", ImageH, ImageW, "+Caption")
            LastHwnd := mHwnd
        }
    If Instr(mHwnd, "Static21")
        {
            SamplePressed := 1
            ImageH := 100
            ImageW := 80
            ShowImage("RitualCount34", ImageH, ImageW, "+Caption")
            LastHwnd := mHwnd
        }
    If Instr(mHwnd, "Static23")
        {
            SamplePressed := 1
            ImageH := 100
            ImageW := 80
            ShowImage("RitualCount44", ImageH, ImageW, "+Caption")
            LastHwnd := mHwnd
        }
    If Instr(mHwnd, "Static25")
        {
            SamplePressed := 1
            ImageH := 100
            ImageW := 100
            ShowImage("RitualShop", ImageH, ImageW, "+Caption")
            LastHwnd := mHwnd
        }
}

ImageViewGuiClose()
{
    Gui, ImageView:Destroy
    SamplePressed :=
    NoteSelected :=
}

Button1()
{
    FileName := "Resources\Images\Image Search\MetamorphAssem.png"
    ScreenShotTool(FileName)
}

Button2()
{
    FileName := "Resources\Images\Image Search\MetamorphIcon.png"
    ScreenShotTool(FileName)
}

Button3()
{
    FileName := "Resources\Images\Image Search\RitualCount13.png"
    ScreenShotTool(FileName)
}

Button4()
{
    FileName := "Resources\Images\Image Search\RitualCount23.png"
    ScreenShotTool(FileName)
}

Button5()
{
    FileName := "Resources\Images\Image Search\RitualCount33.png"
    ScreenShotTool(FileName)
}

Button6()
{
    FileName := "Resources\Images\Image Search\RitualCount14.png"
    ScreenShotTool(FileName)
}

Button7()
{
    FileName := "Resources\Images\Image Search\RitualCount24.png"
    ScreenShotTool(FileName)
}

Button8()
{
    FileName := "Resources\Images\Image Search\RitualCount34.png"
    ScreenShotTool(FileName)
}

Button9()
{
    FileName := "Resources\Images\Image Search\RitualCount44.png"
    ScreenShotTool(FileName)
}

Button10()
{
    FileName := "Resources\Images\Image Search\RitualShop.png"
    ScreenShotTool(FileName)
}

ScreenShotTool(path)
{
    Gui, Calibrate:Minimize
    Run, SnippingTool
    SetTitleMatchMode, 2
    WinWaitActive, Snipping Tool
    WinWaitClose, Snipping Tool
    WinGetActiveTitle, CWindow
    snToken := Gdip_Startup()
    ClipWait, , 1
    pBitmap := Gdip_CreateBitmapFromClipboard()
    Gdip_SaveBitmapToFile(pBitmap, path)
    WinActivate, %CWindow%
    WinWaitActive, %CWindow%
    PoeHwnd := WinExist(CWindow)
    Gui, CalibrationNotice:Destroy
    Gui, CalibrationNotice:Color, %Background%
    Gui, CalibrationNotice:Font, c%Font% s10
    Gui, CalibrationNotice:Add, Text,,Performing calibration, please wait...
    Gui, CalibrationNotice: +AlwaysOnTop -Border
    Gui, CalibrationNotice:Show, NoActivate, Calibration Notify
    MapTransparency := TransparencyCheck("Quick")
    WinSet, Style,  %ShowTitle%, Calibration Notify
    WinSet, Transparent, %MapTransparency%, Calibration Notify
    Sleep, 2000
    Global bmpHaystack := Gdip_BitmapFromHWND(PoeHwnd, 1)
    Global bmpNeedle := Gdip_CreateBitmapFromFile(path)
    Loop, 201
        {
            If (Gdip_ImageSearch(bmpHaystack,bmpNeedle,LIST,0,0,0,0,A_Index,0xFFFFFF,1,0) > 0)
                {
                    Global VariationAmt := A_Index + 10 ; Find matchpoint and add 10 for safety. 
                    Break
                }
                Else
                    {
                        If (A_Index = 201) 
                            {
                                Gui, CalibrationNotice:Destroy
                                Msgbox, Calibration failed. Try again. 
                            }
                    }
        }
        Gui, CalibrationNotice:Destroy
        IniTitle := StrSplit(path, "\")
        IniTitle := StrSplit(IniTitle[4],".png")
        IniTitle := IniTitle[1]
        ScreenIni := ScreenIni()
        If (VariationAmt < 30)
            {
                VariationAmt := 30
            }
        IniWrite, %VariationAmt%, %ScreenIni%, Variation, %IniTitle%
        Gdip_DisposeImage(bmpHaystack)
        Gdip_DisposeImage(bmpNeedle)
        Gdip_DisposeImage(pBitmap)
        Gdip_Shutdown(rnToken)
        DeleteObject(pBitmap)
        DeleteObject(bmpHaystack)
        DeleteObject(bmpNeedle)
        DeleteObject(ErrorLevel)
}

ReloadScreenSearch()
{
    Run, %A_ScriptDir%\Resources\Scripts\ScreenSearch.ahk
}
Return

OpenFootnote()
{    
    MouseGetPos,,,, mHwnd, 
    If InStr(A_GuiControl, "1")
        {
            NoteSelected := 1
            SamplePressed := 1
            ViewFootnote(1)
        }
    If InStr(A_GuiControl, "2")
        {
            NoteSelected := 2
            SamplePressed := 1
            ViewFootnote(2)
        }
    If InStr(A_GuiControl, "3")
        {
            NoteSelected := 3
            ViewFootnote(3)
        }
}

ViewFootnote(FootnoteNum)
{
    If (FootnoteNum = 1)
    {            
        If WinActive("Calibration Tool")
            {
                CustomText := "To calibrate first select the stage (0-27) you want to calibrate followed by the calibrate button. Note: To calibrate auto switching use 28. When calibrating auto switching its important not to select any of the ring area around the logo as it will throw off the ability of the screen recognition to work if filled in."
                Caption := "-Caption"
                If (SamplePressed = 1)
                    {
                        Caption := "+Caption"
                    }
                ShowImage("", 0, 0, Caption, CustomText,0)
            }
        Else
            {
                GuiControl, Auto:, Text, 1: to use this Auto Mechanic the corresponding mechanic must be turned on in the "Select Mechanics" menu. You must also have "Output Dialog To Chat" turned on in the games UI Settings panel.
                Gui, Auto:Font, c%Font% s10
                GuiControl, Font, Text
                SamplePressed := 0
            }
    }
    If (FootnoteNum = 2)
        {
            If WinActive("Calibration Tool")
                {
                    CustomText := "To calibrate first select the stage (0-10) you want to calibrate followed by the calibrate button. Note: To calibrate auto switching use 11. When calibrating auto switching its important not to select any of the ring area around the logo as it will throw off the ability of the screen recognition to work if filled in."
                    Caption := "-Caption"
                    If (SamplePressed = 1)
                        {
                            Caption := "+Caption"
                        }
                    ShowImage("", 0, 0, Caption, CustomText,0)
                }
            Else
                {
                    GuiControl, Auto:, Text, 2: to use this Auto Mechanic the corresponding mechanic must be turned on in the "Select Mechanics" menu. You may also need to calibrate the Search Tool by clicking the "Calibrate Search" button when you have it active in game.
                    Gui, Auto:Font, c%Font% s10
                    GuiControl, Font, Text
                    SamplePressed := 0
                }
        }
    If (FootnoteNum = 3)
        {
            GuiControl, Auto:, Text, 3: Eldritch refers to Maven, Eater of Worlds and Searing Exarch. The tool will automatically check for whichever is active when the map device is,used in your hideout (make sure to keep your hideout updated using the "Set Hideout" tool) You may also need to calibrate the Search Tool by clicking the "Calibrate Search" button when you have it active in game.
            Gui, Auto:Font, c%Font% s10
            GuiControl, Font, Text
        }
}

ButtonEater()
{
    Gui, Calibrate:Submit, Nohide
    FileName := "Resources\Images\Image Search\Eldritch\eater" eaterVar ".png"
    ScreenShotTool(FileName)
}

ButtonSearing()
{
    Gui, Calibrate:Submit, Nohide
    FileName := "Resources\Images\Image Search\Eldritch\searing" searingVar ".png"
    ScreenShotTool(FileName)
}

ButtonMaven()
{
    Gui, Calibrate:Submit, Nohide
    FileName := "Resources\Images\Image Search\Eldritch\maven" mavenVar ".png"
    ScreenShotTool(FileName)
}

EaterImage()
{
    MouseGetPos,,,, mHwnd, 
    Gui, ImageView:Destroy
    SamplePressed := 1
    ImageH := 100
    ImageW := 130
    ShowImage("Eldritch\eater5", ImageH, ImageW, "+Caption")
    LastHwnd := mHwnd
}

SearingImage()
{
    MouseGetPos,,,, mHwnd, 
    Gui, ImageView:Destroy
    SamplePressed := 1
    ImageH := 100
    ImageW := 130
    ShowImage("Eldritch\searing5", ImageH, ImageW, "+Caption")
    LastHwnd := mHwnd
}

MavenImage()
{
    MouseGetPos,,,, mHwnd, 
    Gui, ImageView:Destroy
    SamplePressed := 1
    ImageH := 100
    ImageW := 130
    ShowImage("Eldritch\maven5", ImageH, ImageW, "+Caption")
    LastHwnd := mHwnd
}