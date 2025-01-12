## PoE-Mechanic-Watch Status
Due to an operating system change and the inability to run Autohotkey I will no longer be maintaining PoE Mechanic Watch. 

For anyone intersted in running PoE Mechanic Watch for Path of Exile 2. I've received reports of being able to run it by adding the POE2.exe title to the "GroupAdd" commands for "PoeWindow" and "PoeOnly" 
Ex: GroupAdd("PoeWindow", "ahk_exe PathOfExile2.exe") Additionally, you'll want to set your hideout name either by manually adding or adding into the HideoutList.txt which can be found in the Resources/Data folder. This will allow it to show as a hidout in the selectable list. 

For anyone who wants to take over development and I'd happily allow that.

# PoE-Mechanic-Watch
AHK Script that helps track and warn the user to complete certain mechanics. 

This program is an AutoHotKey Script. AutoHotKey can be downloaded for free here: https://www.autohotkey.com/

The purpose of this program is for use with Path Of Exile to assist in tracking and reminding the user of completing in-game mechanics.   

This program works by setting an overlay in Path of Exile, when one of the overlay icons are pressed (or triggered) the script will then warn you if the mechanic hasn't been completed when your portal hotkey was pressed or when you enter your hideout. When a notification is triggered Clicking "Yes!" will close the notificaiton and you will be warned again if necessary, clicking "No" will turn off the reminder script resetting the overlay. Clicking the overlay icon a second time will also turn the reminder script off and reset the overlay. 

#### The following game mechanics are currently supported:  
- Abyss  
- Betrayal
- Blight  
- Breach  
- Einhar
- Expedition  
- Harvest  
- Incursion  
- Legion
- Niko
- Ritual  
- Ultimatum
- Searing Exarch/Eater of Worlds/Maven (Map Count Tracking)
- A "Generic" option is also available for those who desire a simpler interface or for use with other (future) league mechanics.   

#### Auto Mechanic Tracking:
Auto Mechanic Tracking is available for Betrayal, Blight, Einhar, Expedition, Incursion, Niko, Ritual, Ultimatum and the Eldritch bosses (Eater of Worlds, Searing Exarch and Maven).

Auto Tracking is done using several combinations of Dialogues, Optical Character Recognition (OCR) and Image Recognition. For Dialogue search to work it  ***requires*** the ***"Output Dialogue To Chat"*** setting to be turned on in the "UI" section of the settings in game. For OCR to function you ***must*** have the ***Quest Tracking*** setting enabled in game. Image recognition may require calibration to work. It's recommended to use it as is first before attempting to calibrate.

Influenced map tracking for the Searing Exarch and Eater of Worlds mechanics will happen automatically. Upon entering a map the counter will be ticked and a message displayed, the counter can be decreased using a hotkey (programmable) and increased by clicking on the icon, the counter can be reset by holding alt and right clicking the icon. The Hotkey to remove a counted map can be changed using the "Change Hotkey" tray menu option. 

With Eldritch Auto tracking enabled the tool will attempt to verify which mechanic is currently being, and can update the count within +/-2 of the current count if it's incorrect. Image recognition may require calibration but it is recommended to attempt to use it as is first before attempting to calibrate. Additionally, Eldritch Auto tracking can be updated using OCR by hovering over the Icons in the Map Device to display the counts. For more information on Eldritch Search please see the [v2.10 discussion thread](https://github.com/sushibagel/PoE-Mechanic-Watch/discussions/51).

Each mechanic has more information on how it's tracked in the Auto Enable/Disable menu. 

Note: If your favorite mechanic doesn't have Auto Mechanic tracking this is most likely because I haven't been able to find a reliable way to track it. I recommend considering setting a hotkey that can be easily pressed to trigger the mechanic. 

