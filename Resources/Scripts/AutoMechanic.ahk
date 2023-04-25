Global BlightAuto
Global ExpeditionAuto 
Global IncursionAuto
Global AutoMechanicSearch

SelectAuto()
{
    ReadAutoMechanics()
    Sleep, 100
    Gui, Auto:-Border -Caption
    Gui, Auto:Color, %Background%
    Gui, Auto:Font, c%Font% s10
    AutoMechanicSearch := AutoMechanics()
    For each, Mechanic in StrSplit(AutoMechanicSearch, "|")
    {
        autochecked := % mechanic "Auto"
        autochecked := % %autochecked%
        Gui, Auto:Add, Checkbox, v%Mechanic% Checked%autochecked%, %Mechanic%
    }
    Gui, Auto:Font, s10
    Gui, Auto:Add, Text, +Wrap w180, Note: to use Auto Mechanics the corresponding mechanic must be turned on in the "Select Mechanics" menu. You must also have "Output Dialog To Chat" turned on in the games UI Settings panel. 
    Gui, Auto:Add, Button, x10 y210 w80 h40, Select Mechanics
    Gui, Auto:Add, Button, x105 y210 w80 h40, OK
    Gui, Auto:Show, W200, Auto Enable/Disable (Beta)
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