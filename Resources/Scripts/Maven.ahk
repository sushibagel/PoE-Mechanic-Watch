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
Global MavenReminderText
Global UncheckMaps
Global LastState1
Global LastState2
Global LastState3
Global LastState4
Global LastState5
Global LastState6
Global LastState7
Global LastState8
Global LastState9
Global LastState10
Global UncheckFormed
Global LastStateLairoftheHydra
Global LastStateMazeoftheMinotaur
Global LastStateForgeofthePhoenix
Global LastStatePitoftheChimera
Global UncheckForgotten
Global LastStateRewrittenDistantMemory
Global LastStateAugmentedDistantMemory
Global LastStateAlteredDistantMemory
Global LastStateTwistedDistantMemory
Global UncheckFeared
Global LastStateCortex
Global LastStateChayulasDomain
Global LastStateTheAlluringAbyss
Global LastStateTheShapersRealm
Global LastStateAbsenceofValueandMeaning
Global UncheckTwisted
Global LastStateThePurifier
Global LastStateTheConstrictor
Global LastStateTheEnslaver
Global LastStateTheEradicator
Global UncheckHidden
Global LastStateUulNetolsDomain
Global LastStateXophsDomain
Global LastStateTulsDomain
Global LastStateEshsDomain
Global UncheckElderslayer
Global LastStateBaranTheCrusader
Global LastStateVeritaniaTheRedeemer
Global LastStateAlHezminTheHunter
Global LastStateDroxTheWarlord
Global NumBosses
Global MavenBoss

MavenTrack()
{
    Gui, Maven:Destroy
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
    MavenReminderText := "You have just entered a Maven's Crucible click ""Yes"" to view/reset tracking."
    MavenReminderType:= "Crucible"
    MavenReminder()
}

ViewMaven()
{
    Gui, Maven:Destroy
    MechanicsIni := MechanicsIni()
    Gui, Maven:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
    Gui, Maven:Font, c%Font% s13 Bold
    Width := A_ScreenWidth*.65
    Width := Round(96/A_ScreenDPI*Width)
    Gui, Maven:Add, Text, w%Width% +Center, Maven Completion Status
    Gui, Maven:Font
    Gui, Maven:Font, c%Font% s%fw%
    Gui, Maven:Add, Text, w%Width% +Center, Note: You can check/uncheck items to change the completion status.
    Gui, Maven:Font, c%Font% s1
    Gui, Maven:Add, GroupBox, w%Width% +Center x0 h1
    Space = y+2
    Gui, Maven: -Caption
    fw := Round(96/A_ScreenDPI*10)
    Gui, Maven:Font, c%Font% s11 Bold Underline
    Gui, Maven:Add, Text, xs x10 Section, Map Bosses
    Gui, Maven:Font
    Gui, Maven:Font, c%Font% s%fw%

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
    Gui, Maven:Add, CheckBox, Checked0 gUncheckMaps vUncheckMaps, Remove All
    Gui, Maven:Font, cBlack
    Gui, Maven:Add, Edit, Center xs w60 vMavenBoss
    Gui, Maven:Add, Button, xp+65 , Add
    Gui, Maven:Font,c%Font%

    ; The Formed
    Gui, Maven:Font, c%Font% s11
    Gui, Maven:Font, Bold Underline
    Gui, Maven:Add, Text, ys Section, The Formed
    Gui, Maven: Font
    Gui, Maven:Font, c%Font% s%fw%
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
    Gui, Maven:Add, CheckBox, Checked0 gUncheckFormed vUncheckFormed, Remove All

    ; The Forgotten
    Gui, Maven:Font, c%Font% s11
    Gui, Maven:Font, Bold Underline
    Gui, Maven:Add, Text, ys Section, The Forgotten
    Gui, Maven: Font
    Gui, Maven:Font, c%Font% s%fw%
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
    Gui, Maven:Add, CheckBox, Checked0 gUncheckForgotten vUncheckForgotten, Remove All

    ; The Feared
    Gui, Maven:Font, c%Font% s11
    Gui, Maven:Font, Bold Underline
    Gui, Maven:Add, Text, ys Section, The Feared
    Gui, Maven:Font
    Gui, Maven:Font, c%Font% s%fw%
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
    Gui, Maven:Add, CheckBox, Checked0 gUncheckFeared vUncheckFeared, Remove All

    ; The Twisted
    Gui, Maven:Font, c%Font% s11
    Gui, Maven:Font, Bold Underline
    Gui, Maven:Add, Text, ys Section, The Twisted
    Gui, Maven: Font
    Gui, Maven:Font, c%Font% s%fw%
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
    Gui, Maven:Add, CheckBox, Checked0 gUncheckTwisted vUncheckTwisted, Remove All

    ; The Hidden
    Gui, Maven:Font, c%Font% s11
    Gui, Maven:Font, Bold Underline
    Gui, Maven:Add, Text, ys Section, The Hidden
    Gui, Maven: Font
    Gui, Maven:Font, c%Font% s%fw%
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
    Gui, Maven:Add, CheckBox, Checked0 gUncheckHidden vUncheckHidden, Remove All

    ; The Elderslayers
    Gui, Maven:Font, c%Font% s11
    Gui, Maven:Font, Bold Underline
    Gui, Maven:Add, Text, ys Section, The Elderslayers
    Gui, Maven: Font
    Gui, Maven:Font, c%Font% s%fw%
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
    Gui, Maven:Add, CheckBox, Checked0 gUncheckElderslayer vUncheckElderslayer, Remove All

    Gui, Maven:Font, c%Font%
    Gui, Maven:Add, Button, xn x20 Section, Close
    Gui, Maven:Color, %Background%
    Gui, Maven:Show, w%Width%, Maven
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
    NumBosses := 0
    Loop, 10
    {
        IniRead, BossName, %MechanicsIni%, Maven Map, Maven Map %A_Index%
        IniWrite, %A_Space%, %MechanicsIni%, Maven Map, Maven Map %A_Index%
        If (BossName != "")
        {
            NumBosses++
            IniWrite, %BossName%, %MechanicsIni%, Maven Map, Maven Map %NumBosses%
        }
    }
    IniWrite, %NumBosses%, %MechanicsIni%, Influence Track, Maven
    RefreshOverlay()
    Return
}

