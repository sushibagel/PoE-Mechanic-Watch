Global HotkeyCount
global Location := "Resources\Settings\Hotkeys.ini"

AHKLIB = %A_MyDocuments%\AutoHotKey\Lib
VA = %AHKLIB%\VA.ahk
WV= %AHKLIB%\setWindowVol.ahk
INI= Resources\Settings\StorageLocation.ini
Gdip = %AHKLIB%\Gdip_All.ahk
IS = %AHKLIB%\Gdip_ImageSearch.ahk
ISC = %AHKLIB%\Gdip_ImageSearch.c

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
If !FileExist(Gdip)
{
    FileCopy, Resources\Scripts\Gdip_All.ahk, %AHKLIB%
}
If !FileExist(IS)
{
    FileCopy, Resources\Scripts\Gdip_ImageSearch.ahk, %AHKLIB%
}
If !FileExist(ISC)
{
    FileCopy, Resources\Scripts\Gdip_ImageSearch.c, %AHKLIB%
}
If FileExist(INI)
{
    IniRead, Location, %INI%, Settings Location, Location
    Location := Location "\Resources\Settings\Hotkeys.ini"
}

If FileExist(Location)
{
    IniRead, Hotkeys, %Location%, Hotkeys
    If InStr(Hotkeys, "1=")
    {
        HotkeyCount := 1
        HotKeyMechanics := "MapCount|ToggleInfluence|MavenInvitation|LaunchPoE|ToolLauncher|Abyss|Blight|Breach|Expedition|Harvest|Incursion|Legion|Metamorph|Ritual|Generic|MasterMapping"

        For each, HotkeyItem in StrSplit(HotKeyMechanics, "|")
        {
            HotkeyCount ++
            IniRead, NewHotkey, %Location%, Hotkeys, %HotkeyCount%
            IniDelete, %Location%, Hotkeys, %HotkeyCount%
            KeyCombo := %HotkeyItem%
            IniWrite, %NewHotkey%, %Location%, Hotkeys, %HotkeyItem%
            IniDelete, %Location%, Hotkeys, 1
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