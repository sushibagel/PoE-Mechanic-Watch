Global AutoMechanicState
Global ClientState
Global HideoutState
Global HotkeyState
Global LaunchAssistState
Global MechanicState
Global PositionState
Global MapPositionState
Global SoundState
Global ThemeState
Global ToolLauncherState
Global TransparencyState
Global ThemeSelect
Global HideoutSelect
Global MechanicSelect
Global PositionSelect
Global MapPositionSelect
Global TransparencySelect
Global AutoMechanicSelect
Global HotkeySelect
Global SoundSelect
Global LaunchAssistSelect
Global ToolLauncherSelect

GroupAdd, PoECheck, ahk_exe PathOfExileSteam.exe
GroupAdd, PoECheck, ahk_exe PathOfExile.exe 
GroupAdd, PoECheck, ahk_exe PathOfExileEGS.exe
GroupAdd, PoECheck, ahk_class POEWindowClass

CheckFirstRun() ;Check to see if all First Run Items are complete
{
    Global ItemSearch := "Client|Theme|Hideout|Mechanic|Position|MapPosition|AutoMechanic|Hotkey|Sound|LaunchAssist|Transparency|ToolLauncher"
    Global Item
    Global each
    FirstRunPath := FirstRunIni()
    For each, Item in StrSplit(ItemSearch, "|")
    {
        IniRead, %Item%State, %FirstRunPath%, Completion, %Item%
    }
    Return
}

FirstRun()
{
    PostSetup()
    LaunchPathIni := LaunchOptionsIni()
    IniRead, exe, %LaunchPathIni%, POE, EXE
    If !WinExist("Tail.ahk") and If InStr(exe, ".exe")
    {
        Run, Resources\Scripts\Tail.ahk
    }
    PostRestore()
    FirstRunPath := FirstRunIni()
    IniWrite, 1, %FirstRunPath%, Active, Active
    CheckFirstRun()
    GetHideout()
    Global yh := (A_ScreenHeight/2) -250
    Global xh := A_ScreenWidth/2
    Gui, First:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
    Gui, First:Color, %Background%
    Gui, First:Font, c%Font% s12
    Gui, First:Add, Text, w550 +Center, Welcome to PoE Mechanic Watch
    Gui, First: -Caption
    Gui, First:Show, NoActivate x%xh% y%yh% w550, First
    WinSet, Style, -0xC00000, First
    WinGetPos, X, Y, w, h, First
    Gui, First:Hide
    xh := xh - (w/2)
    yh1 := yh + h

    Gui, First2:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
    Gui, First2:Color, %Secondary%
    Gui, First2:Font, cBlack s10
    Gui, First2:Add, Text,, Before using PoE Mechanic Watch click each item below to set your preferences.
    Gui, First2:Add, Text,, Items with a * are required
    Gui, First2:Add, Checkbox, vClientOpened gClientOpen Checked%ClientState%, * Open your Path of Exile Client
    Gui, First2:Add, Checkbox, vThemeSelect gThemeSelect Checked%ThemeState%, %A_Space% Select your Theme
    IniFile := HideoutIni()
    If FileExist(IniFile)
    {
        HideoutSetup = Current Hideout: %MyHideout%
    }
    Else
    {
        HideoutSetup = 
    }

    Gui, First2:Add, Checkbox, vHideoutSelect gHideoutSelect Checked%HideoutState%, * Select your Hideout %HideoutSetup%
    Gui, First2:Add, Checkbox, vMechanicSelect gMechanicSelect Checked%MechanicState%, * Select the Mechanics you want to track
    Gui, First2:Add, Checkbox, vPositionSelect gPositionSelect Checked%PositionState%, %A_Space% Setup your overlay
    Gui, First2:Add, Checkbox, vMapPositionSelect gMapPositionSelect Checked%MapPositionState%, %A_Space% Select the position of the Map Notifications
    Gui, First2:Add, Checkbox, vTransparencySelect gTransparencySelect Checked%TransparencyState%, * Set the transparency of your overlays and notifications
    Gui, First2:Add, Checkbox, vAutoMechanicSelect gAutoMechanicSelect Checked%AutoMechanicState%, %A_Space% Select Auto Mechanics
    Gui, First2:Add, Checkbox, vHotkeySelect gHotkeySelect Checked%HotkeyState%, %A_Space% Modify Hotkeys (Highly recommended if you are using Influence tracking)
    Gui, First2:Add, Checkbox, vSoundSelect gSoundSelect Checked%SoundState%, %A_Space% Sound Settings
    Gui, First2:Add, Checkbox, vLaunchAssistSelect gLaunchAssistSelect Checked%LaunchAssistState%, %A_Space% Select applications/scripts/etc. to be launched alongside Path of Exile
    Gui, First2:Add, Checkbox, vToolLauncherSelect gToolLauncherSelect Checked%ToolLauncherState%, %A_Space% Quickly launch your favorite applications/scripts/websites
    Gui, First2:Add, Button, x490, Close
    Gui, First2: -Caption +HwndFirst2
    Gui, First2:Show, x%xh% y%yh1% w550, First2
    WinSet, Style, -0xC00000, First2

    Gui, First: -Caption +OwnerFirst2 ;;;;;; Intentionally here so that First2 is shown so it can own First
    Gui, First:Show, x%xh% y%yh% w550, First
    WinSet, Style, -0xC00000, First
    WinWaitClose, First2
    Return
}

