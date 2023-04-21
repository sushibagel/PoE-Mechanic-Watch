#SingleInstance, Force
Global MatchCount
Global testdata
Global MyMap

uxtheme := DllCall("GetModuleHandle", "str", "uxtheme", "ptr")
SetPreferredAppMode := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 135, "ptr")
FlushMenuThemes := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 136, "ptr")
DllCall(SetPreferredAppMode, "int", 1) ; Dark
DllCall(FlushMenuThemes)

DllCall("dwmapi\DwmSetWindowAttribute", "Ptr",DivGui, "Int",20, "Int*",True, "Int",4)

; #IfWinActive, ahk_exe Notepad.exe

~^c::
    Sleep, 500
    DivSearch := Clipboard
    If InStr(DivSearch,"Item Class: Maps")
    {
        MapData := StrSplit(DivSearch, "`n")
        MapData := StrSplit(MapData[3], " ")
        MyMap := MapData[1]
        url = https://divcards.io/
        whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        whr.Open("GET", "https://divcards.io/", true)
        whr.Send()
        whr.WaitForResponse() 
        MapData := whr.ResponseText
        MatchCount := 0
        Gui, DivCheck:Destroy
        Gui, DivCheck:Font, c%Font% s15 Bold
        Gui, DivCheck:Add, Text, , Map: %MyMap%
        ; Gui, DivCheck:-Caption +Border +hwndDivGui 
        Gui, DivCheck: +hwndDivGui 
        Gui, DivCheck: Color, 4e4f53
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
        }

Link()
{
    Run, % %A_GuiControl%
}

;Alleyways,Home,3,Exceptional Gem 1-20% Qual,UsefulAF,https://www.poewiki.net/wiki/Support_gem#Exceptional_Support_Gems


    
    
       

    ; ; Headings 
    ; Gui, NotificationSettings:Font, c%Font% s%fw1% Bold Underline
    ; Gui, NotificationSettings:Add, Text, xs x25 Section, Notification Type
    ; XOff := Round(96/A_ScreenDPI*50)
    ; Gui, NotificationSettings:Add, Text, x+%XOff% ys, Enabled
    ; XOff := Round(96/A_ScreenDPI*30)
    ; Gui, NotificationSettings:Add, Text, x+%XOff% ys, Sound Settings
    ; XOff := Round(96/A_ScreenDPI*45)
    ; Gui, NotificationSettings:Add, Text, x+%XOff% ys, Transparency Settings
    ; XOff := Round(96/A_ScreenDPI*33)
    ; Gui, NotificationSettings:Add, Text, x+%XOff% ys, Additional Settings



; Item Class: Maps
; Rarity: Normal
; Arcade Map
; --------
; Map Tier: 12
; --------
; Item Level: 81
; --------
; Travel to this Map by using it in a personal Map Device. Maps can only be used once.

#IncludeAgain, Class_ScrollGUI.ahk