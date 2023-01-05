#SingleInstance force
Global IconColor := "C:\Users\drwsi\Documents\PoE Mechanic Watch\PoE-Mechanic-Watch\Resources\Images\volume white.png"
Global PlayColor := "C:\Users\drwsi\Documents\PoE Mechanic Watch\PoE-Mechanic-Watch\Resources\Images\play white.png"
Global StopColor := "C:\Users\drwsi\Documents\PoE Mechanic Watch\PoE-Mechanic-Watch\Resources\Images\stop white.png"
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
Global NotificationTran
Global MapTran
Global MechanicTran
Global InfluenceTran
Global MavenTran
Global SoundButtonChange
Global Font := "White"
Global Background := "4e4f53"
Global Secondary := "a6a6a6"
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
    If (ColorMode = "Dark")
    {
        IconColor = Resources/Images/volume white.png
        RefreshColor = Resources/Images/refresh white.png
        PlayColor = Resources/Images/play white.png
        StopColor = Resources/Images/stop white.png
    }
    If (ColorMode = "Light")
    {
        IconColor = Resources/Images/volume.png
        RefreshColor = Resources/Images/refresh.png
        PlayColor = Resources/Images/play.png
        StopColor = Resources/Images/stop.png
    }
    TransparencyFile := TransparencyIni()
    Gui, NotificationSettings:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
    Gui, NotificationSettings:Font, c%Font% s13 Bold
    Width := A_ScreenWidth*.42
    Width := Round(96/A_ScreenDPI*Width)
    BoxH := Round(96/A_ScreenDPI*43)
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
    PlayButton2 := Round(96/A_ScreenDPI*570)
    StopButton := Round(96/A_ScreenDPI*625)
    Edit2 := Round(96/A_ScreenDPI*665)
    Offset := Round(96/A_ScreenDPI*0)
    EditOffset := Round(96/A_ScreenDPI*1)
    ActiveOffset := Round(96/A_ScreenDPI*315)
    TextOffset := Round(96/A_ScreenDPI*14)
    MavenInvitations := Round(96/A_ScreenDPI*25)

    Gui, NotificationSettings:Add, Text, w%Width% +Center, Notification Settings
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font% s1
    Gui, NotificationSettings:Add, GroupBox, w%Width% +Center x0 h1
    Space = y+2
    Gui, NotificationSettings: -Caption
    
    ; Headings 
    Gui, NotificationSettings:Font, c%Font% s%fw1% Bold Underline
    Gui, NotificationSettings:Add, Text, xs x25 Section, Notification Type
    XOff := Round(96/A_ScreenDPI*50)
    Gui, NotificationSettings:Add, Text, x+%XOff% ys, Enabled
    XOff := Round(96/A_ScreenDPI*30)
    Gui, NotificationSettings:Add, Text, x+%XOff% ys, Sound Settings
    XOff := Round(96/A_ScreenDPI*45)
    Gui, NotificationSettings:Add, Text, x+%XOff% ys, Transparency Settings

    ; Sub Headings
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font% s%fw2%
    Gui, NotificationSettings:Add, Text, xs+%ActiveOffset% Section, Active
    XOff := Round(96/A_ScreenDPI*5)
    Gui, NotificationSettings:Add, Text, x+%XOff% ys, Sound
    Gui, NotificationSettings:Add, Text, x+%XOff% ys, Test
    XOff := Round(96/A_ScreenDPI*10)
    Gui, NotificationSettings:Add, Text, x+%XOff% ys, Volume
    XOff := Round(96/A_ScreenDPI*50)
    Gui, NotificationSettings:Add, Text, x+%XOff% ys, Test
    XOff := Round(96/A_ScreenDPI*20)
    Gui, NotificationSettings:Add, Text, x+%XOff% ys, Close
    Gui, NotificationSettings:Add, Text, x+%XOff% ys Section, Opacity
    XOff := Round(96/A_ScreenDPI*15)
    Gui, NotificationSettings:Add, Text, xs-1 ys+%XOff% Section, (0 to 255)

    ; Overlay Section
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Add, Text, xs y-2 x25, 
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font%
    Gui, NotificationSettings:Add, GroupBox, w%Box% +Center x5 h%Boxh%
    Gui, NotificationSettings:Font, c%Font% s%fw% Bold
    Gui, NotificationSettings:Add, Text, yp+%TextOffset% x25 Section, Overlay
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%Check1% Checked1 Disabled
    Gui, NotificationSettings:Add, Picture, gtest ys-%Offset% x%PlayButton2% w15 h15, %PlayColor%
    Gui, NotificationSettings:Add, Picture, gtest ys-%Offset% x%StopButton% w15 h15, %StopColor%
    Gui, NotificationSettings:Font, cBlack 
    IniRead, Value, %TransparencyFile%, Transparency, Overlay, 255
    Gui, NotificationSettings:Add, Edit, Center ys-%EditOffset% x%Edit2% h20 w50 vNotificationTran
    Gui, NotificationSettings:Add, UpDown, Range0-255, %Value% x270 h20  

