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
Menu, Tray, Add, Set Hideout, SetHideout
Menu, Tray, Add, Move Overlay, Move
Menu, Tray, Add, Select Mechanics, SelectMechanics
Menu, Tray, Add, Select Auto Enable/Disable (Beta), SelectAuto
Menu, Tray, Add, Sound Settings, UpdateNotification
Menu, Tray, Add, Change Hotkey, HotkeyUpdate
Menu, Tray, Add, Change Theme, SelectTheme
Menu, Tray, Add, Launch Path of Exile, LaunchPoe
Menu, Tray, Add
Menu, Tray, Add, Reload Influences.ahk, ReloadInfluences
Menu, Tray, Add
Menu, Tray, Add, Reload, Reload
Menu, Tray, Add, Check for Updates, UpdateCheck
Menu, Tray, Add, View Log, ViewLog
Menu, Tray, Add, Exit, Exit
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
Global SearingOn
Global EaterOn

;;;;;;;;;;;;;;;;;;;;; Window Group ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GroupAdd, PoeWindow, ahk_exe PathOfExileSteam.exe
GroupAdd, PoeWindow, ahk_exe PathOfExile.exe 
GroupAdd, PoeWindow, ahk_exe PathOfExileEGS.exe
GroupAdd, PoeWindow, Reminder
GroupAdd, PoeWindow, Overlay

;;;;;;;;;;;;;;;;;;;;;;;;; Setup ;;;;;;;;;;;;;;;;;;;;;;;;;
Start:
MechanicSearch = Abyss|Blight|Breach|Expedition|Harvest|Incursion|Metamorph|Ritual|Generic|Eater|Searing

AutoMechanicSearch = Blight|Expedition|Incursion

GoSub, UpdateCheck
GoSub, GetLogPath

Gosub, CheckTheme

Gosub, GetHideout
GoSub, ReadMechanics
Gosub, ReadAutoMechanics
Gosub, Monitor

;;;;;;;;;;;;;;;;;;;;;;;;;;;; Sub Routines ;;;;;;;;;;;;;;;;;;;;;;;;

GetHideout:
FileReadLine, hideoutcheck, Resources/Settings/CurrentHideout.txt, 1
StringTrimLeft, MyHideout, hideoutcheck, 12 
Return

Monitor: ;Monitor for Path of Exile window to be active. This will hide the overlay if the window is inactive and activate it when active. 
Loop 
{
    IfWinActive, ahk_group PoeWindow
    {
        Gosub, Overlay
        {
            If (WarningActive = "Yes")
            {
                Gosub, Reminder
            }
            If (AutoMechanicsActive >= 1)
            {
                Gosub, LogMonitor
            }
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
If (LogPath != "")
{
    IniWrite, %LogPath%, Resources/Data/LaunchPath.ini, POE, log
}
Return

Gosub, LogMonitor
Return

Reload:
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
Return
GoSub, ReadMechanics
Gui, 2:Destroy
Gosub, Overlay
Return

LaunchPoe:
IniRead, PoeLaunch, Resources/Data/LaunchPath.ini, POE, exe
run, %PoeLaunch%
Return

HotkeyUpdate:
Run, Resources\Scripts\hotkeyselect.ahk
RunWait, Resources\Scripts\hotkeyselect.ahk
Gosub, ReloadInfluences
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

;;;;;;;;;;;;;;;;;Subroutines for each mechanic ;;;;;;;;;;;;;;;;;;
Abyss:
GoSub, MechanicsActive
{
if (AbyssActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Abyss
        Gui, 2:Destroy
        Gosub, Overlay
        Gosub, LogMonitor
        return
    }

if (AbyssActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Abyss
        Gui, 2:Destroy
        Gosub, Overlay
        return
    }
}

Blight:
GoSub, MechanicsActive
{
if (BlightActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Blight
        Gui, 2:Destroy
        Gosub, Overlay
        Gosub, LogMonitor
        return
    }

if (BlightActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Blight
        Gui, 2:Destroy
        Gosub, Overlay
        return
    }
}

Breach:
GoSub, MechanicsActive
{
if (BreachActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Breach
        Gui, 2:Destroy
        Gosub, Overlay
        Gosub, LogMonitor
        return
    }

if (BreachActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Breach
        Gui, 2:Destroy
        Gosub, Overlay
        return
    }
}

Expedition:
GoSub, MechanicsActive
{
if (ExpeditionActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Expedition
        Gui, 2:Destroy
        Gosub, Overlay
        Gosub, LogMonitor
        return
    }

if (ExpeditionActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Expedition
        Gui, 2:Destroy
        Gosub, Overlay
        return
    }
}

Incursion:
GoSub, MechanicsActive
{
if (IncursionActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Incursion
        Gui, 2:Destroy
        Gosub, Overlay
        Gosub, LogMonitor
        IncursionSleep = 0
        return
    }

if (IncursionActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Incursion
        Gui, 2:Destroy
        Gosub, Overlay
        return
    }
}

Metamorph:
GoSub, MechanicsActive
{
if (MetamorphActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Metamorph
        Gui, 2:Destroy
        Gosub, Overlay
        Gosub, LogMonitor
        return
    }

if (MetamorphActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Metamorph
        Gui, 2:Destroy
        Gosub, Overlay
        return
    }
}

Ritual:
GoSub, MechanicsActive
{
if (RitualActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Ritual
        Gui, 2:Destroy
        Gosub, Overlay
        Gosub, LogMonitor
        return
    }

if (RitualActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Ritual
        Gui, 2:Destroy
        Gosub, Overlay
        return
    }
}

Harvest:
GoSub, MechanicsActive
{
if (HarvestActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Harvest
        Gui, 2:Destroy
        Gosub, Overlay
        Gosub, LogMonitor
        return
    }

if (HarvestActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Harvest
        Gui, 2:Destroy
        Gosub, Overlay
        return
    }
}

Generic:
GoSub, MechanicsActive
{
if (GenericActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Generic
        Gui, 2:Destroy
        Gosub, Overlay
        Gosub, LogMonitor
        return
    }

if (GenericActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Generic
        Gui, 2:Destroy
        Gosub, Overlay
        return
    }
}

Eater:
IniRead, Eater, Resources/Settings/Mechanics.ini, InfluenceTrack, Eater
OldTrack := Eater
Eater ++
IniWrite, %Eater%, Resources/Settings/Mechanics.ini, InfluenceTrack, Eater
ControlSetText, %OldTrack%, %Eater%, Overlay
Return

Searing:
IniRead, Searing, Resources/Settings/Mechanics.ini, InfluenceTrack, Searing
OldTrack := Searing
Searing ++
IniWrite, %Searing%, Resources/Settings/Mechanics.ini, InfluenceTrack, Searing
ControlSetText, %OldTrack%, %Searing%, Overlay
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