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
    Msgbox "need to setup launch support tool. This launches additional stuff along with the game." 
}