; Map Notification Section
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font%
    Gui, NotificationSettings:Add, GroupBox, w%Box% +Center x5 h%Boxh%
    Gui, NotificationSettings:Font, c%Font% s%fw% Bold
    Gui, NotificationSettings:Add, Text, yp+%TextOffset% x25 Section, Map Notification
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%Check1% Checked1
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%Check2% Checked1
    Gui, NotificationSettings:Add, Picture, gSoundsButtonChange ys-%Offset% x%SpeakerButton% w15 h15, %IconColor%
    Gui, NotificationSettings:Add, Picture, gtest ys-%Offset% x%PlayButton% w15 h15, %PlayColor%
    Gui, NotificationSettings:Font, cBlack
    Gui, NotificationSettings:Color, Edit, %Secondary% -Caption -Border
    Gui, NotificationSettings:Add, Edit, Center ys-%Offset% x%Edit% h20 w50 vEdit3
    Gui, NotificationSettings:Add, UpDown, Range0-100, %ItemVolume% x270 h20  
    Gui, NotificationSettings:Add, Picture, gtest ys-%Offset% x%PlayButton2% w15 h15, %PlayColor%
    Gui, NotificationSettings:Add, Picture, gtest ys-%Offset% x%StopButton% w15 h15, %StopColor%
    IniRead, Value, %TransparencyFile%, Transparency, Map, 255
    Gui, NotificationSettings:Add, Edit, Center ys-%Offset% x%Edit2% h20 w50 vMapTran
    Gui, NotificationSettings:Add, UpDown, Range0-255, %Value% x270 h20  

; Mechanic Notification Section
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font%
    Gui, NotificationSettings:Add, GroupBox, w%Box% +Center x5 h%Boxh%
    Gui, NotificationSettings:Font, c%Font% s%fw% Bold
    Gui, NotificationSettings:Add, Text, yp+%TextOffset% x25 Section, Mechanic Notification
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%Check1% Checked1
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%Check2% Checked1
    Gui, NotificationSettings:Add, Picture, gSoundsButtonChange ys-%Offset% x%SpeakerButton% w15 h15, %IconColor%
    Gui, NotificationSettings:Add, Picture, gtest ys-%Offset% x%PlayButton% w15 h15, %PlayColor%
    Gui, NotificationSettings:Font, cBlacke
    Gui, NotificationSettings:Color, Edit, %Secondary% -Caption -Border
    Gui, NotificationSettings:Add, Edit, Center ys-%Offset% x%Edit% h20 w50 vEdit5
    Gui, NotificationSettings:Add, UpDown, Range0-100, %ItemVolume% x270 h20  
    Gui, NotificationSettings:Add, Picture, gtest ys-%Offset% x%PlayButton2% w15 h15, %PlayColor%
    Gui, NotificationSettings:Add, Picture, gtest ys-%Offset% x%StopButton% w15 h15, %StopColor%
    IniRead, Value, %TransparencyFile%, Transparency, Notification, 255
    Gui, NotificationSettings:Add, Edit, Center ys-%Offset% x%Edit2% h20 w50 vMechanicTran
    Gui, NotificationSettings:Add, UpDown, Range0-255, %Value% x270 h20 

