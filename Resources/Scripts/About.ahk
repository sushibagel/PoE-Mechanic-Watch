GetAbout(*)
{
    DestroyVersionGui()
    CurrentTheme := GetTheme()
    AboutGui.BackColor := CurrentTheme[1]
    AboutGui.SetFont("s15 Bold c" CurrentTheme[3])
    AboutGui.Add("Text", "w400 Center" ,"About PoE Mechanic Watch")
    AboutGui.AddText("w400 h1 Background" CurrentTheme[3])
    AboutGui.SetFont("s10 Norm")
    AboutGui.Add("Text", "XM Section", "Version:")
    VersionPath := IniPath("Version")
    FileData := Fileread(VersionPath)
    FileData := StrSplit(FileData, "`r", "`r`n")
    AboutGui.SetFont("c" CurrentTheme[2])
    AboutGui.Add("Text", "YS x+1 w150", FileData[1])
    AboutGui.SetFont("c" CurrentTheme[3])
    AboutGui.Add("Text", "YS Section", "Release Date:")
    AboutGui.SetFont("c" CurrentTheme[2])
    AboutGui.Add("Text", "YS x+1", FileData[2])
    AboutGui.SetFont("c" CurrentTheme[3])
    AboutGui.Add("Button", "XM Section w150 ", "Check For Updates")
    AboutGui.Add("Text","YS w50")
    AboutGui.Add("Button", "YS W150", "Changelog").OnEvent("Click", AboutChangelog)
    AboutGui.Add("Link", "XM w400 +Wrap", "To view previous versions and release information visit <a href=`"https://github.com/sushibagel/PoE-Mechanic-Watch/releases`">here.</a> For feedback and questions visit <a href=`"https://github.com/sushibagel/PoE-Mechanic-Watch/discussions`">here.</a>")
    AboutGui.Show()
}

DestroyVersionGui()
{
    If WinExist("About PoE Mechanic Watch")
        {
            AboutGui.Destroy()
        }
    Global AboutGui := Gui(,"About PoE Mechanic Watch")
}

AboutChangelog(*)
{
    WinMinimize("About PoE Mechanic Watch")
    ViewChangelog()
    WinWaitActive("PoE Mechanic Watch Changelog")
    WinWaitClose
    WinRestore("About PoE Mechanic Watch")
}

ViewChangelog(*)
{
    DestroyChangelog()
    CurrentTheme := GetTheme()
    Changelog.BackColor := CurrentTheme[1]
    Changelog.SetFont("s15 Bold c" CurrentTheme[3])
    Changelog.Add("Text", "Center w1000", "Changelog")
    Changelog.AddText("h1 w1000 Background" CurrentTheme[3])
    

    OnMessage(0x0115, OnScroll) ; WM_VSCROLL
    OnMessage(0x0114, OnScroll) ; WM_HSCROLL
    OnMessage(0X020A, OnWheel)  ; WM_MOUSEWHEEL
    Changelog.Show()
    Changelog.OnEvent("Close", CloseChangelog)
}

DestroyChangelog()
{
    If WinExist("PoE Mechanic Watch Changelog")
        {
            Changelog.Destroy()
        }
    Global Changelog := Gui("+Resize +0x300000", "PoE Mechanic Watch Changelog")
}

CloseChangelog(*)
{
    DestroyChangelog()
}
;### add check for updates button and changelog button