Global Abyss
Global Betrayal
Global Blight
Global Breach
Global Einhar
Global Expedition
Global Harvest
Global Incursion
Global Legion
Global Niko
Global Ritual
Global Ultimatum
Global Generic
Global Eater
Global Searing
Global Maven
Global AbyssActive
Global BetrayalActive
Global BlightActive
Global BreachActive
Global EinharActive
Global ExpeditionActive
Global HarvestActive
Global IncursionActive
Global LegionActive
Global NikoActive
Global RitualActive
Global UltimatumActive
Global GenericActive
Global MechanicSearch
Global AbyssOn
Global BetrayalOn
Global BlightOn
Global BreachOn
Global EinharOn
Global ExpeditionOn
Global HarvestOn
Global IncursionOn
Global IncursionTotal
Global LegionOn
Global NikoOn
Global RitualOn
Global UltimatumOn
Global GenericOn
Global mechanicsOn
Global MechanicsActive
Global Mechanic
Global None
Global AutoRun

Mechanics() ;List of Mechanics
{
    Return, "Abyss|Betrayal|Blight|Breach|Einhar|Expedition|Harvest|Incursion|Legion|Niko|Ritual|Ultimatum|Generic"
}

SelectMechanics(RunAuto := False)
{
    Gui, Mechanic:Destroy
    MechanicSearch := Mechanics()
    Gui, Mechanic:Font, c%Font% s10
    MechanicsPath := MechanicsIni()
    Gui, Mechanic:Add, Text, xn x10 Section, Mechanic
    Gui, Mechanic:Add, Text, x93 ys, On
    Gui, Mechanic:Add, Text, x135 ys, Active Only
    Gui, Mechanic:Font, c%Font% s7
    Gui, Mechanic:Add, Text, x+.5 ys, 1
    Gui, Mechanic:Font, c%Font% s10
    Gui, Mechanic:Add, Text, x222 ys, Off
    For each, Mechanic in StrSplit(MechanicSearch, "|")
    {
        IniRead, %Mechanic%State, %MechanicsPath%, Mechanics, %Mechanic%, 0
        autochecked := % mechanic "State"
        autochecked := % %autochecked%
        Gui, Mechanic:Add, Text, xn x15 Section, %Mechanic%:
        If (autochecked = 1)
            {
                OnChecked := 1
                OffChecked := 0
                AutoOnly := 0
            }
        If (autochecked = 0)
            {
                OnChecked := 0
                OffChecked := 1
                AutoOnly := 0
            }
        If (autochecked = 2)
            {
                OnChecked := 0
                OffChecked := 0
                AutoOnly := 1
            }
        Gui, Mechanic:Add, Radio, x95 ys v%Mechanic% Checked%OnChecked%
        Gui, Mechanic:Add, Radio, x160 ys Checked%AutoOnly%
        Gui, Mechanic:Add, Radio, x225 ys Checked%OffChecked%
    }
    Gui, Mechanic:Font, s8 c%Font%
    Gui, Mechanic:Add, Text, xn x10 w240,1. Active Only will hide the mechanic icon unless it is made active either by hotkey or auto mechanic. 

    Gui, Mechanic:-Border -Caption
    Gui, Mechanic:Color, %Background%
    Gui, Mechanic:Font, s1 c%Secondary%
    Gui, Mechanic:Add, Text
    Gui, Mechanic:Add, Text, xn w260 0x10
    Gui, Mechanic:Font, Bold s11
    Gui, Mechanic:Add, Text,x10,Select One
    Gui, Mechanic:Font, s1 c%Font%
    Gui, Mechanic:Font, Normal s10
    InfluencesTypes := Influences()
    For each, Influence in StrSplit(InfluencesTypes, "|")
    {
        IniRead, %Influence%State, %MechanicsPath%, Influence, %Influence%
        autochecked = %Influence%State
        autochecked := % %autochecked%
        Gui, Mechanic:Add, Radio, x15 v%Influence% Checked%autochecked%, %Influence%
    }
    Gui, Mechanic:Add, Radio, vNone, None
    Gui, Mechanic:Add, Button, xp x150 w80 h20, OK
    Gui Mechanic:Show,,Mechanic
    If (RunAuto = 1)
    {
        AutoRun := 1
    }
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
        If (%Mechanic% = 3)
            {
                %Mechanic% := 0
            }
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
    If (AutoRun = 1)
    {
        SelectAuto()
        Exit
    }
    FirstRunPath := FirstRunIni()
    IniRead, Active, %FirstRunPath%, Active, Active
    If (Active = 1)
    {
        FirstRunPath := FirstRunIni()
        Iniwrite, 1, %FirstRunPath%, Completion, Mechanic
        FirstRun()
    }
    ReloadScreenSearch()
    RefreshOverlay()
    Return
}

ReadMechanics()
{
    MechanicsPath := MechanicsIni()
    MechanicSearch := Mechanics()
    MechanicsOn := ""
    For each, Mechanic in StrSplit(MechanicSearch, "|")
    {
        IniRead, %Mechanic%, %MechanicsPath%, Mechanics, %Mechanic%
        If (%Mechanic% = 1)
            {
                %Mechanic%On := 1
                MechanicsOn ++
            }
        If (%Mechanic% = 0)
            {
                %Mechanic%On := 0
            }
        If (%Mechanic% = 2)
            {
                %Mechanic%On := 2
                MechanicsOn ++
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
        IniRead, %Mechanic%, %MechanicsPath%, Mechanic Active, %Mechanic%, 0
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