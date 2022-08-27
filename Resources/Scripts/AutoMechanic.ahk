Global BlightAuto
Global ExpeditionAuto 
Global IncursionAuto

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
    Gui, Submit, NoHide 
    AutoMechanicSearch := AutoMechanics()
    MechanicsIni := MechanicsIni()
    For each, Mechanic in StrSplit(AutoMechanicSearch, "|")
    {
        mechanicvalue := % %Mechanic%
        IniWrite, %mechanicvalue%, %MechanicsIni%, Auto Mechanics, %Mechanic%
    }
    Gui, Auto:Destroy
    Return
} 

AutoButtonSelectMechanics()
{
    AutoButtonOk()
    SelectMechanics()
    WinwaitClose, Mechanic
    SelectAuto()
}

ReadAutoMechanics()
{
    AutoMechanicSearch := AutoMechanics()
    MechanicsIni := MechanicsIni()
    AutoMechanicsActive = 0
    For each, Mechanic in StrSplit(AutoMechanicSearch, "|")
    {
        IniRead, %Mechanic%, %MechanicsIni%, Auto Mechanics, %Mechanic%
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