ClientOpen()
{
    Gui, Submit, NoHide
    If (ClientOpened = 1)
    {
        Gui, First:Destroy
        Gui, First2:Destroy
        FirstRunPath := FirstRunIni()
        If !WinExist("ahk_group PoECheck")
        {
            Gui, FirstReminder:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
            Gui, FirstReminder:Color, %Background%
            Gui, FirstReminder:Font, c%Font% s10
            Gui, FirstReminder:Add, Text, w500 +Center, You must open Path of Exile to continue. This is required so the Client.txt path can be obtained. (This is only necessary for the first run)
            Gui, FirstReminder:Add, Button, x490, OK
            Gui, FirstReminder: +AlwaysOnTop -Caption
            yh := (A_ScreenHeight/2) -250
            xh := A_ScreenWidth/2
            Gui, FirstReminder:Show, NoActivate x%xh% y%yh% w550, FirstReminder
            Iniwrite, 0, %FirstRunPath%, Completion, Client
            WinWaitClose, FirstReminder
            CheckFirstRun()
            ReloadFirstRun()
        }
        IfWinExist, ahk_group PoeWindow
        {
            Iniwrite, 1, %FirstRunPath%, Completion, Client
            GetLogPath()
            ReloadFirstRun()
        }
    }
    Return
}

ThemeSelect()
{
    Gui, Submit, NoHide
    Gui, First:Destroy
    Gui, First2:Destroy
    SelectTheme()
    WinWaitClose, Gui:Theme
    FirstRunWrite("Theme")
    Return
}

HideoutSelect()
{
    Gui, Submit, NoHide
    Gui, First:Destroy
    Gui, First2:Hide
    SetHideout()
    Gui, First2:Destroy
    FirstRunWrite("Hideout")
    Return
}

MechanicSelect()
{
    Gui, Submit, NoHide
    Gui, First:Destroy
    Gui, First2:Destroy
    SelectMechanics()
    WinWaitClose, Mechanic
    FirstRunWrite("Mechanic")
    Return
}

PositionSelect()
{
    Gui, Submit, NoHide
    Gui, First:Destroy
    Gui, First2:Destroy
    OverlaySetup()
    WinWait, OverlaySetup
    WinwaitClose, OverlaySetup
    FirstRunWrite("Position")
    Return
}

