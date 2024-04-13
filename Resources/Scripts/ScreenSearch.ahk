#SingleInstance, force
#Persistent
#NoEnv
#MaxMem 1024
#NoTrayIcon
Menu, Tray, Icon, Resources\Images\generic.png
SetBatchLines, -1

Global ScreenSearchMechanics := "Ritual|Eldritch|Blight"
Global MySearches
Global SearchActiveEldritch

#Include <Gdip_All>
#Include <Gdip_ImageSearch>

GroupAdd, PoeWindow, ahk_exe PathOfExileSteam.exe
GroupAdd, PoeWindow, ahk_exe PathOfExile.exe 
GroupAdd, PoeWindow, ahk_exe PathOfExileEGS.exe
GroupAdd, PoeWindow, ahk_class POEWindowClass
; GroupAdd, PoeWindow, ahk_exe Code.exe
; GroupAdd, PoeWindow, ahk_exe ApplicationFrameHost.exe

Start()
Return

Start()
{
    WinWaitActive, ahk_group PoeWindow
    MechanicsIni := MechanicsIni()
    SearchMechanics := StrSplit(ScreenSearchMechanics, "|")
    MechanicCount := SearchMechanics.MaxIndex()
    Loop, %MechanicCount% ;Check if any Screen Searches are active before enabling the timer. I'm not setting the search variables here because I don't want to activate the timer twice. 
        {
            ScreenIni := ScreenIni()
            IniRead, CalibrateActive, %ScreenIni%, Screen Search Disable, Disable, 0
            IniRead, ActiveCheck, %MechanicsIni%, Auto Mechanics, % SearchMechanics[A_Index], 0
            If (ActiveCheck = 1) and (CalibrateActive = 0)
                {
                    IniRead, mActiveCheck,  %MechanicsIni%, Mechanics, % SearchMechanics[A_Index], 0 ; Now check that the mechanic tracking is enabled for the overlay. 
                    If (mActiveCheck = 1)
                        {
                            SetTimer, ScreenCheck, 500
                            Break
                        }
                }
            If (SearchMechanics[A_Index] = "Eldritch") and (ActiveCheck = 1) and (CalibrateActive = 0)
                {
                    SetTimer, ScreenCheck, 500
                    Break
                }
        }
}
Return

ScreenCheck()
{
    ScreenIni := ScreenIni()
    IniRead, CalibrateActive, %ScreenIni%, Screen Search Disable, Disable, 0
    If !WinActive("ahk_group PoeWindow") or (CalibrateActive = 1)
        {
            SetTimer, ScreenCheck, Off
            Start()
        }
    HideoutIni := HideoutIni()
    IniRead, HideoutStatus, %HideoutIni%, In Hideout, In Hideout, 0
    MechanicsIni := MechanicsIni()
    IniRead, ActiveCheck, %MechanicsIni%, Auto Mechanics, Eldritch, 0
    If (HideoutStatus = 1) and (ActiveCheck = 1)
        {
            EldritchSearch()
            Return
        }
    MySearches := GetSearches()
    MySearches := StrSplit(MySearches, "|")
    LoopCount := MySearches.MaxIndex()
    Loop, %LoopCount%
        {
            ThisSearch := % MySearches[A_Index]
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
            ScreenIni := ScreenIni()
            IniRead, SearchVariation, %ScreenIni%, Variation, %ThisSearch%, 50
            PngLocation := "Resources\Images\Image Search\Custom\" ThisSearch ".png"
            If !FileExist(PngLocation)
                {
                    PngLocation := "Resources\Images\Image Search\" ThisSearch ".png"
                }
            gdipToken := Gdip_Startup()
            PoeHwnd := WinExist("ahk_group PoeWindow")
            bmpHaystack := Gdip_BitmapFromHWND(PoeHwnd, 1)
            ; bmpHaystack := Gdip_BitmapFromScreen() ;For testing only
            ScreenSearchData := Gdip_CreateBitmapFromFile(PngLocation)
            If (Gdip_ImageSearch(bmpHaystack,ScreenSearchData,LIST,0,0,0,0,SearchVariation,0xFFFFFF,1,0) > 0)
                {
                    IniRead, RitualStatus, %MechanicsIni%, Ritual Track, Count
                    IniRead, RitualActiveStatus, %MechanicsIni%, Mechanic Active, Ritual, 0
                    If InStr(ThisSearch, "Shop") and (RitualActiveStatus = 1) and ((RitualStatus = "4/4") or (RitualStatus = "3/3")) ; need to make it only reset if opened at full count
                        {
                            MechanicsIni := MechanicsIni()
                            IniRead, isActive, %MechanicsIni%, Mechanic Active, Ritual
                            If (isActive = 1)
                                {
                                    IniWrite, 0, %MechanicsIni%, Mechanic Active, Ritual
                                    IniWrite, 0, %MechanicsIni%, Ritual Track, Status ;Shut screen search off for ritual until next map. Toggled back on by the "Tail.ahk" script. 
                                    IniWrite, %BlankVariable%, %MechanicsIni%, Ritual Track, Count ;erase the ritual count
                                    RefreshOverlay()
                                    Break
                                }
                        }
                    If InStr(ThisSearch, "Blight")
                        {
                            MechanicsIni := MechanicsIni()
                            IniWrite, 0, %MechanicsIni%, Mechanic Active, Blight
                            Sleep, 200
                            RefreshOverlay()
                            Break
                        }
                    If InStr(ThisSearch, "RitualIcon") and (RitualActiveStatus = 0) 
                        {
                            MechanicsIni := MechanicsIni()
                            IniWrite, 1, %MechanicsIni%, Mechanic Active, Ritual
                            IniWrite, %BlankVariable%, %MechanicsIni%, Ritual Track, Count
                            Sleep, 200
                            RefreshOverlay()
                            Break
                        }
                }
            Else
                {
                    Gdip_DisposeImage(ScreenSearchData)
                    DeleteObject(ScreenSearchData)
                    Gdip_Shutdown(gdipToken)
                    Gdip_DisposeImage(bmpHaystack)
                    DeleteObject(bmpHaystack)
                    DeleteObject(ErrorLevel)
                }
            }
        Gdip_DisposeImage(ScreenSearchData)
        DeleteObject(ScreenSearchData)
        Gdip_Shutdown(gdipToken)
        Gdip_DisposeImage(bmpHaystack)
        DeleteObject(bmpHaystack)
        DeleteObject(ErrorLevel)
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
                    If (ActiveCheck > 0) and (TrackerCheck > 0) and !(SearchMechanics[A_Index] = "Blight")
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
                    IniRead, BlightStatus, %MechanicsIni%, Mechanic Active, Blight, 0
                    If (SearchMechanics[A_Index] = "Blight") and (BlightStatus > 0)
                        {
                            If !(MySearches = "")
                                {
                                    MySearches := MySearches "|Blight"
                                }
                            If (MySearches = "")
                                {
                                    MySearches := "Blight"
                                }    
                        }
                }
        }
    Return, %MySearches%
}
Return

