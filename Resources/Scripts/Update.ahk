UpdateCheck(GuiButton := "", *)
{
    VersionPath := IniPath("Version")
    VersionData := FileRead(VersionPath)
    VersionData := StrSplit(VersionData, "`r", "`n `t")
    InstalledVersion := VersionData[1]
    GithubConnect := ComObject("WinHttp.WinHttpRequest.5.1")
    GithubConnect.Open("GET", "https://raw.githubusercontent.com/sushibagel/PoE-Mechanic-Watch/main/Resources/Data/Version.txt", True)
    GithubConnect.Send()
    GithubConnect.WaitForResponse()
    CurrentVersion := Trim(GithubConnect.ResponseText, "`n `t") ; Trim and clean
    CurrentVersion := StrSplit(CurrentVersion, "v")
    InstalledVersion := StrSplit(InstalledVersion, "v")
    If (CurrentVersion[2] > InstalledVersion[2])
        {
            msgbox "Test"
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

    MiscIni := IniPath("Misc Data")
    IniWrite(A_Now, MiscIni, "Update", "Last Check")
}