SetupTool(*)
{
    Setup := GuiTemplate("Setup", "Setup Tool", 500)
    CurrentTheme := GetTheme()
    SetupItems := ["* Open Path of Exile Client.", "  Select alternate settings storage location", "  Select your Theme", "* Select your Hideout", "* Select the Mechanics you want to track", "  View/Change options for various notifications" ,"  Modify Hotkeys", "  Quickly launch your favorite applications/scripts/websites", "  Get a reminder to start/enable your buffs when you enter a map"]
    SetupCategories := ["Client", "Storage Location", "Theme", "Set Hideout", "Select Mechanics", "Notification Settings", "Hotkeys", "Quick Launch", "Custom Reminder"]
    Setup.SetFont("s10 Norm c" CurrentTheme[3])
    Setup.Add("Text", "w500", "Before using PoE Mechanic Watch click each item below to set your preferences. `nItems with a * are required")
    TotalCounts := 9
    Loop TotalCounts
        {
            SetupIni := IniPath("Setup")
            SetupCompletion := IniRead(SetupIni, "Setup Completion", SetupCategories[A_Index], 0)
            If (SetupCategories[A_Index] = "Client")
                {
                    SetupCompletion := ClientSetupCheck()
                }
            If (SetupCategories[A_Index] = "Set Hideout")
                {
                    SetupCompletion := HideoutSetupCheck()
                }
            Setup.Add("Checkbox", "XM Section Checked" SetupCompletion).OnEvent("Click", LaunchEvent.Bind(SetupCategories[A_Index]))
            Setup.Add("Text", "YS", SetupItems[A_Index]).OnEvent("Click", LaunchEvent.Bind(SetupCategories[A_Index]))
            If (SetupCategories[A_Index] = "Set Hideout") and (SetupCompletion = 1)
                {
                    CurrentHideout := GetHideout()
                    Setup.SetFont("Bold c" CurrentTheme[2])
                    Setup.Add("Text", "YS w70", ) ;Add spacer
                    Setup.Add("Text", "YS", "Current Hideout: " CurrentHideout)
                    Setup.SetFont("Norm c" CurrentTheme[3])
                }
        }
    Setup.Show
    Setup.OnEvent("Close", CheckCompletion)
}

SetupToolDestroy()
    {
        Setup.Destroy()
    }

LaunchEvent(ItemIndex, NA1, NA2)
{
    If (ItemIndex = "Client")
        {
            SetupToolDestroy()
            CheckPath()
            PathAvailable := ClientSetupCheck()
            If (PathAvailable = "1")
                {
                    SetupComplete(ItemIndex)
                    SetupTool()
                }
            Else
                {
                    Msgbox "Error: You must open Path of Exile to continue. This is required so the `"Client.txt`" path can be obtained. (This is only necessary for the first time you launch the script)"
                }
        }
    If (ItemIndex = "Set Hideout")
        {
            SetupToolDestroy()
            SetHideout()
            WinWaitClose("Update Hideout")
            HideoutComplete := HideoutSetupCheck()
            If (HideoutComplete = 1)
            {
                SetupComplete(ItemIndex)
            }
            SetupTool()
        }
    If (ItemIndex = "Theme")
        {
            SetupToolDestroy()
            ChangeGui()
            WinWaitClose("Change Theme")
            SetupComplete(ItemIndex)
            SetupTool()
        }
    If (ItemIndex = "Select Mechanics")
        {
            SetupToolDestroy()
            MechanicsSelect()
            WinWaitClose("Mechanics")
            SetupComplete(ItemIndex)
            SetupTool()
        }
    If (ItemIndex = "Quick Launch")
        {
            SetupToolDestroy()
            LauncherGui()
            WinWaitClose("Launcher Settings")
            SetupComplete(ItemIndex)
            SetupTool()
        }
    If (ItemIndex = "Storage Location")
        {
            SetupToolDestroy()
            SettingsLocation()
            WinWaitClose("Settings Storage Location")
            SetupComplete(ItemIndex)
            SetupTool()
        }
    If (ItemIndex = "Notification Settings")
        {
            SetupToolDestroy()
            NotificationSettings()
            WinWaitClose("Notification Settings")
            SetupComplete(ItemIndex)
            SetupTool()
        }
    If (ItemIndex = "Custom Reminder")
        {
            SetupToolDestroy()
            CustomNotificationSetup()
            WinWaitClose("Custom Reminder Setup")
            SetupComplete(ItemIndex)
            SetupTool()
        }
    If (ItemIndex = "Hotkeys")
        {
            SetupToolDestroy()
            HotkeySetup()
            WinWaitClose("Hotkey Setup")
            SetupComplete(ItemIndex)
            SetupTool()
        }
}

ClientSetupCheck()
{
    LaunchIni := IniPath("Launch")
    PathAvailable := IniRead(LaunchIni, "POE", "EXE", "Error")
    If (PathAvailable = "Error") or (PathAvailable = "")
        {
            Return 0
        }
    Else
        {
            Return 1
        }
}

HideoutSetupCheck()
{
    CurrentHideout := GetHideout()
    If (CurrentHideout = "Error") or (CurrentHideout = "")
        {
            Return 0
        }
    Else
        {
            Return 1
        }
}

SetupComplete(Completed)
{
    SetupIni := IniPath("Setup")
    IniWrite(1, SetupIni, "Setup Completion", Completed)
}

CheckCompletion(*)
{
    ClientCheck := ClientSetupCheck()
    HideoutCheck := HideoutSetupCheck()
    If (ClientCheck = 0) or (HideoutCheck = 0)
        {
            WarningGuiDestroy()
            CurrentTheme := GetTheme()
            WarningGui.BackColor := CurrentTheme[1]
            WarningGui.SetFont("s15 Bold c" CurrentTheme[3])
            WarningGui.Add("Text", "w300 Center", "Warning")
            WarningGui.SetFont("s12 Norm c" CurrentTheme[3])
            ErrorMessage := "The required setup tasks have not been completed. PoE Mechanic watch will not function properly until completed.`r`rBy clicking `"Yes`" PoE Mechanic Watch will close. Are you sure you want to close?"
            WarningGui.Add("Text", "w300", ErrorMessage)
            WarningGui.Add("Button","Section x100 w50", "Yes").OnEvent("Click", WarningYes)
            WarningGui.Add("Button","YS x200 w50", "No").OnEvent("Click", WarningNo)
            WarningGui.Opt("-Caption")
            WarningGui.Show
        }
}

WarningGuiDestroy()
{
    If WinExist("Warning")
        {
            WarningGui.Destroy()
        }
    Global WarningGui := Gui(,"Warning")
}

WarningYes(*)
{
    WarningGui.Destroy
    ExitApp
}

WarningNo(*)
{
    WarningGui.Destroy
    SetupTool()
}

SetupVerification()
{
    ClientCheck := ClientSetupCheck()
    HideoutCheck := HideoutSetupCheck()
    If (ClientCheck = 0) or (HideoutCheck = 0)
    {
        SetupTool()
        WinWaitClose("Setup Tool")
        SetupVerification()
    }
}