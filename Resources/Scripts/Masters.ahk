Global MasterOverlayLaunch
Global MasterMechanic
Global MasterTransparency
Global WarningTransparency
Global MasterGuiMove

MapDevice()
{
    MasterOverlayLaunch = 0
    Loop
    {
        HideoutIni := HideoutIni()
        IniRead, HideoutStatus, %HideoutIni%, In Hideout, In Hideout, 0
        {
            If (HideoutStatus = 0)
                {
                    MasterOverlayKill()
                    Break
                }
            Else
                {
                    MechanicsIniLoc := MechanicsIni()
                    IniRead, MasterMappingActive, %MechanicsIniLoc%, Master Mapping, Active, 0
                    If (MasterMappingActive != 1)
                    {
                        Break
                    }
                    If !WinActive("ahk_group PoeWindow")
                        {
                            WinWaitActive, ahk_group PoeWindow
                        }
                    gdipMapDevice := Gdip_Startup()
                    PoeHwnd2 := WinExist("ahk_class POEWindowClass")
                    bmpSearching := Gdip_BitmapFromHWND(PoeHwnd2, 1)


                    ImageLocation := "Resources\Images\Image Search\Custom\MapDevice.png"
                    If !FileExist(ImageLocation)
                        {
                            ImageLocation := "Resources\Images\Image Search\MapDevice.png"
                        }

                    SearchingFor := Gdip_CreateBitmapFromFile(ImageLocation)
                    SearchIniLoc := ScreenIni()
                    IniRead, MapVariation, %SearchIniLoc%, Variation, MapDevice
                    If (Gdip_ImageSearch(bmpSearching,SearchingFor,LIST,0,0,0,0,MapVariation,,1,0) > 0)
                        {

                            If !WinExist("Master Reminder") and (MasterOverlayLaunch = 0)
                            {
                                LaunchMaster()
                            }
                        }
                    Else
                        {
                            If WinExist("Master Reminder")
                                {
                                    Gui, Master:Destroy
                                    Gui, ActivateWarning:Destroy
                                }
                        }
                    Gdip_DisposeImage(bmpSearching)
                    DeleteObject(bmpSearching)
                    Gdip_DisposeImage(SearchingFor)
                    DeleteObject(SearchingFor)
                    Gdip_Shutdown(gdipMapDevice)
                }
        }
    }
}

LaunchMaster()
{
    MasterOverlayKill()
    SelectorLaunch()
    WarningLaunch()
    OnMessage(0x201, "WM_LBUTTONDOWN")
    Return
}

WM_LBUTTONDOWN() 
    { 
        If WinActive("Master Reminder") and (MasterGuiMove != 1)
            {
                CoordMode, Mouse, Screen
                MouseGetPos, MouseX, MouseY
                ControlClick, x%MouseX% y%MouseY%, ahk_class POEWindowClass
                MasterOverlayKill()
                MasterOverlayLaunch := 1
            }
        If WinActive("Master Reminder") and (MasterGuiMove = 1)
            {
                PostMessage 0xA1, 2
                MouseGetPos, MouseX, MouseY
                Winget, hwnd, ID, Activate Warning
                GuiControl,, Master, X%MouseX%, Y%MouseY%
                Return
                }
        If WinActive("Activate Warning") and (MasterGuiMove != 1)
            {
                MasterHotkey := MasterHotkeyGet()
                NotificationText := "Please select a master mission to continue! Press" A_Space """" MasterHotkey """" A_Space "to turn off."
                QuickNotify(NotificationText)
                NotificationIni := NotificationIni()
                IniRead, CloseDuration, %NotificationIni%, Map Notification Position, Duration
                SetTimer, CloseQuickNotify, -%CloseDuration%
            }
            If WinActive("Activate Warning") and (MasterGuiMove = 1)
                {
                    PostMessage 0xA1, 2
                    MouseGetPos, MouseX, MouseY
                    Winget, hwnd, ID, Activate Warning
                    GuiControl,, ActivateWarning, X%MouseX%, Y%MouseY%
                    Return
                }
    }

MasterOverlayKill()
{
    Gui, Master:Destroy
    Gui, ActivateWarning:Destroy
    Return
}

