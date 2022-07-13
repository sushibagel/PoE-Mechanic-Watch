Reminder:
WarningActive = Yes
height1 := (A_ScreenHeight / 2) - 100
width1 := (A_ScreenWidth / 2)-180
Gui, 1:Destroy
Gui, 1:Font, cWhite s12

;;;;;;;;;;;;;;;;;; Read Status of Mechanics ;;;;;;;;;;;;;;;;
Gosub, MechanicsActive
Active = 

Loop, 1
For each, Mechanic in StrSplit(MechanicSearch, "|")
{
    mechanicactive = %Mechanic%Active
    If (%mechanicactive% = 1)
    {
        Active = %Active% %Mechanic%
        MechanicsActive ++
    }
}

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
    gheight := height + 40
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
            Sleep, 100
        }
        IfWinNotActive, ahk_group PoeWindow
        {
            Gui, 2:Destroy
            Loop
            {
                IfWinActive, ahk_group PoeWindow
                {
                    Gosub, Overlay
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
Gosub, LogMonitor
Return

ButtonNo:
Gui, 1:submit
WarningActive = No
Loop, 1
For each, Mechanic in StrSplit(MechanicSearch, "|")
{
    IniWrite, 0, Resources\Data\MechanicsActive.ini, Active, %Mechanic%
}
Gui, 2:Destroy
GoSub, Monitor
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