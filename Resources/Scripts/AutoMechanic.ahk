Global BlightAuto
Global ExpeditionAuto 
Global IncursionAuto
Global AutoMechanicSearch

SelectAuto()
{
    ReadAutoMechanics()
    Sleep(100)
    Auto := Gui()
    Auto.Opt("-Border -Caption")
    Auto.BackColor := Background
    Auto.SetFont("c" . Font . " s10")
    AutoMechanicSearch := AutoMechanics()
    For each, Mechanic in StrSplit(AutoMechanicSearch, "|")
    {
        autochecked := mechanic "Auto"
        autochecked := %autochecked%
        ogcCheckbox := Auto.Add("Checkbox", "v" . Mechanic . " Checked" . autochecked, Mechanic)
    }
    Auto.SetFont("s10")
    Auto.Add("Text", "+Wrap w180", "Note: to use Auto Mechanics the corresponding mechanic must be turned on in the `"Select Mechanics`" menu. You must also have `"Output Dialog To Chat`" turned on in the games UI Settings panel.")
    ogcButtonSelectMechanics := Auto.Add("Button", "x10 y210 w80 h40", "Select Mechanics")
    ogcButtonSelectMechanics.OnEvent("Click", AutoButtonSelectMechanics.Bind("Normal"))
    ogcButtonOK := Auto.Add("Button", "x105 y210 w80 h40", "OK")
    ogcButtonOK.OnEvent("Click", AutoButtonOK.Bind("Normal"))
    Auto.Title := "Auto Enable/Disable (Beta)"
    Auto.Show("W200")
    Return
}

AutoButtonOk()
{
    AutoWrite()
    FirstRunPath := FirstRunIni()
    Active := IniRead(FirstRunPath, "Active", "Active")
    If (Active = 1)
    {
        FirstRunPath := FirstRunIni()
        IniWrite(1, FirstRunPath, "Completion", "AutoMechanic")
        FirstRun()
    }
    Return
}

AutoWrite()
{
    oSaved := Auto.Submit("0")
    AutoMechanicSearch := AutoMechanics()
    MechanicsPath := MechanicsIni()
    For each, Mechanic in StrSplit(AutoMechanicSearch, "|")
    {
        mechanicvalue := %Mechanic%
        IniWrite(mechanicvalue, MechanicsPath, "Auto Mechanics", Mechanic)
    }
    Auto.Destroy()
}

AutoButtonSelectMechanics()
{
    AutoWrite()
    SelectMechanics(True)
}

ReadAutoMechanics()
{
    AutoMechanicSearch := AutoMechanics()
    MechanicsPath := MechanicsIni()
    AutoMechanicsActive := "0"
    For each, Mechanic in StrSplit(AutoMechanicSearch, "|")
    {
        %Mechanic% := IniRead(MechanicsPath, "Auto Mechanics", Mechanic)
        If (%Mechanic% = 1)
        {
            %Mechanic%Auto := 1
            AutoMechanicsActive ++
        }
        Else
        {
            %Mechanic%Auto := 0
        }
    }
    Return
}

AutoMechanics()
{
    Return "Blight|Expedition|Incursion"
}