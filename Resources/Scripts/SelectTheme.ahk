SelectTheme:
StringTrimRight, UpOneLevel, A_ScriptDir, 7

Gui, Theme:-Border
Gui, Theme:Color, %Background%
Gui, Theme:-Caption
Gui, Theme:Font, c%Font% s10
Gui, Theme:Add, Button,, Dark Mode
Gui, Theme:Add, Picture, w200 h100,%UpOneLevel%/Images/Dark Theme/Dark Reminder.jpg
Gui, Theme:Add, Picture,x215 y1 w200 h300,%UpOneLevel%/Images/Dark Theme/Dark Auto mechanics.jpg
Gui, Theme:Add, Picture,x420 y1 w200 h400,%UpOneLevel%/Images/Dark Theme/Dark Hideout Select.jpg
Gui, Theme:Add, Picture,x625 y1 w200 h400,%UpOneLevel%/Images/Dark Theme/Dark Mechanic Selector.jpg
Gui, Theme:Add, Picture, x10 y145 w200 h100,%UpOneLevel%/Images/Dark Theme/Dark Notification Selector.jpg
Gui, Theme:Add, Picture, x10 y320 w350 h80,%UpOneLevel%/Images/Dark Theme/Dark Hotkey.jpg
Gui, Theme:Show
Return