##### Maven Tracking:
Maven Invitation Tracking for map bosses is done automatically. Maps will only be tracked if the map meets the level requirement criteria (81+) and a Maven voice line is detected. For non-map boss invitation tracking (The Formed, The Feared, The Twisted, The Hidden, The Elderslayer), auto tracking will not work for The Twisted (Elder Guardians) as there are no voicelines to detect and the zone can't be destiguished from the map zone. You can instead check/uncheck boxes for them. The checkboxes can be manually managed for all Invitations, unchecking a map will remove it from the list and reduce the total on the overlay. 

I have not tested Maven tracking extensively so there may be bugs. When I began this project I was excited to see how Maven farming would feel with the new changes to Awakened Gem drops. Unfortunately, (in my opinion) Maven still just doesn't feel very rewarding to farm so this resulted in minimal testing. This does not mean I refuse to work on it so please report any issues you notice. 

## Other Features:
####  Launch tools:
-   Setup tools/applications that will launch alongside Path of Exile    

#### Custom Notification:
-   Allows you to set a custom message that is displayed each time you enter a map. The idea for this came from a community member and will most likely be useful as a reminder to turn on buffs such as Corrupting Fever or Blood Rage or to enable your "Reused at the end of this Flask’s effect" Flasks. This reminder is available as a permanent notification (that would need to be dismissed) or a temporary notification that would close once expired. To change how long the notification is shown for the temporary notification change the Quick Notification "Duration" setting in the "Notification Settings" panel. 

## Installation:  
To run this script you ***MUST*** have AutoHotKey v2 installed. https://www.autohotkey.com/ (Please note that v1 and v2 can be installed together). 

Download and unzip the program. Double-click ***"PoE Mechanic Watch.ahk"*** to run the program.  
Please note, that it must be run from within a folder containing all the assets and files that are contained in the zip. 

## Usage: 
The first time you use this tool you will be greeted with a setup screen. This will walk you through the initial setup.  

