SetHotkeyItems(Items, HotkeyGui)
{
    HotkeyIni := IniPath("Hotkeys")
    CurrentTheme := GetTheme()
    CurrentValue := IniRead(HotkeyIni, "Hotkeys", Items, "")
    CheckboxStatus := 0
    If InStr(CurrentValue, "#")
        {
            CurrentValue := StrSplit(CurrentValue, "#")
            CurrentValue := CurrentValue[2]
            CheckboxStatus := 1
        }
    HotkeyGui.SetFont("s8 Underline c" CurrentTheme[2])
    Footnote := "    "
    If (Items = "Map Count")
        {
            FootNote := 1
        }
    Else If (Items = "Toggle Influences")
        {
            FootNote := 2
        }
    Else If (Items = "Maven Invitation")
        {
            FootNote := 3
        }
    Else If (Items = "Launch PoE")
        {
            FootNote := 4
        }
    Else If (Items = "Launcher Tool")
        {
            FootNote := 5
        }
    Else If (Items = "Portal Key")
        {
            FootNote := 6
        }
    Else If (Items = "Chat Key")
        {
            FootNote := 7
            If (CurrentValue = "")
                {
                    CurrentValue := "Enter"
                }
        }
    Else
        {
            FootNote := 8
        }
    HotkeyGui.Add("Text", "w175 XS Section",) ;Spacer
    HotkeyGui.Add("Text", "w1 YS", FootNote).OnEvent("Click", HotkeyFootnote.Bind(FootNote, Items))
    HotkeyGui.SetFont("s10 Norm c" CurrentTheme[3])
    HotkeyGui.Add("Text", "w120 x+1 YS", Items).OnEvent("Click", HotkeyFootnote.Bind(FootNote, Items))
    HotkeyGui.Add("Text", "w175 YS",)
    CheckNum := A_Index "Check"
    CheckNum := HotkeyGui.Add("Checkbox", "YS Checked" CheckboxStatus)
    HotkeyGui.Add("Hotkey", "YS Center", CurrentValue).OnEvent("Change", HotkeyEdit.Bind(Items, Checknum))
    CheckNum.OnEvent("Click", WinKeyCheck.Bind(Items))
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
                    IniWrite(CurrentValue, HotkeyIni,"Hotkeys", Item)
                }
        }
    HotkeyEdit(Item, Status.Value, "112222llF")
}

HotkeyEdit(Item, WinStatus, KeyCombo, *)
{
    If (KeyCombo = "112222llF")
    {
        NewKey := IniPath("Hotkeys", "Read", , "Hotkeys", Item, "")
        If (WinStatus = 1)
            {
                NewKey := "#" NewKey
            }
    }
    Else
    {
        NewKey := KeyCombo.Value
        If (WinStatus.Value = 1)
            {
                NewKey := "#" KeyCombo.Value
            } 
    }
    HotkeyIni := IniPath("Hotkeys") 
    Hotkeys := GetHotkeyItems()
    HotkeyPairs := GetHotkeyPairs()
    For HotkeyItems in Hotkeys ;Disable all active hokeys
        {
            ActiveHotkey := IniPath("Hotkeys", "Read", , "Hotkeys", HotkeyItems, "")
            If !(ActiveHotkey = "")
            {
                If (HotkeyItems = "Launch PoE")
                {
                    Hotkey ActiveHotkey, "Off"
                }
                Else
                {
                    HotIfWinActive("ahk_group PoeWindow")
                    Hotkey ActiveHotkey, "Off"
                    HotIfWinActive
                }
            }
        }
    Mechanics := VariableStore("Mechanics")
    For Mechanic in Mechanics
    {
        ActiveHotkey := IniPath("Hotkeys", "Read", , "Hotkeys", Mechanic, "")
        If !(ActiveHotkey = "")
        {
            HotIfWinActive("ahk_group PoeWindow")
            Hotkey ActiveHotkey, "Off"
            HotIfWinActive
        }
    }
    IniWrite(NewKey, HotkeyIni, "Hotkeys", Item)
    ApplyHotkeys()
}

HotkeyGui_Size(GuiObj, MinMax, Width, Height)
{
    If (MinMax != 1)
        UpdateScrollBars(GuiObj)
}

