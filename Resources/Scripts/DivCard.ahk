#SingleInstance, Force
Global MatchCount
Global testdata
Global MyMap
Global DivCheckActive
Global MapTitle

uxtheme := DllCall("GetModuleHandle", "str", "uxtheme", "ptr")
SetPreferredAppMode := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 135, "ptr")
FlushMenuThemes := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 136, "ptr")
DllCall(SetPreferredAppMode, "int", 1) ; Dark
DllCall(FlushMenuThemes)

DllCall("dwmapi\DwmSetWindowAttribute", "Ptr",DivGui, "Int",20, "Int*",True, "Int",4)

#IfWinActive, ahk_group PoeWindow
~^c::
{
    CheckDivStatus()
    If (DivCheckActive = 1)
        {
            Gosub, CheckDiv
        }
    Return
}
#If

DivInput()
{
    CheckDivStatus()
    If (DivCheckActive = 1)
        {
            CheckTheme()
            MapTitle :=
            Gui, MapInput:Color, Edit, %Secondary% 
            Gui, MapInput:Color, %Background%
            Gui, MapInput:+E0x02000000 +E0x00080000 ; WS_EX_COMPOSITED WS_EX_LAYERED
            Gui, MapInput: -Caption  +AlwaysOnTop 
            Gui, MapInput:Font, c%Font% s10
            Gui, MapInput:Add, Text, +Center, Input the name of a map
            Gui, MapInput:Add, Edit, w145 vMapTitle -Caption -Border
            Gui, MapInput:Add, Button, +Default gMapSubmit Section, Submit
            Gui, MapInput:Add, Button, gMapCancel ys x+37, Cancel
            Gui, MapInput:Margin
            Gui, MapInput:Show,, Map Input
            ; InputBox, MapTitle, Map Search, Input the name of a map,, 200, 125,,,, 15
            WinWaitClose, Map Input
            If (MapTitle != "")
                {
                    Clipboard := "Item Class: Mapss" 
                    MyMap := MapTitle 
                    Gosub, CheckDiv
                }
            Return
        }
}

MapSubmit()
{
    Gui, MapInput:Submit
    Gui, MapInput:Destroy
}

MapCancel()
{
    Gui, MapInput:Destroy
}

#p::
Reload
Return

