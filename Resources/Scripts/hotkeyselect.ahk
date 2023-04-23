Global ctrls
Global ControlCheck

HotkeyUpdate()
{
  Global
  HotkeyIni := HotkeyIni()
  CheckTheme()

  ;Setup text for individual HotKey descriptions
  HotkeyText1 := "Divination Card Input"
  HotkeyText2 := "Reverse Map Count Hotkey"
  HotkeyText3 := "Toggle Influence"
  HotkeyText4 := "Maven Invitation Status"
  HotkeyText5 := "Launch Path of Exile"
  HotkeyText6 := "Open Tool Launcher"
  HotkeyText7 := "Abyss"
  HotkeyText8 := "Blight"
  HotkeyText9 := "Breach"
  HotkeyText10 := "Expedition"
  HotkeyText11 := "Harvest"
  HotkeyText12 := "Incursion"
  HotkeyText13 := "Legion"
  HotkeyText14 := "Metamorph"
  HotkeyText15 := "Ritual"
  HotkeyText16 := "Generic"

  Hotkey := Gui()
  Hotkey.BackColor := Background
  Hotkey.SetFont("s12 c" . Font . " Bold")
  Hotkey.Add("Text", "+Center w500", "Click the boxes below and enter your desired key combination.")
  space := "y+5"
  Hotkey.Add("Text", space . " +Center w500", "(Un)Check the box to toggle the Windows key modifier.")
  Hotkey.SetFont("c" . Font . " s11 Normal")
  space := "y+1"
  Hotkey.Add("GroupBox", "w500 h10 xs " . space)
  Hotkey.Add("Text", "xm x50", "`"Ctl + C`" Div Card Check") ;#%A_Index%:
  CtlActive := IniRead(HotkeyIni, "Hotkeys", "DivCheck", 0)
  ogcControlCheck := Hotkey.Add("Checkbox", "yp x250 +Left vControlCheck  Checked" . CtlActive)
  ogcControlCheck.OnEvent("Click", CtlToggle.Bind("Normal"))

  ctrls := 16  ;How many Hotkey controls to add.
  Loop %ctrls% {
  Hotkeytext := "HotkeyText"A_Index
  text := %Hotkeytext%
  Hotkey.Add("Text", "xm x50", text) ;#%A_Index%:
  savedHK%A_Index% := IniRead(HotkeyIni, "Hotkeys", A_Index, A_Space)
  If savedHK%A_Index%                                       ;Check for saved hotkeys in INI file.
    Hotkey(savedHK%A_Index%, Label%A_Index%, "UseErrorLevel")               ;Activate saved hotkeys if found.
  ; StrReplace() is not case sensitive
  ; check for StringCaseSense in v1 source script
  ; and change the CaseSense param in StrReplace() if necessary
  noMods := StrReplace(savedHK%A_Index%, "~",,,, 1)                  ;Remove tilde (~) and Win (#) modifiers...
  ; StrReplace() is not case sensitive
  ; check for StringCaseSense in v1 source script
  ; and change the CaseSense param in StrReplace() if necessary
  noMods := StrReplace(noMods, "#", ,, &ErrorLevel)              ;They are incompatible with hotkey controls (cannot be shown).
  ogcCheckBoxCB := Hotkey.Add("CheckBox", "yp x250 +Left vCB" . A_Index . " Checked" . ErrorLevel, "Win")  ;Add checkboxes to allow the Windows key (#) as a modifier...
  ogcHotkeyHK := Hotkey.Add("Hotkey", "yp x300 vHK" . A_Index, noMods)
  ogcHotkeyHK.OnEvent("Change", Label.Bind("Change"))           ;Add hotkey controls and show saved hotkeys.
  }
  Hotkey.Title := "Hotkey Selector"
  Hotkey.Show("w550")
  return
}

Label()
{
  ModifierKeys := "+,^,!,+^,+!,^!,+^!" 
  ModifierKeys := StrSplit(ModifierKeys, ",")
  Loop
    {
      If (A_GuiControl = ModifierKeys[A_Index])
        {
          Return
        }
    }
  ; If %A_GuiControl% in +,^,!,+^,+!,^!,+^!    ;If the hotkey contains only modifiers, return to wait for a key.
  ;   return
  num := SubStr(A_GuiControl, 3)              ;Get the index number of the hotkey control.
  If (HK%num% != "") {                       ;If the hotkey is not blank...
    oSaved := Hotkey.Submit("0")
    ControlCheck := oSaved.ControlCheck
    CB := oSaved.CB
    HK := oSaved.HK
    If CB%num%                                ;  If the 'Win' box is checked, then add its modifier (#).
    HK%num% := "#" HK%num%
    If !RegExMatch(HK%num%, "[#!\^\+]")        ;  If the new hotkey has no modifiers, add the (~) modifier.
    HK%num% := "~" HK%num%                   ;    This prevents any key from being blocked.
    Loop %ctrls%
    If (HK%num% = savedHK%A_Index%) {        ;  Check for duplicate hotkey...
      dup := A_Index
      Loop 6 {
        ;    Flash the original hotkey to alert the user.
      Sleep(200)
      }
      ogcHK%num%.Value := HK%num% :=""      ;    Delete the hotkey and clear the control.
      break
    }
  }
  If (savedHK%num% || HK%num%)
    setHK(num, savedHK%num%, HK%num%)
  return
}

SetHK(num,INI,GUI) 
{
  HotkeyPath := HotkeyIni()
  If INI
    Hotkey(INI, Label%num%, "Off, UseErrorLevel")
  If GUI
    Hotkey(GUI, Label%num%, "On, UseErrorLevel")
  IniWrite(GUI ? GUI:null, HotkeyPath, "Hotkeys", num)
  savedHK%num%  := HK%num%
  TrayTip("Map Hotkey Changed", !INI ? GUI " ON":!GUI ? INI " OFF":GUI " ON`n" INI " OFF")
}

HotkeyGuiClose()
{
  Hotkey.Destroy()
  SetHotKeys()
  FirstRunPath := FirstRunIni()
    Active := IniRead(FirstRunPath, "Active", "Active")
    If (Active = 1)
    {
        FirstRunPath := FirstRunIni()
        IniWrite(1, FirstRunPath, "Completion", "Hotkey")
        FirstRun()
        Exit()
    }
  PostSetup()
  PostMessage(0x01789, , , , "PoE Mechanic Watch.ahk - AutoHotkey") ;Run script reload function
  PostRestore()
  Return
}

SetHotkeys()
  {
    HotkeyPath := HotkeyIni()
    Loop 14
    {
      Hotkey%A_Index% := IniRead(HotkeyPath, "Hotkeys", A_Index)
      HotkeyOffCheck := "Hotkey"A_Index
      If (%HotkeyOffCheck% = "") Or (%HotkeyOffCheck% = "Error")
      {
        Hotkey(HotkeyOffCheck, "Off", "UseErrorLevel")
      }
    }
    Return
  }

  InfluenceHotkey()
  {
    HotkeyPath := HotkeyIni()
    InfluenceHotkey := IniRead(HotkeyPath, "Hotkeys", 1)

    if (InfluenceHotkey ~= "i)(\+)")
    {
        ; StrReplace() is not case sensitive
        ; check for StringCaseSense in v1 source script
        ; and change the CaseSense param in StrReplace() if necessary
        InfluenceHotkey := StrReplace(InfluenceHotkey, "+", "Shift +" A_Space,,, 1)
    }
    if (InfluenceHotkey ~= "i)(\^)")
    {
        ; StrReplace() is not case sensitive
        ; check for StringCaseSense in v1 source script
        ; and change the CaseSense param in StrReplace() if necessary
        InfluenceHotkey := StrReplace(InfluenceHotkey, "^", "Control +" A_Space,,, 1)
    }
    if (InfluenceHotkey ~= "i)(!)")
    {
        ; StrReplace() is not case sensitive
        ; check for StringCaseSense in v1 source script
        ; and change the CaseSense param in StrReplace() if necessary
        InfluenceHotkey := StrReplace(InfluenceHotkey, "!", "Alt +" A_Space,,, 1)
    }
    if (InfluenceHotkey ~= "i)(#)")
    {
        ; StrReplace() is not case sensitive
        ; check for StringCaseSense in v1 source script
        ; and change the CaseSense param in StrReplace() if necessary
        InfluenceHotkey := StrReplace(InfluenceHotkey, "#", "Win +" A_Space,,, 1)
    }
    If (InfluenceHotkey = "")
    {
      InfluenceHotkey := "HOTKEY NOT SET"
    }

    Return InfluenceHotkey
  }

  CtlToggle()
  {
    HotkeyIni := HotkeyIni()
    oSaved := Hotkey.Submit("0")
    ControlCheck := oSaved.ControlCheck
    CB := oSaved.CB
    HK := oSaved.HK
    IniWrite(ControlCheck, HotkeyIni, "Hotkeys", "DivCheck")
  }