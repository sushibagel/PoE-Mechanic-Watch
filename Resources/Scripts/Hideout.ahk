#HotIf WinActive("Update Hideout") ;Enter key hotkey active only while hideout update is active
Enter::
{
    If (Focused = 1)
        {
            HideoutIni := IniPath("Hideout")
            IniWrite(HideoutTyped, HideoutIni, "Current Hideout", "Hideout")
            DestroyHideoutTool()
        }
}
#HotIf

SetHideout(*)
{
    DestroyHideoutTool()
    CurrentTheme := GetTheme()
    HideoutUpdate.BackColor := CurrentTheme[1]
    HideoutUpdate.SetFont("s15 Bold c" CurrentTheme[3])
    HideoutUpdate.Add("Text", "w250 Center" ,"Update Hideout")
    HideoutUpdate.AddText("w250 h1 Background" CurrentTheme[3])
    HideoutUpdate.SetFont("s10 Norm")
    HideoutPath := IniPath("HideoutList")
    HideoutFile := FileRead(HideoutPath)
    HideoutIni := IniPath("Hideout")
    CurrentHideout := IniRead(HideoutIni, "Current Hideout", "Hideout", "")
    SearchEdit := HideoutUpdate.Add("Edit", "w250 Background" CurrentTheme[2], CurrentHideout)
    SearchEdit.OnEvent("Change", FilterSearch)
    SearchEdit.OnEvent("Focus", EditFocused)
    SearchEdit.OnEvent("LoseFocus", EditUnFocused)
    Global LV := HideoutUpdate.Add("ListView","Sort Grid w250 r20 Background" CurrentTheme[2], ["Name"])
    Loop Parse HideoutFile, "`r"
        {
            LV.Add(,A_LoopField)
        }
    LV.ModifyCol(1, "230")
    GridTheme := CurrentTheme[3]
    If RegExMatch(CurrentTheme[3], "i)(?=.*[0-9])(?=.*\d)")
        {
            GridTheme := "0x" CurrentTheme[3]
        }
    LV_GridColor(LV, GridTheme)  
    LV.OnEvent("DoubleClick", LVDoubleClick)
    HideoutUpdate.AddText("w250 h1 Background" CurrentTheme[3])
    HideoutUpdate.SetFont("s10 Norm c" CurrentTheme[3])
    HideoutUpdate.Add("Link",'w250 Center', "Find and select the name of your hideout from the list above, the list can be filtered using the `"Search`" box. Double Click an option from the list to select a hideout. If your hideout is not available in the list simply type the full name of your hideout into the `"Search`" box and press `"Enter`" to help the community you may also consider letting me know it's missing by leaving a comment in the latest discussion thread found <a href=`"https://github.com/sushibagel/PoE-Mechanic-Watch/discussions`">here.</a>")
    HideoutUpdate.Show
}

DestroyHideoutTool()
{
    If WinExist("Update Hideout")
        {
            HideoutUpdate.Destroy()
        }
    Global HideoutUpdate := Gui(,"Update Hideout")
}

FilterSearch(FilterSearch, NA1)
{
    Global HideoutTyped := FilterSearch.Value
    If (FilterSearch.Value != "")
        {
            LV.Delete
            HideoutPath := IniPath("HideoutList")
            HideoutFile := FileRead(HideoutPath)
            Loop Parse HideoutFile, "`r"
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
    HideoutSelected := ListViewGetContent("Selected", "SysListView321", "Update Hideout")
    HideoutSelected := StrSplit(HideoutSelected, A_Tab,A_Tab "`r `n" A_Space)
    HideoutIni := IniPath("Hideout")
    IniWrite(HideoutSelected[1], HideoutIni, "Current Hideout", "Hideout")
    DestroyHideoutTool()
}

GetHideout()
{
    HideoutIni := IniPath("Hideout")
    CurrentHideout := IniRead(HideoutIni, "Current Hideout", "Hideout", "Error")
    Return CurrentHideout
}