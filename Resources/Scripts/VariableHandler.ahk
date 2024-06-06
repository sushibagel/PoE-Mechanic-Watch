/**
 * Function for managing file paths as well as reading and writing to files
 * @param {String} FileRequested String with the name of the file needed. (Changelog, Hotkeys, Hideout, HideoutList, Launch, Map List, Mechanics, Misc Data, Notifications, Overlay, Setup, Storage, Theme, Transparency, Version)
 * @param {String} Action The action desired. Read/Write, if left blank it will return the INI path.
 * @param {String} Value This is the value to be written to the ini file.
 * @param {String} Section This is the Ini Section Header being read/written
 * @param {String} Key the Ini Key to be read/written to.
 * @param {String} Default The default return value if the key is blank.
 * @returns This returns the Ini path unless a Read action is requested. For read actions the Key value would be returned. 
 */
IniPath(FileRequested, Action:="", Value:="", Section:="", Key:="", Default:="")
{
    If !(FileRequested = "Storage")
        {
            StorageDir := GetStorageDir()
        }
    Switch
    {
        Case FileRequested = "Changelog": Return "Changelog.txt"
        Case FileRequested = "Hotkeys": Path := StorageDir "\Resources\Settings\Hotkeys.ini" 
        Case FileRequested = "Hideout": Path := StorageDir "\Resources\Settings\Hideout.ini"
        Case FileRequested = "HideoutList": Return "Resources\Data\HideoutList.txt"
        Case FileRequested = "Launch": Path := StorageDir "\Resources\Data\LaunchPath.ini"
        Case FileRequested = "Map List": Return StorageDir "\Resources\Data\maplist.txt"
        Case FileRequested = "Mechanics": Path := StorageDir "\Resources\Settings\Mechanics.ini"
        Case FileRequested = "Misc Data": Path := StorageDir "\Resources\Data\Misc.ini"
        Case FileRequested = "Notifications": Path := StorageDir "\Resources\Settings\Notification.ini"
        Case FileRequested = "Overlay": Path := StorageDir "\Resources\Settings\Overlay.ini"
        Case FileRequested = "Setup": Path := StorageDir "\Resources\Data\Setup.ini"
        Case FileRequested = "Storage": Path := "Resources\Settings\StorageLocation.ini" ;Intentionally doesn't use alt storage path. 
        Case FileRequested = "Theme": Path := StorageDir "\Resources\Settings\Theme.ini"
        Case FileRequested = "Transparency": Path := StorageDir "\Resources\Settings\Transparency.ini"
        Case FileRequested = "Version": Return "Resources\Data\Version.txt"
    }
    Switch(True) 
    {
        Case Action = "Write" : IniWrite(Value, Path, Section, Key)
        Case Action = "Read" : Return IniRead(Path, Section, Key, Default)  
        Default: Return Path
            
    }
}

/**
 * 
 * @param VariableRequested {String} Requested variable data. [Influences, Mechanics, ImageSearch]
 * @returns {Array} 
 */
VariableStore(VariableRequested)
{
    Switch 
    {
        Case VariableRequested = "Influences": Return ["Eater", "Searing", "Maven"]
        Case VariableRequested = "Mechanics": Return ["Abyss", "Betrayal", "Blight", "Breach", "Einhar", "Expedition", "Harvest", "Incursion", "Legion", "Niko", "Ritual", "Ultimatum", "Generic"]
        Case VariableRequested = "ImageSearch": Return ["Ritual Icon", "Ritual Shop", "Blight"]
    }
}

/**
 * 
 * @param FileRequested 
 * @param AllowCustom {String} "Yes" or "No"
 * @returns {String} 
 */
