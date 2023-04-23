Global AutoMechanicState
Global ClientState
Global HideoutState
Global HotkeyState
Global LaunchAssistState
Global MechanicState
Global PositionState
Global MapPositionState
Global SoundState
Global ThemeState
Global ToolLauncherState
Global NotificationState
; Global ThemeSelect
; Global HideoutSelect
; Global MechanicSelect
; Global PositionSelect
; Global MapPositionSelect
; Global NotificationSelect
; Global AutoMechanicSelect
; Global HotkeySelect
; Global SoundSelect
; Global LaunchAssistSelect
; Global ToolLauncherSelect

CheckFirstRun() ;Check to see if all First Run Items are complete
{
    Global ItemSearch := "Client|Theme|Hideout|Mechanic|Position|MapPosition|AutoMechanic|Hotkey|Sound|LaunchAssist|Notification|ToolLauncher"
    Global Item
    Global each
    FirstRunPath := FirstRunIni()
    For each, Item in StrSplit(ItemSearch, "|")
    {
        %Item%State := IniRead(FirstRunPath, "Completion", Item, 0)
    }
    Return
}

FirstRun()
{
    PostSetup()
    LaunchPathIni := LaunchOptionsIni()
    exe := IniRead(LaunchPathIni, "POE", "EXE")
    If !WinExist("Tail.ahk") and If InStr(exe, ".exe")
    {
        Run("Resources\Scripts\Tail.ahk")
    }
    PostRestore()
    FirstRunPath := FirstRunIni()
    IniWrite(1, FirstRunPath, "Active", "Active")
    CheckFirstRun()
    GetHideout()
    Global yh := (A_ScreenHeight/2) -250
    Global xh := A_ScreenWidth/2
    First := Gui()
    First.Opt("+E0x02000000 +E0x00080000") ; WS_EX_COMPOSITED WS_EX_LAYERED
    First.BackColor := Background
    First.SetFont("c" . Font . " s12")
    First.Add("Text", "w550 +Center", "Welcome to PoE Mechanic Watch")
    First.Opt("-Caption")
    First.Title := "First"
    First.Show("NoActivate x" . xh . " y" . yh . " w550")
    WinSetStyle(-12582912, "First")
    WinGetPos(&X, &Y, &w, &h, "First")
    First.Hide()
    xh := xh - (w/2)
    yh1 := yh + h

    First2 := Gui()
    First2.Opt("+E0x02000000 +E0x00080000") ; WS_EX_COMPOSITED WS_EX_LAYERED
    First2.BackColor := Secondary
    First2.SetFont("cBlack s10")
    First2.Add("Text", , "Before using PoE Mechanic Watch click each item below to set your preferences.")
    First2.Add("Text", , "Items with a * are required")
    ogcCheckboxClientOpened := First2.Add("Checkbox", "vClientOpened  Checked" . ClientState, "* Open your Path of Exile Client")
    ogcCheckboxClientOpened.OnEvent("Click", ClientOpen.Bind("Normal"))
    ogcCheckboxThemeSelect := First2.Add("Checkbox", "vThemeSelect  Checked" . ThemeState, A_Space . " Select your Theme")
    ogcCheckboxThemeSelect.OnEvent("Click", ThemeSelect.Bind("Normal"))
    IniFile := HideoutIni()
    If FileExist(IniFile)
    {
        HideoutSetup := "Current Hideout: " . MyHideout
    }
    Else
    {
        HideoutSetup := ""
    }

    ogcCheckboxHideoutSelect := First2.Add("Checkbox", "vHideoutSelect  Checked" . HideoutState, "* Select your Hideout " . HideoutSetup)
    ogcCheckboxHideoutSelect.OnEvent("Click", HideoutSelect.Bind("Normal"))
    ogcCheckboxMechanicSelect := First2.Add("Checkbox", "vMechanicSelect  Checked" . MechanicState, "* Select the Mechanics you want to track")
    ogcCheckboxMechanicSelect.OnEvent("Click", MechanicSelect.Bind("Normal"))
    ogcCheckboxNotificationSelect := First2.Add("Checkbox", "vNotificationSelect  Checked" . NotificationState, A_Space . " View/Change options for various notifications.")
    ogcCheckboxNotificationSelect.OnEvent("Click", NotificationSelect.Bind("Normal"))
    ogcCheckboxAutoMechanicSelect := First2.Add("Checkbox", "vAutoMechanicSelect  Checked" . AutoMechanicState, A_Space . " Select Auto Mechanics")
    ogcCheckboxAutoMechanicSelect.OnEvent("Click", AutoMechanicSelect.Bind("Normal"))
    ogcCheckboxHotkeySelect := First2.Add("Checkbox", "vHotkeySelect  Checked" . HotkeyState, A_Space . " Modify Hotkeys (Highly recommended if you are using Influence tracking)")
    ogcCheckboxHotkeySelect.OnEvent("Click", HotkeySelect.Bind("Normal"))
    ogcCheckboxLaunchAssistSelect := First2.Add("Checkbox", "vLaunchAssistSelect  Checked" . LaunchAssistState, A_Space . " Select applications/scripts/etc. to be launched alongside Path of Exile")
    ogcCheckboxLaunchAssistSelect.OnEvent("Click", LaunchAssistSelect.Bind("Normal"))
    ogcCheckboxToolLauncherSelect := First2.Add("Checkbox", "vToolLauncherSelect  Checked" . ToolLauncherState, A_Space . " Quickly launch your favorite applications/scripts/websites")
    ogcCheckboxToolLauncherSelect.OnEvent("Click", ToolLauncherSelect.Bind("Normal"))
    ogcButtonClose := First2.Add("Button", "x490", "Close")
    ogcButtonClose.OnEvent("Click", First2ButtonClose.Bind("Normal"))
    First2.Opt("-Caption +HwndFirst2")
    First2.Title := "First2"
    First2.Show("x" . xh . " y" . yh1 . " w550")
    WinSetStyle(-12582912, "First2")

    First.Opt("-Caption +OwnerFirst2") ;;;;;; Intentionally here so that First2 is shown so it can own First
    First.Title := "First"
    First.Show("x" . xh . " y" . yh . " w550")
    WinSetStyle(-12582912, "First")
    WinWaitClose("First2")
    Return
}

