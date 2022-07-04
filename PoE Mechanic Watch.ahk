#SingleInstance, force
#Persistent
#Include, tf.ahk
#NoEnv
CoordMode, Screen
DetectHiddenWindows, On

Menu, Tray, NoStandard
Menu, Tray, Add, Set Hideout, SetHideout
Menu, Tray, Add, Move Overlay, Move
Menu, Tray, Add
Menu, Tray, Add, Reload, Reload
Menu, Tray, Add, View Log, ViewLog
Menu, Tray, Add, Window Spy, WindowSpy
Menu, Tray, Add, Edit This Script, mwt_Edit
Menu, Tray, Add, Exit, Exit
Menu,Tray,Icon,%A_ScriptDir%/Blood-filled_Vessel_inventory_icon.png
Global RitualText
Global MetamorphText
Global Hideout
Global MetamorphButton
Global RitualButton 
Global MyHideout
Global height
Global width
Global height1
Global width1
Global POEPathTrim
Global LogPath
Global WarningActive
GroupAdd, PoeWindow, ahk_exe PathOfExileSteam.exe
GroupAdd, PoeWindow, ahk_exe PathOfExile.exe 
GroupAdd, PoeWindow, ahk_exe PathOfExileEGS.exe
GroupAdd, PoeWindow, Reminder
GroupAdd, PoeWindow, Overlay

FileReadLine, hideoutcheck, CurrentHideout.txt, 1
StringTrimLeft, MyHideout, hideoutcheck, 12 

MetamorphButton = 1
RitualButton = 1

GoSub, GetLogPath

Monitor: ;Monitor for Path of Exile window to be active. This will hide the overlay if the window is inactive and activate it when active. 
Loop 
{
    IfWinActive, ahk_group PoeWindow
    {
        Gosub, Overlay
        {
            If (WarningActive = "Yes")
            {
                Gosub, Reminder
            }
        }
    }

    IfWinNotActive, ahk_group PoeWindow
    {
        Gui, 2:Destroy
    }
}

Overlay:
{
    FileReadLine, heightVar, overlayposition.txt, 1
    StringTrimLeft, height, heightVar, 7
    FileReadLine, widthVar, overlayposition.txt, 2
    StringTrimLeft, width, widthVar, 6
    Gui, 2:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
    Gui, 2:Color, 808080
    if (MetamorphButton = 1)
        {
            Gui, 2:Add, Picture, gMetamorph x5 y5 w50 h40 , %A_ScriptDir%/metamorph.png
        }
    if (MetamorphButton = 2)
        {
            Gui, 2:Add, Picture, gMetamorph x5 y5 w50 h40 , %A_ScriptDir%/metamorph_selected.png
        }
    if (RitualButton = 1)
        {
            Gui, 2:Add, Picture, gRitual x60 y5 w50 h40 , %A_ScriptDir%/Blood-filled_Vessel_inventory_icon.png
        }
    if (RitualButton = 2)
        {
            Gui, 2:Add, Picture, gRitual x60 y5 w50 h40 , %A_ScriptDir%/Blood-filled_Vessel_inventory_icon_selected.png
        }
    Gui, 2:+AlwaysOnTop
    Gui, 2:Show, NoActivate x%width% y%height%, Overlay
    WinSet, Style, -0xC00000, Overlay
    WinSet, TransColor, 808080, Overlay
    return
}


LogMonitor: ;Monitor the PoE client.txt
Gosub, GetLogPath
Loop 
{
    if (MetamorphButton = 1)
    {
        if (RitualButton = 1)
        {
            Gosub, Monitor
            Break
        }
    }

    IfWinNotActive, ahk_group PoeWindow
    {
        Gui, 1:Destroy
        Gui, 2:Destroy
        Loop
        {
            IfWinActive, ahk_group PoeWindow
            {
                Gosub, Overlay
                Gosub, LogMonitor
                Break
            }
        }
    }

    Hideout  := TF_Tail(LogPath, 3)
    IfInString, Hideout, %MyHideout%
    {
        GoSub, Reminder
        Break
    }
}

Reminder:
        WarningActive = Yes
        height1 := (A_ScreenHeight / 2) - 100
        width1 := (A_ScreenWidth / 2)-180
        Gui, 1:Destroy
        Gui, 1:Font, cWhite s12
        if RitualText !=
        {
            if MetamorphText !=
            {
                 Gui, 1:Add, Text,,Did you forget to complete your Metamorph and Ritual?
            }
            Else
            {
                 Gui, 1:Add, Text,,Did you forget to complete your Ritual?
            }
        }

        if MetamorphText !=
        {
            if RitualText =
            {
                 Gui, 1:Add, Text,,Did you forget to complete your Metamorph?
            }
        }
        Gui, 1:Font, s10
        Gui, 1:Add, Button,x90 y40, Yes!
        Gui, 1:Add, Button,x200 y40, No
        Gui, 1:Color, 4e4f53
        Gui, 1:-Border
        Gui, 1:+AlwaysOnTop
        Gui, 1:show, x%width1% y%height1%, Reminder
        WinSet, Style, -0xC00000, Reminder
        Gui, 2:Show, NoActivate x%width% y%height%, Overlay
        Gosub, WindowMonitor
        Return

