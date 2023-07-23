#SingleInstance force
#Requires AutoHotkey >=2.0
Persistent

StorageLocation := IniRead("Resources\Settings\StorageLocation.ini", "Settings" "Location", "Location", "A_ScriptDir")
If (StorageLocation = "A_ScriptDir")
    {
        StorageLocation := A_ScriptDir
    }
Theme := IniRead( StorageLocation "\Resources\Settings\Theme.ini", "Theme", "Theme", "Dark")

If (Theme = "Dark")
{
    isDark := 2
}
If (Theme = "Light")
{
    isDark := 3
}
MenuDark(isDark)

; Tray Setup
Tray := A_TrayMenu
Tray.Delete ; Delete the standard items.
Tray.Add "Select Mechanics", SelectMechanics
Tray.Add "Select Auto Enable/Disable", SelectMechanics
Tray.Add "View Maven Invitation Status", SelectMechanics
Tray.Add 
Tray.Add "Launch Path of Exile", SelectMechanics
Tray.Add "View Path of Exile Log", SelectMechanics
Tray.Add 

; Setup sub-menu
SetupMenu := Menu()
Tray.Add "Setup", SetupMenu
Tray.Default := "Setup"
SetupMenu.Add "Setup Menu", FirstRun
SetupMenu.Add 
SetupMenu.Add "Set Hideout", SelectMechanics
SetupMenu.Add 
SetupMenu.Add "Calibrate Search", SelectMechanics
SetupMenu.Add 
SetupMenu.Add "Change Theme", SelectMechanics
SetupMenu.Add "Change Hotkey", SelectMechanics
SetupMenu.Add 
SetupMenu.Add "Overlay Settings", SelectMechanics
SetupMenu.Add "Move Overlay", SelectMechanics
SetupMenu.Add "Move Quick Notification", SelectMechanics
SetupMenu.Add 
SetupMenu.Add "Notification Settings", SelectMechanics
SetupMenu.Add 
SetupMenu.Add "Launch Assist", SelectMechanics
SetupMenu.Add "Tool Launcher", SelectMechanics
SetupMenu.Add 
SetupMenu.Add "Choose Settings File Location", SelectMechanics
SetupMenu.Default := "Setup Menu"

; Tray Menu Continued
Tray.Add 
Tray.Add "Reload", SelectMechanics
Tray.Add
Tray.Add "Check for Updates", SelectMechanics
Tray.Add "Exit", Exit

; About Sub-Menu
AboutMenu := Menu()
Tray.Add "About", AboutMenu
AboutMenu.Add "Version", SelectMechanics
AboutMenu.Add "Changelog", SelectMechanics
AboutMenu.Add "Q&&A/Feedback", SelectMechanics

TraySetIcon "Resources\Images\harvest.png"

; Dark Mode tray menu
MenuDark(Dark) {
    ;https://stackoverflow.com/a/58547831/894589
    static uxtheme := DllCall("GetModuleHandle", "str", "uxtheme", "ptr")
    static SetPreferredAppMode := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 135, "ptr")
    static FlushMenuThemes := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 136, "ptr")

    DllCall(SetPreferredAppMode, "int", Dark) ; 0=Default  1=AllowDark  2=ForceDark  3=ForceLight  4=Max
    DllCall(FlushMenuThemes)
}

SelectMechanics(*)
{
    MsgBox "you selected SelectMechanics"
    Return
}

Exit(*)
{
    ExitApp
}

; FirstRun Check
ClientState := ""
ThemeState := ""
HideoutState := ""
MechanicState := ""
PositionState := ""
MapPositionState := ""
AutomechanicState := ""
HotkeyState := ""
SoundState := ""
LaunchAssistState := ""
NotificationState := ""
ToolLauncherState := ""
FirstRunPath := FirstRunIni()
If FileExist(FirstRunPath) ;Check for "FirstRun" ini
{
    FirstRunItemList := FirstRunItems()
    FirstRunPath := FirstRunIni()
    For each, Item in StrSplit(FirstRunItemList, "|")
    {
        %Item%State := ""
        %Item%State := IniRead(FirstRunPath, "Completion", Item, 0)
        If (ClientState = "ERROR") or (HideoutState = "ERROR") or (MechanicState = "ERROR") or (ClientState = 0) or (HideoutState = 0) or (MechanicState = 0) or (ClientState = "") or (HideoutState = "") or (MechanicState = "")
            {
                FirstRun()
            }
    }
}
If !FileExist(FirstRunPath)
{
    FirstRun()
}

FirstRunActive := IniRead(FirstRunPath, "Active", "Active",0)
If (FirstRunActive = 1)
{
    FirstRun()
}

; End Setup

UpdateCheck()

#IncludeAgain Resources\Scripts\Firstrun.ahk
#IncludeAgain Resources\Scripts\Ini.ahk