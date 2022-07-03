#NoEnv
#SingleInstance force
SetBatchLines, -1
Global HideoutSet

LVArray := []
Gui, Add, Text, cWhite ,Search:
Gui, Add, Edit, w130 vSearchTerm gSearch -Caption -Border
Gui, Color, Edit, a6a6a6
Gui, Add, ListView, grid r15 w130 vLV gSubmit +AltSubmit, Hideout Name
Gui, +AlwaysOnTop
Gui, -Border
Gui, Color, 4e4f53
Gui, -Caption
Gui, Add, Button, gCancel, &Cancel
Loop, Read, Hideoutlist.txt
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
   Gui, Destroy
   MsgBox, Warning! You Submitted a blank hideout name. Please select a valid hideout!
   Reload
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
HideoutSet := C1
Gui, Destroy
GoSub, WriteFile
Return
}

WriteFile:
if HideoutSet !=
{
   FileDelete, CurrentHideout.txt
   FileAppend, MyHideout = %HideoutSet% `n, CurrentHideout.txt
   HideoutSet :=
   Run, PoE Mechanic Watch.ahk
   ExitApp
}