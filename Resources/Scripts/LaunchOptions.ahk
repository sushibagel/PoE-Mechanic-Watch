Global ArrCount

LaunchSupport() ;read ini file and launch each item
{
    LaunchPath := LaunchOptionsIni()
    ArrCount := CountLauncher()
    Loop, %ArrCount%
    {
        IniRead, keyLaunchKeys, %LaunchPath%, Launch Options, %A_Index%
        if !(KeyLaunchKeys = "ERROR")
        {
            run, % keyLaunchKeys
        }
    }
    Return
}

LaunchGui: 
LaunchIni := LaunchOptionsIni()
yh := (A_ScreenHeight/2) -150
xh := A_ScreenWidth/2
ArrCount := CountLauncher()
Gui, Launcher:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
Gui, Launcher:Color, %Background%
Gui, Launcher:Font, c%Font% s12
Gui, Launcher:Add, Text, +Center, Uncheck items to delete from launcher
Gui, Launcher: -Caption
Gui, Launcher:Font, c%Font% s10
Loop, %ArrCount%
{
    IniRead, keyLaunchKeys, %LaunchIni%, Launch Options, %A_Index%
    if !(KeyLaunchKeys = "ERROR")
    {
        Gui, Launcher:Add, Checkbox, v%A_Index% Checked1, % keyLaunchKeys
    }
}
Gui, Launcher:Show,,Launcher
WinGetPos, X, Y, w, h, Launcher
If (h < 85)
{
    h = 85
}
Gui, Launcher:Destroy
Gui, Launcher:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
Gui, Launcher:Color, %Background%
Gui, Launcher:Font, c%Font% s12
Gui, Launcher:Add, Text, +Center, Uncheck items to delete from launcher
Gui, Launcher: -Caption
Gui, Launcher:Font, c%Font% s10
Loop, %ArrCount%
{
    IniRead, keyLaunchKeys, %LaunchIni%, Launch Options, %A_Index%
    if !(KeyLaunchKeys = "ERROR")
    {
        Gui, Launcher:Add, Checkbox, v%A_Index% Checked1, % keyLaunchKeys
    }
}
xh := xh - (w/2)
yh2 := yh + h
h := h - 30
Gui, Launcher:Add, Button, xn x50 Section, Accept
Gui, Launcher:Add, Button, ys x170, Select File
Gui, Launcher:Show, x%xh% y%yh%, Launcher
Return


LauncherButtonAccept()
{
    Gui, Submit, NoHide
    Gui, Launcher:Destroy
    LaunchPath := LaunchOptionsIni()
    NewKey = 0
    Loop, %ArrCount%
    {
        IniRead, keyLaunchKeys, %LaunchPath%, Launch Options, %A_Index%
        if !(KeyLaunchKeys = "ERROR")
        {
            IniDelete, %LaunchPath%, Launch Options, %A_Index%
            If (%A_Index% = 1)
            {
                NewKey ++
                IniWrite, % keyLaunchKeys, %LaunchPath%, Launch Options, %NewKey%
            }
        }
    }
    Return
}

LauncherButtonSelectFile()
{
    Gui, Submit, NoHide
    Gui, Launcher:Destroy
    FileSelectFile, LaunchOptions, 1, %A_ScriptDir%, Please select any new file you would like to add to your launch options. 
    KeyCount = 0
    ArrCount := CountLauncher()
    LaunchPath := LaunchOptionsIni()
    Loop, %ArrCount%
    {
        IniRead, keyLaunchKeys, %LaunchPath%, Launch Options, %A_Index%
        if !(KeyLaunchKeys = "ERROR")
        {
            KeyCount++
        }
    }
    KeyCount++
    IniWrite, %LaunchOptions%, %LaunchPath%, Launch Options, %KeyCount%
    Gosub, LaunchGui
    Return
}

CountLauncher()
{
    ArrCount := 0
    LaunchIni := LaunchOptionsIni()
    IniRead, SectionCount, %LaunchIni%, Launch Options
    TotalTools := StrSplit(SectionCount, "`n")
    Return % TotalTools.MaxIndex()
}