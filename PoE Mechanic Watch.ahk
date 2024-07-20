#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

;Tray Menu setup
TraySetIcon("Resources\Images\mechanicwatch.png")
MyTray := Menu()
MyTray:= A_TrayMenu
MyTray.Delete() ; Delete the standard items.
MyTray.Add("Launch Path of Exile", LaunchPoE)
MyTray.Add()
MyTray.Add("Select Mechanics", Settings.Bind(2))
MyTray.Add("Maven Status", MavenStatus)
MyTray.Add()
Setup := Menu()
Setup.Add("Setup Tool", Settings.Bind(1))
Setup.Add()
Setup.Add("Set Hideout", Settings.Bind(5))
Setup.Add()
Setup.Add("Overlay Settings", Settings.Bind(3))
Setup.Add("Move Overlay", MoveOverlay)
Setup.Add()
Setup.Add("Notification Settings", Settings.Bind(4))
Setup.Add("Move Quick Notifications", MoveQuick)
Setup.Add("Custom Notification", Settings.Bind(11))
Setup.Add()
Setup.Add("Calibration Tool", Settings.Bind(12))
Setup.Add("Set Hotkeys", Settings.Bind(7))
Setup.Add()
Setup.Add("Launcher Setup", Settings.Bind(8))
Setup.Add()
Setup.Add("Change Theme", Settings.Bind(6))
Setup.Add("Change Settings Location", Settings.Bind(9))
Setup.Default := "Setup Tool"
MyTray.Add("Setup", Setup)
MyTray.Default := "Setup"
MyTray.Add()
MyTray.Add("Check for Updates", UpdateCheck)
MyTray.Add("About", Settings.Bind(10))
MyTray.Add()
MyTray.Add("Reload This Script", Restart) 
MyTray.Add("Exit", Close)

; Group of windows that are monitored for the overlay
GroupAdd("PoeWindow", "ahk_exe PathOfExileSteam.exe")
GroupAdd("PoeWindow", "ahk_exe PathOfExile.exe")
GroupAdd("PoeWindow", "ahk_exe PathOfExileEGS.exe")
GroupAdd("PoeWindow", "PoE Mechanic Watch Notification")
GroupAdd("PoeWindow", "Quick Notification")
GroupAdd("PoeWindow", "ahk_exe Code.exe")

GroupAdd("PoeOnly", "ahk_exe PathOfExileSteam.exe")
GroupAdd("PoeOnly", "ahk_exe PathOfExile.exe")
GroupAdd("PoeOnly", "ahk_exe PathOfExileEGS.exe")
GroupAdd("PoeOnly", "ahk_exe Code.exe")
Global MoveActive := 0
Global TestActive := 0

HSHELL_WINDOWACTIVATED := 4
HSHELL_GETMINRECT := 5
HSHELL_WINDOWREPLACED := 13
HSHELL_RUDEAPPACTIVATED := 0x8004

Detector := Gui()
DllCall("RegisterShellHookWindow", "UInt", Detector.Hwnd)
Messenger := DllCall("RegisterWindowMessage", "Str", "SHELLHOOK")
OnMessage(Messenger, Recipient)

SetTrayTheme()

;Reload Group
GroupAdd("AHKFiles", "About.ahk")
GroupAdd("AHKFiles", "Calibration.ahk")
GroupAdd("AHKFiles", "LaunchOptions.ahk")
GroupAdd("AHKFiles", "LogMonitor.ahk")
GroupAdd("AHKFiles", "Maven.ahk")
GroupAdd("AHKFiles", "Mechanics.ahk")
GroupAdd("AHKFiles", "Notification.ahk")
GroupAdd("AHKFiles", "PoE Mechanic Watch.ahk")
GroupAdd("AHKFiles", "Hideout.ahk")
GroupAdd("AHKFiles", "Hotkeys.ahk")
GroupAdd("AHKFiles", "ScreenSearch.ahk")
GroupAdd("AHKFiles", "ScrollableGui.ahk")
GroupAdd("AHKFiles", "Setup.ahk")
GroupAdd("AHKFiles", "Theme.ahk")
GroupAdd("AHKFiles", "Update.ahk")
GroupAdd("AHKFiles", "VariableHandler.ahk")

SetupVerification()

HideoutIni := IniPath("Hideout")
IniWrite(0, HideoutIni, "In Hideout", "In Hideout")

If WinActive("ahk_group PoeWindow")
    {
        SetTimer(ScreenSearchHandler, 500)
        lt.Start ; Start log monitoring
        CreateOverlay()
    }

#HotIf WinActive("ahk_group AHKFiles") ; For dev purposes, Quick reload
~^s::
{
        {
            Reload
        }
}
#HotIf

