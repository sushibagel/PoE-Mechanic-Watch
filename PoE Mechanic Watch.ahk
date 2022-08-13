;;;;; List of things to do to add a new mechanic. ;;;;;;;;
;Add mechanic specific global variables
;Add the mechanic to the "MechanicSearch" variable
;Add mechanic specific sub routines
;Add mechanic in MechanicSelector.ahk

#SingleInstance, force
#Persistent
#NoEnv
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
Menu, Tray, Add
Menu, Tray, Add, Reload Influences, ReloadInfluences
Menu, Tray, Add, Reload, Reload
Menu, Tray, Add
Menu, Tray, Add, Check for Updates, UpdateCheck
Menu, Tray, Add, Exit, Exit
Menu, AboutMenu, Add, Version, Version
Menu, Tray, Add, About, :AboutMenu
Menu, AboutMenu, Add, Changelog, Changelog
Menu, AboutMenu, Add, Q&&A/Feedback, Feedback
Menu, Tray, Icon, Resources/Images/ritual.png

;;;;;;;;;;;;;;;;;;;;;;;;;; Global Variables ;;;;;;;;;;;;;;;;;;;;;
Global MyHideout
Global LogPath
Global MechanicSearch
Global AutoMechanicSearch
Global AutoMechanicsActive
Global WarningActive
Global MechanicsActive
Global height
Global width
Global sleepmechanic
Global NotificationSound
Global NotificationActive
Global ColorMode
Global Background
Global Secondary
Global Font
Global Hk2
Global iniFile
Global iniSection
Global PoeID
Global MyDialogsDisable
Global MyDialogs
Global Hideout
Global LogWait

;;;;;;;;;;;;;;;;;;;;;;;;;; Mechanic Globals ;;;;;;;;;;;;;;;;;;;;;
Global AbyssOn
Global BlightOn
Global BreachOn
Global ExpeditionOn
Global HarvestOn
Global IncursionOn
Global MetamorphOn
Global RitualOn
Global GenericOn
Global AbyssActive
Global BlightActive
Global BreachActive
Global ExpeditionActive
Global HarvestActive
Global IncursionActive
Global MetamorphActive
Global RitualActive
Global GenericActive
Global BlightAuto
Global ExpeditionAuto
Global IncursionAuto
Global BlightSleep
Global ExpeditionSleep
Global IncursionSleep
Global IncursionGo
Global SearingOn
Global EaterOn

;;;;;;;;;;;;;;;;;;;;; Window Group ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GroupAdd, PoeWindow, ahk_exe PathOfExileSteam.exe
GroupAdd, PoeWindow, ahk_exe PathOfExile.exe 
GroupAdd, PoeWindow, ahk_exe PathOfExileEGS.exe
GroupAdd, PoeWindow, Reminder
GroupAdd, PoeWindow, Overlay
GroupAdd, PoeWindow, First2

;;;;;;;;;;;;;;;;;;;;;;;;; Check for Ini Files ;;;;;;;;;;;;;;;;;;

Gosub, LaunchGlobals

ThemeiniPath = Resources\Settings\Theme.ini

If !FileExist(ThemeiniPath)
{
    If !FileExist("Resources\Settings")
    {
        FileCreateDir, Resources\Settings
    }
	IniWrite, White, Resources\Settings\Theme.ini, Dark, Font
    IniWrite, 4e4f53, Resources\Settings\Theme.ini, Dark, Background
    IniWrite, a6a6a6, Resources\Settings\Theme.ini, Dark, Secondary
    IniWrite, Black, Resources\Settings\Theme.ini, Light, Font
    IniWrite, White, Resources\Settings\Theme.ini, Light, Background
    IniWrite, ededed, Resources\Settings\Theme.ini, Light, Secondary
    IniWrite, Dark, Resources\Settings\Theme.ini, Theme, Theme
}

Gosub, CheckTheme

PositiontxtPath = Resources\Settings\overlayposition.txt

