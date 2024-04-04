#SingleInstance, Force
#Persistent
#NoEnv
#MaxMem 1024
#NoTrayIcon ;need to enable for release
Menu, Tray, Icon, Resources\Images\incursion.png
SetBatchLines, -1
Global FinishedCoord
Global EinharComplete

OnMessage(0x01987, "GetSideTextArea")
OnMessage(0x01988, "GetRitualTextArea")

;	REF: https://www.autohotkey.com/boards/viewtopic.php?t=72674
;	PROVIDED BY: teadrinker
;	DATE: February 21st, 2020
;	NOTES: Optical character recognition (OCR) with UWP API

GroupAdd, PoeWindow, ahk_exe PathOfExileSteam.exe
GroupAdd, PoeWindow, ahk_exe PathOfExile.exe
GroupAdd, PoeWindow, ahk_exe PathOfExileEGS.exe
GroupAdd, PoeWindow, ahk_class POEWindowClass
; GroupAdd, PoeWindow, ahk_exe Code.exe

Start()
Return

GetTextArea(SelectedArea)
{
   GetArea()
   ScreenIni := ScreenIni()
   For each, Coordinate in StrSplit("x|y|w|h", "|")
   {
      IniRead, Coord, %ScreenIni%, OCR Area, %Coordinate%
      IniWrite, %Coord%, %ScreenIni%, %SelectedArea%, %Coordinate%
      IniWrite, %blankVariable%, %ScreenIni%, OCR Area, %Coordinate%
   }
}

Start()
{
   WinWaitActive, ahk_group PoeWindow
   MechanicsIni := MechanicsIni()
   OCRMechanics := OCRMechanics()
   OCRMechanics := StrSplit(OCRMechanics, "|")
   MechanicCount := OCRMechanics.MaxIndex()
   Loop, %MechanicCount% ;Check if any Screen Searches are active before enabling the timer. I'm not setting th   e search variables here because I don't want to activate the timer twice.
   {
      IniRead, ActiveCheck, %MechanicsIni%, Auto Mechanics, % OCRMechanics[A_Index], 0
      If (ActiveCheck = 1)
      {
         IniRead, mActiveCheck, %MechanicsIni%, Mechanics, % OCRMechanics[A_Index], 0 ; Now check that the mechanic tracking is enabled for the overlay.
         If (mActiveCheck > 0)
         {
            SetTimer, CheckScreen, 800
            Break
         }
      }
   }
}
Return

OCRMechanics()
{
   Return, "Incursion|Niko|Betrayal|Einhar|Ritual"
}