;Overlay Control Start
Recipient(Message, ID, *)
{
    If ((Message == HSHELL_GETMINRECT) or (Message == HSHELL_RUDEAPPACTIVATED) or (Message == HSHELL_WINDOWACTIVATED) or (Message == HSHELL_WINDOWREPLACED)) and WinActive("ahk_group PoeWindow") and !(MoveActive = 1)
        {
            If IsSet(lt)
                {
                    SetTimer(ScreenSearchHandler, 500)
                    lt.Start ; Start log monitoring
                    DestroyOverlay()
                    CreateOverlay()
                }
        }
    If ((Message == HSHELL_GETMINRECT) or (Message == HSHELL_RUDEAPPACTIVATED) or (Message == HSHELL_WINDOWACTIVATED) or (Message == HSHELL_WINDOWREPLACED)) and !WinActive("ahk_group PoeWindow") and !(MoveActive = 1)
        {
            If IsSet(lt)
                {
                    SetTimer(ScreenSearchHandler, 0)
                    lt.Stop ; Stop log monitoring
                }
            DestroyOverlay()
        }
}
;Overlay Control End

CheckPath()
{
    LaunchIni := IniPath("Launch")
    WinFound := WinWait("ahk_Group PoeWindow",,.1) ;Update launch path
    If !(WinFound = 0)
        {
            GamePath := WinGetProcessPath("ahk_Group PoeWindow")
            If InStr(GamePath, "PathOfExile")
                {
                    SplitPath(GamePath, &ExeName, &ExeDirectory)
                    IniWrite(ExeName, LaunchIni, "POE", "EXE")
                    IniWrite(ExeDirectory, LaunchIni, "POE", "Directory")
                }
        }
}