CloseQuickNotify()
{
    WinClose, Quick Notify
    Return
}

ToggleMasters()
{
    MechanicsIniLoc := MechanicsIni()
    IniRead, MasterStatus, %MechanicsIniLoc%, Master Mapping, Active , 0
    If (MasterStatus = 0)
        {
            MasterStatus := 1
        }
    Else
        {
            MasterStatus := 0
        }
    IniWrite, %MasterStatus%, %MechanicsIniLoc%, Master Mapping, Active
    MasterOverlayKill()
    CloseQuickNotify()
    Return
}

MasterSetup()
{
    Gui, MasterSetup:Destroy
    Gui, MasterSetup:Color, %Background%
    Gui, MasterSetup:Font, c%Font% s5
    Gui, MasterSetup:Add, Text, Section,
    Gui, MasterSetup:Font, c%Font% s18
    GuiW := Round(96/A_ScreenDPI*740)
    Gui, MasterSetup:Add, Text, Section +Center w%GuiW%, Master Mapping Setup
    Gui, MasterSetup:Font, c%Font% s10
    Gui, MasterSetup:Add, Text, +Wrap Section w%GuiW%, This tool will remind you to select a master mission when accessing the map device. It is highly recommended to setup a hotkey in the "Set Hotkey" tool, to be able to quickly disable the setting if desired. Note: Once enabled you'll need to leave and enter your hideout for the tool to activate. 
    BoxH := Round(96/A_ScreenDPI*1)
    Gui, MasterSetup:Font, s1
    Gui, MasterSetup:Add, Text,,
    Gui, MasterSetup:Add, GroupBox, +Center x5 w%GuiW% h%BoxH%OpenImage
    Gui, MasterSetup:Add, Text,,
    MechanicsIniLoc := MechanicsIni()
    IniRead, autochecked, %MechanicsIniLoc%, Master Mapping, Active, 0
    Gui, MasterSetup:Font, c%Font% s10
    Gui, MasterSetup:Add, Checkbox, xn x10 Section gToggleMasters Checked%autochecked%, Active
    If (ColorMode = "Dark")
        {
            PlayColor = Resources/Images/play white.png
            StopColor = Resources/Images/stop white.png
            MoveColor = Resources/Images/move white.png
        }
        If (ColorMode = "Light")
        {
            PlayColor = Resources/Images/play.png
            StopColor = Resources/Images/stop.png
            MoveColor = Resources/Images/move.png
        }
        If (ColorMode = "Custom")
            {
                If (Icons = "White")
                    {
                        PlayColor = Resources/Images/play white.png
                        StopColor = Resources/Images/stop white.png
                        MoveColor = Resources/Images/move white.png
                    }
                If (Icons = "Black")
                    {
                        PlayColor = Resources/Images/play.png
                        StopColor = Resources/Images/stop.png
                        MoveColor = Resources/Images/move.png
                    }
            }
    Gui, MasterSetup:Font, c%Font% s2
    Gui, MasterSetup:Add, Text, Section,
    Gui, MasterSetup:Font, c%Font% s13
    Offset1 := Round(96/A_ScreenDPI*165)        
    Gui, MasterSetup:Add, Text, x%Offset1% Section, View
    Offset := Round(96/A_ScreenDPI*20)
    Gui, MasterSetup:Add, Text, YS x+%Offset%, Move
    Gui, MasterSetup:Add, Text, YS x+%Offset%, Close
    Gui, MasterSetup:Add, Text, YS x+%Offset%, Transparency
    Gui, MasterSetup:Font, c%Font% s12

    Offset := Round(96/A_ScreenDPI*51)
    Offset1 := Round(96/A_ScreenDPI*180) 
    Offset2 := (96/A_ScreenDPI*70)
    Gui, MasterSetup:Add, Text, Section x10, Master Selector
    Gui, MasterSetup:Add, Picture, gSelectorLaunch YS x%Offset1% w15 h15, %PlayColor%
    Gui, MasterSetup:Add, Picture, gSelectorMove YS x+%Offset% w20 h20, %MoveColor%
    Gui, MasterSetup:Add, Picture, gSelectorKill YS x+%Offset% w15 h15, %StopColor%
    NotificationIniLoc := NotificationIni()
    Gui, MasterSetup:Font, cBlack s10
    IniRead, Value, %NotificationIniLoc%, Master Notification Position, Transparency, 255
    Gui, MasterSetup:Add, Edit, Center YS x+%Offset2% h20 w50 gMasterTran vMasterTransparency
    Gui, MasterSetup:Add, UpDown, Range0-255, %Value% x270 h20
    Gui, MasterSetup:Font, c%Font% s10
    Gui, MasterSetup:Add, Text, YS x+%Offset% +Wrap w180, The Master Selector needs to be positioned on top of the four circles used for selecting master missions. This is used to detect wheter or not a mission has been selected. 
    Gui, MasterSetup:Font, c%Font% s5
    Gui, MasterSetup:Add, Text,,
    Gui, MasterSetup:Font, c%Font% s12
    Gui, MasterSetup:Add, Text, Section xs, Warning Message
    Gui, MasterSetup:Add, Picture, gWarningLaunch YS x%Offset1% w15 h15, %PlayColor%
    Gui, MasterSetup:Add, Picture, gWarningMove YS x+%Offset% w20 h20, %MoveColor%
    Gui, MasterSetup:Add, Picture, gWarningKill YS x+%Offset% w15 h15, %StopColor%
    Gui, MasterSetup:Font, cBlack s10
    IniRead, Value, %NotificationIniLoc%, Activation Warning, Transparency, 255
    Gui, MasterSetup:Add, Edit, Center YS x+%Offset2% h20 w50 gWarningTran vWarningTransparency
    Gui, MasterSetup:Add, UpDown, Range0-255, %Value% x270 h20
    Gui, MasterSetup:Font, c%Font% s10
    Gui, MasterSetup:Add, Text, YS x+%Offset% +Wrap w180, Place the Warning Message somewhere that will be visible when attempting to activate your map.

    Gui, MasterSetup:Font, c%Font% s12
    ButtonLoc := GuiW - 50
    Gui, MasterSetup:Add, Text,,
    Gui, MasterSetup:Add, Button, x%ButtonLoc% ,Close
    Gui, MasterSetup:Add, Text, Section,
    Gui, MasterSetup:Show, , Master Setup
    Return
}

