Global IncursionGo
Global MyDialogs
Global MyDialogsDisable
Global FullSearch
Global IncursionCode
Global IncursionSleep
Global MyHideout
Global MavenSearch

LogMonitor() ;Monitor the PoE client.txt
{
    FileRead, ReadFile, Resources\Data\Incursiondialogsdisable.txt
    IncursionGo := StrReplace(ReadFile, "`r`n" , ",")

    MyHideout := GetHideout()
    ReadMechanics()
    ReadAutoMechanics()
    InfluenceActive()

    FullSearch =
    MyDialogs = 
    MyDialogsDisable =
    AutoMechanicSearch := AutoMechanics()
    For each, Mechanic in StrSplit(AutoMechanicSearch, "|")
    {
        autocheck = %Mechanic%Auto
        if (%autocheck% = 1)
        {
            Loop, Read, Resources/Data/%Mechanic%dialogs.txt
            {
                if (MyDialogs = "")
                {
                    MyDialogs = %A_LoopReadLine%
                }
                Else
                {
                    MyDialogs = %MyDialogs%,%A_LoopReadLine%
                }
            }
            Loop, Read, Resources/Data/%Mechanic%dialogsdisable.txt
            {
                if (MyDialogsDisable = "")
                {
                    MyDialogsDisable = %A_LoopReadLine%
                }
                Else
                {
                    MyDialogsDisable = %MyDialogsDisable%,%A_LoopReadLine%
                }
            }
        }
    }
    MavenFile := MavenTxt()
    IniRead, MavenSearch, %MavenFile%, Voice Lines
    MavenSearch := StrSplit(MavenSearch, ["=", "`n"])
    MavenSearch := MavenSearch[1]"," MavenSearch[3]"," MavenSearch[5]"," MavenSearch[7]"," MavenSearch[9]"," MavenSearch[11]"," MavenSearch[13]"," MavenSearch[15]"," MavenSearch[17]"," MavenSearch[19]"," MavenSearch[21]"," MavenSearch[23]"," MavenSearch[25]"," MavenSearch[27]"," MavenSearch[29]"," MavenSearch[31]"," MavenSearch[33]
    Return
}

SearchText(NewLine)
{
    MechanicsActive()
    LogMonitor()
    If NewLine contains %MyDialogs%
        {
            For each, Mechanic in StrSplit(AutoMechanicSearch, "|")
            Loop, Read, Resources/Data/%Mechanic%dialogs.txt
            {
                activecheck = %Mechanic%Active
                automechanic = %Mechanic%Auto
                If NewLine contains %A_LoopReadLine%
                {
                    If (%activecheck% != 1) and (%automechanic% = 1)
                    { ; This now activates the mechanic in the mechanics.ini and sends a message to the overlay script to refresh the overlay. 
                        IniPath := MechanicsIni()
                        IniWrite, 1, %IniPath%, Mechanic Active, %Mechanic%
                        Prev_DetectHiddenWindows := A_DetectHiddenWIndows
                        Prev_TitleMatchMode := A_TitleMatchMode
                        SetTitleMatchMode 2
                        DetectHiddenWindows On
                        PostMessage, 0x01111,,,, PoE Mechanic Watch.ahk - AutoHotkey
                        DetectHiddenWindows, %Prev_DetectHiddenWindows%
                        SetTitleMatchMode, %A_TitleMatchMode%
                        Break
                    }
                    If NewLine contains %IncursionGo%
                    {
                        VariablePath := VariableIni()
                        IniRead, IncursionCode, %VariablePath%, Incursion, Log Code, 0
                        IniRead, IncursionSleep, %VariablePath%, Incursion, Sleep Count, 0
                        GetLogCode := StrSplit(NewLine, A_Space)
                        Code = % GetLogCode[3]
                        If (Code = IncursionCode) and (Code != "")
                        {
                            Break
                        }
                        IniWrite, %Code%, %VariablePath%, Incursion, Log Code
                        IncursionSleep ++
                        IniWrite, %IncursionSleep%, %VariablePath%, Incursion, Sleep Count
                        If (IncursionSleep = 3)
                        {
                            IniPath := MechanicsIni()
                            IniWrite, 0, %VariablePath%, Incursion, Sleep Count
                            IniWrite, 0, %IniPath%, Mechanic Active, %Mechanic%
                            Prev_DetectHiddenWindows := A_DetectHiddenWIndows
                            Prev_TitleMatchMode := A_TitleMatchMode
                            SetTitleMatchMode 2
                            DetectHiddenWindows On
                            PostMessage, 0x01111,,,, PoE Mechanic Watch.ahk - AutoHotkey ;refresh overlay
                            PostMessage, 0x01118,,,, WindowMonitor.ahk - AutoHotkey ;Deactivate reminder overlay
                            DetectHiddenWindows, %Prev_DetectHiddenWindows%
                            SetTitleMatchMode, %A_TitleMatchMode%
                            Break
                        }
                    }
                }
            }
        }
    If NewLine contains %MyDialogsDisable%
    {
        For each, Mechanic in StrSplit(AutoMechanicSearch, "|")
        Loop, Read, Resources/Data/%Mechanic%dialogsdisable.txt
        {
            If NewLine contains %A_LoopReadLine%
            {
                activecheck = %Mechanic%Active
                automechanic = %Mechanic%Auto
                If (%activecheck% = 1) and (%automechanic% = 1) and !InStr(Mechanic, "Incursion")
                {
                    IniPath := MechanicsIni()
                    IniWrite, 0, %IniPath%, Mechanic Active, %Mechanic%
                    Prev_DetectHiddenWindows := A_DetectHiddenWIndows
                    Prev_TitleMatchMode := A_TitleMatchMode
                    SetTitleMatchMode 2
                    DetectHiddenWindows On
                    PostMessage, 0x01111,,,, PoE Mechanic Watch.ahk - AutoHotkey
                    DetectHiddenWindows, %Prev_DetectHiddenWindows%
                    SetTitleMatchMode, %A_TitleMatchMode%
                    Break 
                }  
            }
        }
    }

    IfWinActive, First2
    {
        Return
    }
    Return
}

GetLogPath()
{
    LaunchIni := LaunchOptionsIni()
    IniRead, LogPath, %LaunchIni%, POE, log
    Return, %LogPath%
}

GetHideout()
{
    IniFile := HideoutIni()
    IniRead, MyHideout, %IniFile%, Current Hideout, MyHideout
    Return, %MyHideout%
}

CheckTheme()
{
    Global ThemeItems := "Font|Background|Secondary"
    ThemeFile := ThemeIni()
    IniRead, ColorMode, %ThemeFile%, Theme, Theme
    Global Item
    Global each
    For each, Item in StrSplit(ThemeItems, "|")
    {
        IniRead, %Item%, %ThemeFile%, %ColorMode%, %Item%
    }
    Return, %ColorMode%
}