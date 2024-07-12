SetupTool(*)
{
    If !DirExist("Resources/Settings") ; Check if Settins directory exists and create if it doesn't
        {
            DirCreate("Resources/Settings")
        }
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
            Setup.Add("Checkbox", "XM Section Checked" SetupCompletion).OnEvent("Click", LaunchEvent.Bind(SetupCategories[A_Index], Setup))
            Setup.Add("Text", "YS", SetupItems[A_Index]).OnEvent("Click", LaunchEvent.Bind(SetupCategories[A_Index], Setup))
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
    Setup.OnEvent("Close", CheckCompletion.Bind(Setup))
}

SetupToolDestroy(Setup)
    {
        Setup.Destroy()
    }

LaunchEvent(ItemIndex, Setup, *)
{
    If (ItemIndex = "Client")
        {
            SetupToolDestroy(Setup)
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
            SetupToolDestroy(Setup)
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
            SetupToolDestroy(Setup)
            Settings("Change Theme")
            WinWaitClose("Change Theme")
            SetupComplete(ItemIndex)
            SetupTool()
        }
    If (ItemIndex = "Select Mechanics")
        {
            SetupToolDestroy(Setup)
            MechanicsSelect()
            WinWaitClose("Mechanics")
            SetupComplete(ItemIndex)
            If WinActive("Calibration Tool")
                {
                    WinWaitClose("Calibration Tool")
                }
            SetupTool()
        }
    If (ItemIndex = "Quick Launch")
        {
            SetupToolDestroy(Setup)
            LauncherGui()
            WinWaitClose("Launcher Settings")
            SetupComplete(ItemIndex)
            SetupTool()
        }
    If (ItemIndex = "Storage Location")
        {
            SetupToolDestroy(Setup)
            SettingsLocation()
            WinWaitClose("Settings Storage Location")
            SetupComplete(ItemIndex)
            SetupTool()
        }
    If (ItemIndex = "Notification Settings")
        {
            SetupToolDestroy(Setup)
            NotificationSettings()
            WinWaitClose("Notification Settings")
            SetupComplete(ItemIndex)
            SetupTool()
        }
    If (ItemIndex = "Custom Reminder")
        {
            SetupToolDestroy(Setup)
            CustomNotificationSetup()
            WinWaitClose("Custom Reminder Setup")
            SetupComplete(ItemIndex)
            SetupTool()
        }
    If (ItemIndex = "Hotkeys")
        {
            SetupToolDestroy(Setup)
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

WarningYes(Setup)
{
    WarningGui.Destroy(Setup)
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

^#i:: Settings("Select Mechanics") 

Settings(TargetTab:="", *)
{
    Global SettingsGui := GuiTemplate("SettingsGui", "Settings", 1050)
    CurrentTheme := GetTheme()
    SettingsGui.SetFont("s12")
    If (TargetTab = "")
    {
        SettingsGui.SetFont("cRed")
    }
    Else If TargetTab = "Setup Tool"
    {
        TargetTab := 1
    }
    Else If TargetTab = "Select Mechanics"
    {
        TargetTab := 2
    }
    Else If TargetTab = "Set Hideout"
    {
        TargetTab := 3
    } 
    Else If TargetTab = "Change Theme"
    {
        TargetTab := 4
    } 
    SettingsTabs := GetTabs()
    SettingsTabName := GetTabNames()
    SettingsGui.Add("GroupBox", "Section x10 y125 r1 w130")
    SettingsGui.Add("Text", "XP+2 YP+25 w125 Center vSetupTab", "Setup").OnEvent("Click", ChangeTab.Bind("SetupTab"))
    SettingsGui.SetFont("s12 c" CurrentTheme[3])
    For Setting in SettingsTabs
    {
        If (A_Index > 1)
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

    ;Tab 1 Setup
    GuiTabs.UseTab(1)
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
            SettingsGui.Add("Checkbox", "XS Section Checked" SetupCompletion).OnEvent("Click", LaunchEvent.Bind(SetupCategories[A_Index], Setup))
            SettingsGui.Add("Text", "YS", SetupItems[A_Index]).OnEvent("Click", LaunchEvent.Bind(SetupCategories[A_Index], Setup))
            If (SetupCategories[A_Index] = "Set Hideout") and (SetupCompletion = 1)
                {
                    CurrentHideout := GetHideout()
                    SettingsGui.SetFont("Bold c" CurrentTheme[2])
                    SettingsGui.Add("Text", "YS w70", ) ;Add spacer
                    SettingsGui.Add("Text", "YS vSetupHideout", "Current Hideout: " CurrentHideout)
                    SettingsGui.SetFont("Norm c" CurrentTheme[3])
                }
        }

    ;Tab 2 Mechanics
    GuiTabs.UseTab(2)
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
            LayoutSet := "YP"
            If (A_Index = 1)
                {
                    LayoutSet := "Section XS x300"
                }
                SettingsGui.Add("Text", LayoutSet " Left " HeaderWidth, Title)
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
    SettingsGui.Add("Button", "XS-50 y+50", "Calibrate Search",).OnEvent("Click",CalibrateSearchButton.Bind(SettingsGui))

    ;Tab 3 Set Hideout
    GuiTabs.UseTab(3)
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
    Global LV := SettingsGui.Add("ListView","Sort Grid w250 r20 Background" CurrentTheme[2], ["Name"])
    Loop Parse HideoutFile, "`r"
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

    ;Tab 4 Theme Tab
    GuiTabs.UseTab(4)
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


    SettingsGui.Show("")
}

ChangeTab(TabName, ButtonInfo, *)
{
    GuiTabs.Choose(ButtonInfo.Text)
    SettingsTabs := GetTabNames()
    CurrentTheme := GetTheme()
    For Tab in SettingsTabs
    {
        SettingsGui[Tab].Opt("c" CurrentTheme[3])
    }
    SettingsGui[TabName].Opt("cRed")
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