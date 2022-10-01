#SingleInstance, force
#Persistent
#NoEnv
;#Warn

OnExit("Exit")
CoordMode, Screen
DetectHiddenWindows, On

OnMessage(0x01111, "RefreshOverlay")

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
Menu, SetupMenu, Add, Overlay Settings, OverlaySetup
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
Global LogPath

Global ColorMode
Global Background
Global Font
Global Secondary

Global ClientOpened
Global MyHideout
Global Mechanics

Global each
Global xh
Global yh
Global h
Global w
Global X
Global Y
Global sleepmechanic
Global Hotkey1
Global Height
Global Length
Global Width
Global keyLaunchKeys
Global keyname
Global data0
Global data1
Global BreakLoop
Global EndLoop
Global ActiveCheck
Global Item
Global Space
Global LaunchKeys
Global keyLaunchName

;;;;;;;;;;;;;;;;;;;;; Window Group ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GroupAdd, PoeWindow, ahk_exe PathOfExileSteam.exe
GroupAdd, PoeWindow, ahk_exe PathOfExile.exe 
GroupAdd, PoeWindow, ahk_exe PathOfExileEGS.exe
GroupAdd, PoeWindow, ahk_class POEWindowClass
GroupAdd, PoeWindow, Reminder
GroupAdd, PoeWindow, InfluenceReminder
GroupAdd, PoeWindow, Overlay
GroupAdd, PoeWindow, Move
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
    IniWrite, Horizontal, %OverlayIni%, Overlay Position, Orientation
    IniWrite, 50, %OverlayIni%, Size, Height
    IniWrite, 12, %OverlayIni%, Size, Font
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

; FirstRunIni := FirstRunIni()
; If FileExist(FirstRunIni) ;Check for "FirstRun" ini
; {
;     CheckFirstRun()
;     If (ClientState = "ERROR") or (HideoutState = "ERROR") or (MechanicState = "ERROR") or (TransparencyState = "Error") or (ClientState = 0) or (HideoutState = 0) or (MechanicState = 0) or (TransparencyState = 0) or (ClientState = "") or (HideoutState = "") or (MechanicState = "") or (TransparencyState = "")
;     {
;         FirstRun()
;     }
; }

; If !FileExist(FirstRunIni)
; {
;     FirstRun()
; }

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
    Return  
}

VariableIni := VariableIni()
If !FileExist(VariableIni) ;Check for "Variable" ini
{
    IniWrite, None, %VariableIni%, Map, Last Map
    IniWrite, None, %VariableIni%, Map, Last Seed
}

;;;;;;;;;;;;;;;; End Setup ;;;;;;;;;;;;;;;

IndexTrack =

UpdateCheck()
Start()
Return

Start()
{
    CheckTheme()
    HotkeyCheck()
    Run, Resources\Scripts\Tail.ahk
    Run, Resources\Scripts\NotificationMonitor.ahk
    Overlay()
}
Return

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
    ThemeFile := ThemeIni()
    IniWrite, Dark, %ThemeFile%, Theme, Theme
    CheckTheme()
    Return
}

ThemeButtonLightMode()
{
    Gui, Theme:Destroy
    ThemeFile := ThemeIni()
    IniWrite, Light, %ThemeFile%, Theme, Theme
    CheckTheme()
    Return
}

CheckTheme()
{
    Global ThemeItems := "Font|Background|Secondary"
    ThemeFile := ThemeIni()
    IniRead, ColorMode, %ThemeFile%, Theme, Theme
    Global Item
    Global each
    For each, Item in StrSplit(ThemeItems, "|")
    {
        IniRead, %Item%, %ThemeFile%, %ColorMode%, %Item%
    }
    Return, %ColorMode%
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

;;;;;;;;; Misc ;;;;;;;;;;;;;;;;;;;;;;;;;;;
LaunchPoe()
{
    LaunchOptionsIni := LaunchOptionsIni()
    IniRead, PoeLaunch, %LaunchOptionsIni%, POE, exe
    IniRead, PoeDir, %LaunchOptionsIni%, POE, Directory
    SetWOrkingDir, %PoeDir%
    run, %PoeLaunch%
    SetWorkingDir, %A_ScriptDir%
    LaunchSupport()
Return
}

ViewLog()
{
    LaunchOptionsIni := LaunchOptionsIni()
    IniRead, LogPath, %LaunchOptionsIni%, POE, Directory
    run, %LogPath%\logs
    Return
}

Changelog()
{
    Run, Resources\Scripts\Changelog.ahk
    Return
}

Feedback()
{
    Run, https://github.com/sushibagel/PoE-Mechanic-Watch/discussions
    Return
}

Version()
{
    Run, Resources\Scripts\Version.ahk
    Return
}

Reload()
{
    AdditionalScripts("Reload")
    Reload
    Return
}

Exit()
{
    AdditionalScripts("Exit")
    ExitApp
}

AdditionalScripts(Action)
{
   ScriptsActions := "\Resources\Scripts\Tail.ahk|\Resources\Scripts\NotificationMonitor.ahk|\Resources\Scripts\WindowMonitor.ahk"
   For each, script in StrSplit(ScriptsActions, "|")
   {
        If(Action = "Exit")
        {
            WinClose, %A_ScriptDir%%script% ahk_class AutoHotkey
        }
        If(Action = "Reload")
        {
            Run, %A_ScriptDir%%script%
        }
   }
   Return
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#Include, Resources\Scripts\AutoMechanic.ahk
#Include, Resources\Scripts\Firstrun.ahk
#Include, Resources\Scripts\HotkeySelect.ahk
#Include, Resources\Scripts\Ini.ahk
#Include, Resources\Scripts\Influences.ahk
#Include, Resources\Scripts\LaunchOptions.ahk
#Include, Resources\Scripts\Mechanics.ahk
#Include, Resources\Scripts\NotificationSounds.ahk
#Include, Resources\Scripts\Overlay.ahk
#Include, Resources\Scripts\OverlaySetup.ahk
#Include, Resources\Scripts\ToolLauncher.ahk
#Include, Resources\Scripts\Transparency.ahk
#Include, Resources\Scripts\UpdateCheck.ahk