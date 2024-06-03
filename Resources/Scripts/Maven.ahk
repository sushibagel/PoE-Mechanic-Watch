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
            MavenGui.SetFont("s10 Norm")
            For Boss in InvitationBosses
                {
                    CheckStatus := 0
                    If (Invitation = "Map Bosses")
                        {
                            CheckStatus := 1
                            Control := "Boss" A_Index
                        }
                    Else
                        {
                            CheckStatus := IniRead(MechanicsIni, Invitation, Boss, "0")
                            If (Invitation = "The Formed")
                                {
                                    Control := "Formed" A_Index
                                }
                            If (Invitation = "The Forgotten")
                                {
                                    Control := "Forgotten" A_Index
                                }
                            If (Invitation = "The Feared")
                                {
                                    Control := "Feared" A_Index
                                }
                            If (Invitation = "The Twisted")
                                {
                                    Control := "Twisted" A_Index
                                }
                            If (Invitation = "The Hidden")
                                {
                                    Control := "Hidden" A_Index
                                }
                            If (Invitation = "The Elderslayers")
                                {
                                    Control := "Elderslayer" A_Index
                                }
                        }
                    MavenGui.Add("Checkbox", "XS v" Control, Boss).OnEvent("Click", ToggleBoss.Bind(Boss, Invitation, A_Index))
                }
            MavenGui.Add("Checkbox", "XS c" CurrentTheme[2], "Remove All").OnEvent("Click", RemoveAll.Bind(Invitation))
        }
}

DestroyMavenGui(MavenGui)
{
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

ToggleBoss(Boss, Invitation, IndexCount, Value, *)
{
    ; msgbox Boss "|" Invitation "|" IndexCount "|" Value.Value
    MechanicsIni := IniPath("Mechanics")
    If !(Invitation = "Map Bosses")
        {
            IniWrite(Value.Value, MechanicsIni, Invitation, Boss)
        }
    Else
        {
            MavenMaps := BuildMapArray()
            If (Value.Value = 0) ; if the map being removed is the last one just remove it. 
                {

                    IniDelete(MechanicsIni, "Maven Map", "Maven Map " IndexCount)
                }
            Else If (Value.Value = 1) ; if box is rechecked add it back
                {
                    MavenMaps := BuildMapArray()
                    IniWrite(Boss, MechanicsIni, "Maven Map", "Maven Map " IndexCount)
                }
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

RemoveAll(Invitation, Status,*)
{
    MechanicsIni := IniPath("Mechanics")
    If (Invitation = "Map Bosses")
        {
            Loop 10
                {
                    IniDelete(MechanicsIni, "Maven Map", "Maven Map " A_Index)
                }
        }
    Else
        {
            Bosses := GetBosses(Invitation)
            For Boss in Bosses
                {
                    IniWrite(Status.Value, MechanicsIni, Invitation, Boss)
                }
        }
}

; ### Probably should have this one always on top. 
; ### built in transparency slider? 
; ### Control for individual notifications
