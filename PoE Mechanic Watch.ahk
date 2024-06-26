#SingleInstance, force
#Persistent
#NoEnv
#MaxMem 1024
#Requires AutoHotkey >=1.1.36 <2
;#Warn

OnExit("Exit")
CoordMode, Screen
DetectHiddenWindows, On

OnMessage(0x01111, "RefreshOverlay")
OnMessage(0x012222, "OverlayKill")
OnMessage(0x012229, "MasterOverlayKill")
OnMessage(0x01786, "Start")
OnMessage(0x01741, "HotkeyCheck") ;check hotkeys
OnMessage(0x01783, "LaunchUpdate") ;timed update on PoE launch
OnMessage(0x01789, "Reload") ;timed update on PoE launch
OnMessage(0x204, "WM_RBUTTONDOWN")
OnMessage(0x01775, "MapDevice") ;Launch Map Device Search

;;;;;;;;;;;;;; Tray Menu ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IniRead, StorageLocation, Resources\Settings\StorageLocation.ini, Settings Location, Location
If (StorageLocation = "A_ScriptDir")
    {
        StorageLocation := A_ScriptDir
    }
IniRead, Theme, %StorageLocation%\Resources\Settings\Theme.ini, Theme, Theme, Light
If (Theme = "Dark")
{
    isDark := 2
}
If (Theme = "Light")
{
    isDark := 3
}

MenuDark(isDark)

; Create the menu here

; 0=Default  1=AllowDark  2=ForceDark  3=ForceLight  4=Max
Menu, Tray, NoStandard
Menu, Tray, Add, Select Mechanics, SelectMechanics
Menu, Tray, Add, Select Auto Enable/Disable, SelectAuto
Menu, Tray, Add, View Maven Invitation Status, ViewMaven
Menu, Tray, Add
Menu, Tray, Add, Launch Path of Exile, LaunchPoe
Menu, Tray, Add, View Path of Exile Log, ViewLog
Menu, Tray, Add
Menu, SetupMenu, Add, Setup Menu, FirstRun
Menu, SetupMenu, Add
Menu, Tray, Add, Setup, :SetupMenu
Menu, SetupMenu, Add, Set Hideout, SetHideout
Menu, SetupMenu, Add, Map Reminder Settings, MapSettings
Menu, SetupMenu, Add
Menu, SetupMenu, Add, Calibrate Search, AutoButtonCalibrateSearch
Menu, SetupMenu, Add
Menu, SetupMenu, Add, Change Theme, SelectTheme
Menu, SetupMenu, Add, Change Hotkey, HotkeyUpdate
Menu, SetupMenu, Add
Menu, SetupMenu, Add, Overlay Settings, OverlaySetup
Menu, SetupMenu, Add, Move Overlay, Move
Menu, SetupMenu, Add, Move Quick Notification, MoveMap
Menu, SetupMenu, Add
Menu, SetupMenu, Add, Notification Settings, NotificationSetup
Menu, SetupMenu, Add
Menu, SetupMenu, Add, Launch Assist, LaunchGui
Menu, SetupMenu, Add, Tool Launcher, ToolLaunchGui
Menu, SetupMenu, Add
Menu, SetupMenu, Add, Choose Settings File Location, iniChoose
Menu, Tray, Default, Setup
Menu, SetupMenu, Default, Setup Menu
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

MenuDark(Dark) {
    ;https://stackoverflow.com/a/58547831/894589
    static uxtheme := DllCall("GetModuleHandle", "str", "uxtheme", "ptr")
    static SetPreferredAppMode := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 135, "ptr")
    static FlushMenuThemes := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 136, "ptr")

    DllCall(SetPreferredAppMode, "int", Dark) ; 0=Default  1=AllowDark  2=ForceDark  3=ForceLight  4=Max
    DllCall(FlushMenuThemes)
}
;;;;;;;;;;;;;;;;;;;;;;;;;; Global Variables ;;;;;;;;;;;;;;;;;;;;;
Global LogPath

