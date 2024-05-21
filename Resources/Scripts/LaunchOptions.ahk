LaunchPoE(*)
{
    LaunchIni := IniPath("Launch")
    ExePath := IniRead(LaunchIni,"POE", "EXE")
    ExeDir := IniRead(LaunchIni, "POE", "Directory")
    SetWorkingDir(ExeDir)
    Run(ExeDir "\" ExePath)
    SetWorkingDir(A_ScriptDir)
    LaunchSupport()
}

LaunchSupport()
{
    LaunchIni := IniPath("Launch")
    CheckTotal := IniRead(LaunchIni, "Tool Path")
    CheckTotal := StrSplit(CheckTotal, "`n")
    Loop CheckTotal.Length
        {
            LaunchValue := IniRead(LaunchIni, "Tool Launch", A_Index, 0)
            If (LaunchValue = 1)
                {
                    LaunchPath := IniRead(LaunchIni, "Tool Path", A_Index)
                    Run LaunchPath
                }
        }
}

LauncherGui(*)
{
    ;This will combine both Launcher Guis and will instead just have a "Launch" with PoE Checkbox
    DestroyLauncherGui()
    CurrentTheme := GetTheme()
    LaunchGui.BackColor := CurrentTheme[1]
    LaunchGui.SetFont("s15 Bold c" CurrentTheme[3])
    LaunchGui.Add("Text", "w500 Center Section", "Launcher Settings")
    LaunchGui.AddText("w500 h1 Background" CurrentTheme[3])
    LaunchGui.SetFont("s10 Norm")
    Headers := ["Auto Launch", "Tool Name", "Remove", "Launch"]
    HeaderFootNotes := ["1","2","3","4"]
    SectionWidths := ["w100", "w85","w25","w25"]
    LaunchGui.SetFont("s12 Bold c" CurrentTheme[3])
    For Header in Headers
        {
            GuiOptions := "YS"
            If (A_Index = 1)
                {
                    GuiOptions := "XM Section"
                }
            If (A_Index = 3)
                {
                    GuiOptions := "YS Right"
                }
            If (A_Index = 4)
                {
                    GuiOptions := "YS Center"
                }
            LaunchGui.Add("Text", GuiOptions " " SectionWidths[A_Index], Header)
            LaunchGui.SetFont("s8 Norm Underline c" CurrentTheme[2])
            LaunchGui.Add("Text", "x+.8 Left", HeaderFootNotes[A_Index]).OnEvent("Click",LaunchFootnoteShow.Bind(HeaderFootNotes[A_Index]))
            If (A_Index = 2)
                {
                    LaunchGui.Add("Text", "w100 YS",)
                }
            LaunchGui.SetFont("s12 Norm Bold c" CurrentTheme[3])
        }
    LaunchGui.SetFont("s10 Norm c" CurrentTheme[3])    
    LaunchIni := IniPath("Launch")
    CheckTotal := IniRead(LaunchIni, "Tool Path")
    CheckTotal := StrSplit(CheckTotal, "`n")
    CloseButton := ImagePath("Close Button", "No")
    PlayButton := ImagePath("Play Button", "No")

    Loop CheckTotal.Length
        {
            LaunchOption := IniRead(LaunchIni, "Tool Launch", A_Index)
            ToolName := IniRead(LaunchIni, "Tool Name", A_Index)
            LaunchGui.Add("Checkbox", "Section XM x60 Checked" LaunchOption).OnEvent("Click",ToggleLaunch.Bind(A_Index))
            LaunchGui.Add("Text", "YS w15",) ;Spacer
            LaunchGui.Add("Text", "w205 YS", ToolName).OnEvent("Click",TooltipPath.Bind(A_Index))
            LaunchGui.Add("Picture", "x+40 w20 h-1", CloseButton).OnEvent("Click", RemoveTool.Bind(A_Index))
            LaunchGui.Add("Text", "w30 YS",)
            LaunchGui.Add("Picture", "YS w20 h-1", PlayButton).OnEvent("Click", LaunchTool.Bind(A_Index))
            LaunchGui.Add("Text", "w20 YS",)
        }
    LaunchGui.AddText("w500 h1 XM Background" CurrentTheme[3])
    LaunchGui.SetFont("s10 Norm Bold c" CurrentTheme[3]) 
    LaunchGui.Add("Text", "XM w250 Right", "Add Tool")

    LaunchGui.SetFont("s7 Norm Underline c" CurrentTheme[2])
    LaunchGui.Add("Text", "x+1 Left w200", 5).OnEvent("Click",LaunchFootnoteShow.Bind(5))

    LaunchGui.SetFont("s10 Norm c" CurrentTheme[3])
    LaunchGui.Add("Text", "XM Section", "Name:")
    Global NewName := LaunchGui.Add("Edit", "w300 YS Background" CurrentTheme[2])
    LaunchGui.Add("Text", "YS", "Auto Launch:")
    Global NewCheck := LaunchGui.Add("Checkbox", "YS")
    LaunchGui.Add("Text", "XM Section", "URL/Location:")
    Global NewLocation := LaunchGui.Add("Edit", "w300 YS Background" CurrentTheme[2])
    LaunchGui.Add("Button", "YS", "Add Tool").OnEvent("Click", SelectTool)
    LaunchGui.Show
    LaunchGui.OnEvent("Close", DestroyLauncherGui)
}

DestroyLauncherGui(*)
{
    DestroyLauncherPath()
    DestroyFootnote()
    If WinExist("Launcher Settings")
        {
            LaunchGui.Destroy()
        }
    Global LaunchGui := Gui(,"Launcher Settings")
}

LaunchFootnoteShow(FootnoteNum, NA1, NA2)
{
    TriggeredBy := "Launcher Settings"
    WinGetPos(&X, &Y, &W, &H, TriggeredBy)
    XPos := X + W
    YPos := Y
    If (FootnoteNum = 1)
        {
            GuiInfo := "If checked the associated tool will launch along side PoE when you use the `"Launch Path of Exile`" option in the tray menu."
        }
    If (FootnoteNum = 2)
        {
            GuiInfo := "Click the name of each tool to view the Path/URL."
        }
    If (FootnoteNum = 3)
        {
            GuiInfo := "Clicking the icons below will remove the corresponding tool from the launcher options."
        }
    If (FootnoteNum = 4)
        {
            GuiInfo := "Clicking the icons below will launch/open the associated tool."
        }
    If (FootnoteNum = 5)
        {
            GuiInfo := "To add a new tool input the name of your new tool, if the `"URL/Location`" is omitted a dialog will pop-up to select a file/application."
        }
    ActivateFootnoteGui(GuiInfo, XPos, YPos)
}

TooltipPath(LauncherIndex, NA1, NA2)
{
    LaunchIni := IniPath("Launch")
    ToolName := IniRead(LaunchIni, "Tool Name", LauncherIndex)
    ToolPath := IniRead(LaunchIni, "Tool Path", LauncherIndex)
    DestroyLauncherPath()
    CurrentTheme := GetTheme()
    LaunchPath.BackColor := CurrentTheme[1]
    LaunchPath.SetFont("s10 c" CurrentTheme[3])
    LaunchPath.Add("Text",, ToolName ": " ToolPath)
    WinGetPos(,&Y,,&H,"Launcher Settings")
    LaunchPath.Show("y" Y+H)
}

DestroyLauncherPath()
{
    If WinExist("Launcher Path")
        {
            LaunchPath.Destroy()
        }
    Global LaunchPath := Gui(,"Launcher Path")
}

RemoveTool(RemoveIndex, NA1, NA2)
{
    LaunchIni := IniPath("Launch")
    CheckTotal := IniRead(LaunchIni, "Tool Path") ;Check current number of launch tools
    CheckTotal := StrSplit(CheckTotal, "`n")
    If (RemoveIndex = CheckTotal.Length) ; If the one being removed is the last one just remove it. 
        {
            IniDelete(LaunchIni,"Tool Path", RemoveIndex)
            IniDelete(LaunchIni,"Tool Name", RemoveIndex)
            IniDelete(LaunchIni,"Tool Launch", RemoveIndex)
        }
    Else ; Rewrite everthing else and remove the last one. 
        {
            LoopTotal := CheckTotal.Length - RemoveIndex
            ReadIndex := RemoveIndex
            WriteIndex := RemoveIndex
            Loop LoopTotal
                {
                    ReadIndex++ 
                    Tools := ["Tool Path", "Tool Name", "Tool Launch"]
                    For Tool in Tools
                        {
                            NextValue := IniRead(LaunchIni, Tool, ReadIndex) ;;; read next value
                            IniWrite(NextValue, LaunchIni, Tool, WriteIndex) ;;; write it to the previous value
                        }
                    WriteIndex++
                }
            IniDelete(LaunchIni, "Tool Path", CheckTotal.Length)
            IniDelete(LaunchIni, "Tool Name", CheckTotal.Length)
            IniDelete(LaunchIni, "Tool Launch", CheckTotal.Length)

        }
    LauncherGui()
}

LaunchTool(LaunchIndex, NA1, NA2)
{
    LaunchIni := IniPath("Launch")
    LaunchPath := IniRead(LaunchIni,"Tool Path", LaunchIndex)
    Run(LaunchPath)
}

ToggleLaunch(LaunchIndex, ToggleValue, NA2)
{
    LaunchIni := IniPath("Launch")
    IniWrite(ToggleValue.Value, LaunchIni, "Tool Launch", LaunchIndex)
}

SelectTool(*)
{
    If (NewName.Value = "")
        {
            Msgbox "Error: Please Enter a name before selecting your tool."
        }
    If !(NewLocation.Value = "") and !(NewName.Value = "")
        {
            LaunchIni := IniPath("Launch")
            CheckTotal := IniRead(LaunchIni, "Tool Path") ;Check current number of launch tools
            CheckTotal := StrSplit(CheckTotal, "`n")
            IniWrite(NewLocation.Value, Launchini, "Tool Path", CheckTotal.Length + 1)
            IniWrite(NewName.Value, Launchini, "Tool Name", CheckTotal.Length + 1)
            IniWrite(NewCheck.Value, Launchini, "Tool Launch", CheckTotal.Length + 1)
            LauncherGui()
        }
    If (NewLocation.Value = "") and !(NewName.Value = "")
        {
            LaunchPath := FileSelect("S 1", A_Desktop, "Please select the file you would like to add to your launch options.")
            If !(LaunchPath = "")
                {
                    LaunchIni := IniPath("Launch")
                    CheckTotal := IniRead(LaunchIni, "Tool Path") ;Check current number of launch tools
                    CheckTotal := StrSplit(CheckTotal, "`n")
                    IniWrite(LaunchPath, Launchini, "Tool Path", CheckTotal.Length + 1)
                    IniWrite(NewName.Value, Launchini, "Tool Name", CheckTotal.Length + 1)
                    IniWrite(NewCheck.Value, Launchini, "Tool Launch", CheckTotal.Length + 1)
                    LauncherGui()
                }
        }
}
; ###add way to add new tools