ImagePath(FileRequested, AllowCustom)
{
    CurrentTheme := GetTheme()
    BasePath := "Resources\Images\Image Search\"
    Switch
        {
            Case FileRequested = "Blight": Append := "Blight.png"
            Case FileRequested = "Quest Tracker Text": Append := "QuestTracker.png"
            Case FileRequested = "Ritual Icon": Append := "RitualIcon.png"
            Case FileRequested = "Ritual Text": Append := "RitualText.png"
            Case FileRequested = "Ritual Shop": Append := "RitualShop.png"
            Case FileRequested = "Influence Count": Append := "EldritchText.png"
            Case FileRequested = "Eater Completion": Append := FileRequested ".png"
            Case FileRequested = "Searing Completion": Append := FileRequested ".png"
            Case FileRequested = "Maven Completion": Append := FileRequested ".png"
            Case FileRequested = InStr(FileRequested, 0) || InStr(FileRequested, 1) || InStr(FileRequested, 2) || InStr(FileRequested, 3) || InStr(FileRequested, 4) || InStr(FileRequested, 5) || InStr(FileRequested, 6) || InStr(FileRequested, 7) || InStr(FileRequested, 8) || InStr(FileRequested, 9) || InStr(FileRequested, 0): Append := FileRequested ".png"
            Case FileRequested = "Eater On": Append := "eateron.png"
            Case FileRequested = "Searing On": Append := "searingon.png"
            Case FileRequested = "Maven On": Append := "mavenon.png"
            
            Case FileRequested = "Close Button": Path := "Resources/Images/Close " CurrentTheme[4] ".png"
            Case FileRequested = "Minimize Button": Path := "Resources/Images/minimize " CurrentTheme[4] ".png"
            Case FileRequested = "Move Button": Path := "Resources/Images/move " CurrentTheme[4] ".png"
            Case FileRequested = "Play Button": Path := "Resources/Images/Play " CurrentTheme[4] ".png"
            Case FileRequested = "Refresh Button": Path := "Resources/Images/Refresh " CurrentTheme[4] ".png"
            Case FileRequested = "Stop Button": Path := "Resources/Images/Stop " CurrentTheme[4] ".png"
            Case FileRequested = "Volume Button": Path := "Resources/Images/Volume " CurrentTheme[4] ".png"
        }
    If IsSet(Path)
        {
            Return Path
        }
    If (AllowCustom = "Yes")
        {
            If InStr(FileRequested, "Searing") or InStr(FileRequested, "Eater") or InStr(FileRequested, "Maven")
                {
                    CustomPath := BasePath "Eldritch\Custom\" Append
                }
            Else
                {
                    CustomPath := BasePath "Custom\" Append
                }
           If FileExist(CustomPath)
            {
                ReturnedPath := CustomPath
            }
        }
    If !IsSet(ReturnedPath)
        {
            If InStr(FileRequested, "Searing") or InStr(FileRequested, "Eater") or InStr(FileRequested, "Maven")
                {
                    ReturnedPath := BasePath "Eldritch\" Append
                }
            Else
                {
                    ReturnedPath := BasePath Append
                }
        }
    Return ReturnedPath
}

SettingsLocation(*)
{
    StorageGui := GuiTemplate("StorageGUi", "Settings Storage Location", 700)
    CurrentTheme := GetTheme()
    ExplainTool := "This tool will allow you to choose a location for user specific settings to be stored. This is useful if you have multiple computers and want to sync your settings with Dropbox. Note: Calibration images are not moved."
    StorageGui.Add("Text", "Center w700", ExplainTool)
    StorageGui.Add("Text", "XM Section", "Current Location:")
    StorageIni := IniPath("Storage")
    CurrentLocation := IniRead(StorageIni, "Settings Location", "Location", A_ScriptDir)
    If (CurrentLocation = "A_ScriptDir")
        {
            CurrentLocation := A_ScriptDir
        }
    StorageGui.Add("Edit", "YS w450 Background" CurrentTheme[2], CurrentLocation)
    StorageGui.Add("Button", "YS", "Select Location").OnEvent("Click", GetLocation)
    StorageGui.Show
}

SettingsLocationDestroy(StorageGui)
{
    StorageGui.Destroy()
}

GetLocation(*)
{
    SelectFolder := FileSelect("D 2", A_Desktop, "Please select the folder to store settings files in.")
    If !(SelectFolder = "")
        {
            CurrentDir := GetStorageDir()
            StorageIni := IniPath("Storage")
            IniWrite(SelectFolder, StorageIni, "Settings Location", "Location")
            DataFolder := "\Resources\Data"
            SettingsFolder := "\Resources\Settings"
            DirCreate(SelectFolder DataFolder)
            DirCreate(SelectFolder SettingsFolder)
            FileCopy(CurrentDir DataFolder "\*.ini", SelectFolder DataFolder, True)
            FileCopy(CurrentDir SettingsFolder "\*.ini", SelectFolder SettingsFolder, True)
            SettingsLocation()
        }
}

