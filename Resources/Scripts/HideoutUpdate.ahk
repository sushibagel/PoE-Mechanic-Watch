#NoEnv
#SingleInstance force
DetectHiddenWindows, On
SetBatchLines, -1
Global HideoutSet
Global UpOneLevel
Global UpTwoLevels

StringTrimRight, UpOneLevel, A_ScriptDir, 7
StringTrimRight, UpTwoLevels, UpOneLevel, 10

IniRead, ColorMode, %UpOneLevel%Settings/Theme.ini, Theme, Theme
IniRead, Font, %UpOneLevel%Settings/Theme.ini, %ColorMode%, Font
IniRead, Background, %UpOneLevel%Settings/Theme.ini, %ColorMode%, Background
IniRead, Secondary, %UpOneLevel%Settings/Theme.ini, %ColorMode%, Secondary

LVArray := []
Gui, Add, Text, c%Font% ,Search:
Gui, Add, Edit, w130 vSearchTerm gSearch -Caption -Border
Gui, Color, Edit, %Secondary%
Gui, Add, ListView, grid r15 w130 vLV gSubmit +AltSubmit, Hideout Name
Gui, +AlwaysOnTop
Gui, -Border
Gui, Color, %Background%
Gui, -Caption
Gui, Add, Button, gCancel, &Cancel

Loop, Read, %UpOneLevel%Data\HideoutList.txt
{
   LV_Add("", A_LoopReadLine)
   LVArray.Push(A_LoopReadLine)
}
TotalItems := LVArray.Length()
LV_ModifyCol()
;Gui, Add, StatusBar, , % "   " . TotalItems . " of " . TotalItems . " Items"
Gui, Show, , ListView
Return

GuiClose:
ExitApp

Search:
if getkeystate("CapsLock","T")
return

GuiControlGet, SearchTerm
GuiControl, -Redraw, LV
LV_Delete()
For Each, FileName In LVArray
{
   If (SearchTerm != "")
   {
      If (InStr(FileName, SearchTerm) = 1) ; for matching at the start
      ; If InStr(FileName, SearchTerm) ; for overall matching
         LV_Add("", FileName)
   }
   Else
      LV_Add("", FileName)
}
Items := LV_GetCount()
SB_SetText("   " . Items . " of " . TotalItems . " Items")
GuiControl, +Redraw, LV
Return

Enter::
NumpadEnter::
if SearchTerm =
{
   Gosub, Warning
}
Else
{
GuiControlGet, SearchTerm
Gui, Destroy
HideoutSet := SearchTerm
GoSub, WriteFile
Return
}

Cancel:
ExitApp

Submit:
If ((A_GuiEvent = "DoubleClick") || (Trigger_Action))
{
clipboard=
LV_GetText(C1,A_EventInfo,1)
HideoutSet = %C1%
Gui, Destroy
GoSub, WriteFile
Return
}
Return

WriteFile:
if HideoutSet !=
{
   If FileExist("Resources\Settings\CurrentHideout.txt")
   {
      FileDelete, Resources\Settings\CurrentHideout.txt
   }
   FileAppend, MyHideout = %HideoutSet% `n, Resources\Settings\CurrentHideout.txt
   HideoutSet :=
   IfWinNotExist, First2
   {
      msgbox, test
      Run, %UpTwoLevels%PoE Mechanic Watch.ahk
      ExitApp
   }
   ExitApp
}

WarningButtonOK:
Reload
ExitApp
Return

Warning:
   Gui, Destroy
   Gui, Warning:Font, s11
   Gui, Warning:Add, Text, c%Font% ,Warning! You Submitted a blank hideout name. Please select a valid hideout!
   Gui, Warning:+AlwaysOnTop
   Gui, Warning:-Border
   Gui, Warning:Color, %Background%
   Gui, Warning:-Caption
   Gui, Warning:Add, Button,,&OK
   Gui, Warning:Show