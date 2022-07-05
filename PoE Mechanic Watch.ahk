#SingleInstance, force
#Persistent
#Include, Resources/Scripts/tf.ahk
#NoEnv
CoordMode, Screen
DetectHiddenWindows, On

Menu, Tray, NoStandard
Menu, Tray, Add, Set Hideout, SetHideout
Menu, Tray, Add, Move Overlay, Move
Menu, Tray, Add
Menu, Tray, Add, Reload, Reload
Menu, Tray, Add, Check for Updates, UpdateCheck
Menu, Tray, Add, View Log, ViewLog
Menu, Tray, Add, Exit, Exit
Menu, Tray, Icon, Resources/Images/Blood-filled_Vessel_inventory_icon.png
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

FileReadLine, hideoutcheck, Resources/Settings/CurrentHideout.txt, 1
StringTrimLeft, MyHideout, hideoutcheck, 12 

MetamorphButton = 1
RitualButton = 1
GoSub, UpdateCheck
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
    FileReadLine, heightVar, Resources/Settings/overlayposition.txt, 1
    StringTrimLeft, height, heightVar, 7
    FileReadLine, widthVar, Resources/Settings/overlayposition.txt, 2
    StringTrimLeft, width, widthVar, 6
    Gui, 2:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
    Gui, 2:Color, 808080
    if (MetamorphButton = 1)
        {
            Gui, 2:Add, Picture, gMetamorph x5 y5 w50 h40 , Resources/Images/metamorph.png
        }
    if (MetamorphButton = 2)
        {
            Gui, 2:Add, Picture, gMetamorph x5 y5 w50 h40 , Resources/Images/metamorph_selected.png
        }
    if (RitualButton = 1)
        {
            Gui, 2:Add, Picture, gRitual x60 y5 w50 h40 , Resources/Images/Blood-filled_Vessel_inventory_icon.png
        }
    if (RitualButton = 2)
        {
            Gui, 2:Add, Picture, gRitual x60 y5 w50 h40 , Resources/Images/Blood-filled_Vessel_inventory_icon_selected.png
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
    Gui, 3:Add, Picture, gnone x105 y5 w50 h40 , Resources/Images/metamorph.png
    Gui, 3:Add, Picture, gnone x160 y5 w50 h40 , Resources/Images/Blood-filled_Vessel_inventory_icon.png
    Gui, 3:Add, Button, gLock x20 y10, &Lock
    Gui, 3:+AlwaysOnTop
    Gui, 3:Show, x%widthoff% y%heightoff%, Move
Return

none:
Return

Exit:
ExitApp
Return

Lock:
DetectHiddenWindows, On
WinGetPos,newwidth, newheight
Gui, 3:Submit
Gui, 3:Destroy
setheight:=newheight + 25
setwidth:=newwidth + 105

FileDelete, Resources/Settings/overlayposition.txt
FileAppend, height=%setheight% `n, Resources/Settings/overlayposition.txt
FileAppend, width=%setwidth%, Resources/Settings/overlayposition.txt
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
Run, Resources\Scripts\HideoutUpdate.ahk
Return

ViewLog:
run, %POEPathTrim%logs
Return

UpdateCheck:
FileReadLine, InstalledVersion, Resources/Data/Version.txt, 1
Filename = %A_ScriptDir%/PoE Mechanic Watch Update.zip
url = https://github.com/sushibagel/PoE-Mechanic-Watch/blob/main/Resources/Data/Version.txt
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
whr.Open("GET", "https://raw.githubusercontent.com/sushibagel/PoE-Mechanic-Watch/main/Resources/Data/Version.txt", true)
whr.Send()
whr.WaitForResponse() 
CurrentVersion1 := whr.ResponseText
UpdateURL = https://github.com/sushibagel/PoE-Mechanic-Watch/archive/refs/tags/%version%.zip
CurrentVersion := SubStr(CurrentVersion1, 1, 6)
If (InstalledVersion=CurrentVersion)
{
    TrayTip, Up-To-Date, PoE Mechanic Watch Is Up-To-Date,
    Return
}
Else
{
    MsgBox, 1, Press OK to download, Your currently installed version is %InstalledVersion%. The latest is %CurrentVersion%.
	IfMsgBox OK
	UrlDownloadToFile, *0 %UpdateUrl%, %Filename%
	    if ErrorLevel = 1
			MsgBox, There was some error updating the file. You may have the latest version, or it is blocked.
		else if ErrorLevel = 0
			MsgBox, The update/ download appears to have been successful or you clicked cancel. Please check the update folder %A_ScriptDir% for the download. To install unzip it and replace the existing files with the ones found in the zip. 
		else 
			MsgBox, some other crazy error occured. 
}
Return
