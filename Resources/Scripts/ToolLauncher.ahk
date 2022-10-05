Global ToolAddress
Global ToolName

ToolLaunchGui:
LaunchIni := LaunchOptionsIni()
yh := (A_ScreenHeight/2) -150
wh := A_ScreenWidth/2
xh := (A_ScreenWidth/2)
ArrCount := CountTools()
Gui, ToolLauncher:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
Gui, ToolLauncher:Color, %Background%
Gui, ToolLauncher:Font, c%Font% s12
Gui, ToolLauncher:Add, Text, +Center, Uncheck items to delete from launcher
Gui, ToolLauncher:Add, GroupBox, h10 xn x10
Space = y+2
Gui, ToolLauncher: -Caption
Gui, ToolLauncher:Font, c%Font% s11
Loop, %ArrCount%
{
    IniRead, keyLaunchKeys, %LaunchIni%, User Tools, %A_Index%
    IniRead, keyLaunchName, %LaunchIni%, Tool Name, %A_Index%
    if !(KeyLaunchKeys = "ERROR")
    {
        Gui, ToolLauncher:Add, Button, xn x10 Section v%A_Index%Launch, Launch
        Gui, ToolLauncher:Add, Text, ys, %keyLaunchName%:
        Gui, ToolLauncher:Add, Checkbox, v%A_Index% Checked1 ys, % keyLaunchKeys
    }
}
Gui, ToolLauncher:Show, w%wh%,ToolLauncher
WinGetPos, X, Y, w, h, ToolLauncher
If (h < 85)
{
    h = 85
}
Gui, ToolLauncher:Destroy
Gui, ToolLauncher:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
Gui, ToolLauncher:Font, c%Font% s12
Gui, ToolLauncher:Add, Text, +Center w%wh%, Uncheck items to delete from launcher
Gui, ToolLauncher:Add, GroupBox, w%wh% h10 xn
Space = y+2
Gui, ToolLauncher: -Caption
Gui, ToolLauncher:Font, c%Font% s11
Loop, %ArrCount%
{
    IniRead, keyLaunchKeys, %LaunchIni%, User Tools, %A_Index%
    IniRead, keyLaunchName, %LaunchIni%, Tool Name, %A_Index%
    if !(KeyLaunchKeys = "ERROR")
    {
        Gui, ToolLauncher:Add, Button, xn x10 Section v%A_Index%Launch, Launch
        Gui, ToolLauncher:Add, Text, ys, %keyLaunchName%:
        Gui, ToolLauncher:Add, Checkbox, v%A_Index% Checked1 ys, % keyLaunchKeys
    }
}
xh := xh - (w/2)
yh2 := yh + h
h := h - 30
Gui, ToolLauncher:Add, GroupBox, w%w% h10 xn
Gui, ToolLauncher:Add, Text, xn x10 Section, Add New Tool
Gui, ToolLauncher:Font, c%Font% s9
Gui, ToolLauncher:Add, Text, ys, (This can be a local program or website)
Gui, ToolLauncher:Font, c%Font% s10
Gui, ToolLauncher:Add, Text, xs x10 Section, Tool Name:
Gui, ToolLauncher:Font, cBlack
Gui, ToolLauncher:Add, Edit, ys vToolName
Gui, ToolLauncher:Font, c%Font%
Gui, ToolLauncher:Add, Text, ys , Tool Address/Location:
Gui, ToolLauncher:Font, cBlack
ToolAddress = %ToolAddress%
Gui, ToolLauncher:Add, Edit, w150 ys vToolAddress, %ToolAddress%
Gui, ToolLauncher:Font, c%Font%
Gui, ToolLauncher:Add, Button, ys, Select File
Gui, ToolLauncher:Add, Button, ys Section, Submit
Gui, ToolLauncher:Add, Button, xn x20 Section, Close
Gui, ToolLauncher:Color, Edit, %Secondary%
Gui, ToolLauncher:Font, cBlack
Gui, ToolLauncher:Color, %Background%
Gui, ToolLauncher:Show, x%xh% y%yh% w%wh%, ToolLauncher
WinWaitClose, ToolLauncher
Return