ClientOpen()
{
    oSaved := First.Submit("0")
    If (ClientOpened = 1)
    {
        First.Destroy()
        First2.Destroy()
        FirstRunPath := FirstRunIni()
        If !WinExist("ahk_exe PathOfExileSteam.exe") and !WinExist("ahk_exe PathOfExile.exe") and !WinExist("ahk_exe PathOfExileEGS.exe") and !WinExist("ahk_class POEWindowClass")
        {
            FirstReminder := Gui()
            FirstReminder.Opt("+E0x02000000 +E0x00080000") ; WS_EX_COMPOSITED WS_EX_LAYERED
            FirstReminder.BackColor := Background
            FirstReminder.SetFont("c" . Font . " s10")
            FirstReminder.Add("Text", "w500 +Center", "You must open Path of Exile to continue. This is required so the Client.txt path can be obtained. (This is only necessary for the first run)")
            ogcButtonOK := FirstReminder.Add("Button", "x490", "OK")
            ogcButtonOK.OnEvent("Click", FirstReminderButtonOK.Bind("Normal"))
            FirstReminder.Opt("+AlwaysOnTop -Caption")
            yh := (A_ScreenHeight/2) -250
            xh := A_ScreenWidth/2
            FirstReminder.Title := "FirstReminder"
            FirstReminder.Show("NoActivate x" . xh . " y" . yh . " w550")
            IniWrite(0, FirstRunPath, "Completion", "Client")
            WinWaitClose("FirstReminder")
            CheckFirstRun()
            Reload()
        }
        Else
        {
            IniWrite(1, FirstRunPath, "Completion", "Client")
            GetLogPath()
            Reload()
        }
    }
    Return
}

