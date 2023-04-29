IniPath(MyKey){
    switch MyKey
    {
        case "FirstRun":        MyValue := "Resources\Data\Firstrun.ini"                ;Section Key - Completion
        case "Hideout":         MyValue := "Resources\Settings\Hideout.ini"             ;Section Key - Hideout
        case "Hotkey":          MyValue := "Resources\Settings\Hotkeys.ini"             ;Section Key - Hotkeys
        case "Location":        MyValue := "Resources\Settings\StorageLocation.ini"     ;Section Key - Settings Location
        case "LaunchOptions":   MyValue := "Resources\Data\LaunchPath.ini"              ;Section Key - POE, Launch Options, User Tools, Tool Name
        case "Mechanics":       MyValue := "Resources\Settings\Mechanics.ini"           ;Section Key - Mechanics, Mechanics Active, Auto Mechanics, Influence, Influence Track
        case "Misc":            MyValue := "Resources\Settings\Misc.ini"                ;Section Key - On Death
        case "Notification":    MyValue := "Resources\Settings\Notification.ini"        ;Section Key - Sounds, Active, Volume
        case "Overlay":         MyValue := "Resources\Settings\OverlayPosition.ini"     ;Section Key - Overlay
        case "Screen":          MyValue := "Resources\Data\ScreenSearch.ini"            ;Section Key - Bitmaps 
        case "Theme":           MyValue := "Resources\Settings\Theme.ini"               ;Section Key - Dark, Light, Theme
        case "Transparency":    MyValue := "Resources\Settings\Transparency.ini"        ;Section Key - Transparency
        case "Variable":        MyValue := "Resources\Data\Variable.ini"                ;Section Key - Map       
    }
    Return MyValue
}

;;;;;;;;;;;;;;;;; Path functions ;;;;;;;;;;;;;;;;;;;;;;

FirstRunIni()
{
    MyKey := "FirstRun"
    IniFile := IniPath(MyKey)
    IniFile := CheckDir(IniFile)
    Return, % IniFile
}

HideoutIni()
{
    MyKey := "Hideout"
    IniFile := IniPath(MyKey)
    IniFile := CheckDir(IniFile)
    Return, % IniFile
}

HotkeyIni()
{
    MyKey := "Hotkey"
    IniFile := IniPath(MyKey)
    IniFile := CheckDir(IniFile)
    Return, % IniFile
}

LaunchOptionsIni()
{
    MyKey := "LaunchOptions"
    IniFile := IniPath(MyKey)
    IniFile := CheckDir(IniFile)
    Return, % IniFile
}

MechanicsIni()
{
    MyKey := "Mechanics"
    IniFile := IniPath(MyKey)
    IniFile := CheckDir(IniFile) 
    Return, % IniFile
}

MiscIni()
{
    MyKey := "Misc"
    IniFile := IniPath(MyKey)
    IniFile := CheckDir(IniFile)
    Return, % IniFile
}

NotificationIni()
{
    MyKey := "Notification"
    IniFile := IniPath(MyKey)
    IniFile := CheckDir(IniFile)
    Return, % IniFile
}

OverlayIni()
{
    MyKey := "Overlay"
    IniFile := IniPath(MyKey)
    IniFile := CheckDir(IniFile)
    Return, % IniFile
}

ScreenIni()
{
    MyKey := "Screen"
    IniFile := IniPath(MyKey)
    IniFile := CheckDir(IniFile)
    Return, % IniFile
}

StorageIni()
{
    IniFile := "Resources\Settings\StorageLocation.ini"
    Return, % IniFile
}

ThemeIni()
{
    MyKey := "Theme"
    IniFile := IniPath(MyKey)
    IniFile := CheckDir(IniFile)
    Return, % IniFile
}

TransparencyIni()
{
    MyKey := "Transparency"
    IniFile := IniPath(MyKey)
    IniFile := CheckDir(IniFile)
    Return, % IniFile
}

VariableIni()
{
    MyKey := "Variable"
    IniFile := IniPath(MyKey)
    IniFile := CheckDir(IniFile)
    Return, % IniFile
}

CheckDir(IniFile)
{
    If A_ScriptDir contains Resources
    {   
        Ini := StrSplit(A_ScriptDir, "Resources\Scripts")
        IniFile := Ini[1] IniFile
    }
    IniRead, CurrentLocation, Resources\Settings\StorageLocation.ini, Settings Location, Location
    If !InStr(CurrentLocation, "A_ScriptDir")
    {
        IniFile := StrSplit(IniFile, "Resources")
        IniFile := "Resources" IniFile[2] 
        IniFile := CurrentLocation "\" IniFile
    }
    Return, %IniFile%
}