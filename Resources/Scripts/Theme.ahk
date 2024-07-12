SetTrayTheme() 
{
    CurrentTheme := GetTheme()
    DarkTray := 1
    If (CurrentTheme[5] = "Light") or ((CurrentTheme[5] = "Custom") and (CurrentTheme[4] = "Black"))
    {
        DarkTray := 0
    }
    DllCall(DllCall("GetProcAddress", "ptr", DllCall("GetModuleHandle", "str", "uxtheme", "ptr"), "ptr", 135, "ptr"), "int", DarkTray),
    DllCall(DllCall("GetProcAddress", "ptr", DllCall("GetModuleHandle", "str", "uxtheme", "ptr"), "ptr", 136, "ptr"))
}

GetTheme() ;Returns "CurrentTheme" array with Background Color at "CurrentTheme[1]" Followed by Secondary color [2], Font color[3], Icon Color[4] and theme mode[5]. 
{
    ThemePath := IniPath("Theme")
    CurrentMode := IniRead(ThemePath, "Theme", "Theme", "Dark")
    BackgroundTheme := IniRead(ThemePath, CurrentMode, "Background", "4e4f53")
    FontTheme := IniRead(ThemePath, CurrentMode, "Font", "White")
    SecondaryTheme := IniRead(ThemePath, CurrentMode, "Secondary", "a6a6a6")
    IconTheme := IniRead(ThemePath, CurrentMode, "Icons", "White")
    CurrentTheme := Array()
    CurrentTheme.Push(BackgroundTheme)
    CurrentTheme.Push(SecondaryTheme)
    CurrentTheme.Push(FontTheme)
    CurrentTheme.Push(IconTheme)
    CurrentTheme.Push(CurrentMode)
    Return(CurrentTheme)
}

RefreshTheme(ChangeTo, ChangeTheme, *)
{
    IniPath("Theme", "Write", ChangeTo, "Theme", "Theme")
    Settings("Change Theme")
}

BackgroundColorSet(BackgroundColor, *)
{
    ThemePath := IniPath("Theme")
    IniWrite(BackgroundColor.Value, ThemePath, "Custom", "Background")
}

SecondaryColorSet(SecondaryColor, *)
{
    ThemePath := IniPath("Theme")
    IniWrite(SecondaryColor.Value, ThemePath, "Custom", "Secondary")
}

FontColorSet(FontColor, *)
{
    ThemePath := IniPath("Theme")
    IniWrite(FontColor.Value, ThemePath, "Custom", "Font")
}

ToggleIcon(ButtonNumber, *)
{
    ThemePath := IniPath("Theme")
    If (ButtonNumber = 1)
        {
            IniWrite("Black", ThemePath, "Custom", "Icons")
        }
    If (ButtonNumber = 2)
        {
            IniWrite("White", ThemePath, "Custom", "Icons")
        }
}