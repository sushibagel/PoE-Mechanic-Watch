Global ArrCount

LaunchSupport() ;read ini file and launch each item
{
    LaunchPath := LaunchOptionsIni()
    ArrCount = 0
    FileRead, LaunchKeys, %LaunchPath%
    Loop, Parse, LaunchKeys, `n`r
    {
        if(Not Instr(A_LoopField, "="))
        Continue
        ArrCount++
        StringSplit, data, A_LoopField, =
        key%ArrCount% := data1
    }

    Loop, %ArrCount%
    {
        keyname := key%A_Index%
        IniRead, keyLaunchKeys, %LaunchPath%, Launch Options, %keyname%
        if !(KeyLaunchKeys = "ERROR")
        {
            run, % keyLaunchKeys
        }
    }
    Return
}

LaunchGui: ;Adds checkbox items to gui
LaunchIni := LaunchOptionsIni()
yh := (A_ScreenHeight/2) -150
xh := A_ScreenWidth/2
ArrCount = 0
FileRead, LaunchKeys, %LaunchIni%
Loop, Parse, LaunchKeys, `n`r
{
    if(Not Instr(A_LoopField, "="))
    Continue
    ArrCount++
    StringSplit, data, A_LoopField, =
    key%ArrCount% := data1
}
Gui, Launcher:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
Gui, Launcher:Color, %Background%
Gui, Launcher:Font, c%Font% s12
Gui, Launcher:Add, Text, +Center, Uncheck items to delete from launcher
Gui, Launcher: -Caption
Gui, Launcher:Font, c%Font% s10
Loop, %ArrCount%
{
    keyname := key%A_Index%
    IniRead, keyLaunchKeys, %LaunchIni%, Launch Options, %keyname%
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
    keyname := key%A_Index%
    IniRead, keyLaunchKeys, %LaunchIni%, Launch Options, %keyname%
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
        keyname := key%A_Index%
        IniRead, keyLaunchKeys, %LaunchPath%, Launch Options, %keyname%
        if !(KeyLaunchKeys = "ERROR")
        {
            IniDelete, %LaunchPath%, Launch Options, %keyname%
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
    FileRead, LaunchKeys, %LaunchPath%
    ArrCount = 0
    KeyCount = 0
    Loop, Parse, LaunchKeys, `n`r
    {
        if(Not Instr(A_LoopField, "="))
        Continue
        ArrCount++
        StringSplit, data, A_LoopField, =
        key%ArrCount% := data1
    }

    Loop, %ArrCount%
    {
        keyname := key%A_Index%
        IniRead, keyLaunchKeys, %LaunchPath%, Launch Options, %keyname%
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