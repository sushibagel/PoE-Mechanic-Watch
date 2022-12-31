Global CBScreenCapHotkey
Global HKScreenCapHotkey

DeathReviewSetup()
Exit

DeathCapture()
{
    SendLevel, 1
    Send, !{f10}
}

DeathReviewSetup()
{
    Gui, Death:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
    Gui, Death:Font, c%Font% s13 Bold
    Gui, Death:Add, Text, % dpi("w810 +Center"), Death Review Settings
    Gui, Death:Font
    Gui, Death:Font, c%Font% s9
    Gui, Death:Add, Text,% dpi("w810" "h1"), Note: For on death review you must enable screen recording in your GPU software (NVIDIA ShadowPlay or AMD ReLive) and setup the hotkey below. A character name is not required but will prevent saving recordings when another player in your group dies. If you use the "Delete Recording" function I highly recommend setting a dedicated folder for saving the your videos, I AM NOT RESPONSIBLE IF YOUR HOMEWORK OR IMPORTANT FILES GET DELETED. 
    Gui, Death:Font, c%Font% s1
    Gui, Death:Add, GroupBox, % dpi("x0 w810 h1") 
    Space = y+2
    Gui, Death: -Caption
    Gui, Death:Font, c%Font% s11 Bold Underline
    Gui, Death:Add, Text, xs x10 Section, Hotkey
    Gui, Death:Font
    Gui, Death:Font, c%Font% s%fw%
    Gui, Death:Font, c%Font%
    Gui, Death:Add, Button, xn x20 Section, Close
    Gui, Death:Color, %Background%
    
    #ctrls = 1  ;How many Hotkey controls to add.
    Loop,% #ctrls {
    HotkeyIin := HotkeyIni()
    IniRead, ScreenCapHotkey, %HotkeyIni%, Screen Record, Screen Record, %A_Space%
    If %ScreenCapHotkey%                                   ;Check for saved hotkeys in INI file.
    Hotkey, %ScreenCapHotkey%, DeathCapture, UseErrorLevel               ;Activate saved hotkeys if found.
    StringReplace, noMods, savedHK%A_Index%, ~                  ;Remove tilde (~) and Win (#) modifiers...
    StringReplace, noMods, noMods, #,,UseErrorLevel              ;They are incompatible with hotkey controls (cannot be shown).
    Gui, Death:Add, CheckBox, yp x250 +Left vCBScreenCapHotkey Checked%ErrorLevel%, Win  ;Add checkboxes to allow the Windows key (#) as a modifier...
    Gui, Death:Add, Hotkey, yp x300 vHKScreenCapHotkey gSetLabel, %noMods%           ;Add hotkey controls and show saved hotkeys.
  }
    Gui, Death:Show, % dpi("w810" "h300"), Death Review Settings
    return
}

SetLabel()
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
    setSC(num, savedHK%num%, HK%num%)
  return
}

SetSC(num,INI,GUI) 
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