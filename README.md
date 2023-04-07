# PoE-Mechanic-Watch
AHK Script that watches the Path of Exile Client.txt and warns the user to complete certain mechanics. 

This program is a AutoHotKey Script. AutoHotKey can be downloaded for free here: https://www.autohotkey.com/

The purpose of this program is for use with Path Of Exile to assist in tracking and reminding the user of completing in game mechanics.   

This program works by setting an overlay in Path of Exile, when one of the overlay icons are pressed the script then begins continuously reading your Client.txt log file looking for a line stating that you have entered your hideout. Once the text is found in your log file a notification is triggered reminding you to complete the mechanic that you have turned on monitoring for, Clicking "Yes!" will close the notificaiton and begin reading your logs again, clicking "No" will turn off the reminder script resetting the overlay. Clicking the overlay icon a second time will also turn the reminder script off and reset the overlay. 

#### The following game mechanics are currently supported:  
- Abyss  
- Blight  
- Breach  
- Expedition  
- Harvest  
- Incursion  
- Legion
- Metamorph  
- Ritual  
- Searing Exarch/Eater of Worlds (Map Count Tracking)
- A "Generic" option is also available for those who desire a simplier interface or for use with other (future) league mechanics.  

#### Auto Mechanic Tracking:
For Blight, Expedition and Incursion Auto Mechanic Tracking can be enabled in a seperate menu. This feature ***requires*** the ***"Output Dialogue To Chat"*** setting turned on in the "UI" section of the settings in game. Incursion reminders are only disabled after the 3rd encounter. Please note this feature depends on NPC dialogs, due to dialogs being random it may not be 100% reliable.  

Influenced map tracking for the Searing Exarch and Eater of Worlds mechanics will happen automatically. Upon entering a map the counter will be ticked and a message displayed, the counter can be decreased using a hotkey (programmable) and increased by clicking on the icon. The Hotkey can be changed using the "Change Hotkey" tray menu option.  

##### Maven Tracking:
Maven Invitation Tracking for map bosses is done automatically. Maps will only be tracked if the map are meets the level requirement criteria (81+) and a Maven voiceline is detected. For non-map boss invitation tracking (The Formed, The Feared, The Twisted, The Hidden, The Elderslayer), auto tracking will not work for The Twisted (Elder Guardians) as there are no voicelines to detect and the zone can't be destiguished from the map zone. You can instead check/uncheck boxes for them. The checkboxes can be manually managed for all Invitations, unchecking a map will remove it from the list and reduce the total on the overlay. 

I have not tested Maven tracking extensively so there may be bugs. When I began this project I was excited to see the how Maven farming would feel with the new changes to Awakened Gem drops. Unforunately, (in my opinion) Maven still just doesn't feel very rewarding to farm so this resulted in minimal testing. This does not mean I refuse to work on it so please report any issues you notice. 

## Installation:  
To run this script you ***MUST*** have AutoHotKey installed. https://www.autohotkey.com/

Download and unzip the program. Double-click ***"Launcher.ahk"*** to run the program.  
Please note, it must be run from within a folder containing all the assets and files that are contained in the zip. 

## Usage: 
The first time you use this tool you will be greeting with a setup screen. This will walk you through initial setup.  

