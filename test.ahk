#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

;Tray Menu setup
TraySetIcon("Resources/Images/Ritual.png")
MyTray := Menu()
MyTray:= A_TrayMenu
MyTray.Delete() ; Delete the standard items.
MyTray.Add("Launch Path of Exile", LaunchPoE)
MyTray.Add()
MyTray.Add("Select Mechanics", MechanicsSelect)
MyTray.Add()
Setup := Menu()
Setup.Add("Set Hideout", SetHideout)
Setup.Add()
Setup.Add("Overlay Settings", OverlaySettingsRun)
Setup.Add("Move Overlay", MoveOverlay)
Setup.Add()
Setup.Add("Change Theme", ChangeGui)
Setup.Add()
Setup.Add("Calibration Tool", CalibrationTool)
MyTray.Add("Setup", Setup)
MyTray.Add()
MyTray.Add("Reload This Script", Restart) 
MyTray.Add("Exit", Close)

; Group of windows that are monitored for the overlay
GroupAdd("PoeWindow", "ahk_exe PathOfExileSteam.exe")
GroupAdd("PoeWindow", "ahk_exe PathOfExile.exe")
GroupAdd("PoeWindow", "ahk_exe PathOfExileEGS.exe")
; GroupAdd("PoeWindow", "Reminder")
; GroupAdd("PoeWindow", "InfluenceReminder")
; GroupAdd("PoeWindow", "Overlay")
; GroupAdd("PoeWindow", "Move")
; GroupAdd("PoeWindow", "Influence")
; GroupAdd("PoeWindow", "Transparency")
GroupAdd("PoeWindow", "ahk_exe Code.exe")
; GroupAdd("PoeWindow", "ahk_class Notepad")

Global Overlay := Gui(,"Overlay")
Global OverlaySettings := Gui(,"Overlay Settings")
Global MoveActive := 0

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
GroupAdd("AHKFiles", "LaunchOptions.ahk")
GroupAdd("AHKFiles", "Mechanics.ahk")
GroupAdd("AHKFiles", "Calibration.ahk")
GroupAdd("AHKFiles", "Hideout.ahk")
GroupAdd("AHKFiles", "Setup.ahk")
GroupAdd("AHKFiles", "test.ahk")
GroupAdd("AHKFiles", "Theme.ahk")
GroupAdd("AHKFiles", "VariableHandler")

SetupTool()

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
            DestroyOverlay()
            CreateOverlay()
        }
    If ((Message == HSHELL_GETMINRECT) or (Message == HSHELL_RUDEAPPACTIVATED) or (Message == HSHELL_WINDOWACTIVATED) or (Message == HSHELL_WINDOWREPLACED)) and !WinActive("ahk_group PoeWindow") and !(MoveActive = 1)
        {
            DestroyOverlay()
        }
}
;Overlay Control End

WinWait("ahk_Group PoeWindow") ;Update launch path
GamePath := WinGetProcessPath("ahk_Group PoeWindow")
If InStr(GamePath, "PathOfExile")
    {
        LaunchIni := IniPath("Launch")
        SplitPath(GamePath, &ExeName, &ExeDirectory)
        IniWrite(ExeName, LaunchIni, "POE", "EXE")
        IniWrite(ExeDirectory, LaunchIni, "POE", "Directory")
    }

