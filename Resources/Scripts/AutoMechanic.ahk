SelectAuto:
AutoMechanicSearch = Blight|Expedition|Incursion
Gosub, ReadAutoMechanics
Sleep, 100
Gui, Auto:-Border
Gui, Auto:Color, %Background%
Gui, Auto:-Caption
Gui, Auto:Font, c%Font% s10
Loop, 1
For each, Mechanic in StrSplit(AutoMechanicSearch, "|")
{
    autochecked = %mechanic%Auto
    If (%autochecked% = 1)
    {
        autochecked = 1
    }
    If (%autchecked% = 0)
    {
        autochecked = 0
    }
    Gui, Auto:Add, Checkbox, v%Mechanic% Checked%autochecked%, %Mechanic%
}
Gui, Auto:Font, s10
Gui, Auto:Add, Text, +Wrap w180, Note: to use Auto Mechanics the corresponding mechanic must be turned on in the "Select Mechanics" menu. You must also have "Output Dialog To Chat" turned on in the games UI Settings panel. 
Gui, Auto:Add, Button, x10 y210 w80 h40, Select Mechanics
Gui, Auto:Add, Button, x105 y210 w80 h40, OK
Gui, Auto:Show, W200, Auto Enable/Disable (Beta)
Return

AutoButtonOk: 
Gui, Submit, NoHide 
iniWrite, %Blight%, Resources\Settings\AutoMechanics.ini, Checkboxes, Blight
iniWrite, %Expedition%, Resources\Settings\AutoMechanics.ini, Checkboxes, Expedition
iniWrite, %Incursion%, Resources\Settings\AutoMechanics.ini, Checkboxes, Incursion
Gui, Destroy
Gosub, Start
Return

AutoButtonSelectMechanics:
Gui, Submit, NoHide
iniWrite, %Blight%, Resources\Settings\AutoMechanics.ini, Checkboxes, Blight
iniWrite, %Expedition%, Resources\Settings\AutoMechanics.ini, Checkboxes, Expedition
iniWrite, %Incursion%, Resources\Settings\AutoMechanics.ini, Checkboxes, Incursion
Run, Resources\Scripts\MechanicSelector.ahk
Return

ReadAutoMechanics:
AutoMechanicsActive = 0
Loop, 1
For each, Mechanic in StrSplit(AutoMechanicSearch, "|")
{
    IniRead, %Mechanic%, Resources\Settings\AutoMechanics.ini, Checkboxes, %Mechanic%
    If (%Mechanic% = 1)
    {
        %Mechanic%Auto := 1
        AutoMechanicsActive ++
    }
    If (%Mechanic% = 0)
    %Mechanic%Auto := 0
}
Return