CheckScreen()
{
   If !WinActive("ahk_group PoeWindow")
   {
      SetTimer, CheckScreen, Off
      Start()
   }
   HideoutIni := HideoutIni()
   Loop
   {
      IniRead, HideoutStatus, %HideoutIni%, In Hideout, In Hideout
      If (HideoutStatus = 1)
      {
         Sleep, 5000
      }
      If (HideoutStatus = 0)
      {
         Break
      }
   }
   ScreenIni := ScreenIni()
   For each, Coordinate in StrSplit("x|y|w|h", "|")
   {
      If (Coordinate = "x")
      {
         Default := A_ScreenWidth/2
      }
      If (Coordinate = "y")
      {
         Default := 0
      }
      If (Coordinate = "w")
      {
         Default := A_ScreenWidth
      }
      If (Coordinate = "h")
      {
         Default := A_ScreenHeight
      }
      Search := "Search" Coordinate
      IniRead, %Search%, %ScreenIni%, Side Area, %Coordinate%, %Default%
   }
   hBitmap := HBitmapFromScreen(SearchX, SearchY, SearchW, SearchH)
   pIRandomAccessStream := HBitmapToRandomAccessStream(hBitmap)
   DllCall("DeleteObject", "Ptr", hBitmap)
   v_text := OCR(pIRandomAccessStream, "en")
   ObjRelease(pIRandomAccessStream)
   ScreenText := % v_text
   v_Reminder :=
   OCRMechanics := OCRMechanics()
   OCRMechanics := StrSplit(OCRMechanics, "|")
   MechanicCount := OCRMechanics.MaxIndex()
   MechanicsIni := MechanicsIni()
   Loop, %MechanicCount% ;Check if any Screen Searches are active before enabling the timer. I'm not setting the search variables here because I don't want to activate the timer twice.
   {
      IniRead, ActiveCheck, %MechanicsIni%, Auto Mechanics, % OCRMechanics[A_Index], 0
      IniRead, mActiveCheck, %MechanicsIni%, Mechanics, % OCRMechanics[A_Index], 0 ; Now check that the mechanic tracking is enabled for the overlay.
      If(ActiveCheck = 1) and (mActiveCheck > 0)
      {
         ; Define the regex pattern
         EinharPattern := ".*(?:Find and weaken|weaken the beasts|Einhar, Beastmaster|Einhar Beastmaster).*"
         ; Check if the string matches the regex pattern
         If (RegExMatch(ScreenText, EinharPattern)) and (OCRMechanics[A_Index] = "Einhar")
         {
            ;now look for specific match matches to determine what part of the chain we are in.
            If InStr(ScreenText, "Mission complete")
            {
               MechanicsIni := MechanicsIni()
               IniRead, CurrentStatus, %MechanicsIni%, Mechanic Active, Einhar, 0
               If (CurrentStatus = 1)
               {
                  IniWrite, 0, %MechanicsIni%, Mechanic Active, Einhar
                  IniWrite, %BlankVariable%, %MechanicsIni%, Einhar Track, Current Count
                  RefreshOverlay()
               }
            }

            EinharPattern := ".*(?:Find and weaken|weaken the beasts).*"
            If (RegExMatch(ScreenText, EinharPattern)) and (OCRMechanics[A_Index] = "Einhar") ; Find Einhar mission in the screen text and check that it the auto mechanic is active.
            {
               EinharProcessPattern := ".*(?:Find and weaken|weaken the beasts).*"
               If (RegExMatch(ScreenText, EinharProcessPattern)) ;Narrow down the search to see if the mission was completed.
               {
                  EinharCount := StrSplit(ScreenText, "`n") ;Split the text found on screen by lines.
                  EinharLines := EinharCount.MaxIndex()
                  Loop, %EinharLines%
                  {
                     If (RegexMatch(EinharCount[A_Index],EinharProcessPattern))
                     {
                        IndexMatch := A_Index -1
                        Loop, 2
                        {
                           IndexMatch++
                           If InStr(EinharCount[IndexMatch], "(")
                           {
                              EinharCount := StrSplit(EinharCount[IndexMatch],"(")
                              EinharCount := StrSplit(EinharCount[2],")")
                              If InStr(EinharCount[1], "/") ;If "/" is found in the number sequence we just use that as the "Count" text for the overlay.
                              {
                                 EinharCount := EinharCount[1]
                                 Break
                              }
                              Else
                                 {
                                    MechanicsIni := MechanicsIni()
                                    IniRead, ActiveCheck, %MechanicsIni%, Section, Einhar, 0
                                    If (EinharCount[1] = "") and !(ActiveCheck = 1) ;If the string is empty the first step of the mechanic probably hasn't been completed so we'll just leave it blank.
                                    {
                                       EinharCount := 0
                                    }
      
                                    If !(EinharCount[1] = "") ;If we don't find the "/" and the string isn't empty we need to figure out the correct "count"
                                    {
                                       If (StrLen(EinharCount[1]) = 3) and !(EinharCount[1] = "")
                                       {
      
                                          EinharCount := StrSplit(EinharCount[1])
                                          EinharCount := EinharCount[1] "/" EinharCount[3]
                                       }
                                       If (StrLen(EinharCount[1]) = 4) and !(EinharCount[1] = "")
                                       {
                                          EinharCount := StrSplit(EinharCount[1])
                                          EinharCount := EinharCount[1] "/" EinharCount[3] EinharCount[4]
                                       }
                                       If (StrLen(EinharCount[1]) = 5) and !(EinharCount[1] = "")
                                       {
                                          EinharCount := StrSplit(EinharCount[1])
                                          EinharCount := EinharCount[1] EinharCount[2] "/" EinharCount[4] EinharCount[5]
                                       }
                                    }
                                 }
                           }
                        }
                     }
                  }
               }
               MechanicsIni := MechanicsIni()
               CurrentCount := ""
               IniRead, CurrentCount, %MechanicsIni%, Einhar Track, Current Count
               If !(CurrentCount = EinharCount)
               {
                  MechanicsIni := MechanicsIni()
                  IniRead, EinharActive, %MechanicsIni%, Mechanic Active, Einhar, 0
                  If (EinharActive = 1) and !(EinharCount > 0)
                     {
                        
                     }
                  Else
                     {
                        IniWrite, %EinharCount%, %MechanicsIni%, Einhar Track, Current Count
                        IniWrite, 1, %MechanicsIni%, Mechanic Active, Einhar
                        RefreshOverlay()  
                     }
               }
            }
         }

         NikoPattern := ".*(?:Master of the Depths|Niko, Master|Niko Master|Master of the Depths|Find the Voltaxic|Voltaxic Sulphite deposits).*"
         If (RegExMatch(ScreenText, NikoPattern)) and (OCRMechanics[A_Index] = "Niko") ; Here I would put in the specific text to search for I believe it could be used for Alva, Niko, Betrayal maybe other mechanics?
         {
            NikoProcessPattern := ".*(?:Find the Voltaxic|Voltaxic Sulphite deposits).*"
            If (RegExMatch(ScreenText, NikoProcessPattern))
            {
               NikoCount := StrSplit(ScreenText, "`n")
               NikoLines := NikoCount.MaxIndex()
               Loop, %NikoLines%
               {
                  If (RegexMatch(NikoCount[A_Index],NikoProcessPattern))
                  {
                     IndexMatch := A_Index -1
                     Loop, 2
                     {
                        IndexMatch++
                        If InStr(NikoCount[IndexMatch], "(")
                        {
                           NikoCount := StrSplit(NikoCount[IndexMatch],"(")
                           NikoCount := StrSplit(NikoCount[2],")")
                           If InStr(NikoCount[1], "/")
                           {
                              NikoCount := NikoCount[1]
                              Break
                           }
                           Else
                              {
                                 MechanicsIni := MechanicsIni()
                                 IniRead, ActiveCheck, %MechanicsIni%, Section, Niko, 0
                                 If (NikoCount[1] = "") and !(ActiveCheck = 1)
                                 {
                                    NikoCount := 0
                                 }
                                 If !(NikoCount[1] = "")
                                 {
                                    NikoCount := StrSplit(NikoCount[1])
                                    NikoCount := NikoCount[1] "/" NikoCount[3]
                                 }
                              }
                        }
                     }
                  }
               }
               MechanicsIni := MechanicsIni()
               CurrentCount := ""
               IniRead, CurrentCount, %MechanicsIni%, Niko Track, Current Count
               If !(CurrentCount = NikoCount)
               {
                  MechanicsIni := MechanicsIni()
                  IniRead, NikoActive, %MechanicsIni%, Mechanic Active, Niko, 0
                  If (NikoActive = 1) and !((NikoCount = "1/3") or (NikoCount = "2/3"))
                     {

                     }
                  Else
                     {
                        IniWrite, %NikoCount%, %MechanicsIni%, Niko Track, Current Count
                        IniWrite, 1, %MechanicsIni%, Mechanic Active, Niko
                        RefreshOverlay()
                     }
               }
            }

            If InStr(ScreenText, "Mission Complete")
            {
               NikoCount := StrSplit(ScreenText, "`n")
               NikoLines := NikoCount.MaxIndex()
               Loop, %NikoLines%
               {
                  If (RegexMatch(NikoCount[A_Index],NikoPattern))
                  {
                     CheckCompletion := A_Index + 1
                     If InStr(NikoCount[CheckCompletion], "Mission Complete")
                        {
                           MechanicsIni := MechanicsIni()
                           IniRead, CurrentStatus, %MechanicsIni%, Mechanic Active, Niko, 0
                           If (CurrentStatus = 1)
                           {
                              IniWrite, 0, %MechanicsIni%, Mechanic Active, Niko
                              IniWrite, %BlankVariable%, %MechanicsIni%, Niko Track, Current Count
                              RefreshOverlay()
                           }
                        }
                  }
               }
            }
         }
         BetrayalPattern := ".*(?:Jun, Veiled|Jun Veiled|Veiled Master|Immortal Syndicate Encounters|Complete the Immortal|the Immortal Syndicate|Syndicate encounter).*"
         If (RegExMatch(ScreenText, BetrayalPattern)) and (OCRMechanics[A_Index] = "Betrayal")
         {

            BetrayalProcessPattern := ".*(?:Immortal Syndicate Encounters|Complete the Immortal|the Immortal Syndicate|Syndicate encounter).*"
            If (RegExMatch(ScreenText, BetrayalProcessPattern))
            {
               BetrayalCount := StrSplit(ScreenText, "`n")
               BetrayalLines := BetrayalCount.MaxIndex()
               Loop, %BetrayalLines%
               {
                  If (RegexMatch(BetrayalCount[A_Index],BetrayalProcessPattern))
                  {
                     IndexMatch := A_Index -1
                     Loop, 2
                     {
                        IndexMatch++
                        If InStr(BetrayalCount[IndexMatch], "(")
                        {
                           BetrayalCount := StrSplit(BetrayalCount[IndexMatch],"(")
                           BetrayalCount := StrSplit(BetrayalCount[2],")")
                           If InStr(BetrayalCount[1], "/")
                           {
                              BetrayalCount := BetrayalCount[1]
                              Break
                           }
                           Else
                           {
                              MechanicsIni := MechanicsIni()
                              IniRead, CurrentStatus, %MechanicsIni%, Mechanic Active, Betrayal, 0
                              If (BetrayalCount[1] = "") and (A_Index = 2) and and !(ActiveCheck = 1)
                              {
                                 BetrayalCount := 0
                              }
                              If !(BetrayalCount[1] = "") and (A_Index = 2)
                              {
                                 BetrayalCount := StrSplit(BetrayalCount[1])
                                 BetrayalCount := BetrayalCount[1] "/" BetrayalCount[3]
                              }
                           }
                        }
                     }
                  }
               }
               MechanicsIni := MechanicsIni()
               CurrentCount := ""
               IniRead, CurrentCount, %MechanicsIni%, Betrayal Track, Current Count
               If !(CurrentCount = BetrayalCount)
               {
                  MechanicsIni := MechanicsIni()
                  IniRead, BetrayalActive, %MechanicsIni%, Mechanic Active, Betrayal, 0
                  If (BetrayalActive = 1) and !(BetrayalCount > 0)
                     {

                     }
                  Else
                     {
                        IniWrite, %BetrayalCount%, %MechanicsIni%, Betrayal Track, Current Count
                        IniWrite, 1, %MechanicsIni%, Mechanic Active, Betrayal
                        RefreshOverlay()
                     }
               }
            }

            If InStr(ScreenText, "Mission Complete")
            {
               BetrayalCount := StrSplit(ScreenText, "`n")
               BetrayalLines := BetrayalCount.MaxIndex()
               Loop, %BetrayalLines%
                  {
                     If (RegExMatch(BetrayalCount[A_Index], BetrayalPattern))
                        {
                           CheckCompletion := A_Index + 1
                           If InStr(NikoCount[CheckCompletion], "Mission Complete")
                              {
                                 MechanicsIni := MechanicsIni()
                                 IniRead, CurrentStatus, %MechanicsIni%, Mechanic Active, Betrayal, 0
                                 If (CurrentStatus = 1)
                                 {
                                    IniWrite, 0, %MechanicsIni%, Mechanic Active, Betrayal
                                    IniWrite, "", %MechanicsIni%, Betrayal Track, Current Count
                                    RefreshOverlay()
                                 }
                              }
                        }
                  }
            }
         }
         If (OCRMEchanics[A_Index] = "Ritual")
         {
            IniRead, RitualActive, %MechanicsIni%, Mechanic Active, Ritual, 0
            If (RitualActive = 1)
            {
               RitualOCR()
            }
            Return
         }
         IncursionPattern := ".*(?:Master Explorer|Alva, Master|Alva Master|Complete the temporal|the temporal Incursion).*"
         If (RegExMatch(ScreenText, IncursionPattern)) and (OCRMechanics[A_Index] = "Incursion") ; Here I would put in the specific text to search for I believe it could be used for Alva, Incursion, Betrayal maybe other mechanics?
         {
            IncursionProcessPattern := ".*(?:Complete the temporal|the temporal Incursion).*"
            If (RegExMatch(ScreenText, IncursionProcessPattern))
            {
               IncursionCount := StrSplit(ScreenText, "`n")
               IncursionLines := IncursionCount.MaxIndex()
               Loop, %IncursionLines%
               {
                  If (RegexMatch(IncursionCount[A_Index],IncursionProcessPattern))
                  {
                     IndexMatch := A_Index -1
                     Loop, 2
                     {
                        IndexMatch++
                        If InStr(IncursionCount[IndexMatch], "(")
                        {
                           IncursionCount := StrSplit(IncursionCount[IndexMatch],"(")
                           IncursionCount := StrSplit(IncursionCount[2],")")
                           If InStr(IncursionCount[1], "/")
                           {
                              IncursionCount := IncursionCount[1]
                              Break
                           }
                           Else
                              {
                                 MechanicsIni := MechanicsIni()
                                 IniRead, ActiveCheck, %MechanicsIni%, Section, Incursion, 0
                                 If (IncursionCount[1] = "") and !(ActiveCheck = 1)
                                 {
                                    IncursionCount := 0
                                 }
                                 If !(IncursionCount[1] = "")
                                 {
                                    IncursionCount := StrSplit(IncursionCount[1])
                                    IncursionCount := IncursionCount[1] "/" IncursionCount[3]
                                 }
                              }
                        }
                     }
                  }
               }
               MechanicsIni := MechanicsIni()
               CurrentCount := ""
               IniRead, CurrentCount, %MechanicsIni%, Incursion Track, Current Count
               IniRead, ActiveCheck, %MechanicsIni%, Mechanic Active, Incursion, 0
               If !(CurrentCount = IncursionCount)
               {
                  MechanicsIni := MechanicsIni()
                  IniRead, IncursionActive, %MechanicsIni%, Mechanic Active, Incursion, 0
                  If (IncursionActive = 1) and !(IncursionCount > 0)
                     {
                        
                     }
                     Else
                        {
                           IniWrite, %IncursionCount%, %MechanicsIni%, Incursion Track, Current Count
                           IniWrite, 1, %MechanicsIni%, Mechanic Active, Incursion
                           RefreshOverlay()
                        }
               }
            }
            If InStr(ScreenText, "Mission Complete")
               {
                  IncursionCount := StrSplit(ScreenText, "`n")
                  IncursionLines := IncursionCount.MaxIndex()
                  Loop, %IncursionLines%
                     {
                        If (RegexMatch(IncursionCount[A_Index],IncursionPattern))
                           {
                              CheckCompletion := A_Index + 1
                              If InStr(IncursionCount[CheckCompletion], "Mission Complete")
                                 {
                                    MechanicsIni := MechanicsIni()
                                    IniRead, CurrentStatus, %MechanicsIni%, Mechanic Active, Incursion, 0
                                    If (CurrentStatus = 1)
                                    {
                                       IniWrite, 0, %MechanicsIni%, Mechanic Active, Incursion
                                       IniWrite, "", %MechanicsIni%, Incursion Track, Current Count
                                       RefreshOverlay()
                                    }
                                 }
                           }
                     }
               }
            }
      }
   }
}

