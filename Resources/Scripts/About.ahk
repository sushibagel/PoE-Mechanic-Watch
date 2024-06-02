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
    Global CheckButton := AboutGui.Add("Button", "XM Section w150 ", "Check For Updates").OnEvent("Click", UpdateCheck)
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
    ChangelogPath := IniPath("Changelog")
    ChangelogData := FileRead(ChangelogPath)
    Changelog.SetFont("s10 Norm c" CurrentTheme[2])
    Changelog.Add("Link", "w1000 +Wrap", "For more information, questions or feedback on this release please see the current release discussion thread on my Github <a href=`"https://github.com/sushibagel/PoE-Mechanic-Watch/discussions`">here</a>.")
    Changelog.SetFont("c" CurrentTheme[3])
    Changelog.Add("Text", "XM +Wrap w1000", ChangelogData)
    Changelog.Add("Text", "Xm r2")
    Changelog.OnEvent("Size", Changelog_Size)
    OnMessage(0x0115, OnScroll) ; WM_VSCROLL
    OnMessage(0x0114, OnScroll) ; WM_HSCROLL
    OnMessage(0X020A, OnWheel)  ; WM_MOUSEWHEEL
    H := "h" A_ScreenHeight - 500
    Changelog.Show("w1050" H)
    Changelog.OnEvent("Close", CloseChangelog)
}

Changelog_Size(GuiObj, MinMax, Width, Height)
{
    If (MinMax != 1)
        UpdateScrollBars(GuiObj)
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