Global ColorMode
Global Background
Global Font
Global Secondary
Global Icons
Global CustomBackground
Global CustomFont
Global CustomSecondary
Global CustomIcon
Global SecondaryProgress
Global BackgroundProgress
Global FontProgress

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
Global IgnoreNotificationKey

;;;;;;;;;;;;;;;;;;;;; Window Group ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GroupAdd, PoeWindow, ahk_exe PathOfExileSteam.exe
GroupAdd, PoeWindow, ahk_exe PathOfExile.exe
GroupAdd, PoeWindow, ahk_exe PathOfExileEGS.exe
GroupAdd, PoeWindow, ahk_class POEWindowClass
GroupAdd, PoeWindow, Reminder
GroupAdd, PoeWindow, InfluenceReminder
GroupAdd, PoeWindow, Overlay
GroupAdd, PoeWindow, Move
GroupAdd, PoeWindow, Awakened PoE Trade
GroupAdd, PoeWindow, Influence
GroupAdd, PoeWindow, Transparency
; GroupAdd, PoeWindow, ahk_exe code.exe

;;;;;;;;;;;;;;;;;;;;;;;;; Check for Ini Files ;;;;;;;;;;;;;;;;;;
LocationIni := StorageIni()
If !FileExist(LocationIni) ;Check for "Theme" ini
{
    If !FileExist("Resources\Settings")
    {
        FileCreateDir, Resources\Settings
    }
    IniWrite, A_ScriptDir, %LocationIni%, Settings Location, Location
}

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
    Loop, 14
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
    IniWrite, 1, %NotificationIni%, Active, Notification
    IniWrite, 1, %NotificationIni%, Active, Influence
    IniWrite, 100, %NotificationIni%, Volume, Notification
    IniWrite, 100, %NotificationIni%, Volume, Influence
    IniWrite, 839, %NotificationIni%, Map Notification Position, Vertical
    IniWrite, 677, %NotificationIni%, Map Notification Position, Horizontal
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

TransparencyIni := TransparencyIni()
If !FileExist(TransparencyIni)
{
    TransparencyItems := "Overlay|Notification|Influence|Map"
    For each, Item in StrSplit(TransparencyItems, "|")
    {
        IniWrite, 255, %TransparencyIni%, Transparency, %Item%
    }
}

FirstRunIni := FirstRunIni()
If FileExist(FirstRunIni) ;Check for "FirstRun" ini
{
    CheckFirstRun()
    If (ClientState = "ERROR") or (HideoutState = "ERROR") or (MechanicState = "ERROR") or (ClientState = 0) or (HideoutState = 0) or (MechanicState = 0) or (ClientState = "") or (HideoutState = "") or (MechanicState = "")
    {
        FirstRun()
    }
}
If !FileExist(FirstRunIni)
{
    FirstRun()
}

IniRead, FirstRunActive, %FirstRunIni%, Active, Active
If (FirstRunActive = 1)
{
    FirstRun()
}

