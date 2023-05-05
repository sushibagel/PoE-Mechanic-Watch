Global BlightAuto
Global ExpeditionAuto 
Global IncursionAuto
Global MetamorphAuto
Global RitualAuto
Global AutoMechanicSearch

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
    GuiW := Round(96/A_ScreenDPI*600)
    Gui, Calibrate:Add, Text, Section +Center w%GuiW%, Screen Search Calibration Tool
    Gui, Calibrate:Font, c%Font% s9
    Gui, Calibrate:Add, Text, +Wrap Section w%GuiW%, Note: Calibration may not be necessary for your system, only perform a calibration if auto search doesnt work on your system. Each mechanic has several calibration steps. You'll need to have the mechanic available in each stage to calibrate the stage. The calibrate button will enable screenshot mode, carefully select a section of your screen similar to the samples shown. Be sure that your screenshot only includes a static image if you have any background (part of your map) it can result in the tool to fail to recognize future instances.
    BoxH := Round(96/A_ScreenDPI*1)
    Gui, Calibrate:Font, s1
    Gui, Calibrate:Add, Text,,
    Gui, Calibrate:Add, GroupBox, +Center x5 w%GuiW% h%BoxH%
    Gui, Calibrate:Add, Text,,
    MySearches := MetamorphSearch() "|" RitualSearch()
    MySearches := StrSplit(MySearches, "|")
    LoopCount := MySearches.MaxIndex()
    Gui, Calibrate:Font, c%Font% s12
    Loop, %LoopCount%
        {
            Gui, Calibrate:Add, Text, Section xs, % MySearches[A_Index]
            XBut := Round(96/A_ScreenDPI*425)
            Gui, Calibrate:Add, Button, ys x%XBut% w80, Calibrate
            Gui, Calibrate:Font, c1177bb Normal Underline 
            XSample := Round(96/A_ScreenDPI*570)
            Gui, Calibrate:Add, Picture,ys x+10 w53 h30
            Gui, Calibrate:Add, Text, yp+5 w80 Hwnd%A_Index% gOpenImage, Sample
            Gui, Calibrate:Font, c%Font% Normal
        }
    Gui, Calibrate:Add, Text, Section gOpenImage vtest, Sample
    Gui, Calibrate:Show, , Calibration Tool
    OnMessage(0x0200, "MouseMove")
    Return
}
Global test
MouseMove(wParam, lParam, Msg, Hwnd) {
    If InStr(A_GuiControl, "Sample")
        {
            Gui, Calibrate:Submit, nohide
            MouseGetPos,,,, mHwnd, 2
            GuiControlGet, GuiCtrl,,%A_GuiControl%
            ; if (mHwnd = MyEditHwnd)
            GuiControlGet, Var, Name, %A_GuiControl%
            ToolTip,  %Hwnd% | %mHwnd% | %GuiCtrl% | %test%
        }
    If !InStr(A_GuiControl, "Sample")
        {
            ToolTip
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
    msgbox, test
}