CreateOverlay()
{
    ;Get overlay settings from ini files
    If WinExist("Overlay")
        {
            DestroyOverlay()
        }
    OverlayIni := IniPath("Overlay")
    TransparencyPath := IniPath("Transparency")
    MechanicsPath := IniPath("Mechanics")
    OverlayHeight := IniRead(OverlayIni, "Overlay Position", "Height", A_ScreenHeight-300)
    OverlayWidth := IniRead(OverlayIni, "Overlay Position", "Width", A_ScreenWidth/2)
    OverlayTransparency := IniRead(TransparencyPath, "Transparency", "Overlay", 255)
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
                    AddOverlayItem(Mechanic, MechanicActive, MechanicCount)
                }
        }

    ;Setup the active Influence
    Influences := VariableStore("Influences")
    For Influence in Influences
        {
            InfluenceActive := IniRead(MechanicsPath, "Influence", Influence, 0)
            If (InfluenceActive = 1)
                {
                    ActiveInfluence := Influence
                    Break
                }
        }
    InfluenceCount := IniRead(MechanicsPath, "Influence Track", ActiveInfluence, 0)
    AddOverlayItem(ActiveInfluence,,InfluenceCount)
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
            Overlay.Add("Button", OverlayOrientation, "Lock").OnEvent("Click", LockMove)
            ShouldActivate := ""
            Tooltip("Drag the overlay around and press `"Lock`" to store it's location.", A_ScreenWidth/2 - 200, A_ScreenHeight/2)
        }
    ;Activate Overlay and set transparency
    Overlay.Show("y" OverlayHeight "x" OverlayWidth " " ShouldActivate)
    WinSetTransColor("1e1e1e " OverlayTransparency, "Overlay")
}

DestroyOverlay()
{
    If WinExist("Overlay")
        {
            Overlay.Destroy()
        }
    Global Overlay := Gui(,"Overlay")
}

AddOverlayItem(Mechanic, Active := 0, MechanicCount?)
{
    ;Get overlay settings
    OverlayIni := IniPath("Overlay")
    OverlayOrientation := IniRead(OverlayIni, "Overlay Position", "Orientation", "Horizontal")
    IconHeight := IniRead(OverlayIni, "Size", "Height", 40)
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
            Overlay.Add("Picture", "Section " OverlayOrientation " w-1 h" IconHeight, "Resources\Images\" Mechanic "_selected.png").Onevent("Click",  OverlayToggle.Bind(Mechanic))
        }
    If (Active = 0)
        {
            Overlay.Add("Picture", "Section " OverlayOrientation " w-1 h" IconHeight, "Resources\Images\" Mechanic ".png").Onevent("Click", OverlayToggle.Bind(Mechanic))
        }
    Overlay.BackColor := "1e1e1e"
    Overlay.SetFont("s" OverlayFont)
    Overlay.Add("Text", "BackgroundTrans cwhite Center XS w" IconHeight, MechanicCount).OnEvent("Click", OverlayToggle.Bind(Mechanic))
}

OverlayToggle(ToggledMechanic, NA1, NA2)
{
    Mechanics := VariableStore("Mechanics")
    For Mechanic in Mechanics
        {
            If (ToggledMechanic = Mechanic)
                {
                    Toggle(Mechanic)
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

Toggle(Mechanic)
{
    MechanicsPath := IniPath("Mechanics")
    MechanicActive := IniRead(MechanicsPath, "Mechanic Active", Mechanic, 0)
    If (MechanicActive = 1)
        {
            IniWrite(0, MechanicsPath, "Mechanic Active", Mechanic)
            If (Mechanic = "Ritual") or (Mechanic = "Einhar") or (Mechanic = "Niko") or (Mechanic = "Betrayal")  or (Mechanic = "Incursion")
                {
                    IniWrite(A_Space, MechanicsPath, Mechanic " Track", "Current Count")
                } 
        }
    Else
        {
            IniWrite(1, MechanicsPath, "Mechanic Active", Mechanic)
        }
    RefreshOverlay()
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

LockMove(*)
{
    newwidth := 0
    newHeight := 0
    WinGetPos &Xpos, &Ypos,,,Overlay
    YPos := YPos + 32
    OverlayIni := IniPath("Overlay")
    IniWrite(Xpos, OverlayIni, "Overlay Position", "Width")
    IniWrite(Ypos, OverlayIni, "Overlay Position", "Height")
    Global MoveActive := 0
    ToolTip
    RefreshOverlay()
}

;Overlay Gui
OverlaySettingsRun(*)
{
    OverlayIni := IniPath("Overlay")
    OverlaySettings := Gui(,"Overlay Settings")
    OverlaySettingsClose()
    CurrentTheme := GetTheme()
    OverlaySettings.BackColor := CurrentTheme[1]
    OverlaySettings.SetFont("s20 Bold c" CurrentTheme[3])
    OverlaySettings.Add("Text", "w500 Center", "Overlay Settings")
    OverlaySettings.AddText("w500 h1 Background" CurrentTheme[3])
    OverlaySettings.SetFont("s13 Norm")
    OverlaySettings.Add("Text", "w150 Right Section", "Refresh Overlay:")
    OverlaySettings.Add("Text", "w130 YS Right ", "")
    RefreshIcon := "Resources\Images\refresh " CurrentTheme[4] ".png"
    OverlaySettings.Add("Picture", "w25 h25 YS Right", RefreshIcon).OnEvent("Click", RefreshOverlay)

    OverlaySettings.Add("Text", "XM w150 Right Section", "Move Overlay:")
    OverlaySettings.Add("Text", "w130 YS Right Section", "")

    MoveIcon := "Resources\Images\Move " CurrentTheme[4] ".png"
    OverlaySettings.Add("Picture", "w25 h25 YS Right", MoveIcon).OnEvent("Click", MoveOverlay)

    OverlaySettings.Add("Text", "XM w150 Right Section", "Layout:")
    OverlaySettings.Add("Text", "w100 YS Right Section", "")
    OverlayOrientation := IniRead(OverlayIni, "Overlay Position", "Orientation", "Horizontal")
    If (OverlayOrientation = "Horizontal")
        {
            OverlayOrientation := 2
        }
    Else
        {
            OverlayOrientation := 1
        }
    OverlaySettings.SetFont("s11")
    Global DDLOptions := ["Vertical", "Horizontal"]
    Global LayoutSelect := OverlaySettings.Add("DropDownList", "w100 vOrientationChoice YS Choose" OverlayOrientation " Background" CurrentTheme[2],DDLOptions )
    LayoutSelect.OnEvent("Change", LayoutSet)

    OverlaySettings.SetFont("s13")
    OverlaySettings.Add("Text", "XM w150 Right Section", "Icon Size:")
    OverlaySettings.Add("Text", "w100 YS Right Section", "")
    IconHeight := IniRead(OverlayIni, "Size", "Height", 40)
    OverlaySettings.SetFont("s11")
    Global IconEdit := OverlaySettings.AddEdit("YS w100 Number Background" CurrentTheme[2])
    Global IconUpDown := OverlaySettings.AddUpDown("YS Range1-255", IconHeight)
    IconEdit.OnEvent("Change", IconEditChange)
    IconUpDown.OnEvent("Change", IconUpDownChange)

    OverlaySettings.SetFont("s13")
    OverlaySettings.Add("Text", "XM w150 Right Section", "Font Size:")
    OverlaySettings.Add("Text", "w100 YS Right Section", "")
    OverlayFont := IniRead(OverlayIni, "Size", "Font", 12)
    OverlaySettings.SetFont("s11")
    Global FontEdit := OverlaySettings.AddEdit("YS w100 Number Background" CurrentTheme[2])
    Global FontUpDown := OverlaySettings.AddUpDown("Range1-255", OverlayFont)
    FontEdit.OnEvent("Change", FontEditChange)
    FontUpDown.OnEvent("Change", FontUpDownChange)
    OverlaySettings.OnEvent("Close", RefreshOverlay)
    OverlaySettings.Show
}

OverlaySettingsClose()
{
    If WinExist("Overlay Settings")
        {
            OverlaySettings.Destroy
            OverlaySettings := Gui(,"Overlay Settings")
        }
}

LayoutSet(*)
{
    OverlayIni := IniPath("Overlay")
    IniWrite(DDLOptions[LayoutSelect.Value], OverlayIni, "Overlay Position", "Orientation")
}

IconEditChange(*)
{
    OverlayIni := IniPath("Overlay")
    IniWrite(IconEdit.Value, OverlayIni, "Size", "Height")
}

IconUpDownChange(*)
{
    OverlayIni := IniPath("Overlay")
    IniWrite(IconUpDown.Value, OverlayIni, "Size", "Height")
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

ActivateFootnoteGui(GuiInfo, X:="", Y:="", W:="", H:="")
{
    DestroyFootnote()
    CurrentTheme := GetTheme()
    FootnoteGui.BackColor := CurrentTheme[1]
    FootnoteGui.SetFont("s10 c" CurrentTheme[3])
    WrapWidth := "w200"
    If !(W = "")
        {
            WrapWidth := "w" W-20
        }
    FootnoteGui.Add("Link", WrapWidth " Wrap" ,GuiInfo)
    GuiX := ""
    GuiY := ""
    GuiW := ""
    GuiH := ""
    LocationVariable := ["X", "Y", "W", "H"]
    For Location in LocationVariable
        {
            If !(%Location% = "")
                {
                    Gui%Location% := Location %Location%
                }
        }
    FootnoteGui.Show( GuiX GuiY GuiW GuiH)
}

DestroyFootnote()
{
    If WinExist("Footnote")
        {
            FootnoteGui.Destroy()
        }
    Global FootnoteGui := Gui(,"Footnote")
}

Restart(*)
{
    Reload
}

Close(*)
{
    ExitApp
}

#IncludeAgain "Resources\Scripts\Calibration.ahk"
#IncludeAgain "Resources\Scripts\Hideout.ahk"
#IncludeAgain "Resources\Scripts\LaunchOptions.ahk"
#IncludeAgain "Resources\Scripts\Mechanics.ahk"
#IncludeAgain "Resources\Scripts\Setup.ahk"
#IncludeAgain "Resources\Scripts\Theme.ahk"
#IncludeAgain "Resources\Scripts\VariableHandler.ahk"

;Tasks
    ;### Write check for Theme ini File and create if necsessary. 
    ;### need to fix double overlay hapenning sometimes when moving overlay more than once. 