CreateOverlay()
{
    ;Get overlay settings from ini files
    If WinExist("PoE Mechanic Watch Overlay")
        {   
            OverlayHwnd := WinWait("PoE Mechanic Watch Overlay")
            OverlayObj := GuiFromHwnd(OverlayHwnd)
            OverlayObj.Destroy
        }
    Overlay := Gui(, "PoE Mechanic Watch Overlay")
    OverlayIni := IniPath("Overlay")
    MechanicsPath := IniPath("Mechanics")
    OverlayHeight := IniRead(OverlayIni, "Overlay Position", "Height", "")
    OverlayWidth := IniRead(OverlayIni, "Overlay Position", "Width", "")
    OverlayTransparency := IniRead(OverlayIni, "Transparency", "Transparency", 255)
    ;Add additional settings
    Overlay.Opt("AlwaysOnTop")
    If (MoveActive = 0)
        {
            Overlay.Opt("-Caption -Border +ToolWindow +E0x02000000 +E0x08000000")
        }

    ;Setup mechanics on Overlay
    Mechanics := VariableStore("Mechanics")
    For Mechanic in Mechanics
        {
            MechanicOn := IniRead(MechanicsPath, "Mechanics", Mechanic, 0)
            MechanicActive := IniRead(MechanicsPath, "Mechanic Active", Mechanic, 0)
            MechanicCount := ""
            If (Mechanic = "Ritual") or (Mechanic = "Einhar") or (Mechanic = "Niko") or (Mechanic = "Betrayal")  or (Mechanic = "Incursion")
                {
                    MechanicCount := IniRead(MechanicsPath, Mechanic " Track", "Current Count", "")
                } 
            If ((MechanicOn = 2) and (MechanicActive = 1)) or (MechanicOn = 1)
                {
                    Overlay := AddOverlayItem(Overlay, Mechanic, MechanicActive, MechanicCount)
                }
        }

    ;Setup the active Influence
    ActiveInfluence := GetInfluence()
    InfluenceCount := IniRead(MechanicsPath, "Influence Track", ActiveInfluence, 0)
    Overlay := AddOverlayItem(Overlay, ActiveInfluence,,InfluenceCount)
    ShouldActivate := "NoActivate"
    If (MoveActive = 1)
        {
            OverlayOrientation := IniRead(OverlayIni, "Overlay Position", "Orientation", "Horizontal")
            If (OverlayOrientation = "Horizontal")
                {
                    OverlayOrientation := "YM"
                }
            If (OverlayOrientation = "Vertical")
                {
                    OverlayOrientation := "XM"
                }
            CurrentTheme := GetTheme()
            VerticalStatus := 0
            HorizontalStatus := 0
            If OverlayHeight = ""
                {
                    VerticalStatus := 1
                }
            If (OverlayWidth = "")
                {
                    HorizontalStatus := 1
                }
            Overlay.SetFont("s10 c" CurrentTheme[3])
            VerticalCheck := Overlay.Add("Checkbox", "YM Section Checked" VerticalStatus, "Center Vertically")
            HorizontalCheck := Overlay.Add("Checkbox", "XP Checked" HorizontalStatus, "Center Horizontally")
            Overlay.Add("Button", OverlayOrientation, "Lock").OnEvent("Click", LockMove.Bind(VerticalCheck, HorizontalCheck))
            Overlay.SetFont("s8 Bold c" CurrentTheme[2])
            Overlay.Add("Text", "XM", "Drag the overlay around and press `"Lock`" to store it's location.")
            ShouldActivate := ""
        }
    ;Activate Overlay and set transparency
    Overlay.Show(OverlayHeight OverlayWidth " " ShouldActivate)
    If !(MoveActive = 1)
        {
            WinSetTransColor("1e1e1e " OverlayTransparency, "PoE Mechanic Watch Overlay")
        }
    Overlay.OnEvent("Close", DestroyOverlay)
}

DestroyOverlay(*)
{
    If WinExist("PoE Mechanic Watch Overlay")
        {   
            OverlayHwnd := WinWait("PoE Mechanic Watch Overlay")
            OverlayObj := GuiFromHwnd(OverlayHwnd)
            If HasMethod(OverlayObj, "Destroy")
                {
                    OverlayObj.Destroy()
                }
        }
}

AddOverlayItem(Overlay, Mechanic, Active := 0, MechanicCount?)
{
    ;Get overlay settings
    OverlayIni := IniPath("Overlay")
    OverlayOrientation := IniRead(OverlayIni, "Overlay Position", "Orientation", "Horizontal")
    IconSize := IniRead(OverlayIni, "Size", "Icons", 40)
    OverlayFont := IniRead(OverlayIni, "Size", "Font", 12)
    If (OverlayOrientation = "Horizontal")
        {
            OverlayOrientation := "YM"
        }
        If (OverlayOrientation = "Vertical")
        {
            OverlayOrientation := "XM"
        }

    If (Active = 1)
        {
            Overlay.Add("Picture", "Section " OverlayOrientation " w" IconSize " h" IconSize, "Resources\Images\" Mechanic "_selected.png").Onevent("Click",  OverlayToggle.Bind(Mechanic))
        }
    If (Active = 0)
        {
            Overlay.Add("Picture", "Section " OverlayOrientation " w" IconSize " h" IconSize, "Resources\Images\" Mechanic ".png").Onevent("Click", OverlayToggle.Bind(Mechanic))
        }
    Overlay.BackColor := "1e1e1e"
    Overlay.SetFont("s" OverlayFont)
    Overlay.Add("Text", "BackgroundTrans cwhite Center XS w" IconSize, MechanicCount).OnEvent("Click", OverlayToggle.Bind(Mechanic))
    Return Overlay
}

OverlayToggle(ToggledMechanic, *)
{
    Mechanics := VariableStore("Mechanics")
    For Mechanic in Mechanics
        {
            If (ToggledMechanic = Mechanic)
                {
                    ToggleMechanic(Mechanic)
                    Break
                }
        }
    Influences := VariableStore("Influences")
    For Influence in Influences
        {
            If (ToggledMechanic = Influence)
                {
                    IncrementInfluence(Influence)
                    Break
                }
        }
}

ToggleMechanic(Mechanic, Refresh:=1, Status:="", *)
{
    MechanicsPath := IniPath("Mechanics")
    MechanicActive := IniRead(MechanicsPath, "Mechanic Active", Mechanic, 0)
    If (MechanicActive = 1) and !(Status = "On")
        {
            IniWrite(0, MechanicsPath, "Mechanic Active", Mechanic)
            If (Refresh = 1)
                {
                    RefreshOverlay()
                }
            If (Mechanic = "Ritual") or (Mechanic = "Einhar") or (Mechanic = "Niko") or (Mechanic = "Betrayal")  or (Mechanic = "Incursion")
                {
                    IniWrite(A_Space, MechanicsPath, Mechanic " Track", "Current Count")
                } 
        }
    If (MechanicActive = 0) and !(Status = "Off")
        {
            IniWrite(1, MechanicsPath, "Mechanic Active", Mechanic)
            If (Refresh = 1)
                {
                    RefreshOverlay()
                }
        }
}

GetInfluence()
{
    Influences := VariableStore("Influences")
    MechanicsPath := IniPath("Mechanics")
    For Influence in Influences
        {
            InfluenceActive := IniRead(MechanicsPath, "Influence", Influence, 0)
            If (InfluenceActive = 1)
                {
                    ActiveInfluence := Influence
                    Break
                }
        }
    Return ActiveInfluence
}

IncrementInfluence(Influence)
{
    MechanicsPath := IniPath("Mechanics")
    If GetKeyState("ALT", "P") ; Reset influence count if "Alt Clicked"
        {
            IniWrite(0, MechanicsPath, "Influence Track", Influence)
        }
    Else
        {
            CurrentCount := IniRead(MechanicsPath, "Influence Track", Influence, 0)
            CurrentCount++
            If (CurrentCount > 28) and ((Influence = "Searing") or (Influence = "Eater"))
                {
                    CurrentCount := 0
                }
            If (CurrentCount > 10) and (Influence = "Maven")
                {
                    CurrentCount := 0
                }
            IniWrite(CurrentCount, MechanicsPath, "Influence Track", Influence)
        }
    RefreshOverlay()
}

RefreshOverlay(*)
{
    DestroyOverlay()
    CreateOverlay()
}

MoveOverlay(*)
{
    Global MoveActive := 1
    RefreshOverlay()
}

LockMove(VerticalCheck, HorizontalCheck, *)
{
    WinGetPos &Xpos, &Ypos,,,"PoE Mechanic Watch Overlay"
    YPos := "y" YPos + 32
    XPos := "x" XPos
    If (VerticalCheck.Value = 1)
        {
            Ypos := ""
        }
    If (HorizontalCheck.Value = 1)
        {
            Xpos := ""
        }
    OverlayIni := IniPath("Overlay")
    IniWrite(Xpos, OverlayIni, "Overlay Position", "Width")
    IniWrite(Ypos, OverlayIni, "Overlay Position", "Height")
    Global MoveActive := 0
    RefreshOverlay()
}

LayoutSet(Value, *)
{
    OverlayIni := IniPath("Overlay")
    IniWrite(Value.Text, OverlayIni, "Overlay Position", "Orientation")
}

IconEditChange(*)
{
    OverlayIni := IniPath("Overlay")
    IniWrite(IconEdit.Value, OverlayIni, "Size", "Icons")
}

IconUpDownChange(*)
{
    OverlayIni := IniPath("Overlay")
    IniWrite(IconUpDown.Value, OverlayIni, "Size", "Icons")
}

FontEditChange(*)
{
    OverlayIni := IniPath("Overlay")
    IniWrite(FontEdit.Value, OverlayIni, "Size", "Font")
}

FontUpDownChange(*)
{
    OverlayIni := IniPath("Overlay")
    IniWrite(FontUpDown.Value, OverlayIni, "Size", "Font")
}

Restart(*)
{
    Reload
}

Close(*)
{
    ExitApp
}

StartTasks()
{
    UpdateCheck()
    CheckPath()
    StartWatch()
    ApplyHotkeys()
}

#IncludeAgain "Resources\Scripts\AppVol.ahk"
#IncludeAgain "Resources\Scripts\Calibration.ahk"
#IncludeAgain "Resources\Scripts\Hideout.ahk"
#IncludeAgain "Resources\Scripts\Hotkeys.ahk"
#IncludeAgain "Resources\Scripts\ImagePut.ahk"
#IncludeAgain "Resources\Scripts\LaunchOptions.ahk"
#IncludeAgain "Resources\Scripts\LogMonitor.ahk"
#IncludeAgain "Resources\Scripts\Maven.ahk"
#IncludeAgain "Resources\Scripts\Mechanics.ahk"
#IncludeAgain "Resources\Scripts\Notification.ahk"
#IncludeAgain "Resources\Scripts\OCR.ahk"
#IncludeAgain "Resources\Scripts\ScreenSearch.ahk"
#IncludeAgain "Resources\Scripts\ScrollableGui.ahk"
#IncludeAgain "Resources\Scripts\Setup.ahk"
#IncludeAgain "Resources\Scripts\Theme.ahk"
#IncludeAgain "Resources\Scripts\Update.ahk"
#IncludeAgain "Resources\Scripts\VariableHandler.ahk"

;Tasks
    ;### need to complete Maven Invitation function in the hotkey script for "GetHotkeyPairs()"
    ; ### need to add check for mechanic screensearch to make sure auto is active. 
    ; #### Need to add Blight to calibration menu. 
    ; ### verify that all auto mechanics check that the mechanic is on and the auto mode is enabled. 
    ; ### ritual toggling for auto mode needs to check that it's enabled. 
    ; ### Ritual text isn't being read. (Works from default settings but not from set area.)
    ; ### input for the gui doens't consistently work with OCR Calibration. 
    ; ### Overlay didn't show on first launch without alt-tab.  