#SingleInstance, force
#Persistent
#NoEnv
#Warn,,OutputDebug
CoordMode, Screen
DetectHiddenWindows, On

;;;;;;;;;;;;;; Tray Menu ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Menu, Tray, NoStandard
Menu, Tray, Add, Select Mechanics, SelectMechanics
Menu, Tray, Add, Select Auto Enable/Disable (Beta), SelectAuto
Menu, Tray, Add, Launch Path of Exile, LaunchPoe
Menu, Tray, Add, View Path of Exile Log, ViewLog
Menu, Tray, Add
Menu, SetupMenu, Add, Setup Menu, FirstRun
Menu, Tray, Add, Setup, :SetupMenu
Menu, SetupMenu, Add, Set Hideout, SetHideout
Menu, SetupMenu, Add, Change Theme, SelectTheme
Menu, SetupMenu, Add, Move Overlay, Move
Menu, SetupMenu, Add, Set Transparency, UpdateTransparency
Menu, SetupMenu, Add, Change Hotkey, HotkeyUpdate
Menu, SetupMenu, Add, Sound Settings, UpdateNotification
Menu, SetupMenu, Add, Launch Assist, LaunchGui
Menu, SetupMenu, Add, Tool Launcher, ToolLaunchGui
Menu, Tray, Add
Menu, Tray, Add, Reload, Reload
Menu, Tray, Add
Menu, Tray, Add, Check for Updates, UpdateCheck
Menu, Tray, Add, Exit, Exit
Menu, AboutMenu, Add, Version, Version
Menu, Tray, Add, About, :AboutMenu
Menu, AboutMenu, Add, Changelog, Changelog
Menu, AboutMenu, Add, Q&&A/Feedback, Feedback
Menu, Tray, Icon, Resources\Images\ritual.png

;;;;;;;;;;;;;;;;;;;;;;;;;; Global Variables ;;;;;;;;;;;;;;;;;;;;;
Global ThemeSelect
Global HideoutSelect
Global MechanicSelect
Global PositionSelect
Global TransparencySelect
Global AutoMechanicSelect
Global HotkeySelect
Global SoundSelect
Global LaunchAssistSelect
Global ToolLauncherSelect

Global ColorMode
Global Background
Global Font
Global Secondary
Global ClientOpened
Global MyHideout
Global Mechanics

Global AutoMechanicState
Global ClientState
Global HideoutState
Global HotkeyState
Global LaunchAssistState
Global MechanicState
Global PositionState
Global SoundState
Global ThemeState
Global ToolLauncherState
Global TransparencyState

;;;;;;;;;;;;;;;;;;;;; Window Group ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GroupAdd, PoeWindow, ahk_exe PathOfExileSteam.exe
GroupAdd, PoeWindow, ahk_exe PathOfExile.exe 
GroupAdd, PoeWindow, ahk_exe PathOfExileEGS.exe
GroupAdd, PoeWindow, ahk_class POEWindowClass
GroupAdd, PoeWindow, ahk_class AutoHotkeyGUI
GroupAdd, PoeWindow, ahk_exe Awakened PoE Trade.exe
GroupAdd, PoeWindow, ahk_exe code.exe

;;;;;;;;;;;;;;;;;;;;;;;;; Check for Ini Files ;;;;;;;;;;;;;;;;;;
ThemeIni := ThemeIni()
If !FileExist(ThemeIni) ;Check for "Theme" ini
{
    If !FileExist("Resources\Settings")
    {
        FileCreateDir, Resources\Settings
    }
    IniWrite, White, %ThemeIni%, Dark, Font
    IniWrite, 4e4f53, %ThemeIni%, Dark, Background
    IniWrite, a6a6a6, %ThemeIni%, Dark, Secondary
    IniWrite, Black, %ThemeIni%, Light, Font
    IniWrite, White, %ThemeIni%, Light, Background
    IniWrite, ededed, %ThemeIni%, Light, Secondary
    IniWrite, Dark, %ThemeIni%, Theme, Theme
}

CheckTheme()
OverlayIni := OverlayIni()
If !FileExist(OverlayIni) ;Check for "Overlay" ini
{
    IniWrite, 962, %OverlayIni%, Overlay Position, Height
    IniWrite, 570, %OverlayIni%, Overlay Position, Width
}

HotkeyIni := HotkeyIni()
Blank :=
If !FileExist(HotkeyIni)
{
    Loop, 12
    {
        IniWrite, %blank%, %HotkeyIni%, Hotkeys, %A_Index% 
    }
}