GetArea() {
   FinishedCoord := 0
   area := []
   StartSelection(area)
   While, FinishedCoord = 0
      Sleep, 100
   Return area
}

StartSelection(area) {
   handler := Func("Select").Bind(area)
   Hotkey, LButton, % handler, On
   ReplaceSystemCursors("IDC_CROSS")
}

Select(area) {
   Static hGui := CreateSelectionGui()
   Hook := new WindowsHook(WH_MOUSE_LL := 14, "LowLevelMouseProc", hGui)
   Loop {
      KeyWait, LButton
      WinGetPos, X, Y, W, H, ahk_id %hGui%
   } until w > 0
   ReplaceSystemCursors("")
   Hotkey, LButton, Off
   Hook := ""
   Gui, %hGui%:Show, Hide
   ScreenIni := ScreenIni()
   For each, Coordinate in StrSplit("x|y|w|h", "|")
   {
      CoordinateValue := %Coordinate%
      IniWrite, %CoordinateValue%, %ScreenIni%, OCR Area, %Coordinate%
   }
   FinishedCoord := 1
}

ReplaceSystemCursors(IDC = "") {
   Static IMAGE_CURSOR := 2, SPI_SETCURSORS := 0x57
      , exitFunc := Func("ReplaceSystemCursors").Bind("")
      , SysCursors := { IDC_APPSTARTING: 32650
         , IDC_ARROW : 32512
         , IDC_CROSS : 32515
         , IDC_HAND : 32649
         , IDC_HELP : 32651
         , IDC_IBEAM : 32513
         , IDC_NO : 32648
         , IDC_SIZEALL : 32646
         , IDC_SIZENESW : 32643
         , IDC_SIZENWSE : 32642
         , IDC_SIZEWE : 32644
         , IDC_SIZENS : 32645
         , IDC_UPARROW : 32516
         , IDC_WAIT : 32514 }
   If !IDC {
      DllCall("SystemParametersInfo", UInt, SPI_SETCURSORS, UInt, 0, UInt, 0, UInt, 0)
      OnExit(exitFunc, 0)
   }
   Else {
      hCursor := DllCall("LoadCursor", Ptr, 0, UInt, SysCursors[IDC], Ptr)
      For k, v in SysCursors {
         hCopy := DllCall("CopyImage", Ptr, hCursor, UInt, IMAGE_CURSOR, Int, 0, Int, 0, UInt, 0, Ptr)
         DllCall("SetSystemCursor", Ptr, hCopy, UInt, v)
      }
      OnExit(exitFunc)
   }
   Return
}

