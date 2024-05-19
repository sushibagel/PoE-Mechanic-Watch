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
    LV := HideoutUpdate.Add("ListView","Sort w250 Background" CurrentTheme[2] " ", ["Name"])
    Loop Parse HideoutFile, "`r"
        {
            LV.Add(,A_LoopField)
        }
    
        ; LVS_EX_GRIDLINES


    HideoutUpdate.AddText("w250 h1 Background" CurrentTheme[3])
    HideoutUpdate.SetFont("s8 Norm c" CurrentTheme[3])
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