NotificationIni := NotificationIni()
If !FileExist(NotificationIni) ;Check for "Notification" ini
{
    ReminderWav := "Resources\Sounds\reminder.wav"
    IniWrite, %ReminderWav%, %NotificationIni%, Sounds, Notification
    IniWrite, %ReminderWav%, %NotificationIni%, Sounds, Influence
    IniWrite, 0, %NotificationIni%, Active, Notification
    IniWrite, 0, %NotificationIni%, Active, Influence
    IniWrite, 100, %NotificationIni%, Volume, Notification
    IniWrite, 100, %NotificationIni%, Volume, Influence
}

MechanicsIni := MechanicsIni()
If !FileExist(MechanicsIni) ;Check for "Mechanics" ini
{
    Mechanics := Mechanics()
    For each, Item in StrSplit(Mechanics, "|")
    {
        IniWrite, 0, %MechanicsIni%, Mechanics, %Item%
        IniWrite, 0, %MechanicsIni%, Mechanic Active, %Item%
    }
    AutoMechanics := AutoMechanics()
    For each, Item in StrSplit(AutoMechanics, "|")
    {
        IniWrite, 0, %MechanicsIni%, Auto Mechanics, %Item%
    }
    Influences := Influences()
    For each, Item in StrSplit(Influences, "|")
    {
        IniWrite, 0, %MechanicsIni%, Influence, %Item%
        IniWrite, 0, %MechanicsIni%, Influence Track, %Item%
    }
}

FirstRunIni := FirstRunIni()
If FileExist(FirstRunIni) ;Check for "FirstRun" ini
{
    CheckFirstRun()
    If (ClientState = "ERROR") or (HideoutState = "ERROR") or (MechanicState = "ERROR") or (TransparencyState = "Error") or (ClientState = 0) or (HideoutState = 0) or (MechanicState = 0) or (TransparencyState = 0) or (ClientState = "") or (HideoutState = "") or (MechanicState = "") or (TransparencyState = "")
    {
        FirstRun()
    }
}

If !FileExist(FirstRunIni)
{
    FirstRun()
}

LaunchOptionIni := LaunchOptionsIni()
If !FileExist(LaunchOptionIni) ;Check for "Launch options" ini
{
    MsgBox,, Launch Path of Exile, Please launch Path of Exile for the script to continue loading
    WinWait, ahk_Group PoeWindow
}

HideoutIni := HideoutIni()
If !FileExist(HideoutIni) ;Check for "Hideout" ini
{
GroupAdd, FirstRunGroup, First2
GroupAdd, FirstRunGroup, Move
    IfWinNotActive, ahk_Group FirstRunGroup
    {
        FirstRunIni := FirstRunIni()
        IniRead, FirstrunHideout, %FirstRunIni%, Completion, Hideout
        If (FirstrunHideout = 1)
        {
            SetHideout()
        }
    }    
}

Return

;;;;;;;;;;;;;;;;;;;;;;Variable Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Influences() ;List of Influences
{
    Return, "Eater|Searing"
}

