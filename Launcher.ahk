global Location := "Resources\Settings\Hotkeys.ini"

AHKLIB = %A_MyDocuments%\AutoHotKey\Lib
OW = %AHKLIB%\OnWin.ahk
VA = %AHKLIB%\VA.ahk
WV= %AHKLIB%\setWindowVol.ahk
INI= Resources\Settings\StorageLocation.ini

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
If !FileExist(OW)
{
    FileCopy, Resources\Scripts\OnWin.ahk, %AHKLIB%
}

If FileExist(INI)
{
    IniRead, Location, %INI%, Settings Location, Location
    Location := Location "\Resources\Settings\Hotkeys.ini"
}

If FileExist(Location)
{
    IniRead, Hotkeys, %Location%, Hotkeys
    If !InStr(Hotkeys, "15")
    {
        Loop, 15
        {
            IniWrite, %A_Space%, %Location%, Hotkeys, %A_Index%
        }
        SetTimer, Exit, 5000
        msgbox, This update may have broken any hotkeys you previously had set. Please check and update them. 
    }
}

Run, PoE Mechanic Watch.ahk
ExitApp

Exit()
{
    Run, PoE Mechanic Watch.ahk
    ExitApp
}