GetStorageDir()
{
    StorageIni := IniPath("Storage")
    CurrentDir := IniRead(StorageIni, "Settings Location", "Location", A_ScriptDir)
    If (CurrentDir = "A_ScriptDir")
        {
            CurrentDir := A_ScriptDir
        }
    Return CurrentDir
}

NotificationVars(NotificationType)
{
    NotificationIni := IniPath("Notifications")
    ReturnInfo := Array()
    ActiveStatus := IniRead(NotificationIni, NotificationType, "Active", 1)
    HorizontalStatus := IniRead(NotificationIni, NotificationType, "Horizontal", "")
    VerticalStatus := IniRead(NotificationIni, NotificationType, "Vertical", "")
    TransparencyStatus := IniRead(NotificationIni, NotificationType, "Transparency", 255)
    SoundStatus := IniRead(NotificationIni, NotificationType, "Sound Active", 0)
    PathStatus := IniRead(NotificationIni, NotificationType, "Sound Path", "Resources\Sounds\reminder.wav")
    VolumeStatus := IniRead(NotificationIni, NotificationType, "Volume", 50)
    DurationStatus := IniRead(NotificationIni, NotificationType, "Duration", 3)
    DurationStatus := DurationStatus * 1000
    VariablesNames := ["Active", "Horizontal", "Vertical", "Transparency", "Sound", "Path", "Volume", "Duration"]
    For Variable in VariablesNames
        {
            Item := Variable "Status"
            ReturnInfo.Push(%Item%)
        }
    Return ReturnInfo
}


; Gui Boiler Plate
GuiTemplate(GuiName, GuiTitle, GuiWidth, GuiParams:="")
{
    If WinExist(GuiTitle)
        {
            WinClose
        }
    GuiName := Gui( GuiParams, GuiTitle)
    CurrentTheme := GetTheme()
    GuiName.BackColor := CurrentTheme[1]
    GuiName.SetFont("s15 Bold c" CurrentTheme[3])
    GuiName.Add("Text", "Center w" GuiWidth, GuiTitle)
    GuiName.AddText("h1 w" GuiWidth " Background" CurrentTheme[3])
    GuiName.SetFont("Norm s10.")
    Return GuiName
}