MavenButtonAdd()
{
    Gui, Maven:Submit, Nohide
    MechanicsIni := MechanicsIni()
    Loop, 10
    {
        IniRead, CheckBoss, %MechanicsIni%, Maven Map, Maven Map %A_Index%
        If (CheckBoss = "")
        {
            IniWrite, %MavenBoss%, %MechanicsIni%, Maven Map, Maven Map %A_Index%
            IniWrite, %A_Index%, %MechanicsIni%, Influence Track, Maven
            ViewMaven()
            Break
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

UncheckMaps()
{
    Gui, Maven:Submit, NoHide
    If (UncheckMaps = 1)
    {
        Loop, 10
        {
            SaveState := "Maven" A_Index
            LastState%A_Index% := %SaveState%
            GuiControl, , Maven%A_Index%, 0
        }
    }
    If (UncheckMaps = 0)
    {
        Loop, 10
        {
            PriorState := "LastState" A_Index
            PriorState := %PriorState%
            GuiControl, , Maven%A_Index%, %PriorState%
        }
    }
}

UncheckFormed()
{
    Gui, Maven:Submit, NoHide
    If (UncheckFormed = 1)
    {
        LastStateLairoftheHydra := LairoftheHydra
        LastStateMazeoftheMinotaur := MazeoftheMinotaur
        LastStateForgeofthePhoenix := ForgeofthePhoenix
        LastStatePitoftheChimera := PitoftheChimera
        GuiControl, , LairoftheHydra, 0
        GuiControl, , MazeoftheMinotaur, 0
        GuiControl, , ForgeofthePhoenix, 0
        GuiControl, , PitoftheChimera, 0
    }
    If (UncheckFormed = 0)
    {
        GuiControl, , LairoftheHydra, %LastStateLairoftheHydra%
        GuiControl, , MazeoftheMinotaur, %LastStateMazeoftheMinotaur%
        GuiControl, , ForgeofthePhoenix, %LastStateForgeofthePhoenix%
        GuiControl, , PitoftheChimera, %LastStatePitoftheChimera%
    }
}

UncheckForgotten()
{
    Gui, Maven:Submit, NoHide
    If (UncheckForgotten = 1)
    {
        LastStateRewrittenDistantMemory := RewrittenDistantMemory
        LastStateAugmentedDistantMemory := AugmentedDistantMemory
        LastStateAlteredDistantMemory := AlteredDistantMemory
        LastStateTwistedDistantMemory := TwistedDistantMemory
        GuiControl, , RewrittenDistantMemory, 0
        GuiControl, , AugmentedDistantMemory, 0
        GuiControl, , AlteredDistantMemory, 0
        GuiControl, , TwistedDistantMemory, 0
    }
    If (UncheckForgotten = 0)
    {
        GuiControl, , RewrittenDistantMemory, %LastStateRewrittenDistantMemory%
        GuiControl, , AugmentedDistantMemory, %LastStateAugmentedDistantMemory%
        GuiControl, , AlteredDistantMemory, %LastStateAlteredDistantMemory%
        GuiControl, , TwistedDistantMemory, %LastStateTwistedDistantMemory%
    }
}

UncheckFeared()
{
    Gui, Maven:Submit, NoHide
    If (UncheckFeared = 1)
    {
        LastStateCortex := Cortex
        LastStateChayulasDomain := ChayulasDomain
        LastStateTheAlluringAbyss := TheAlluringAbyss
        LastStateTheShapersRealm := TheShapersRealm
        LastStateAbsenceofValueandMeaning := AbsenceofValueandMeaning
        GuiControl, , Cortex, 0
        GuiControl, , ChayulasDomain, 0
        GuiControl, , TheAlluringAbyss, 0
        GuiControl, , TheShapersRealm, 0
        GuiControl, , AbsenceofValueandMeaning, 0
    }
    If (UncheckFeared = 0)
    {
        GuiControl, , Cortex, %LastStateCortex%
        GuiControl, , ChayulasDomain, %LastStateChayulasDomain%
        GuiControl, , TheAlluringAbyss, %LastStateTheAlluringAbyss%
        GuiControl, , TheShapersRealm, %LastStateTheShapersRealm%
        GuiControl, , AbsenceofValueandMeaning, %LastStateAbsenceofValueandMeaning%
    }
}

UncheckTwisted()
{
    Gui, Maven:Submit, NoHide
    If (UncheckTwisted = 1)
    {
        LastStateThePurifier := ThePurifier
        LastStateTheConstrictor := TheConstrictor
        LastStateTheEnslaver := TheEnslaver
        LastStateTheEradicator := TheEradicator
        GuiControl, , ThePurifier, 0
        GuiControl, , TheConstrictor, 0
        GuiControl, , TheEnslaver, 0
        GuiControl, , TheEradicator, 0
    }
    If (UncheckTwisted = 0)
    {
        GuiControl, , ThePurifier, %LastStateThePurifier%
        GuiControl, , TheConstrictor, %LastStateTheConstrictor%
        GuiControl, , TheEnslaver, %LastStateTheEnslaver%
        GuiControl, , TheEradicator, %LastStateTheEradicator%
    }
}

UncheckHidden()
{
    Gui, Maven:Submit, NoHide
    If (UncheckHidden = 1)
    {
        LastStateUulNetolsDomain := UulNetolsDomain
        LastStateXophsDomain := XophsDomain
        LastStateTulsDomain := TulsDomain
        LastStateEshsDomain := EshsDomain
        GuiControl, , UulNetolsDomain, 0
        GuiControl, , XophsDomain, 0
        GuiControl, , TulsDomain, 0
        GuiControl, , EshsDomain, 0
    }
    If (UncheckHidden = 0)
    {
        GuiControl, , UulNetolsDomain, %LastStateUulNetolsDomain%
        GuiControl, , XophsDomain, %LastStateXophsDomain%
        GuiControl, , TulsDomain, %LastStateTulsDomain%
        GuiControl, , EshsDomain, %LastStateEshsDomain%
    }
}

UncheckElderslayer()
{
    Gui, Maven:Submit, NoHide
    If (UncheckElderslayer = 1)
    {
        LastStateBaranTheCrusader := BaranTheCrusader
        LastStateVeritaniaTheRedeemer := VeritaniaTheRedeemer
        LastStateAlHezminTheHunter := AlHezminTheHunter
        LastStateDroxTheWarlord := DroxTheWarlord
        GuiControl, , BaranTheCrusader, 0
        GuiControl, , VeritaniaTheRedeemer, 0
        GuiControl, , AlHezminTheHunter, 0
        GuiControl, , DroxTheWarlord, 0
    }
    If (UncheckElderslayer = 0)
    {
        GuiControl, , BaranTheCrusader, %LastStateBaranTheCrusader%
        GuiControl, , VeritaniaTheRedeemer, %LastStateVeritaniaTheRedeemer%
        GuiControl, , AlHezminTheHunter, %LastStateAlHezminTheHunter%
        GuiControl, , DroxTheWarlord, %LastStateDroxTheWarlord%
    }
}

MavenLog(NewLine, CurrentSearch)
{
    MechanicsIni := MechanicsIni()
    IniRead, InfluenceActive, %MechanicsIni%, Influence, Maven
    {
        If (InfluenceActive = 1)
        {
            MavenFile := MavenTxt()
            IniRead, MavenMatch, %MavenFile%, Voice Lines, %CurrentSearch%
            MavenMatch := StrSplit(MavenMatch, "|")
            MavenBoss := MavenMatch[1]
            MavenInvitation := MavenMatch[2]
            IniWrite, 1, %MechanicsIni%, %MavenInvitation%, %MavenBoss%
        }
    }
}