LaunchOptionIni := LaunchOptionsIni()
If !FileExist(LaunchOptionIni) ;Check for "Launch options" ini
{
    FirstRunIni := FirstRunIni()
    IniRead, FirstRunActive, %FirstRunIni%, Active, Active
    If (FirstRunActive != 1)
        {
            MsgBox,, Launch Path of Exile, Please launch Path of Exile for the script to continue loading
            WinWait, ahk_Group PoeWindow
        }
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

if !(FileExist("Resources\Images\Image Search\Custom")) ;Check for Custom image search folders
    {
        FileCreateDir, Resources\Images\Image Search\Custom
    } 
    
if !(FileExist("Resources\Images\Image Search\Eldritch\Custom")) ;Check for Custom image search folders
    {
        FileCreateDir, Resources\Images\Image Search\Eldritch\Custom
    } 

;;;;;;;;;;;;;;;; End Setup ;;;;;;;;;;;;;;;

IndexTrack =

UpdateCheck()
Start()
Return

Start()
{
    ScreenIni := ScreenIni()
    IniWrite, 0, %ScreenIni%, Screen Search Disable, Disable
    HotkeyCheck()
    WinWait, ahk_Group PoeWindow
    GetLogPath()
    CheckTheme()
    Run, Resources\Scripts\Tail.ahk
    Run, Resources\Scripts\ScreenSearch.ahk
    Run, Resources\Scripts\ocr.ahk
    Overlay()
}
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Settings Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

    LaunchIni := LaunchOptionsIni()
    LogPath = %POEPathTrim%logs\Client.txt
    If (LogPath != "logs\Client.txt")
    {
        IniWrite, %LogPath%, %LaunchIni%, POE, log
        IniWrite, %POEPathTrim%, %LaunchIni%, POE, Directory
        IniWrite, %POEpath%, %LaunchIni%, POE, EXE
    }
    If (LogPath = "logs\Client.txt")
    {
        IniRead, LogPath, %LaunchIni%, POE, log
    }
    Return
}

