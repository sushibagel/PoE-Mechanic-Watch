#SingleInstance force
Global Secondary := "White"
Global Background := "White"
Global Font := "Black"
Global IconColor := "C:\Users\drwsi\Documents\PoE Mechanic Watch\PoE-Mechanic-Watch\Resources\Images\volume.png"
Global PlayColor := "C:\Users\drwsi\Documents\PoE Mechanic Watch\PoE-Mechanic-Watch\Resources\Images\play.png"
Global StopColor := "C:\Users\drwsi\Documents\PoE Mechanic Watch\PoE-Mechanic-Watch\Resources\Images\stop.png"
Global Edit
Global Edit2
Global Edit3
Global Edit4
Global Edit5
Global Edit6
Global Edit7
Global Edit8
Global Edit9
Global Edit10
Global SoundButtonChange
Test()
{
    Exit
}
SoundsButtonChange()
{
    Exit
}
NotificationSetup()
Exit

NotificationSetup()
{
    Gui, NotificationSettings:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
    Gui, NotificationSettings:Font, c%Font% s13 Bold
    Width := A_ScreenWidth*.42
    Width := Round(96/A_ScreenDPI*Width)
    BoxH := Round(96/A_ScreenDPI*35)
    Box:= Width - Round(96/A_ScreenDPI*12)
    BoxHeight := Round(96/A_ScreenDPI*210)
    TW := Width - 20
    fw := Round(96/A_ScreenDPI*12)
    fw1 := Round(96/A_ScreenDPI*15)
    fw2 := Round(96/A_ScreenDPI*11)
    Check1 := Round(96/A_ScreenDPI*285)
    Check2 := Round(96/A_ScreenDPI*355)
    SpeakerButton := Round(96/A_ScreenDPI*400)
    PlayButton := Round(96/A_ScreenDPI*440)
    Edit := Round(96/A_ScreenDPI*470)
    PlayButton2 := Round(96/A_ScreenDPI*590)
    StopButton := Round(96/A_ScreenDPI*645)
    Edit2 := Round(96/A_ScreenDPI*695)

    Gui, NotificationSettings:Add, Text, w%Width% +Center, Notification Settings
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font% s1
    Gui, NotificationSettings:Add, GroupBox, w%Width% +Center x0 h1
    Space = y+2
    Gui, NotificationSettings: -Caption
    
    ; Headings 
    Gui, NotificationSettings:Font, c%Font% s%fw1% Bold Underline
    Gui, NotificationSettings:Add, Text, xs x25 Section, Notification Type
    Gui, NotificationSettings:Add, Text, x+50 ys, Enabled
    Gui, NotificationSettings:Add, Text, x+20 ys, Sound Settings
    Gui, NotificationSettings:Add, Text, x+40 ys, Transparency Settings

    ; Sub Headings
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font% s%fw2%
    Gui, NotificationSettings:Add, Text, xs+252 Section, Active
    Gui, NotificationSettings:Add, Text, x+5 ys, Sound
    Gui, NotificationSettings:Add, Text, x+5 ys, Test
    Gui, NotificationSettings:Add, Text, x+10 ys, Volume
    Gui, NotificationSettings:Add, Text, x+50 ys, Test
    Gui, NotificationSettings:Add, Text, x+20 ys, Close
    Gui, NotificationSettings:Add, Text, x+20 ys Section, Opacity
    Gui, NotificationSettings:Add, Text, xs-1 ys+15 Section, (0 to 100)

    ; Overlay Section
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Add, Text, xs y-2 x25, 
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font%
    Gui, NotificationSettings:Add, GroupBox, w%Box% +Center x5 h%Boxh%
    Gui, NotificationSettings:Font, cBlack s%fw% Bold
    Gui, NotificationSettings:Add, Text, yp+10 x25 Section, Overlay
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Add, Checkbox, ys+1 x%Check1% Checked1 Disabled
    ; Gui, NotificationSettings:Add, Checkbox, ys+1 x%Check2% Checked1
    ; Gui, NotificationSettings:Add, Picture, gSoundsButtonChange%Item% ys-1 x%SpeakerButton% w15 h15, %IconColor%
    ; Gui, NotificationSettings:Add, Picture, gtest%Item% ys-1 x%PlayButton% w15 h15, %PlayColor%
    ; Gui, NotificationSettings:Font, cWhite
    ; Gui, NotificationSettings:Color, Edit, %Secondary% -Caption -Border
    ; Gui, NotificationSettings:Add, Edit, Center ys-2 x%Edit% h20 w50 v%Item%Edit
    ; Gui, NotificationSettings:Add, UpDown, Range0-100, %ItemVolume% x270 h20  
    Gui, NotificationSettings:Add, Picture, gtest%Item% ys-1 x%PlayButton2% w15 h15, %PlayColor%
    Gui, NotificationSettings:Add, Picture, gtest%Item% ys-1 x%StopButton% w15 h15, %StopColor%
    Gui, NotificationSettings:Add, Edit, Center ys-2 x%Edit2% h20 w50 v%Item%Edit2
    Gui, NotificationSettings:Add, UpDown, Range0-100, %ItemVolume% x270 h20  

; Map Notification Section
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font%
    Gui, NotificationSettings:Add, GroupBox, w%Box% +Center x5 h%Boxh%
    Gui, NotificationSettings:Font, cBlack s%fw% Bold
    Gui, NotificationSettings:Add, Text, yp+10 x25 Section, Map Notification
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Add, Checkbox, ys+1 x%Check1% Checked1
    Gui, NotificationSettings:Add, Checkbox, ys+1 x%Check2% Checked1
    Gui, NotificationSettings:Add, Picture, gSoundsButtonChange%Item% ys-1 x%SpeakerButton% w15 h15, %IconColor%
    Gui, NotificationSettings:Add, Picture, gtest%Item% ys-1 x%PlayButton% w15 h15, %PlayColor%
    Gui, NotificationSettings:Font, cWhite
    Gui, NotificationSettings:Color, Edit, %Secondary% -Caption -Border
    Gui, NotificationSettings:Add, Edit, Center ys-2 x%Edit% h20 w50 v%Item%Edit3
    Gui, NotificationSettings:Add, UpDown, Range0-100, %ItemVolume% x270 h20  
    Gui, NotificationSettings:Add, Picture, gtest%Item% ys-1 x%PlayButton2% w15 h15, %PlayColor%
    Gui, NotificationSettings:Add, Picture, gtest%Item% ys-1 x%StopButton% w15 h15, %StopColor%
    Gui, NotificationSettings:Add, Edit, Center ys-2 x%Edit2% h20 w50 v%Item%Edit4
    Gui, NotificationSettings:Add, UpDown, Range0-100, %ItemVolume% x270 h20  

; Mechanic Notification Section
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font%
    Gui, NotificationSettings:Add, GroupBox, w%Box% +Center x5 h%Boxh%
    Gui, NotificationSettings:Font, cBlack s%fw% Bold
    Gui, NotificationSettings:Add, Text, yp+10 x25 Section, Mechanic Notification
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Add, Checkbox, ys+1 x%Check1% Checked1
    Gui, NotificationSettings:Add, Checkbox, ys+1 x%Check2% Checked1
    Gui, NotificationSettings:Add, Picture, gSoundsButtonChange%Item% ys-1 x%SpeakerButton% w15 h15, %IconColor%
    Gui, NotificationSettings:Add, Picture, gtest%Item% ys-1 x%PlayButton% w15 h15, %PlayColor%
    Gui, NotificationSettings:Font, cWhite
    Gui, NotificationSettings:Color, Edit, %Secondary% -Caption -Border
    Gui, NotificationSettings:Add, Edit, Center ys-2 x%Edit% h20 w50 v%Item%Edit5
    Gui, NotificationSettings:Add, UpDown, Range0-100, %ItemVolume% x270 h20  
    Gui, NotificationSettings:Add, Picture, gtest%Item% ys-1 x%PlayButton2% w15 h15, %PlayColor%
    Gui, NotificationSettings:Add, Picture, gtest%Item% ys-1 x%StopButton% w15 h15, %StopColor%
    Gui, NotificationSettings:Add, Edit, Center ys-2 x%Edit2% h20 w50 v%Item%Edit6
    Gui, NotificationSettings:Add, UpDown, Range0-100, %ItemVolume% x270 h20 

; Influence Notification Section
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font%
    Gui, NotificationSettings:Add, GroupBox, w%Box% +Center x5 h%Boxh%
    Gui, NotificationSettings:Font, cBlack s%fw% Bold
    Gui, NotificationSettings:Add, Text, yp+10 x25 Section, Influence Notification
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Add, Checkbox, ys+1 x%Check1% Checked1
    Gui, NotificationSettings:Add, Checkbox, ys+1 x%Check2% Checked1
    Gui, NotificationSettings:Add, Picture, gSoundsButtonChange%Item% ys-1 x%SpeakerButton% w15 h15, %IconColor%
    Gui, NotificationSettings:Add, Picture, gtest%Item% ys-1 x%PlayButton% w15 h15, %PlayColor%
    Gui, NotificationSettings:Font, cWhite
    Gui, NotificationSettings:Color, Edit, %Secondary% -Caption -Border
    Gui, NotificationSettings:Add, Edit, Center ys-2 x%Edit% h20 w50 v%Item%Edit7
    Gui, NotificationSettings:Add, UpDown, Range0-100, %ItemVolume% x270 h20  
    Gui, NotificationSettings:Add, Picture, gtest%Item% ys-1 x%PlayButton2% w15 h15, %PlayColor%
    Gui, NotificationSettings:Add, Picture, gtest%Item% ys-1 x%StopButton% w15 h15, %StopColor%
    Gui, NotificationSettings:Add, Edit, Center ys-2 x%Edit2% h20 w50 v%Item%Edit8
    Gui, NotificationSettings:Add, UpDown, Range0-100, %ItemVolume% x270 h20 

; Maven Notification Section
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font%
    Gui, NotificationSettings:Add, GroupBox, w%Box% +Center x5 h%Boxheight%
    Gui, NotificationSettings:Font, cBlack s%fw% Bold
    Gui, NotificationSettings:Add, Text, yp+10 x25 Section, Maven Notification
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Add, Checkbox, ys+1 x%Check1% Checked1
    Gui, NotificationSettings:Add, Checkbox, ys+1 x%Check2% Checked1
    Gui, NotificationSettings:Add, Picture, gSoundsButtonChange%Item% ys-1 x%SpeakerButton% w15 h15, %IconColor%
    Gui, NotificationSettings:Add, Picture, gtest%Item% ys-1 x%PlayButton% w15 h15, %PlayColor%
    Gui, NotificationSettings:Font, cWhite
    Gui, NotificationSettings:Color, Edit, %Secondary% -Caption -Border
    Gui, NotificationSettings:Add, Edit, Center ys-2 x%Edit% h20 w50 v%Item%Edit9
    Gui, NotificationSettings:Add, UpDown, Range0-100, %ItemVolume% x270 h20  
    Gui, NotificationSettings:Add, Picture, gtest%Item% ys-1 x%PlayButton2% w15 h15, %PlayColor%
    Gui, NotificationSettings:Add, Picture, gtest%Item% ys-1 x%StopButton% w15 h15, %StopColor%
    Gui, NotificationSettings:Add, Edit, Center ys-2 x%Edit2% h20 w50 v%Item%Edit10
    Gui, NotificationSettings:Add, UpDown, Range0-100, %ItemVolume% x270 h20 

    ; Invitation Stuff
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, cBlack s%fw2%
    Gui, NotificationSettings:Add, Text, Section xs x25, The Formed Notification
    Gui, NotificationSettings:Add, Checkbox, ys+1 x%Check1% Checked1
    Gui, NotificationSettings:Add, Text, Section xs x25, The Forgotten Notification
    Gui, NotificationSettings:Add, Checkbox, ys+1 x%Check1% Checked1
    Gui, NotificationSettings:Add, Text, Section xs x25, The Feared Notification
    Gui, NotificationSettings:Add, Checkbox, ys+1 x%Check1% Checked1
    Gui, NotificationSettings:Add, Text, Section xs x25, The Twisted Notification
    Gui, NotificationSettings:Add, Checkbox, ys+1 x%Check1% Checked1
    Gui, NotificationSettings:Add, Text, Section xs x25, The Hidden Notification
    Gui, NotificationSettings:Add, Checkbox, ys+1 x%Check1% Checked1
    Gui, NotificationSettings:Add, Text, Section xs x25, The Elderslayers Notification
    Gui, NotificationSettings:Add, Checkbox, ys+1 x%Check1% Checked1


  Gui, NotificationSettings:Font, c%Font% s1
  Gui, NotificationSettings:Add, GroupBox, w%Width% +Center x0 h1
  
  Gui, NotificationSettings:Font, c%Font% s10
  Gui, NotificationSettings:Add, Button, x20 w50, Close
  Gui, NotificationSettings:Show, W%Width%, Notification Settings
  Return
}

NotificationSettingsButtonClose(){
    Gui, NotificationSettings:Destroy
}


; Volume Part
NotificationTypes()
{
    Return, "Notification|Influence"
}