MasterSetupButtonClose()
{
    Gui, MasterSetup:Destroy
    MasterOverlayKill()
    SelectorKill()
    Return
}

SelectorKill()
{
    Gui, Master:Destroy
    ToolTip
    Return
}

SelectorLaunch(Move:=0)
{
    Gui, Master:Destroy
    CheckTheme()
    IniRead, Vertical, %NotificationIni%, Map Notification Position, Vertical
    IniRead, Horizontal, %NotificationIni%, Map Notification Position, Horizontal
    Gui, Master:Color, %Background%
    Gui, Master:Font, c%Font% s10
    AllowResize := ""
    OnMessage(0x201, "")
    If (Move = 1)
        {
            OnMessage(0x201, "WM_LBUTTONDOWN")
            MasterGuiMove := 1
            AllowResize := "+Resize MinSize75x75 MaxSize1000x1000"
            Gui, Master:Add, Button,w50 x3 y3, Lock
            ToolTip, Click and drag the top bar to position on top of the four master mission circles. Use the sides/corners to resize the window. 
        }
    Gui, Master:+AlwaysOnTop -Caption -Border %AllowResize%
    NotificationIni := NotificationIni()
    IniRead, NotificationY, %NotificationIni%, Master Notification Position, Vertical, 552
    IniRead, Notificationx, %NotificationIni%, Master Notification Position, Horizontal, 430
    IniRead, Notificationw, %NotificationIni%, Master Notification Position, Width, 300
    IniRead, Notificationh, %NotificationIni%, Master Notification Position, Height, 60
    IniRead, Trans, %NotificationIni%, Master Notification Position, Transparency, 255
    Gui, Master:+hwndGui22 -DPIScale
    Gui, Master:Show, y%NotificationY% x%Notificationx% h%Notificationh% w%Notificationw% NoActivate, Master Reminder
    WinSet, Transparent, %Trans%, Master Reminder
    Return
}

