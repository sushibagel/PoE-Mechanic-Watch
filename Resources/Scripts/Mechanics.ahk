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
Global AbyssActive
Global BlightActive
Global BreachActive
Global ExpeditionActive
Global HarvestActive
Global IncursionActive
Global MetamorphActive
Global RitualActive
Global GenericActive
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
Global MechanicsActive
Global Mechanic
Global None

Mechanics() ;List of Mechanics
{
    Return, "Abyss|Blight|Breach|Expedition|Harvest|Incursion|Metamorph|Ritual|Generic"
}

SelectMechanics()
{
    MechanicSearch := Mechanics()
    Gui, Mechanic:Font, c%Font% s10
    MechanicsPath := MechanicsIni()
    For each, Mechanic in StrSplit(MechanicSearch, "|")
    {
        IniRead, %Mechanic%State, %MechanicsPath%, Mechanics, %Mechanic%
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
    InfluencesTypes := Influences()
    For each, Influence in StrSplit(InfluencesTypes, "|")
    {
        IniRead, %Influence%State, %MechanicsPath%, Influence, %Influence%
        autochecked = %Influence%State
        autochecked := % %autochecked%
        Gui, Mechanic:Add, Radio, v%Influence% Checked%autochecked%, %Influence%
    }
    Gui, Mechanic:Add, Radio, vNone, None
    Gui, Mechanic:Add, Button, xp x100 w80 h20, OK
    Gui Mechanic:Show,,Mechanic
    Return
}

MechanicGuiClose()
{
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
    InfluencesTypes := Influences()
    MechanicsPath := MechanicsIni()
    For each, Mechanic in StrSplit(MechanicSearch, "|")
    {
        IniWrite, % %Mechanic%, %MechanicsPath%, Mechanics, %Mechanic%
    }
    For each, Influence in StrSplit(InfluencesTypes, "|")
    {
        IniWrite, % %Influence%, %MechanicsPath%, Influence, %Influence%
    }
    Gui, Mechanic:Destroy
    PostSetup()
    PostMessage, 0x01111,,,, WindowMonitor.ahk - AutoHotkey ; Deactive alt tab reminder for influences 
    PostRestore()
    Return
}

ReadMechanics()
{
    MechanicsPath := MechanicsIni()
    MechanicSearch := Mechanics()
    For each, Mechanic in StrSplit(MechanicSearch, "|")
    {
        IniRead, %Mechanic%, %MechanicsPath%, Mechanics, %Mechanic%
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

MechanicsActive()
{
    MechanicsActive := 0
    MechanicsPath := MechanicsIni()
    MechanicSearch := Mechanics()
    For each, Mechanic in StrSplit(MechanicSearch, "|")
    {
        IniRead, %Mechanic%, %MechanicsPath%, Mechanic Active, %Mechanic%
        If (%Mechanic% = 1)
        {
            %Mechanic%Active := 1
            MechanicsActive ++
        }
        If (%Mechanic% = 0)
        {
            %Mechanic%Active := 0
        }
    }
    Return
}