CreateSelectionGui() {
   Gui, New, +hwndhGui +Alwaysontop -Caption +LastFound +ToolWindow +E0x20 -DPIScale
   WinSet, Transparent, 130
   Gui, Color, FFC800
   Return hGui
}

LowLevelMouseProc(nCode, wParam, lParam) {
   Static WM_MOUSEMOVE := 0x200, WM_LBUTTONUP := 0x202
      , coords := [], startMouseX, startMouseY, hGui
      , timer := Func("LowLevelMouseProc").Bind("timer", "", "")

   If (nCode = "timer") {
      While coords[1] {
         point := coords.RemoveAt(1)
         mouseX := point[1], mouseY := point[2]
         x := startMouseX < mouseX ? startMouseX : mouseX
         y := startMouseY < mouseY ? startMouseY : mouseY
         w := Abs(mouseX - startMouseX)
         h := Abs(mouseY - startMouseY)
         Try Gui, %hGUi%: Show, x%x% y%y% w%w% h%h% NA
      }
   } Else {
      (!hGui && hGui := A_EventInfo)
      If (wParam = WM_LBUTTONUP)
         startMouseX := startMouseY := ""
      If (wParam = WM_MOUSEMOVE)  {
         mouseX := NumGet(lParam + 0, "Int")
         mouseY := NumGet(lParam + 4, "Int")
         If (startMouseX = "") {
            startMouseX := mouseX
            startMouseY := mouseY
         }
         coords.Push([mouseX, mouseY])
         SetTimer, % timer, -10
      }
      Return DllCall("CallNextHookEx", Ptr, 0, Int, nCode, UInt, wParam, Ptr, lParam)
   }
}