AutoMechanics()
{
    Return, "Blight|Expedition|Incursion"
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; First Run Section ;;;;;;;;;;;;;;;;;

CheckFirstRun() ;Check to see if all First Run Items are complete
{
    Global ItemSearch := "Client|Theme|Hideout|Mechanic|Position|AutoMechanic|Hotkey|Sound|LaunchAssist|Transparency|ToolLauncher"
    Global Item
    Global each
    FirstRunIni := FirstRunIni()
    For each, Item in StrSplit(ItemSearch, "|")
    {
        iniRead, %Item%State, %FirstRunIni%, Completion, %Item%
    }
    Return
}

FirstRun()
{
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
    Global xh := xh - (w/2)
    global yh2 := yh + h

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
    Gui, First2:Add, Checkbox, vPositionSelect gPositionSelect Checked%PositionState%, %A_Space% Reposition your overlay
    Gui, First2:Add, Checkbox, vTransparencySelect gTransparencySelect Checked%TransparencyState%, * Set the transparency of your overlays and notifications
    Gui, First2:Add, Checkbox, vAutoMechanicSelect gAutoMechanicSelect Checked%AutoMechanicState%, %A_Space% Select Auto Mechanics
    Gui, First2:Add, Checkbox, vHotkeySelect gHotkeySelect Checked%HotkeyState%, %A_Space% Modify Hotkeys (Highly recommended if you are using Influence tracking)
    Gui, First2:Add, Checkbox, vSoundSelect gSoundSelect Checked%SoundState%, %A_Space% Sound Settings
    Gui, First2:Add, Checkbox, vLaunchAssistSelect gLaunchAssistSelect Checked%LaunchAssistState%, %A_Space% Select applications/scripts/etc. to be launched alongside Path of Exile
    Gui, First2:Add, Checkbox, vToolLauncherSelect gToolLauncherSelect Checked%ToolLauncherState%, %A_Space% Quickly launch your favorite applications/scripts/websites
    Gui, First2:Add, Button, x490, Close
    Gui, First2: -Caption +HwndFirst2
    Gui, First2:Show, x%xh% y%yh2% w550, First2
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
    if !(ClientOpened = 0)
    {
        Gui, First:Destroy
        Gui, First2:Destroy
        FirstRunIni := FirstRunIni()
        IfWinNotExist, ahk_group PoeWindow
        {
            Gui, FirstReminder:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
            Gui, FirstReminder:Color, %Background%
            Gui, FirstReminder:Font, c%Font% s10
            Gui, FirstReminder:Add, Text, w500 +Center, You must open Path of Exile to continue. This is required so the Client.txt path can be obtained. (This is only necessary for the first run)
            Gui, FirstReminder:Add, Button, x490, OK
            Gui, FirstReminder: +AlwaysOnTop -Caption
            Gui, FirstReminder:Show, NoActivate x%xh% y%yh% w550, FirstReminder
            Iniwrite, 0, %FirstRunIni%, Completion, Client
            WinWaitClose, FirstReminder
            CheckFirstRun()
            ReloadFirstRun()
        }
        IfWinExist, ahk_group PoeWindow
        {
            Iniwrite, 1, %FirstRunIni%, Completion, Client
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
    ReloadFirstRun()
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
    ReloadFirstRun()
    Return
}

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
Start()
Gui, Submit, NoHide
Gui, First:Destroy
Gui, First2:Destroy
OverlayMove()
WinWait, Move
Gui, Loading:Destroy
WinwaitClose, Move
FirstRunWrite("Position")
Return

TransparencySelect()
{
    Gui, Submit, NoHide
    Gui, First:Destroy
    Gui, First2:Destroy
    UpdateTransparency()
    WinWaitClose, Transparency
    FirstRunWrite("Transparency")
    ReloadFirstRun()
    Return
}

AutoMechanicSelect()
{
    Gui, Submit, NoHide
    Gui, First:Hide
    Gui, First2:Hide
    ReadAutoMechanics()
    SelectAuto()
    FirstRunWrite("AutoMechanic")
    WinWaitClose, Auto Enable/Disable (Beta)
    Gui, First:Destroy
    Gui, First2:Destroy
    ReloadFirstRun()
    Return
}


HotkeySelect()
{
    Gui, Submit, NoHide
    Gui, First:Destroy
    Gui, First2:Destroy
    HotkeyUpdate()
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
    FirstRunIni := FirstRunIni()
    Iniwrite, 1, %FirstRunIni%, Completion, % WriteItem
    ReloadFirstRun()
    Return
}

First2ButtonClose()
{
    Gui, Submit, NoHide
    Gui, First:Destroy
    Gui, First2:Destroy
    CheckFirstRun()
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
}

FirstReminderButtonOK()
{
    Gui, FirstReminder:Destroy
    Return
}

FirstWarningButtonI'lldoitlater:
ExitApp
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
        Reload
    }
    Return
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Settings Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GetLogPath() ;;;;; Get client and log paths ;;;;;;;;;;;;
{
    WinGet, POEpath, ProcessPath, Path of Exile

    IfInstring, POEpath, PathOfExileSteam.exe
    {
        StringTrimRight, POEPathTrim, POEpath, 20
    }

    IfInstring, POEpath, PathOfExile_x64Steam.exe
    {
        StringTrimRight, POEPathTrim, POEpath, 23
    }

    IfInstring, POEpath, Client.exe
    {
        StringTrimRight, POEPathTrim, POEpath, 10
    }

    IfInstring, POEpath, PathOfExile.exe
    {
        StringTrimRight, POEPathTrim, POEpath, 15
    }

    IfInstring, POEpath, PathOfExile_x64.exe
    {
        StringTrimRight, POEPathTrim, POEpath, 18
    }

    IfInstring, POEpath, PathOfExileEGS.exe
    {
        StringTrimRight, POEPathTrim, POEpath, 18 
    }

    IfInstring, POEpath, PathOfExile_x64EGS.exe
    {
        StringTrimRight, POEPathTrim, POEpath, 21 
    }

    LogPath = %POEPathTrim%logs\Client.txt
    If (LogPath != "logs\Client.txt")
    {
        IniWrite, %LogPath%, Resources\Data\LaunchPath.ini, POE, log
        IniWrite, %POEPathTrim%, Resources\Data\LaunchPath.ini, POE, Directory
    }
    If (LogPath = "logs\Client.txt")
    {
        IniRead, LogPath, Resources\Data\LaunchPath.ini, POE, log
    }
    Return
}

;;;;;;;;;;;;;;;;;;;;;;; Theme ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SelectTheme()
{
    Gui, Theme:-Border
    Gui, Theme:Color, %Secondary%
    Gui, Theme:-Caption
    Gui, Theme:Font, c%Font% s10
    Gui, Theme:Add, Button, x+10 yp+10 w90 h30, Dark Mode
    Gui, Theme:Add, Picture, yn y10 Section ,Resources/Images/Dark Theme/Dark Reminder.png
    Gui, Theme:Add, Picture, xs ,Resources/Images/Dark Theme/Dark Notification Selector.png
    Gui, Theme:Add, Picture, ys ,Resources/Images/Dark Theme/Dark Mechanic Selector.png
    Gui, Theme:Add, Picture, xs Section ,Resources/Images/Dark Theme/Dark Hotkey.png
    Gui, Theme:Add, Picture, yn y10 ,Resources/Images/Dark Theme/Dark Hideout Select.png
    Gui, Theme:Add, GroupBox, w900 h10 xn x10
    Gui, Theme:Add, Button, x10 y+10 w90 h30 Section , Light Mode
    Gui, Theme:Add, Picture, ys Section ,Resources//Images/Light Theme/Light Reminder.png
    Gui, Theme:Add, Picture, xs ,Resources/Images/Light Theme/Light Notification Selector.png
    Gui, Theme:Add, Picture, ys ,Resources/Images/Light Theme/Light Mechanic Selector.png
    Gui, Theme:Add, Picture, xs ,Resources/ImageReturns/Light Theme/Light Hotkey.png
    Gui, Theme:Add, Picture, ys ,Resources/Images/Light Theme/Light Hideout Select.png
    Gui, Theme:Show,,Gui:Theme
    Return
}

ThemeButtonDarkMode()
{    
    Gui, Theme:Destroy
    ThemeIni := ThemeIni()
    IniWrite, Dark, %ThemeIni%, Theme, Theme
    CheckTheme()
    Return
}

ThemeButtonLightMode()
{
    Gui, Theme:Destroy
    ThemeIni := ThemeIni()
    IniWrite, Light, %ThemeIni%, Theme, Theme
    CheckTheme()
    Return
}

CheckTheme()
{
    Global ThemeItems := "Font|Background|Secondary"
    ThemeIni := ThemeIni()
    IniRead, ColorMode, %ThemeIni%, Theme, Theme
    Global Item
    Global each
    For each, Item in StrSplit(ThemeItems, "|")
    {
        IniRead, %Item%, %ThemeIni%, %ColorMode%, %Item%
    }
    Return
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Hideout ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SetHideout()
{
    RunWait, Resources\Scripts\HideoutUpdate.ahk
    Return
}

GetHideout()
{
    IniFile := HideoutIni()
    IniRead, MyHideout, % IniFile, Current Hideout, MyHideout
    Return
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Hotkey Selector ;;;;;;;;;;;;;;;;;;;;;

HotkeyUpdate()
{
    RunWait, Resources\Scripts\hotkeyselect.ahk
    Return
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Transparency Selector ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Global OverlayEdit
Global NotificationEdit
Global InfluenceEdit
Global MapEdit
Global PlayColor

UpdateTransparency()
{
    CheckTheme()
    TransparencyIni := TransparencyIni()
    OverlayList := GetOverlayItems()
    Space = y+5
    Gui, Transparency:Font, c%Font% s11
    Gui, Transparency:Add, Text, w350 +Center, Select the desired opacity for each Overlay Type
    Gui, Transparency:Add, Text, %Space% w350 +Center, Opacity can any value 0 (Invisible) to 255 (Opaque)
    Gui, Transparency:Color, Edit, %Secondary% -Caption -Border
    Gui, Transparency:Color, %Background% 
    Gui, Transparency:Add, GroupBox, w350 h10 xn x10
    Space = y+2
    If (ColorMode = "Dark")
    {
        RefreshColor = refresh white.png
        PlayColor = play white.png
        StopColor = stop white.png
    }
    If (ColorMode = "Light")
    {
        RefreshColor = refresh.png
        PlayColor = play.png
        StopColor = stop.png
    }
    For each, OverlayItem in StrSplit(OverlayList, "|")
    {
        Space := 40 + (A_Index * 10)
        IniRead, %OverlayItem%Value, %TransparencyIni%, Transparency, %OverlayItem%, 255
        Gui, Transparency:Font, c%Font% s12
        ItemText = %OverlayItem%
        If (OverlayItem = "Map")
        {
            ItemText = Map Notification
        }
        If (OverlayItem = "Notification")
        {
            ItemText = Mechanic Notification
        }
        If (OverlayItem = "Influence")
        {
            ItemText = Invitation Reminder
        }
        Gui, Transparency:Add, Text, xn x20 Section, %ItemText% 
        Gui, Transparency:Font, cBlack s10
        Value := %OverlayItem%Value
        Gui, Transparency:Add, Edit, Center v%OverlayItem%Edit ys x200 w50
        Gui, Transparency:Add, UpDown, Range0-255, %Value% ;;;; 0 = invisible 255 = Opaque 
        Gui, Transparency:Add, Picture, g%OverlayItem%Test w25 h25 ys, Resources/Images/%PlayColor%
        Gui, Transparency:Add, Picture, g%OverlayItem%Test w25 h25 ys, Resources/Images/%RefreshColor%
        Gui, Transparency:Add, Picture, g%OverlayItem%Stop w25 h25 ys, Resources/Images/%StopColor%
    }   
    Gui, Transparency:-Caption -Border
    Gui, Transparency:Add, Button, xn x270 w80 h30, OK
    Gui, Transparency:Show, w375, Transparency
    Return
}

TransparencyButtonOk()
{
    Gui, Transparency:Submit, NoHide 
    OverlayList := GetOverlayItems()
    TransparencyIni := TransparencyIni()
    For each, OverlayItem in StrSplit(OverlayList, "|")
    {
        Edit := %OverlayItem%Edit
        IniWrite, %Edit%, %TransparencyIni%, Transparency, %OverlayItem%
    }
    Gui, Influence:Destroy
    Gui, Reminder:Destroy
    Gui, 1:Destroy
    Gui, 2:Destroy
    Gui, Transparency:Destroy
    ReadTransparency()
    Return
}

GetOverlayItems()
{
    Return, "Overlay|Notification|Influence|Map"
}


ReadTransparency()
{
    OverlayList := GetOverlayItems()
    TransparencyIni := TransparencyIni()
    For each, OverlayItem in StrSplit(OverlayList, "|")
    {
        IniRead, %OverlayItem%Transparency, %TransparencyIni%, Transparency, %OverlayItem%, 255
    }
}
Return

OverlayTest()
{
    Return
}

OverlayStop()
{
    Return
}

NotificationTest()
{
    Return
}

NotificationStop()
{
    Return
}

InfluenceTest()
{
    Return
}

InfluenceStop()
{
    Return
}

MapTest()
{
    Return
}

MapStop()
{
    Return
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Auto Mechanic Selector ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
OverlayMove()
{
    Return
}

HideoutUpdate()
{
    Return
}

Start()
{
    Return
}

LaunchPoe()
{
    Return
}

ViewLog()
{
    Return
}

Move()
{
    Return
}

Reload()
{
    Reload
}

UpdateCheck()
{
    Return
}

Exit()
{
    ExitApp
}

Version()
{
    Return
}

Changelog()
{
    Return
}

Feedback()
{
    Return
}

MechanicsActive()
{
    Return
}

InfluenceActive()
{
    Return
}

#Include, Resources\Scripts\AutoMechanic.ahk
#Include, Resources\Scripts\LaunchOptions.ahk
#Include, Resources\Scripts\Mechanics.ahk
#Include, Resources\Scripts\NotificationSounds.ahk
#Include, Resources\Scripts\Overlay.ahk
#Include, Resources\Scripts\ToolLauncher.ahk
#Include, Resources\Scripts\Ini.ahk