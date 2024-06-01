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
    FileData := StrSplit(FileData, "`r",)
    AboutGui.SetFont("c" CurrentTheme[2])
    AboutGui.Add("Text", "YS x+1 w100", FileData[1])
    AboutGui.SetFont("c" CurrentTheme[3])
    AboutGui.Add("Text", "YS Section", "Release Date:")
    AboutGui.SetFont("c" CurrentTheme[2])
    AboutGui.Add("Text", "YS x+1", FileData[2])
    AboutGui.SetFont("c" CurrentTheme[3])
    AboutGui.Add("Link", "XM w400 +Wrap", "For the latest version use the `"Check for Updates`" tool in the tray menu or visit <a href=`"https://github.com/sushibagel/PoE-Mechanic-Watch/releases`">here.</a> For feedback and questions visit <a href=`"https://github.com/sushibagel/PoE-Mechanic-Watch/discussions`">here.</a>")

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