ThemeSelect()
{
    oSaved := FirstReminder.Submit("0")
    First.Hide()
    First2.Destroy()
    SelectTheme()
    WinWaitClose("Gui:Theme")
    First.Destroy()
    FirstRunWrite("Theme")
    Return
}

HideoutSelect()
{
    oSaved := First.Submit("0")
    First.Destroy()
    First2.Hide()
    SetHideout()
    First2.Destroy()
    FirstRunWrite("Hideout")
    Return
}

MechanicSelect()
{
    oSaved := First2.Submit("0")
    ClientOpened := oSaved.ClientOpened
    ThemeSelect := oSaved.ThemeSelect
    HideoutSelect := oSaved.HideoutSelect
    MechanicSelect := oSaved.MechanicSelect
    NotificationSelect := oSaved.NotificationSelect
    AutoMechanicSelect := oSaved.AutoMechanicSelect
    HotkeySelect := oSaved.HotkeySelect
    LaunchAssistSelect := oSaved.LaunchAssistSelect
    ToolLauncherSelect := oSaved.ToolLauncherSelect
    First.Destroy()
    First2.Destroy()
    SelectMechanics()
    WinWaitClose("Mechanic")
    FirstRunWrite("Mechanic")
    Return
}

NotificationSelect()
{
    oSaved := First2.Submit("0")
    ClientOpened := oSaved.ClientOpened
    ThemeSelect := oSaved.ThemeSelect
    HideoutSelect := oSaved.HideoutSelect
    MechanicSelect := oSaved.MechanicSelect
    NotificationSelect := oSaved.NotificationSelect
    AutoMechanicSelect := oSaved.AutoMechanicSelect
    HotkeySelect := oSaved.HotkeySelect
    LaunchAssistSelect := oSaved.LaunchAssistSelect
    ToolLauncherSelect := oSaved.ToolLauncherSelect
    First.Destroy()
    First2.Destroy()
    NotificationSetup()
    WinWaitClose("Notification Settings")
    FirstRunWrite("Notification")
    Return
}

AutoMechanicSelect()
{
    oSaved := First2.Submit("0")
    ClientOpened := oSaved.ClientOpened
    ThemeSelect := oSaved.ThemeSelect
    HideoutSelect := oSaved.HideoutSelect
    MechanicSelect := oSaved.MechanicSelect
    NotificationSelect := oSaved.NotificationSelect
    AutoMechanicSelect := oSaved.AutoMechanicSelect
    HotkeySelect := oSaved.HotkeySelect
    LaunchAssistSelect := oSaved.LaunchAssistSelect
    ToolLauncherSelect := oSaved.ToolLauncherSelect
    First.Destroy()
    First2.Destroy()
    SelectAuto()
    WinWaitClose("Auto Enable/Disable (Beta)")
    Sleep(100)
    If WinExist("Mechanic")
    {
        Return
    }
    FirstRunWrite("AutoMechanic")
    Return
}


HotkeySelect()
{
    oSaved := First2.Submit("0")
    ClientOpened := oSaved.ClientOpened
    ThemeSelect := oSaved.ThemeSelect
    HideoutSelect := oSaved.HideoutSelect
    MechanicSelect := oSaved.MechanicSelect
    NotificationSelect := oSaved.NotificationSelect
    AutoMechanicSelect := oSaved.AutoMechanicSelect
    HotkeySelect := oSaved.HotkeySelect
    LaunchAssistSelect := oSaved.LaunchAssistSelect
    ToolLauncherSelect := oSaved.ToolLauncherSelect
    First.Destroy()
    First2.Destroy()
    HotkeyUpdate()
    WinWaitClose("Dynamic Hotkeys")
    FirstRunWrite("Hotkey")
    Return
}

