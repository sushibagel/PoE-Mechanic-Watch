FirstRun:
Gosub, ReadItems
Gosub, GetHideout
yh := (A_ScreenHeight/2) -150
xh := A_ScreenWidth/2

Gui, First:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
Gui, First:Color, %Background%
Gui, First:Font, c%Font% s12
Gui, First:Add, Text, w550 +Center, Welcome to PoE Mechanic Watch
Gui, First: +AlwaysOnTop -Caption
Gui, First:Show, NoActivate x%xh% y%yh% w550, First
WinSet, Style, -0xC00000, First
WinGetPos, X, Y, w, h, First
Gui, First:Hide
xh := xh - (w/2)
yh2 := yh + h
Gui, First:Show, x%xh% y%yh% w550, First
WinSet, Style, -0xC00000, First
Gui, First2:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
Gui, First2:Color, %Secondary%
Gui, First2:Font, cBlack s10
Gui, First2:Add, Text,, Before using PoE Mechanic Watch click each item below to set your preferences.
Gui, First2:Add, Text,, Items with a * are required
Gui, First2:Add, Checkbox, vClientOpened gClientOpen Checked%ClientState%, * Open your Path of Exile Client
Gui, First2:Add, Checkbox, vThemeSelect gThemeSelect Checked%ThemeState%, Select your Theme
HideouttxtPath = Resources\Settings\CurrentHideout.txt

If FileExist(HideouttxtPath)
{
    HideoutSetup = Current Hideout: %MyHideout%
}

Gui, First2:Add, Checkbox, vHideoutSelect gHideoutSelect Checked%HideoutState%, * Select your Hideout %HideoutSetup%
Gui, First2:Add, Checkbox, vMechanicSelect gMechanicSelect Checked%MechanicState%, * Select the Mechanics you want to track
Gui, First2:Add, Checkbox, vPositionSelect gPositionSelect Checked%PositionState%, Reposition your overlay
Gui, First2:Add, Checkbox, vAutoMechanicSelect gAutoMechanicSelect Checked%AutoMechanicState%, Select Auto Mechanics
Gui, First2:Add, Checkbox, vHotkeySelect gHotkeySelect Checked%HotkeyState%, Modify Hotkeys (Highly recommended if you are using Influence tracking)
Gui, First2:Add, Checkbox, vLaunchAssistSelect gLaunchAssistSelect Checked%LaunchAssistState%, Select applications/scripts/etc. to be launched alongside Path of Exile
Gui, First2:Add, Checkbox, vSoundSelect gSoundSelect Checked%SoundState%, Sound Settings
Gui, First2:Add, Button, x490, Close
Gui, First2: +AlwaysOnTop -Caption
Gui, First2:Show, x%xh% y%yh2% w550, First2
WinSet, Style, -0xC00000, First2
WinWaitClose, First2
Return

ClientOpen:
Gui, Submit, NoHide
if !(%ClientOpened% = 0)
{
    Gui, First:Destroy
    Gui, First2:Destroy
    IfWinNotExist, ahk_group PoeWindow
    {
        Gui, FirstReminder:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
        Gui, FirstReminder:Color, %Background%
        Gui, FirstReminder:Font, c%Font% s10
        Gui, FirstReminder:Add, Text, w550 +Center, You must open Path of Exile to continue. This is required so the Client.txt path can be obtained. (This is only necessary for the first run)
        Gui, FirstReminder:Add, Button, x490, OK
        Gui, FirstReminder: +AlwaysOnTop -Caption
        Gui, FirstReminder:Show, NoActivate x%xh% y%yh% w550, FirstReminder
        Iniwrite, 0, Resources\Data\FirstRun.ini, Checkboxes, Client
        WinWaitClose, FirstReminder
        Gosub, FirstRun
    }
    IfWinExist, ahk_group PoeWindow
    {
        Iniwrite, 1, Resources\Data\FirstRun.ini, Checkboxes, Client
        GoSub, GetLogPath
        GoSub, FirstRun
    }
}
Return

ThemeSelect:
Gui, Submit, NoHide
Gui, First:Destroy
Gui, First2:Destroy
GoSub, SelectTheme
WinWaitClose, Gui:5
Iniwrite, 1, Resources\Data\FirstRun.ini, Checkboxes, Theme
GoSub, FirstRun
Return

HideoutSelect:
Gui, Submit, NoHide
Gui, First:Destroy
Gui, First2:Hide
RunWait, Resources\Scripts\HideoutUpdate.ahk
Gui, First2:Destroy
Gosub, FirstRun
If FileExist(HideouttxtPath)
{
    Iniwrite, 1, Resources\Data\FirstRun.ini, Checkboxes, Hideout
}
Return

MechanicSelect:
Gui, Submit, NoHide
Gui, First:Destroy
Gui, First2:Destroy
Gosub, SelectMechanics
MechanicsiniPath = Resources\Settings\Mechanics.ini
If FileExist(MechanicsiniPath)
{
    Iniwrite, 1, Resources\Data\FirstRun.ini, Checkboxes, Mechanic
}
Gosub, FirstRun
Return

PositionSelect:
GoSub, Start
Gui, Submit, NoHide
Gui, First:Destroy
Gui, First2:Destroy
Gosub, Move
Iniwrite, 1, Resources\Data\FirstRun.ini, Checkboxes, Position
Gosub, FirstRun
Return

AutoMechanicSelect:
Gui, Submit, NoHide
Gui, First:Hide
Gui, First2:Destroy
Gosub, ReadAutoMechanics
Gosub, SelectAuto
Iniwrite, 1, Resources\Data\FirstRun.ini, Checkboxes, AutoMechanic
WinWaitClose, Auto Enable/Disable (Beta)
Gui, First:Destroy
Gosub, FirstRun
Return

HotkeySelect:
Gui, Submit, NoHide
Gui, First:Destroy
Gui, First2:Destroy
Gosub, HotkeyUpdate
Iniwrite, 1, Resources\Data\FirstRun.ini, Checkboxes, Hotkey
Gosub, FirstRun
Return

SoundSelect:
Gui, Submit, NoHide
Gui, First:Destroy
Gui, First2:Destroy
Gosub, UpdateNotification
WinWaitClose, Sounds
Iniwrite, 1, Resources\Data\FirstRun.ini, Checkboxes, Sound
Gosub, FirstRun
Return


LaunchAssistSelect:
Gui, Submit, NoHide
Gui, First:Destroy
Gui, First2:Destroy
Gosub, LaunchGui
WinWaitClose, Launcher
Iniwrite, 1, Resources\Data\FirstRun.ini, Checkboxes, LaunchAssist
Gosub, FirstRun
Return

First2ButtonClose:
Gui, Submit, NoHide
Gui, First:Destroy
Gui, First2:Destroy
Gosub, ReadItems
If (%ClientState% = 0) or (%HideoutState% = 0) or (%MechanicState% = 0)
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
Return

ReadItems:
ItemSearch = Client|Theme|Hideout|Mechanic|Position|AutoMechanic|Hotkey|Sound|LaunchAssist
Loop, 1
For each, Item in StrSplit(ItemSearch, "|")
{
    iniRead, %Item%State, Resources\Data\FirstRun.ini, Checkboxes, %Item%
}
Return

FirstReminderButtonOK:
Gui, FirstReminder:Destroy
Return

FirstWarningButtonI'lldoitlater:
ExitApp
Return

FirstWarningButtonGoBack:
Gui, FirstWarning:Destroy
Gosub, FirstRun
Return