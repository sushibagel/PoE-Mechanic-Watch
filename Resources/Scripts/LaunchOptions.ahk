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
    Try 
    {
        CheckTotal := IniRead(LaunchIni, "Tool Path")
    }
    Catch Error
    {

    }
    Else
    {
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
}

LaunchFootnoteShow(FootnoteNum, *)
{
    FootnoteMenu := Menu()
    If (FootnoteNum = 1)
        {
            FootnoteMenu.Add("If checked the associated tool will launch along side PoE when", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("you use the `"Launch Path of Exile`" option in the tray menu.", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    If (FootnoteNum = 2)
        {
            FootnoteMenu.Add("Click the name of each tool to view the Path/URL.", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("Clicking the popup will launch the tool.", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    If (FootnoteNum = 3)
        {
            FootnoteMenu.Add("Clicking the icons below will remove the corresponding tool", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("from the launcher options.", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    If (FootnoteNum = 4)
        {
            FootnoteMenu.Add("Clicking the icons below will launch/open the associated tool.", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    If (FootnoteNum = 5)
        {
            FootnoteMenu.Add("To add a new tool input the name of your new tool,", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("if the `"URL/Location`" is omitted a dialog will", DestroyFootnoteMenu.Bind(FootnoteMenu))
            FootnoteMenu.Add("pop-up to select a file/application.", DestroyFootnoteMenu.Bind(FootnoteMenu))
        }
    FootnoteMenu.Show()
}

TooltipPath(LauncherIndex, NA1, NA2)
{
    LaunchIni := IniPath("Launch")
    ToolName := IniRead(LaunchIni, "Tool Name", LauncherIndex)
    ToolPath := IniRead(LaunchIni, "Tool Path", LauncherIndex)
    FootnoteMenu := Menu()
    FootnoteMenu.Add(ToolName ": " ToolPath, LaunchTool.Bind(LauncherIndex))
    FootnoteMenu.Show()
}

DestroyLauncherPath(LaunchPath)
{
    If WinExist("Launcher Path")
        {
            LaunchPath.Destroy()
        }
    LaunchPath := Gui(,"Launcher Path")
    Return LaunchPath
}

RemoveTool(RemoveIndex, *)
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
    Settings(8)
}

LaunchTool(LaunchIndex, *)
{
    LaunchIni := IniPath("Launch")
    LaunchPath := IniRead(LaunchIni,"Tool Path", LaunchIndex)
    Run(LaunchPath)
}

ToggleLaunch(LaunchIndex, ToggleValue, *)
{
    LaunchIni := IniPath("Launch")
    IniWrite(ToggleValue.Value, LaunchIni, "Tool Launch", LaunchIndex)
}

SelectTool(SettingsGui, *)
{
    If (NewName.Value = "")
        {
            Msgbox "Error: Please Enter a name before selecting your tool."
        }
    If !(NewLocation.Value = "") and !(NewName.Value = "")
        {
            SettingsToolDestroy(SettingsGui, 1)
            LaunchIni := IniPath("Launch")
            CheckTotal := IniRead(LaunchIni, "Tool Path",,"") ;Check current number of launch tools
            CheckTotal := StrSplit(CheckTotal, "`n")
            IniWrite(NewLocation.Value, Launchini, "Tool Path", CheckTotal.Length + 1)
            IniWrite(NewName.Value, Launchini, "Tool Name", CheckTotal.Length + 1)
            IniWrite(NewCheck.Value, Launchini, "Tool Launch", CheckTotal.Length + 1)
            Settings(8)
        }
    If (NewLocation.Value = "") and !(NewName.Value = "")
        {
            LaunchPath := FileSelect("S 1", A_Desktop, "Please select the file you would like to add to your launch options.")
            If !(LaunchPath = "")
                {
                    LaunchIni := IniPath("Launch")
                    CheckTotal := IniRead(LaunchIni, "Tool Path",,"") ;Check current number of launch tools
                    CheckTotal := StrSplit(CheckTotal, "`n")
                    IniWrite(LaunchPath, Launchini, "Tool Path", CheckTotal.Length + 1)
                    IniWrite(NewName.Value, Launchini, "Tool Name", CheckTotal.Length + 1)
                    IniWrite(NewCheck.Value, Launchini, "Tool Launch", CheckTotal.Length + 1)
                    Settings(8)
                }
        }
}