ToolLauncherButtonClose()
{
    LaunchPath := LaunchOptionsIni()
    Gui, Submit, NoHide
    Gui, ToolLauncher:Destroy
    NewKey = 0
    ArrCount := CountTools()
    Loop, %ArrCount%
    {
        IniRead, keyLaunchKeys, %LaunchPath%, User Tools, %A_Index%
        IniRead, keyLaunchName, %LaunchPath%, Tool Name, %A_Index%
        if !(KeyLaunchKeys = "ERROR")
        {
            IniDelete, %LaunchPath%, User Tools, %A_Index%
            IniDelete, %LaunchPath%, Tool Name, %A_Index%
            If (%A_Index% = 1)
            {
                NewKey ++
                IniWrite, % keyLaunchKeys, %LaunchPath%, User Tools, %NewKey%
                IniWrite, % keyLaunchName, %LaunchPath%, Tool Name, %NewKey%
            }
        }
    }
    Return
}

ToolLauncherButtonSubmit()
{
    LaunchPath := LaunchOptionsIni()
    Gui, ToolLauncher:Submit, NoHide
    EnvGet,SysDrive,SystemDrive
    If ToolAddress contains %SysDrive%,www.,https:// ;Error check the input box
    {
        NewTool := StrSplit(ArrCount, ".", "0")
        NewTool := NewTool[1]
        NewTool ++
        IniWrite, %ToolAddress%, %LaunchPath%, User Tools, %NewTool%
        IniWrite, %ToolName%, %LaunchPath%, Tool Name, %NewTool%
        Gui, ToolLauncher:Destroy
        ToolAddress =
        Gosub, ToolLaunchGui
    }
    Else
    {
        yh := (A_ScreenHeight/2) -150
        xh := (A_ScreenWidth/2) - 225
        Gui, ToolLauncher:Destroy
        Gui, ToolLauncherWarning:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
        Gui, ToolLauncherWarning:Color, %Background%
        Gui, ToolLauncherWarning:Font, c%Font% s11
        Gui, ToolLauncherWarning:Add, Text, w530 +Center, You must use a valid drive path or web address (containing "www.").
        Gui, ToolLauncherWarning:Add, Button, y50 x50, OKAY
        Gui, ToolLauncherWarning: +AlwaysOnTop -Caption
        Gui, ToolLauncherWarning:Show, NoActivate x%xh% y%yh% w550, ToolLauncherWarning
        WinWaitClose, ToolLauncherWarning
        Gosub, ToolLaunchGui
    }
    Return
}

ToolLauncherWarningButtonOkay()
{
    Gui, ToolLauncherWarning:Destroy
    Return
}

ToolLauncherButtonSelectFile()
{
    Gui, Submit, NoHide
    Gui, ToolLauncher:Destroy
    FileSelectFile, ToolAddress, 1, %A_ScriptDir%, Please select any new file you would like to add to your launch options. 
    Gosub, ToolLaunchGui
    Return
}

ToolLauncherButtonLaunch()
{
    LaunchPath := LaunchOptionsIni()
    Gui, ToolLauncher:Submit, NoHide
    Loop, %ArrCount%
    {
        launch := % A_Index "Launch"
        If (A_GuiControl = launch)
        {
            IniRead, LaunchAddress, %LaunchPath%, User Tools, %A_Index%
            Run, %LaunchAddress%
            Gui, ToolLauncher:Destroy
        }
    }
    Return
}

CountTools()
{
    ArrCount := 0
    LaunchIni := LaunchOptionsIni()
    IniRead, SectionCount, %LaunchIni%, User Tools
    TotalTools := StrSplit(SectionCount, "`n")
    Return % TotalTools.MaxIndex()
}