StringTrimRight, UpOneLevel, A_ScriptDir, 7
IniRead, 1ch, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Abyss
IniRead, 2ch, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Blight
IniRead, 3ch, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Breach
IniRead, 4ch, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Expedition
IniRead, 5ch, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Harvest
IniRead, 6ch, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Incursion
IniRead, 7ch, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Metamorph
IniRead, 8ch, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Ritual
IniRead, 9ch, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Generic
Gui, Add, Checkbox, vOneCB Checked%1ch%, Abyss 
Gui, Add, Checkbox, vTwoCB Checked%2ch%, Blight 
Gui, Add, Checkbox, vThreeCB Checked%3ch%, Breach 
Gui, Add, Checkbox, vFourCB Checked%4ch%, Expedition 
Gui, Add, Checkbox, vFiveCB Checked%5ch%, Harvest 
Gui, Add, Checkbox, vSixCB Checked%6ch%, Incursion 
Gui, Add, Checkbox, vSevenCB Checked%7ch%, Metamorph 
Gui, Add, Checkbox, vEightCB Checked%8ch%, Ritual 
Gui, Add, Checkbox, vNineCB Checked%9ch%, Generic 
Gui, Add, Button, x100 y155 w80 h20, OK
gui show
Return

ButtonOk: 
Gui, Submit, NoHide 
iniWrite, %OneCB%, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Abyss
iniWrite, %TwoCB%, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Blight
iniWrite, %ThreeCB%, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Breach
iniWrite, %FourCB%, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Expedition
iniWrite, %FiveCB%, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Harvest
iniWrite, %SixCB%, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Incursion
iniWrite, %SevenCB%, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Metamorph
iniWrite, %EightCB%, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Ritual
iniWrite, %NineCB%, %UpOneLevel%Settings\Mechanics.ini, Checkboxes, Generic
Gui, Destroy
ExitApp
Return