LaunchEvent(ItemIndex, Setup, GuiTabs, IndexCount *)
{
    If (ItemIndex = "Client")
        {
            CheckPath()
            PathAvailable := ClientSetupCheck()
            If (PathAvailable = "1")
                {
                    SetupComplete(ItemIndex)
                    ControlSetChecked(1, ControlGetHwnd(SettingsGui["Checkbox" IndexCount[1]]))
                    SettingsToolDestroy(Setup, "1")
                    Settings(1)
                }
            Else
                {
                    Msgbox "Error: You must open Path of Exile to continue. This is required so the `"Client.txt`" path can be obtained. (This is only necessary for the first time you launch the script)"
                }
        }
    If (ItemIndex = "Set Hideout")
        {
            SwitchTab(5, GuiTabs)
            While (GuiTabs.Value = 5)
                Sleep(1)
            HideoutComplete := HideoutSetupCheck()
            If (HideoutComplete = 1)
            {
                ControlSetChecked(1, ControlGetHwnd(SettingsGui["Checkbox" IndexCount[1]]))
                SetupComplete(ItemIndex)
            }
        }
    If (ItemIndex = "Theme")
        {
            SwitchTab(6, GuiTabs)
            SetupComplete(ItemIndex)
            ControlSetChecked(1, ControlGetHwnd(SettingsGui["Checkbox" IndexCount[1]]))
        }
    If (ItemIndex = "Select Mechanics")
        {
            SwitchTab(2, GuiTabs)
            ControlSetChecked(1, ControlGetHwnd(SettingsGui["Checkbox" IndexCount[1]]))
            SetupComplete(ItemIndex)
        }
    If (ItemIndex = "Quick Launch")
        {
            SwitchTab(8, GuiTabs)
            ControlSetChecked(1, ControlGetHwnd(SettingsGui["Checkbox" IndexCount[1]]))
            SetupComplete(ItemIndex)
        }
    If (ItemIndex = "Storage Location")
        {
            SwitchTab(9, GuiTabs)
            SetupComplete(ItemIndex)
            ControlSetChecked(1, ControlGetHwnd(SettingsGui["Checkbox" IndexCount[1]]))
        }
    If (ItemIndex = "Notification Settings")
        {
            SwitchTab(4, GuiTabs)
            ControlSetChecked(1, ControlGetHwnd(SettingsGui["Checkbox" IndexCount[1]]))
            SetupComplete(ItemIndex)
        }
    If (ItemIndex = "Custom Reminder")
        {
            SwitchTab(11, GuiTabs)
            ControlSetChecked(1, ControlGetHwnd(SettingsGui["Checkbox" IndexCount[1]]))
            SetupComplete(ItemIndex)
        }
    If (ItemIndex = "Hotkeys")
        {
            SwitchTab(7, GuiTabs)
            ControlSetChecked(1, ControlGetHwnd(SettingsGui["Checkbox" IndexCount[1]]))
            SetupComplete(ItemIndex)
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

CheckCompletion(Setup, *)
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
            WarningGui.Add("Button","Section x100 w50", "Yes").OnEvent("Click", WarningYes.Bind(Setup))
            WarningGui.Add("Button","YS x200 w50", "No").OnEvent("Click", WarningNo)
            WarningGui.Opt("-Caption")
            WarningGui.Show
            Return 0
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

WarningYes(Setup, *)
{
    WarningGui.Destroy()
    ExitApp
}

WarningNo(*)
{
    WarningGui.Destroy
    Settings()
}

SetupVerification()
{
    ClientCheck := ClientSetupCheck()
    HideoutCheck := HideoutSetupCheck()
    If (ClientCheck = 0) or (HideoutCheck = 0)
    {
        Settings(1)
    }
    Else
    {
        StartTasks()
    }
}

Settings(TargetTab:=1, *)
{
    Global SettingsGui := GuiTemplate("SettingsGui", "Settings", 1050)
    CurrentTheme := GetTheme()
    SettingsGui.SetFont("s12")
    If (TargetTab = 1)
    {
        SettingsGui.SetFont("cRed")
    }
    SettingsTabs := GetTabs()
    SettingsTabName := GetTabNames()
    SettingsGui.Add("GroupBox", "Section x10 y125 r1 w130")
    SettingsGui.Add("Text", "XP+2 YP+25 w125 Center vSetupTab", "Setup").OnEvent("Click", ChangeTab.Bind("SetupTab"))
    SettingsGui.SetFont("s12 c" CurrentTheme[3])
    For Setting in SettingsTabs
    {
        If (A_Index > 1) and (A_Index < 11) ; Controls what settings pages show as buttons. 
        {
            SettingsGui.Add("GroupBox", "XS y+20 r1 w130")
            If (A_Index = TargetTab)
            {
                SettingsGui.SetFont("cRed")
            }
            Else
            {
                SettingsGui.SetFont("c" CurrentTheme[3])
            }
            SettingsGui.Add("Text", "XP+2 YP+25 w125 Center v" SettingsTabName[A_Index], Setting).OnEvent("Click", ChangeTab.Bind(SettingsTabName[A_Index]))
        }
    }
    SettingsGui.SetFont("s10 Norm")
    SettingsGui.Add("GroupBox", "y100 x150 w900 h800")
    Global GuiTabs := SettingsGui.Add("Tab3","y150 YP XP w900 Choose" TargetTab, SettingsTabs) 
    
    TabMaxW := "w850"
    CurrentTab := 0

    ;Tab 1 Setup 
    CurrentTab := NewTab(CurrentTab)
    CurrentTheme := GetTheme()
    SetupItems := ["* Open Path of Exile Client.", "  Select alternate settings storage location", "  Select your Theme", "* Select your Hideout", "* Select the Mechanics you want to track", "  View/Change options for various notifications" ,"  Modify Hotkeys", "  Quickly launch your favorite applications/scripts/websites", "  Get a reminder to start/enable your buffs when you enter a map"]

    SettingsGui.SetFont("s15 Bold c" CurrentTheme[2])
    SettingsGui.Add("Text", TabMaxW " Center" ,"Setup")
    SettingsGui.AddText( TabMaxW " h1 Section Background" CurrentTheme[3])
    SettingsGui.SetFont("s11 Norm c" CurrentTheme[3])

    SetupCategories := ["Client", "Storage Location", "Theme", "Set Hideout", "Select Mechanics", "Notification Settings", "Hotkeys", "Quick Launch", "Custom Reminder"]
    SettingsGui.SetFont("s10 Norm c" CurrentTheme[3])
    SettingsGui.Add("Text", TabMaxW " xs x200 Section", "Before using PoE Mechanic Watch click each item below to set your preferences. Items with a * are required")
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
            SettingsGui.Add("Checkbox", "XS Section Checked" SetupCompletion " vCheckbox" A_Index ).OnEvent("Click", LaunchEvent.Bind(SetupCategories[A_Index], SettingsGui, GuiTabs,  A_Index))
            SettingsGui.Add("Text", "YS", SetupItems[A_Index]).OnEvent("Click", LaunchEvent.Bind(SetupCategories[A_Index], SettingsGui, GuiTabs, A_Index))
            If (SetupCategories[A_Index] = "Set Hideout") and (SetupCompletion = 1)
                {
                    CurrentHideout := GetHideout()
                    SettingsGui.SetFont("Bold c" CurrentTheme[2])
                    SettingsGui.Add("Text", "YS w70", ) ;Add spacer
                    SettingsGui.Add("Text", "YS vSetupHideout", "Current Hideout: " CurrentHideout)
                    SettingsGui.SetFont("Norm c" CurrentTheme[3])
                }
        }

    ;Mechanics Tab
    CurrentTab := NewTab(CurrentTab)
    SettingsGui.SetFont("s15 Bold c" CurrentTheme[2])
    SettingsGui.Add("Text", TabMaxW " Center" ,"Select Mechanics")
    SettingsGui.AddText( TabMaxW " h1 Section Background" CurrentTheme[3])
    SettingsGui.SetFont("s12 Bold c" CurrentTheme[3]) 
    Headers := ["Mechanic", "On", "Active Only", "Off", "Auto"]
    FootnoteIndex := 0
    For Title in Headers
        {
            HeaderWidth := "w100"
            If (Title = "On") or (Title = "Active Only") or (Title = "Auto")
                {
                    HeaderWidth := ""
                    FootnoteIndex++
                }
            LayoutFormat := "YP"
            If (A_Index = 1)
                {
                    LayoutFormat := "Section XS x300"
                }
                SettingsGui.Add("Text", LayoutFormat " Left " HeaderWidth, Title)
            If (Title = "On") or (Title = "Active Only") or (Title = "Auto")
                {
                    SettingsGui.SetFont("s8 Underline Bold c" CurrentTheme[2])  
                    SettingsGui.Add("Text","YP w70 Left " HeaderWidth, FootnoteIndex).OnEvent("Click", ShowFootnote.Bind(FootnoteIndex))
                    SettingsGui.SetFont("s12 Norm Bold c" CurrentTheme[3])  
                }
        } 
    SettingsGui.AddText("w580 h1 XS Background" CurrentTheme[3])
    Mechanics := VariableStore("Mechanics")
    MechanicsIni := IniPath("Mechanics")
    For Mechanic in Mechanics
        {
            Active := IniRead(MechanicsIni, "Mechanics", Mechanic, 0)
            Auto := IniRead(MechanicsIni, "Auto Mechanics", Mechanic, 0)
            SettingsGui.SetFont("s8 Underline c" CurrentTheme[2])
            FootnoteNum := ""
            AutoAvailable := 0
            If (Mechanic = "Betrayal") or (Mechanic = "Einhar") or (Mechanic = "Niko")
                {
                    FootnoteNum := 1
                    AutoAvailable := 1
                } 
            If (Mechanic = "Blight")
                {
                    FootnoteNum := 2
                    AutoAvailable := 1
                } 
            If (Mechanic = "Ultimatum") or (Mechanic = "Expedition")
                {
                    FootnoteNum := 3
                    AutoAvailable := 1
                } 
            If (Mechanic = "Incursion")
                {
                    FootnoteNum := 1
                    AutoAvailable := 1
                } 
            If (Mechanic = "Ritual")
                {
                    FootnoteNum := 4
                    AutoAvailable := 1
                } 
            SettingsGui.Add("Text","XS Right w10", FootnoteNum).OnEvent("Click", ShowMechanicFootnote.Bind(FootnoteNum))
            SettingsGui.SetFont("s10 Norm c" CurrentTheme[3]) 
            SettingsGui.Add("Text","YP Left w85", Mechanic ":")
            OnCheck := ""
            OnlyCheck := ""
            OffCheck := ""
            If (Active = 1)
                {
                    OnCheck := "Checked"
                }
            If (Active = 2)
                {
                    OnlyCheck := "Checked"
                }
            If (Active = 0)
                {
                    OffCheck := "Checked"
                }
            SettingsGui.Add("Radio","YP Left w135 " OnCheck).OnEvent("Click",OnSelected.Bind(Mechanic))
            SettingsGui.Add("Radio","YP Left w135 " OnlyCheck).OnEvent("Click",ActiveSelected.Bind(Mechanic))
            SettingsGui.Add("Radio","YP Left w110 " OffCheck).OnEvent("Click",OffSelected.Bind(Mechanic))
            If (AutoAvailable = 1)
                {
                    AutoChecked := ""
                    If (Auto = 1)
                        {
                            AutoChecked := "Checked"
                        }
                    SettingsGui.Add("Checkbox","YP Left " AutoChecked).OnEvent("Click",AutoSelected.Bind(Mechanic))
                }
        }
    SettingsGui.SetFont("s12 Bold c" CurrentTheme[3])
    SettingsGui.AddText("w580 h1 XS Background" CurrentTheme[3])
    SettingsGui.AddText("w150 Center XS Section", "Mechanic")
    SettingsGui.AddText("w50 Center YS",)
    SettingsGui.AddText("w200 Right YS", "Auto Switching/Tracking")
    SettingsGui.SetFont("s8 Underline Bold c" CurrentTheme[2])  
    Global EldritchFootnoteHandler := SettingsGui.Add("Text","YP w70 Left", 1)
    EldritchFootnoteHandler.OnEvent("Click", EldritchFootnote)
    Influences := VariableStore("Influences")
    SettingsGui.SetFont("s10 Norm c" CurrentTheme[3])
    NoneChecked := "Checked"
    For Influence in Influences
        {
            Active := IniRead(MechanicsIni, "Influence", Influence, 0)
            OnCheck := ""
            SectionSet := ""
            If (Active = 1)
                {
                    OnCheck := "Checked"
                    NoneChecked := ""
                }
            If (A_Index = 1)
                {
                    SectionSet := "Section x350"
                }
            SettingsGui.Add("Radio","XS Left w135 " OnCheck " " SectionSet, Influence).OnEvent("Click",InfluenceSelected.Bind(Influence))
        }
    SettingsGui.Add("Radio","XS Left w135 " NoneChecked, "None").OnEvent("Click",InfluenceSelected.Bind("None"))
    SettingsGui.Add("Text","YS Left w135 " OnCheck,).OnEvent("Click",InfluenceSelected.Bind("None"))
    Active := IniRead(MechanicsIni,"Auto Mechanics", "Eldritch", 0)
    IsChecked := ""
    If (Active = 1)
        {
            IsChecked := "Checked"
        }
    SettingsGui.Add("Checkbox", IsChecked " YS Left w135 Section " OnCheck,).OnEvent("Click",InfluenceTracking)
    SettingsGui.Add("Button", "XS-50 y+50", "Calibrate Search",).OnEvent("Click",CalibrateSearchButton.Bind(GuiTabs))

    ;Overlay Tab
    CurrentTab := NewTab(CurrentTab)
    SettingsGui.SetFont("s15 Bold c" CurrentTheme[2])
    SettingsGui.Add("Text", TabMaxW " Center" ,"Overlay Settings")
    SettingsGui.AddText( TabMaxW " h1 Section Background" CurrentTheme[3])
    SettingsGui.SetFont("s12 Norm c" CurrentTheme[3]) 
    SettingsGui.Add("Text", "XS x100 w250 Right Section") ; Spacer
    SettingsGui.Add("Text", "YS w150 Right Section", "Refresh Overlay:")
    SettingsGui.Add("Text", "w130 YS Right ", "")
    RefreshIcon := "Resources\Images\refresh " CurrentTheme[4] ".png"
    SettingsGui.Add("Picture", "w25 h25 YS Right", RefreshIcon).OnEvent("Click", RefreshOverlay)
    SettingsGui.Add("Text", "XS x100 w250 Right Section") ; Spacer
    SettingsGui.Add("Text", "YS w150 Right Section", "Move Overlay:")
    SettingsGui.Add("Text", "w130 YS Right Section", "")

    MoveIcon := "Resources\Images\Move " CurrentTheme[4] ".png"
    SettingsGui.Add("Picture", "w25 h25 YS Right", MoveIcon).OnEvent("Click", MoveOverlay)
    SettingsGui.Add("Text", "XS x100 w250 Right Section") ; Spacer
    SettingsGui.Add("Text", "YS w150 Right Section", "Layout:")
    SettingsGui.Add("Text", "w100 YS Right Section", "")
    OverlayIni := IniPath("Overlay")
    OverlayOrientation := IniRead(OverlayIni, "Overlay Position", "Orientation", "Horizontal")
    If (OverlayOrientation = "Horizontal")
        {
            OverlayOrientation := 2
        }
    Else
        {
            OverlayOrientation := 1
        }
    SettingsGui.SetFont("s11")
    Global DDLOptions := ["Vertical", "Horizontal"]
    LayoutSelect := SettingsGui.Add("DropDownList", "w100 vOrientationChoice YS Choose" OverlayOrientation " Background" CurrentTheme[2],DDLOptions )
    LayoutSelect.OnEvent("Change", LayoutSet)

    SettingsGui.SetFont("s13")
    SettingsGui.Add("Text", "XS x100 w250 Right Section") ; Spacer
    SettingsGui.Add("Text", "YS w150 Right Section", "Icon Size:")
    SettingsGui.Add("Text", "w100 YS Right Section", "")
    IconSize := IniRead(OverlayIni, "Size", "Icons", 40)
    SettingsGui.SetFont("s11")
    Global IconEdit := SettingsGui.AddEdit("YS w100 Number Background" CurrentTheme[2])
    Global IconUpDown := SettingsGui.AddUpDown("YS Range1-255", IconSize)
    IconEdit.OnEvent("Change", IconEditChange)
    IconUpDown.OnEvent("Change", IconUpDownChange)

    SettingsGui.SetFont("s13")
    SettingsGui.Add("Text", "XS x100 w250 Right Section") ; Spacer
    SettingsGui.Add("Text", "YS w150 Right Section", "Font Size:")
    SettingsGui.Add("Text", "w100 YS Right Section", "")
    OverlayFont := IniRead(OverlayIni, "Size", "Font", 12)
    SettingsGui.SetFont("s11")
    Global FontEdit := SettingsGui.AddEdit("YS w100 Number Background" CurrentTheme[2])
    Global FontUpDown := SettingsGui.AddUpDown("Range1-255", OverlayFont)
    FontEdit.OnEvent("Change", FontEditChange)
    FontUpDown.OnEvent("Change", FontUpDownChange)

    ;Notification Settings Tab
    CurrentTab := NewTab(CurrentTab)
    SettingsGui.SetFont("s15 Bold c" CurrentTheme[2])
    SettingsGui.Add("Text", TabMaxW " Center" ,"Notification Settings")
    SettingsGui.AddText( TabMaxW " h1 Section Background" CurrentTheme[3])
    SettingsGui.SetFont("s12 Bold c" CurrentTheme[3])
    Headers := ["Enabled", "Notification Type", "Sound Settings", "Transparency Settings", "Additional Settings"]
    For Header in Headers
        {
            AddSection := "YS"
            HeaderWidth := 190
            If (A_Index = 1)
                {
                    AddSection := "Section"
                    HeaderWidth := 70
                }
            If (A_Index = 2)
                {
                    HeaderWidth := "150 Left"
                }
            SettingsGui.Add("Text", "R1 Center w" HeaderWidth " " AddSection, Header)
        }
    SettingsGui.SetFont("s8 Norm c" CurrentTheme[2])
    For Header in Headers
        {
            AddSection := "YS"
            If (Header = "Notification Type")
                {
                    AddSection := "XS Section"
                    SettingsGui.Add("Text", "R1 w240 " AddSection,)
                }
            Else If (Header = "Sound Settings")
                {
                    SettingsGui.Add("Text", "R1 " AddSection, "Active")
                    SettingsGui.Add("Text", "R1 x+15.5 " AddSection, "Sound")
                    SettingsGui.Add("Text", "R1 " AddSection, "Test")
                    SettingsGui.Add("Text", "R1 " AddSection, "Volume")  
                }
            Else If (Header = "Transparency Settings")
                {
                    SettingsGui.Add("Text", "R1 x+66 " AddSection, "Test")
                    SettingsGui.Add("Text", "R1 " AddSection, "Close")
                    SettingsGui.SetFont("s8 Underline c" CurrentTheme[2])
                    SettingsGui.Add("Text", "R1 Section " AddSection, "Opactiy").OnEvent("Click", ExplainNote.Bind("Opacity"))
                    SettingsGui.SetFont("s8 Norm c" CurrentTheme[2])
                    SettingsGui.Add("Text", "R1 XS", "(0-255)")
                }
            Else
                {
                    SettingsGui.Add("Text", "R1 w190 " AddSection,)
                }
        }
    SettingsGui.SetFont("s12 Bold c" CurrentTheme[3])
    NotificationTypes := ["Overlay", "Quick Notification", "Mechanic Notification", "Custom Reminder", "Influence Notification", "Maven Notification"]
    SettingsGui.SetFont("s10 Norm c" CurrentTheme[3])
    PlayIcon := ImagePath("Play Button", "No") ; get play icon
    VolumeIcon := ImagePath("Volume Button", "No") ; get volume icon
    For Header in NotificationTypes
        {
            NotificationIni := IniPath("Notifications")
            DefaultStatus := [3, 1, 1, 0, 1, 1]
            CheckStatus := IniRead(NotificationIni, Header, "Active", DefaultStatus[A_Index])
            If (Header = "Overlay")
                {
                    CheckStatus := "3 Check3 Disabled"
                }
            SettingsGui.Add("Checkbox", "XS x200 w45 Section Center Checked" CheckStatus).OnEvent("Click", EnableCheck.Bind(Header)) ; add Enabled checkbox
            SettingsGui.Add("Text", "w155 YS Left", Header) ; add header
            If (Header = "Overlay")
                {
                    SettingsGui.Add("Text", "YS X+146",) ; add spacer
                }
            If !(Header = "Overlay")
                {
                    CheckStatus := IniRead(NotificationIni, Header, "Sound Active", 0)
                    SettingsGui.Add("Checkbox", "YS w30 Center Checked" CheckStatus).OnEvent("Click", SoundCheck.Bind(Header)) ; add sound checkbox
                    SettingsGui.Add("Picture", "Checked1 YS w-1 h22", VolumeIcon).OnEvent("Click", SoundAction.Bind(Header, "Sound")) ; add volume icon
                    SettingsGui.Add("Picture", "w-1 h20 YS Center ", PlayIcon).OnEvent("Click", SoundAction.Bind(Header, "Test")) ; Add Sound Play Icon
                    SettingsGui.Add("Edit", "Center w50 YS Background" CurrentTheme[2]).OnEvent("Change", VolumeAdjust.Bind(Header)) ;add edit box
                    CurrentVolume := IniRead(NotificationIni, Header, "Volume", 100)
                    SettingsGui.Add("UpDown", "Center YS Range0-100", CurrentVolume) ; add up/down
                }
            SettingsGui.Add("Text", "w85 ") ; add spacer
            SettingsGui.Add("Picture", "w-1 h20 YS Center ", PlayIcon).OnEvent("Click", TestGui.Bind(Header, "Test")) ; Add Transparency Play Icon
            StopIcon := ImagePath("Stop Button", "No") ; get stop icon
            SettingsGui.Add("Picture", "w-1 h20 YS Center x+25 ", StopIcon).OnEvent("Click", TestGui.Bind(Header, "Destroy")) ; Add Transparency Play Icon
            SettingsGui.Add("Edit", "Center w50 YS Background" CurrentTheme[2]).OnEvent("Change", TransparencyAdjust.Bind(Header)) ;add transparency edit box
            CurrentOpacity := IniRead(NotificationIni, Header, "Transparency", 255)
            If (Header = "Overlay")
            {
                CurrentOpacity := IniPath("Overlay", "Read", , "Transparency", "Transparency", 255)
            }
            SettingsGui.Add("UpDown", "Center YS Range0-255", CurrentOpacity) ; add up/down
            If (Header = "Overlay")
                {
                    SettingsGui.Add("Text", "Center YS w45")
                    SettingsGui.Add("Button", "Center YS w50", "Move").OnEvent("Click", MoveOverlay)
                    SettingsGui.Add("Button", "Center YS w50", "Layout").OnEvent("Click", SwitchTab.Bind(3, GuiTabs))
                }
            If (Header = "Quick Notification")
                {
                    SettingsGui.Add("Text", "Center YS w45")
                    SettingsGui.Add("Button", "Center YS w50", "Move").OnEvent("Click", MoveQuick)
                    SettingsGui.SetFont("s8 Norm c" CurrentTheme[3])
                    SettingsGui.Add("Text", "Center YS-15 Section", "Duration (Seconds)")
                    SettingsGui.SetFont("s10 Norm c" CurrentTheme[3])
                    SettingsGui.Add("Edit", "Center w50 XS+15 YP+18 Background" CurrentTheme[2]).OnEvent("Change", QuickDurationChange) ;add transparency edit box
                    QuickDuration := IniRead(NotificationIni, Header, "Duration", 3)
                    SettingsGui.Add("UpDown", "Center YS Range0-255", QuickDuration) ; add up/down
                    SettingsGui.Add("Text", "Center XS w85") ; extra space between lines
                }
            If (Header = "Mechanic Notification")
                {
                    SettingsGui.SetFont("s8 Bold Underline c" CurrentTheme[3])
                    SettingsGui.Add("Text", "Center YS-15 w100 Section", "Triggers").OnEvent("Click", ExplainNote.Bind("Triggers"))
                    HideoutTrigger := IniRead(NotificationIni, Header, "Hideout Trigger", 1)
                    SettingsGui.Add("Checkbox","XS+15 YP+18 Checked" HideoutTrigger).OnEvent("Click", MechanicChecks.Bind("Hideout Trigger"))
                    SettingsGui.SetFont("s8 Norm c" CurrentTheme[3])
                    SettingsGui.Add("Text", "Center XS+2 YP+18", "Hideout")

                    HotkeyTrigger := IniRead(NotificationIni, Header, "Hotkey Trigger", 0)
                    SettingsGui.Add("Checkbox","YS+19 x+30 Checked" HotkeyTrigger).OnEvent("Click", MechanicChecks.Bind("Hotkey Trigger"))
                    SettingsGui.SetFont("s8 Norm c" CurrentTheme[3])
                    SettingsGui.Add("Text", "Center XP-9 YP+18 Section", "Hotkey")
                    SettingsGui.SetFont("s8 Bold Underline c" CurrentTheme[3])
                    SettingsGui.Add("Text", "YS-35 w120 Section", "Quick Notification").OnEvent("Click", ExplainNote.Bind("Quick"))
                    QuickStatus := IniRead(NotificationIni, Header, "Use Quick", 0)
                    SettingsGui.Add("Checkbox","XS+45 YP+18 Checked" QuickStatus).OnEvent("Click", MechanicChecks.Bind("Use Quick"))

                    SettingsGui.Add("Text", "YS w100 Section", "Chat Delay").OnEvent("Click", ExplainNote.Bind("Delay"))
                    SettingsGui.SetFont("s10 Norm c" CurrentTheme[3])
                    SettingsGui.Add("Edit", "Center w50 XS+5 YP+18 Background" CurrentTheme[2]).OnEvent("Change", ChatDelayUpdate) ;add transparency edit box
                    ChatDelay := IniRead(NotificationIni, Header, "Chat Delay", 0)
                    SettingsGui.Add("UpDown", "Center YS Range0-100", ChatDelay) ; add up/down
                    SettingsGui.Add("Text", "Center XS w85") ; extra space between lines
                }
            If (Header = "Custom Reminder")
                {
                    SettingsGui.Add("Text", "Center YS w85")
                    SettingsGui.Add("Button", "YS","Configure").OnEvent("Click", SwitchTab.Bind(11, GuiTabs))
                }
        }

    ;Set Hideout Tab
    CurrentTab := NewTab(CurrentTab)
    SettingsGui.SetFont("s15 Bold c" CurrentTheme[2])
    SettingsGui.Add("Text", TabMaxW " Center" ,"Update Hideout")
    SettingsGui.AddText( TabMaxW " h1 Section Background" CurrentTheme[3])
    SettingsGui.SetFont("s11 Norm c" CurrentTheme[3])
    SettingsGui.Add("Link", TabMaxW ' Center', "Find and select the name of your hideout from the list above, the list can be filtered using the `"Search`" box. Double Click an option from the list to select a hideout. If your hideout is not available in the list simply type the full name of your hideout into the `"Search`" box and press `"Enter`" to help the community you may also consider letting me know it's missing by leaving a comment in the latest discussion thread found <a href=`"https://github.com/sushibagel/PoE-Mechanic-Watch/discussions`">here.</a>")
    SettingsGui.SetFont("s10 Norm")
    HideoutPath := IniPath("HideoutList")
    HideoutFile := FileRead(HideoutPath)
    HideoutIni := IniPath("Hideout")
    CurrentHideout := IniRead(HideoutIni, "Current Hideout", "Hideout", "")
    SearchEdit := SettingsGui.Add("Edit", "vEditText w250 XS x500 Background" CurrentTheme[2], CurrentHideout)
    SearchEdit.OnEvent("Change", FilterSearch)
    SearchEdit.OnEvent("Focus", EditFocused)
    SearchEdit.OnEvent("LoseFocus", EditUnFocused)
    Global LV := SettingsGui.Add("ListView","Sort Grid w250 r18 Background" CurrentTheme[2], ["Name"])
    Loop Parse HideoutFile, "`n"
        {
            LV.Add(,A_LoopField)
        }
    LV.ModifyCol(1, "230")
    GridTheme := CurrentTheme[3]
    If RegExMatch(CurrentTheme[3], "i)(?=.*[0-9])(?=.*\d)")
        {
            GridTheme := "0x" CurrentTheme[3]
        }
    LV_GridColor(LV, GridTheme)  
    LV.OnEvent("DoubleClick", LVDoubleClick)
    SettingsGui.SetFont("s13 Bold c" CurrentTheme[3])
    SettingsGui.Add("Text", TabMaxW " x200 y+5 Center vHideoutName" ,"Current Hideout: " CurrentHideout)

    ;Theme Tab
    CurrentTab := NewTab(CurrentTab)
    SettingsGui.SetFont("s15 Bold c" CurrentTheme[2])
    SettingsGui.Add("Text", TabMaxW " Center" ,"Select Theme")
    SettingsGui.AddText( TabMaxW " h1 Section Background" CurrentTheme[3])
    SettingsGui.SetFont("s11 Norm c" CurrentTheme[3])

    SettingsGui.Add("Button","Section XS x425" , "Dark Theme").OnEvent("Click", RefreshTheme.Bind("Dark", SettingsGui))
    SettingsGui.Add("Button","YS" , "Light Theme").OnEvent("Click", RefreshTheme.Bind("Light", SettingsGui))
    SettingsGui.Add("Button","YS" , "Custom Theme").OnEvent("Click", RefreshTheme.Bind("Custom", SettingsGui))

    BackgroundColor := ""
    SecondaryColor := ""
    FontColor := ""

    GuiOptions := ["Background", "Secondary", "Font"]
    For Option in GuiOptions
        {
            VariableVal := Option "Color"
            SettingsGui.Add("Text", "w150 Right x375 y+10 Section", Option " Color:")
            SettingsGui.Add("Text", "w100 YS Right Section", "")
            If (Option = "Font")
                {
                    SettingsGui.SetFont("c" CurrentTheme[2])
                }
            %VariableVal% := SettingsGui.Add("Edit", "w100 Center YS Background" CurrentTheme[A_Index], CurrentTheme[A_Index])
            %VariableVal%.OnEvent("Change", %Option%ColorSet)   
        }

    SettingsGui.SetFont("c" CurrentTheme[3])
    IconOptions := ["Black", "White"]
    IconSelectColor1 := "" 
    IconSelectColor2 := ""
    For Color in IconOptions
        {
            AddSection := ""
            If (A_Index = 1)
                {
                    AddSection := "Section"
                }
            SettingsGui.Add("Text", "w150 Right y+10 x375 " AddSection, "Icon Color " Color ":")
            SettingsGui.Add("Text", "w120 Right YP", A_Space)
            MoveIcon := "Resources\Images\Move " Color ".png"
            SettingsGui.Add("Picture", "YP w-1 h25 Background" CurrentTheme[2], MoveIcon)
        }
    
    For Color in IconOptions
        {
            isChecked := ""
            If (Color = CurrentTheme[4])
                {
                    isChecked := "Checked"
                }
            PlacementMode := "YS"
            If (A_Index = 2)
                {
                    PlacementMode := "XP"
                }
            IconSelectColor%A_Index% := SettingsGui.Add("Radio", PlacementMode " " isChecked, Color)
            IconSelectColor%A_Index%.OnEvent("Click", ToggleIcon.Bind(A_Index)) 
        }

    SettingsGui.AddText( TabMaxW " XS x175 h1 Section Background" CurrentTheme[3])
    SettingsGui.Add("Link", TabMaxW " Center", 'Use the buttons above to apply the specified theme. To set custom colors type your desired colors in the various boxes and press the `"Custom Theme`" button. Please note changing the values above ONLY changes the `"Custom Theme`" the Dark and Light themes don`'t support customization. Color can be specified by name or with a 6-digit hex color code (Note: Do not include "#" in your hex code). A list of color names can be found <a href="https://www.autohotkey.com/docs/v2/misc/Colors.htm">here.</a> Google also has a great color picker that can be found <a href="https://g.co/kgs/yV1scj8">here.</a>')

    ;Hotkey Tab
    CurrentTab := NewTab(CurrentTab)
    SettingsGui.SetFont("s15 Bold c" CurrentTheme[2])
    SettingsGui.Add("Text", TabMaxW " Center" ,"Hotkey Settings")
    SettingsGui.AddText( TabMaxW " h1 Section Background" CurrentTheme[3]) ;Divider
    SettingsGui.SetFont("s10 Norm c" CurrentTheme[2])
    SettingsGui.Add("Text", TabMaxW " Center", "To setup a hotkey simply click each input box and press your desired hotkey combination. To use the `"Windows Key`" as part of your hotkey combination simply check the box next designated input box. `"Backspace`" will remove/unset any entered hotkey combinations.")
    SettingsGui.SetFont("s10 Norm c" CurrentTheme[3])
    SettingsGui.Add("Text", "w175 Section",) ;Spacer
    SettingsGui.Add("Text", "w270 YS", "Hotkey Items")
    SettingsGui.Add("Text", "YS w100", "Use Win Key")
    SettingsGui.Add("Text", "YS", "Hotkey(s)")
    HotkeyItems := GetHotkeyItems()
    For Item in HotkeyItems
        {
            SetHotkeyItems(Item, SettingsGui)
        }
    Mechanics := VariableStore("Mechanics")
    For Mechanic in Mechanics
        {
            SetHotkeyItems(Mechanic, SettingsGui)
        }


    ;Launcher Tab
    CurrentTab := NewTab(CurrentTab)
    SettingsGui.SetFont("s15 Bold c" CurrentTheme[2])
    SettingsGui.Add("Text", TabMaxW " Center" ,"Launcher Settings")
    SettingsGui.AddText( TabMaxW " h2 Section Background" CurrentTheme[3]) ;Thick divider
    SettingsGui.SetFont("s11 Norm c" CurrentTheme[3])
    Headers := ["Auto Launch", "Tool Name", "Remove", "Launch"]
    HeaderFootNotes := ["1","2","3","4"]
    SectionWidths := ["w105", "w85","w30","w30"]
    SettingsGui.SetFont("s12 Bold c" CurrentTheme[3])
    For Header in Headers
        {
            GuiOptions := "YS"
            If (A_Index = 1)
                {
                    GuiOptions := "XS Section"
                }
            If (A_Index = 3)
                {
                    GuiOptions := "YS Right"
                }
            If (A_Index = 4)
                {
                    GuiOptions := "YS Center"
                }
            SettingsGui.Add("Text", GuiOptions " " SectionWidths[A_Index], Header)
            SettingsGui.SetFont("s8 Norm Underline c" CurrentTheme[2])
            SettingsGui.Add("Text", "x+1 Left", HeaderFootNotes[A_Index]).OnEvent("Click",LaunchFootnoteShow.Bind(HeaderFootNotes[A_Index]))
            If (A_Index = 2)
                {
                    SettingsGui.Add("Text", "w250 YS",)
                }
            Else
                {
                    SettingsGui.Add("Text", "w50 YS",)
                }
            SettingsGui.SetFont("s12 Norm Bold c" CurrentTheme[3])
        }
    SettingsGui.SetFont("s10 Norm c" CurrentTheme[3])    
    LaunchIni := IniPath("Launch")
    If FileExist(LaunchIni)
    {
        FileData := FileRead(LaunchIni)
    }
    Checktotal := Array()
    If IsSet(FileData) and InStr(FileData, "Tool Path")
        {
            CheckTotal := IniRead(LaunchIni, "Tool Path")
            CheckTotal := StrSplit(CheckTotal, "`n")
        }
    CloseButton := ImagePath("Close Button", "No")
    PlayButton := ImagePath("Play Button", "No")

    Loop CheckTotal.Length
        {
            LaunchOption := IniRead(LaunchIni, "Tool Launch", A_Index)
            ToolName := IniRead(LaunchIni, "Tool Name", A_Index)
            SettingsGui.Add("Text", "XS Section",) ;Spacer
            SettingsGui.Add("Checkbox", "YS Checked" LaunchOption).OnEvent("Click",ToggleLaunch.Bind(A_Index))
            SettingsGui.Add("Text", "YS w100",) ;Spacer
            SettingsGui.Add("Text", "w370 YS", ToolName).OnEvent("Click",TooltipPath.Bind(A_Index))
            SettingsGui.Add("Picture", "x+40 w15 h-1", CloseButton).OnEvent("Click", RemoveTool.Bind(A_Index))
            SettingsGui.Add("Text", "w100 YS",) ;Spacer
            SettingsGui.Add("Picture", "YS w15 h-1", PlayButton).OnEvent("Click", LaunchTool.Bind(A_Index))
            SettingsGui.Add("Text", "w20 YS",) ;Spacer
            If !(A_Index = CheckTotal.Length)
            {
                SettingsGui.AddText( TabMaxW " h1 XS Section Background" CurrentTheme[3]) ; Divider
            }
        }
    SettingsGui.AddText( TabMaxW " h2 XS Background" CurrentTheme[3]) ; Thick divider
    SettingsGui.SetFont("s12 Norm Bold c" CurrentTheme[3]) 
    SettingsGui.Add("Text", "XS w424 Right", "Add Tool")
    SettingsGui.SetFont("s7 Norm Underline c" CurrentTheme[2])
    SettingsGui.Add("Text", "x+1 Left w200", 5).OnEvent("Click",LaunchFootnoteShow.Bind(5))
    SettingsGui.SetFont("s10 Norm c" CurrentTheme[3])
    SettingsGui.Add("Text", "XS Section", "Name:")
    Global NewName := SettingsGui.Add("Edit", "w650 YS Background" CurrentTheme[2])
    SettingsGui.Add("Text", "YS", "Auto Launch:")
    Global NewCheck := SettingsGui.Add("Checkbox", "YS")
    SettingsGui.Add("Text", "XS Section", "URL/Location:")
    Global NewLocation := SettingsGui.Add("Edit", "w605 YS Background" CurrentTheme[2])
    SettingsGui.Add("Button", "YS", "Add Tool").OnEvent("Click", SelectTool)

    ;Settings Tab
    CurrentTab := NewTab(CurrentTab)
    SettingsGui.SetFont("s15 Bold c" CurrentTheme[2])
    SettingsGui.Add("Text", TabMaxW " Center" ,"Settings Storage Location")
    SettingsGui.AddText( TabMaxW " h1 Section Background" CurrentTheme[3])
    SettingsGui.SetFont("s12 Norm c" CurrentTheme[3])
    ExplainTool := "This tool will allow you to choose a location for user specific settings to be stored. This is useful if you have multiple computers and want to sync your settings with Dropbox. Note: Calibration images are not moved."
    SettingsGui.Add("Text", TabMaxW " XS Center", ExplainTool)
    SettingsGui.Add("Text", "XS Right w180 Section", "Current Location:")
    StorageIni := IniPath("Storage")
    CurrentLocation := IniRead(StorageIni, "Settings Location", "Location", A_ScriptDir)
    If (CurrentLocation = "A_ScriptDir")
        {
            CurrentLocation := A_ScriptDir
        }
    SettingsGui.Add("Edit", "YS vSettingsEdit w450 Background" CurrentTheme[2], CurrentLocation)
    SettingsGui.Add("Button", "YS", "Select Location").OnEvent("Click", GetLocation.Bind(SettingsGui, GuiTabs))

    ;About Tab
    CurrentTab := NewTab(CurrentTab)
    SettingsGui.SetFont("s15 Bold c" CurrentTheme[2])
    SettingsGui.Add("Text", TabMaxW " Center" ,"About")
    SettingsGui.AddText( TabMaxW " h1 Section Background" CurrentTheme[3])
    SettingsGui.SetFont("s11 Norm c" CurrentTheme[3])
    SettingsGui.Add("Text", "XS Section w250") ;Spacer          
    SettingsGui.Add("Text", "YS", "Version:")
    VersionPath := IniPath("Version")
    FileContent := Fileread(VersionPath)
    FileData := Array()
    Loop Parse, FileContent, "`n", "`r"
        FileData.Push A_LoopField
    SettingsGui.SetFont("c" CurrentTheme[2])
    SettingsGui.Add("Text", "YS x+1 w150", FileData[1])
    SettingsGui.SetFont("c" CurrentTheme[3])
    SettingsGui.Add("Text", "YS", "Release Date:")
    SettingsGui.SetFont("c" CurrentTheme[2])
    SettingsGui.Add("Text", "YS x+1", FileData[2])
    SettingsGui.SetFont("c" CurrentTheme[3])
    SettingsGui.Add("Text", "XS Section w235") ;Spacer 
    Global CheckButton := SettingsGui.Add("Button", "YS w150 ", "Check For Updates").OnEvent("Click", UpdateCheck)
    SettingsGui.Add("Text","YS w50")
    SettingsGui.Add("Button", "YS W150", "Changelog").OnEvent("Click", SwitchTab.Bind(13, GuiTabs))
    SettingsGui.Add("Text", "XS Section w100") ;Spacer 
    SettingsGui.Add("Link", TabMaxW " YS Center +Wrap", "To view previous versions and release information visit <a href=`"https://github.com/sushibagel/PoE-Mechanic-Watch/releases`">here.</a> For feedback and questions visit <a href=`"https://github.com/sushibagel/PoE-Mechanic-Watch/discussions`">here.</a>")

    ;Custom Notification
    CurrentTab := NewTab(CurrentTab)
    SettingsGui.SetFont("s15 Bold c" CurrentTheme[2])
    SettingsGui.Add("Text", TabMaxW " Center" ,"Custom Notification")
    SettingsGui.AddText( TabMaxW " h1 Section Background" CurrentTheme[3])
    SettingsGui.SetFont("s11 Norm c" CurrentTheme[3])
    CurrentMessage := IniRead(NotificationIni, "Custom Reminder", "Message", "Don't forget to activate your buffs!")
    SettingsGui.Add("Text", TabMaxW " Center", "The Custom Reminder allows you to setup a custom message to be displayed when you enter a map. The reminder can be set as a permanent reminder that would need to be dismissed or a timed `"Quick`" reminder.")
    SettingsGui.SetFont("s12")
    SettingsGui.Add("Text", "w400 Right Section", "Set Reminder:")
    SettingsGui.Add("Edit", "w350 YS R1 Background" CurrentTheme[2], CurrentMessage).OnEvent("Change", CustomEditUpdate.Bind("Message"))
    SettingsGui.Add("Text", "XS x400 Section", "Reminder Type:")
    QuickActive := IniRead(NotificationIni, "Custom Reminder", "Use Quick", 1)
    PermanentActive := 1
    If (QuickActive = 1)
        {
            PermanentActive := 0
        }
    SettingsGui.Add("Radio", "YS Checked" QuickActive, "Quick").OnEvent("Click", ToggleType.Bind("Quick"))
    SettingsGui.Add("Radio", "YS Checked" PermanentActive, "Permanent").OnEvent("Click", ToggleType.Bind("Permanent"))
    SettingsGui.Add("Text", "YS", "Test:")
    PlayIcon := ImagePath("Play Button", "No")
    SettingsGui.Add("Picture", "w-1 h20 YS Center ", PlayIcon).OnEvent("Click", TestGui.Bind("Custom Reminder", "Test"))
    SettingsGui.AddText( TabMaxW " XS x170 h1 Section Background" CurrentTheme[3])
    SettingsGui.SetFont("s12 Bold c" CurrentTheme[3])
    SettingsGui.Add("Text", TabMaxW " XS Center", "Quick Reminder Settings")
    SettingsGui.SetFont("s10 Norm")
    SettingsGui.Add("Button", "XS Section x470", "Move").OnEvent("Click", MoveCustom.Bind("Custom"))
    SettingsGui.Add("Text", "YS w100")
    CurrentDuration := IniRead(NotificationIni, "Custom Reminder", "Duration", 3)
    SettingsGui.Add("Edit", "YS R1 w50 Center Background" CurrentTheme[2], CurrentDuration).OnEvent("Change", CustomEditUpdate.Bind("Duration"))
    SettingsGui.Add("UpDown",,CurrentDuration)
    SettingsGui.Add("Text", "XS Section x585")
    SettingsGui.Add("Text", "YS Right", "Duration (Seconds)")

    ;Search Calibration
    CurrentTab := NewTab(CurrentTab)
    SettingsGui.SetFont("s15 Bold c" CurrentTheme[2])
    SettingsGui.Add("Text", TabMaxW " Center" ,"Auto Tracking Calibration")
    SettingsGui.AddText( TabMaxW " h1 Section Background" CurrentTheme[3])
    SettingsGui.SetFont("s12 Norm c" CurrentTheme[3])
    LoopCategories := ["Quest Tracker Text", "Ritual Icon", "Ritual Text", "Ritual Shop", "Influence Count"]
    LoopFootnote := ["1", "2", "1", "2", "3"]
    For Category in LoopCategories
        {
            SettingsGui.Add("Text", "Section XS Right w170") ; Spacer
            SettingsGui.Add("Text", "YS Right w140", Category)
            SettingsGui.SetFont("s8 Underline c" CurrentTheme[2])
            SettingsGui.Add("Text", " x+.8", LoopFootnote[A_Index]).OnEvent("Click",FootnoteShow.Bind(LoopFootnote[A_Index]))
            SettingsGui.SetFont("s12 Norm c" CurrentTheme[3])
            SettingsGui.Add("Text", "YS w120",) ;For consistent Spacing
            SettingsGui.Add("Button", "YS", "Calibrate").OnEvent("Click", CalibrateMechanic.Bind(Category))
            SettingsGui.Add("Button", "YS", "Sample").OnEvent("Click", SampleMechanic.Bind(Category, SettingsGui))
        }
    Influences := VariableStore("Influences")
    TextWidth := ["w36", "w50", "w48"]
    SpacerWidth := ["w154", "w136", "w143"]
    SpacerWidth2 := ["w219", "w201", "w207"]
    MechanicsIni := IniPath("Mechanics")
    Global SearingValue := ""
    Global EaterValue := ""
    Global MavenValue := ""
    For Influence in Influences
        {
            SettingsGui.Add("Text", "Section XS Right w170") ; Spacer
            SettingsGui.Add("Text", "YS Right w140", Influence " Completion")
            SettingsGui.SetFont("s8 Underline c" CurrentTheme[2])
            Footnote := 4
            UpDownRange := "Range0-28"
            If (Influence = "Maven")
                {
                    Footnote := 6
                    UpDownRange := "Range0-10"
                }
            SettingsGui.Add("Text", " x+.8", Footnote).OnEvent("Click",FootnoteShow.Bind(Footnote))
            SettingsGui.SetFont("s12 Norm c" CurrentTheme[3])
            SettingsGui.Add("Text", "YS w62",) ;For consistent Spacing
            CurrentCount := IniRead(MechanicsIni, "Influence Track", Influence, 0)
            SettingsGui.Add("Edit", "YS+5 w40 h25 Number Center Background" CurrentTheme[2], "Calibrate")
            %Influence%Value := SettingsGui.Add("UpDown", "YS " UpDownRange, CurrentCount) ;### Needs event Handler
            SettingsGui.Add("Button", "YS", "Calibrate").OnEvent("Click", CalibrateMechanic.Bind(Influence " Completion"))
            SettingsGui.Add("Button", "YS", "Sample").OnEvent("Click", SampleMechanic.Bind(Influence " Completion", SettingsGui))

            SettingsGui.Add("Text", "Section XS Right w170") ; Spacer
            SettingsGui.Add("Text", "YS Right w140", Influence " On")
            SettingsGui.SetFont("s8 Underline c" CurrentTheme[2])
            SettingsGui.Add("Text", " x+.8", "5").OnEvent("Click",FootnoteShow.Bind("5"))
            SettingsGui.SetFont("s12 Norm c" CurrentTheme[3])
            SettingsGui.Add("Text", "YS w120",) ;For consistent Spacing
            SettingsGui.Add("Button", "YS", "Calibrate").OnEvent("Click", CalibrateMechanic.Bind(Influence " On"))
            SettingsGui.Add("Button", "YS", "Sample").OnEvent("Click", SampleMechanic.Bind(Influence " On", SettingsGui))
        }

    ;Changelog Tab
    CurrentTab := NewTab(CurrentTab)
    SettingsGui.SetFont("s15 Bold c" CurrentTheme[2])
    SettingsGui.Add("Text", TabMaxW " Center" ,"Changelog")
    SettingsGui.AddText( TabMaxW " h1 Section Background" CurrentTheme[3])
    SettingsGui.SetFont("s12 Norm c" CurrentTheme[3])
    ChangelogPath := IniPath("Changelog")
    ChangelogData := FileRead(ChangelogPath)
    SettingsGui.SetFont("s10 Norm c" CurrentTheme[2])
    SettingsGui.Add("Link", "w1000 +Wrap", "For more information, questions or feedback on this release please see the current release discussion thread on my Github <a href=`"https://github.com/sushibagel/PoE-Mechanic-Watch/discussions`">here</a>.")
    SettingsGui.SetFont("c" CurrentTheme[3])
    SettingsGui.Add("Text", "XS +Wrap " TabMaxW, ChangelogData)

    ;Update Tab
    CurrentTab := NewTab(CurrentTab)
    SettingsGui.SetFont("s15 Bold c" CurrentTheme[2])
    SettingsGui.Add("Text", TabMaxW " Center" ,"Update Available")
    SettingsGui.AddText( TabMaxW " h1 Section Background" CurrentTheme[3])
    SettingsGui.SetFont("s12 Norm c" CurrentTheme[3])
    ; Get Version Info
    VersionURL := "https://raw.githubusercontent.com/sushibagel/PoE-Mechanic-Watch/main/Resources/Data/Version.txt"
    CurrentVersion := GetContent(VersionURL)
    CurrentVersion := Trim(CurrentVersion, "`n `t") ; Trim and clean
    CurrentVersion := StrSplit(CurrentVersion, "v")
    UpdateUrl := "https://github.com/sushibagel/PoE-Mechanic-Watch/archive/refs/tags/v" CurrentVersion[2] ".zip"
    ChangelogURL := "https://raw.githubusercontent.com/sushibagel/PoE-Mechanic-Watch/main/changelog.txt"
    ;Add gui data
    SettingsGui.SetFont("c" CurrentTheme[2])
    SettingsGui.Add("Link", TabMaxW " XS +Wrap", "To view previous versions and release information visit <a href=`"https://github.com/sushibagel/PoE-Mechanic-Watch/releases`">here.</a> For feedback and questions visit <a href=`"https://github.com/sushibagel/PoE-Mechanic-Watch/discussions`">here.</a>")
    SettingsGui.SetFont("c" CurrentTheme[3])
    Changelog := GetContent(ChangelogURL)
    SettingsGui.Add("Text", TabMaxW " +Wrap XS", Changelog)
    SettingsGui.Add("Text", "XS w150")
    SettingsGui.Add("Button", "XS w150", "Download").OnEvent("Click", DownloadUpdate.Bind(UpdateUrl, CurrentVersion[2]))

    ; Allow scrolling
    SettingsGui.OnEvent("Size", UpdateGui_Size) 
    OnMessage(0x0115, OnScroll) ; WM_VSCROLL
    OnMessage(0x0114, OnScroll) ; WM_HSCROLL
    OnMessage(0X020A, OnWheel)  ; WM_MOUSEWHEEL
    SettingsGui.Show("h750")
    SettingsGui.OnEvent("Close", SettingsToolDestroy)
}

/**
 * 
 * @param SettingsGui Pass gui variable here. 
 * @param {String} IgnoreCheck If "1" is passed here setup completion will not be checked when the Gui is closed. 
 */
SettingsToolDestroy(SettingsGui, IgnoreCheck:="")
    {
        If WinExist("Image Sample")
            {
                WinClose
            }
        If !(IgnoreCheck = 1)
        {
            CompletionCheck := CheckCompletion(SettingsGui)
        }
        Else
        {
            CompletionCheck := 0
        }
        SettingsGui.Destroy()
        If !(CompletionCheck = 0)
            {
                RefreshOverlay()
            }
    }

ChangeTab(TabName, ButtonInfo, *)
{
    GuiTabs.Choose(ButtonInfo.Text)
    SettingsTabs := GetTabNames()
    CurrentTheme := GetTheme()
    For Tab in SettingsTabs
    {
        If (A_Index < 11)
        SettingsGui[Tab].Opt("c" CurrentTheme[3])
    }
    SettingsGui[TabName].Opt("cRed")
}

SwitchTab(TabNumber, GuiTabs, *)
{
    GuiTabs.Choose(TabNumber)
    SettingsTabs := GetTabNames()
    CurrentTheme := GetTheme()
    For Tab in SettingsTabs
        {
            If (A_Index < 11)
            SettingsGui[Tab].Opt("c" CurrentTheme[3])
        }
        If (TabNumber < 11)
        {
            SettingsGui[SettingsTabs[TabNumber]].Opt("cRed")
        }
}

#HotIf WinActive('Settings')

Enter::
{
    CurrentHWND := ControlGetFocus("Settings")
    EditHWND := ControlGetHwnd(SettingsGui["EditText"])
    If (EditHWND = CurrentHWND)
    {
        HideoutText := SettingsGui["EditText"].Text
        IniWrite(HideoutText, HideoutIni, "Current Hideout", "Hideout")
        SettingsGui["HideoutName"].Text := "Current Hideout: " HideoutText
        SettingsGui["SetupHideout"].Text := "Current Hideout: " HideoutText
    }
}

#HotIf