class WindowsHook {
   __New(type, callback, eventInfo := "", isGlobal := true) {
      this.callbackPtr := RegisterCallback(callback, "Fast", 3, eventInfo)
      this.hHook := DllCall("SetWindowsHookEx", "Int", type, "Ptr", this.callbackPtr
                                              , "Ptr", !isGlobal ? 0 : DllCall("GetModuleHandle", "UInt", 0, "Ptr")
                                              , "UInt", isGlobal ? 0 : DllCall("GetCurrentThreadId"), "Ptr")
   }
   __Delete() {
      DllCall("UnhookWindowsHookEx", "Ptr", this.hHook)
      DllCall("GlobalFree", "Ptr", this.callBackPtr, "Ptr")
   }
}

HBitmapFromScreen(X, Y, W, H) {
   HDC := DllCall("GetDC", "Ptr", 0, "UPtr")
   HBM := DllCall("CreateCompatibleBitmap", "Ptr", HDC, "Int", W, "Int", H, "UPtr")
   PDC := DllCall("CreateCompatibleDC", "Ptr", HDC, "UPtr")
   DllCall("SelectObject", "Ptr", PDC, "Ptr", HBM)
   DllCall("BitBlt", "Ptr", PDC, "Int", 0, "Int", 0, "Int", W, "Int", H
                   , "Ptr", HDC, "Int", X, "Int", Y, "UInt", 0x00CC0020)
   DllCall("DeleteDC", "Ptr", PDC)
   DllCall("ReleaseDC", "Ptr", 0, "Ptr", HDC)
   Return HBM
}