HotkeyFootnote(FootnoteNum, Mechanic, *)
{
    FootnoteMenu := Menu()
    If (FootnoteNum = 1)
        {
            FootnoteMenu.Add("The `"Map Count`" hotkey is used to remove a map from the", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("Eldritch Influence (Maven, Eater of Worlds and Searing Exarch)", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("count. This is not required but highly recommended as", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("depending on the content you are doing you may periodically", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("periodically need to remove a map from the count.", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    If (FootnoteNum = 2)
        {
            FootnoteMenu.Add("The `"Toggle Influence`" hotkey will allow you to quickly)", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("switch between Eldritch Influences (Maven, Eater of Worlds", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("and Searing Exarch)", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    If (FootnoteNum = 3)
        {
            FootnoteMenu.Add("The `"Maven Inventation`" hotkey allows you to quickly open", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("the Maven Invitation Status Menu.", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    If (FootnoteNum = 4)
        {
            FootnoteMenu.Add("The `"Launch PoE`" hotkey allows you to launch Path of Exile", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("along with any configured `"Auto Launch`" items. Auto Launch", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("items can be configured in the Launcher Setup menu. Please", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("note, that this hotkey will work everywhere in Windows so", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("it's important to set a hotkey that will not conflict with", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("any other hotkeys or Windows shortcuts you may already be using.", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    If (FootnoteNum = 5)
        {
            FootnoteMenu.Add("The `"Launcher Tool`" hotkey allows you to quickly launch", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("the Launcher Setup tool.", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    If (FootnoteNum = 6)
        {
            FootnoteMenu.Add("The `"Portal Key`" hotkey is used to trigger mechanic", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("completion reminders. It is recommended to bind this to", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("whichever key you have your in game Portal hotkey set to.", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("To avoid accidental triggers while typing in chat it's", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("highly recommended to setup the `"Chat Delay`" feature", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("in the Notification Settings menu.", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    If (FootnoteNum = 7)
        {
            FootnoteMenu.Add("The `"Chat Key`" hotkey is used along with the `"Chat Delay`"", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("feature in the Notification Settings menu to ignore key presses", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("of the `"Portal Key`" while typing in chat. By default the", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("hotkey is set to `"Enter`", if you've changed the key and", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("would like to reset it simply press `"Delete`" or `"Backspace`"", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("when in the entry box, this will set it to `"None`" and", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("reset the key to `"Enter`".", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    If (FootnoteNum = 8)
        {
            FootnoteMenu.Add("The " Mechanic.Text " hotkey is used to quickly toggle the", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("status of the " Mechanic " mechanic this can be a", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("great alternative to pressing the image to disable tracking.", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    FootnoteMenu.Show()
}

ApplyHotkeys()
{
    HotkeyItems := GetHotkeyItems()
    HotkeyPairs := GetHotkeyPairs()
    HotkeyIni := IniPath("Hotkeys")
    For ThisHotkey in HotkeyItems
        {
            HotkeyCombo := IniRead(HotkeyIni, "Hotkeys", ThisHotkey, "")
            If !(HotkeyCombo = "") and ((ThisHotkey = "Portal Key") or (ThisHotkey = "Chat Key"))
                {
                    If (ThisHotkey = "Chat Key") and (HotkeyCombo = "") ;Default "Chat Key" to "Enter" if not set. 
                        {
                            HotkeyCombo := "Enter"
                        } 
                    HotkeyCombo := "~" HotkeyCombo
                }
            If (ThisHotkey = "Launch PoE") and !(HotkeyCombo ="")
                {
                    Hotkey HotkeyCombo, LaunchPoE, "On"
                }
            Else If !(HotkeyCombo ="")
                {
                    HotIfWinActive("ahk_group PoeWindow")
                    Hotkey HotkeyCombo, %HotkeyPairs[A_Index]%, "On"
                    HotIfWinActive
                }
        }
    Mechanics := VariableStore("Mechanics")
    For Item in Mechanics
        {
            HotkeyCombo := IniRead(HotkeyIni, "Hotkeys", Item, "")
            If !(HotkeyCombo = "")
                {
                    HotIfWinActive("ahk_group PoeWindow")
                    Hotkey HotkeyCombo, ToggleMechanic.Bind(Item, 1), "On"
                    HotIfWinActive
                }
        }
}

ChatDelay(*)
{
    HotkeyIni := IniPath("Hotkeys")
    PortalHotkey := IniRead(HotkeyIni, "Hotkeys","Portal Key", "")
    If !(PortalHotkey = "")
        {
            Hotkey PortalHotkey, NotifyActiveMechanics, "Off"
            NotificaitonIni := IniPath("Notifications")
            DelayTime := IniRead(NotificaitonIni, "Mechanic Notification", "Chat Delay", 0)
            Sleep DelayTime*1000
            Hotkey "~" PortalHotkey, NotifyActiveMechanics, "On"
        } 
}

GetHotkeyItems()
{
    Return ["Map Count", "Toggle Influences", "Maven Invitation", "Launch PoE", "Launcher Tool", "Portal Key", "Chat Key"]
}

GetHotkeyPairs()
{
    Return ["InfluenceRemoveOne", "ToggleInfluence", "MavenStatus", "LaunchPoE", "LauncherGui", "NotifyActiveMechanics", "ChatDelay"]
}

LauncherGui(*)
{
    Settings(8)
}

GetMapHotkey()
{
    MapHotkey := IniPath("Hotkeys", "Read", , "Hotkeys", "Map Count", "Not Set")
    ;Convert Modifier keys to humar readable (# Win ! Alt ^ Ctrl + Shift)
    If !(MapHotkey = "Not Set")
    {
        MapHotkey := StrUpper(MapHotkey)
        ModifierTypes := ["#", "^", "!", "+"]
        ReplaceWith := ["Win", "Ctrl", "Alt", "Shift"]
        For Modifier in ModifierTypes
        {
            If InStr(MapHotkey, Modifier)
                {
                    MapHotkey := StrReplace(MapHotkey, ModifierTypes[A_Index], ReplaceWith[A_Index] A_Space)
                }
        }
        MapHotkey := StrReplace(MapHotkey, A_Space, "+")
    }
    Return MapHotkey
}