GuiClose:
ButtonYes!:
Gui, 1:Submit
WinActivate, ahk_group PoeWindow
WarningActive = No
Loop 
{
    Hideout  := TF_Tail(LogPath, 3)
    IfInString, Hideout, %MyHideout%
    {
        IfWinActive, ahk_group PoeWindow
        {
            Sleep, 1
        }
        IfWinNotActive, ahk_group PoeWindow
        {
            Gui, 2:Destroy
            Loop
            {
                IfWinActive, ahk_group PoeWindow
                {
                    GoSub, Overlay
                    Break
                }
            }

        }
    }
    Else
    {
        Break
    }
}
Gosub, Overlay
Gosub, LogMonitor ;This sends us back to the monitoring loop once we leave our hideout. 
Return

ButtonNo:
Gui, 1:submit
WarningActive = No
MetamorphButton = 1
RitualButton = 1
MetamorphText =
RitualText =
Gui, 2:Destroy
Gosub, Monitor
Return

Metamorph:
{
if (MetamorphButton = 1)
    {
        MetamorphButton = 2
        MetamorphText = Metamorph
        Gui, 2:Destroy
        Gosub, Overlay
        Gosub, LogMonitor
        return
    }

if (MetamorphButton = 2)
    {
        MetamorphButton = 1
        MetamorphText =
        Gui, 2:Destroy
        Gosub, Overlay
        return
    }
}

Ritual:
{
if (RitualButton = 1)
    {
        RitualButton = 2
        RitualText = Ritual
        Gui, 2:Destroy
        Gosub, Overlay
        Gosub, LogMonitor
        return
    }

if (RitualButton = 2)
    {
        RitualButton = 1
        RitualText =
        Gui, 2:Destroy
        Gosub, Overlay
        return
    }
}

Reload:
Reload
Return

Move:
heightoff := height - 25
widthoff := width - 105
    Gui, 3:Add, Picture, gnone x105 y5 w50 h40 , %A_ScriptDir%/metamorph.png
    Gui, 3:Add, Picture, gnone x160 y5 w50 h40 , %A_ScriptDir%/Blood-filled_Vessel_inventory_icon.png
    Gui, 3:Add, Button, gLock x20 y10, &Lock
    Gui, 3:+AlwaysOnTop
    Gui, 3:Show, x%widthoff% y%heightoff%, Move
Return

none:
Return

mwt_Edit:
Edit
return

Exit:
ExitApp
Return

WindowSpy:
  RegRead ahkInstallDir, HKEY_LOCAL_MACHINE, SOFTWARE\AutoHotkey, InstallDir
  Run %ahkInstallDir%\WindowSpy.ahk
  WinWait Active Window Info,,3
  if not ErrorLevel
    WinMove A,, A_ScreenWidth-400, 200 ; Move the window to the side a little for convenience.
return

Lock:
DetectHiddenWindows, On
WinGetPos,newwidth, newheight
Gui, 3:Submit
Gui, 3:Destroy
setheight:=newheight + 25
setwidth:=newwidth + 105

FileDelete, overlayposition.txt
FileAppend, height=%setheight% `n, overlayposition.txt
FileAppend, width=%setwidth%, overlayposition.txt
Return

WindowMonitor:
Loop
{
    IfWinNotActive, ahk_group PoeWindow
    {
        Sleep, 100
        IfWinNotActive, ahk_group PoeWindow
        {
            Gui, 1:Destroy
            Gui, 2:Destroy
            Gosub, WindowMonitor2
            Break
        }
        IfWinActive, ahk_group PoeWindow
        {
            Gosub, WindowMonitor
            Break
        }
    }
}

WindowMonitor2:
Loop
{
    IfWinActive, ahk_group PoeWindow
    {
        Gosub, Monitor
        Break
    }
}

GetLogPath:
WinGet, POEpath, ProcessPath, Path of Exile

IfInstring, POEpath, PathOfExileSteam.exe
{
    StringTrimRight, POEPathTrim, POEpath, 20
}

IfInstring, POEpath, PathOfExile_x64Steam.exe
{
    StringTrimRight, POEPathTrim, POEpath, 23
}

IfInstring, POEpath, Client.exe
{
    StringTrimRight, POEPathTrim, POEpath, 10
}

IfInstring, POEpath, PathOfExile.exe
{
    StringTrimRight, POEPathTrim, POEpath, 15
}

IfInstring, POEpath, PathOfExile_x64.exe
{
    StringTrimRight, POEPathTrim, POEpath, 18
}

IfInstring, POEpath, PathOfExileEGS.exe
{
    StringTrimRight, POEPathTrim, POEpath, 18 
}

IfInstring, POEpath, PathOfExile_x64EGS.exe
{
    StringTrimRight, POEPathTrim, POEpath, 21 
}

LogPath = %POEPathTrim%logs\Client.txt
Return

SetHideout:
Run, HideoutUpdate.ahk
Return

ViewLog:
run, %POEPathTrim%logs
Return
