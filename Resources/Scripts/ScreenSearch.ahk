#SingleInstance, force
#Persistent
#NoEnv
#MaxMem 1024
; #NoTrayIcon
Menu, Tray, Icon, C:\Users\drwsi\Downloads\7039_exe_hardware_hospital_install_installer_icon.png

Global ScreenSearchMechanics := "Metamorph|Ritual"
Global MySearches

#Include <Gdip_All>
#Include <Gdip_ImageSearch>

GroupAdd, PoeWindow, ahk_exe PathOfExileSteam.exe
GroupAdd, PoeWindow, ahk_exe PathOfExile.exe 
GroupAdd, PoeWindow, ahk_exe PathOfExileEGS.exe
GroupAdd, PoeWindow, ahk_class POEWindowClass
                            
OnExit("ExitScript") 

MechanicsIni := MechanicsIni()
SearchMechanics := StrSplit(ScreenSearchMechanics, "|")
MechanicCount := SearchMechanics.MaxIndex()
Loop, %MechanicCount% ;Check if any Screen Searches are active before enabling the timer. I'm not setting the search variables here because I don't want to activate the timer twice. 
    {
        IniRead, ActiveCheck, %MechanicsIni%, Auto Mechanics, % SearchMechanics[A_Index], 0
        If (ActiveCheck = 1)
            {
                IniRead, ActiveCheck,  %MechanicsIni%, Mechanics, % SearchMechanics[A_Index], 0 ; Now check that the mechanic tracking is enabled for the overlay. 
                If (ActiveCheck = 1)
                    {
                        WriteBitmaps()
                        GdipClean()
                        SetTimer, ScreenCheck, 1000
                        ; SetTimer, Restart, 180000
                        Break
                    }
            }
    }

