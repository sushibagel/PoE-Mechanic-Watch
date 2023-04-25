#SingleInstance, force
#Persistent
#NoEnv

Global MetaIconSearch := 0
Global MetaAssemSearch := 0
Global RitualIconSearch := 0
Global RitualCount23Search := 0
Global RitualCount33Search := 0
Global RitualCount24Search := 0
Global RitualCount34Search := 0
Global RitualCount44Search := 0
Global RitualShopSearch := 0
Global MySearches
Global RitualCounts := "13|14|23|24|33|34|44"

#Include <Gdip_All>
#Include <Gdip_ImageSearch>

                            
OnExit("ExitScript") 

SetTimer, ScreenCheck, 500

ScreenCheck()
{
    gdipToken := Gdip_Startup()
    bmpHaystack := Gdip_BitmapFromScreen()
    MySearches := "MetaAssem|MetaIcon|RitualCount23|RitualCount33|RitualCount24|RitualCount34|RitualCount44|RitualShop|RitualCount13|RitualCount14"
    ;Can't figure out a way to make harvest work reliably. 
    MySearches := StrSplit(MySearches, "|")
    LoopCount := MySearches.MaxIndex()
    Loop, %LoopCount%
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
            If (%SearchActive% = 1)
                {
                    If (Gdip_ImageSearch(bmpHaystack,ThisSearch1,LIST,,0,0,0,30,0xFFFFFF,1,0) = 1)
                        {  
                            %SearchActive% := 0
                            MechanicsIni := MechanicsIni()
                            If InStr(ThisSearch, "Ritual")
                                {
                                    RitualCount := SubStr(ThisSearch, -1)
                                    RitualCount := SubStr(RitualCount, 1, 1) "/" SubStr(RitualCount, 0)
                                    IniWrite, %RitualCount%, %MechanicsIni%, Ritual Count, Count
                                }
                            SearchFound(SearchActive)
                            Break
                        }
                }
        }

    Gdip_DisposeImage(bmpHaystack)
    Gdip_DisposeImage(MetaAssem)
    Gdip_DisposeImage(MetaIcon)
    Gdip_DisposeImage(RitualIcon)
    Gdip_DisposeImage(RitualCount23)
    Gdip_DisposeImage(RitualCount33)
    Gdip_DisposeImage(RitualShop)
    Gdip_DisposeImage(RitualCount24)
    Gdip_DisposeImage(RitualCount34)
    Gdip_DisposeImage(RitualCount23)
    Gdip_DisposeImage(RitualCount44)
    Gdip_Shutdown(gdipToken)
}
Return

DestroySearchGui:
{
    Gui, ScreenSearch:Destroy
    SetTimer, DestroySearchGui, Off
}

SearchFound(ThisSearch)
{
    If (ThisSearch = "MetaAssemSearch") or (ThisSearch = "MetaIconSearch")
        {
            If (ThisSearch = "MetaAssemSearch")
                {
                    MetaIconSearch := 1
                    MechanicsIni := MechanicsIni()
                    IniWrite, 0, %MechanicsIni%, Mechanic Active, Metamorph
                    RefreshOverlay()
                }
            Else
                {
                    MetaAssemSearch := 1
                    MechanicsIni := MechanicsIni()
                    IniWrite, 1, %MechanicsIni%, Mechanic Active, Metamorph
                    RefreshOverlay()
                }
        }
        If InStr(ThisSearch, "Ritual")
        {
            RitualVariation := StrSplit(RitualCounts, "|")
            RitualsTotal := MySearches.MaxIndex()
            Loop, %RitualsTotal%
                {
                    RitualSearch := "RitualCount" RitualVariation[A_Index] "Search"
                    If (ThisSearch = RitualSearch)
                        {
                            %RitualSearch% := 0
                            RitualActions(RitualVariation[A_Index])
                        }
                }
        }
    Return
}          

RitualActions(RitualMatch)
{
    RitualVariation := StrSplit(RitualCounts, "|")
    RitualsTotal := MySearches.MaxIndex()
    Loop, %RitualsTotal%
        {
            RitualSearch := "RitualCount" RitualVariation[A_Index] "Search"
            If (RitualSearch != RitualMatch)
                {
                    %RitualSearch% := 1
                    MechanicsIni := MechanicsIni()
                    If (RitualSearch != "RitualCountSearch")
                        {
                            IniWrite, 1, %MechanicsIni%, Mechanic Active, Ritual
                            RefreshOverlay()
                        }
                    Else
                        {
                            IniWrite, 0, %MechanicsIni%, Mechanic Active, Ritual
                            RefreshOverlay()
                        }
                }
        }
}


ExitScript()
{
    Gdip_DisposeImage(bmpHaystack)
    Gdip_DisposeImage(MetaAssem)
    Gdip_DisposeImage(MetaIcon)
    Gdip_DisposeImage(RitualIcon)
    Gdip_DisposeImage(RitualCount23)
    Gdip_DisposeImage(RitualCount33)
    Gdip_DisposeImage(RitualShop)
    Gdip_DisposeImage(RitualCount24)
    Gdip_DisposeImage(RitualCount34)
    Gdip_DisposeImage(RitualCount23)
    Gdip_DisposeImage(RitualCount44)
    Gdip_Shutdown(gdipToken)
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

#IncludeAgain, Resources/Scripts/Ini.ahk

#P::
Reload
Return