MapPositionSelect()
{
    Gui, Submit, NoHide
    Gui, First:Destroy
    Gui, First2:Destroy
    MoveMap()
    WinWait, Influence
    WinwaitClose, Influence
    FirstRunWrite("MapPosition")
    Return
}

TransparencySelect()
{
    Gui, Submit, NoHide
    Gui, First:Destroy
    Gui, First2:Destroy
    UpdateTransparency()
    WinWaitClose, Transparency
    FirstRunWrite("Transparency")
    Return
}

AutoMechanicSelect()
{
    Gui, Submit, NoHide
    Gui, First:Destroy
    Gui, First2:Destroy
    SelectAuto()
    Winwaitclose, Auto Enable/Disable (Beta)
    Sleep, 100
    If WinExist("Mechanic")
    {
        Return
    }
    FirstRunWrite("AutoMechanic")
    Return
}


HotkeySelect()
{
    Gui, Submit, NoHide
    Gui, First:Destroy
    Gui, First2:Destroy
    HotkeyUpdate()
    Winwaitclose, Dynamic Hotkeys
    FirstRunWrite("Hotkey")
    Return
}

LaunchAssistSelect()
{
    Gui, Submit, NoHide
    Gui, First:Destroy
    Gui, First2:Destroy
    Gosub, LaunchGui
    WinWaitClose, Launcher
    FirstRunWrite("LaunchAssist")
    Return
}

SoundSelect()
{
    Gui, Submit, NoHide
    Gui, First:Destroy
    Gui, First2:Destroy
    UpdateNotification()
    WinWaitClose, Sounds
    FirstRunWrite("Sound")
    Return
}

ToolLauncherSelect()
{
    Gui, Submit, NoHide
    Gui, First:Destroy
    Gui, First2:Destroy
    Gosub, ToolLaunchGui
    WinWaitClose, ToolLauncher
    FirstRunWrite("ToolLauncher")
    Return
}

FirstRunWrite(WriteItem)
{
    FirstRunPath := FirstRunIni()
    Iniwrite, 1, %FirstRunPath%, Completion, % WriteItem
    ReloadFirstRun()
    Return
}

First2ButtonClose()
{
    FirstRunPath := FirstRunIni()
    IniWrite, 0, %FirstRunPath%, Active, Active
    Gui, Submit, NoHide
    Gui, First:Destroy
    Gui, First2:Destroy
    CheckFirstRun()
    If (%ClientState% = 0) or (%HideoutState% = 0) or (%MechanicState% = 0) or (%TransparencyState% = 0) or (%ClientState% = ERROR) or (%HideoutState% = ERROR) or (%MechanicState% = ERROR) or (%TransparencyState% = ERROR)
    {
        Gui, FirstWarning:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
        Gui, FirstWarning:Color, %Background%
        Gui, FirstWarning:Font, c%Font% s10
        Gui, FirstWarning:Add, Text, w530 +Center, You haven't gone through all the required setup processes, PoE Mechanic Watch may not function correctly until you do. 
        Gui, FirstWarning:Add, Button, y50 x50, I'll do it later
        Gui, FirstWarning:Add, Button, y50 x450, Go Back
        Gui, FirstWarning: +AlwaysOnTop -Caption
        Gui, FirstWarning:Show, NoActivate x%xh% y%yh% w550, FirstWarning
        WinWaitClose, FirstWarning
    }
    Else
    {
        Reload
    }
    Return
}

FirstReminderButtonOK()
{
    Gui, FirstReminder:Destroy
    Return
}

FirstWarningButtonI'lldoitlater:
Exit()
Return


FirstWarningButtonGoBack()
{
    Gui, FirstWarning:Destroy
    FirstRun()
    Return
}

ReloadFirstRun()
{
    CheckFirstRun() 
    Global CompletionCheck := ClientState + HideoutState + MechanicState + TransparencyState
    If (CompletionCheck >= 2)
    {
        FirstRun()
    }
    Else
    {
        Reload()
    }
    Return
}