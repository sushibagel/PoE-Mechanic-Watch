IniPath(MyKey){
    switch MyKey
    {
        case "FirstRun":        MyValue := "Resources\Data\Firstrun.ini"                ;Section Key - Completion
        case "Hideout":         MyValue := "Resources\Settings\Hideout.ini"             ;Section Key - Hideout
        case "Hotkey":          MyValue := "Resources\Settings\Hotkeys.ini"             ;Section Key - Hotkeys
        case "LaunchOptions":   MyValue := "Resources\Data\LaunchPath.ini"              ;Section Key - POE, Launch Options, User Tools, Tool Name
        case "Mechanics":       MyValue := "Resources\Settings\Mechanics.ini"           ;Section Key - Mechanics, Mechanics Active, Auto Mechanics, Influence, Influence Track
        case "Notification":    MyValue := "Resources\Settings\Notification.ini"        ;Section Key - Sounds, Active, Volume
        case "Overlay":         MyValue := "Resources\Settings\OverlayPosition.ini"     ;Section Key - Overlay
        case "Theme":           MyValue := "Resources\Settings\Theme.ini"               ;Section Key - Dark, Light, Theme
        case "Transparency":    MyValue := "Resources\Settings\Transparency.ini"        ;Section Key - Transparency
        case "Variable":    MyValue := "Resources\Data\Variable.ini"        ;Section Key - Map       
    }
    Return MyValue
}

;;;;;;;;;;;;;;;;; Path functions ;;;;;;;;;;;;;;;;;;;;;;

FirstRunIni()
{
    MyKey := "FirstRun"
    IniFile := IniPath(MyKey)
    Return, % IniFile
}

HideoutIni()
{
    MyKey := "Hideout"
    IniFile := IniPath(MyKey)
    Return, % IniFile
}

HotkeyIni()
{
    MyKey := "Hotkey"
    IniFile := IniPath(MyKey)
    Return, % IniFile
}

LaunchOptionsIni()
{
    MyKey := "LaunchOptions"
    IniFile := IniPath(MyKey)
    Return, % IniFile
}

MechanicsIni()
{
    MyKey := "Mechanics"
    IniFile := IniPath(MyKey) 
    Return, % IniFile
}

NotificationIni()
{
    MyKey := "Notification"
    IniFile := IniPath(MyKey)
    Return, % IniFile
}

OverlayIni()
{
    MyKey := "Overlay"
    IniFile := IniPath(MyKey)
    Return, % IniFile
}

ThemeIni()
{
    MyKey := "Theme"
    IniFile := IniPath(MyKey)
    Return, % IniFile
}

TransparencyIni()
{
    MyKey := "Transparency"
    IniFile := IniPath(MyKey)
    Return, % IniFile
}

VariableIni()
{
    MyKey := "Variable"
    IniFile := IniPath(MyKey)
    Return, % IniFile
}