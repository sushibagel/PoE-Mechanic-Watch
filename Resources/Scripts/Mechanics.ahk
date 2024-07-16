ShowFootnote(FootnoteSelected, Control, *)
{
    If (FootnoteSelected = 1)
        {
            GuiInfo := "The `"On`" setting will enable the mechanic associated, adding an image to the overlay. Tracking for the mechanic can be enabled by clicking on the mechanic image or with an associated hotkey."
        }
    If (FootnoteSelected = 2)
        {
            GuiInfo := "The `"Active Only`" setting will enable the mechanic associated but the overlay image will not be present unless the mechanic is made active either by hotkey or an auto mechanic trigger."
        }
    If (FootnoteSelected = 3)
        {
            GuiInfo := "The `"Auto Mechanics`" setting allows mechanics to be triggered using a combination of Optical Character Recognition (OCR), Image Matching and reading game logs. Note: Not all mechanics will have an `"Auto`" trigger ability, this is mostly due to how they are implemented into the game. Some Auto Mechanics will may need calibration or setup, this can be done by navigating to the `"Calibrate Search`" option. You can learn more about how each mechanics auto tracking works by clicking on the number next to the mechanic."
        }
    If !(GuiInfo = "")
        {
            MouseGetPos(&X,&Y)
            Y := Y - 150
            X := X + 300
            ActivateFootnoteGui(GuiInfo, X, Y)
        }
}

ShowMechanicFootnote(FootnoteSelected, Control, *)
{
    If (FootnoteSelected = 1)
        {
            GuiInfo := "The `"Auto`" setting for this mechanic uses Optical Character Recognition (OCR) to read text on your screen and recognize when certain mechanics are active in game. To use it you MUST have `"Quest Tracking`" enabled in the in-game settings and the corresponding mechanic must be set to `"On`" or `"Active Only`". If necessary you can adjust the OCR Zone in the Calibration Tool, but it should not be needed."
        }
    If (FootnoteSelected = 2)
        {
            GuiInfo := "The `"Auto`" setting for this mechanic uses a combination of Image Matching and reading the game logs to detect its status. To use it you MUST have `"Output Dialog to Chat`" enabled in the in-game settings and the corresponding mechanic must be set to `"On`" or `"Active Only`". You may need to calibrate the Image Matching Tool, this can be done by clicking the `"Calibrate Search`" button (Note: to calibrate you will need to have the mechanic active in game)."
        }
    If (FootnoteSelected = 3)
        {
            GuiInfo := "The `"Auto`" setting for this mechanic reads the game logs to determine its satus. To use it you MUST have `"Output Dialog to Chat`" enabled in the in-game settings and the corresponding mechanic must be set to `"On`" or `"Active Only`"."
        }
    If (FootnoteSelected = 4)
        {
            GuiInfo := "The `"Auto`" setting for this mechanic uses a combination Image Matching and Optical Character Recognition (OCR) to detect its status. To use it the correstponding mechanic must be set to `"On`" or `"Active Only`". You may need to calibrate the Image Matching Tool, this can be done by clicking the `"Calibrate Search`" button (Note: to calibrate you will need to have the mechanic active in game). If necessary you can adjust the OCR Zone in the Calibration Tool, but it should not be needed."
        }
    If !(GuiInfo = "")
        {
            MouseGetPos(&X,&Y)
            Y := Y
            X := X - 50
            If (FootnoteSelected = 4)
            {
                Y := Y - 150
            }
            ActivateFootnoteGui(GuiInfo, X, Y)
        }
}

EldritchFootnote(*)
{
    GuiInfo := "This `"Auto Switching/Tracking`" setting incorporates all three Eldritch mechanics (Eater of Worlds, Searing Exarch and Maven) and will attempt to track completion numbers and switch between the three mechanics when possible. This is accomplished through a combination of reading the game logs, Optical Character Recognition (OCR) and Image Matching. `r `rHow it works: when in your hideout the Image Search feature will begin looking for the Eldritch map device icons, once it identifies which mechanic is currently active it will try to update the current completion total if it's within +/-2 completion. If at any time the completion count isn't updating correctly or it is outside of +/-2 completions you can hover your mouse over the active mechanics icon and OCR will be used to update the count. For more information on why the +/-2 complitions was used see <a href=`"https://github.com/sushibagel/PoE-Mechanic-Watch/discussions/51`">here.</a> Completion counts can be incremented by clicking the icon in the overlay or reset (to zero) by holding `"Alt`" and clicking."
    MouseGetPos(&X,&Y)
    Y := Y - 300
    X := X - 295
    ActivateFootnoteGui(GuiInfo, X, Y)
    WTotal := 580
    ActivateFootnoteGui(GuiInfo, X, Y, WTotal)
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