HotkeySetup(*)
{
    HotkeySetupDestroy()
    CurrentTheme := GetTheme()
    HotkeyGui.BackColor := CurrentTheme[1]
    HotkeyGui.SetFont("s15 Bold c" CurrentTheme[3])
    HotkeyGui.Add("Text", "Center w500", "Hotkey Setup")
    HotkeyGui.AddText("h1 w500 Background" CurrentTheme[3])
    HotkeyGui.SetFont("s10 Norm")
    HotkeyGui.Add("Text", "w270 Section", "Hotkey Items")
    HotkeyGui.Add("Text", "YS w100", "Use Win Key")
    HotkeyGui.Add("Text", "YS", "Hotkey(s)")
    HotkeyItems := ["Map Count", "Toggle Influences", "Maven Invitation", "Launch PoE", "Tool Launcher", "Portal Key", "Chat Key"]
    For Item in HotkeyItems
        {
            SetHotkeyItems(Item)
        }
    Mechanics := VariableStore("Mechanics")
    For Mechanic in Mechanics
        {
            SetHotkeyItems(Mechanic)
        }
    HotkeyGui.Show
}

SetHotkeyItems(Items)
{
    CurrentTheme := GetTheme()
    HotkeyGui.SetFont("s10 c" CurrentTheme[2])
    HotkeyGui.Add("Text", "w300 XM Section", Items)
    HotkeyGui.Add("Checkbox", "YS Checked")
    HotkeyGui.Add("Hotkey", "YS Center")
}

HotkeySetupDestroy()
{
    If WinExist("Hotkey Setup")
        {
            HotkeyGui.Destroy()
        }
    Global HotkeyGui := Gui(,"Hotkey Setup")
}