;;;;;;;;;;;;;;;;;;;;;;; Theme ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SelectTheme()
{
    Gui, Theme:Destroy
    Gui, Theme:-Border
    Gui, Theme:Color, %Secondary%
    Gui, Theme:-Caption
    Gui, Theme:Font, c%Font% s10
    Gui, Theme:Add, Button, x+10 yp+10 w90 h30, Dark Mode
    Gui, Theme:Add, Picture, yn y10 Section ,Resources/Images/Dark Theme/Dark Reminder.png
    Gui, Theme:Add, Picture, xs ,Resources/Images/Dark Theme/Dark Notification Selector.png
    Gui, Theme:Add, Picture, ys ,Resources/Images/Dark Theme/Dark Mechanic Selector.png
    Gui, Theme:Add, Picture, yn y10 ,Resources/Images/Dark Theme/Dark Hideout Select.png

    BoxW := Round(96/A_ScreenDPI*970)
    Gui, Theme:Add, GroupBox, w%BoxW% h10 xn x10

    Gui, Theme:Add, Button, x10 y+10 w90 h30 Section , Light Mode
    Gui, Theme:Add, Picture, ys Section ,Resources//Images/Light Theme/Light Reminder.png
    Gui, Theme:Add, Picture, xs ,Resources/Images/Light Theme/Light Notification Selector.png
    Gui, Theme:Add, Picture, ys ,Resources/Images/Light Theme/Light Mechanic Selector.png
    Gui, Theme:Add, Picture, ys ,Resources/Images/Light Theme/Light Hideout Select.png

    BoxH := Round(96/A_ScreenDPI*900)
    Gui, Theme:Add, GroupBox, w1 h%BoxH% yn
    Gui, Theme:Add, Button, yn y10 w90 h30 Section, Custom
    ThemeFile := ThemeIni()
    IniRead, CustomBackground, %ThemeFile%, Custom, Background, Gray
    IniRead, CustomFont, %ThemeFile%, Custom, Font, White
    IniRead, CustomSecondary, %ThemeFile%, Custom, Secondary, Silver
    Gui, Theme:Font, c%Font% s10
    Gui, Theme:Add, Link, xs w420 +Wrap Section, Custom colors can be selected by typing in the color names listed below or with a 6-digit hex color code (Note: Do not include "#" in your hex code). I you are looking for a color picker <a href="https://g.co/kgs/2dFtE2">Google has a great one here.</a> Once you've typed in your desired color press "Enter" to apply it to the samples below, if you're happy with the colors press the "Custom" button above to save the colors.

    Gui, Theme:Add, Text, Section w110, Background:
    Gui, Theme:Font, cBlack s10
    Gui, Theme:Add, Edit, vCustomBackground +Center w90 YS, %CustomBackground%
    Gui, Theme:Add, Progress, YS w100 h20 c%CustomBackground% vBackgroundProgress, 100

    Gui, Theme:Font, c%Font% s10
    Gui, Theme:Add, Text, xs Section w110, Secondary Color:
    Gui, Theme:Font, cBlack s10
    Gui, Theme:Add, Edit, vCustomSecondary +Center w90 YS, %CustomSecondary%
    Gui, Theme:Add, Progress, YS w100 h20 c%CustomSecondary% vSecondaryProgress, 100

    Gui, Theme:Font, c%Font% s10
    Gui, Theme:Add, Text, xs Section w110, Font:
    Gui, Theme:Font, cBlack s10
    Gui, Theme:Add, Edit, vCustomFont +Center w90 YS, %CustomFont%
    Gui, Theme:Add, Progress, YS w100 h20 c%CustomFont% vFontProgress, 100
    
    Gui, Theme:Font, c%Font% s10
    Gui, Theme:Add, Text, xs Section w110, Icons:
    DarkOn := 0
    LightOn := 0
    If (ColorMode = "Dark")
        {
            DarkOn := 1
        }
    If (ColorMode = "Light")
        {
            LightOn := 1
        }
    If (ColorMode = "Custom")
        {
            If (Icons = "White")
                {
                    DarkOn := 1
                }
            If (Icons = "Black")
                {
                    LightOn :=1
                }
        }
    Gui, Theme:Font, c%Font% s10
    Gui, Theme:Add, Radio, Group YS vCustomIcon Checked%LightOn%, Black
    Gui, Theme:Add, Radio, XS+122 Checked%DarkOn%, White
    Gui, Theme:Add, Picture, YP-25 x+20 w15 h15, Resources/Images/play.png
    Gui, Theme:Add, Picture, XP y+10 w15 h15, Resources/Images/play white.png
    Gui, Theme:Add, Text, yp xs Section, %A_Space%
    Gui, Theme:Add, Text, xs Section, %A_Space%

    ColorOptions := "Black-Silver|Gray-White|Maroon-Red|Purple-Fuchsia|Green-Lime|Olive-Yellow|Navy-Blue|Teal-Aqua"
    For each, ColorChoice in StrSplit(ColorOptions, "|")
    {
        ColorChoice := StrSplit(ColorChoice, "-")
        Color1 := ColorChoice[1]
        Gui, Theme:Font, c%Font% s10
        Gui, Theme:Add, Text, xs Section w55, % ColorChoice[1] ":"
        Gui, Theme:Font, cBlack s10
        Gui, Theme:Add, Progress, YS x+30 w90 h20 c%Color1%, 100
        Color2 := ColorChoice[2]
        Gui, Theme:Font, c%Font% s10
        Gui, Theme:Add, Text, YS w55, % ColorChoice[2] ":"
        Gui, Theme:Font, cBlack s10
        Gui, Theme:Add, Progress, YS w90 h20 x+30 c%Color2%, 100
    }

    Gui, Theme:-DPIScale
    Gui, Theme:Show,,Gui:Theme
    Return
}

#IfWinActive Gui:Theme
    Enter::
        {
            Gui, Theme:Submit, Nohide
            GuiControl, Theme:+c%CustomBackground%, BackgroundProgress
            GuiControl, Theme:+c%CustomFont%, FontProgress
            GuiControl, Theme:+c%CustomSecondary%, SecondaryProgress
        }
    Return
#If

ThemeButtonDarkMode()
{
    Gui, Theme:Destroy
    ThemeFile := ThemeIni()
    IniWrite, Dark, %ThemeFile%, Theme, Theme
    FirstRunIni := FirstRunIni()
    IniWrite, 1, %FirstRunIni%, Completion, Theme
    Reload(1)
    Return
}

ThemeButtonLightMode()
{
    Gui, Theme:Destroy
    ThemeFile := ThemeIni()
    IniWrite, Light, %ThemeFile%, Theme, Theme
    FirstRunIni := FirstRunIni()
    IniWrite, 1, %FirstRunIni%, Completion, Theme
    Reload(1)
    Return
}

