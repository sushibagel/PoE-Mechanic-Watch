# PoE-Mechanic-Watch
AHK Script that watches the Path of Exile Cleint.txt and warns the user to complete certain mechanics. 

This program is a AutoHotKey Script. AutoHotKey can be downloaded for free here: https://www.autohotkey.com/

The purpose of this program is for use with Path Of Exile to assist in tracking and reminding the user of completing their Metamorph and Ritual mechanics in game. 

I am in no way affiliated with Grinding Gear Games, the developers of AutoHotkey or the writer of the tf.ahk library. I am in no ways responsible if this script bricks your computer, causes errors or results in a ban in Path of Exile. 

This program works by setting an overlay in Path of Exile, when one of the overlay icons are pressed the script then begins continuously reading your Client.txt log file looking for a line stating that you have entered your hideout. Once the text is found in your log file a notification is triggered reminding you to complete the mechanic that you have turned on monitoring for, Clicking "Yes!" will close the notificaiton and begin reading your logs again, clicking "No" will turn off the reminder script resetting the overlay. Clicking the overlay icon a second time will also turn the reminder script off and reset the overlay. 

You can reposition the overlay to your liking by right clicking the script icon in your System Tray and selecting "Move Overlay" once positioned to your liking click "Lock" and the the overlay position will be remembered. You can also change the overlay position by changing the coordinates in the "overlayposition.txt" and restarting the script.

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

Additional Notes: 
New hideouts can be added to the Hideout menu by editing the "HideoutList.txt" and typing in the hideout name on a new line. 

Credits:
Thank you to Griding Gear Games the developers of Path of Exile
Thank you to hi5 and the allowed use of the tf.ahk autohotkey library. https://github.com/hi5/TF
Thank you to the developers of AutoHotKey. https://www.autohotkey.com/
