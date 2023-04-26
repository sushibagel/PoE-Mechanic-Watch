#SingleInstance, force
#Persistent
#NoEnv

Global ScreenSearchMechanics := "Metamorph|Ritual"
Global MySearches

#Include <Gdip_All>
#Include <Gdip_ImageSearch>

                            
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
                        SetTimer, ScreenCheck, 500
                        Break
                    }
            }
    }

ScreenCheck()
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
                            If (MySearches = "")
                                {
                                   CurrentSearch := % SearchMechanics[A_Index] "Search"
                                   MySearches := %CurrentSearch%()
                                }
                            If !(MySearches = "")
                                {
                                    CurrentSearch := % SearchMechanics[A_Index] "Search"
                                    MySearches := MySearches "|" %CurrentSearch%()
                                }
                        }
                }
        }
;begin actual search
    gdipToken := Gdip_Startup()
    bmpHaystack := Gdip_BitmapFromScreen()
    MySearches := StrSplit(MySearches, "|")
    LoopCount := MySearches.MaxIndex()
    Loop, %LoopCount% ; Get all image locations
        {
            PngSearch := MySearches[A_Index]
            PngLocation := "Resources\Images\Image Search\" MySearches[A_Index] ".png"
            %PngSearch% := Gdip_CreateBitmapFromFile(PngLocation)
        }
    
    Loop, %LoopCount%
        {
            ThisSearch := % MySearches[A_Index]
            ThisSearch1 := %ThisSearch%
            SearchActive := ThisSearch "Search"
            If (Gdip_ImageSearch(bmpHaystack,ThisSearch1,LIST,,0,0,0,30,0xFFFFFF,1,0) = 1)
                {  
                    If InStr(ThisSearch, "Assem")
                        {
                            MechanicsIni := MechanicsIni()
                            IniRead, isActive, %MechanicsIni%, Mechanic Active, Metamorph
                            If (isActive = 1)
                                {
                                    IniWrite, 0, %MechanicsIni%, Mechanic Active, Metamorph
                                    IniWrite, 0, %MechanicsIni%, Metamorph Track, Status ;Shut screen search off for metamorph until next map. Toggled back on in hideout section of log script
                                    IniWrite, 1, %MechanicsIni%, Metamorph Track, Icon Status ;Toggle Icon search on. 
                                    RefreshOverlay()
                                    GdipClean()
                                    Return
                                }
                        }
                        
                    If InStr(ThisSearch, "Shop")
                        {
                            msgbox, test
                            MechanicsIni := MechanicsIni()
                            IniRead, isActive, %MechanicsIni%, Mechanic Active, Ritual
                            If (isActive = 1)
                                {
                                    IniWrite, 0, %MechanicsIni%, Mechanic Active, Ritual
                                    IniWrite, 0, %MechanicsIni%, Ritual Track, Status ;Shut screen search off for ritual until next map. Toggled back on in hideout section of log script
                                    RefreshOverlay()
                                    GdipClean()
                                    Return
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
                            Return
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
                                    IniWrite, 0, %MechanicsIni%, Ritual Track, %ThisSearch% ;Shut screen search off for ritual the ritual icon. Toggled back on as we go
                                    RitualCount := StrSplit(ThisSearch, "RitualCount")
                                    RitualCount := SubStr(RitualCount[2], 1, 1) "/" SubStr(RitualCount[2], 0, 1)
                                    IniWrite, %RitualCount%, %MechanicsIni%, Ritual Track, Count
                                    RefreshOverlay()
                                }

                    GdipClean()
                    Return
                }
        }
    }
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
    Return, "RitualCount23|RitualCount33|RitualCount24|RitualCount34|RitualCount44|RitualShop|RitualCount13|RitualCount14"
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
    Gdip_Shutdown(gdipToken)
}

#IncludeAgain, Resources/Scripts/Ini.ahk

#P::
Reload
Return