CheckDiv:
    CheckTheme()    
    Sleep, 100
    DivSearch := Clipboard
    If InStr(DivSearch,"Item Class: Maps")
    {
        MapData := StrSplit(DivSearch, "`n")
        If !InStr(MapData[3], "Map")
            {
                MapData[3] := MapData[4]
            }
        MapData := StrSplit(MapData[3], "Map")
        If !InStr(DivSearch,"Item Class: Mapss")
            {
                MyMap := MapData[1]
                MyMap = %MyMap%
                FileRead, MapList, Resources\Data\maplist.txt
                Loop
                    {
                        If !InStr(MapList, MyMap)
                            {
                                FindMapName()
                            }
                        If InStr(MapList, MyMap)
                            {
                                Break
                            }
                    }    
                }
        url = https://divcards.io/
        whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        whr.Open("GET", "https://divcards.io/", true)
        whr.Send()
        whr.WaitForResponse() 
        MapData := whr.ResponseText
        MatchCount := 0
        CheckTheme()
        Gui, DivCheck:Destroy
        Gui, DivCheck:Font, c%Font% s9 
        Gui, DivCheck:Add, Text, Section, Divination card information and rating are provided by
        Gui, DivCheck:Font, c1177bb s9   Normal Underline
        Gui, DivCheck:Margin, 2
        Gui, DivCheck:Add, Text, ys gDivCardsLink, divcards.io
        Gui, DivCheck:Margin
        Gui, DivCheck:Font, c%Font% s15 Bold
        Gui, DivCheck:Add, Text, , Map: %MyMap%
        ; Gui, DivCheck:-Caption +Border +hwndDivGui 
        Gui, DivCheck: +hwndDivGui 
        Gui, DivCheck: Color, %Background%
        Gui, DivCheck:Font, c%Font% s10 Bold

        TWidth := Round(96/A_ScreenDPI*200)
        Gui, DivCheck:Add, Text, xs Section w%TWidth% +Wrap, Divination Card 
        TWidth := Round(96/A_ScreenDPI*149)
        Gui, DivCheck:Add, Text, ys w%TWidth% +Wrap, Stack Count
        TWidth := Round(96/A_ScreenDPI*250)
        Gui, DivCheck:Add, Text, ys w%TWidth% +Wrap, Reward
        TWidth := Round(96/A_ScreenDPI*125)
        Gui, DivCheck:Add, Text, ys w%TWidth% +Wrap, Usefullness
        TWidth := Round(96/A_ScreenDPI*150)
        Gui, DivCheck:Add, Text, ys w%TWidth% +Wrap, Wiki Link
        
        MapData := StrSplit(MapData,"`n")
        Loop, % MapData.MaxIndex()
            {
                testdata := "MapData"A_Index
                ExactName := StrSplit(MapData[A_Index], ",", A_Space)
                If (ExactName[1] = MyMap)
                    {
                        MatchCount++
                        AddDiv := "DivCards"A_Index
                        %AddDiv% := StrSplit(MapData[A_Index],",")
                        %MatchCount%Name := %AddDiv%[2]
                        %MatchCount%Count := %AddDiv%[3]
                        %MatchCount%Reward := %AddDiv%[4]
                        %MatchCount%Useful := %AddDiv%[5]
                        %MatchCount%Link := %AddDiv%[6] 
                        If (%MatchCount%Useful = "ActualGarbage")
                            {
                                %MatchCount%Useful := "Garbage"
                            }
                        If (%MatchCount%Useful = "GodTier")
                            {
                                %MatchCount%Useful := "Top Tier"
                            }
                        If (%MatchCount%Useful = "UsefulAF")
                            {
                                %MatchCount%Useful := "Useful"
                            }
                        If (%MatchCount%Link != "")
                            {
                                %MatchCount%Linkbtn := "Link"
                            }
                        If (%MatchCount%Link = "")
                            {
                                %AddDiv%[6] := "https://www.poewiki.net/wiki/Path_of_Exile_Wiki"
                                %MatchCount%Linkbtn := "N/A"
                            }
                        TWidth := Round(96/A_ScreenDPI*250)
                        Gui, DivCheck:Font, c%Font% s10 Normal
                        Gui, DivCheck:Add, Text, xs Section w%TWidth% +Wrap, % %MatchCount%Name 
                        TWidth := Round(96/A_ScreenDPI*100)
                        Gui, DivCheck:Add, Text, ys w%TWidth% +Wrap, % %MatchCount%Count
                        TWidth := Round(96/A_ScreenDPI*250)
                        Gui, DivCheck:Add, Text, ys w%TWidth% +Wrap, % %MatchCount%Reward
                        TWidth := Round(96/A_ScreenDPI*140)
                        Gui, DivCheck:Add, Text, ys w%TWidth% +Wrap, % %MatchCount%Useful
                        TWidth := Round(96/A_ScreenDPI*150)
                        Gui, DivCheck:Font, c1177bb s10 Normal Underline
                        Gui, DivCheck:Add, Text, ys w%TWidth% +Wrap gLink vLink%MatchCount%, % %MatchCount%Linkbtn
                        Link%MatchCount% := %AddDiv%[6]
                    } 
            }
            ; Create ScrollGUI2 with both horizontal and vertical scrollbars
            SG2 := New ScrollGUI(DivGui, 600, 300, "+Resize +LabelGui2")
            ; Show ScrollGUI2
            SG2.Show("Divination Card", "xCenter yCenter")
            Return
    }
    Return

DivCheckGuiClose()
{
    Gui, DivCheck:Destroy
}

Link()
{
    Run, % %A_GuiControl%
}

FindMapName()
{
    MyMap := StrSplit(MyMap, A_Space)
    TotalSplit := MyMap.MaxIndex() -1
    MMap :=
    Loop, %TotalSplit%
        {
            MapInstance := A_Index + 1
            MMap := MMap A_Space MyMap[MapInstance]
        }
    MyMap = %MMap%
}

DivCardsLink()
{
    Run, https://divcards.io
}

CheckDivStatus()
{
    HotkeyIni := HotkeyIni()
    IniRead, DivCheckActive, %HotkeyIni%, Hotkeys, DivCheck, 0
}