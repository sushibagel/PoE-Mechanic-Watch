#SingleInstance, Force

Start:
StringTrimRight, UpOneLevel, A_ScriptDir, 7

MechanicSearch = Abyss|Blight|Breach|Expedition|Harvest|Incursion|Metamorph|Ritual|Generic

Gui, Mechanic:Font, cWhite s10
Loop, 1
For each, Mechanic in StrSplit(MechanicSearch, "|")
{
    IniRead, %Mechanic%State, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, %Mechanic%
}

Loop, 1
For each, Mechanic in StrSplit(MechanicSearch, "|")
{
    autochecked = %mechanic%State
    If (%autochecked% = 1)
    {
        autochecked = 1
    }
    If (%autchecked% = 0)
    {
        autochecked = 0
    }
    Gui, Mechanic:Add, Checkbox, v%Mechanic% Checked%autochecked%, %Mechanic%
}


FileRead, Influences, %UpOneLevel%Data/Influences.txt
Loop, 1
For each, Influence in StrSplit(Influences, "|")
{
    IniRead, %Influence%State, %UpOneLevel%/Settings/Mechanics.ini, Influence, %Influence%
}
Gui, Mechanic:-Border
Gui, Mechanic:Color, 4e4f53
Gui, Mechanic:-Caption
Gui, Mechanic:Font, s1 ce5f1fb
Gui, Mechanic:Add, Text
Gui, Mechanic:Add, Text, w200 0x10
Gui, Mechanic:Font, Bold s11
Gui, Mechanic:Add, Text,,Select One
Gui, Mechanic:Font, s1 cWhite
Gui, Mechanic:Font, Normal s10
FileRead, Influences, %UpOneLevel%Data/Influences.txt
For each, Influence in StrSplit(Influences, "|")
{
    autochecked = %Influence%State
    If (%autochecked% = 1)
    {
        autochecked = 1
    }
    If (%autchecked% = 0)
    {
        autochecked = 0
    }
    Gui, Mechanic:Add, Checkbox, v%Influence% Checked%autochecked%, %Influence%
}

Gui, Mechanic:Add, Button, x100 y295 w80 h20, OK
Gui Mechanic:Show
Return

MechanicGuiClose:
ExitApp
Gui, Destroy
Return

MechanicButtonOk: 
Gui, Submit, NoHide 
If (Searing = 1) and (Eater = 1)
{
    Msgbox, Warning, you can only have one Influence active at a time. 
    Gui, Mechanic:Destroy
    Reload
}
iniWrite, %Abyss%, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Abyss
IniWrite, Value, Filename, Section, Key
iniWrite, %Blight%, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Blight
iniWrite, %Breach%, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Breach
iniWrite, %Expedition%, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Expedition
iniWrite, %Harvest%, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Harvest
iniWrite, %Incursion%, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Incursion
iniWrite, %Metamorph%, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Metamorph
iniWrite, %Ritual%, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Ritual
iniWrite, %Generic%, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Generic
iniWrite, %Searing%, %UpOneLevel%Settings\Mechanics.ini, Influence, Searing
iniWrite, %Eater%, %UpOneLevel%Settings\Mechanics.ini, Influence, Eater
Gui, Mechanic:Destroy
ExitApp
Return