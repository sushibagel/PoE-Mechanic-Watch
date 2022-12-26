MavenTrack()
{
    VariablePath := VariableIni()
    IniRead, MavenMapActive, %VariablePath%, Map, Maven Map
    IniRead, CurrentMap, %VariablePath%, Map, Last Map
    If (MavenMapActive = "Yes")
    {
        MechanicsPath := MechanicsIni()
        IniRead, MavenCount, %MechanicsPath%, Influence Track, Maven
        If (MavenCount < 10)
        {
            MavenCount ++
            IniWrite, %MavenCount%, %MechanicsPath%, Influence Track, Maven
            RefreshOverlay()
            Loop, 10
            {
                IniRead, MavenMap%A_Index%, %MechanicsPath%, Maven Map, Maven Map %A_Index%
                MapCheck := "MavenMap"A_Index
                If (%MapCheck% = "") or (%MapCheck% = "ERROR")
                {
                    MavenMapNumber := A_Index
                    Break
                }
            }
            MechanicsPath := MechanicsIni()
            IniWrite, %CurrentMap%, %MechanicsPath%, Maven Map, Maven Map %MavenMapNumber%
        }
        IniWrite, No, %VariablePath%, Map, Maven Map
    }
}

ResetMaven()
{
    IniWrite, 0, %MechanicsPath%, Influence Track, Maven
    Return
}

; ViewMaven()
g::
{
    MechanicsIni := MechanicsIni()
    IniRead, FormedCompletion, %MechanicsIni%, The Formed
    yh := (A_ScreenHeight/2) -150
    wh := A_ScreenWidth/2
    xh := (A_ScreenWidth/2)
    ewh := wh - (wh/3.5)
    Gui, iniChoose:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
    Gui, iniChoose:Color, %Background%
    Gui, iniChoose:Font, c%Font% s12
    Gui, iniChoose:Add, GroupBox, h10 xn x10
    Space = y+2
    Gui, iniChoose: -Caption
    Gui, iniChoose:Font, c%Font% s11
    Gui, iniChoose:Show, w%wh%,iniChoose
    WinGetPos, X, Y, w, h, iniChoose
    If (h < 85)
    {
        h = 85
    }
    Gui, iniChoose:Destroy
    Gui, iniChoose:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
    Gui, iniChoose:Font, c%Font% s12
    Gui, iniChoose:Add, Text, +Center w%wh%, Maven Completion Status
    Gui, iniChoose:Font, c%Font% s8
    Gui, iniChoose:Add, Text, +Center w%wh%, Note: You can check/uncheck items to change the completion status. 
    Gui, iniChoose:Font, c%Font% s12
    Gui, iniChoose:Add, GroupBox, w%wh% h10 xn
    Space = y+2
    Gui, iniChoose: -Caption
    Gui, iniChoose:Font, c%Font% s11
    xh := xh - (w/2)
    yh2 := yh + h
    h := h - 30
    Gui, iniChoose:Font, c%Font% s10
    Gui, iniChoose:Add, Text, xs x10 Section, The Formed
    Gui, iniChoose:Font, c%Font% s9
    msgbox, %FormedCompletion%
    return
    Gui, Add, CheckBox, vShipToBillingAddress, Ship to billing address?

    Gui, iniChoose:Font, cBlack
    Gui, iniChoose:Add, Edit, ys vCurrentLocation w%ewh%, %CurrentLocation%
    Gui, iniChoose:Font, c%Font%
    Gui, iniChoose:Add, Button, ys, Select Location
    Gui, iniChoose:Add, Button, xn x20 Section, Close
    Gui, iniChoose:Color, %Background%
    Gui, iniChoose:Show, x%xh% y%yh% w%wh%, iniChoose
    WinWaitClose, iniChoose
    Return
}

iniChooseButtonClose()
{
    Gui, Submit, NoHide
    Gui, iniChoose:Destroy
    Return
}

iniChooseButtonSelectLocation()
{
    LocationIni := StorageIni()
    Gui, Submit, NoHide
    Gui, iniChoose:Destroy
    FileSelectFolder, NewLocation, 1, %A_ScriptDir%, Please select the parent folder you'd like for your settings files. 
    IniWrite, %NewLocation%, %LocationIni%, Settings Location, Location
    CopyFolder := CurrentLocation "\Resources\Settings\*.ini"
    NewSettings := NewLocation "\Resources\Settings"
    CopyData := CurrentLocation "\Resources\Data\*.ini"
    NewData := NewLocation "\Resources\Data"
    FileCreateDir, %NewSettings%
    FileCreateDir, %NewData%
    FileCopy, %CopyFolder%, %NewSettings%\*.ini
    FileCopy, %CopyData%, %NewData%\*.ini
    ; iniChoose()
    Return
}