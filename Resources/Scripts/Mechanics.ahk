Global Abyss
Global Blight
Global Breach
Global Expedition
Global Harvest
Global Incursion
Global Metamorph
Global Ritual
Global Generic
Global Eater
Global Searing
Global MechanicSearch
Global AbyssOn
Global BlightOn
Global BreachOn
Global ExpeditionOn
Global HarvestOn
Global IncursionOn
Global MetamorphOn
Global RitualOn
Global GenericOn

Mechanics() ;List of Mechanics
{
    Return, "Abyss|Blight|Breach|Expedition|Harvest|Incursion|Metamorph|Ritual|Generic"
}

SelectMechanics()
{
    MechanicSearch := Mechanics()
    Gui, Mechanic:Font, c%Font% s10
    MechanicsIni := MechanicsIni()
    For each, Mechanic in StrSplit(MechanicSearch, "|")
    {
        IniRead, %Mechanic%State, %MechanicsIni%, Mechanics, %Mechanic%
        autochecked := % mechanic "State"
        autochecked := % %autochecked%
        Gui, Mechanic:Add, Checkbox, v%Mechanic% Checked%autochecked%, %Mechanic%
    }
    Gui, Mechanic:-Border -Caption
    Gui, Mechanic:Color, %Background%
    Gui, Mechanic:Font, s1 %Secondary%
    Gui, Mechanic:Add, Text
    Gui, Mechanic:Add, Text, w200 0x10
    Gui, Mechanic:Font, Bold s11
    Gui, Mechanic:Add, Text,,Select One
    Gui, Mechanic:Font, s1 c%Font%
    Gui, Mechanic:Font, Normal s10
    Influences := Influences()
    For each, Influence in StrSplit(Influences, "|")
    {
        IniRead, %Influence%State, %MechanicsIni%, Influence, %Influence%
        autochecked = %Influence%State
        autochecked := % %autochecked%
        Gui, Mechanic:Add, Checkbox, v%Influence% Checked%autochecked%, %Influence%
    }
    Gui, Mechanic:Add, Button, x100 y295 w80 h20, OK
    Gui Mechanic:Show,,Mechanic
    Return
}

MechanicGuiClose()
{
    Start()
    Return
}

MechanicButtonOk()
{
    Gui, Submit, NoHide 
    If (Searing = 1) and (Eater = 1)
    {
        Msgbox, Warning, you can only have one Influence active at a time. 
        Gui, Mechanic:Destroy
        SelectMechanics()
    }
    MechanicSearch := Mechanics()
    Influences := Influences()
    MechanicsIni := MechanicsIni()
    For each, Mechanic in StrSplit(MechanicSearch, "|")
    {
        IniWrite, % %Mechanic%, %MechanicsIni%, Mechanics, %Mechanic%
    }
    For each, Influence in StrSplit(Influences, "|")
    {
        IniWrite, % %Influence%, %MechanicsIni%, Influence, %Influence%
    }
    Gui, Mechanic:Destroy
    Start()
    Return
}

ReadMechanics()
{
    MechanicsIni := MechanicsIni()
    MechanicSearch := Mechanics()
    For each, Mechanic in StrSplit(MechanicSearch, "|")
    {
        IniRead, %Mechanic%, %MechanicsIni%, Mechanics, %Mechanic%
        If (%Mechanic% = 1)
        {
            %Mechanic%On := 1
        }
        If (%Mechanic% = 0)
        {
            %Mechanic%On := 0
        }
    }
    Return
}