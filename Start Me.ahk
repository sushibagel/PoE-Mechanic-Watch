AHKLIB = %A_MyDocuments%\AutoHotKey\Lib
VA = %AHKLIB%\VA.ahk
WV= %AHKLIB%\setWindowVol.ahk

If !FileExist(AHKLIB)
{
    FileCreateDir, %AHKLIB%
}
If !FileExist(VA)
{
    FileCopy, Resources\Scripts\VA.ahk, %AHKLIB%
}
If !FileExist(WV)
{
    FileCopy, Resources\Scripts\setWindowVol.ahk, %AHKLIB%
}
Run, PoE Mechanic Watch.ahk
Return