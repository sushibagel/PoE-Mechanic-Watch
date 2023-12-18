#Persistent
#NoEnv
#SingleInstance Force
SetWorkingDir, %A_ScriptDir%

;	REF: https://www.autohotkey.com/boards/viewtopic.php?t=72674
;	PROVIDED BY: teadrinker
;	DATE: February 21st, 2020
;	NOTES: Optical character recognition (OCR) with UWP API

SetSysTrayIcon:
v_scriptICON := A_ScriptDir . "\OCR icon 256x.ico"
If FileExist(v_scriptICON)
	Menu Tray, Icon, %v_scriptICON%, 1
v_scriptICON := ""

TrayTipInfo:															; used in conjunction with 'ForceScriptExit:' labeled routine
; .... --- look at the end ---> ..127...................................................... --- 127 max TrayTip length --> ...v
	Menu, Tray, Tip, (OCR) Use ALT+SHIFT+X to begin`, then`nright click+drag to make a selection box.`nLet go of all mouse buttons.`n`nQUIT: +Numpad5

AtTheTop:
MsgBox, 4161, Optical character recognition (OCR), 
	( LTrim
		Use [ALT+SHIFT+X] to begin,
		then Right-Click & hold it at the 'start' point,
		and drag your mouse to create a selection box.
		***** Be patient, it may take a moment
		for the box to appear.
		Lastly, let go of all mouse buttons. Ta Da!
		The result is copied to the Clipboard.
		***** This OCR script is not perfect.
		Double-check the results against the source.
		
		QUIT: SHIFT+Numpad5

		... click [OK] to begin ...
	)
	IfMsgBox Ok, {
		Return
	} Else IfMsgBox Cancel, {
		ExitApp
	}
Return

/*	REF: https://www.autohotkey.com/docs/Hotkeys.htm

	AHK's Hotkey modifiers are:
		!	= Alt
		^	= Ctrl
		+	= Shift
		#	= Win (Windows logo key)
		
*/
!+x::	; ALT+SHIFT+x
	hBitmap := HBitmapFromScreen(GetArea()*)
	pIRandomAccessStream := HBitmapToRandomAccessStream(hBitmap)
	DllCall("DeleteObject", "Ptr", hBitmap)
	v_text := OCR(pIRandomAccessStream, "en")
	ObjRelease(pIRandomAccessStream)
	Clipboard := % v_text
	v_Reminder := 
	MsgBox, 4161, Optical character recognition (OCR), 
		( LTrim
			The following has been copied to the Clipboard:
			==============================
			%Clipboard%
		)
Return

;	use 'NumpadClear' instead of '+Numpad5' to represent SHIFT+Numpad5 hotkey
NumpadClear::															; behaves as If [SHIFT]+Numpad5 were pressed together
	ExitApp
Return

GetArea() {
   area := []
   StartSelection(area)
   while !area.w
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
   for k, v in ["x", "y", "w", "h"]
      area[v] := %v%
}

ReplaceSystemCursors(IDC = "") {
   Static IMAGE_CURSOR := 2, SPI_SETCURSORS := 0x57
        , exitFunc := Func("ReplaceSystemCursors").Bind("")
        , SysCursors := { IDC_APPSTARTING: 32650
                        , IDC_ARROW      : 32512
                        , IDC_CROSS      : 32515
                        , IDC_HAND       : 32649
                        , IDC_HELP       : 32651
                        , IDC_IBEAM      : 32513
                        , IDC_NO         : 32648
                        , IDC_SIZEALL    : 32646
                        , IDC_SIZENESW   : 32643
                        , IDC_SIZENWSE   : 32642
                        , IDC_SIZEWE     : 32644
                        , IDC_SIZENS     : 32645 
                        , IDC_UPARROW    : 32516
                        , IDC_WAIT       : 32514 }
   If !IDC {
      DllCall("SystemParametersInfo", UInt, SPI_SETCURSORS, UInt, 0, UInt, 0, UInt, 0)
      OnExit(exitFunc, 0)
   }
   Else  {
      hCursor := DllCall("LoadCursor", Ptr, 0, UInt, SysCursors[IDC], Ptr)
      For k, v in SysCursors  {
         hCopy := DllCall("CopyImage", Ptr, hCursor, UInt, IMAGE_CURSOR, Int, 0, Int, 0, UInt, 0, Ptr)
         DllCall("SetSystemCursor", Ptr, hCopy, UInt, v)
      }
      OnExit(exitFunc)
   }
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
}

CreateHString(string, ByRef hString)
{
    DllCall("Combase.dll\WindowsCreateString", "wstr", string, "uint", StrLen(string), "ptr*", hString)
}

DeleteHString(hString)
{
   DllCall("Combase.dll\WindowsDeleteString", "ptr", hString)
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
}