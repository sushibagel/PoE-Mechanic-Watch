MavenStatus(*)
{
    MavenGui := GuiTemplate("MavenGui", "Maven Completion Status", "1200")
    CurrentTheme := GetTheme()
    InvitationList := MavenInvitations()
    MechanicsIni := IniPath("Mechanics")
    For Invitation in InvitationList
        {
            MavenGui.SetFont("s12 Bold")
            Location := "YS"
            If (A_Index = 1)
                {
                    Location := "XM"
                }
            MavenGui.Add("Text", "Section " Location, Invitation)
            InvitationBosses := GetBosses(Invitation)
            Vars := GetLabels(Invitation)
            MavenGui.SetFont("s10 Norm")
            For Boss in Vars
                {
                    CheckStatus := 0
                    If (Invitation = "Map Bosses")
                        {
                            CheckStatus := 1
                        }
                    Else
                        {
                            CheckStatus := IniRead(MechanicsIni, Invitation, InvitationBosses[A_Index], "0")
                        }
                    MavenGui.Add("Checkbox", "XS v" Boss " Checked" CheckStatus, InvitationBosses[A_Index])
                }
            MavenGui.Add("Checkbox", "XS c" CurrentTheme[2], "Remove All").OnEvent("Click", RemoveAll.Bind(Invitation, MavenGui, Vars, InvitationBosses))
        }
    MavenGui.Show()
    MavenGui.OnEvent("Close", DestroyMavenGui)
}

DestroyMavenGui(MavenGui)
{
    Invitations := MavenInvitations()
    MechanicsIni := IniPath("Mechanics")
    Obj := MavenGui.Submit()
    For Name, Value in Obj.OwnProps() 
        {
            If Instr(Name, "Map") and (Value = 0)
                {
                    MapName := StrSplit(Name, "Map")
                    MapName := "Maven Map " MapName[2]
                    IniDelete(MechanicsIni, "Maven Map", MapName)
                }
            Else
                {
                    For Invitation in Invitations
                        {
                            Bosses := GetBosses(Invitation)
                            Labels := GetLabels(Invitation)
                            Loop Labels.Length
                                {
                                    If (Labels[A_Index] = Name)
                                        {
                                            Match := Bosses[A_Index]
                                            Category := Invitation
                                            Break
                                        }
                                }
                        }
                    IniWrite(Value, MechanicsIni, Category, Match )
                }
        }
    MavenGui.Destroy()
    RenumberMavenBosses()
}

MavenInvitations()
{
    Return ["Map Bosses", "The Formed", "The Forgotten", "The Feared", "The Twisted", "The Hidden", "The Elderslayers"]
}

GetBosses(Invitation)
{
    If (Invitation = "Map Bosses")
        {
            MavenMaps := BuildMapArray()
            Return MavenMaps
        }
    If (Invitation = "The Formed")
        {
            Return ["Lair of the Hydra", "Maze of the Minotaur", "Forge of the Phoenix", "Pit of the Chimera"]
        }
    If (Invitation = "The Forgotten")
        {
            Return ["Rewritten Distant Memory", "Augmented Distant Memory", "Altered Distant Memory", "Twisted Distant Memory"]
        }
    If (Invitation = "The Feared")
        {
            Return ["Cortex", "Chayula's Domain", "The Alluring Abyss", "The Shaper's Realm", "Absence of Value and Meaning"]
        }
    If (Invitation = "The Twisted")
        {
            Return ["The Purifier", "The Constrictor", "The Enslaver", "The Eradicator"]
        }
    If (Invitation = "The Hidden")
        {
            Return ["Uul-Netol's Domain", "Xoph's Domain", "Tul's Domain", "Esh's Domain"]
        }
    If (Invitation = "The Elderslayers")
        {
            Return ["Baran, The Crusader", "Veritania, the Redeemer", "Al-Hezmin, The Hunter", "Drox, The Warlord"]
        }
}

GetLabels(Invitation)
{
    If (Invitation = "Map Bosses")
        {
            MapArray := Array()
            Loop 10
                {
                    MapArray.Push("Map" A_Index)
                }
            Return ["Map1", "Map2", "Map3", "Map4"]
        }
    If (Invitation = "The Formed")
        {
            Return ["Hydra", "Minotaur", "Phoenix", "Chimera"]
        }
        If (Invitation = "The Forgotten")
            {
                Return ["Rewritten", "Augmented", "Altered", "Twisted"]
            }
        If (Invitation = "The Feared")
            {
                Return ["Cortex", "Chayula", "Alluring", "Shaper", "Absence"]
            }
        If (Invitation = "The Twisted")
            {
                Return ["Purifier", "Constrictor", "Enslaver", "Eradicator"]
            }
        If (Invitation = "The Hidden")
            {
                Return ["Uu", "Xoph", "Tul", "Esh"]
            }
        If (Invitation = "The Elderslayers")
            {
                Return ["Baran", "Veritania", "Al-Hezmin", "Drox"]
            }
}

RenumberMavenBosses()
{
    MavenMaps := BuildMapArray() ; get map array
    CheckArray := Array()
    MechanicsIni := IniPath("Mechanics")
    Loop MavenMaps.Length ;check if we get the correct number in the new array
        {
            MavenStatus := IniRead(MechanicsIni, "Maven Map", "Maven Map " A_Index, "")
            If !(MavenStatus = "")
                {
                    CheckArray.Push(MavenStatus)
                }
        }
    If !(CheckArray.Length = MavenMaps.Length) ; if they don't match we fix it
        {
            IndexCount := 1
            Loop 10
                {
                    MavenStatus := IniRead(MechanicsIni, "Maven Map", "Maven Map " A_Index, "")
                    If !(MavenStatus = "")
                        {
                            IniDelete(MechanicsIni, "Maven Map", "Maven Map " A_Index)
                            IniWrite(MavenStatus, MechanicsIni, "Maven Map", "Maven Map " IndexCount)
                            IndexCount++
                        }
                }
        }
}

BuildMapArray()
{
    MechanicsIni := IniPath("Mechanics")
    MavenMaps := Array()
    Loop 10
        {
            MavenStatus := IniRead(MechanicsIni, "Maven Map", "Maven Map " A_Index, "")
            If !(MavenStatus = "")
                {
                    MavenMaps.Push(MavenStatus)
                }
        }
    Return MavenMaps
}

RemoveAll(Invitation, MavenGui, Vars, InvitationBosses, Status, *)
{
    MechanicsIni := IniPath("Mechanics")
    For Boss in Vars
        {
            ; ControlHWND := ControlGetHwnd(Boss, "Maven Completion Status")
            If (ControlGetChecked(Boss, "Maven Completion Status") = 1) and (Status.Value = 1)
                {
                    ControlSetChecked(!Status.Value, Boss, "Maven Completion Status")
                }
            Else
                {
                    BossStatus := IniRead(MechanicsIni, Invitation, InvitationBosses[A_Index], 0)
                    If (BossStatus = 1)
                        {
                            ControlSetChecked(1, Boss, "Maven Completion Status")
                        }
                }
        }
	}
