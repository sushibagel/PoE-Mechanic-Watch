UpdateCheck(*)
{
    VersionPath := IniPath("Version")
    VersionData := FileRead(VersionPath)
    VersionData := StrSplit(VersionData, "`r", "`n `t")
    MsgBox VersionData[1]



    
    MiscIni := IniPath("Misc Data")
    IniWrite(A_Now, MiscIni, "Update", "Last Check")
}