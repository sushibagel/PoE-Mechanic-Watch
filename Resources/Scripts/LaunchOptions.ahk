Global ArrCount

LaunchSupport() ;read ini file and launch each item
{
    LaunchPath := LaunchOptionsIni()
    ArrCount := CountLauncher()
    Loop ArrCount
    {
        keyLaunchKeys := IniRead(LaunchPath, "Launch Options", A_Index)
        if !(KeyLaunchKeys = "ERROR")
        {
            Run(keyLaunchKeys)
        }
    }
    Return
}

LaunchGui() 
{ ; V1toV2: Added bracket
LaunchIni := LaunchOptionsIni()
yh := (A_ScreenHeight/2) -150
xh := A_ScreenWidth/2
ArrCount := CountLauncher()
Launcher := Gui()
Launcher.Opt("+E0x02000000 +E0x00080000") ; WS_EX_COMPOSITED WS_EX_LAYERED
Launcher.BackColor := Background
Launcher.SetFont("c" . Font . " s12")
Launcher.Add("Text", "+Center", "Uncheck items to delete from launcher")
Launcher.Opt("-Caption")
Launcher.SetFont("c" . Font . " s10")
Loop ArrCount
{
    keyLaunchKeys := IniRead(LaunchIni, "Launch Options", A_Index)
    if !(KeyLaunchKeys = "ERROR")
    {
        ogcCheckbox := Launcher.Add("Checkbox", "v" . A_Index . " Checked1", keyLaunchKeys)
    }
}
Launcher.Title := "Launcher"
Launcher.Show()
WinGetPos(&X, &Y, &w, &h, "Launcher")
If (h < 85)
{
    h := "85"
}
Launcher.Destroy()
Launcher.Opt("+E0x02000000 +E0x00080000") ; WS_EX_COMPOSITED WS_EX_LAYERED
Launcher.BackColor := Background
Launcher.SetFont("c" . Font . " s12")
Launcher.Add("Text", "+Center", "Uncheck items to delete from launcher")
Launcher.Opt("-Caption")
Launcher.SetFont("c" . Font . " s10")
Loop ArrCount
{
    keyLaunchKeys := IniRead(LaunchIni, "Launch Options", A_Index)
    if !(KeyLaunchKeys = "ERROR")
    {
        ogcCheckbox := Launcher.Add("Checkbox", "v" . A_Index . " Checked1", keyLaunchKeys)
    }
}
xh := xh - (w/2)
yh2 := yh + h
h := h - 30
ogcButtonAccept := Launcher.Add("Button", "xn x50 Section", "Accept")
ogcButtonAccept.OnEvent("Click", LauncherButtonAccept.Bind("Normal"))
ogcButtonSelectFile := Launcher.Add("Button", "ys x170", "Select File")
ogcButtonSelectFile.OnEvent("Click", LauncherButtonSelectFile.Bind("Normal"))
Launcher.Title := "Launcher"
Launcher.Show("x" . xh . " y" . yh)
Return
} ; V1toV2: Added bracket before function


LauncherButtonAccept()
{
    oSaved := Launcher.Submit("0")
     := oSaved.
     := oSaved.
    Launcher.Destroy()
    LaunchPath := LaunchOptionsIni()
    NewKey := "0"
    Loop ArrCount
    {
        keyLaunchKeys := IniRead(LaunchPath, "Launch Options", A_Index)
        if !(KeyLaunchKeys = "ERROR")
        {
            IniDelete(LaunchPath, "Launch Options", A_Index)
            If (%A_Index% = 1)
            {
                NewKey ++
                IniWrite(keyLaunchKeys, LaunchPath, "Launch Options", NewKey)
            }
        }
    }
    Return
}

LauncherButtonSelectFile()
{
    oSaved := Launcher.Submit("0")
     := oSaved.
     := oSaved.
    Launcher.Destroy()
    LaunchOptions := FileSelect(1, A_ScriptDir, "Please select any new file you would like to add to your launch options.")
    KeyCount := "0"
    ArrCount := CountLauncher()
    LaunchPath := LaunchOptionsIni()
    Loop ArrCount
    {
        keyLaunchKeys := IniRead(LaunchPath, "Launch Options", A_Index)
        if !(KeyLaunchKeys = "ERROR")
        {
            KeyCount++
        }
    }
    KeyCount++
    IniWrite(LaunchOptions, LaunchPath, "Launch Options", KeyCount)
    LaunchGui()
    Return
}

CountLauncher()
{
    ArrCount := 0
    LaunchIni := LaunchOptionsIni()
    SectionCount := IniRead(LaunchIni, "Launch Options")
    TotalTools := StrSplit(SectionCount, "`n")
    Return TotalTools.MaxIndex()
}