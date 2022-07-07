#SingleInstance, force
#Persistent
#Include, Resources/Scripts/tf.ahk
#NoEnv
CoordMode, Screen
DetectHiddenWindows, On

Menu, Tray, NoStandard
Menu, Tray, Add, Set Hideout, SetHideout
Menu, Tray, Add, Move Overlay, Move
Menu, Tray, Add, Select Mechanics, SelectMechanics
Menu, Tray, Add
Menu, Tray, Add, Reload, Reload
Menu, Tray, Add, Check for Updates, UpdateCheck
Menu, Tray, Add, View Log, ViewLog
Menu, Tray, Add, Exit, Exit
Menu, Tray, Icon, Resources/Images/ritual.png
Global Hideout
Global MyHideout
Global height
Global width
Global height1
Global width1
Global POEPathTrim
Global LogPath
Global WarningActive
Global AbyssOn
Global BlightOn
Global BreachOn
Global ExpeditionOn
Global HarvestOn
Global IncursionOn
Global MetamorphOn
Global RitualOn
Global GenericOn
Global AbyssActive
Global BlightActive
Global BreachActive
Global ExpeditionActive
Global HarvestActive
Global IncursionActive
Global MetamorphActive
Global RitualActive
Global GenericActive
GroupAdd, PoeWindow, ahk_exe PathOfExileSteam.exe
GroupAdd, PoeWindow, ahk_exe PathOfExile.exe 
GroupAdd, PoeWindow, ahk_exe PathOfExileEGS.exe
GroupAdd, PoeWindow, Reminder
GroupAdd, PoeWindow, Overlay

FileReadLine, hideoutcheck, Resources/Settings/CurrentHideout.txt, 1
StringTrimLeft, MyHideout, hideoutcheck, 12 

GoSub, UpdateCheck
GoSub, GetLogPath

ReadMechanics:
    IniRead, AbyssOn, Resources\Settings\Mechanics.ini, Checkboxes, Abyss
    IniRead, BlightOn, Resources\Settings\Mechanics.ini, Checkboxes, Blight
    IniRead, BreachOn, Resources\Settings\Mechanics.ini, Checkboxes, Breach
    IniRead, ExpeditionOn, Resources\Settings\Mechanics.ini, Checkboxes, Expedition
    IniRead, HarvestOn, Resources\Settings\Mechanics.ini, Checkboxes, Harvest
    IniRead, IncursionOn, Resources\Settings\Mechanics.ini, Checkboxes, Incursion
    IniRead, MetamorphOn, Resources\Settings\Mechanics.ini, Checkboxes, Metamorph
    IniRead, RitualOn, Resources\Settings\Mechanics.ini, Checkboxes, Ritual
    IniRead, GenericOn, Resources\Settings\Mechanics.ini, Checkboxes, Generic
    
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

    GoSub, MechanicsActive

mechaniccheck = Abyss
    if (%mechaniccheck%On = 1)
    {
        if (%mechaniccheck%Active = 1)
        {
            Gui, 2:Add, Picture, g%mechaniccheck% x5 y5 w50 h40 , Resources/Images/%mechaniccheck%_selected.png
        }
        Else
        {
            Gui, 2:Add, Picture, g%mechaniccheck% x5 y5 w50 h40 , Resources/Images/%mechaniccheck%.png
        }
    }

mechaniccheck = Blight
    if (%mechaniccheck%On = 1)
    {
        if (AbyssOn = 1)
        {
            rx=55
        }
        else
        {
            rx=0
        }
        mechanicx := rx+5
        if (%mechaniccheck%Active = 1)
        {
            Gui, 2:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%_selected.png
        }
        Else
        {
            Gui, 2:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%.png
        }
    }

