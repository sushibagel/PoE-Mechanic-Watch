HotkeySetup(*)
{
    HotkeySetupDestroy()
    CurrentTheme := GetTheme()
    HotkeyGui.BackColor := CurrentTheme[1]
    HotkeyGui.SetFont("s15 Bold c" CurrentTheme[3])
    HotkeyGui.Add("Text", "Center w700", "Hotkey Setup")

    HotkeyGui.Show
}

HotkeySetupDestroy()
{
    If WinExist("Hotkey Setup")
        {
            HotkeyGui.Destroy()
        }
    Global HotkeyGui := Gui(,"Hotkey Setup")
}