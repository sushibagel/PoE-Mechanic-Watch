#NoTrayIcon
#SingleInstance force

StringTrimRight, UpOneLevel, A_ScriptDir, 7
StringTrimRight, UpTwoLevels, UpOneLevel, 10

IniRead, ColorMode, %UpOneLevel%Settings/Theme.ini, Theme, Theme
IniRead, Font, %UpOneLevel%Settings/Theme.ini, %ColorMode%, Font
IniRead, Background, %UpOneLevel%Settings/Theme.ini, %ColorMode%, Background
IniRead, Secondary, %UpTwoLevels%Settings/Theme.ini, %ColorMode%, Secondary

FileRead, Changelog, %UpTwoLevels%changelog.txt
Gui, Changelog:Color, %Background%
Gui, Changelog:-Caption -Border +hwndVersionGui
Gui, Changelog:Font, c%Font% s10
Gui, Changelog:Add, Text, +Wrap w860, %Changelog%
Gui, Changelog:Add, Text, +Wrap w860, For the latest version use the "Check for Update" menu item or visit:
Gui, Changelog:Font, underline
Gui, Changelog:Add, Text, gVisitGithub c568ca1, https://github.com/sushibagel/PoE-Mechanic-Watch/releases
Gui, Changelog:Add, Button,x830, OK
;Gui, Changelog:Show,w885 h%Height%, Version
Global SG1 := New ScrollGUI(VersionGui, 800, 600, "+Resize +LabelGui1", 3, 4)
SG1.Show("ScrollGUI1", "y0 xcenter")
Return

ChangelogButtonOK:
ChangelogGuiClose:
ExitApp
Return

VisitGithub:
Gui, Version:Destroy
Run, https://github.com/sushibagel/PoE-Mechanic-Watch/releases
ExitApp
Return

#IncludeAgain Class_ScrollGUI.ahk