MasterGuiClose()
{
    WarningKill()
    Return
}

SelectorMove()
{
    SelectorLaunch(1)
    Return
}

MasterButtonLock()
{
    WinGetPos, newx, newy, newwidth, newheight, Master
    Winget, hwnd, ID, Master
    NotificationIni := NotificationIni()
    IniWrite, %newheight%, %NotificationIni%, Master Notification Position, Height
    IniWrite, %newwidth%, %NotificationIni%, Master Notification Position, Width
    IniWrite, %newx%, %NotificationIni%, Master Notification Position, Horizontal
    IniWrite, %newy%, %NotificationIni%, Master Notification Position, Vertical
    SelectorKill()
    Return
}

GetClientSize(hwnd, ByRef w, ByRef h)   ;by Lexikos http://www.autohotkey.com/forum/post-170475.html
{
    VarSetCapacity(rc, 16)
    DllCall("GetClientRect", "uint", hwnd, "uint", &rc)
    w := NumGet(rc, 8, "int")
    h := NumGet(rc, 12, "int")
}

WarningLaunch(Move:=0)
{
    Gui, ActivateWarning:Destroy
    CheckTheme()
    Gui, ActivateWarning:Color, %Background%
    Gui, ActivateWarning:Font, c%Font% s10
    Gui, ActivateWarning:Add, Text, Center y5, Master mission not active. Please select a master mission!
    AllowResize := ""
    Resizable := ""
    Resizable2 := ""
    OnMessage(0x201, "")
    If (Move = 1)
        {
            OnMessage(0x201, "WM_LBUTTONDOWN")
            MasterGuiMove := 1
            ShowTitle := ""
            ShowBorder := ""
            AllowResize := "+Resize MinSize94x31 MaxSize1000x1000"
            Gui, ActivateWarning:Add, Button,x3 w50, Lock
            ToolTip, Click and drag the window to a position of your liking. Use the sides/corners to resize the window. 
        }
    Gui, ActivateWarning:+AlwaysOnTop -Border -Caption %AllowResize%
    NotificationIni := NotificationIni()
    IniRead, NotificationY, %NotificationIni%, Activation Warning, Vertical, 913
    IniRead, Notificationx, %NotificationIni%, Activation Warning, Horizontal, 406
    IniRead, Notificationh, %NotificationIni%, Activation Warning, Height, 53
    IniRead, Trans, %NotificationIni%, Activation Warning, Transparency, 255
    Gui, ActivateWarning:+hwndGui25 -DPIScale
    Gui, ActivateWarning:Show, y%NotificationY% x%Notificationx% h%Notificationh% NoActivate, Activate Warning
    WinSet, Transparent, %Trans%, Activate Warning
    Return
}

WarningMove()
{
    WarningLaunch(1)
    Return
}

WarningKill()
{
    Gui, ActivateWarning:Destroy
    ToolTip
    Return
}

ActivateWarningButtonLock()
{
    WinGetPos, newx, newy, newwidth, newheight, Activate Warning
    Winget, hwnd, ID, Activate Warning
    GetClientSize(hwnd, newwidth, newheight)
    newheight := newheight - 20
    NotificationIni := NotificationIni()
    IniWrite, %newheight%, %NotificationIni%, Activation Warning, Height
    IniWrite, %newx%, %NotificationIni%, Activation Warning, Horizontal
    IniWrite, %newy%, %NotificationIni%, Activation Warning, Vertical
    WarningKill()
    Return
}

ActivateWarningGuiClose()
{
    WarningKill()
    Return
}

MasterSetupGuiClose()
{
    WarningKill()
    MasterOverlayKill()
    Return
}

MasterTran()
{
    Gui, MasterSetup:Submit, Nohide
    NotificationIniLoc := NotificationIni()
    IniWrite, %MasterTransparency%, %NotificationIniLoc%, Master Notification Position, Transparency
    Return
}

WarningTran()
{
    Gui, MasterSetup:Submit, Nohide
    NotificationIniLoc := NotificationIni()
    IniWrite, %WarningTransparency%, %NotificationIniLoc%, Activation Warning, Transparency
    Return
}