ScreenCheck()
{
    MySearches := GetSearches()
    ;begin actual search
    gdipToken := Gdip_Startup()
    PoeHwnd := WinExist("ahk_group PoeWindow")
    bmpHaystack := Gdip_BitmapFromHWND(PoeHwnd, 1)
    ScreenIni := ScreenIni()
    IniWrite, %bmpHaystack%, %ScreenIni%, Bitmaps, HayStackImage
    Gdip_DisposeImage(bmpHaystack)
    MySearches := GetSearches()
    gdipToken := Gdip_Startup()
    MySearches := StrSplit(MySearches, "|")
    LoopCount := MySearches.MaxIndex()
    Loop, %LoopCount%
        {
            ThisSearch := % MySearches[A_Index]
            If InStr(ThisSearch, "Metamorph")
                {
                    ThisSection := "Metamorph Track"
                    If (ThisSearch = "MetamorphAssem")
                        {
                            CurrentSearch := "Status"
                        }
                    If (ThisSearch = "MetamorphIcon")
                        {
                            CurrentSearch := "Icon Status"
                        }
                }
            If InStr(ThisSearch, "Ritual")
                {
                    ThisSection := "Ritual Track"
                    CurrentSearch := ThisSearch
                    If (ThisSearch = "RitualShop")
                        {
                            CurrentSearch := "Status"
                        }
                }
            MechanicsIni := MechanicsIni()
            IniRead, ThisSearchActive, %MechanicsIni%, %ThisSection%, %CurrentSearch%
            If (ThisSearchActive = 1)
            {
                ScreenIni := ScreenIni()
                IniRead, ThisSearch1, %ScreenIni%, Bitmaps, %ThisSearch%
                IniRead, bmpHaystack, %ScreenIni%, Bitmaps, HayStackImage
                If (Gdip_ImageSearch(bmpHaystack,ThisSearch1,LIST,,0,0,0,30,0xFFFFFF,1,0) > 0)
                    {     
                        If InStr(ThisSearch, "Assem")
                            {
                                MechanicsIni := MechanicsIni()
                                IniRead, isActive, %MechanicsIni%, Mechanic Active, Metamorph
                                If (isActive = 1)
                                    {
                                        IniWrite, 0, %MechanicsIni%, Mechanic Active, Metamorph
                                        IniWrite, 0, %MechanicsIni%, Metamorph Track, Status ;Shut screen search off for metamorph until next map. Toggled back on on in the Tail.ahk script
                                        IniWrite, 1, %MechanicsIni%, Metamorph Track, Icon Status ;Toggle Icon search on. 
                                        RefreshOverlay()
                                        GdipClean()
                                        Break
                                    }
                            }
                        If InStr(ThisSearch, "Shop")
                            {
                                MechanicsIni := MechanicsIni()
                                IniRead, isActive, %MechanicsIni%, Mechanic Active, Ritual
                                If (isActive = 1)
                                    {
                                        IniWrite, 0, %MechanicsIni%, Mechanic Active, Ritual
                                        IniWrite, 0, %MechanicsIni%, Ritual Track, Status ;Shut screen search off for ritual until next map. Toggled back on by the "Tail.ahk" script. 
                                        RefreshOverlay()
                                        GdipClean()
                                        Break
                                    }
                            }
                        
                        If InStr(ThisSearch, "MetamorphIcon")
                            {
                                MechanicsIni := MechanicsIni()
                                IniRead, iconStatus, %MechanicsIni%, Metamorph Track, Icon Status, 0
                                If (iconStatus = 1)
                                    {
                                        IniWrite, 1, %MechanicsIni%, Mechanic Active, Metamorph
                                        IniWrite, 0, %MechanicsIni%, Metamorph Track, Icon Status ;Shut screen search off for metamorph the metamorph icon. Toggled back on by aseembly screen
                                        RefreshOverlay()
                                    }
                                GdipClean()
                                Break
                            }

                        If InStr(ThisSearch, "RitualCount")
                            {
                                MechanicsIni := MechanicsIni()
                                IniRead, iconStatus, %MechanicsIni%, Ritual Track, %ThisSearch%, 0
                                If (iconStatus = 1)
                                    {
                                        IniWrite, 1, %MechanicsIni%, Mechanic Active, Ritual
                                        IniWrite, 1, %MechanicsIni%, Ritual Track, RitualCount13 ;Toggle on all the ritual trackers except the one that triggered. 
                                        IniWrite, 1, %MechanicsIni%, Ritual Track, RitualCount23
                                        IniWrite, 1, %MechanicsIni%, Ritual Track, RitualCount33
                                        IniWrite, 1, %MechanicsIni%, Ritual Track, RitualCount14
                                        IniWrite, 1, %MechanicsIni%, Ritual Track, RitualCount24
                                        IniWrite, 1, %MechanicsIni%, Ritual Track, RitualCount34
                                        IniWrite, 1, %MechanicsIni%, Ritual Track, RitualCount44
                                        IniWrite, 0, %MechanicsIni%, Ritual Track, %ThisSearch% ;Shut screen search off for the triggering ritual. Toggled back on as we go
                                        RitualCount := StrSplit(ThisSearch, "RitualCount")
                                        RitualCount := SubStr(RitualCount[2], 1, 1) "/" SubStr(RitualCount[2], 0, 1)
                                        IniWrite, %RitualCount%, %MechanicsIni%, Ritual Track, Count
                                        RefreshOverlay()
                                        If (RitualCount = "3/3") or (RitualCount = "4/4")
                                            {
                                                QuickNotify()
                                            }
                                    }
                                    GdipClean()
                                    Break
                            }
                    }  
            } 
    }
}
Return

WriteBitmaps()
{
    MySearches := GetSearches()
    gdipToken := Gdip_Startup()
    MySearches := StrSplit(MySearches, "|")
    LoopCount := MySearches.MaxIndex()
    Loop, %LoopCount% ; Get all image locations
        {
            PngSearch := MySearches[A_Index]
            PngLocation := "Resources\Images\Image Search\" MySearches[A_Index] ".png"
            %PngSearch% := Gdip_CreateBitmapFromFile(PngLocation)
            BitmapData := %PngSearch%
            ScreenIni := ScreenIni()
            IniWrite, %BitmapData%, %ScreenIni%, Bitmaps, %PngSearch%
        }
}

GetSearches()
{
    MechanicsIni := MechanicsIni()
    SearchMechanics := StrSplit(ScreenSearchMechanics, "|")
    MechanicCount := SearchMechanics.MaxIndex()
    MySearches := ""
    Loop, %MechanicCount% ;Check which screen search mechanics are active and set each of their mechanics to a global for searching. 
        {
            IniRead, ActiveCheck, %MechanicsIni%, Auto Mechanics, % SearchMechanics[A_Index], 0
            If (ActiveCheck = 1)
                {
                    IniRead, ActiveCheck,  %MechanicsIni%, Mechanics, % SearchMechanics[A_Index], 0 ; Now check that the mechanic tracking is enabled for the overlay.
                    CurrentSearch := SearchMechanics[A_Index] " Track"
                    IniRead, TrackerCheck,  %MechanicsIni%, %CurrentSearch%, Status, 0 ; Check the status of the mechanic tracker 
                    If (ActiveCheck = 1) and (TrackerCheck = 1)
                        {
                            If !(MySearches = "")
                                {
                                    CurrentSearch := % SearchMechanics[A_Index] "Search"
                                    MySearches := MySearches "|" %CurrentSearch%()
                                }
                            If (MySearches = "")
                                {
                                   CurrentSearch := % SearchMechanics[A_Index] "Search"
                                   MySearches := %CurrentSearch%()
                                }
                        }
                }
        }
    Return, %MySearches%
}
DestroySearchGui:
{
    Gui, ScreenSearch:Destroy
    SetTimer, DestroySearchGui, Off
    Return
}

