Reminder:


IniRead, NotificationSound, Resources\Settings\notification.ini, Sounds, Notification
IniRead, NotificationSoundActive, Resources\Settings\notification.ini, Active, Notification

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

If ReminderText contains Searing
{
    StringReplace, ReminderText, ReminderText,`, Searing,
}
If ReminderText contains Eater
{
    StringReplace, ReminderText, ReminderText,`, Eater,
}

Sleep, 100
Gosub, MechanicReminder

IniRead, NotificationSoundActive, Resources\Settings\notification.ini, Active, Notification
If (NotificationSoundActive = 1)
{
    IniRead, NotificationVolume, Resources\Settings\notification.ini, Volume, Notification
    IniRead, NotificationSound, Resources\Settings\notification.ini, Sounds, Notification
    SoundPlay, Resources\Sounds\blank.wav ;;;;; super hacky workaround but works....
    SetTitleMatchMode, 2
    WinGet, AhkExe, ProcessName, Reminder
    SetTitleMatchMode, 1
    SetWindowVol(AhkExe, NotificationVolume)
    SoundPlay, %NotificationSound%
}
Loop
{
    IfWinNotActive, ahk_Group PoeWindow
    {
        Sleep, 400
        IfWinNotActive, ahk_Group PoeWindow
        {
            Gui, 1:Destroy
            Gui, 2:Destroy
            Loop
            {
                If (EndLoop = 1)
                {
                    EndLoop =
                    NewLine =
                    Exit
                }
                IfWinActive, ahk_Group PoeWindow and (EndLoop != 1)
                {
                    Gosub, Overlay
                    Gosub, Reminder
                    NewLine =
                    Break
                }
            }
        }
    }
    If (EndLoop = 1)
    {
        EndLoop = 
        NewLine =
        Exit
    }
}
Exit

GuiClose:
ButtonYes!:
WinActivate, Path of Exile
Gui, 1:Submit
lt := new CLogTailer(LogPath, Func("LogTail"))
Return

ButtonNo:
BreakLoop = 1
Gui, 1:Submit
Loop, 1
For each, Mechanic in StrSplit(MechanicSearch, "|")
{
    IniWrite, 0, Resources\Data\MechanicsActive.ini, Active, %Mechanic%
}
Gui, 2:Destroy
GoSub, Monitor
Return

UpdateNotification:
IniRead, NotificationSoundActive, Resources\Settings\notification.ini, Active, Notification
IniRead, InfluenceSoundActive, Resources\Settings\notification.ini, Active, Influence
IniRead, NotificationVolume, Resources\Settings\notification.ini, Volume, Notification
IniRead, InfluenceVolume, Resources\Settings\notification.ini, Volume, Influence
IniRead, NotificationSound, Resources\Settings\notification.ini, Sounds, Notification
IniRead, InfluenceSound, Resources\Settings\notification.ini, Sounds, Influence
Gui, Sounds:Font, c%Font% s10
Gui, Sounds:Add, Checkbox, vNotification Checked%NotificationSoundActive%, Notification

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

Gui, Sounds:Add, Picture, gSoundsButtonChangeNotification x165 y5 w20 h20, Resources\Images\%IconColor%
Gui, Sounds:Add, Picture, gtestnotication x195 y5 w20 h20, Resources\Images\%PlayColor%
Gui, Sounds:Font, cBlack
Gui, Sounds:Color, Edit, %Secondary% -Caption -Border
Gui, Sounds:Add, Edit, x220 y5 h20 w50 vNotiEdit
Gui, Sounds:Add, UpDown, Range0-100, %NotificationVolume% x270 h20
Gui, Sounds:Font, c%Font%
Gui, Sounds:Add, Checkbox, vInfluenceNotification Checked%InfluenceSoundActive% x10, Influence Notification
Gui, Sounds:Add, Picture, gSoundsInfluenceNotification x165 y30 w20 h20, Resources\Images\%IconColor%
Gui, Sounds:Add, Picture, gtestnoticationInfluence x195 y30 w20 h20, Resources\Images\%PlayColor%
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
IniWrite, %Notification%, Resources\Settings\notification.ini, Active, Notification
IniWrite, %InfluenceNotification%, Resources\Settings\notification.ini, Active, Influence
Gui, Destroy
IniWrite, %NotiEdit%, Resources\Settings\notification.ini, Volume, Notification
IniWrite, %NotiEditInfluence%, Resources\Settings\notification.ini, Volume, Influence
Return

SoundsButtonChangeNotification:
Gui, Submit, NoHide
IniWrite, %Notification%, Resources\Settings\notification.ini, Active, Notification
FileSelectFile, NewSound, 1, %A_ScriptDir%\Resources\Sounds, Please select the new sound file you would like, Audio (*.wav; *.mp2; *.mp3)
If (NewSound != "")
{
    IniWrite, %NewSound%, Resources\Settings\notification.ini, Sounds, Notification
}
Return

SoundsInfluenceNotification:
Gui, Submit, NoHide
IniWrite, %InfluenceNotification%, Resources\Settings\notification.ini, Active, Influence
FileSelectFile, NewSound, 1, %A_ScriptDir%\Resources\Sounds, Please select the new sound file you would like, Audio (*.wav; *.mp2; *.mp3)
If (NewSound != "")
{
    IniWrite, %NewSound%, Resources\Settings\notification.ini, Sounds, Influence
}
Return

testnotication:
Gui, Sounds:Submit, NoHide
IniRead, TestSound, Resources\Settings\notification.ini, Sounds, Notification
TestVolume = %NotiEdit%
SoundPlay, Resources\Sounds\blank.wav ;;;;; super hacky workaround but works....
SetTitleMatchMode, 2
WinGet, AhkExe, ProcessName, Sounds
SetTitleMatchMode, 1
SetWindowVol(AhkExe, 0)
SetWindowVol(AhkExe, TestVolume)
SoundPlay, %TestSound%
Return

testnoticationInfluence:
Gui, Sounds:Submit, NoHide
IniRead, TestSound, Resources\Settings\notification.ini, Sounds, Influence
TestVolume = %NotiEditInfluence%
SoundPlay, Resources\Sounds\blank.wav ;;;;; super hacky workaround but works....
SetTitleMatchMode, 2
WinGet, AhkExe, ProcessName, Sounds
SetTitleMatchMode, 1
SetWindowVol(AhkExe, 0)
SetWindowVol(AhkExe, TestVolume)
SoundPlay, %TestSound%
Return