Global #ctrls

HotkeyUpdate()
{
  Global
  HotkeyIni := HotkeyIni()
  CheckTheme()

  ;Setup text for individual HotKey descriptions
  HotkeyText1 := "Reverse Map Count Hotkey"
  HotkeyText2 := "Launch Path of Exile"
  HotkeyText3 := "Open Tool Launcher"
  HotkeyText4 := "Abyss"
  HotkeyText5 := "Blight"
  HotkeyText6 := "Breach"
  HotkeyText7 := "Expedition"
  HotkeyText8 := "Harvest"
  HotkeyText9 := "Incursion"
  HotkeyText10 := "Metamorph"
  HotkeyText11 := "Ritual"
  HotkeyText12 := "Generic"

  Gui, Hotkey:Color, %Background%
  Gui, Hotkey:Font, s12 c%Font% Bold
  Gui, Hotkey:Add, Text, +Center w500, Click the boxes below and enter your desired key combination. 
  space = y+5
  Gui, Hotkey:Add, Text, %space% +Center w500,(Un)Check the box to toggle the Windows key modifier. 
  Gui, Hotkey:Font, c%Font% s11 Normal
  space = y+1
  Gui, Hotkey:Add, GroupBox, w500 h10 xs %space%

  #ctrls = 12  ;How many Hotkey controls to add.
  Loop,% #ctrls {
  Hotkeytext := "HotkeyText"A_Index
  text := %Hotkeytext%
  Gui, Hotkey:Add, Text, xm x50, %text% ;#%A_Index%:
  IniRead, savedHK%A_Index%, %HotkeyIni%, Hotkeys, %A_Index%, %A_Space%
  If savedHK%A_Index%                                       ;Check for saved hotkeys in INI file.
    Hotkey,% savedHK%A_Index%, Label%A_Index%, UseErrorLevel               ;Activate saved hotkeys if found.
  StringReplace, noMods, savedHK%A_Index%, ~                  ;Remove tilde (~) and Win (#) modifiers...
  StringReplace, noMods, noMods, #,,UseErrorLevel              ;They are incompatible with hotkey controls (cannot be shown).
  Gui, Hotkey:Add, CheckBox, yp x250 +Left vCB%A_Index% Checked%ErrorLevel%, Win  ;Add checkboxes to allow the Windows key (#) as a modifier...
  Gui, Hotkey:Add, Hotkey, yp x300 vHK%A_Index% gLabel, %noMods%           ;Add hotkey controls and show saved hotkeys.
  }
  Gui, Hotkey:Show, w550,Dynamic Hotkeys
  return
}

Label()
{
  If %A_GuiControl% in +,^,!,+^,+!,^!,+^!    ;If the hotkey contains only modifiers, return to wait for a key.
    return
  num := SubStr(A_GuiControl,3)              ;Get the index number of the hotkey control.
  If (HK%num% != "") {                       ;If the hotkey is not blank...
    Gui, Hotkey:Submit, NoHide
    If CB%num%                                ;  If the 'Win' box is checked, then add its modifier (#).
    HK%num% := "#" HK%num%
    If !RegExMatch(HK%num%,"[#!\^\+]")        ;  If the new hotkey has no modifiers, add the (~) modifier.
    HK%num% := "~" HK%num%                   ;    This prevents any key from being blocked.
    Loop,% #ctrls
    If (HK%num% = savedHK%A_Index%) {        ;  Check for duplicate hotkey...
      dup := A_Index
      Loop,6 {
      GuiControl,% "Disable" b:=!b, HK%dup%  ;    Flash the original hotkey to alert the user.
      Sleep,200
      }
      GuiControl,,HK%num%,% HK%num% :=""      ;    Delete the hotkey and clear the control.
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
    Hotkey, %INI%, Label%num%, Off, UseErrorLevel
  If GUI
    Hotkey, %GUI%, Label%num%, On, UseErrorLevel
  IniWrite,% GUI ? GUI:null, %HotkeyPath%, Hotkeys, %num%
  savedHK%num%  := HK%num%
  TrayTip, Map Hotkey Changed, % !INI ? GUI " ON":!GUI ? INI " OFF":GUI " ON`n" INI " OFF"
}

HotkeyGuiClose()
{
  Gui, Hotkey:Destroy
  SetHotKeys()
  FirstRunPath := FirstRunIni()
    IniRead, Active, %FirstRunPath%, Active, Active
    If (Active = 1)
    {
        FirstRunPath := FirstRunIni()
        Iniwrite, 1, %FirstRunPath%, Completion, Hotkey
        FirstRun()
        Exit
    }
  PostSetup()
  PostMessage, 0x01786,,,, PoE Mechanic Watch.ahk - AutoHotkey ;Run script start function
  PostRestore()
  Return
}

SetHotkeys()
  {
    HotkeyPath := HotkeyIni()
    Loop, 12
    {
      IniRead, Hotkey%A_Index%, %HotkeyPath%, Hotkeys, %A_Index%
      HotkeyOffCheck := "Hotkey"A_Index
      If (%HotkeyOffCheck% = "") Or (%HotkeyOffCheck% = "Error")
      {
        Hotkey, %HotkeyOffCheck%, Off, UseErrorLevel
      }
    }
    Return
  }

  InfluenceHotkey()
  {
    HotkeyPath := HotkeyIni()
    IniRead, InfluenceHotkey, %HotkeyPath%, Hotkeys, 1

    If InfluenceHotkey contains +
    {
        StringReplace, InfluenceHotkey, InfluenceHotkey, + , Shift +%A_Space%,
    }
    If InfluenceHotkey contains ^
    {
        StringReplace, InfluenceHotkey, InfluenceHotkey, ^ , Control +%A_Space%,
    }
    If InfluenceHotkey contains !
    {
        StringReplace, InfluenceHotkey, InfluenceHotkey, ! , Alt +%A_Space%,
    }
    If InfluenceHotkey contains #
    {
        StringReplace, InfluenceHotkey, InfluenceHotkey, # , Win +%A_Space%,
    }
    If (InfluenceHotkey = "")
    {
      InfluenceHotkey := "HOTKEY NOT SET"
    }

    Return, % InfluenceHotkey
  }