UpdateCheck(GuiButton := "", *)
{
    VersionPath := IniPath("Version")
    VersionData := FileRead(VersionPath)
    VersionData := StrSplit(VersionData, "`r", "`n `t")
    InstalledVersion := VersionData[1]
    VersionURL := "https://raw.githubusercontent.com/sushibagel/PoE-Mechanic-Watch/main/Resources/Data/Version.txt"
    CurrentVersion := GetContent(VersionURL)
    CurrentVersion := Trim(CurrentVersion, "`n `t") ; Trim and clean
    CurrentVersion := StrSplit(CurrentVersion, "v")
    InstalledVersion := StrSplit(InstalledVersion, "v")
    If (CurrentVersion[2] > InstalledVersion[2])
        {
            UpdateUrl := "https://github.com/sushibagel/PoE-Mechanic-Watch/archive/refs/tags/v" CurrentVersion[2] ".zip"
            ChangelogURL := "https://raw.githubusercontent.com/sushibagel/PoE-Mechanic-Watch/main/changelog.txt"
            If WinExist("About PoE Mechanic Watch")
                {
                    WinMinimize
                }
            DestroyUpdateGui()
            CurrentTheme := GetTheme()
            UpdateGui.BackColor := CurrentTheme[1]
            UpdateGui.SetFont("s15 Bold c" CurrentTheme[3])
            UpdateGui.Add("Text", "w800 Center", "Update Available")
            UpdateGui.AddText("w800 h1 Background" CurrentTheme[3])
            UpdateGui.SetFont("s10 Norm")
            UpdateGui.Add("Text", "XM Section w130")
            UpdateGui.Add("Button", "YS w150", "Download").OnEvent("Click", DownloadUpdate.Bind(UpdateUrl, CurrentVersion[2]))
            UpdateGui.Add("Text", "YS w170")
            UpdateGui.Add("Button", "YS w150", "Remind Me Later").OnEvent("Click", DestroyUpdateGui)
            UpdateGui.SetFont("c" CurrentTheme[2])
            UpdateGui.Add("Link", "XM w800 +Wrap", "To view previous versions and release information visit <a href=`"https://github.com/sushibagel/PoE-Mechanic-Watch/releases`">here.</a> For feedback and questions visit <a href=`"https://github.com/sushibagel/PoE-Mechanic-Watch/discussions`">here.</a>")
            UpdateGui.SetFont("c" CurrentTheme[3])
            Changelog := GetContent(ChangelogURL)
            UpdateGui.Add("Text", "w800 +Wrap XM", Changelog)
            UpdateGui.OnEvent("Size", UpdateGui_Size)
            OnMessage(0x0115, OnScroll) ; WM_VSCROLL
            OnMessage(0x0114, OnScroll) ; WM_HSCROLL
            OnMessage(0X020A, OnWheel)  ; WM_MOUSEWHEEL
            H := "h" A_ScreenHeight - 500
            UpdateGui.Show("w850" H)
            WinWaitClose("Update Available")
        }
    If (CurrentVersion[2] = InstalledVersion[2])
        {
            TrayTip("PoE Mechanic Watch is Up-To-Date")
            If WinExist("About PoE Mechanic Watch")
                {
                    GuiButton.Text := "No Update Available"
                }
            Sleep 3000
            TrayTip
        }
    If WinExist("About PoE Mechanic Watch")
        {
            WinRestore
        }
    MiscIni := IniPath("Misc Data")
    IniWrite(A_Now, MiscIni, "Update", "Last Check")
}

DestroyUpdateGui(*)
{
    If WinExist("Update Available")
        {
            UpdateGui.Destroy()
        }
    Global UpdateGui := Gui(,"Update Available")
}

GetContent(URL)
{
    GithubConnect := ComObject("WinHttp.WinHttpRequest.5.1")
    GithubConnect.Open("GET", URL, True)
    GithubConnect.Send()
    GithubConnect.WaitForResponse()
    Return GithubConnect.ResponseText
}

UpdateGui_Size(GuiObj, MinMax, Width, Height)
{
    If (MinMax != 1)
        UpdateScrollBars(GuiObj)
}

DownloadUpdate(UpdateURL, CurrentVersion, *)
{
    Download(UpdateURL, "PoE Mechanic Watch " CurrentVersion '.zip')
}

; ### add option to go to zip file with install instructions