SelectTheme:

Gui, 5:-Border
Gui, 5:Color, %Secondary%
Gui, 5:-Caption
Gui, 5:Font, c%Font% s10
Gui, 5:Add, Button, x+10 yp+10 w90 h30, Dark Mode
Gui, 5:Add, Picture, yn y10 Section ,Resources/Images/Dark Theme/Dark Reminder.png
Gui, 5:Add, Picture, xs ,Resources/Images/Dark Theme/Dark Notification Selector.png
Gui, 5:Add, Picture, ys ,Resources/Images/Dark Theme/Dark Mechanic Selector.png
Gui, 5:Add, Picture, xs Section ,Resources/Images/Dark Theme/Dark Hotkey.png
Gui, 5:Add, Picture, yn y10 ,Resources/Images/Dark Theme/Dark Hideout Select.png
Gui, 5:Add, GroupBox, w900 h10 xn x10
Gui, 5:Add, Button, x10 y+10 w90 h30 Section , Light Mode
Gui, 5:Add, Picture, ys Section ,Resources//Images/Light Theme/Light Reminder.png
Gui, 5:Add, Picture, xs ,Resources/Images/Light Theme/Light Notification Selector.png
Gui, 5:Add, Picture, ys ,Resources/Images/Light Theme/Light Mechanic Selector.png
Gui, 5:Add, Picture, xs ,Resources/Images/Light Theme/Light Hotkey.png
Gui, 5:Add, Picture, ys ,Resources/Images/Light Theme/Light Hideout Select.png
Gui, 5:Show,,Gui:5
Return

5ButtonDarkMode:
Gui, 5:Destroy
IniWrite, Dark, Resources/Settings/Theme.ini, Theme, Theme
Gosub, CheckTheme
Return

5ButtonLightMode:
Gui, 5:Destroy
IniWrite, Light, Resources/Settings/Theme.ini, Theme, Theme
Gosub, CheckTheme
Return