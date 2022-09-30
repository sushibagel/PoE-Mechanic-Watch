Global IncursionGo
Global MyDialogs
Global MyDialogsDisable
Global FullSearch
Global IncursionCode
Global IncursionSleep
Global MyHideout

LogMonitor() ;Monitor the PoE client.txt
{
    SetTimer, LogMonitor, Delete
    ReadFile = Resources\Data\Incursiondialogsdisable.txt
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
    Return
}

HideoutEntered()
{
    MechanicsActive()
    If (MechanicsActive >= 1)
    {
        ; Reminder()
        WinwaitClose, Reminder
        Exit
    }
    Exit
}

+i::
{
    ControlSetText, Control, NewText [, WinTitle, WinText, ExcludeTitle, ExcludeText]
    ControlSetText, Resources\Images\blight.png, Resources\Images\blight_selected.png, ,Resources\Images\blight.pngs

    Overlay
ahk_class AutoHotkeyGUI
    return
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
                    {
                        ; change overlay image
                        ; edit the ini file to active the mechanic. 
                        ControlSetText, Control, NewText [, WinTitle, WinText, ExcludeTitle, ExcludeText]
                        %Mechanic%()
                        Break
                    }
                    If NewLine contains %IncursionGo%
                    {
                        GetLogCode := StrSplit(NewLine, A_Space)
                        Code = % GetLogCode[3]
                        If (Code = IncursionCode) and (Code != "")
                        {
                            Break
                        }
                        IncursionCode := Code
                        IncursionSleep ++
                        If (IncursionSleep = 4)
                        {
                            ; Incursion()
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
                If (%activecheck% = 1) and (%automechanic% = 1) and !InStr(Mechanic, Incursion)
                {
                    %Mechanic%()
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