DestroySearchGui:
{
    Gui, ScreenSearch:Destroy
    SetTimer, DestroySearchGui, Off
    Return
}

RefreshOverlay()
{
	PostSetup()
    PostMessage, 0x01111,,,, PoE Mechanic Watch.ahk - AutoHotkey
	PostRestore()
    Return
}

PostSetup()
{
    Prev_DetectHiddenWindows := A_DetectHiddenWIndows
    Prev_TitleMatchMode := A_TitleMatchMode
    SetTitleMatchMode 2
    DetectHiddenWindows On
    Return
}

PostRestore()
{
    DetectHiddenWindows, %Prev_DetectHiddenWindows%
    SetTitleMatchMode, %A_TitleMatchMode%
    Return
}

RitualSearch()
{
    Return, "RitualShop|RitualIcon"
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
    Return
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

InfluenceTypes()
{
    Return, "Eater|Searing|Maven"
}

EldritchSearch()
{
    ;Start by identifying which influence is active. 
    ;Then do a search for +/- 2 for the influence count
    ;If match isn't found with +/- 2 search in groups of 5 switching to checking influences between each group.
    ActiveInfluence := FindActiveInfluence()
    
    If (ActiveInfluence != "")
        {
            EldritchCount := QuickCount(ActiveInfluence)
        }
}

FindActiveInfluence()
{

    InfluenceTypes := InfluenceTypes()
    gdipToken := Gdip_Startup()
    PoeHwnd := WinExist("ahk_group PoeWindow")
    bmpHaystack := Gdip_BitmapFromHWND(PoeHwnd, 1) ;Capture Screen for Search
    WinWaitActive, ahk_group PoeWindow
    For each, Influence in StrSplit(InfluenceTypes, "|")
        {
            InfluenceTarget := Influence "on"
            InfluenceSearch := SearchMechanic(InfluenceTarget, bmpHaystack)
            If (InfluenceSearch = "Match Found")
                {
                    Gdip_DisposeImage(EldritchSearch)
                    DeleteObject(EldritchSearch)
                    ; Gdip_DisposeImage(bmpHaystack)
                    ; DeleteObject(bmpHaystack)
                    ; DeleteObject(ErrorLevel)
                    ; Gdip_Shutdown(gdipToken)
                    InfluenceTypes := InfluenceTypes()
                    MechanicsIni := MechanicsIni()
                    CurrentInfluence := Influence
                    For each, Influence in StrSplit(InfluenceTypes, "|")
                        {
                            IniRead, InfluenceStatus, %MechanicsIni%, Influence, %Influence%, 0
                            If (InfluenceStatus = 1)
                                {
                                    IniInfluence := Influence
                                    Break
                                }
                        }
                    If (CurrentInfluence = IniInfluence)
                        {
                            ; just move on to checking current count
                            Return, % CurrentInfluence "|" bmpHaystack
                        }
                    Else
                        {
                            ; write the new influence then move on to current count. 
                            InfluenceTypes := InfluenceTypes()
                            For each, Influence in StrSplit(InfluenceTypes, "|")
                                {
                                    IniWrite, 0, %MechanicsIni%, Influence, %Influence%
                                }
                            IniWrite, 1, %MechanicsIni%, Influence, %CurrentInfluence%
                            SetTimer, DelayRefresh, 500
                            Return, % CurrentInfluence "|" bmpHaystack  
                        }
                }
            Else
                {
                    Gdip_DisposeImage(EldritchSearch)
                    DeleteObject(EldritchSearch)
                }
        }
        Gdip_DisposeImage(EldritchSearch)
        DeleteObject(EldritchSearch)
        Gdip_DisposeImage(bmpHaystack)
        DeleteObject(bmpHaystack)
        DeleteObject(ErrorLevel)
        Gdip_Shutdown(gdipToken)
}

SearchMechanic(SearchTarget, bmpHaystack)
{
    SearchPath := "Resources\Images\Image Search\Eldritch\Custom\" SearchTarget ".png"
    If !FileExist(SearchPath)
        {
            SearchPath := "Resources\Images\Image Search\Eldritch\" SearchTarget ".png"
        }
    ScreenIni := ScreenIni()
    IniRead, SearchVariation, %ScreenIni%, Variation, Eldritch, 50
    EldritchSearch := Gdip_CreateBitmapFromFile(SearchPath)
    If (Gdip_ImageSearch(bmpHaystack,EldritchSearch,LIST,0,0,0,0,SearchVariation,0xFFFFFF,1,0) > 0)
        {
            Gdip_DisposeImage(EldritchSearch)
            DeleteObject(EldritchSearch)
            MechanicsIni := MechanicsIni() 
            Return, "Match Found"
        }
}

QuickCount(Influence)
{
    SearchInfo := StrSplit(Influence, "|")
    Influence := SearchInfo[1]
    bmpHaystack := SearchInfo[2]
    MechanicsIni := MechanicsIni()
    IniRead, LastKnown, %MechanicsIni%, Influence Track, %Influence%, 0
    If (Influence = "Eater") or (Influence = "Searing")
        {
            If (LastKnown = 0)
                {
                    SearchNumber := "26|27|0|1|2"
                }
            Else If (LastKnown = 1)
                {
                    SearchNumber := "27|0|1|2|3"
                }
            Else If (LastKnown = 26)
                {
                    SearchNumber := "24|25|26|27|0"
                }
            Else If (LastKnown = 27)
                {
                    SearchNumber := "25|26|27|0|1"
                }
            Else
                {
                    SearchNumber := []
                    Loop, 5
                        {
                            SubNumber := A_Index - 3
                            SearchNumber.Push(LastKnown + SubNumber)
                        }
                }
        }
    If (Influence = "Maven")
        {
            If (LastKnown = 0)
                {
                    SearchNumber := "8|9|0|1"
                }
            Else If (LastKnown = 1)
                {
                    SearchNumber := "9|0|1|2|3"
                }
            Else If (LastKnown = 8)
                {
                    SearchNumber := "6|7|8|9|0"
                }
            Else If (LastKnown = 9)
                {
                    SearchNumber := "7|8|9|0|1"
                }
            Else
                {
                    SearchNumber := []
                    Loop, 5
                        {
                            SubNumber := A_Index - 3
                            SearchNumber.Push(LastKnown + SubNumber)
                        }
                }
        }
    If InStr(SearchNumber, "|")
        {
            SearchNumber := StrSplit(SearchNumber, "|")
        }
    InfluenceTypes := InfluenceTypes()
    Loop, 5
        {
            SearchCount := Influence SearchNumber[A_Index]
            SearchMechanic := SearchMechanic(SearchCount, bmpHaystack)
            If (SearchMechanic = "Match Found")
                {
                    Gdip_DisposeImage(EldritchSearch)
                    DeleteObject(EldritchSearch)
                    Gdip_DisposeImage(bmpHaystack)
                    DeleteObject(bmpHaystack)
                    DeleteObject(ErrorLevel)
                    Gdip_Shutdown(gdipToken)
                    ; on successful match check if it's a new count if not write to ini file. 
                    MechanicsIni := MechanicsIni()
                    IniRead, CurrentCount, %MechanicsIni%, Influence Track, %Influence% , 0
                    If (CurrentCount != SearchNumber[A_Index])
                        {
                            IniWrite, % SearchNumber[A_Index], %MechanicsIni%, Influence Track, %Influence%
                            RefreshOverlay()
                        }
                }
        }
    Gdip_DisposeImage(EldritchSearch)
    DeleteObject(EldritchSearch)
    Gdip_DisposeImage(bmpHaystack)
    DeleteObject(bmpHaystack)
    DeleteObject(ErrorLevel)
    Gdip_Shutdown(gdipToken)
}

EldritchCount(Influence)
{

}

DelayRefresh()
{
    SetTimer, DelayRefresh, Off
    RefreshOverlay()
}

#IncludeAgain, Resources/Scripts/Ini.ahk