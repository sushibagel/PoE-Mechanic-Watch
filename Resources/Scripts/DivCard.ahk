Global MatchCount

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
    MatchCount := 0
    StringSplit, MapData, MapData, "`n"
    ; msgbox, %MapData35%
    Loop, % MapData.MaxIndex()
        testdata := "MapData"A_Index
    Msgbox, %testdata%
        If InStr(testdata, MyMap)
            {
                MatchCount++
                MatchData%MatchCount% := "MapData"%A_LoopField%
                MsgBox, djjdjd
            }
    MsgBox, %MatchCount%
}