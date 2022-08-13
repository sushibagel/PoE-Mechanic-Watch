Reminder:
IniRead, NotificationSound, Resources/Settings/notification.ini, Sounds, Notification
IniRead, NotificationActive, Resources/Settings/notification.ini, Active, Notification

WarningActive = Yes
height9 := (A_ScreenHeight / 2) - 100
width9 := (A_ScreenWidth / 2)-180
Gui, 1:Destroy

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
Gosub, MechanicReminder

    If (NotificationActive = 1)
    {
        IniRead, CheckVolume, Resources/Settings/notification.ini, Volume, Notification
	    SoundPlay, Resources/Sounds/blank.wav ;;;;; super hacky workaround but works....
	    SetWindowVol("ahk_exe Autohotkey.exe", 0)
	    CheckVolume = +%CheckVolume%
	    SetWindowVol("ahk_exe Autohotkey.exe", CheckVolume)
        SoundPlay, %NotificationSound%
    }
    Return

GuiClose:
ButtonYes!:
Gui, 1:Submit
WinActivate, ahk_group PoeWindow
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

UpdateNotification:
IniRead, NotificationActive, Resources/Settings/notification.ini, Active, Notification
IniRead, InfluenceSoundActive, Resources/Settings/notification.ini, Active, Influence
IniRead, NotificaitonVolume, Resources/Settings/notification.ini, Volume, Notification
IniRead, InfluenceVolume, Resources/Settings/notification.ini, Volume, Influence
Gui, Sounds:Font, c%Font% s10
Gui, Sounds:Add, Checkbox, vNotification Checked%NotificationActive%, Notification

If (ColorMode = "Dark")
{
    IconColor = volume white.png
    PlayColor = play white.png
}
If (ColorMode = "Light")
{
    IconColor = volume.png
    PlayColor = play.png
}

Gui, Sounds:Add, Picture, gSoundsButtonChangeNotification x165 y5 w20 h20, Resources/Images/%IconColor%
Gui, Sounds:Add, Picture, gtestnotication x195 y5 w20 h20, Resources/Images/%PlayColor%
Gui, Sounds:Font, cBlack
Gui, Sounds:Color, Edit, %Secondary% -Caption -Border
Gui, Sounds:Add, Edit, x220 y5 h20 w50 vNotiEdit
Gui, Sounds:Add, UpDown, Range0-100, %NotificaitonVolume% x270 h20
Gui, Sounds:Font, c%Font%
Gui, Sounds:Add, Checkbox, vInfluenceNotification Checked%InfluenceSoundActive% x10, Influence Notification
Gui, Sounds:Add, Picture, gSoundsInfluenceNotification x165 y30 w20 h20, Resources/Images/%IconColor%
Gui, Sounds:Add, Picture, gtestnoticationInfluence x195 y30 w20 h20, Resources/Images/%PlayColor%
Gui, Sounds:Font, cBlack
Gui, Sounds:Color, Edit, %Secondary% -Caption -Border
Gui, Sounds:Add, Edit, x220 y30 h20 w50 vNotiEditInfluence
Gui, Sounds:Add, UpDown, Range0-100, %InfluenceVolume% x270 h20 y30 -Caption -Border
Gui, Sounds:Font, c%Font%

Gui, Sounds:-Border
Gui, Sounds:Color, %Background%
Gui, Sounds:-Caption
Gui, Sounds:Font, s8 Bold
Gui, Sounds:Add, Button, x190 y60 w80 h30, OK
Gui, Sounds:Show, W280 h95, Sounds
Return

SoundsGuiClose:
SoundsButtonOk: 
Gui, Submit, NoHide 
IniWrite, %Notification%, Resources/Settings/notification.ini, Active, Notification
IniWrite, %InfluenceNotification%, Resources/Settings/notification.ini, Active, Influence
Gui, Destroy
IniWrite, %NotiEdit%, Resources/Settings/notification.ini, Volume, Notification
IniWrite, %NotiEditInfluence%, Resources/Settings/notification.ini, Volume, Influence
Return

SoundsButtonChangeNotification:
Gui, Submit, NoHide
IniWrite, %Notification%, Resources/Settings/notification.ini, Active, Notification
FileSelectFile, NewSound, 1, %A_ScriptDir%\Resources\Sounds, Please select the new sound file you would like, Audio (*.wav; *.mp2; *.mp3)
If (NewSound != "")
{
    IniWrite, %NewSound%, Resources/Settings/notification.ini, Sounds, Notification
}
Return

SoundsInfluenceNotification:
Gui, Submit, NoHide
IniWrite, %InfluenceNotification%, Resources/Settings/notification.ini, Active, Influence
FileSelectFile, NewSound, 1, %A_ScriptDir%\Resources\Sounds, Please select the new sound file you would like, Audio (*.wav; *.mp2; *.mp3)
If (NewSound != "")
{
    IniWrite, %NewSound%, Resources/Settings/notification.ini, Sounds, Influence
}
Return

testnotication:
Gui, Sounds:Submit, NoHide
IniRead, TestSound, Resources/Settings/notification.ini, Sounds, Notification
TestVolume = +%NotiEdit%
SoundPlay, Resources/Sounds/blank.wav ;;;;; super hacky workaround but works....
SetWindowVol("ahk_exe Autohotkey.exe", 0)
SetWindowVol("ahk_exe Autohotkey.exe", TestVolume)
SoundPlay, %TestSound%
Return

testnoticationInfluence:
Gui, Sounds:Submit, NoHide
IniRead, TestSound, Resources/Settings/notification.ini, Sounds, Influence
TestVolume = +%NotiEditInfluence%
SoundPlay, Resources/Sounds/blank.wav ;;;;; super hacky workaround but works....
SetWindowVol("ahk_exe Autohotkey.exe", 0)
SetWindowVol("ahk_exe Autohotkey.exe", TestVolume)
SoundPlay, %TestSound%
Return