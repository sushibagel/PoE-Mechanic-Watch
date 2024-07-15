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
            UpdateGui := GuiTemplate("UpdateGui", "Update Available", "800")
            CurrentTheme := GetTheme()
            UpdateGui.Add("Text", "XM Section w130")
            UpdateGui.Add("Button", "YS w150", "Download").OnEvent("Click", DownloadUpdate.Bind(UpdateUrl, CurrentVersion[2]))
            UpdateGui.Add("Text", "YS w170")
            UpdateGui.Add("Button", "YS w150", "Remind Me Later").OnEvent("Click", DestroyUpdateGui.Bind(UpdateGui))
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
            UpdateGui.OnEvent("Close", DestroyUpdateGui)
            WinWaitClose("Update Available")
        }
    If (CurrentVersion[2] = InstalledVersion[2])
        {
            TrayTip("PoE Mechanic Watch is Up-To-Date",,4)
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

DestroyUpdateGui(UpdateGui, *)
{
    UpdateGui.Destroy()
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
    WinMinimize("Update Available")
    FileName := "PoE Mechanic Watch " CurrentVersion ".zip"
    Download(UpdateURL, FileName)
    DownloadComplete := DownloadCheck(FileName)
    If (DownloadComplete = 1)
        {
            DownloadGui := GuiTemplate("DownloadGui", "Download Complete", 300)
            CurrentTheme := GetTheme()
            DownloadGui.Add("Text", "w300 +Wrap", "To update unzip the contents of  `"" FileName "`" simply open the contained folders until you see `"" A_ScriptName "`" and a folders titled `"Resources`" copy all the files in the directory and simply paste them into the your current install directory.")
            DownloadGui.Add("Button", "XM Section w100", "Open File").OnEvent("Click", OpenFile.Bind(Filename, DownloadGui))
            DownloadGui.Add("Text", "Center w175", "")
            DownloadGui.Add("Button", "YS w100", "Close").OnEvent("Click", CloseDlGui.Bind(DownloadGui))
            DownloadGui.Show()
            DownloadGui.OnEvent("Close", CloseDlGui.Bind(DownloadGui))
        }
}

DownloadCheck(FileName)
{
    If FileExist(FileName)
        {
            Return 1
        }
    Else
        {
            Sleep 200
            DownloadCheck(FileName)
        }
}

DestroyDownloadGui(DownloadGui)
{
    DownloadGui.Destroy()
}

OpenFile(FileName, DownloadGui, *)
{
    If WinExist("Update Available")
        {
            WinClose
        }
    If WinExist("About PoE Mechanic Watch")
        {
            WinClose
        }
    DestroyDownloadGui(DownloadGui)
    Run(FileName)  
}

CloseDlGui(DownloadGui, *)
{
    DestroyDownloadGui(DownloadGui)
    If WinExist("Update Available")
        {
            WinRestore
        }
}