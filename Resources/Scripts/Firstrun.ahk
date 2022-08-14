FirstRun:
Gosub, ReadItems
Gosub, GetHideout
yh := (A_ScreenHeight/2) -150
xh := A_ScreenWidth/2

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
yh2 := yh + h

Gui, First2:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
Gui, First2:Color, %Secondary%
Gui, First2:Font, cBlack s10
Gui, First2:Add, Text,, Before using PoE Mechanic Watch click each item below to set your preferences.
Gui, First2:Add, Text,, Items with a * are required
Gui, First2:Add, Checkbox, vClientOpened gClientOpen Checked%ClientState%, * Open your Path of Exile Client
Gui, First2:Add, Checkbox, vThemeSelect gThemeSelect Checked%ThemeState%, %A_Space% Select your Theme
HideouttxtPath = Resources\Settings\CurrentHideout.txt

If FileExist(HideouttxtPath)
{
    HideoutSetup = Current Hideout: %MyHideout%
}

Gui, First2:Add, Checkbox, vHideoutSelect gHideoutSelect Checked%HideoutState%, * Select your Hideout %HideoutSetup%
Gui, First2:Add, Checkbox, vMechanicSelect gMechanicSelect Checked%MechanicState%, * Select the Mechanics you want to track
Gui, First2:Add, Checkbox, vPositionSelect gPositionSelect Checked%PositionState%, %A_Space% Reposition your overlay
Gui, First2:Add, Checkbox, vTransparencySelect gTransparencySelect Checked%TransparencyState%, * Set the transparency of your overlays and notifications
Gui, First2:Add, Checkbox, vAutoMechanicSelect gAutoMechanicSelect Checked%AutoMechanicState%, %A_Space% Select Auto Mechanics
Gui, First2:Add, Checkbox, vHotkeySelect gHotkeySelect Checked%HotkeyState%, %A_Space% Modify Hotkeys (Highly recommended if you are using Influence tracking)
Gui, First2:Add, Checkbox, vLaunchAssistSelect gLaunchAssistSelect Checked%LaunchAssistState%, %A_Space% Select applications/scripts/etc. to be launched alongside Path of Exile
Gui, First2:Add, Checkbox, vSoundSelect gSoundSelect Checked%SoundState%, %A_Space% Sound Settings
Gui, First2:Add, Button, x490, Close
Gui, First2: -Caption +HwndFirst2
Gui, First2:Show, x%xh% y%yh2% w550, First2
WinSet, Style, -0xC00000, First2

Gui, First: -Caption +OwnerFirst2 ;;;;;; Intentionally here so that First2 is shown so it can own First
Gui, First:Show, x%xh% y%yh% w550, First
WinSet, Style, -0xC00000, First
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
        Gui, FirstReminder:Add, Text, w500 +Center, You must open Path of Exile to continue. This is required so the Client.txt path can be obtained. (This is only necessary for the first run)
        Gui, FirstReminder:Add, Button, x490, OK
        Gui, FirstReminder: +AlwaysOnTop -Caption
        Gui, FirstReminder:Show, NoActivate x%xh% y%yh% w550, FirstReminder
        Iniwrite, 0, Resources\Data\FirstRun.ini, Checkboxes, Client
        WinWaitClose, FirstReminder
        Gosub, ReadItems
        Gosub, ReloadCheck
    }
    IfWinExist, ahk_group PoeWindow
    {
        Iniwrite, 1, Resources\Data\FirstRun.ini, Checkboxes, Client
        GoSub, GetLogPath
        Gosub, ReloadCheck
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
Gosub, ReloadCheck
Return

HideoutSelect:
Gui, Submit, NoHide
Gui, First:Destroy
Gui, First2:Hide
RunWait, Resources\Scripts\HideoutUpdate.ahk
Gui, First2:Destroy
If FileExist(HideouttxtPath)
{
    Iniwrite, 1, Resources\Data\FirstRun.ini, Checkboxes, Hideout
}
Gosub, ReloadCheck
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
Gosub, ReloadCheck
Return

PositionSelect:
Gui, First:Hide
Gui, First2:Hide
Gui, Loading:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
Gui, Loading:Color, %Background%
Gui, Loading:Font, c%Font% s10
Gui, Loading:Add, Text, w500 +Center, The Overlay repositioning tool is loading... Please wait...
Gui, Loading: +AlwaysOnTop -Caption
yload := yh + 200
Gui, Loading:Show, NoActivate x%xh% y%yload% w550, Loading
GoSub, Start
Gui, Submit, NoHide
Gui, First:Destroy
Gui, First2:Destroy
Gosub, Move
WinWait, Move
Gui, Loading:Destroy
WinwaitClose, Move
Iniwrite, 1, Resources\Data\FirstRun.ini, Checkboxes, Position
Gosub, ReloadCheck
Return

TransparencySelect:
Gui, Submit, NoHide
Gui, First:Destroy
Gui, First2:Destroy
GoSub, UpdateTransparency
WinWaitClose, Transparency
Iniwrite, 1, Resources\Data\FirstRun.ini, Checkboxes, Transparency
Gosub, ReloadCheck
Return

AutoMechanicSelect:
Gui, Submit, NoHide
Gui, First:Hide
Gui, First2:Hide
Gosub, ReadAutoMechanics
Gosub, SelectAuto
Iniwrite, 1, Resources\Data\FirstRun.ini, Checkboxes, AutoMechanic
WinWaitClose, Auto Enable/Disable (Beta)
Gui, First:Destroy
Gui, First2:Destroy
Gosub, ReloadCheck
Return

HotkeySelect:
Gui, Submit, NoHide
Gui, First:Destroy
Gui, First2:Destroy
Gosub, HotkeyUpdate
Iniwrite, 1, Resources\Data\FirstRun.ini, Checkboxes, Hotkey
Gosub, ReloadCheck
Return

LaunchAssistSelect:
Gui, Submit, NoHide
Gui, First:Destroy
Gui, First2:Destroy
Gosub, LaunchGui
WinWaitClose, Launcher
Iniwrite, 1, Resources\Data\FirstRun.ini, Checkboxes, LaunchAssist
Gosub, ReloadCheck
Return

SoundSelect:
Gui, Submit, NoHide
Gui, First:Destroy
Gui, First2:Destroy
Gosub, UpdateNotification
WinWaitClose, Sounds
Iniwrite, 1, Resources\Data\FirstRun.ini, Checkboxes, Sound
Gosub, ReloadCheck
Return

First2ButtonClose:
Gui, Submit, NoHide
Gui, First:Destroy
Gui, First2:Destroy
Gosub, ReadItems
If (%ClientState% = 0) or (%HideoutState% = 0) or (%MechanicState% = 0) or (%TransparencyState% = 0)
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

ReadItems:
ItemSearch = Client|Theme|Hideout|Mechanic|Position|AutoMechanic|Hotkey|Sound|LaunchAssist|Transparency
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

ReloadCheck:
Gosub, ReadItems
CompletionCheck := ClientState + HideoutState + MechanicState + TransparencyState
If (CompletionCheck >= 2)
{
    Gosub, FirstRun
}
Else
{
    Reload
}
Return