If !FileExist(PositiontxtPath)
{
    FileAppend, height=962 `n, Resources/Settings/overlayposition.txt
    FileAppend, width=570, Resources/Settings/overlayposition.txt
}

HokeyiniPath = Resources\Settings\Hotkeys.ini

If !FileExist(HokeyiniPath)
{
	IniWrite, "#^+r", Resources/Settings/Hotkeys.ini, Hotkeys, 1 ;Defaults to an intentionally obscure combo to avoid clashing with other peoples hotkeys. Needed a default to avoid errors. 
    IniWrite, "#^q", Resources/Settings/Hotkeys.ini, Hotkeys, 2 ;Defaults to an intentionally obscure combo to avoid clashing with other peoples hotkeys. Needed a default to avoid errors. 
    Hotkey, #^q, LaunchPoe
}

NotificationiniPath = Resources\Settings\notification.ini

If !FileExist(NotificationiniPath)
{
	IniWrite, Resources\Sounds\reminder.wav, Resources\Settings\notification.ini, Sounds, Notification
    IniWrite, Resources\Sounds\reminder.wav, Resources\Settings\notification.ini, Sounds, Influence
    IniWrite, 0, Resources\Settings\notification.ini, Active, Notification
    IniWrite, 0, Resources\Settings\notification.ini, Active, Influence
    IniWrite, 100, Resources\Settings\notification.ini, Volume, Notification
    IniWrite, 100, Resources\Settings\notification.ini, Volume, Influence
}

MechanicsiniPath = Resources\Settings\Mechanics.ini

If !FileExist(MechanicsiniPath)
{
	IniWrite, 0, Resources\Settings\Mechanics.ini, Checkboxes, Abyss
    IniWrite, 0, Resources\Settings\Mechanics.ini, Checkboxes, Blight
    IniWrite, 0, Resources\Settings\Mechanics.ini, Checkboxes, Breach
    IniWrite, 0, Resources\Settings\Mechanics.ini, Checkboxes, Expedition
    IniWrite, 0, Resources\Settings\Mechanics.ini, Checkboxes, Harvest
    IniWrite, 0, Resources\Settings\Mechanics.ini, Checkboxes, Incursion
    IniWrite, 0, Resources\Settings\Mechanics.ini, Checkboxes, Metamorph
    IniWrite, 0, Resources\Settings\Mechanics.ini, Checkboxes, Ritual
    IniWrite, 0, Resources\Settings\Mechanics.ini, Checkboxes, Generic
    IniWrite, 0, Resources\Settings\Mechanics.ini, Influence, Searing
    IniWrite, 0, Resources\Settings\Mechanics.ini, Influence, Eater
    IniWrite, 0, Resources\Settings\Mechanics.ini, InfluenceTrack, Searing
    IniWrite, 0, Resources\Settings\Mechanics.ini, InfluenceTrack, Eater
}

FirstruniniPath = Resources\Data\Firstrun.ini
If FileExist(FirstruniniPath)
{
    Gosub, ReadItems
    If (ClientState = "ERROR") or (HideoutState = "ERROR") or (MechanicState = "ERROR") or (ClientState = 0) or (HideoutState = 0) or (MechanicState = 0)
    {
        Gosub, FirstRun
    }
}
If !FileExist(FirstruniniPath)
{
    Gosub, FirstRun
}

LaunchiniPath = Resources\Data\LaunchPath.ini

If !FileExist(LaunchiniPath)
{
    MsgBox,, Launch Path of Exile, Please launch Path of Exile for the script to continue loading
    WinWait, ahk_Group PoeWindow
}

AutoiniPath = Resources\Settings\AutoMechanics.ini

If !FileExist(AutoiniPath)
{
	IniWrite, 0, Resources\Settings\AutoMechanics.ini, Checkboxes, Blight
    IniWrite, 0, Resources\Settings\AutoMechanics.ini, Checkboxes, Expedition
    IniWrite, 0, Resources\Settings\AutoMechanics.ini, Checkboxes, Incursion
}

HideouttxtPath = Resources\Settings\CurrentHideout.txt

If !FileExist(HideouttxtPath)
{
GroupAdd, FirstRunGroup, First2
GroupAdd, FirstRunGroup, Move

    IfWinNotActive, ahk_Group FirstRunGroup
    {
        IniRead, FirstrunHideout, Resources\Data\FirstRun.ini, Checkboxes, Hideout
        If (FirstrunHideout = 1)
        {
            Gosub, SetHideout
        }
    }    
}

ActiveiniPath = Resources\Data\MechanicsActive.ini

If !FileExist(ActiveiniPath)
{
    IniWrite, 0, %ActiveiniPath%, Active, Abyss
    IniWrite, 0, %ActiveiniPath%, Active, Blight
    IniWrite, 0, %ActiveiniPath%, Active, Breach
    IniWrite, 0, %ActiveiniPath%, Active, Expedition
    IniWrite, 0, %ActiveiniPath%, Active, Harvest
    IniWrite, 0, %ActiveiniPath%, Active, Incursion
    IniWrite, 0, %ActiveiniPath%, Active, Metamorph
    IniWrite, 0, %ActiveiniPath%, Active, Ritual
    IniWrite, 0, %ActiveiniPath%, Active, Generic
}
;;;;;;;;;;;;;;;;;;;;;;;;; Setup ;;;;;;;;;;;;;;;;;;;;;;;;;
Start:
MechanicSearch = Abyss|Blight|Breach|Expedition|Harvest|Incursion|Metamorph|Ritual|Generic|Eater|Searing

GoSub, UpdateCheck
GoSub, GetLogPath
Gosub, CheckTheme
Gosub, HotkeyCheck
Gosub, GetHideout
GoSub, ReadMechanics
Gosub, ReadAutoMechanics
Gosub, LaunchGlobals
Gosub, ReadTransparency
Gosub, Monitor

;;;;;;;;;;;;;;;;;;;;;;;;;;;; Sub Routines ;;;;;;;;;;;;;;;;;;;;;;;;

GetHideout:
FileReadLine, hideoutcheck, Resources/Settings/CurrentHideout.txt, 1
StringTrimLeft, MyHideout, hideoutcheck, 12 
MyHideout = %MyHideout% ;Remove extra space that for some reason occurs. 
Return

Monitor: ;Monitor for Path of Exile window to be active. This will hide the overlay if the window is inactive and activate it when active. 
Loop 
{
    IfWinActive, ahk_group PoeWindow
    {
        
        Gosub, Overlay
        If (AutoMechanicsActive >= 1)
        {
            Gosub, LogMonitor
        }
    }

    IfWinNotActive, ahk_group PoeWindow
    {
        Sleep, 200
        IfWinNotActive, ahk_group PoeWindow
        {
            Gui, 2:Destroy
        }
    }
    IfWinExist, First
    {
        Return
    }
}

ReadMechanics:
Loop, 1
For each, Mechanic in StrSplit(MechanicSearch, "|")
{
    IniRead, %Mechanic%, Resources\Settings\Mechanics.ini, Checkboxes, %Mechanic%
    If (%Mechanic% = 1)
    %Mechanic%On := 1
    If (%Mechanic% = 0)
    %Mechanic%On := 0
}
SetTitleMatchMode, 2
FileRead, Influences, Resources/Data/Influences.txt
Loop, 1
For each, Influence in StrSplit(Influences, "|")
{
    IniRead, %Influence%, Resources/Settings/Mechanics.ini, Influence, %Influence%
    If (%Influence% = 1)
    %Influence%On := 1
    If (%Influence% = 0)
    %Influence%On := 0
}
IfWinNotExist, Influences.ahk
{
    Run, %A_ScriptDir%\Resources\Scripts\Influences.ahk
}


If (SearingOn = 0) and (EaterOn = 0)
{
    IfWinExist, Influences.ahk
    {
        WinClose, Resources\Scripts\Influences.ahk ahk_class AutoHotkey
    }
}
SetTitleMatchMode, 1
Return

MechanicsActive:
MechanicsActive = 0
Loop, 1
For each, Mechanic in StrSplit(MechanicSearch, "|")
{
    IniRead, %Mechanic%, Resources\Data\MechanicsActive.ini, Active, %Mechanic%
    If (%Mechanic% = 1)
    {
        %Mechanic%Active := 1
        MechanicsActive ++
    }
    If (%Mechanic% = 0)
    %Mechanic%Active := 0
}
Return

GetLogPath:
WinGet, POEpath, ProcessPath, Path of Exile

If (POEPath != "")
{
    IniWrite, %POEpath%, Resources/Data/LaunchPath.ini, POE, exe
}

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
    IniWrite, %LogPath%, Resources/Data/LaunchPath.ini, POE, log
    IniWrite, %POEPathTrim%, Resources/Data/LaunchPath.ini, POE, Directory
}
Return

Gosub, LogMonitor
Return

Reload:
Gosub, ExitInfluences
Sleep, 500
Run, %A_ScriptDir%\Resources\Scripts\Influences.ahk
Reload
Return

Exit:
Gosub, ExitInfluences
ExitApp
Return

SetHideout:
Run, Resources\Scripts\HideoutUpdate.ahk
Return

ViewLog:
run, %POEPathTrim%logs
Return

SelectMechanics:
RunWait, Resources\Scripts\MechanicSelector.ahk
SetTitleMatchMode, 2
WinClose, Resources\Scripts\Influences.ahk ahk_class AutoHotkey
SetTitleMatchMode, 1
Sleep, 500
Run, %A_ScriptDir%\Resources\Scripts\Influences.ahk
GoSub, ReadMechanics
Gui, 2:Destroy
Gosub, Overlay
Return

LaunchPoe:
IniRead, PoeLaunch, Resources/Data/LaunchPath.ini, POE, exe
IniRead, PoeDir, Resources/Data/LaunchPath.ini, POE, Directory
SetWOrkingDir, %PoeDir%
run, %PoeLaunch%
SetWorkingDir, %A_ScriptDir%
Gosub, LaunchSupport
Return

HotkeyUpdate:
IniWrite, 1, Resources/Settings/Hotkeys.ini, Reload, Influences
Gosub, ReloadInfluences
IniRead, Hotkey2, Resources/Settings/Hotkeys.ini, Hotkeys, 2
If !(Hotkey2 = "")
{
    Hotkey, %Hotkey2%, Off
}
Run, Resources\Scripts\hotkeyselect.ahk
RunWait, Resources\Scripts\hotkeyselect.ahk
Gosub, ReloadInfluences
Gosub, HotkeyCheck
Return

HotkeyCheck:
IniRead, Hotkey2, Resources/Settings/Hotkeys.ini, Hotkeys, 2
If !(Hotkey2 = "")
{
    Hotkey, %Hotkey2%, LaunchPoe
}
Return

ReloadInfluences:
SetTitleMatchMode, 2
WinClose, Resources\Scripts\Influences.ahk ahk_class AutoHotkey
SetTitleMatchMode, 1
Run, %A_ScriptDir%\Resources\Scripts\Influences.ahk
Return

ExitInfluences:
SetTitleMatchMode, 2
WinClose, Resources\Scripts\Influences.ahk ahk_class AutoHotkey
SetTitleMatchMode, 1
Return

CheckTheme:
IniRead, ColorMode, Resources/Settings/Theme.ini, Theme, Theme
IniRead, Font, Resources/Settings/Theme.ini, %ColorMode%, Font
IniRead, Background, Resources/Settings/Theme.ini, %ColorMode%, Background
IniRead, Secondary, Resources/Settings/Theme.ini, %ColorMode%, Secondary
Return

Version:
Run, Resources\Scripts\Version.ahk
Return

Changelog:
Run, Resources\Scripts\Changelog.ahk
Return

Feedback:
Run, https://github.com/sushibagel/PoE-Mechanic-Watch/discussions
Return

;;;;;;;;;;;;;;;;;Subroutines for each mechanic ;;;;;;;;;;;;;;;;;;
ToggleOn:
Gui, 2:Destroy
Gosub, Overlay
Gosub, LogMonitor
Return

ToggleOff:
Gui, 2:Destroy
WarningActive = No
Gosub, Overlay
Return

Abyss:
GoSub, MechanicsActive
{
if (AbyssActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Abyss
        Gosub, ToggleOn
        Return
    }

if (AbyssActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Abyss
        Gosub, ToggleOff
        Return
    }
}

Blight:
GoSub, MechanicsActive
{
if (BlightActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Blight
        Gosub, ToggleOn
        Return
    }

if (BlightActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Blight
        Gosub, ToggleOff
        Return
    }
}

Breach:
GoSub, MechanicsActive
{
if (BreachActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Breach
        Gosub, ToggleOn
        Return
    }

if (BreachActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Breach
        Gosub, ToggleOff
        Return
    }
}

Expedition:
GoSub, MechanicsActive
{
if (ExpeditionActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Expedition
        Gosub, ToggleOn
        Return
    }

if (ExpeditionActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Expedition
        Gosub, ToggleOff
        Return
    }
}

Incursion:
GoSub, MechanicsActive
{
if (IncursionActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Incursion
        Gosub, ToggleOn
        IncursionSleep = 1
        Return
    }

if (IncursionActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Incursion
        Gosub, ToggleOff
        IncursionSleep = 0
        Return
    }
}

Metamorph:
GoSub, MechanicsActive
{
if (MetamorphActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Metamorph
        Gosub, ToggleOn
        Return
    }

if (MetamorphActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Metamorph
        Gosub, ToggleOff
        Return
    }
}

Ritual:
GoSub, MechanicsActive
{
if (RitualActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Ritual
        Gosub, ToggleOn
        Return
    }

if (RitualActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Ritual
        Gosub, ToggleOff
        Return
    }
}

Harvest:
GoSub, MechanicsActive
{
if (HarvestActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Harvest
        Gosub, ToggleOn
        Return 
    }

if (HarvestActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Harvest
        Gosub, ToggleOff
        Return
    }
}

Generic:
GoSub, MechanicsActive
{
if (GenericActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Generic
        Gosub, ToggleOn
        Return
    }

if (GenericActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Generic
        Gosub, ToggleOff
        Return
    }
}

Eater:
IniRead, Eater, Resources/Settings/Mechanics.ini, InfluenceTrack, Eater
OldTrack := Eater
Eater ++
If(Eater = 29)
{
    Eater = 0
}
IniWrite, %Eater%, Resources/Settings/Mechanics.ini, InfluenceTrack, Eater
ControlSetText, %OldTrack%, %Eater%, Overlay
Return

Searing:
IniRead, Searing, Resources/Settings/Mechanics.ini, InfluenceTrack, Searing
OldTrack := Searing
Searing ++
If(Searing = 29)
{
    Searing = 0
}
IniWrite, %Searing%, Resources/Settings/Mechanics.ini, InfluenceTrack, Searing
ControlSetText, %OldTrack%, %Searing%, Overlay
Return

CloseGui:
Return

NotificationSound:
Return

ReminderLoop:
Return
;;;;;;;;;;;;;;;; Include Scripts ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#Include, Resources/Scripts/tf.ahk
#Include, Resources/Scripts/UpdateCheck.ahk
#Include, Resources/Scripts/Overlay.ahk
#Include, Resources/Scripts/Reminder.ahk
#Include, Resources/Scripts/Move.ahk
#Include, Resources/Scripts/AutoMechanic.ahk
#Include, Resources/Scripts/LogMonitor.ahk
#Include, Resources/Scripts/SelectTheme.ahk
#Include, Resources/Scripts/VolumeAdjust.ahk
#Include, Resources/Scripts/Firstrun.ahk
#Include, Resources/Scripts/LaunchOptions.ahk
#Include, Resources/Scripts/Transparency.ahk
#Include, Resources/Scripts/ReminderGui.ahk
#Include, Resources/Scripts/Tail.ahk
#IncludeAgain, Resources/Scripts/MapNotification.ahk
#IncludeAgain, Resources/Scripts/EldritchReminder.ahk