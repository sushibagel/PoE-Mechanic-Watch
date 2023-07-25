Global MasterOverlayLaunch
MapDevice()
{
    MasterOverlayLaunch = 0
    Loop
    {
        HideoutIni := HideoutIni()
        IniRead, HideoutStatus, %HideoutIni%, In Hideout, In Hideout, 0
        {
            If (HideoutStatus = 0)
                {
                    Break
                }
            Else
                {
                    If !WinActive("ahk_group PoeWindow")
                        {
                            WinWaitActive, ahk_group PoeWindow
                        }
                    gdipMapDevice := Gdip_Startup()
                    PoeHwnd2 := WinExist("ahk_class POEWindowClass")
                    bmpSearching := Gdip_BitmapFromHWND(PoeHwnd2, 1)
                    ImageLocation := "Resources\Images\Image Search\MapDevice.png"
                    SearchingFor := Gdip_CreateBitmapFromFile(ImageLocation)
                    If (Gdip_ImageSearch(bmpSearching,SearchingFor,LIST,0,0,0,0,150,,1,0) > 0)
                        {

                            If !WinExist("Master Reminder") and (MasterOverlayLaunch = 0)
                            {
                                LaunchMaster()
                            }
                        }
                    Else
                        {
                            If WinExist("Master Reminder")
                                {
                                    Gui, Master:Destroy
                                    Gui, ActivateBlocker:Destroy
                                }
                        }
                    Gdip_DisposeImage(bmpSearching)
                    DeleteObject(bmpSearching)
                    Gdip_DisposeImage(SearchingFor)
                    DeleteObject(SearchingFor)
                    Gdip_Shutdown(gdipMapDevice)
                }
        }
    }
}

LaunchMaster()
{
    CheckTheme()
    IniRead, Vertical, %NotificationIni%, Map Notification Position, Vertical
    IniRead, Horizontal, %NotificationIni%, Map Notification Position, Horizontal
    CheckTheme()
    Gui, Master:Color, %Background%
    Gui, Master:Font, c%Font% s10
    Gui, Master:+AlwaysOnTop -Border -Caption
    NotificationIni := NotificationIni()
    IniRead, NotificationY, %NotificationIni%, Master Notification Position, Vertical, 552
    IniRead, Notificationx, %NotificationIni%, Master Notification Position, Horizontal, 430
    IniRead, Notificationw, %NotificationIni%, Master Notification Position, Width, 300
    IniRead, Notificationh, %NotificationIni%, Master Notification Position, Height, 60
    Gui, Master:Show, y%NotificationY% x%Notificationx% h%Notificationh% w%Notificationw% NoActivate, Master Reminder
    WinSet, Transparent, 150, Master Reminder
    Gui, ActivateBlocker:Color, %Background%
    Gui, ActivateBlocker:Font, c%Font% s10
    Gui, ActivateBlocker:+AlwaysOnTop -Border -Caption
    IniRead, NotificationY, %NotificationIni%, Activation Blocker, Vertical, 870
    IniRead, Notificationx, %NotificationIni%, Activation Blocker, Horizontal, 560
    IniRead, Notificationw, %NotificationIni%, Activation Blocker, Width, 100
    IniRead, Notificationh, %NotificationIni%, Activation Blocker, Height, 35
    Gui, ActivateBlocker:Show, y%NotificationY% x%Notificationx% h%Notificationh% w%Notificationw% NoActivate, Activate Blocker
    WinSet, Transparent, 150, Activate Blocker
    OnMessage(0x201, "WM_LBUTTONDOWN")
    Return
}

WM_LBUTTONDOWN() 
    { ; move window
    ;-------------------------------------------------------------------------------
        If WinActive("Master Reminder")
            {
                CoordMode, Mouse, Screen
                MouseGetPos, MouseX, MouseY
                ControlClick, x%MouseX% y%MouseY%, ahk_class POEWindowClass
                MasterOverlayKill()
                MasterOverlayLaunch := 1
            }
    }

MasterOverlayKill()
{
    Gui, Master:Destroy
    Gui, ActivateBlocker:Destroy
}