; ListView Grid color thanks "just me" ======================================================================================================================
; just me      ->  https://www.autohotkey.com/boards/viewtopic.php?f=83&t=125259
; LV_GridColor - Sets/resets the color used to draw the gridlines in a ListView
; Parameter:
;     LV          -  ListView control object
;     GridColor   -  RGB integer value in the range from 0x000000 to 0xFFFFFF or HTML color nameas  defined in the docs
; Remarks:
;     Drawing is implemented using Custom Draw -> https://learn.microsoft.com/en-us/windows/win32/controls/custom-draw
; ======================================================================================================================
LV_GridColor(LV, GridColor?) {
    Static Controls := Map()
    If Controls.Has(LV.Hwnd) {
       LV.OnNotify(-12, NM_CUSTOMDRAW, 0)
       If LV.HasProp("GridPen") {
          DllCall("DeleteObject", "Ptr", LV.GridPen)
          LV.DeleteProp("GridPen")
       }
       If (Controls[LV.Hwnd] = 1)
          LV.Opt("+LV0x00000001") ; LV_EX_GRIDLINES
       Controls.Delete(LV.Hwnd)
    }
    If IsSet(GridColor) {
       GridColor := BGR(GridColor)
       If (GridColor = "")
          Throw Error("Invald parameter GridColor!")
       LV.GridPen := DllCall("CreatePen", "Int", 0, "Int", 1, "UInt", GridColor, "UPtr")
       LV_EX_Styles := SendMessage(0x1037, 0, 0, LV.Hwnd) ; LVM_GETEXTENDEDLISTVIEWSTYLE
       If (LV_EX_Styles & 0x00000001) ; LV_EX_GRIDLINES
          LV.Opt("-LV0x00000001")
       Controls[LV.Hwnd] := LV_EX_Styles & 0x00000001
       LV.OnNotify(-12, NM_CUSTOMDRAW, 1)
    }
    Return True
    ; -------------------------------------------------------------------------------------------------------------------
    NM_CUSTOMDRAW(LV, LP) {
       Static Points := Buffer(24, 0)                     ; Polyline points
       Static SizeNMHDR := A_PtrSize * 3                  ; Size of NMHDR structure
       Static SizeNCD := SizeNMHDR + 16 + (A_PtrSize * 5) ; Size of NMCUSTOMDRAW structure
       Static OffDC := SizeNMHDR + A_PtrSize
       Static OffRC := OffDC + A_PtrSize
       Static OffItem := SizeNMHDR + 16 + (A_PtrSize * 2) ; Offset of dwItemSpec (NMCUSTOMDRAW)
       Static OffCT := SizeNCD                            ; Offset of clrText (NMLVCUSTOMDRAW)
       Static OffCB := OffCT + 4                          ; Offset of clrTextBk (NMLVCUSTOMDRAW)
       Static OffSubItem := OffCB + 4                     ; Offset of iSubItem (NMLVCUSTOMDRAW)
       Critical -1
       Local DrawStage := NumGet(LP + SizeNMHDR, "UInt")  ; drawing stage
       Switch DrawStage {
          Case 0x030002:       ; CDDS_SUBITEMPOSTPAINT
             Local SI := NumGet(LP + OffSubItem, "Int") ; subitem
             Local DC := NumGet(LP + OffDC, "UPtr")     ; device context
             Local RC := LP + OffRC                     ; drawing rectangle
             Local L := SI = 0 ? 0 : NumGet(RC, "Int")  ; left
             Local T := NumGet(RC + 4, "Int")           ; top
             Local R := NumGet(RC + 8, "Int")           ; right
             Local B := NumGet(RC + 12, "Int")          ; bottom
             Local PP := DllCall("SelectObject", "Ptr", DC, "Ptr", LV.GridPen, "UPtr") ; previous pen
             If (SI = 0)
                NumPut("Int", L, "Int", B - 1, "Int", R, "Int", B - 1, Points)
             Else
                NumPut("Int", L, "Int", T, "Int", L, "Int", B - 1, "Int", R, "Int", B - 1, Points)
             DllCall("Polyline", "Ptr", DC, "Ptr", Points, "Int", SI = 0 ? 2 : 3)
             NumPut("Int", L, "Int", B - 1, "Int", R, "Int", B - 1, "Int", R, "Int", T - 1, Points)
             DllCall("Polyline", "Ptr", DC, "Ptr", Points, "Int", 3)
             DllCall("SelectObject", "Ptr", DC, "Ptr", PP, "UPtr")
             Return 0x00       ; CDRF_DODEFAULT
          Case 0x030001:       ; CDDS_SUBITEMPREPAINT
             Return 0x10       ; CDRF_NOTIFYPOSTPAINT
          Case 0x010001:       ; CDDS_ITEMPREPAINT
             Return 0x20       ; CDRF_NOTIFYSUBITEMDRAW
          Case 0x000001:       ; CDDS_PREPAINT
             Return 0x20       ; CDRF_NOTIFYITEMDRAW
          Default:
             Return 0x00       ; CDRF_DODEFAULT
       }
    }
    ; -------------------------------------------------------------------------------------------------------------------
    BGR(Color, Default := "") { ; converts colors to BGR
       ; HTML Colors (BGR)
       Static HTML := {AQUA:   0xFFFF00, BLACK: 0x000000, BLUE:   0xFF0000, FUCHSIA: 0xFF00FF, GRAY:  0x808080,
                       GREEN:  0x008000, LIME:  0x00FF00, MAROON: 0x000080, NAVY:    0x800000, OLIVE: 0x008080,
                       PURPLE: 0x800080, RED:   0x0000FF, SILVER: 0xC0C0C0, TEAL:    0x808000, WHITE: 0xFFFFFF,
                       YELLOW: 0x00FFFF}
       If IsInteger(Color)
          Return ((Color >> 16) & 0xFF) | (Color & 0x00FF00) | ((Color & 0xFF) << 16)
       Return (HTML.HasOwnProp(Color) ? HTML.%Color% : Default)
    }
}