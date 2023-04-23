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

DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", DivGui, "Int", 20, "Int*", &True, "Int", 4)

#HotIf WinActive("ahk_group PoeWindow", )
~^c::
{
    CheckDivStatus()
    If (DivCheckActive = 1)
        {
            CheckDiv()
        }
    Return
}
#HotIf

DivInput()
{
    CheckDivStatus()
    If (DivCheckActive = 1)
        {
            CheckTheme()
            MapTitle := ""
            MapInput := Gui()
            MapInput.BackColor := "Edit"
            MapInput.BackColor := Background
            MapInput.Opt("+E0x02000000 +E0x00080000") ; WS_EX_COMPOSITED WS_EX_LAYERED
            MapInput.Opt("-Caption  +AlwaysOnTop")
            MapInput.SetFont("c" . Font . " s10")
            MapInput.Add("Text", "+Center", "Input the name of a map")
            ogcEditMapTitle := MapInput.Add("Edit", "w145 vMapTitle -Caption -Border")
            ogcButtonSubmit := MapInput.Add("Button", "+Default  Section", "Submit")
            ogcButtonSubmit.OnEvent("Click", MapSubmit.Bind("Normal"))
            ogcButtonCancel := MapInput.Add("Button", "ys x+37", "Cancel")
            ogcButtonCancel.OnEvent("Click", MapCancel.Bind("Normal"))
            MapInput.MarginX := "", MapInput.MarginY := ""
            MapInput.Title := "Map Input"
            MapInput.Show()
            ; InputBox, MapTitle, Map Search, Input the name of a map,, 200, 125,,,, 15
            WinWaitClose("Map Input")
            If (MapTitle != "")
                {
                    A_Clipboard := "Item Class: Mapss" 
                    MyMap := MapTitle 
                    CheckDiv()
                }
            Return
        }
}

MapSubmit()
{
    oSaved := MapInput.Submit()
    MapTitle := oSaved.MapTitle
    MapInput.Destroy()
}

MapCancel()
{
    MapInput.Destroy()
}

#p::
{ ; V1toV2: Added bracket
Reload()
Return
} ; Added bracket before function

CheckDiv()
{ ; V1toV2: Added bracket
    CheckTheme()    
    Sleep(100)
    DivSearch := A_Clipboard
    If InStr(DivSearch, "Item Class: Maps")
    {
        MapData := StrSplit(DivSearch, "`n")
        If !InStr(MapData[3], "Map")
            {
                MapData[3] := MapData[4]
            }
        MapData := StrSplit(MapData[3], "Map")
        If !InStr(DivSearch, "Item Class: Mapss")
            {
                MyMap := MapData[1]
                MyMap := MyMap
                MapList := Fileread("Resources\Data\maplist.txt")
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
        url := "https://divcards.io/"
        whr := ComObject("WinHttp.WinHttpRequest.5.1")
        whr.Open("GET", "https://divcards.io/", true)
        whr.Send()
        whr.WaitForResponse() 
        MapData := whr.ResponseText
        MatchCount := 0
        CheckTheme()
        DivCheck := Gui()
        DivCheck.Destroy()
        DivCheck.SetFont("c" . Font . " s9")
        DivCheck.Add("Text", "Section", "Divination card information and rating are provided by")
        DivCheck.SetFont("c1177bb s9   Normal Underline")
        DivCheck.MarginX := "2", DivCheck.MarginY := ""
        ogcTextdivcardsio := DivCheck.Add("Text", "ys", "divcards.io")
        ogcTextdivcardsio.OnEvent("Click", DivCardsLink.Bind("Normal"))
        DivCheck.MarginX := "", DivCheck.MarginY := ""
        DivCheck.SetFont("c" . Font . " s15 Bold")
        DivCheck.Add("Text", , "Map: " . MyMap)
        ; Gui, DivCheck:-Caption +Border +hwndDivGui 
        DivCheck.Opt("+hwndDivGui")
        DivCheck.Color(Background)
        DivCheck.SetFont("c" . Font . " s10 Bold")

        TWidth := Round(96/A_ScreenDPI*200)
        DivCheck.Add("Text", "xs Section w" . TWidth . " +Wrap", "Divination Card")
        TWidth := Round(96/A_ScreenDPI*149)
        DivCheck.Add("Text", "ys w" . TWidth . " +Wrap", "Stack Count")
        TWidth := Round(96/A_ScreenDPI*250)
        DivCheck.Add("Text", "ys w" . TWidth . " +Wrap", "Reward")
        TWidth := Round(96/A_ScreenDPI*125)
        DivCheck.Add("Text", "ys w" . TWidth . " +Wrap", "Usefullness")
        TWidth := Round(96/A_ScreenDPI*150)
        DivCheck.Add("Text", "ys w" . TWidth . " +Wrap", "Wiki Link")
        
        MapData := StrSplit(MapData,"`n")
        Loop MapData.MaxIndex()
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
                        DivCheck.SetFont("c" . Font . " s10 Normal")
                        DivCheck.Add("Text", "xs Section w" . TWidth . " +Wrap", %MatchCount%Name)
                        TWidth := Round(96/A_ScreenDPI*100)
                        DivCheck.Add("Text", "ys w" . TWidth . " +Wrap", %MatchCount%Count)
                        TWidth := Round(96/A_ScreenDPI*250)
                        DivCheck.Add("Text", "ys w" . TWidth . " +Wrap", %MatchCount%Reward)
                        TWidth := Round(96/A_ScreenDPI*140)
                        DivCheck.Add("Text", "ys w" . TWidth . " +Wrap", %MatchCount%Useful)
                        TWidth := Round(96/A_ScreenDPI*150)
                        DivCheck.SetFont("c1177bb s10 Normal Underline")
                        ogcTextLink := DivCheck.Add("Text", "ys w" . TWidth . " +Wrap  vLink" . MatchCount, %MatchCount%Linkbtn)
                        ogcTextLink.OnEvent("Click", Link.Bind("Normal"))
                        Link%MatchCount% := %AddDiv%[6]
                    } 
            }
            ; Create ScrollGUI2 with both horizontal and vertical scrollbars
            SG2 := New ScrollGUI(DivGui, 600, 300, "+Resize +LabelGui2")
            ; Show ScrollGUI2
            SG2.Show("Divination Card", "xCenter yCenter")
            Return
    }
} ; V1toV2: Added bracket before function

DivCheckGuiClose()
{
    DivCheck.Destroy()
}

Link()
{
    Run(%A_GuiControl%)
}

FindMapName()
{
    MyMap := StrSplit(MyMap, A_Space)
    TotalSplit := MyMap.MaxIndex() -1
    MMap := ""
    Loop TotalSplit
        {
            MapInstance := A_Index + 1
            MMap := MMap A_Space MyMap[MapInstance]
        }
    MyMap := MMap
}

DivCardsLink()
{
    Run("https://divcards.io")
}

CheckDivStatus()
{
    HotkeyIni := HotkeyIni()
    DivCheckActive := IniRead(HotkeyIni, "Hotkeys", "DivCheck", 0)
}