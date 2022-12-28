Global Maven1
Global Maven2
Global Maven3
Global Maven4
Global Maven5
Global Maven6
Global Maven7
Global Maven8
Global Maven9
Global Maven10
Global LairoftheHydra
Global MazeoftheMinotaur
Global ForgeofthePhoenix
Global PitoftheChimera
Global RewrittenDistantMemory
Global AugmentedDistantMemory
Global AlteredDistantMemory
Global TwistedDistantMemory
Global Cortex
Global ChayulasDomain
Global TheAlluringAbyss
Global TheShapersRealm
Global AbsenceofValueandMeaning
Global ThePurifier
Global TheConstrictor
Global TheEnslaver
Global TheEradicator
Global UulNetolsDomain
Global XophsDomain
Global TulsDomain
Global EshsDomain
Global BaranTheCrusader
Global VeritaniaTheRedeemer
Global AlHezminTheHunter
Global DroxTheWarlord

MavenTrack()
{
    VariablePath := VariableIni()
    IniRead, MavenMapActive, %VariablePath%, Map, Maven Map
    IniRead, CurrentMap, %VariablePath%, Map, Last Map
    If (MavenMapActive = "Yes")
    {
        MechanicsPath := MechanicsIni()
        IniRead, MavenCount, %MechanicsPath%, Influence Track, Maven
        If (MavenCount < 10)
        {
            MavenCount ++
            IniWrite, %MavenCount%, %MechanicsPath%, Influence Track, Maven
            RefreshOverlay()
            Loop, 10
            {
                IniRead, MavenMap%A_Index%, %MechanicsPath%, Maven Map, Maven Map %A_Index%
                MapCheck := "MavenMap"A_Index
                If (%MapCheck% = "") or (%MapCheck% = "ERROR")
                {
                    MavenMapNumber := A_Index
                    Break
                }
            }
            MechanicsPath := MechanicsIni()
            IniWrite, %CurrentMap%, %MechanicsPath%, Maven Map, Maven Map %MavenMapNumber%
        }
        IniWrite, No, %VariablePath%, Map, Maven Map
    }
}

ResetMaven()
{
    MechanicsPath := MechanicsIni()
    IniWrite, 0, %MechanicsPath%, Influence Track, Maven
    Loop, 10
    {
        IniDelete, %MechanicsPath%, Maven Map, Maven Map %A_Index%
    }
    Return
}