HBitmapToRandomAccessStream(hBitmap) {
   Static IID_IRandomAccessStream := "{905A0FE1-BC53-11DF-8C49-001E4FC686DA}"
        , IID_IPicture            := "{7BF80980-BF32-101A-8BBB-00AA00300CAB}"
        , PICTYPE_BITMAP := 1
        , BSOS_DEFAULT   := 0

   DllCall("Ole32\CreateStreamOnHGlobal", "Ptr", 0, "UInt", true, "PtrP", pIStream, "UInt")

   VarSetCapacity(PICTDESC, sz := 8 + A_PtrSize*2, 0)
   NumPut(sz, PICTDESC)
   NumPut(PICTYPE_BITMAP, PICTDESC, 4)
   NumPut(hBitmap, PICTDESC, 8)
   riid := CLSIDFromString(IID_IPicture, GUID1)
   DllCall("OleAut32\OleCreatePictureIndirect", "Ptr", &PICTDESC, "Ptr", riid, "UInt", false, "PtrP", pIPicture, "UInt")
   ; IPicture::SaveAsFile
   DllCall(NumGet(NumGet(pIPicture+0) + A_PtrSize*15), "Ptr", pIPicture, "Ptr", pIStream, "UInt", true, "UIntP", size, "UInt")
   riid := CLSIDFromString(IID_IRandomAccessStream, GUID2)
   DllCall("ShCore\CreateRandomAccessStreamOverStream", "Ptr", pIStream, "UInt", BSOS_DEFAULT, "Ptr", riid, "PtrP", pIRandomAccessStream, "UInt")
   ObjRelease(pIPicture)
   ObjRelease(pIStream)
   Return pIRandomAccessStream
}

CLSIDFromString(IID, ByRef CLSID) {
   VarSetCapacity(CLSID, 16, 0)
   If res := DllCall("ole32\CLSIDFromString", "WStr", IID, "Ptr", &CLSID, "UInt")
      Throw Exception("CLSIDFromString failed. Error: " . Format("{:#x}", res))
   Return &CLSID
}