mechaniccheck = Breach
    if (%mechaniccheck%On = 1)
    {
        mechanictest := AbyssOn + BlightOn
        if (mechanictest = 0)
        {
            mechanicx=5
        }
        else
        {
            mechanicx := (mechanictest*55)+5
        }
        if (%mechaniccheck%Active = 1)
        {
            Gui, 2:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%_selected.png
        }
        Else
        {
            Gui, 2:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%.png
        }
    }

    mechaniccheck = Expedition
    if (%mechaniccheck%On = 1)
    {
        mechanictest := AbyssOn + BlightOn + BreachOn
        if (mechanictest = 0)
        {
            mechanicx=5
        }
        else
        {
            mechanicx := (mechanictest*55)+5
        }
        if (%mechaniccheck%Active = 1)
        {
            Gui, 2:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%_selected.png
        }
        Else
        {
            Gui, 2:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%.png
        }
    }

    mechaniccheck = Harvest
    if (%mechaniccheck%On = 1)
    {
        mechanictest := AbyssOn + BlightOn + BreachOn + ExpeditionOn
        if (mechanictest = 0)
        {
            mechanicx=5
        }
        else
        {
            mechanicx := (mechanictest*55)+5
        }
        if (%mechaniccheck%Active = 1)
        {
            Gui, 2:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%_selected.png
        }
        Else
        {
            Gui, 2:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%.png
        }
    }

        mechaniccheck = Incursion
    if (%mechaniccheck%On = 1)
    {
        mechanictest := AbyssOn + BlightOn + BreachOn + ExpeditionOn + HarvestOn
        if (mechanictest = 0)
        {
            mechanicx=5
        }
        else
        {
            mechanicx := (mechanictest*55)+5
        }
        if (%mechaniccheck%Active = 1)
        {
            Gui, 2:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%_selected.png
        }
        Else
        {
            Gui, 2:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%.png
        }
    }

     mechaniccheck = Metamorph
    if (%mechaniccheck%On = 1)
    {
        mechanictest := AbyssOn + BlightOn + BreachOn + ExpeditionOn + HarvestOn + IncursionOn
        if (mechanictest = 0)
        {
            mechanicx=5
        }
        else
        {
            mechanicx := (mechanictest*55)+5
        }
        if (%mechaniccheck%Active = 1)
        {
            Gui, 2:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%_selected.png
        }
        Else
        {
            Gui, 2:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%.png
        }
    }

         mechaniccheck = Ritual
    if (%mechaniccheck%On = 1)
    {
        mechanictest := AbyssOn + BlightOn + BreachOn + ExpeditionOn + HarvestOn + IncursionOn + MetamorphOn
        if (mechanictest = 0)
        {
            mechanicx=5
        }
        else
        {
            mechanicx := (mechanictest*55)+5
        }
        if (%mechaniccheck%Active = 1)
        {
            Gui, 2:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%_selected.png
        }
        Else
        {
            Gui, 2:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%.png
        }
    }

         mechaniccheck = Generic
    if (%mechaniccheck%On = 1)
    {
        mechanictest := AbyssOn + BlightOn + BreachOn + ExpeditionOn + HarvestOn + IncursionOn + MetamorphOn + RitualOn
        if (mechanictest = 0)
        {
            mechanicx=5
        }
        else
        {
            mechanicx := (mechanictest*55)+5
        }
        if (%mechaniccheck%Active = 1)
        {
            Gui, 2:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%_selected.png
        }
        Else
        {
            Gui, 2:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%.png
        }
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
    IfWinNotActive, ahk_group PoeWindow
    {
        Sleep, 100
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
Active = 
Active1 = 
Active2 =
Active3 =
Active4 =
Active5 =
Active6 =
Active7 =
Active8 =
Active9 =

GoSub, MechanicsActive

If (AbyssActive = 1)
{
    Active1 := "Abyss" A_Space
}
If (BlightActive = 1)
{
    Active2 := "Blight" A_Space
}
If (BreachActive = 1)
{
    Active3 := "Breach" A_Space
}
If (ExpeditionActive = 1)
{
    Active4 := "Expedition" A_Space
}
If (HarvestActive = 1)
{
    Active5 := "Harvest" A_Space
}
If (IncursionActive = 1)
{
    Active6 := "Incursion" A_Space
}
If (MetamorphActive = 1)
{
    Active7 := "Metamorph" A_Space
}
If (RitualActive = 1)
{
    Active8 := "Ritual" A_Space
}
If (GenericActive = 1)
{
    Active8 := "Mechanic" A_Space
}

MechanicsActive := MetamorphActive + RitualActive + HarvestActive + BlightActive + ExpeditionActive + AbyssActive + BreachActive + IncursionActive + GenericActive

Active = %Active1%%Active2%%Active3%%Active4%%Active5%%Active6%%Active7%%Active8%%Active9%

if (MechanicsActive >= 3)
{
    TMech := MechanicsActive - 2
    ReminderText1 := StrReplace(Active, A_Space,",",, TMech)
    Active1 := StrReplace(ReminderText1, A_Space, "and",, 1)
    ReminderText2 := StrReplace(Active1, ",", ","A_Space)
    Active2 := StrReplace(ReminderText2, "and", A_Space "and"A_Space)
    
    ReminderText := Active2
}

if (MechanicsActive = 2)
{
    ReminderText := StrReplace(Active, A_Space, A_Space "and" A_Space,, 1)
}

if (MechanicsActive = 1)
{
    ReminderText := Active
}
    Sleep, 100
    Gui, 1:Add, Text,,Did you forget to complete your %ReminderText%?
    Gui, 1:Font, s10
    Gui, 1:Color, 4e4f53
    Gui, 1:-Border
    Gui, 1:+AlwaysOnTop
    Gui, 1:Show, x%width1% y%height1%, Reminder
    WinGetPos,,, Width, Height, Reminder
    Gui, 1:Hide,
    WinSet, Style, -0xC00000, Reminder
    xpos := (width/4)
    xpos2 := xpos+80
    gheight := height + 20
    nwidth := width1 - xpos
    Gui, 1:Add, Button, x%xpos% y40, Yes!
    Gui, 1:Add, Button,x%xpos2% y40, No
    Gui, 1:Show, x%nwidth% y%height1% h%gheight%, Reminder
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
IniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Abyss
IniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Blight
IniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Breach
IniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Expedition
IniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Harvest
IniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Incursion
IniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Metamorph
IniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Ritual  
IniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Generic
Gui, 2:Destroy
Gosub, Monitor
Return

Abyss:
GoSub, MechanicsActive
{
if (AbyssActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Abyss
        Gui, 2:Destroy
        Gosub, Overlay
        Gosub, LogMonitor
        return
    }

if (AbyssActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Abyss
        Gui, 2:Destroy
        Gosub, Overlay
        return
    }
}

Blight:
GoSub, MechanicsActive
{
if (BlightActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Blight
        Gui, 2:Destroy
        Gosub, Overlay
        Gosub, LogMonitor
        return
    }

if (BlightActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Blight
        Gui, 2:Destroy
        Gosub, Overlay
        return
    }
}

Breach:
GoSub, MechanicsActive
{
if (BreachActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Breach
        Gui, 2:Destroy
        Gosub, Overlay
        Gosub, LogMonitor
        return
    }

if (BreachActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Breach
        Gui, 2:Destroy
        Gosub, Overlay
        return
    }
}

Expedition:
GoSub, MechanicsActive
{
if (ExpeditionActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Expedition
        Gui, 2:Destroy
        Gosub, Overlay
        Gosub, LogMonitor
        return
    }

if (ExpeditionActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Expedition
        Gui, 2:Destroy
        Gosub, Overlay
        return
    }
}

Incursion:
GoSub, MechanicsActive
{
if (IncursionActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Incursion
        Gui, 2:Destroy
        Gosub, Overlay
        Gosub, LogMonitor
        return
    }

if (IncursionActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Incursion
        Gui, 2:Destroy
        Gosub, Overlay
        return
    }
}

Metamorph:
GoSub, MechanicsActive
{
if (MetamorphActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Metamorph
        Gui, 2:Destroy
        Gosub, Overlay
        Gosub, LogMonitor
        return
    }

if (MetamorphActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Metamorph
        Gui, 2:Destroy
        Gosub, Overlay
        return
    }
}

Ritual:
GoSub, MechanicsActive
{
if (RitualActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Ritual
        Gui, 2:Destroy
        Gosub, Overlay
        Gosub, LogMonitor
        return
    }

if (RitualActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Ritual
        Gui, 2:Destroy
        Gosub, Overlay
        return
    }
}

Harvest:
GoSub, MechanicsActive
{
if (HarvestActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Harvest
        Gui, 2:Destroy
        Gosub, Overlay
        Gosub, LogMonitor
        return
    }

if (HarvestActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Harvest
        Gui, 2:Destroy
        Gosub, Overlay
        return
    }
}

Generic:
GoSub, MechanicsActive
{
if (GenericActive = 0)
    {
        iniWrite, 1, Resources\Data\MechanicsActive.ini, Active, Generic
        Gui, 2:Destroy
        Gosub, Overlay
        Gosub, LogMonitor
        return
    }

if (GenericActive = 1)
    {
        iniWrite, 0, Resources\Data\MechanicsActive.ini, Active, Generic
        Gui, 2:Destroy
        Gosub, Overlay
        return
    }
}

Reload:
Reload
Return

Move:
heightoff := height - 30
widthoff := width - 5
GoSub, RecheckMechanics
mechaniccheck = Abyss
    if (%mechaniccheck%On = 1)
    {
        if (%mechaniccheck%Active = 1)
        {
            Gui, 3:Add, Picture, g%mechaniccheck% x5 y5 w50 h40 , Resources/Images/%mechaniccheck%_selected.png
        }
        Else
        {
            Gui, 3:Add, Picture, g%mechaniccheck% x5 y5 w50 h40 , Resources/Images/%mechaniccheck%.png
        }
    }

mechaniccheck = Blight
    if (%mechaniccheck%On = 1)
    {
        if (AbyssOn = 1)
        {
            rx=55
        }
        else
        {
            rx=0
        }
        mechanicx := rx+5
        if (%mechaniccheck%Active = 1)
        {
            Gui, 3:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%_selected.png
        }
        Else
        {
            Gui, 3:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%.png
        }
    }

mechaniccheck = Breach
    if (%mechaniccheck%On = 1)
    {
        mechanictest := AbyssOn + BlightOn
        if (mechanictest = 0)
        {
            mechanicx=5
        }
        else
        {
            mechanicx := (mechanictest*55)+5
        }
        if (%mechaniccheck%Active = 1)
        {
            Gui, 3:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%_selected.png
        }
        Else
        {
            Gui, 3:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%.png
        }
    }

    mechaniccheck = Expedition
    if (%mechaniccheck%On = 1)
    {
        mechanictest := AbyssOn + BlightOn + BreachOn
        if (mechanictest = 0)
        {
            mechanicx=5
        }
        else
        {
            mechanicx := (mechanictest*55)+5
        }
        if (%mechaniccheck%Active = 1)
        {
            Gui, 3:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%_selected.png
        }
        Else
        {
            Gui, 3:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%.png
        }
    }

    mechaniccheck = Harvest
    if (%mechaniccheck%On = 1)
    {
        mechanictest := AbyssOn + BlightOn + BreachOn + ExpeditionOn
        if (mechanictest = 0)
        {
            mechanicx=5
        }
        else
        {
            mechanicx := (mechanictest*55)+5
        }
        if (%mechaniccheck%Active = 1)
        {
            Gui, 3:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%_selected.png
        }
        Else
        {
            Gui, 3:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%.png
        }
    }

        mechaniccheck = Incursion
    if (%mechaniccheck%On = 1)
    {
        mechanictest := AbyssOn + BlightOn + BreachOn + ExpeditionOn + HarvestOn
        if (mechanictest = 0)
        {
            mechanicx=5
        }
        else
        {
            mechanicx := (mechanictest*55)+5
        }
        if (%mechaniccheck%Active = 1)
        {
            Gui, 3:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%_selected.png
        }
        Else
        {
            Gui, 3:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%.png
        }
    }

     mechaniccheck = Metamorph
    if (%mechaniccheck%On = 1)
    {
        mechanictest := AbyssOn + BlightOn + BreachOn + ExpeditionOn + HarvestOn + IncursionOn
        if (mechanictest = 0)
        {
            mechanicx=5
        }
        else
        {
            mechanicx := (mechanictest*55)+5
        }
        if (%mechaniccheck%Active = 1)
        {
            Gui, 3:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%_selected.png
        }
        Else
        {
            Gui, 3:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%.png
        }
    }

         mechaniccheck = Ritual
    if (%mechaniccheck%On = 1)
    {
        mechanictest := AbyssOn + BlightOn + BreachOn + ExpeditionOn + HarvestOn + IncursionOn + MetamorphOn
        if (mechanictest = 0)
        {
            mechanicx=5
        }
        else
        {
            mechanicx := (mechanictest*55)+5
        }
        if (%mechaniccheck%Active = 1)
        {
            Gui, 3:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%_selected.png
        }
        Else
        {
            Gui, 3:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%.png
        }
    }

             mechaniccheck = Generic
    if (%mechaniccheck%On = 1)
    {
        mechanictest := AbyssOn + BlightOn + BreachOn + ExpeditionOn + HarvestOn + IncursionOn + MetamorphOn + RitualOn
        if (mechanictest = 0)
        {
            mechanicx=5
        }
        else
        {
            mechanicx := (mechanictest*55)+5
        }
        if (%mechaniccheck%Active = 1)
        {
            Gui, 3:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%_selected.png
        }
        Else
        {
            Gui, 3:Add, Picture, g%mechaniccheck% x%mechanicx% y5 w50 h40 , Resources/Images/%mechaniccheck%.png
        }
    }
    Gui, 3:Add, Button, gLock x20 y50, &Lock
    Gui, 3:+AlwaysOnTop
    GuiWidth := ((AbyssOn + BlightOn + BreachOn + ExpeditionOn + HarvestOn + IncursionOn + MetamorphOn + RitualOn + GenericOn)*55)+15
    If (GuiWidth < 195)
    {
        GuiWidth := 200
    }
    Gui, 3:Show, x%widthoff% y%heightoff% w%GuiWidth%, Move
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
setheight:=newheight + 5
setwidth:=newwidth + 15

FileDelete, Resources/Settings/overlayposition.txt
FileAppend, height=%setheight% `n, Resources/Settings/overlayposition.txt
FileAppend, width=%setwidth%, Resources/Settings/overlayposition.txt
Return

WindowMonitor:
Loop
{
    IfWinNotActive, ahk_group PoeWindow
    {
        Sleep, 200
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
CurrentVersion := SubStr(CurrentVersion1, 1, 6)
If (InstalledVersion=CurrentVersion)
{
    TrayTip, Up-To-Date, PoE Mechanic Watch Is Up-To-Date,
    Return
}
Else
{
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
whr.Open("GET", "https://raw.githubusercontent.com/sushibagel/PoE-Mechanic-Watch/main/changelog.txt", true)
whr.Send()
whr.WaitForResponse() 
changelog := whr.ResponseText
UpdateURL = https://github.com/sushibagel/PoE-Mechanic-Watch/archive/refs/tags/%CurrentVersion%.zip
    MsgBox, 1, An update is available. Press OK to download., Your currently installed version is %InstalledVersion%. The latest is %CurrentVersion%.`n`nTo avoid the need to change all your settings on each update I recommend not copying over not copying the "Settings" folder from the update zip.`n`nChangelog:`n%changelog%
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

SelectMechanics:
RunWait, Resources\Scripts\MechanicSelector.ahk
GoSub, RecheckMechanics
Gui, 2:Destroy
Gosub, Overlay
Return

MechanicsActive:
IniRead, AbyssActive, Resources\Data\MechanicsActive.ini, Active, Abyss
IniRead, BlightActive, Resources\Data\MechanicsActive.ini, Active, Blight
IniRead, BreachActive, Resources\Data\MechanicsActive.ini, Active, Breach
IniRead, ExpeditionActive, Resources\Data\MechanicsActive.ini, Active, Expedition
IniRead, HarvestActive, Resources\Data\MechanicsActive.ini, Active, Harvest
IniRead, IncursionActive, Resources\Data\MechanicsActive.ini, Active, Incursion
IniRead, MetamorphActive, Resources\Data\MechanicsActive.ini, Active, Metamorph
IniRead, RitualActive, Resources\Data\MechanicsActive.ini, Active, Ritual 
IniRead, GenericActive, Resources\Data\MechanicsActive.ini, Active, Generic 
Return

RecheckMechanics:
IniRead, AbyssOn, Resources\Settings\Mechanics.ini, Checkboxes, Abyss
    IniRead, BlightOn, Resources\Settings\Mechanics.ini, Checkboxes, Blight
    IniRead, BreachOn, Resources\Settings\Mechanics.ini, Checkboxes, Breach
    IniRead, ExpeditionOn, Resources\Settings\Mechanics.ini, Checkboxes, Expedition
    IniRead, HarvestOn, Resources\Settings\Mechanics.ini, Checkboxes, Harvest
    IniRead, IncursionOn, Resources\Settings\Mechanics.ini, Checkboxes, Incursion
    IniRead, MetamorphOn, Resources\Settings\Mechanics.ini, Checkboxes, Metamorph
    IniRead, RitualOn, Resources\Settings\Mechanics.ini, Checkboxes, Ritual
    IniRead, GenericOn, Resources\Settings\Mechanics.ini, Checkboxes, Generic
Return
