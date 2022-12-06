SelectTheme:

Gui, Theme:-Border
Gui, Theme:Color, %Secondary%
Gui, Theme:-Caption
Gui, Theme:Font, c%Font% s10
Gui, Theme:Add, Button, x+10 yp+10 w90 h30, Dark Mode
Gui, Theme:Add, Picture, yn y10 Section ,Resources/Images/Dark Theme/Dark Reminder.png
Gui, Theme:Add, Picture, xs ,Resources/Images/Dark Theme/Dark Notification Selector.png
Gui, Theme:Add, Picture, ys ,Resources/Images/Dark Theme/Dark Mechanic Selector.png
Gui, Theme:Add, Picture, xs Section ,Resources/Images/Dark Theme/Dark Hotkey.png
Gui, Theme:Add, Picture, yn y10 ,Resources/Images/Dark Theme/Dark Hideout Select.png
Gui, Theme:Add, GroupBox, w900 h10 xn x10
Gui, Theme:Add, Button, x10 y+10 w90 h30 Section , Light Mode
Gui, Theme:Add, Picture, ys Section ,Resources//Images/Light Theme/Light Reminder.png
Gui, Theme:Add, Picture, xs ,Resources/Images/Light Theme/Light Notification Selector.png
Gui, Theme:Add, Picture, ys ,Resources/Images/Light Theme/Light Mechanic Selector.png
Gui, Theme:Add, Picture, xs ,Resources/Images/Light Theme/Light Hotkey.png
Gui, Theme:Add, Picture, ys ,Resources/Images/Light Theme/Light Hideout Select.png
Gui, Theme:Show,,Gui:Theme
Return

ThemeButtonDarkMode:
Gui, Theme:Destroy
IniWrite, Dark, Resources/Settings/Theme.ini, Theme, Theme
Gosub, CheckTheme
Return

ThemeButtonLightMode:
Gui, Theme:Destroy
IniWrite, Light, Resources/Settings/Theme.ini, Theme, Theme
Gosub, CheckTheme
Return