![Startup Tool](https://github.com/sushibagel/PoE-Mechanic-Watch/blob/main/Screenshots/Startup%20Tool.jpg?raw=true) 

Once setup while in game you have an overlay present with various images (one for each mechanic you've selected).  

![Overlay](https://github.com/sushibagel/PoE-Mechanic-Watch/blob/main/Screenshots/Overlay.jpg?raw=true)  

Clicking an image will activate tracking and display a red box around the image. Once active clicking the image again will deactivate it.  

![Overlay Active](https://github.com/sushibagel/PoE-Mechanic-Watch/blob/main/Screenshots/Overlay%20Active.jpg?raw=true)

If you enter your hideout with tracking active on any mechanics you will be greeted with a reminder message.  

![Notification](https://github.com/sushibagel/PoE-Mechanic-Watch/blob/main/Screenshots/Notification.jpg?raw=true)

If at any time you wish to change any settings this can be done by right clicking the Tray Menu Icon and choosing the desired menu item. 

![Tray Menu Icon](https://github.com/sushibagel/PoE-Mechanic-Watch/blob/main/Screenshots/Tray%20Menu%20Icon.jpg?raw=true)

![Tray Menu](https://github.com/sushibagel/PoE-Mechanic-Watch/blob/main/Screenshots/Tray%20Menu.jpg?raw=true)

#### Tray Menu Item Descriptions:  
- Select Mechanics - Allows you to select which mechanics will appear for tracking in your Overlay  
- Select Auto Enable/Disable - Allows you to select which mechanics will have auto enable/disable active. Please see the important information above about this feature. [Go to Auto Mechanic Information](#auto-mechanic-tracking)  
- Launch Path of Exile - This will launch your Path of Exile client along with anything you've setup to launch alongside it with the "Launch Assist" tool  
- View Path of Exile Log - Takes you to your Client.txt Log File  
- Setup - Takes you to the "Setup" sub menu   
- Reload - Reloads PoE Mechanic Tracking  
- Check for Updates - Manually check for updates. For more information on updating please see the Troubleshooting secton. [Go to Troubleshooting section](#troubleshooting)  
- Setup Menu - Display the "Setup Menu" that is shown the first time you run the tool   
- Set Hideout - Launches the Hideout selection tool. Please see the [hideout notes](#hideout-notes) below    
- Change Theme - Displays the Theme Selector Tool   
- Move Overlay - Allow you to reposition your overlay   
- Set Transparency - Launches the tool to set your transparency options for various overlays and notifications   
- Change Hotkey - Allows you to set your hotkey combination for removing a counted map from the influenced map counter and the Path of Exile launch tool    
- Sound Settings - Allows you to test/set your notification sounds and volume    
- Launch Assist - The launch assist tool allows you to select files/applications that you would like launched alongside you Path of Exile client when using your defined hotkey or the "Launch Path of Exile" tray menu item    

## Troubleshooting:  
- If you are receiving the following error when starting the script: "Call to nonexistent function: Specifically: SetWindowVol(AhkExe, NotificationVolume) Line 67" this is likely because you launched the "PoE Mechanic Watch.ahk" file. Please try again using the "Launcher.ahk" instead. 

- Please make sure that your AutoHotKey is up-to-date. 

- If notifications aren't being displayed when entering your hideout double check that you have the correct Hideout set. For more information on setting your hideout please view the [hideout notes](#hideout-notes) below. 

- If you've reset your hideout and are still not getting notifications you may need to delete your "Client.txt" file and restart your game. The reason for this is that if your "Client.txt" is too long it can cause problems with reading the file. 

- Make sure that you are running the script from within a folder containing all of the original assets of the program. 

- If at any time the script freezes right click the icon in the System Tray and click "Reload". This will restart the script and in many cases resolve any problems. 

- If clicking the "View Log" button isn't taking you to the correct path, this is likely because you opened the script prior to having your client open. Once your client is open click the "Reload" button and it should work as expected. 

- The Auto Enable/Disable feature is currently in Beta. For it to work it requires the "Output Dialogue To Chat" setting to be turned on in the "UI" section of the settings in game. I've tried to be as thorough as possible in adding dialogs but I may have missed some as there is some variance in the.

- For the "Launch Path of Exile" tray menu command to work properly, the game must be launched at least once with this tool running first. 

##### Updating:
When using the "Update" tool press "Enter" or select "OK" when you notified of an update. "PoE Mechanic Watch Update.zip" will download to your PoE Mechanic Watch folder, simply unzip and copy all the files from the new release folder into your existing directy. Doing this should keep all user settings.

#### Hideout Notes:  
The first time your run this script you will be required to set your hideout in the first run "Setup" menu. If at any time you switch your hideout you can change it by using the "Set Hideout" tool in the "Setup" submenu of the tray icon menu. Use the search box to find the hideout type you use,  double clicking the name of your hideout or typing in the full hideout name and pressing enter will set your hideout. Note: If you hideout is not listed you can type in your hideout and press enter. However, any typos can result in the script not working as expected.

For feedback, questions or suggestions please visit the <a href="https://github.com/sushibagel/PoE-Mechanic-Watch/discussions" title="Discussion Section">Discussion Section of the Github</a>  

## Credits:  
Thank you to Griding Gear Games the developers of Path of Exile  
Thank you to hi5 for the use of the tf.ahk autohotkey library. <a href="https://github.com/hi5/TF" title="tf library">Tf Library Github</a>  
Thank you to reddit user "evilC_UK" and cjsmiles999 on the AHK forums for the sample code used to more efficiently read the log files.   
Thank you to the developers of AutoHotKey. https://www.autohotkey.com/  
Thanks to user "mshall" on the AutoHotKey forums for the base code for the updater.  
Thanks to user "jaco0646" for the code for the Hotkey Selector posted on the AutoHotKey forums.  
Thanks to user "masonjar13" on the AutoHotKey forums for the Volume Adjust "VA" library used in the volume control settings.   
Thank you to user "just me" on the AutoHotKey forums for the Class_ScrollGUI.ahk script. https://github.com/AHK-just-me/Class_ScrollGUI/blob/master/Sources/Class_ScrollGUI.ahk)  
Thank you to user "Coco" on the AutoHotKey forums for sharing the OnWin.ahk library. https://www.autohotkey.com/boards/viewtopic.php?t=6463
The speaker icon was found at <a href="https://www.flaticon.com/free-icons/speaker" title="speaker icons">Speaker icons created by Pixel perfect - Flaticon</a>  
The play button was found at <a href="https://www.flaticon.com/free-icons/play" title="play icons">Play icons created by Freepik - Flaticon</a>  
The reload button was found at <a href="https://www.flaticon.com/free-icons/refresh" title="refresh icons">Refresh icons created by Gregor Cresnar - Flaticon</a>  
The stop button was found at <a href="https://www.flaticon.com/free-icons/forbidden" title="forbidden icons">Forbidden icons created by Freepik - Flaticon</a>  

I am in no way affiliated with Grinding Gear Games, the developers of AutoHotkey. I am in no ways responsible if this script bricks your computer, causes errors or results in a ban in Path of Exile. 

## Screenshots:
#### Move Overlay Tool: 

![Move Overlay](https://github.com/sushibagel/PoE-Mechanic-Watch/blob/main/Screenshots/Move%20Overlay.jpg?raw=true)

#### Theme Selector: 

![Theme Selector](https://github.com/sushibagel/PoE-Mechanic-Watch/blob/main/Screenshots/Theme%20Selector.png?raw=true)

#### See Auto-Mechanic Tracking in action (Click Image Below): 

[![Video Link](https://github.com/sushibagel/PoE-Mechanic-Watch/blob/main/Screenshots/Video%20Snap.jpg?raw=true)](https://youtu.be/kMowzpj714A)
