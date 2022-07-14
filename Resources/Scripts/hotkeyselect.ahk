#SingleInstance force
#NoEnv
Global UpOneLevel
SetBatchLines, -1

StringTrimRight, UpOneLevel, A_ScriptDir, 7

#ctrls = 1  ;How many Hotkey controls to add.
Loop,% #ctrls {
 Gui, Add, Text, xm, Reverse Map Count Hotkey #%A_Index%:
 IniRead, savedHK%A_Index%, %UpOneLevel%Settings/Hotkeys.ini, Hotkeys, %A_Index%, %A_Space%
 If savedHK%A_Index%                                       ;Check for saved hotkeys in INI file.
  Hotkey,% savedHK%A_Index%, Label%A_Index%                 ;Activate saved hotkeys if found.
 StringReplace, noMods, savedHK%A_Index%, ~                  ;Remove tilde (~) and Win (#) modifiers...
 StringReplace, noMods, noMods, #,,UseErrorLevel              ;They are incompatible with hotkey controls (cannot be shown).
 Gui, Add, Hotkey, x+5 vHK%A_Index% gLabel, %noMods%           ;Add hotkey controls and show saved hotkeys.
 Gui, Add, CheckBox, x+5 vCB%A_Index% Checked%ErrorLevel%, Win  ;Add checkboxes to allow the Windows key (#) as a modifier...
}                                                                ;Check the box if Win modifier is used.
Gui, Show,,Dynamic Hotkeys
return
GuiClose:
 ExitApp

Label:
 If %A_GuiControl% in +,^,!,+^,+!,^!,+^!    ;If the hotkey contains only modifiers, return to wait for a key.
  return
 num := SubStr(A_GuiControl,3)              ;Get the index number of the hotkey control.
 If (HK%num% != "") {                       ;If the hotkey is not blank...
  Gui, Submit, NoHide
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

setHK(num,INI,GUI) {
 If INI
  Hotkey, %INI%, Label%num%, Off
 If GUI
  Hotkey, %GUI%, Label%num%, On
 IniWrite,% GUI ? GUI:null, %UpOneLevel%Settings/Hotkeys.ini, Hotkeys, %num%
 savedHK%num%  := HK%num%
 TrayTip, Label%num%,% !INI ? GUI " ON":!GUI ? INI " OFF":GUI " ON`n" INI " OFF"
}

;These labels may contain any commands for their respective hotkeys to perform.
Label1:
 MsgBox,% A_ThisLabel "`n" A_ThisHotkey
return

Label2:
 MsgBox,% A_ThisLabel "`n" A_ThisHotkey
return

Label3:
 MsgBox,% A_ThisLabel "`n" A_ThisHotkey
return

Label4:
 MsgBox,% A_ThisLabel "`n" A_ThisHotkey
return

Label5:
 MsgBox,% A_ThisLabel "`n" A_ThisHotkey
return