LaunchAssistSelect()
{
    oSaved := First2.Submit("0")
    ClientOpened := oSaved.ClientOpened
    ThemeSelect := oSaved.ThemeSelect
    HideoutSelect := oSaved.HideoutSelect
    MechanicSelect := oSaved.MechanicSelect
    NotificationSelect := oSaved.NotificationSelect
    AutoMechanicSelect := oSaved.AutoMechanicSelect
    HotkeySelect := oSaved.HotkeySelect
    LaunchAssistSelect := oSaved.LaunchAssistSelect
    ToolLauncherSelect := oSaved.ToolLauncherSelect
    First.Destroy()
    First2.Destroy()
    LaunchGui()
    WinWaitClose("Launcher")
    FirstRunWrite("LaunchAssist")
    Return
}

ToolLauncherSelect()
{
    oSaved := First2.Submit("0")
    ClientOpened := oSaved.ClientOpened
    ThemeSelect := oSaved.ThemeSelect
    HideoutSelect := oSaved.HideoutSelect
    MechanicSelect := oSaved.MechanicSelect
    NotificationSelect := oSaved.NotificationSelect
    AutoMechanicSelect := oSaved.AutoMechanicSelect
    HotkeySelect := oSaved.HotkeySelect
    LaunchAssistSelect := oSaved.LaunchAssistSelect
    ToolLauncherSelect := oSaved.ToolLauncherSelect
    First.Destroy()
    First2.Destroy()
    ToolLaunchGui()
    WinWaitClose("ToolLauncher")
    FirstRunWrite("ToolLauncher")
    Return
}

FirstRunWrite(WriteItem)
{
    FirstRunPath := FirstRunIni()
    IniWrite(1, FirstRunPath, "Completion", WriteItem)
    Reload()
    Return
}

First2ButtonClose()
{
    FirstRunPath := FirstRunIni()
    IniWrite(0, FirstRunPath, "Active", "Active")
    oSaved := First2.Submit("0")
    ClientOpened := oSaved.ClientOpened
    ThemeSelect := oSaved.ThemeSelect
    HideoutSelect := oSaved.HideoutSelect
    MechanicSelect := oSaved.MechanicSelect
    NotificationSelect := oSaved.NotificationSelect
    AutoMechanicSelect := oSaved.AutoMechanicSelect
    HotkeySelect := oSaved.HotkeySelect
    LaunchAssistSelect := oSaved.LaunchAssistSelect
    ToolLauncherSelect := oSaved.ToolLauncherSelect
    First.Destroy()
    First2.Destroy()
    NotificationSettings := Gui()
    NotificationSettings.Destroy()
    CheckFirstRun()
    If (%ClientState% = 0) or (%HideoutState% = 0) or (%MechanicState% = 0) or (%ClientState% = "ERROR") or (%HideoutState% = "ERROR") or (%MechanicState% = "ERROR")
    {
        FirstWarning := Gui()
        FirstWarning.Opt("+E0x02000000 +E0x00080000") ; WS_EX_COMPOSITED WS_EX_LAYERED
        FirstWarning.BackColor := Background
        FirstWarning.SetFont("c" . Font . " s10")
        FirstWarning.Add("Text", "w530 +Center", "You haven't gone through all the required setup processes, PoE Mechanic Watch may not function correctly until you do.")
        ogcButtonDoItLater := FirstWarning.Add("Button", "y50 x50", "Do It Later")
        ogcButtonDoItLater.OnEvent("Click", FirstWarningButtonDoItLater.Bind("Normal"))
        ogcButtonGoBack := FirstWarning.Add("Button", "y50 x450", "Go Back")
        ogcButtonGoBack.OnEvent("Click", FirstWarningButtonGoBack.Bind("Normal"))
        FirstWarning.Opt("+AlwaysOnTop -Caption")
        FirstWarning.Title := "FirstWarning"
        FirstWarning.Show("NoActivate x" . xh . " y" . yh . " w550")
        WinWaitClose("FirstWarning")
    }
    Else
    {
        Reload()
    }
    Return
}

FirstReminderButtonOK()
{
    FirstReminder.Destroy()
    Return
}

FirstWarningButtonDoItLater(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
Exit()
Return
} ; V1toV2: Added bracket before function


FirstWarningButtonGoBack()
{
    FirstWarning.Destroy()
    FirstRun()
    Return
}