OCR(IRandomAccessStream, language := "en")
{
   Static OcrEngineClass, OcrEngineObject, MaxDimension, LanguageClass, LanguageObject, CurrentLanguage, StorageFileClass, BitmapDecoderClass
   If (OcrEngineClass = "")
   {
      CreateClass("Windows.Globalization.Language", ILanguageFactory := "{9B0252AC-0C27-44F8-B792-9793FB66C63E}", LanguageClass)
      CreateClass("Windows.Graphics.Imaging.BitmapDecoder", IStorageFileStatics := "{438CCB26-BCEF-4E95-BAD6-23A822E58D01}", BitmapDecoderClass)
      CreateClass("Windows.Media.Ocr.OcrEngine", IOcrEngineStatics := "{5BFFA85A-3384-3540-9940-699120D428A8}", OcrEngineClass)
      DllCall(NumGet(NumGet(OcrEngineClass+0)+6*A_PtrSize), "ptr", OcrEngineClass, "uint*", MaxDimension)   ; MaxImageDimension
   }
   If (CurrentLanguage != language)
   {
      If (LanguageObject != "")
      {
         ObjRelease(LanguageObject)
         ObjRelease(OcrEngineObject)
         LanguageObject := OcrEngineObject := ""
      }
      CreateHString(language, hString)
      DllCall(NumGet(NumGet(LanguageClass+0)+6*A_PtrSize), "ptr", LanguageClass, "ptr", hString, "ptr*", LanguageObject)   ; CreateLanguage
      DeleteHString(hString)
      DllCall(NumGet(NumGet(OcrEngineClass+0)+9*A_PtrSize), "ptr", OcrEngineClass, ptr, LanguageObject, "ptr*", OcrEngineObject)   ; TryCreateFromLanguage
      If (OcrEngineObject = 0)
      {
         MsgBox Can not use language "%language%" for OCR, please install language pack.
         ExitApp
      }
      CurrentLanguage := language
   }
   DllCall(NumGet(NumGet(BitmapDecoderClass+0)+14*A_PtrSize), "ptr", BitmapDecoderClass, "ptr", IRandomAccessStream, "ptr*", BitmapDecoderObject)   ; CreateAsync
   WaitForAsync(BitmapDecoderObject, BitmapDecoderObject1)
   BitmapFrame := ComObjQuery(BitmapDecoderObject1, IBitmapFrame := "{72A49A1C-8081-438D-91BC-94ECFC8185C6}")
   DllCall(NumGet(NumGet(BitmapFrame+0)+12*A_PtrSize), "ptr", BitmapFrame, "uint*", width)   ; get_PixelWidth
   DllCall(NumGet(NumGet(BitmapFrame+0)+13*A_PtrSize), "ptr", BitmapFrame, "uint*", height)   ; get_PixelHeight
   If (width > MaxDimension) or (height > MaxDimension)
   {
      MsgBox Image is to big - %width%x%height%.`nIt should be maximum - %MaxDimension% pixels
      ExitApp
   }
   SoftwareBitmap := ComObjQuery(BitmapDecoderObject1, IBitmapFrameWithSoftwareBitmap := "{FE287C9A-420C-4963-87AD-691436E08383}")
   DllCall(NumGet(NumGet(SoftwareBitmap+0)+6*A_PtrSize), "ptr", SoftwareBitmap, "ptr*", BitmapFrame1)   ; GetSoftwareBitmapAsync
   WaitForAsync(BitmapFrame1, BitmapFrame2)
   DllCall(NumGet(NumGet(OcrEngineObject+0)+6*A_PtrSize), "ptr", OcrEngineObject, ptr, BitmapFrame2, "ptr*", OcrResult)   ; RecognizeAsync
   WaitForAsync(OcrResult, OcrResult1)
   DllCall(NumGet(NumGet(OcrResult1+0)+6*A_PtrSize), "ptr", OcrResult1, "ptr*", lines)   ; get_Lines
   DllCall(NumGet(NumGet(lines+0)+7*A_PtrSize), "ptr", lines, "int*", count)   ; count
   Loop % count
   {
      DllCall(NumGet(NumGet(lines+0)+6*A_PtrSize), "ptr", lines, "int", A_Index-1, "ptr*", OcrLine)
      DllCall(NumGet(NumGet(OcrLine+0)+7*A_PtrSize), "ptr", OcrLine, "ptr*", hText)
      buffer := DllCall("Combase.dll\WindowsGetStringRawBuffer", "ptr", hText, "uint*", length, "ptr")
      text .= StrGet(buffer, "UTF-16") "`n"
      ObjRelease(OcrLine)
      OcrLine := ""
   }
   ObjRelease(BitmapDecoderObject)
   ObjRelease(BitmapDecoderObject1)
   ObjRelease(SoftwareBitmap)
   ObjRelease(BitmapFrame)
   ObjRelease(BitmapFrame1)
   ObjRelease(BitmapFrame2)
   ObjRelease(OcrResult)
   ObjRelease(OcrResult1)
   ObjRelease(lines)
   BitmapDecoderObject := BitmapDecoderObject1 := SoftwareBitmap := BitmapFrame := BitmapFrame1 := BitmapFrame2 := OcrResult := OcrResult1 := lines := ""
   Return text
}

CreateClass(string, interface, ByRef Class)
{
   CreateHString(string, hString)
   VarSetCapacity(GUID, 16)
   DllCall("ole32\CLSIDFromString", "wstr", interface, "ptr", &GUID)
   DllCall("Combase.dll\RoGetActivationFactory", "ptr", hString, "ptr", &GUID, "ptr*", Class)
   DeleteHString(hString)
   Return
}

CreateHString(string, ByRef hString)
{
    DllCall("Combase.dll\WindowsCreateString", "wstr", string, "uint", StrLen(string), "ptr*", hString)
    Return
}

DeleteHString(hString)
{
   DllCall("Combase.dll\WindowsDeleteString", "ptr", hString)
   Return
}

WaitForAsync(Object, ByRef ObjectResult)
{
   AsyncInfo := ComObjQuery(Object, IAsyncInfo := "{00000036-0000-0000-C000-000000000046}")
   Loop
   {
      DllCall(NumGet(NumGet(AsyncInfo+0)+7*A_PtrSize), "ptr", AsyncInfo, "uint*", status)   ; IAsyncInfo.Status
      If (status != 0)
      {
         If (status != 1)
         {
            MsgBox AsyncInfo status error.
            ExitApp
         }
         ObjRelease(AsyncInfo)
         AsyncInfo := ""
         Break
      }
      Sleep 10
   }
   DllCall(NumGet(NumGet(Object+0)+8*A_PtrSize), "ptr", Object, "ptr*", ObjectResult)   ; GetResults
   Return
}

RefreshOverlay()
{
	PostSetup()
   PostMessage, 0x01111,,,, PoE Mechanic Watch.ahk - AutoHotkey
	PostRestore()
   Return
}

PostSetup()
{
    Prev_DetectHiddenWindows := A_DetectHiddenWIndows
    Prev_TitleMatchMode := A_TitleMatchMode
    SetTitleMatchMode 2
    DetectHiddenWindows On
    Return
}

