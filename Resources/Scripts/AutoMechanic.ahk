#Include <Gdip_All>
#Include <Gdip_ImageSearch>

Global BlightAuto
Global ExpeditionAuto
Global IncursionAuto
Global RitualAuto
Global UltimatumAuto
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
Global SampleMapDevice
Global Completion
Global Text
Global SampleEaterOn
Global SampleSearingOn
Global SampleMavenOn

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
        If (Mechanic = "Betrayal") or (Mechanic = "Einhar") or (Mechanic = "Niko") ; uses OCR Only
            {
                FootNote := 1
            }   
        If (Mechanic = "Blight") ; Blight uses all 3 mechanics for tracking (Image Recognition, Log reading and OCR)
            {
                FootNote := 2
            }
        If (Mechanic = "Expedition") ; uses log reading only
            {
                FootNote := 3
            }
        If (Mechanic = "Incursion") ; Incursion uses Log reading and OCR
            {
                FootNote := 4
            }
        If (Mechanic = "Ritual") ; uses image recognition and OCR
            {
                FootNote := 5
            }
        If (Mechanic = "Ultimatum") ; uses image recognition and OCR
            {
                FootNote := 3
            }
        If (Mechanic = "Eldritch") ; uses image recognition
            {
                FootNote := 6
            }   
        Gui, Auto:Add, Text, x+.5 yp HwndFootnote%A_Index% gOpenFootnote, %FootNote%
        Gui, Auto:Font
        Gui, Auto:Font, c%Font% s13
    }
    Gui, Auto:Font, c%Font% s5
    Gui, Auto:Add, Text, xs Section,
    Gui, Auto:Font, s10 c%Background%
    Gui, Auto:Add, Text, xs +Wrap w250 vText, 3 : Eldritch refers to Maven, Eater of Worlds and Searing Exarch. The tool will automatically check for whichever is active when the map device is used in your hideout (make sure to keep your hideout updated using the "Set Hideout" tool). You may also need to calibrate the Search Tool by clicking the "Calibrate Search" button when you have it active in game.
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
    Return, "Betrayal|Blight|Einhar|Expedition|Incursion|Niko|Ritual|Ultimatum|Eldritch"
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
    Gui, Calibrate:Add, Text, Section +Center w%GuiW%, Calibration Tool
    Gui, Calibrate:Font, c%Font% s10
    Gui, Calibrate:Add, Text, +Wrap Section w%GuiW%, Note: Calibration may not be necessary for your system, only perform a calibration if auto search doesnt work on your system. Each mechanic has several calibration steps. You'll need to have the mechanic available in each stage to calibrate. Mouse over or click the number next to the name of each calibration item for more information and instructions on how to calibrate. You can also mouse over or click the "Sample" text next to each calibration item for a sample  of what the calibration section should look like. 
    BoxH := Round(96/A_ScreenDPI*1)
    Gui, Calibrate:Font, s1
    Gui, Calibrate:Add, Text,,
    Gui, Calibrate:Add, GroupBox, +Center x5 w%GuiW% h%BoxH%OpenImage
    Gui, Calibrate:Add, Text,,
    MySearches := RitualSearch()
    MySearches := StrSplit(MySearches, "|")
    LoopCount := MySearches.MaxIndex()
    Gui, Calibrate:Font, c%Font% s12
    Gui, Calibrate:Add, Text, Section xs, Quest Tracker Text
    Gui, Calibrate:Font, s8 c1177bb Normal Underline
    Gui, Calibrate:Add, Text, x+.5 yp HwndFootnote1 gOpenFootnote, 1
    Gui, Calibrate:Font
    Gui, Calibrate:Font, cBlack Normal
    Gui, Calibrate:Font, c%Font% s12
    XBut := Round(96/A_ScreenDPI*425)
    Gui, Calibrate:Add, Button, ys x%XBut% w80 gQuestText, Calibrate
    Gui, Calibrate:Font, c1177bb Normal Underline
    XSample := Round(96/A_ScreenDPI*570)
    Gui, Calibrate:Add, Text, ys x+10 w80 HwndSampleQuestText gOpenImage, Sample
    Gui, Calibrate:Font, c%Font% Normal
    Loop, %LoopCount%
    {
        Gui, Calibrate:Add, Text, Section xs, % MySearches[A_Index]
        Gui, Calibrate:Font, s8 c1177bb Normal Underline
        If (MySearches[A_Index] = "Ritual Icon") or (MySearches[A_Index] = "Ritual Shop")
            {
                Footnote := 2
            }
        If (MySearches[A_Index] = "Ritual Text")
            {
                Footnote := 1
            }
        Gui, Calibrate:Add, Text, x+.5 yp HwndFootnote1 gOpenFootnote, %Footnote%
        Gui, Calibrate:Font
        Gui, Calibrate:Font, cBlack Normal
        Gui, Calibrate:Font, c%Font% s12
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
            FootNote := 5
        }
        Else
        {
            FootNote := 3
        }
        Gui, Calibrate:Add, Text, x+.5 yp HwndFootnote%A_Index% gOpenFootnote, %FootNote%
        Gui, Calibrate:Font
        XEdit := Round(96/A_ScreenDPI*325)
        EditOffset := 5
        Gui, Calibrate:Font, cBlack Normal
        Gui, Calibrate:Add, Edit, Center ys+%EditOffset% x%XEdit% h20 w50 v%boss%Var
        Gui, Calibrate:Font, c%Font% s12
        ERange := "0-28"
        If (boss = "Maven")
        {
            ERange := "0-11"
        }
        Gui, Calibrate:Add, UpDown, Range%ERange%, %Value% x270 h20
        XBut := Round(96/A_ScreenDPI*425)
        Gui, Calibrate:Add, Button, ys x%XBut% w80 gButton%boss%, Calibrate
        Gui, Calibrate:Font, c1177bb Normal Underline s12
        XSample := Round(96/A_ScreenDPI*570)
        Gui, Calibrate:Add, Text, ys x+10 w80 HwndSample%boss% g%boss%Image, Sample
        Gui, Calibrate:Font, c%Font% Normal s12

        ;add boss "On" line
        Gui, Calibrate:Add, Text, Section xs, %boss% On
        Gui, Calibrate:Font, s8 c1177bb Normal Underline
        Gui, Calibrate:Add, Text, x+.5 yp HwndFootnote4 gOpenFootnote, 4
        XBut := Round(96/A_ScreenDPI*425)
        Gui, Calibrate:Font, Normal 
        Gui, Calibrate:Font, c%Font% s12
        Gui, Calibrate:Add, Button, ys x%XBut% w80 g%boss%OnButton, Calibrate
        XSample := Round(96/A_ScreenDPI*570)
        Gui, Calibrate:Font, c1177bb Normal Underline s12
        Gui, Calibrate:Add, Text, ys x+10 w80 HwndSample%boss%On g%boss%On, Sample
        Gui, Calibrate:Font, c%Font% Normal
    }
    Gui, Calibrate:Add, Text, Section xs, Map Device
    Gui, Calibrate:Font, s8 c1177bb Normal Underline
    Gui, Calibrate:Add, Text, x+.5 yp HwndFootnote6 gOpenFootnote, 6
    XBut := Round(96/A_ScreenDPI*425)
    Gui, Calibrate:Font, Normal 
    Gui, Calibrate:Font, c%Font% s12
    Gui, Calibrate:Add, Button, ys x%XBut% w80 gMapDeviceButton, Calibrate
    XSample := Round(96/A_ScreenDPI*570)
    Gui, Calibrate:Font, c1177bb Normal Underline s12
    Gui, Calibrate:Add, Text, ys x+10 w80 HwndSampleMapDevice gMapDeviceImage, Sample
    Gui, Calibrate:Font, c%Font% Normal

    Gui, Calibrate:Add, Text, Section,
    Gui, Calibrate:Show, , Calibration Tool
    OnMessage(0x0200, "MouseMove")
    Return
}

