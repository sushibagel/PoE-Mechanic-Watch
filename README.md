# PoE-Mechanic-Watch
AHK Script that watches the Path of Exile Client.txt and warns the user to complete certain mechanics. 

This program is a AutoHotKey Script. AutoHotKey can be downloaded for free here: https://www.autohotkey.com/

The purpose of this program is for use with Path Of Exile to assist in tracking and reminding the user of completing their Metamorph and Ritual mechanics in game. 

I am in no way affiliated with Grinding Gear Games, the developers of AutoHotkey or the writer of the tf.ahk library. I am in no ways responsible if this script bricks your computer, causes errors or results in a ban in Path of Exile. 

This program works by setting an overlay in Path of Exile, when one of the overlay icons are pressed the script then begins continuously reading your Client.txt log file looking for a line stating that you have entered your hideout. Once the text is found in your log file a notification is triggered reminding you to complete the mechanic that you have turned on monitoring for, Clicking "Yes!" will close the notificaiton and begin reading your logs again, clicking "No" will turn off the reminder script resetting the overlay. Clicking the overlay icon a second time will also turn the reminder script off and reset the overlay. 

You can reposition the overlay to your liking by right clicking the script icon in your System Tray and selecting "Move Overlay" once positioned to your liking click "Lock" and the the overlay position will be remembered. You can also change the overlay position by changing the coordinates in the "overlayposition.txt" and restarting the script.

Influenced map tracking for the Searing Exarch and Eater of Worlds mechanics will happen automatically. Upon entering a map the counter will be ticked and a message displayed, the counter can be decreased using a hotkey (programmable) and increased by clicking on the icon. 
The Hotkey can be changed using the "Change Hotkey" tray menu option.

Auto mechanic tracking for Blight, Expedition and Incursion can be enabled in a seperate menu. This feature requires the "Output Dialogue To Chat" setting turned on in the "UI" section of the settings in game. Incursion reminders are only disabled after the 3rd encounter. Please note this feature depends on NPC dialogs, due to dialogs being random it may not be 100% reliable. 

Installation:
To run this script you MUST have AutoHotKey installed. https://www.autohotkey.com/

The first time your run this script you MUST set your hideout type. This can be done in two ways: First by right clicking the script icon in the System Tray and selecting "Set Hideout" use the search box to find the hideout type you use,  double clicking the name of your hideout or typing in the full hideout name and pressing enter will set your hideout. Note: If you hideout is not listed you can type in your hideout and press enter. However, any typos can result in the script not working as expected. Alternatively, you can edit the "CurrentHideout.txt" file Note: this method is not preffered, any typos, or formatting errors can cause the script to not work correctly. 

Download and unzip the program. Double-click "PoE Mechanic Watch.ahk" to run the program. 
Please note, it must be run from within a folder containing all the assets and files that are contained in the zip. 

Troubleshooting: 
Please make sure that your AutoHotKey is up-to-date. 

Make sure you've set your hideout using the "Set Hideout" button on the System Tray menu. Any typos may result in failure for the script to display a reminder. 

You may need to delete your "Client.txt" file and restart your game. The reason for this is that is your "Client.txt" it can cause problems with reading the file. 

Make sure that you are running the script from within a folder containing all of the original assets of the program. 

If at any time the script freezes right click the icon in the System Tray and click "Reload". This will restart the script and in many cases resolve any problems. 

If clicking the "View Log" button isn't taking you to the correct path, this is likely due to because you opened the script prior to having your client open. Once your client is open click the "Reload" button and it should work as expected. 

To update simply copy all the files from the new release folder into your existing directy. Doing this should keep all user settings.

The Auto Enable/Disable feature is currently in Beta. For it to work it requires the "Output Dialogue To Chat" setting to be turned on in the "UI" section of the settings in game. I've tried to be as thorough as possible in adding dialogs but I may have missed some as there is some variance in the.

For the "Launch Path of Exile" tray menu command to work properly, the game must be launched at least once with this tool running first. 

For feedback, questions or suggestions please visit the <a href="https://github.com/sushibagel/PoE-Mechanic-Watch/discussions" title="Discussion Section"> of the Github. 

Additional Notes: 
New hideouts can be added to the Hideout menu by editing the "HideoutList.txt" and typing in the hideout name on a new line. 

Credits:
Thank you to Griding Gear Games the developers of Path of Exile
Thank you to hi5 and the allowed use of the tf.ahk autohotkey library. https://github.com/hi5/TF
Thank you to reddit user "evilC_UK" for the sample code used to more efficiently read the log files. 
Thank you to the developers of AutoHotKey. https://www.autohotkey.com/
Thanks to user "mshall" on the AutoHotKey forums for the base code for the updater. 
Thanks to user "jaco0646" for the code for the Hotkey Selector posted on the AutoHotKey forums. 
Thanks to user "masonjar13" on the AutoHotKey forums for the Volume Adjust "VA" library used in the volume control settings. 
The speaker icon was found at <a href="https://www.flaticon.com/free-icons/speaker" title="speaker icons">Speaker icons created by Pixel perfect - Flaticon</a>
The play button was found at <a href="https://www.flaticon.com/free-icons/play" title="play icons">Play icons created by Freepik - Flaticon</a>

Donations: 
There are no obligations for anyone to donate but if you wish to you can here: [PayPal](https://www.paypal.com/paypalme/Drew149).

![Overlay](https://github.com/sushibagel/PoE-Mechanic-Watch/blob/main/Screenshots/Overlay.jpg?raw=true)

![Overlay Active](https://github.com/sushibagel/PoE-Mechanic-Watch/blob/main/Screenshots/Overlay%20Active.jpg?raw=true)

![Move Overlay](https://github.com/sushibagel/PoE-Mechanic-Watch/blob/main/Screenshots/Move%20Overlay.jpg?raw=true)

![Theme Selector](https://github.com/sushibagel/PoE-Mechanic-Watch/blob/main/Screenshots/Theme%20Selector.png?raw=true)

![Tray Menu](https://github.com/sushibagel/PoE-Mechanic-Watch/blob/main/Screenshots/Tray%20Menu.jpg?raw=true)

See Auto-Mechanic Tracking in action (Click Image Below)
[![Video Link](https://github.com/sushibagel/PoE-Mechanic-Watch/blob/main/Screenshots/Video%20Snap.jpg?raw=true)](https://youtu.be/kMowzpj714A)