ViewMaven()
{
    MechanicsIni := MechanicsIni()
    yh := (A_ScreenHeight/2) -150
    wh := (A_ScreenWidth/2)+50
    xh := (A_ScreenWidth/2)
    ewh := wh - (wh/3.5)
    Gui, Maven:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
    Gui, Maven:Color, %Background%
    Gui, Maven:Font, c%Font% s12
    Gui, Maven:Add, GroupBox, h10 xn x10
    Space = y+2
    Gui, Maven: -Caption
    Gui, Maven:Font, c%Font% s11
    Gui, Maven:Show, w%wh%,Maven
    WinGetPos, X, Y, w, h, Maven
    If (h < 85)
    {
        h = 85
    }
    Gui, Maven:Destroy
    Gui, Maven:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
    Gui, Maven:Font, c%Font% s13 Bold
    Gui, Maven:Add, Text, +Center w%wh%, Maven Completion Status
    Gui, Maven:Font
    Gui, Maven:Font, c%Font% s9
    Gui, Maven:Add, Text, +Center w%wh%, Note: You can check/uncheck items to change the completion status. 
    Gui, Maven:Font, c%Font% s12
    Gui, Maven:Add, GroupBox, w%wh% h10 xn
    Space = y+2
    Gui, Maven: -Caption
    Gui, Maven:Font, c%Font% s11
    xh := xh - (w/2)
    yh2 := yh + h
    h := h - 30
    Gui, Maven:Font, c%Font% s11
    Gui, Maven:Font, Bold Underline
    Gui, Maven:Add, Text, xs x10 Section, Map Bosses
    Gui, Maven:Font
    Gui, Maven:Font, c%Font% s9

; Map Bosses
    Loop, 10
    {
        IniRead, MapCompletion, %MechanicsIni%, Maven Map, Maven Map %A_Index%
        If (MapCompletion != "ERROR") and (MapCompletion != "")
        {
            MapCompletion := StrReplace(MapCompletion, "_" )
            MapReadable := RegExReplace(MapCompletion, "([[:upper:]])", " $1")
            Gui, Maven:Add, CheckBox, Checked1 vMaven%A_Index%, %MapReadable%
        }
    }

    ; The Formed
    Gui, Maven:Font, c%Font% s11
    Gui, Maven:Font, Bold Underline
    Gui, Maven:Add, Text, ys Section, The Formed
    Gui, Maven: Font
    Gui, Maven:Font, c%Font% s9
    IniRead, FormedCompletion, %MechanicsIni%, The Formed
    FormedCompletion := StrSplit(FormedCompletion, ["=", "`n"])
    ControlText := FormedCompletion[1]
    ControlText2 := StrReplace(ControlText, A_Space)
    Checked := ""
    If (FormedCompletion[2] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%
    ControlText := FormedCompletion[3]
    ControlText2 := StrReplace(ControlText, A_Space)
    Checked := ""
    If (FormedCompletion[4] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%
    ControlText := FormedCompletion[5]
    ControlText2 := StrReplace(ControlText, A_Space)
    Checked := ""
    If (FormedCompletion[6] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%
    ControlText := FormedCompletion[7]
    ControlText2 := StrReplace(ControlText, A_Space)
    Checked := ""
    If (FormedCompletion[8] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%

; The Forgotten
    Gui, Maven:Font, c%Font% s11
    Gui, Maven:Font, Bold Underline
    Gui, Maven:Add, Text, ys Section, The Forgotten
    Gui, Maven: Font
    Gui, Maven:Font, c%Font% s9
    IniRead, ForgottenCompletion, %MechanicsIni%, The Forgotten
    ForgottenCompletion := StrSplit(ForgottenCompletion, ["=", "`n"])
    ControlText := ForgottenCompletion[1]
    ControlText2 := StrReplace(ControlText, A_Space)
    Checked := ""
    If (ForgottenCompletion[2] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%
    ControlText := ForgottenCompletion[3]
    ControlText2 := StrReplace(ControlText, A_Space)
    Checked := ""
    If (ForgottenCompletion[4] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%
    ControlText := ForgottenCompletion[5]
    ControlText2 := StrReplace(ControlText, A_Space)
    Checked := ""
    If (ForgottenCompletion[6] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%
    ControlText := ForgottenCompletion[7]
    ControlText2 := StrReplace(ControlText, A_Space)
    Checked := ""
    If (ForgottenCompletion[8] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%

    ; The Feared
    Gui, Maven:Font, c%Font% s11
    Gui, Maven:Font, Bold Underline
    Gui, Maven:Add, Text, ys Section, The Feared
    Gui, Maven: Font
    Gui, Maven:Font, c%Font% s9
    IniRead, FearedCompletion, %MechanicsIni%, The Feared
    FearedCompletion := StrSplit(FearedCompletion, ["=", "`n"])
    ControlText := FearedCompletion[1]
    ControlText2 := StrReplace(ControlText, A_Space)
    ControlText2 := StrReplace(ControlText2, "'s", "s")
    Checked := ""
    If (FearedCompletion[2] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%
    ControlText := FearedCompletion[3]
    ControlText2 := StrReplace(ControlText, A_Space)
    ControlText2 := StrReplace(ControlText2, "'s", "s")
    Checked := ""
    If (FearedCompletion[4] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%
    ControlText := FearedCompletion[5]
    ControlText2 := StrReplace(ControlText, A_Space)
    ControlText2 := StrReplace(ControlText2, "'s", "s")
    Checked := ""
    If (FearedCompletion[6] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%
    ControlText := FearedCompletion[7]
    ControlText2 := StrReplace(ControlText, A_Space)
    ControlText2 := StrReplace(ControlText2, "'s", "s")
    Checked := ""
    If (FearedCompletion[8] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%
    ControlText := FearedCompletion[9]
    ControlText2 := StrReplace(ControlText, A_Space)
    ControlText2 := StrReplace(ControlText2, "'s", "s")
    Checked := ""
    If (FearedCompletion[10] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%

; The Twisted
    Gui, Maven:Font, c%Font% s11
    Gui, Maven:Font, Bold Underline
    Gui, Maven:Add, Text, ys Section, The Twisted
    Gui, Maven: Font
    Gui, Maven:Font, c%Font% s9
    IniRead, TwistedCompletion, %MechanicsIni%, The Twisted
    TwistedCompletion := StrSplit(TwistedCompletion, ["=", "`n"])
    ControlText := TwistedCompletion[1]
    ControlText2 := StrReplace(ControlText, A_Space)
    ControlText2 := StrReplace(ControlText2, "'s", "s")
    Checked := ""
    If (TwistedCompletion[2] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%
    ControlText := TwistedCompletion[3]
    ControlText2 := StrReplace(ControlText, A_Space)
    ControlText2 := StrReplace(ControlText2, "'s", "s")
    Checked := ""
    If (TwistedCompletion[4] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%
    ControlText := TwistedCompletion[5]
    ControlText2 := StrReplace(ControlText, A_Space)
    ControlText2 := StrReplace(ControlText2, "'s", "s")
    Checked := ""
    If (TwistedCompletion[6] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%
    ControlText := TwistedCompletion[7]
    ControlText2 := StrReplace(ControlText, A_Space)
    ControlText2 := StrReplace(ControlText2, "'s", "s")
    Checked := ""
    If (TwistedCompletion[8] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%

; The Hidden
    Gui, Maven:Font, c%Font% s11
    Gui, Maven:Font, Bold Underline
    Gui, Maven:Add, Text, ys Section, The Hidden
    Gui, Maven: Font
    Gui, Maven:Font, c%Font% s9
    IniRead, HiddenCompletion, %MechanicsIni%, The Hidden
    HiddenCompletion := StrSplit(HiddenCompletion, ["=", "`n"])
    ControlText := HiddenCompletion[1]
    ControlText2 := StrReplace(ControlText, A_Space)
    ControlText2 := StrReplace(ControlText2, "-")
    ControlText2 := StrReplace(ControlText2, "'s", "s")
    Checked := ""
    If (HiddenCompletion[2] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%
    ControlText := HiddenCompletion[3]
    ControlText2 := StrReplace(ControlText, A_Space)
    ControlText2 := StrReplace(ControlText2, "'s", "s")
    Checked := ""
    If (HiddenCompletion[4] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%
    ControlText := HiddenCompletion[5]
    ControlText2 := StrReplace(ControlText, A_Space)
    ControlText2 := StrReplace(ControlText2, "'s", "s")
    Checked := ""
    If (HiddenCompletion[6] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%
    ControlText := HiddenCompletion[7]
    ControlText2 := StrReplace(ControlText, A_Space)
    ControlText2 := StrReplace(ControlText2, "'s", "s")
    Checked := ""
    If (HiddenCompletion[8] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%

; The Elderslayers
    Gui, Maven:Font, c%Font% s11
    Gui, Maven:Font, Bold Underline
    Gui, Maven:Add, Text, ys Section, The Elderslayers
    Gui, Maven: Font
    Gui, Maven:Font, c%Font% s9
    IniRead, ElderslayersCompletion, %MechanicsIni%, The Elderslayers
    ElderslayersCompletion := StrSplit(ElderslayersCompletion, ["=", "`n"])
    ControlText := ElderslayersCompletion[1]
    ControlText2 := StrReplace(ControlText, A_Space)
    ControlText2 := StrReplace(ControlText2, ",")
    ControlText2 := StrReplace(ControlText2, "'s", "s")
    Checked := ""
    If (ElderslayersCompletion[2] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%
    ControlText := ElderslayersCompletion[3]
    ControlText2 := StrReplace(ControlText, A_Space)
    ControlText2 := StrReplace(ControlText2, ",")
    ControlText2 := StrReplace(ControlText2, "'s", "s")
    Checked := ""
    If (ElderslayersCompletion[4] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%
    ControlText := ElderslayersCompletion[5]
    ControlText2 := StrReplace(ControlText, A_Space)
    ControlText2 := StrReplace(ControlText2, "-")
    ControlText2 := StrReplace(ControlText2, ",")
    ControlText2 := StrReplace(ControlText2, "'s", "s")
    Checked := ""
    If (ElderslayersCompletion[6] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%
    ControlText := ElderslayersCompletion[7]
    ControlText2 := StrReplace(ControlText, A_Space)
    ControlText2 := StrReplace(ControlText2, ",")
    ControlText2 := StrReplace(ControlText2, "'s", "s")
    Checked := ""
    If (ElderslayersCompletion[8] = 1)
    {
        Checked := "Checked1"
    }
    Gui, Maven:Add, CheckBox, %Checked% v%ControlText2%, %ControlText%
    Gui, Maven:Font, c%Font%
    Gui, Maven:Add, Button, xn x20 Section, Close
    Gui, Maven:Color, %Background%
    Gui, Maven:Show, x%xh% y%yh% w%wh%, Maven
    WinWaitClose, Maven
    Return
}

MavenButtonClose()
{
    Gui, Submit, NoHide
    Gui, Maven:Destroy
    Loop, 10
    {
        MapCheck := "Maven" A_Index
        If (%MapCheck% = 0)
        {
            RemoveMap(A_Index)
        }
    }
    MechanicsIni := MechanicsIni()
    Witnesses := Witnesses()
    For each, Witness in StrSplit(Witnesses, "|")
    {
        Bosses := %Witness%()
        For each, Boss in StrSplit(Bosses, "|")
        {
            BossName := StrReplace(Boss, A_Space)
            BossName := StrReplace(BossName, ",")
            BossName := StrReplace(BossName, "'s", "s")
            BossName := StrReplace(BossName, "-")
            BossName := %BossName%
            IniWrite, %BossName%, %MechanicsIni%, The %Witness%, %Boss%
        }
    }
    Return
}

RemoveMap(RemoveMap)
{
    MechanicsIni := MechanicsIni()
    IniDelete, %MechanicsIni%, Maven Map, Maven Map %RemoveMap%
    IniRead, MapCompletion, %MechanicsIni%, Maven Map
    ReplaceMap := StrSplit(MapCompletion, "`n")
    Loop, 10
    {
        IniDelete, %MechanicsIni%, Maven Map, Maven Map %A_Index%
        WriteMap := ReplaceMap[A_Index]
        WriteMap := StrSplit(WriteMap, "=")
        WriteMap := WriteMap[2]
        IniWrite, %WriteMap%, %MechanicsIni%, Maven Map, Maven Map %A_Index%
    }
}

MavenMatch(NewLine)
{
    MavenFile := MavenTxt()
    IniRead, MavenSearch, %MavenFile%, Voice Lines
    MavenSearch := StrSplit(MavenSearch, ["=", "`n"])
    Loop, 33
    {
        MySearch := MavenSearch[A_Index]
        If NewLine contains %MySearch%
        {
            IniRead, MavenData, %MavenFile%, Voice LInes, %MySearch%
            MavenData := StrSplit(MavenData, "|")
            MavenBoss := MavenData[1]
            MavenSection := MavenData[2]
            MechanicsIni := MechanicsIni()
            IniWrite, 1, %MechanicsIni%, %MavenSection%, %MavenBoss%
            Break
        }
    }
}

Formed() 
{
    Return, "Lair of the Hydra|Maze of the Minotaur|Forge of the Phoenix|Pit of the Chimera"
}

Forgotten()
{
    Return, "Rewritten Distant Memory|Augmented Distant Memory|Altered Distant Memory|Twisted Distant Memory"
}

Feared()
{
    Return, "Cortex|Chayula's Domain|The Alluring Abyss|The Shaper's Realm|Absence of Value and Meaning"
}

Twisted()
{
    Return, "The Purifier|The Constrictor|The Enslaver|The Eradicator"
}

Hidden()
{
    Return, "Uul-Netol's Domain|Xoph's Domain|Tul's Domain|Esh's Domain"
}

Elderslayers()
{
    Return, "Baran, The Crusader|Veritania, The Redeemer|Al-Hezmin, The Hunter|Drox, The Warlord"
}

Witnesses()
{
    Return, "Formed|Forgotten|Feared|Twisted|Hidden|Elderslayers"
}

MavenTxt()
{
    Return, "Resources/Data/Maven.txt"
}