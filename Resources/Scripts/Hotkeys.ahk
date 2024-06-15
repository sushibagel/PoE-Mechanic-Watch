HotkeySetup(*)
{
    HotkeyGui := GuiTemplate("HotkeyGui", "Hotkey Setup", 550)
    CurrentTheme := GetTheme()
    HotkeyGui.SetFont("s10 Norm c" CurrentTheme[2])
    HotkeyGui.Add("Text", "Center w500", "To setup a hotkey simply click each input box and press your desired hotkey combination. To use the `"Windows Key`" as part of your hotkey combination simply check the box next designated input box. `"Backspace`" will remove/unset any entered hotkey combinations.")
    HotkeyGui.SetFont("s10 Norm c" CurrentTheme[3])
    HotkeyGui.Add("Text", "w270 Section", "Hotkey Items")
    HotkeyGui.Add("Text", "YS w100", "Use Win Key")
    HotkeyGui.Add("Text", "YS", "Hotkey(s)")
    HotkeyItems := GetHotkeyItems()
    For Item in HotkeyItems
        {
            SetHotkeyItems(Item, HotkeyGui)
        }
    Mechanics := VariableStore("Mechanics")
    For Mechanic in Mechanics
        {
            SetHotkeyItems(Mechanic, Hotkeygui)
        }
    HotkeyGui.Add("Text", "YS R2",)
    HotkeyGui.OnEvent("Size", HotkeyGui_Size)
    OnMessage(0x0115, OnScroll) ; WM_VSCROLL
    OnMessage(0x0114, OnScroll) ; WM_HSCROLL
    OnMessage(0x020A, OnWheel)  ; WM_MOUSEWHEEL
    GuiHeight := "h" A_ScreenHeight - 500
    HotkeyGui.Show("w600" GuiHeight)
    HotkeyGui.OnEvent("Close", HotkeySetupDestroy)
}

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
    HotkeyGui.SetFont("s8 c" CurrentTheme[2])
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
    HotkeyGui.Add("Text", "w1 XM Section", FootNote).OnEvent("Click", HotkeyFootnote.Bind(FootNote))
    HotkeyGui.SetFont("s10 c" CurrentTheme[3])
    HotkeyGui.Add("Text", "w295 x+1 YS", Items).OnEvent("Click", HotkeyFootnote.Bind(FootNote))
    CheckNum := A_Index "Check"
    CheckNum := HotkeyGui.Add("Checkbox", "YS Checked" CheckboxStatus)
    HotkeyGui.Add("Hotkey", "YS Center", CurrentValue).OnEvent("Change", HotkeyEdit.Bind(Items, Checknum))
    CheckNum.OnEvent("Click", WinKeyCheck.Bind(Items))
}

HotkeySetupDestroy(HotkeyGui)
{
    DestroyFootnote()
    HotkeyGui.Destroy()
    ApplyHotkeys()
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
}

HotkeyEdit(Item, WinStatus, KeyCombo, *)
{
    
    NewKey := KeyCombo.Value
    If (WinStatus.Value = 1)
        {
            NewKey := "#" KeyCombo.Value
        }
    HotkeyIni := IniPath("Hotkeys")
    CurrentHotkey := IniRead(HotkeyIni, "Hotkeys", Item)
    IniWrite(NewKey, HotkeyIni, "Hotkeys", Item)
    Hotkeys := GetHotkeyItems()
    For HotkeyItems in Hotkeys
        {
            If (HotkeyItems = "Item")
                {
                    IndexMatch := A_Index
                    HotkeyActions := GetHotkeyPairs()
                    msgbox IndexMatch
                    Hotkey CurrentHotkey, HotkeyActions[IndexMatch], "Off"
                    Break
                }
        }
}

HotkeyGui_Size(GuiObj, MinMax, Width, Height)
{
    If (MinMax != 1)
        UpdateScrollBars(GuiObj)
}

HotkeyFootnote(FootnoteNum, Mechanic, *)
{
    TriggeredBy := "Hotkey Setup"
    WinGetPos(&X, &Y, &W, &H, TriggeredBy)
    XPos := X + W
    YPos := ((Y + H)/2) - 32
    If (FootnoteNum = 1)
        {
            YPos := Y + 200
            GuiInfo := "The `"Map Count`" hotkey is used to remove a map from the Eldritch Influence (Maven, Eater of Worlds and Searing Exarch) count.`r`rThis is not required but highly recommended as depending on the content you are doing you may periodically need to remove a map from the count."
        }
    If (FootnoteNum = 2)
        {
            YPos := Y + 200
            GuiInfo := "The `"Toggle Influence`" hotkey will allow you to quickly switch between Eldritch Influences (Maven, Eater of Worlds and Searing Exarch)."
        }
    If (FootnoteNum = 3)
        {
            YPos := Y + 200
            GuiInfo := "The `"Maven Inventation`" hotkey allows you to quickly open the Maven Invitation Status Menu."
        }
    If (FootnoteNum = 4)
        {
            YPos := Y + 200
            GuiInfo := "The `"Launch PoE`" hotkey allows you to launch Path of Exile along with any configured `"Auto Launch`" items. Auto Launch items can be configured in the Launcher Setup menu.`r`rPlease note, that this hotkey will work everywhere in Windows so it's important to set a hotkey that will not conflict with any other hotkeys or Windows shortcuts you may already be using."
        }
    If (FootnoteNum = 5)
        {
            GuiInfo := "The `"Launcher Tool`" hotkey allows you to quickly launch the Launcher Setup tool."
        }
    If (FootnoteNum = 6)
        {
            GuiInfo := "The `"Portal Key`" hotkey is used to trigger mechanic completion reminders. It is recommended to bind this to whichever key you have your in game Portal hotkey set to.`r`rTo avoid accidental triggers while typing in chat it's highly recommended to setup the `"Chat Delay`" feature in the Notification Settings menu."
        }
    If (FootnoteNum = 7)
        {
            GuiInfo := "The `"Chat Key`" hotkey is used along with the `"Chat Delay`" feature in the Notification Settings menu to ignore key presses of the `"Portal Key`" while typing in chat. By default the hotkey is set to `"Enter`", if you've changed the key and would like to reset it simply press `"Delete`" or `"Backspace`" when in the entry box, this will set it to `"None`" and reset the key to `"Enter`"."
        }
    If (FootnoteNum = 8)
        {
            GuiInfo := "The " Mechanic.Value " hotkey is used to quickly toggle the status of the " Mechanic.Value " mechanic this can be a great alternative to pressing the image to disable tracking."
        }
    ActivateFootnoteGui(GuiInfo, XPos, YPos)
}

ApplyHotkeys()
{
    HotkeyItems := GetHotkeyItems()
    HotkeyPairs := GetHotkeyPairs()
    HotkeyIni := IniPath("Hotkeys")
    For ThisHotkey in HotkeyItems
        {
            HotkeyCombo := IniRead(HotkeyIni, "Hotkeys", ThisHotkey, "")
            If !(HotkeyCombo = "") and (ThisHotkey = "Portal Key") or (ThisHotkey = "Chat Key") 
                {
                    If (ThisHotkey = "Chat Key")
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
    Return ["InfluenceRemoveOne", "ToggleInfluence", "Test", "LaunchPoE", "LauncherGui", "NotifyActiveMechanics", "ChatDelay"]
}