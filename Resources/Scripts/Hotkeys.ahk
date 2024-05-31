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
    HotkeyGui.Add("Text", "w300 XM Section", Items)
    HotkeyGui.Add("Checkbox", "YS Checked").OnEvent("Click", WinKeyCheck.Bind(Items))
    HotkeyGui.Add("Hotkey", "YS Center").OnEvent("Change", HotkeyEdit.Bind(Items))
}

HotkeySetupDestroy()
{
    If WinExist("Hotkey Setup")
        {
            HotkeyGui.Destroy()
        }
    Global HotkeyGui := Gui(,"Hotkey Setup")
}

WinKeyCheck(Item, Status, *)
{
    HotkeyIni := IniPath("Hotkeys")
    CurrentValue := IniRead(HotkeyIni, "Hotkeys", Item, "")
    If (Status.Value = 1)
        {
            IniWrite("#" CurrentValue, HotkeyIni, "Hotkeys", Item)
        }
    If (Status.Value = 0)
        {
            If InStr(CurrentValue, "#")
                {
                    NewValue := StrSplit(CurrentValue, "#")
                    IniWrite(NewValue[2], HotkeyIni, "Hotkeys", Item)
                }
            Else
                {
                    IniWrite(NewValue, HotkeyIni,"Hotkeys", Item)
                }
        }
}

HotkeyEdit(Item, KeyCombo, *)
{
    ToolTip Item "|" KeyCombo.Value
}