![Setup Tool](https://github.com/sushibagel/PoE-Mechanic-Watch/blob/v2-Development/Resources/Images/Screenshots/Dark%20Settings.png?raw=true) 

Once set up, while in the game you have an overlay present with various images (one for each mechanic you've selected).  

![Overlay](https://github.com/sushibagel/PoE-Mechanic-Watch/blob/v2-Development/Resources/Images/Screenshots/Overlay.png?raw=true)  

Clicking an image will activate tracking and display a red box around the image. Once active, clicking the image again will deactivate it.  

![Overlay Active](https://github.com/sushibagel/PoE-Mechanic-Watch/blob/main/Resources/Images/Screenshots/Overlay%20Active.png?raw=true)

If you enter your hideout with tracking active on any mechanics you will be greeted with a reminder message.  

![Notification](https://github.com/sushibagel/PoE-Mechanic-Watch/blob/v2-Development/Resources/Images/Screenshots/Dark%20Reminder.png?raw=true)

If at any time you wish to change any settings this can be done by right-clicking the Tray Menu Icon and choosing the desired menu item. 

![Tray Menu Icon](https://github.com/sushibagel/PoE-Mechanic-Watch/blob/main/Resources/Images/Screenshots/Tray%20Icon.png?raw=true)

![Tray Menu](https://github.com/sushibagel/PoE-Mechanic-Watch/blob/main/Resources/Images/Screenshots/Tray%20Menu.png?raw=true)

All "Counters" (Eater, Searing, Maven, Incursion) can be incremented by clicking them or reset with "Alt + Right Click" 

#### Tray Menu Item Descriptions:  
- Select Mechanics - Allows you to select which mechanics will appear for tracking in your Overlay  
- Select Auto Enable/Disable - Allows you to select which mechanics will have auto enable/disable active. Please see the important information above about this feature. [Go to Auto Mechanic Information](#auto-mechanic-tracking)  
- View Maven Invitation Status - Launches a window that allows you to view/manage the completion of the various Maven invitations.
- Master Mapping Settings - Launches the setup tool for the Master Mapping Reminder. 
- Launch Path of Exile - This will launch your Path of Exile client along with anything you've set to launch alongside it with the "Launch Assist" tool  
- View Path of Exile Log - Takes you to your Client.txt Log File  
- Setup - Takes you to the "Setup" sub-menu   
- Reload - Reloads PoE Mechanic Tracking  
- Check for Updates - Manually check for updates. For more information on updating please see the Troubleshooting section. [Go to Troubleshooting section](#troubleshooting)  
- Setup Menu - Display the "Setup Menu" that is shown the first time you run the tool   
- Set Hideout - Launches the Hideout selection tool. Please see the [hideout notes](#hideout-notes) below 
- Map Reminder Settings - Launches the setup tool for the Map Reminder. 
- Calibrate Search - Launches the image recognition setup tool. 
- Change Theme - Displays the Theme Selector Tool   
- Change Hotkey - Allows you to set your hotkey combination for various tasks. 
- Overlay Settings - Allows you to change the size, position, and orientation of the overlay.
- Move Overlay - Allows you to reposition your overlay 
- Move Quick Notification - Allows you to move the position of all quick notifications.
- Notification Settings - Allows you to toggle various notifications on/off. Toggle and set notification sound files and volume. Set the transparency of notifications and move/manage notifications.
- Launch Assist - The launch assist tool allows you to select files/applications that you would like launched alongside your Path of Exile client when using your defined hotkey or the "Launch Path of Exile" tray menu item   
- Tool Launcher - A set of shortcuts that can be used to launch various programs, tools, websites, etc. that you may wish to use while playing.
- Choose Settings File Location - Allows you to set the location you want your settings to be stored. This is useful if you wish to share settings between machines. 

## Troubleshooting:  
- If you are receiving the following error when starting the script: "Call to nonexistent function: Specifically: SetWindowVol(AhkExe, NotificationVolume) Line 67" this is likely because you launched the "PoE Mechanic Watch.ahk" file. Please try again using the "Launcher.ahk" instead. 

- If you are receiving the following error when starting the script: "Error: Function library not found"this is likely because you launched the "PoE Mechanic Watch.ahk" file. Please try again using the "Launcher.ahk" instead. 

- Please make sure that you have AutoHotKey version 1.1.36.02. This script is not yet compatible with version 2.0+.

- If notifications aren't being displayed when entering your hideout double-check that you have the correct Hideout set. For more information on setting your hideout please view the [hideout notes](#hideout-notes) below. 

- If you've reset your hideout and are still not getting notifications you may need to delete your "Client.txt" file and restart your game. The reason for this is that if your "Client.txt" is too long it can cause problems with reading the file. 

- Make sure that you are running the script from within a folder containing all of the original assets of the program. 

- If at any time the script freezes right click the icon in the System Tray and click "Reload". This will restart the script and in many cases resolve any problems. 

- If clicking the "View Log" button isn't taking you to the correct path, this is likely because you opened the script prior to having your client open. Once your client is open click the "Reload" button and it should work as expected. 

- Blight, Expedition or Incursion mechanics aren't automatically enabled/disabling. These mechanics all require the "Output Dialogue To Chat" setting to be turned on in the "UI" section of the settings in game. Please note there are some situations where certain dialogs aren't issued and it may result in a failure to enable/disable tracking. If you happen to find any dialogs that do not work as triggers please post a bug report on my Github. 

- If Auto tracking isn't working for Ritual or the Eldritch bosses (Eater of Worlds, Searing Exarch, and Maven) you may need to calibrate the image recognition using the "Calibrate Search" tool found in the Auto Enable/Disable menu.

- If OCR Auto Tracking isn't working verify that "Enable Quest Tracking" is enabled in the "UI" tab of the Options Menu in the game. 

- For the "Launch Path of Exile" tray menu command to work properly, the game must be launched at least once with this tool running first. 

##### Updating:
When using the "Update" tool press "Enter" or select "OK" when you are notified of an update. "PoE Mechanic Watch Update.zip" will download to your PoE Mechanic Watch folder, simply unzip and copy all the files from the new release folder into your existing directy. Doing this should keep all user settings.

#### Hideout Notes:  
The first time you run this script you will be required to set your hideout in the first-run "Setup" menu. If at any time you switch your hideout you can change it by using the "Set Hideout" tool in the "Setup" submenu of the tray icon menu. Use the search box to find the hideout type you use,  double clicking the name of your hideout or typing in the full hideout name and pressing enter will set your hideout. Note: If you hideout is not listed you can type in your hideout and press enter. However, any typos can result in the script not working as expected. Please also feel free to let me know your hideout type is missing by posting feedback on my Github. 

For feedback, questions or suggestions please visit the <a href="https://github.com/sushibagel/PoE-Mechanic-Watch/discussions" title="Discussion Section">Discussion Section of the Github</a>  

## Credits:  
Thank you to Grinding Gear Games the developers of Path of Exile  
Thank you to hi5 for the use of the tf.ahk autohotkey library. <a href="https://github.com/hi5/TF" title="tf library">Tf Library Github</a>  
Thank you to Reddit user "evilC_UK" and cjsmiles999 on the AHK forums for the sample code used to more efficiently read the log files.   
Thank you to the developers of AutoHotKey. https://www.autohotkey.com/  
Thanks to user "mshall" on the AutoHotKey forums for the base code for the updater.  
Thanks to user "jaco0646" for the code for the Hotkey Selector posted on the AutoHotKey forums.  
Thanks to user "masonjar13" on the AutoHotKey forums for the Volume Adjust "VA" library used in the volume control settings.   
Thank you to the user "just me" on the AutoHotKey forums for the Class_ScrollGUI.ahk script. https://github.com/AHK-just-me/Class_ScrollGUI/blob/master/Sources/Class_ScrollGUI.ahk)  
Thank you to user "Coco" on the AutoHotKey forums for sharing the OnWin.ahk library. https://www.autohotkey.com/boards/viewtopic.php?t=6463
Thank you to "Marius Șucan" for Gdip_All https://github.com/marius-sucan/AHK-GDIp-Library-Compilation
Thank you to "Masterfocus" for Gdip_ImageSearch https://github.com/MasterFocus/AutoHotkey/blob/master/Functions/Gdip_ImageSearch/Gdip_ImageSearch.ahk
The speaker icon was found at <a href="https://www.flaticon.com/free-icons/speaker" title="speaker icons">Speaker icons created by Pixel perfect - Flaticon</a>  
The play button was found at <a href="https://www.flaticon.com/free-icons/play" title="play icons">Play icons created by Freepik - Flaticon</a>  
The reload button was found at <a href="https://www.flaticon.com/free-icons/refresh" title="refresh icons">Refresh icons created by Gregor Cresnar - Flaticon</a>  
The stop button was found at <a href="https://www.flaticon.com/free-icons/forbidden" title="forbidden icons">Forbidden icons created by Freepik - Flaticon</a> 
The mimize icon was found at <a href="https://www.flaticon.com/free-icons/minus" title="minus icons">Minus icons created by Pixel perfect - Flaticon</a>
The close icon was found at <a href="https://www.flaticon.com/free-icons/close" title="close icons">Close icons created by Pixel perfect - Flaticon</a>

I am in no way affiliated with Grinding Gear Games, the developers of AutoHotkey. I am in no way responsible if this script bricks your computer, causes errors, or results in a ban in Path of Exile. 

## Screenshots:
#### Move Overlay Tool: 

![Move Overlay](https://raw.githubusercontent.com/sushibagel/PoE-Mechanic-Watch/main/Resources/Images/Screenshots/Move%20Overlay.png)


#### See Auto-Mechanic Tracking in action (Click Image Below): 

[![Video Link](https://github.com/sushibagel/PoE-Mechanic-Watch/blob/main/Resources/Images/Screenshots/Video%20Snap.jpg?raw=true)](https://youtu.be/kMowzpj714A)
