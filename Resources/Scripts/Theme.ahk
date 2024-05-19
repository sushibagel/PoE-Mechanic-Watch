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
    IconTheme := IniRead(ThemePath, CurrentMode, "Icons", "Black")
    CurrentTheme := Array()
    CurrentTheme.Push(BackgroundTheme)
    CurrentTheme.Push(SecondaryTheme)
    CurrentTheme.Push(FontTheme)
    CurrentTheme.Push(IconTheme)
    CurrentTheme.Push(CurrentMode)
    Return(CurrentTheme)
}

ChangeGui(*)
{
    Global ChangeTheme := Gui(,"Change Theme")
    DestroyChangeTheme()
    CurrentTheme := GetTheme()
    ChangeTheme.BackColor := CurrentTheme[1]
    ChangeTheme.SetFont("s20 Bold c" CurrentTheme[3])
    ChangeTheme.Add("Text", "w500 Center", "Change Theme")
    ChangeTheme.SetFont("s10 Norm")
    ChangeTheme.AddText("w500 h1 Background" CurrentTheme[3])
    ChangeTheme.Add("Button","Section XM x125" , "Dark Theme").OnEvent("Click", RefreshTheme.Bind("Dark"))
    ChangeTheme.Add("Button","YS" , "Light Theme").OnEvent("Click", RefreshTheme.Bind("Light"))
    ChangeTheme.Add("Button","YS" , "Custom Theme").OnEvent("Click", RefreshTheme.Bind("Custom"))

    Global BackgroundColor := ""
    Global SecondaryColor := ""
    Global FontColor := ""

    GuiOptions := ["Background", "Secondary", "Font"]
    For Option in GuiOptions
        {
            VariableVal := Option "Color"
            ChangeTheme.Add("Text", "w150 Right XM Section", Option " Color:")
            ChangeTheme.Add("Text", "w100 YS Right Section", "")
            If (Option = "Font")
                {
                    ChangeTheme.SetFont("c" CurrentTheme[2])
                }
            %VariableVal% := ChangeTheme.Add("Edit", "w100 Center YS Background" CurrentTheme[A_Index], CurrentTheme[A_Index])
            %VariableVal%.OnEvent("Change", %Option%ColorSet)   
        }

    ChangeTheme.SetFont("c" CurrentTheme[3])
    IconOptions := ["Black", "White"]
    Global IconSelectColor1 := "" 
    Global IconSelectColor2 := ""
    For Color in IconOptions
        {
            AddSection := ""
            If (A_Index = 1)
                {
                    AddSection := "Section"
                }
            ChangeTheme.Add("Text", "w150 Right XM " AddSection, "Icon Color " Color ":")
            ChangeTheme.Add("Text", "w120 Right YP", A_Space)
            MoveIcon := "Resources\Images\Move " Color ".png"
            ChangeTheme.Add("Picture", "YP w-1 h25 Background" CurrentTheme[2], MoveIcon)
        }
    
    For Color in IconOptions
        {
            isChecked := ""
            If (Color = CurrentTheme[4])
                {
                    isChecked := "Checked"
                }
            PlacementMode := "YS"
            If (A_Index = 2)
                {
                    PlacementMode := "XP"
                }
            IconSelectColor%A_Index% := ChangeTheme.Add("Radio", PlacementMode " " isChecked, Color)
            IconSelectColor%A_Index%.OnEvent("Click", ToggleIcon) 
        }

    ChangeTheme.AddText("w500 h1 XM Background" CurrentTheme[3])
    ChangeTheme.Add("Link", "w500 Center", 'Use the buttons above to apply the specified theme. To set custom colors type your desired colors in the various boxes and press the `"Custom Theme`" button. Please note changing the values above ONLY changes the `"Custom Theme`" the Dark and Light themes don`'t support customization. Color can be specified by name or with a 6-digit hex color code (Note: Do not include "#" in your hex code). A list of color names can be found <a href="https://www.autohotkey.com/docs/v2/misc/Colors.htm">here.</a> Google also has a great color picker that can be found <a href="https://g.co/kgs/yV1scj8">here.</a>')
    ChangeTheme.Show
}

DestroyChangeTheme()
{
    If WinExist("Change Theme")
        {
            ChangeTheme.Destroy()
        }
    Global ChangeTheme := Gui(,"Change Theme")
}

RefreshTheme(ChangeTo, NA1, NA2)
{
    ThemePath := IniPath("Theme")
    IniWrite(ChangeTo, ThemePath, "Theme", "Theme")
    DestroyChangeTheme()
    ChangeGui()
}

BackgroundColorSet(*)
{
    ThemePath := IniPath("Theme")
    IniWrite(BackgroundColor.Value, ThemePath, "Custom", "Background")
}

SecondaryColorSet(*)
{
    ThemePath := IniPath("Theme")
    IniWrite(SecondaryColor.Value, ThemePath, "Custom", "Secondary")
}

FontColorSet(*)
{
    ThemePath := IniPath("Theme")
    IniWrite(FontColor.Value, ThemePath, "Custom", "Font")
}

ToggleIcon(*)
{
    ThemePath := IniPath("Theme")
    If (IconSelectColor1.Value = 1)
        {
            IniWrite("Black", ThemePath, "Custom", "Icons")
        }
    If (IconSelectColor2.Value = 1)
        {
            IniWrite("White", ThemePath, "Custom", "Icons")
        }
}