SetupTool()
{
    SetupToolDestroy()
    CurrentTheme := GetTheme()
    Setup.BackColor := CurrentTheme[1]
    Setup.SetFont("s15 Bold c" CurrentTheme[3])
    Setup.Add("Text", "Center w500", "Setup Tool")
    Setup.AddText("h1 w500 Background" CurrentTheme[3])
    SetupItems := ["*Open Path of Exile Client.", "Select alternate settimgs storage location."]
    TotalCounts := 10
    Loop TotalCounts
        {
            Setup.Add("Checkbox", "XM Section")
            Setup.Add("Text", "YS", SetupItems[A_Index])
        }




    Setup.Show
}

SetupToolDestroy()
{
If WinExist("Setup Tool")
    {
        Setup.Destroy()
    }
    Global Setup := Gui(, "Setup Tool")
}