ThemeButtonCustom()
{
    Gui, Theme:Submit
    Gui, Theme:Destroy
    ThemeFile := ThemeIni()
    IniWrite, %CustomBackground%, %ThemeFile%, Custom, Background
    IniWrite, %CustomFont%, %ThemeFile%, Custom, Font
    IniWrite, %CustomSecondary%, %ThemeFile%, Custom, Secondary
    If (CustomIcon = 1)
        {
            CustomIcon := "Black"
        }
    Else
        {
            CustomIcon := "White"
        }
    IniWrite, %CustomIcon%, %ThemeFile%, Custom, Icons
    IniWrite, Custom, %ThemeFile%, Theme, Theme
    FirstRunIni := FirstRunIni()
    IniWrite, 1, %FirstRunIni%, Completion, Theme
    Reload(1)
    Return
}

ColorPicker()
{
    Run, https://g.co/kgs/2dFtE2
    Return
}

CheckTheme()
{
    Global ThemeItems := "Font|Background|Secondary|Icons"
    ThemeFile := ThemeIni()
    IniRead, ColorMode, %ThemeFile%, Theme, Theme
    If (ColorMode = "Custom")
        {
            IniRead, Icons, %ThemeFile%, Custom, Icons
        }
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
    IniRead, PoeLaunch, %LaunchOptionsIni%, POE, EXE
    IniRead, PoeDir, %LaunchOptionsIni%, POE, Directory
    SetWOrkingDir, %PoeDir%
    Run, %PoeLaunch%
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

Reload(Special := 0)
{
    If (Special != 1)
        {
            FirstRunPath := FirstRunIni()
            IniWrite, 0, %FirstRunPath%, Active, Activ
        }
    AdditionalScripts("Reload")
    Reload
    Return
}

Exit(Special := 0)
{
    If (Special = "Reload") or (Special = "Single")
        {
            Return
        }
    If (Special != 1)
        {
            FirstRunPath := FirstRunIni()
            IniWrite, 0, %FirstRunPath%, Active, Active
            AdditionalScripts("Exit")
        }
    ExitApp
}

AdditionalScripts(Action)
{
    ScriptsActions := "\Resources\Scripts\Tail.ahk|\Resources\Scripts\WindowMonitor.ahk|\Resources\Scripts\ScreenSearch.ahk|\Resources\Scripts\ocr.ahk"
    For each, script in StrSplit(ScriptsActions, "|")
    {
        If(Action = "Exit")
        {
            WinClose, %A_ScriptDir%%script% ahk_class AutoHotkey
        }
        If(Action = "Reload")
        {
            If(script = "\Resources\Scripts\Tail.ahk")
            {
                If WinExist("Tail.ahk")
                {
                    Run, %A_ScriptDir%%script%
                }
            }
            Else
            {
                Run, %A_ScriptDir%%script%
            }
        }
    }
    Return
}

HotkeyCheck()
{
    HotkeyPath := HotkeyIni()
    HotkeyMechanics := GetHokeyMechanics()
    For each, HotkeyItem in StrSplit(HotKeyMechanics, "|")
    {
        IniRead, HotkeyCombo, %HotkeyPath%, Hotkeys, %HotkeyItem%
        HotkeySet := %HotkeyItem%
        Hotkey, IfWinActive
        If (HotkeyItem = "ToggleInfluence") and !(HotkeyCombo = "") and !(HotkeyCombo = "ERROR")
            {
                Hotkey, ~%HotkeyCombo%, ToggleInfluence
            }

        If (HotkeyItem = "MavenInvitation") and !(HotkeyCombo = "") and !(HotkeyCombo = "ERROR")
            {
                Hotkey, ~%HotkeyCombo%, ViewMaven
            }

        If (HotkeyItem = "LaunchPoE") and !(HotkeyCombo = "") and !(HotkeyCombo = "ERROR")
            {
                Hotkey, ~%HotkeyCombo%, LaunchPoe
            }

        If (HotkeyItem = "ToolLauncher") and !(HotkeyCombo = "") and !(HotkeyCombo = "ERROR")
            {
                Hotkey, ~%HotkeyCombo%, ToolLaunchGui
            }

        If (HotkeyItem = "MapCount") and !(HotkeyCombo = "") and !(HotkeyCombo = "ERROR")
            {
                Hotkey, IfWinActive, ahk_group PoeWindow
                Hotkey, ~%HotkeyCombo%, SubtractOne
            }

        If (HotkeyItem = "Abyss") and !(HotkeyCombo = "") and !(HotkeyCombo = "ERROR")
            {
                Hotkey, IfWinActive, ahk_group PoeWindow
                Hotkey, %HotkeyCombo%, Abyss, T5
            }

        If (HotkeyItem = "Betrayal") and !(HotkeyCombo = "") and !(HotkeyCombo = "ERROR")
            {
                Hotkey, IfWinActive, ahk_group PoeWindow
                Hotkey, %HotkeyCombo%, Betrayal, T5
            }

        If (HotkeyItem = "Blight") and !(HotkeyCombo = "") and !(HotkeyCombo = "ERROR")
            {
                Hotkey, IfWinActive, ahk_group PoeWindow
                Hotkey, %HotkeyCombo%, Blight, T5
            }

        If (HotkeyItem = "Breach") and !(HotkeyCombo = "") and !(HotkeyCombo = "ERROR")
            {
                Hotkey, IfWinActive, ahk_group PoeWindow
                Hotkey, %HotkeyCombo%, Breach, T5
            }

        If (HotkeyItem = "Einhar") and !(HotkeyCombo = "") and !(HotkeyCombo = "ERROR")
            {
                Hotkey, IfWinActive, ahk_group PoeWindow
                Hotkey, %HotkeyCombo%, Einhar, T5
            }

        If (HotkeyItem = "Expedition") and !(HotkeyCombo = "") and !(HotkeyCombo = "ERROR")
            {
                Hotkey, IfWinActive, ahk_group PoeWindow
                Hotkey, %HotkeyCombo%, Expedition, T5
            }

        If (HotkeyItem = "Harvest") and !(HotkeyCombo = "") and !(HotkeyCombo = "ERROR")
            {
                Hotkey, IfWinActive, ahk_group PoeWindow
                Hotkey, %HotkeyCombo%, Harvest, T5
            }

        If (HotkeyItem = "Incursion") and !(HotkeyCombo = "") and !(HotkeyCombo = "ERROR")
            {
                Hotkey, IfWinActive, ahk_group PoeWindow
                Hotkey, %HotkeyCombo%, Incursion, T5
            }

        If (HotkeyItem = "Legion") and !(HotkeyCombo = "") and !(HotkeyCombo = "ERROR")
            {
                Hotkey, IfWinActive, ahk_group PoeWindow
                Hotkey, %HotkeyCombo%, Legion, T5
            }

        If (HotkeyItem = "Niko") and !(HotkeyCombo = "") and !(HotkeyCombo = "ERROR")
            {
                Hotkey, IfWinActive, ahk_group PoeWindow
                Hotkey, %HotkeyCombo%, Niko, T5
            }

        If (HotkeyItem = "Ritual") and !(HotkeyCombo = "") and !(HotkeyCombo = "ERROR")
            {
                Hotkey, IfWinActive, ahk_group PoeWindow
                Hotkey, %HotkeyCombo%, Ritual, T5
            }

        If (HotkeyItem = "Ultimatum") and !(HotkeyCombo = "") and !(HotkeyCombo = "ERROR")
            {
                Hotkey, IfWinActive, ahk_group PoeWindow
                Hotkey, %HotkeyCombo%, Ultimatum, T5
            }

        If (HotkeyItem = "Generic") and !(HotkeyCombo = "") and !(HotkeyCombo = "ERROR")
            {
                Hotkey, IfWinActive, ahk_group PoeWindow
                Hotkey, %HotkeyCombo%, Generic, T5
            }
        If (HotkeyItem = "PortalKey") and !(HotkeyCombo = "") and !(HotkeyCombo = "ERROR")
            {
                Hotkey, IfWinActive, ahk_group PoeWindow
                Hotkey, ~%HotkeyCombo%, HotkeyReminder, T5
            }
        If (HotkeyItem = "ChatKey") and !(HotkeyCombo = "") and !(HotkeyCombo = "ERROR")
            {
                Hotkey, IfWinActive, ahk_group PoeWindow
                Hotkey, ~%HotkeyCombo%, ChatDelay, T5
            }
    }
}

TransparencyCheck(NotificationTransparency)
{
    TransparencyIniPath := TransparencyIni()
    IniRead, NotificationTransparency, %TransparencyIniPath%, Transparency, %NotificationTransparency%, 255
    Return, %NotificationTransparency%
}

MapSettings()
{
    PostSetup()
    PostMessage, 0x01997,,,, Tail.ahk ;Trigger Map Settings Setup Tool
    PostRestore()
}

HotkeyReminder()
{
    ActiveMechanics := MechanicsActive()
    If (MechanicsActive > 0) and !(IgnoreNotificationKey = 1)
        {
            NotificationIni := NotificationIni()
            IniRead, HotkeyTriggerStatus, %NotificationIni%, Notification Trigger, Hotkey, 0
            If (HotkeyTriggerStatus = 1) ; Check if the hotkey setting is actually active before triggering the reminder
            {
                IniWrite, 1, %NotificationIni%, Notification Trigger, Quick Triggered
                PostSetup()
                PostMessage, 0x01112,,,, Tail.ahk ;Trigger reminder
                PostRestore()
            }
        }
}

ChatDelay()
{
    NotificationIni := NotificationIni()
    IniRead, DelayTime, %NotificationIni%, Notification Trigger, Chat Delay, 0 
    If !(DelayTime = 0)
        {
            SetTimer, ChatDelayTimer, Off
            IgnoreNotificationKey := 1
            SetTimer, ChatDelayTimer, %DelayTime%
        }
}

ChatDelayTimer()
{
    IgnoreNotificationKey := 0
}

~^s:: ;Remove for release
{
    If WinActive(A_ScriptName)
        {
            Reload()
        }
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#Include, Resources\Scripts\AutoMechanic.ahk
#Include, Resources\Scripts\Class_ScrollGUI.ahk
; #Include, Resources\Scripts\DivCard.ahk
#Include, Resources\Scripts\EldritchReminder.ahk
#Include, Resources\Scripts\Firstrun.ahk
#Include, Resources\Scripts\HotkeySelect.ahk
#Include, Resources\Scripts\Ini.ahk
#Include, Resources\Scripts\iniChoose.ahk
#Include, Resources\Scripts\Influences.ahk
#Include, Resources\Scripts\LaunchOptions.ahk
#Include, Resources\Scripts\Maven.ahk
#Include, Resources\Scripts\MavenReminder.ahk
#Include, Resources\Scripts\Mechanics.ahk
#Include, Resources\Scripts\NotificationSettings.ahk
#Include, Resources\Scripts\NotificationSounds.ahk
#Include, Resources\Scripts\Overlay.ahk
#Include, Resources\Scripts\OverlaySetup.ahk
#Include, Resources\Scripts\ToolLauncher.ahk
#Include, Resources\Scripts\UpdateCheck.ahk

;New Mechanic setup list. Add the following Global Variables (Mechanic Name, MechanicActive, MechanicOn - to Mechanics.ahk) Add mechanic name to Mechanic()(Function) in Mechanics.ahk