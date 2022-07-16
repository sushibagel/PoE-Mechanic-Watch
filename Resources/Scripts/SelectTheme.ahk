SelectTheme:

Gui, 5:-Border
Gui, 5:Color, %Secondary%
Gui, 5:-Caption
Gui, 5:Font, c%Font% s10
Gui, 5:Add, Button, x10 w90 h30, Dark Mode
Gui, 5:Add, Picture, ,Resources//Images/Dark Theme/Dark Reminder.png
Gui, 5:Add, Picture,x320 y1,Resources//Images/Dark Theme/Dark Auto mechanics.png
Gui, 5:Add, Picture,x528 y1 ,Resources//Images/Dark Theme/Dark Hideout Select.png
Gui, 5:Add, Picture,x688 y1 ,Resources//Images/Dark Theme/Dark Mechanic Selector.png
Gui, 5:Add, Picture, x10 y145 ,Resources//Images/Dark Theme/Dark Notification Selector.png
Gui, 5:Add, Picture, x10 y260 ,Resources//Images/Dark Theme/Dark Hotkey.png
GuiDrawLine(20,360,900,1,5)
Gui, 5:Font, c%Font% s10
Gui, 5:Add, Button, x10 w90 h30, Light Mode
Gui, 5:Add, Picture, x10 y410,Resources//Images/Light Theme/Light Reminder.png
Gui, 5:Add, Picture,x320 y370,Resources//Images/Light Theme/Light Auto mechanics.png
Gui, 5:Add, Picture,x528 y370 ,Resources//Images/Light Theme/Light Hideout Select.png
Gui, 5:Add, Picture,x688 y370 ,Resources//Images/Light Theme/Light Mechanic Selector.png
Gui, 5:Add, Picture, x10 y515 ,Resources//Images/Light Theme/Light Notification Selector.png
Gui, 5:Add, Picture, x10 y635 ,Resources//Images/Light Theme/Light Hotkey.jpg
Gui, 5:Show,,Gui:5
Return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GuiDrawLine(X,Y,Size,VH="",Guin="") {
If (Guin="" OR Guin<1 OR Guin>99)
    Guin=1

If VH=
   VH=1

Size+=4

Gui, %Guin%:Font, S1

if VH
   Gui, %Guin%:Add, Text, x%X% y%Y% w%Size% 0x10
Else
   Gui, %Guin%:Add, Text, x%X% y%Y% h%Size% 0x11

Gui, %Guin%:Font, S
Return errorlevel
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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