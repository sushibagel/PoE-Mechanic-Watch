Global #ctrls
Global ControlCheck

HotkeyUpdate()
{
  Global
  HotkeyIni := HotkeyIni()
  CheckTheme()

  HotkeyMechanics := GetHokeyMechanics()

  Gui, Hotkey:Color, %Background%
  Gui, Hotkey:Font, s12 c%Font% Bold
  Gui, Hotkey:Add, Text, +Center w500, Click the boxes below and enter your desired key combination.
  space = y+5
  Gui, Hotkey:Add, Text, %space% +Center w500,(Un)Check the box to toggle the Windows key modifier.
  Gui, Hotkey:Font, s7 c%Font% Normal
  Gui, Hotkey:Add, Text, %space% +Center w500,Note: To add the Windows Key as part of your hotkey you MUST check the box prior to entering in your hotkey value.
  Gui, Hotkey:Font, c%Font% s11 Normal
  space = y+1
  Gui, Hotkey:Add, GroupBox, w500 h10 xs %space%
  IniRead, CtlActive, %HotkeyIni%, Hotkeys, DivCheck, 0

  For each, HotkeyItem in StrSplit(HotKeyMechanics, "|")
    {
      HotKeyText := HotkeyItem
      If (HotkeyItem = "MapCount")
        {
          HotkeyText := "Reverse Map Count Hotkey"
        }
      If (HotkeyItem = "ToggleInfluence")
        {
          HotkeyText := "Toggle Influence"
        }
      If (HotkeyItem = "MavenInvitation")
        {
          HotkeyText := "Maven Invitation Status"
        }
      If (HotkeyItem = "LaunchPoE")
        {
          HotkeyText := "Launch Path of Exile"
        }
      If (HotkeyItem = "ToolLauncher")
        {
          HotkeyText := "Open Tool Launcher"
        }
      If (HotkeyItem = "MasterMapping")
        {
          HotkeyText := "Master Mapping Tool"
        }
  
      Gui, Hotkey:Add, Text, xm x50, %HotKeyText% ;#%A_Index%:
      IniRead, savedHK%HotkeyItem%, %HotkeyIni%, Hotkeys, %HotkeyItem%, %A_Space%
      If savedHK%HotkeyItem% ;Check for saved hotkeys in INI file.
        Hotkey,% savedHK%HotkeyItem%, Label%HotkeyItem%, UseErrorLevel ;Activate saved hotkeys if found.
      StringReplace, noMods, savedHK%HotkeyItem%, ~ ;Remove tilde (~) and Win (#) modifiers...
      StringReplace, noMods, noMods, #,,UseErrorLevel ;They are incompatible with hotkey controls (cannot be shown).
        Gui, Hotkey:Add, CheckBox, yp x250 +Left vCB%HotkeyItem% Checked%ErrorLevel%, Win ;Add checkboxes to allow the Windows key (#) as a modifier...
        Gui, Hotkey:Add, Hotkey, yp x300 vHK%HotkeyItem% gLabel, %noMods% ;Add hotkey controls and show saved hotkeys.
    }
    Gui, Hotkey:Show, w550, Hotkey Selector
    return
}

Label()
{
  If %A_GuiControl% in +,^,!,+^,+!,^!,+^! ;If the hotkey contains only modifiers, return to wait for a key.
    return
  num := SubStr(A_GuiControl,3) ;Get the index number of the hotkey control.
  If (HK%num% != "") { ;If the hotkey is not blank...
    Gui, Hotkey:Submit, NoHide
    If CB%num% ;  If the 'Win' box is checked, then add its modifier (#).
      HK%num% := "#" HK%num%
    If !RegExMatch(HK%num%,"[#!\^\+]") ;  If the new hotkey has no modifiers, add the (~) modifier.
      HK%num% := "~" HK%num% ;    This prevents any key from being blocked.
    Loop,% #ctrls
      If (HK%num% = savedHK%A_Index%) { ;  Check for duplicate hotkey...
        dup := A_Index
        Loop,6 {
          GuiControl,% "Disable" b:=!b, HK%dup% ;    Flash the original hotkey to alert the user.
          Sleep,200
        }
        GuiControl,,HK%num%,% HK%num% :="" ;    Delete the hotkey and clear the control.
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
  savedHK%num% := HK%num%
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
  PostMessage, 0x01789,,,, PoE Mechanic Watch.ahk - AutoHotkey ;Run script reload function
  PostRestore()
  Return
}

SetHotkeys()
{
  HotkeyPath := HotkeyIni()
  HotkeyMechanics := GetHokeyMechanics()
  For each, HotkeyItem in StrSplit(HotKeyMechanics, "|")
    {
      IniRead, Hotkey%HotkeyItem%, %HotkeyPath%, Hotkeys, %HotkeyItem%
      HotkeyOffCheck := "Hotkey"HotkeyItem
      If (%HotkeyOffCheck% = "") Or (%HotkeyOffCheck% = "Error")
      {
        Hotkey, %HotkeyOffCheck%, Off, UseErrorLevel
      }
      Return
    }
  }

InfluenceHotkey()
{
  HotkeyPath := HotkeyIni()
  IniRead, InfluenceHotkey, %HotkeyPath%, Hotkeys, MapCount

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

CtlToggle()
{
  HotkeyIni := HotkeyIni()
  Gui, Hotkey:Submit, NoHide
  IniWrite, %ControlCheck%, %HotkeyIni%, Hotkeys, DivCheck
}

MasterHotkeyGet()
{
  HotkeyPath := HotkeyIni()
  IniRead, ToggleKey, %HotkeyPath%, Hotkeys, MasterMapping, Hotkey Not Set
  If ToggleKey contains +
  {
    StringReplace, ToggleKey, ToggleKey, + , Shift +%A_Space%,
  }
  If ToggleKey contains ^
  {
    StringReplace, ToggleKey, ToggleKey, ^ , Control +%A_Space%,
  }
  If ToggleKey contains !
  {
    StringReplace, ToggleKey, ToggleKey, ! , Alt +%A_Space%,
  }
  If ToggleKey contains #
  {
    StringReplace, ToggleKey, ToggleKey, # , Win +%A_Space%,
  }
  If (ToggleKey = "")
  {
    ToggleKey := "Hotkey Not Set"
  }

  Return, % ToggleKey
}

GetHokeyMechanics()
{
  Return, "MapCount|ToggleInfluence|MavenInvitation|LaunchPoE|ToolLauncher|Abyss|Betrayal|Blight|Breach|Einhar|Expedition|Harvest|Incursion|Legion|Niko|Ritual|Ultimatum|Generic|MasterMapping"
}