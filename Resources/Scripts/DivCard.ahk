w::
UpdateCheck()
{
	url = https://divcards.io/
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", "https://divcards.io/", true)
	whr.Send()
	whr.WaitForResponse() 
	MapData := whr.ResponseText
    MyMap := "Arcade"
    StringSplit, MapData, MapData, "`n"
    ; msgbox, %MapData35%
    Loop, 10
        If InStr(MapData35, MyMap)
            {
                MsgBox, Test %A_LoopField%
            }
}