ExitScript()
{
    GdipClean()
    Return
}

RefreshOverlay()
{
	PostSetup()
    PostMessage, 0x01111,,,, PoE Mechanic Watch.ahk - AutoHotkey
	PostRestore()
}

PostSetup()
{
    Prev_DetectHiddenWindows := A_DetectHiddenWIndows
    Prev_TitleMatchMode := A_TitleMatchMode
    SetTitleMatchMode 2
    DetectHiddenWindows On
}

PostRestore()
{
    DetectHiddenWindows, %Prev_DetectHiddenWindows%
    SetTitleMatchMode, %A_TitleMatchMode%
}

MetamorphSearch()
{
    Return, "MetamorphAssem|MetamorphIcon"
}

RitualSearch()
{
    Return, "RitualShop|RitualCount23|RitualCount33|RitualCount24|RitualCount34|RitualCount44|RitualCount13|RitualCount14"
}

GdipClean()
{
    Gdip_DisposeImage(bmpHaystack)
    Gdip_DisposeImage(MetamorphAssem)
    Gdip_DisposeImage(MetamorphIcon)
    Gdip_DisposeImage(RitualIcon)
    Gdip_DisposeImage(RitualCount13)
    Gdip_DisposeImage(RitualCount23)
    Gdip_DisposeImage(RitualCount33)
    Gdip_DisposeImage(RitualShop)
    Gdip_DisposeImage(RitualCount14)
    Gdip_DisposeImage(RitualCount24)
    Gdip_DisposeImage(RitualCount34)
    Gdip_DisposeImage(RitualCount23)
    Gdip_DisposeImage(RitualCount44)
}

QuickNotify()
{
    Gui, Quick:Destroy
    NotificationIni := NotificationIni()
    IniRead, Vertical, %NotificationIni%, Map Notification Position, Vertical
    IniRead, Horizontal, %NotificationIni%, Map Notification Position, Horizontal
    ThemeIni := ThemeIni()
    IniRead, Theme, %ThemeIni%, Theme, Theme
    IniRead, Background, %ThemeIni%, %Theme%, Background
    IniRead, Background, %ThemeIni%, %Theme%, Font
    Gui, Quick:Color, %Background%
    Gui, Quick:Font, c%Font% s10
    ShowTitle := "-0xC00000"
    ShowBorder := "-Border"
    Gui, Quick:Add, Text,,You just completed your Final Ritual, Don't forget to get your rewards. 
    Gui, Quick: +AlwaysOnTop %ShowBorder%
    Notificationpath := NotificationIni()
    IniRead, Active, %NotificationPath%, Active, Quick, 1
    If (Active = 1)
    {
        Gui, Quick:Show, NoActivate x%Horizontal% y%Vertical%, Quick Notify
        TransparencyIniPath := TransparencyIni()
        IniRead, NotificationTransparency, %TransparencyIniPath%, Transparency, Quick, 255
        WinSet, Style,  %ShowTitle%, Quick Notify
        WinSet, Transparent, %NotificationTransparency%, Quick Notify
    }
    NotificationPath := NotificationIni()
    IniRead, SoundActive, %NotificationPath%, Sound Active, Quick
    IniRead, NotificationSound, %NotificationPath%, Sounds, Quick, Resources\Sounds\reminder.wav
    If (SoundActive = 1)
    {
        SoundPlay, Resources\Sounds\blank.wav ;;;;; super hacky workaround but works....
        SetTitleMatchMode, 2
        WinGet, AhkExe, ProcessName, Quick
        SetTitleMatchMode, 1
        SetWindowVol(AhkExe, NotificationVolume)
        SoundPlay, %NotificationSound%
    }
    SetTimer, CloseGui, -3000
}

CloseGui()
{
    Gui, Quick:Destroy
    Tooltip
    Return
}

Restart()
{
    Gdip_Shutdown(gdipToken)
    Reload
}

#IncludeAgain, Resources/Scripts/Ini.ahk