CalibrateGuiClose:
{
    Gui, FootnoteView:Destroy
    Gui, ImageView:Destroy
    Gui, Calibrate:Destroy
    ScreenIni := ScreenIni()
    IniWrite, 0, %ScreenIni%, Screen Search Disable, Disable
    If (AutoRun = 1)
    {
        SelectAuto()
        AutoRun :=
    }
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
    If InStr(A_GuiControl, "4") and (NoteSelected != 4)
        {
            NoteSelected := 0
            ViewFootnote(4)
            LastHwnd := mHwnd
            Return
        }
    If InStr(A_GuiControl, "5") and (NoteSelected != 5)
        {
            NoteSelected := 0
            ViewFootnote(5)
            LastHwnd := mHwnd
            Return
        }
    If InStr(A_GuiControl, "6") and (NoteSelected != 6)
        {
            NoteSelected := 0
            ViewFootnote(6)
            LastHwnd := mHwnd
            Return
        }
    If InStr(A_GuiControl, "Sample") and (SamplePressed != 1)
        {
            MouseGetPos,,,, mHwnd, 2
            If Instr(mHwnd, Sample1) and (mHwnd != LastHwnd)
                {
                    ImageH := 100
                    ImageW := 80
                    ShowImage("RitualIcon", ImageH, ImageW)
                    LastHwnd := mHwnd
                }
            If Instr(mHwnd, Sample2) and (mHwnd != LastHwnd)
                {
                    ImageH := 100
                    ImageW := 100
                    ShowImage("RitualText", ImageH, ImageW)
                    LastHwnd := mHwnd
                }
            If Instr(mHwnd, Sample3) and (mHwnd != LastHwnd)
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
                    Gui, Calibrate:Submit, Nohide
                    If (eaterVar =28)
                    {
                        eaterVar := "on"
                        ImageH := 50
                        ImageW := 70
                    }
                    ShowImage("Eldritch/eater" eaterVar, ImageH, ImageW)
                    LastHwnd := mHwnd
                }
            If Instr(mHwnd, SampleSearing) and (mHwnd != LastHwnd)
                {
                    ImageH := 100
                    ImageW := 130
                    Gui, Calibrate:Submit, Nohide
                    If (searingVar =28)
                    {
                        searingVar := "on"
                        ImageH := 50
                        ImageW := 70
                    }
                    ShowImage("Eldritch/searing" searingVar, ImageH, ImageW)
                    LastHwnd := mHwnd
                }
            If Instr(mHwnd, SampleMaven) and (mHwnd != LastHwnd)
                {
                    ImageH := 100
                    ImageW := 130
                    Gui, Calibrate:Submit, Nohide
                    If (mavenVar =11)
                    {
                        mavenVar := "on"
                        ImageH := 70
                        ImageW := 50
                    }
                    ShowImage("Eldritch/maven" mavenVar, ImageH, ImageW)
                    LastHwnd := mHwnd
                }
            If Instr(mHwnd, SampleMapDevice) and (mHwnd != LastHwnd)
                {
                    ImageH := 80
                    ImageW := 250
                    Gui, Calibrate:Submit, Nohide
                    ShowImage("MapDevice", ImageH, ImageW)
                    LastHwnd := mHwnd
                }
            If Instr(mHwnd, SampleSearingOn) and (mHwnd != LastHwnd)
                {
                    ImageH := 50
                    ImageW := 70
                    Gui, Calibrate:Submit, Nohide
                    ShowImage("Eldritch/searingon", ImageH, ImageW)
                    LastHwnd := mHwnd
                }
            If Instr(mHwnd, SampleMavenOn) and (mHwnd != LastHwnd)
                {
                    ImageH := 50
                    ImageW := 70
                    Gui, Calibrate:Submit, Nohide
                    ShowImage("Eldritch/mavenon", ImageH, ImageW)
                    LastHwnd := mHwnd
                }
            If Instr(mHwnd, SampleEaterOn) and (mHwnd != LastHwnd)
                {
                    ImageH := 50
                    ImageW := 70
                    Gui, Calibrate:Submit, Nohide
                    ShowImage("Eldritch/eateron", ImageH, ImageW)
                    LastHwnd := mHwnd
                }
            If Instr(mHwnd, SampleQuestText) and (mHwnd != LastHwnd)
                {
                    ImageH := 100
                    ImageW := 80
                    Gui, Calibrate:Submit, Nohide
                    ShowImage("RitualIcon", ImageH, ImageW) ; update once an image is taken. 
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
    If (GuiTranparent != 0)
    {
        WinSet, TransColor, %Background% 255, ImageView
    }
}

RitualSearch()
{
    Return, "Ritual Icon|Ritual Text|Ritual Shop"
}

OpenImage()
{
    MouseGetPos,,,, mHwnd,
    Gui, ImageView:Destroy
    SamplePressed :=
    If Instr(mHwnd, "Static8")
        {
            SamplePressed := 1
            ImageH := 100
            ImageW := 80
            ShowImage("RitualIcon", ImageH, ImageW,"+Caption")
            LastHwnd := mHwnd
        }
    If Instr(mHwnd, "Static11")
    {
        SamplePressed := 1
        ImageH := 250
        ImageW := 100
        ShowImage("RitualIcon", ImageH, ImageW, "+Caption")
        LastHwnd := mHwnd
    }
    If Instr(mHwnd, "Static14")
        {
            SamplePressed := 1
            ImageH := 180
            ImageW := 100
            ShowImage("RitualText", ImageH, ImageW, "+Caption")
            LastHwnd := mHwnd
        }
    If Instr(mHwnd, "Static17")
    {
        SamplePressed := 1
        ImageH := 190
        ImageW := 150
        ShowImage("RitualShop", ImageH, ImageW, "+Caption")
        LastHwnd := mHwnd
    }
    If Instr(mHwnd, "MapDevice")
    {
        SamplePressed := 1
        ImageH := 150
        ImageW := 250
        ShowImage("MapDevice", ImageH, ImageW, "+Caption")
        LastHwnd := mHwnd
    }
    If Instr(mHwnd, "SampleMavenOn")
        {
            SamplePressed := 1
            ImageH := 50
            ImageW := 70
            ShowImage("Eldritch/mavenon", ImageH, ImageW, "+Caption")
            LastHwnd := mHwnd
        }
    If Instr(mHwnd, "SampleSearingOn")
        {
            SamplePressed := 1
            ImageH := 50
            ImageW := 70
            ShowImage("Eldritch/searingon", ImageH, ImageW, "+Caption")
            LastHwnd := mHwnd
        }
    If Instr(mHwnd, "SampleEaterOn")
        {
            SamplePressed := 1
            ImageH := 50
            ImageW := 70
            ShowImage("Eldritch/eateron", ImageH, ImageW, "+Caption")
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
    FileName := "Resources\Images\Image Search\Custom\RitualIcon.png"
    ScreenShotTool(FileName)
}

Button2()
{
    Gui, Calibrate:Submit, Nohide
    WinMinimize, Calibration Tool
    PostSetup()
    PostMessage, 0x01988,,,, ocr.ahk - AutoHotkey ;Calibrate ritual text search
    PostRestore()
    Return
}

Button3()
{
    FileName := "Resources\Images\Image Search\Custom\RitualShop.png"
    ScreenShotTool(FileName)
}

ScreenShotTool(path)
{
    FileDelete, %path%
    ScreenIni := ScreenIni()
    IniWrite, 1, %ScreenIni%, Screen Search Disable, Disable
    gdipCalibrate := Gdip_Startup()
    Gui, Calibrate:Minimize
    Completion := ""
    Run, SnippingTool
    SetTitleMatchMode, 2
    WinWaitActive, Snipping Tool
    WinWaitClose, Snipping Tool
    ClipWait, , 1
    CalibrateCreate := Gdip_CreateBitmapFromClipboard()
    Gdip_SaveBitmapToFile(CalibrateCreate, path)
    WinActivate, Path of Exile
    WinWaitActive, Path of Exile
    PoeHwnd := WinExist(CWindow)
    Gui, CalibrationNotice:Destroy
    Gui, CalibrationNotice:Color, %Background%
    Gui, CalibrationNotice:Font, c%Font% s10
    Gui, CalibrationNotice:Add, Text,,Performing calibration, please wait... 
    Gui, CalibrationNotice:Add, Text, w200 Center vCompletion, %Completion%
    Gui, CalibrationNotice: +AlwaysOnTop -Border
    Gui, CalibrationNotice:Show, NoActivate, Calibration Notify
    MapTransparency := TransparencyCheck("Quick")
    WinSet, Style, %ShowTitle%, Calibration Notify
    WinSet, Transparent, %MapTransparency%, Calibration Notify
    Sleep, 2000
    Global CaliHaystack := Gdip_BitmapFromHWND(PoeHwnd, 1)
    Global CaliNeedle := Gdip_CreateBitmapFromFile(path)
    Loop, 201
    {
        Completion := Round(A_Index/201*100) "%" 
        GuiControl, CalibrationNotice:, Completion, %Completion%
        If (Gdip_ImageSearch(CaliHaystack,CaliNeedle,LIST,0,0,0,0,A_Index,,1,0) > 0)
        {
            Global VariationAmt := A_Index + 15 ; Find matchpoint and add 15 for safety.
            ; msgbox, Success! Your new calibration value is %A_Index%
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
        Gdip_DisposeImage(CaliNeedle)
        DeleteObject(CaliNeedle)
        DeleteObject(ErrorLevel)
    }
    Gui, CalibrationNotice:Destroy
    IniTitle := StrSplit(path, "\")
    IniTitle := StrSplit(IniTitle[4],".png")
    IniTitle := IniTitle[1]
    ScreenIni := ScreenIni()
    If (VariationAmt < 50)
    {
        VariationAmt := 50
    }
    IniWrite, %VariationAmt%, %ScreenIni%, Variation, %IniTitle%
    IniWrite, 0, %ScreenIni%, Screen Search Disable, Disable
    Gdip_DisposeImage(CaliHaystack)
    Gdip_DisposeImage(CaliNeedle)
    Gdip_DisposeImage(CalibrateCreate)
    Gdip_Shutdown(gdipCalibrate)
    DeleteObject(CalibrateCreate)
    DeleteObject(CaliHaystack)
    DeleteObject(CaliNeedle)
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
        SamplePressed := 1
        ViewFootnote(3)
    }
    If InStr(A_GuiControl, "4")
        {
            NoteSelected := 4
            SamplePressed := 1
            ViewFootnote(4)
        }
    If InStr(A_GuiControl, "5")
        {
            NoteSelected := 5
            SamplePressed := 1
            ViewFootnote(5)
        }
    If InStr(A_GuiControl, "6")
        {
            NoteSelected := 6
            SamplePressed := 1
            ViewFootnote(6)
        }
}

ViewFootnote(FootnoteNum)
{
    If (FootnoteNum = 1)
    {
        If WinActive("Calibration Tool")
        {
            CustomText := "Upon selecting ""Calibrate"" the Calibration Tool Menu will minimize, simply click and drag (a yellow box should appear as you drag) the area you want to use as the ""Calibrated"" area. It's recommended to select a larger area than may seem necessary to make sure that the text is completely captured. Calibration shouldn't be necessary but can help to make the tool slightly more efficient."
            Caption := "-Caption"
            If (SamplePressed = 1)
            {
                Caption := "+Caption"
            }
            ShowImage("", 0, 0, Caption, CustomText,0)
        }
        Else
        {
            GuiControl, Auto:, Text, 1: This mechanic uses OCR to read text on your screen and recongize when certain mechanics are active in your maps. To use it you must have "Quest Tracking" enabled in the game settings and the corresponding mechanic must be turned on in the "Select Mechanics" menu. Setting the OCR Zone is available in the Calibration Tool but should not be necessary. 
            Gui, Auto:Font, c%Font% s10
            GuiControl, Font, Text
            SamplePressed := 0
        }
    }
    If (FootnoteNum = 2)
    {
        If WinActive("Calibration Tool")
        {
            CustomText := "The calibrate button will open the ""Snipping Tool"" on your computer, verify the ""Rectangular Snip"" Mode is enabled, press ""New"" and carefully select a section of your screen similar to the samples shown. Be sure that your screenshot only includes a static image, if you have any background (part of your map) it can result in the tool to failing to recognize future instances. Once you are happy with the screenshot close the tool without saving."
            Caption := "-Caption"
            If (SamplePressed = 1)
            {
                Caption := "+Caption"
            }
            ShowImage("", 0, 0, Caption, CustomText,0)
        }
        Else
        {
            GuiControl, Auto:, Text, 2: this Auto Mechanic uses a combination of Image Recognition and reading the client log to detect its status. To use this Auto Mechanic the corresponding mechanic must be turned on in the "Select Mechanics" menu. You may also need to calibrate the Search Tool by clicking the "Calibrate Search" button when you have it active in game and you must also have "Output Dialog To Chat" turned on in the games UI Settings panel.
            Gui, Auto:Font, c%Font% s10
            GuiControl, Font, Text
            SamplePressed := 0
        }
    }
    If (FootnoteNum = 3)
        {
            If WinActive("Calibration Tool")
            {
                CustomText := "To calibrate first select the stage (0-27) you want to calibrate then press the calibrate button. The calibrate button will open the ""Snipping Tool"" on your computer, verify the ""Rectangular Snip"" Mode is enabled, press ""New"" and carefully select a section of your screen similar to the samples shown. When calibrating it`'s important to not capture any surrounding elements (the map device background is fine) to avoid issues."
                
                Caption := "-Caption"
                If (SamplePressed = 1)
                {
                    Caption := "+Caption"
                }
                ShowImage("", 0, 0, Caption, CustomText,0)
            }
            Else
            {
                GuiControl, Auto:, Text, 3: to use this Auto Mechanic the corresponding mechanic must be turned on in the "Select Mechanics" menu. You must also have "Output Dialog To Chat" turned on in the games UI Settings panel.
                Gui, Auto:Font, c%Font% s10
                GuiControl, Font, Text
                SamplePressed := 0
            }
        }
    If (FootnoteNum = 4)
        {
            If WinActive("Calibration Tool")
                {
                    CustomText := "The Eldritch ""On"" search function is used to determine which boss is selected for your mapping influence. When active it will auto switch between the three mechanics as necessary. The calibrate button will open the ""Snipping Tool"" on your computer, verify the ""Rectangular Snip"" Mode is enabled, press ""New"" and carefully select a section of your screen similar to the samples shown. When calibrating auto switching it`'s important not to select any of the ring area around the logo as it will throw off the ability of the screen recognition to work if filled in."
                    Caption := "-Caption"
                    If (SamplePressed = 1)
                    {
                        Caption := "+Caption"
                    }
                    ShowImage("", 0, 0, Caption, CustomText,0)
                }
                Else
                {
                    GuiControl, Auto:, Text, 4: This Auto Mechanic uses a combination of reading the client log and OCR to detect its status. To use it the corresponding mechanic must be turned on in the "Select Mechanics" menu. You must also have "Output Dialog To Chat" and "Quest Tracking" turned on in the games UI Settings panel and . The OCR "Zone" can be set in the Calibration Tool but should not be necessary. 

                    Gui, Auto:Font, c%Font% s10
                    GuiControl, Font, Text
                }
        }
    If (FootnoteNum = 5)
        {
            If WinActive("Calibration Tool")
                {
                    CustomText := "To calibrate first select the stage (0-10) you want to calibrate followed by the calibrate button. The calibrate button will open the ""Snipping Tool"" on your computer, verify the ""Rectangular Snip"" Mode is enabled, press ""New"" and carefully select a section of your screen similar to the samples shown. When calibrating it`'s important to not capture any surrounding elements (the map device background is fine) to avoid issues."
                    Caption := "-Caption"
                    If (SamplePressed = 1)
                    {
                        Caption := "+Caption"
                    }
                    ShowImage("", 0, 0, Caption, CustomText,0)
                }
            Else
                {
                    GuiControl, Auto:, Text, 5: This Auto Mechanic uses a combination of Image Recognition and OCR to track the mechanic status. To use it you may need to calibrate the Search Tool by clicking the "Calibrate Search" button when you have it active in game. Configuration of the OCR "Zone" should not be necessary but is also possible in the Calibration Tool. 
                    Gui, Auto:Font, c%Font% s10
                    GuiControl, Font, Text
                }
        }
    If (FootnoteNum = 6)
        {
            If WinActive("Calibration Tool")
                {
                    CustomText := "The Map Device is used for identifying when the map device is open to activate the Master Mapping tool. The calibrate button will open the ""Snipping Tool"" on your computer, verify the ""Rectangular Snip"" Mode is enabled, press ""New"" and carefully select a section of your screen similar to the samples shown. To calibrate select the ""Map Receptacle""  text and the surrounding box, it`'s important not to select any of the Kirac mods below or your hideout in the background as this may cause issues with screen recognition."
                    Caption := "-Caption"
                    If (SamplePressed = 1)
                    {
                        Caption := "+Caption"
                    }
                    ShowImage("", 0, 0, Caption, CustomText,0)
                }
            Else
                {
                    GuiControl, Auto:, Text, 6: Eldritch refers to Maven, Eater of Worlds and Searing Exarch. The tool will automatically check for whichever is active when the map device is,used in your hideout (make sure to keep your hideout updated using the "Set Hideout" tool) You may also need to calibrate the Search Tool by clicking the "Calibrate Search" button when you have it active in game.
                    Gui, Auto:Font, c%Font% s10
                    GuiControl, Font, Text
                }
        }
}

ButtonEater()
{
    Gui, Calibrate:Submit, Nohide
    FileName := "Resources\Images\Image Search\Eldritch\Custom\eater" eaterVar ".png"
    ScreenShotTool(FileName)
}

ButtonSearing()
{
    Gui, Calibrate:Submit, Nohide
    FileName := "Resources\Images\Image Search\Eldritch\Custom\searing" searingVar ".png"
    ScreenShotTool(FileName)
}

ButtonMaven()
{
    Gui, Calibrate:Submit, Nohide
    FileName := "Resources\Images\Image Search\Eldritch\Custom\maven" mavenVar ".png"
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

MapDeviceImage()
{
    MouseGetPos,,,, mHwnd,
    Gui, ImageView:Destroy
    SamplePressed := 1
    ImageH := 130
    ImageW := 250
    ShowImage("MapDevice", ImageH, ImageW, "+Caption")
    LastHwnd := mHwnd
    Return
}

MapDeviceButton()
{
    Gui, Calibrate:Submit, Nohide
    FileName := "Resources\Images\Image Search\Custom\MapDevice.png"
    ScreenShotTool(FileName)
    Return
}

EaterOn()
{
    MouseGetPos,,,, mHwnd,
    Gui, ImageView:Destroy
    SamplePressed := 1
    ImageH := 70
    ImageW := 80
    ShowImage("Eldritch\eateron", ImageH, ImageW, "+Caption")
    LastHwnd := mHwnd
    Return
}

SearingOn()
{
    MouseGetPos,,,, mHwnd,
    Gui, ImageView:Destroy
    SamplePressed := 1
    ImageH := 70
    ImageW := 80
    ShowImage("Eldritch\searingon", ImageH, ImageW, "+Caption")
    LastHwnd := mHwnd
    Return
}

MavenOn()
{
    MouseGetPos,,,, mHwnd,
    Gui, ImageView:Destroy
    SamplePressed := 1
    ImageH := 70
    ImageW := 80
    ShowImage("Eldritch\mavenon", ImageH, ImageW, "+Caption")
    LastHwnd := mHwnd
    Return
}

EaterOnButton()
{
    Gui, Calibrate:Submit, Nohide
    FileName := "Resources\Images\Image Search\Eldritch\Custom\eateron.png"
    ScreenShotTool(FileName)
    Return
}

SearingOnButton()
{
    Gui, Calibrate:Submit, Nohide
    FileName := "Resources\Images\Image Search\Eldritch\Custom\searingon.png"
    ScreenShotTool(FileName)
    Return
}

MavenOnButton()
{
    Gui, Calibrate:Submit, Nohide
    FileName := "Resources\Images\Image Search\Eldritch\Custom\mavenon.png"
    ScreenShotTool(FileName)
    Return
}

QuestText()
{
    Gui, Calibrate:Submit, Nohide
    WinMinimize, Calibration Tool
    PostSetup()
    PostMessage, 0x01987,,,, ocr.ahk - AutoHotkey ; Calibrate quest tracker text search
    PostRestore()
    Return
}