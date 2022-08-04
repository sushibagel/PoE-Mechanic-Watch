#NoTrayIcon
#SingleInstance force

StringTrimRight, UpOneLevel, A_ScriptDir, 7
StringTrimRight, UpTwoLevels, UpOneLevel, 10

IniRead, ColorMode, %UpOneLevel%Settings/Theme.ini, Theme, Theme
IniRead, Font, %UpOneLevel%Settings/Theme.ini, %ColorMode%, Font
IniRead, Background, %UpOneLevel%Settings/Theme.ini, %ColorMode%, Background
IniRead, Secondary, %UpTwoLevels%Settings/Theme.ini, %ColorMode%, Secondary

FileRead, Changelog, %UpTwoLevels%changelog.txt
Gui, Changelog:-Border
Gui, Changelog:Color, %Background%
Gui, Changelog:-Caption
Gui, Changelog:Font, c%Font% s10
Gui, Changelog:Add, Text, +Wrap w860, %Changelog%
Gui, Changelog:Add, Text, +Wrap w860, For the latest version use the "Check for Update" menu item or visit:
Gui, Changelog:Font, underline
Gui, Changelog:Add, Text, gVisitGithub c568ca1, https://github.com/sushibagel/PoE-Mechanic-Watch/releases
Gui, Changelog:Add, Button,x830, OK
Gui, Changelog:Show,w885, Version
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