PostRestore()
{
    DetectHiddenWindows, %Prev_DetectHiddenWindows%
    SetTitleMatchMode, %A_TitleMatchMode%
    Return
}

GetSideTextArea()
{
   GetTextArea("Side Area")
   Return
}

GetRitualTextArea()
{
   GetTextArea("Ritual Area")
   Return
}

RitualOCR()
{
   ScreenIni := ScreenIni()
   For each, Coordinate in StrSplit("x|y|w|h", "|")
      {
         If (Coordinate = "x")
            {
               Default := 0
            }
         If (Coordinate = "y")
            {
               Default := A_ScreenHeight/3
            }
         If (Coordinate = "w")
            {
               Default := A_ScreenWidth
            }
         If (Coordinate = "h")
            {
               Default := A_ScreenHeight
            }
         Search := "Search" Coordinate
         IniRead, %Search%, %ScreenIni%, Ritual Area, %Coordinate%, %Default%
      }
   hBitmap := HBitmapFromScreen(SearchX, SearchY, SearchW, SearchH)
   pIRandomAccessStream := HBitmapToRandomAccessStream(hBitmap)
   DllCall("DeleteObject", "Ptr", hBitmap)
   v_text := OCR(pIRandomAccessStream, "en")
   ObjRelease(pIRandomAccessStream)
   ScreenText := % v_text
   RitualSearchCombos :=    ".*(?:113|213|313|114|214|314|414|1/3|2/3|3/3|1/4|2/4|3/4|4/4).*" ;using a search combo to help prevent false positives
   If (RegExMatch(ScreenText, RitualSearchCombos, RitualMatch))
      {
         If !InStr(RitualMatch, "/")
            {
               RitualMatch := StrSplit(RitualMatch)
               RitualMatch := RitualMatch[1] "/" RitualMatch[3]
            }
         MechanicsIni := MechanicsIni()
         IniRead, CurrentCount, %MechanicsIni%, Ritual Track, Count
         RitualMatch := RegExReplace(RitualMatch, "([\s]*)([^\s]*)([\s]*)", "$2") ;remove whitespace from variable
         If !(CurrentCount = RitualMatch)
            {
               MechanicsIni := MechanicsIni()
               IniRead, RitualnActive, %MechanicsIni%, Mechanic Active, Ritual, 0
               If (RitualnActive = 1) and !(RitualMatch > 0)
                  {

                  }
               Else
                  {
                     IniWrite, %RitualMatch%, %MechanicsIni%, Ritual Track, Count
                     If (RitualMatch = "3/3") or (RitualMatch = "4/4")
                        {
                           QuickNotify()
                        }
                     RefreshOverlay()
                  }
            }
      }
   Return
}

QuickNotify()
{
    Gui, Quick:Destroy
    NotificationIni := NotificationIni()
    IniRead, Vertical, %NotificationIni%, Map Notification Position, Vertical
    IniRead, Horizontal, %NotificationIni%, Map Notification Position, Horizontal
    ThemeIni := ThemeIni()
    IniRead, Theme, %ThemeIni%, Theme, Theme
    IniRead, Background, %ThemeIni%, %Theme%, Background
    IniRead, Font, %ThemeIni%, %Theme%, Font
    Gui, Quick:Color, %Background%
    Gui, Quick:Font, c%Font% s10
    ShowTitle := "-0xC00000"
    ShowBorder := "-Border"
    Gui, Quick:Add, Text,,You just completed your Final Ritual, Don't forget to get your rewards.
    Gui, Quick: +AlwaysOnTop %ShowBorder%
    Notificationpath := NotificationIni()
    IniRead, Active, %NotificationPath%, Active, Quick, 1
    If (Active = 1)
    {
        Gui, Quick:Show, NoActivate x%Horizontal% y%Vertical%, Quick Notify
        TransparencyIniPath := TransparencyIni()
        IniRead, NotificationTransparency, %TransparencyIniPath%, Transparency, Quick, 255
        WinSet, Style,  %ShowTitle%, Quick Notify
        WinSet, Transparent, %NotificationTransparency%, Quick Notify
    }
    NotificationPath := NotificationIni()
    IniRead, SoundActive, %NotificationPath%, Sound Active, Quick
    IniRead, NotificationSound, %NotificationPath%, Sounds, Quick, Resources\Sounds\reminder.wav
    If (SoundActive = 1)
    {
        SoundPlay, Resources\Sounds\blank.wav ;;;;; super hacky workaround but works....
        SetTitleMatchMode, 2
        WinGet, AhkExe, ProcessName, Quick
        SetTitleMatchMode, 1
        SetWindowVol(AhkExe, NotificationVolume)
        SoundPlay, %NotificationSound%
    }
    SetTimer, CloseGui, -3000
    Return
}

CloseGui()
{
    Gui, Quick:Destroy
    Tooltip
    Return
}

#IncludeAgain, Resources/Scripts/Ini.ahk
