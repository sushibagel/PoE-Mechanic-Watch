#NoTrayIcon
#SingleInstance force

StringTrimRight, UpOneLevel, A_ScriptDir, 7

IniRead, ColorMode, %UpOneLevel%Settings/Theme.ini, Theme, Theme
IniRead, Font, %UpOneLevel%Settings/Theme.ini, %ColorMode%, Font
IniRead, Background, %UpOneLevel%Settings/Theme.ini, %ColorMode%, Background
IniRead, Secondary, %UpOneLevel%Settings/Theme.ini, %ColorMode%, Secondary

FileReadLine, InstalledVersion, %UpOneLevel%Data/Version.txt, 1
Gui, Version:New,, Current Version
Gui, Version:-Border
Gui, Version:Color, %Background%
Gui, Version:-Caption
Gui, Version:Font, c%Font% s10
Gui, Version:Add, Text,, %InstalledVersion%
Gui, Version:Add, Text, +Wrap w360, For the latest version use the "Check for Update" menu item or visit:
Gui, Version:Font, underline
Gui, Version:Add, Text, gVisitGithub c568ca1, https://github.com/sushibagel/PoE-Mechanic-Watch/releases
Gui, Version:Add, Button,y110 x330, OK
Gui, Version:Show,w385 h150, Version
Return

VersionButtonOK:
VersionGuiClose:
ExitApp
Return

VisitGithub:
Gui, Version:Destroy
Run, https://github.com/sushibagel/PoE-Mechanic-Watch/releases
ExitApp
Return