; Influence Notification Section
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font%
    Gui, NotificationSettings:Add, GroupBox, w%Box% +Center x5 h%Boxh%
    Gui, NotificationSettings:Font, c%Font% s%fw% Bold
    Gui, NotificationSettings:Add, Text, yp+%TextOffset% x25 Section, Influence Notification
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%Check1% Checked1
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%Check2% Checked1
    Gui, NotificationSettings:Add, Picture, gSoundsButtonChange ys-%Offset% x%SpeakerButton% w15 h15, %IconColor%
    Gui, NotificationSettings:Add, Picture, gtest ys-%Offset% x%PlayButton% w15 h15, %PlayColor%
    Gui, NotificationSettings:Font, cBlack
    Gui, NotificationSettings:Color, Edit, %Secondary% -Caption -Border
    Gui, NotificationSettings:Add, Edit, Center ys-%Offset% x%Edit% h20 w50 vEdit7
    Gui, NotificationSettings:Add, UpDown, Range0-100, %ItemVolume% x270 h20  
    Gui, NotificationSettings:Add, Picture, gtest ys-%Offset% x%PlayButton2% w15 h15, %PlayColor%
    Gui, NotificationSettings:Add, Picture, gtest ys-%Offset% x%StopButton% w15 h15, %StopColor%
    IniRead, Value, %TransparencyFile%, Transparency, Influence, 255
    Gui, NotificationSettings:Add, Edit, Center ys-%Offset% x%Edit2% h20 w50 vInfluenceTran
    Gui, NotificationSettings:Add, UpDown, Range0-255, %Value% x270 h20 

; Maven Notification Section
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font%
    Gui, NotificationSettings:Add, GroupBox, w%Box% +Center x5 h%Boxheight%
    Gui, NotificationSettings:Font, c%Font% s%fw% Bold
    Gui, NotificationSettings:Add, Text, yp+%TextOffset% x25 Section, Maven Notification
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%Check1% Checked1
    Gui, NotificationSettings:Add, Checkbox, ys+%Offset% x%Check2% Checked1
    Gui, NotificationSettings:Add, Picture, gSoundsButtonChange ys-1 x%SpeakerButton% w15 h15, %IconColor%
    Gui, NotificationSettings:Add, Picture, gtest ys-%Offset% x%PlayButton% w15 h15, %PlayColor%
    Gui, NotificationSettings:Font, cBlack
    Gui, NotificationSettings:Color, Edit, %Secondary% -Caption -Border
    Gui, NotificationSettings:Add, Edit, Center ys-%Offset% x%Edit% h20 w50 vEdit9
    Gui, NotificationSettings:Add, UpDown, Range0-100, %ItemVolume% x270 h20  
    Gui, NotificationSettings:Add, Picture, gtest ys-%Offset% x%PlayButton2% w15 h15, %PlayColor%
    Gui, NotificationSettings:Add, Picture, gtest ys-%Offset% x%StopButton% w15 h15, %StopColor%
    IniRead, Value, %TransparencyFile%, Transparency, Maven, 255
    Gui, NotificationSettings:Add, Edit, Center ys-%Offset% x%Edit2% h20 w50 vMavenTran
    Gui, NotificationSettings:Add, UpDown, Range0-255, %Value% x270 h20 

    ; Invitation Stuff
    Gui, NotificationSettings:Font
    Gui, NotificationSettings:Font, c%Font% s%fw2%
    Gui, NotificationSettings:Add, Text, Section xs yp+%MavenInvitations%, The Formed Notification
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
    Gui, NotificationSettings:Color, %Background%
    Gui, NotificationSettings:Show, W%Width%, Notification Settings
  Return
}

NotificationSettingsButtonClose(){
    Gui, NotificationSettings:Destroy
}