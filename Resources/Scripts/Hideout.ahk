FilterSearch(FilterSearch, NA1)
{
    Global HideoutTyped := FilterSearch.Value
    If (FilterSearch.Value != "")
        {
            LV.Delete
            HideoutPath := IniPath("HideoutList")
            HideoutFile := FileRead(HideoutPath)
            Loop Parse HideoutFile, "`n"
                {
                    If InStr(A_LoopField, FilterSearch.Value)
                        {
                            LV.Add(,A_LoopField)
                        }
                }
            LV.Redraw
        }

}

EditFocused(*)
{
    Global Focused := 1
}

EditUnFocused(*)
{
    Global Focused := 0
}

LVDoubleClick(*)
{
    HideoutSelected := ListViewGetContent("Selected", "SysListView321", "Settings")
    HideoutSelected := StrSplit(HideoutSelected, A_Tab,A_Tab "`r `n" A_Space)
    HideoutIni := IniPath("Hideout")
    IniWrite(HideoutSelected[1], HideoutIni, "Current Hideout", "Hideout")
    SettingsGui["EditText"].Text := HideoutSelected[1]
    SettingsGui["HideoutName"].Text := "Current Hideout: " HideoutSelected[1]
}

GetHideout()
{
    HideoutIni := IniPath("Hideout")
    CurrentHideout := IniRead(HideoutIni, "Current Hideout", "Hideout", "Error")
    Return CurrentHideout
}