ShowFootnote(FootnoteSelected, Control, *)
{
    FootnoteMenu := Menu()
    If (FootnoteSelected = 1)
        {
            FootnoteMenu.Add("The `"On`" setting will enable the mechanic", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("associated, adding an image to the overlay.", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("Tracking for the mechanic can be enabled by", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("clicking on the mechanic image or with an", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("associated hotkey.", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    If (FootnoteSelected = 2)
        {
            FootnoteMenu.Add("The `"Active Only`" setting will enable the", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("mechanic associated but the overlay image will", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("not be present unless the mechanic is made active", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("either by hotkey or an auto mechanic trigger.", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    If (FootnoteSelected = 3)
        {
            FootnoteMenu.Add("The `"Auto Mechanics`" setting allows mechanics", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("to be triggered using a combination of Optical", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("Character Recognition (OCR), Image Matching and", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("reading game logs. Note: Not all mechanics will", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("have an `"Auto`" trigger ability, this is mostly", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("due to how they are implemented into the game.", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("Some Auto Mechanics will may need calibration", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("or setup, this can be done by navigating to the", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("`"Calibrate Search`" option. You can learn more", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("about how each mechanics auto tracking works by", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("clicking on the number next to the mechanic.", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    FootnoteMenu.Show() 
}

DestroyFootnoteMenu(FootnoteMenu, *)
{
    FootnoteMenu.Delete
}

ShowMechanicFootnote(FootnoteSelected, Control, *)
{
    FootnoteMenu := Menu()
    If (FootnoteSelected = 1)
        {
            FootnoteMenu.Add("The `"Auto`" setting for this mechanic uses ", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("Optical Character Recognition (OCR) to read text", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("on your screen and recognize when certain mechanics", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("are active in game. To use it you MUST have", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("`"Quest Tracking`" enabled in the in-game settings", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("and the corresponding mechanic must be set to `"On`"", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("or `"Active Only`". If necessary you can adjust the", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("OCR Zone in the Calibration Tool, but it should", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("not be needed.", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    If (FootnoteSelected = 2)
        {
            FootnoteMenu.Add("The `"Auto`" setting for this mechanic uses a", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("combination of Image Matching and reading the", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("game logs to detect its status. To use it you MUST", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("have `"Output Dialog to Chat`" enabled in the", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("in-game settings and the corresponding mechanic", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("must be set to `"On`" or `"Active Only`".", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("You may need to calibrate the Image Matching Tool,", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("this can be done by clicking the `"Calibrate Search`"", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("button (Note: to calibrate you will need to have the", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("mechanic active in game).", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    If (FootnoteSelected = 3)
        {
            FootnoteMenu.Add("The `"Auto`" setting for this mechanic reads the", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("game logs to determine its satus. To use it you", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("MUST have `"Output Dialog to Chat`" enabled in the", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("in-game settings and the corresponding mechanic must", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add(" be set to `"On`" or `"Active Only`".", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    If (FootnoteSelected = 4)
        {
            FootnoteMenu.Add("The `"Auto`" setting for this mechanic uses a", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("combination Image Matching and Optical Character", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("Recognition (OCR) to detect its status. To use it", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("the corresponding mechanic must be set to `"On`" or", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("`"Active Only`". You may need to calibrate the Image", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("Matching Tool, this can be done by clicking the", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("`"Calibrate Search`" button (Note: to calibrate you", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("will need to have the mechanic active in game).", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("If necessary you can adjust the OCR Zone in the", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("Calibration Tool, but it should not be needed.", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    FootnoteMenu.Show()
}

EldritchFootnote(*)
{
    FootnoteMenu := Menu()
    FootnoteMenu.Add("This `"Auto Switching/Tracking`" setting incorporates all three Eldritch mechanics", DestroyFootnoteMenu.Bind(FootnoteMenu))
    FootnoteMenu.Add("(Eater of Worlds, Searing Exarch and Maven) and will attempt to track completion", DestroyFootnoteMenu.Bind(FootnoteMenu))
    FootnoteMenu.Add("numbers and switch between the three mechanics when possible This is accomplished", DestroyFootnoteMenu.Bind(FootnoteMenu))
    FootnoteMenu.Add("through a combination of reading the game logs, Optical Character Recognition (OCR)", DestroyFootnoteMenu.Bind(FootnoteMenu))
    FootnoteMenu.Add("and Image Matching. How it works: when in your hideout the Image Search feature", DestroyFootnoteMenu.Bind(FootnoteMenu))
    FootnoteMenu.Add("will begin looking for the Eldritch map device icons, once it identifies which", DestroyFootnoteMenu.Bind(FootnoteMenu))
    FootnoteMenu.Add("mechanic is currently active it will try to update the current completion total", DestroyFootnoteMenu.Bind(FootnoteMenu))
    FootnoteMenu.Add("if it's within +/-2 completion. If at any time the completion count isn't updating", DestroyFootnoteMenu.Bind(FootnoteMenu))
    FootnoteMenu.Add("correctly or it is outside of +/-2 completions you can hover your mouse over the", DestroyFootnoteMenu.Bind(FootnoteMenu))
    FootnoteMenu.Add("active mechanics icon and OCR will be used to update the count. For", DestroyFootnoteMenu.Bind(FootnoteMenu))
    FootnoteMenu.Add("morere information on why the +/-2 complitions was used see", DestroyFootnoteMenu.Bind(FootnoteMenu))
    FootnoteMenu.Add("https://github.com/sushibagel/PoE-Mechanic-Watch/discussions/51", DiscussionLink)
    FootnoteMenu.Add("Completion counts can be incremented by clicking the icon in the overlay or reset", DestroyFootnoteMenu.Bind(FootnoteMenu))
    FootnoteMenu.Add("(to zero) by holding `"Alt`" and clicking.", DestroyFootnoteMenu.Bind(FootnoteMenu))
    FootnoteMenu.Show()
}

DiscussionLink(*)
{
    Run("https://github.com/sushibagel/PoE-Mechanic-Watch/discussions/51")
}

ActiveSelected(MechanicSelected, NA1, NA2)
{
    MechanicsIni := IniPath("Mechanics")
    IniWrite(2, MechanicsIni, "Mechanics", MechanicSelected)
}

OnSelected(MechanicSelected, NA1, NA2)
{
    MechanicsIni := IniPath("Mechanics")
    IniWrite(1, MechanicsIni, "Mechanics", MechanicSelected)
}

OffSelected(MechanicSelected, *)
{
    MechanicsIni := IniPath("Mechanics")
    IniWrite(0, MechanicsIni, "Mechanics", MechanicSelected)
}

AutoSelected(MechanicSelected, Status, NA2)
{
    MechanicsIni := IniPath("Mechanics")
    IniWrite(Status.Value, MechanicsIni, "Auto Mechanics", MechanicSelected)
}

InfluenceSelected(MechanicSelected, Status, NA2)
{
    MechanicsIni := IniPath("Mechanics")
    Influences := VariableStore("Influences")
    For Influence in Influences
        {
            IniWrite(0, MechanicsIni, "Influence", Influence)
        }
    If !(MechanicSelected = "None")
        {
            IniWrite(Status.Value, MechanicsIni, "Influence", MechanicSelected)
        }
}

InfluenceTracking(Status, NA2)
{
    MechanicsIni := IniPath("Mechanics")
    IniWrite(Status.Value, MechanicsIni, "Auto Mechanics", "Eldritch")
}

MechanicSelectClose(*)
{
    DestroyFootnote()
}

CalibrateSearchButton(GuiTabs, *)
{
    SwitchTab(12, GuiTabs)
}

NotifyActiveMechanics(*)
{
    MechanicsIni := IniPath("Mechanics")
    Mechanics := VariableStore("Mechanics")
    ActiveMechanics := Array()
    For Mechanic in Mechanics
        {
            MechanicVar := Mechanic "Status"
            MechanicVar:= IniRead(MechanicsIni, "Mechanic Active", Mechanic, 0)
            If (MechanicVar = 1)
                {
                    ActiveMechanics.Push(Mechanic)
                }
        }
    If (ActiveMechanics.Length > 0)
    {
        Notify(ActiveMechanics, "Mechanic Notification")
    }
}

InfluenceRemoveOne(*)
{
    MechanicsIni := IniPath("Mechanics")
    ActiveInfluence := GetInfluence()
    CurrentCount := IniRead(MechanicsIni, "Influence Track", ActiveInfluence, 0)
    CurrentCount--
    If (CurrentCount = -1)
        {
            If (ActiveInfluence = "Eater") or (ActiveInfluence = "Searing")
                {
                    CurrentCount := 27
                }
            If (ActiveInfluence = "Maven")
                {
                    CurrentCount := 10
                }
        }
    IniWrite(CurrentCount, MechanicsIni, "Influence Track", ActiveInfluence)
    RefreshOverlay()
}

ToggleInfluence(*)
{
    ActiveInfluence := GetInfluence()
    Influences := VariableStore("Influences")
    For Influence in Influences
        {
            If (ActiveInfluence = Influence)
                {
                    InfluenceIndex := A_Index
                    Break
                }
        }
    InfluenceIndex++
    If (InfluenceIndex > 3)
        {
            InfluenceIndex := 1
        }            
    MechanicsIni := IniPath("Mechanics")
    Influences := VariableStore("Influences")
    For Influence in Influences
        {
            IniWrite(0, MechanicsIni, "Influence", Influence)
        }
    If !(ActiveInfluence = "None")
        {
            IniWrite(1, MechanicsIni, "Influence", Influences[InfluenceIndex])
        }
    RefreshOverlay()
}

ChangeInfluence(NewInfluence)
{
    ActiveInfluence := GetInfluence()
    If !(NewInfluence = ActiveInfluence)
        {
            MechanicsIni := IniPath("Mechanics")
            Influences := VariableStore("Influences")
            For Influence in Influences
                {
                    IniWrite(0, MechanicsIni, "Influence", Influence)
                }
            If !(ActiveInfluence = "None")
                {
                    IniWrite(1, MechanicsIni, "Influence", NewInfluence)
                }
            RefreshOverlay()
        }
}