UpdateCheck()
{
	MiscIni := MiscIni()
	IniWrite, %A_Now%, %MiscIni%, Update Check, Last Update
	FileReadLine, InstalledVersion, Resources/Data/Version.txt, 1
	Filename = %A_ScriptDir%/PoE Mechanic Watch Update.zip
	url = https://github.com/sushibagel/PoE-Mechanic-Watch/blob/main/Resources/Data/Version.txt
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", "https://raw.githubusercontent.com/sushibagel/PoE-Mechanic-Watch/main/Resources/Data/Version.txt", true)
	whr.Send()
	whr.WaitForResponse() 
	CurrentVersion1 := whr.ResponseText
	CurrentVersion := SubStr(CurrentVersion1, 1, 6)
	CurrentVersion := Trim(CurrentVersion,"`n `t") ; Trim and clean text
	InstalledVersion := Trim(InstalledVersion,"`n `t") ; Trim and clean text
	MsgBox, %CurrentVersion% %InstalledVersion%
	If (InstalledVersion == CurrentVersion)
	{
		TrayTip, Up-To-Date, PoE Mechanic Watch Is Up-To-Date,
		Sleep, 2000
		Traytip
		Return
	}
	Else
	{
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", "https://raw.githubusercontent.com/sushibagel/PoE-Mechanic-Watch/main/changelog.txt", true)
	whr.Send()
	whr.WaitForResponse() 
	changelog := whr.ResponseText
	UpdateURL = https://github.com/sushibagel/PoE-Mechanic-Watch/archive/refs/tags/%CurrentVersion%.zip
		MsgBox, 1, An update is available. Press OK to download., Your currently installed version is %InstalledVersion%. The latest is %CurrentVersion%.`n`nTo avoid the need to change all your settings on each update I recommend not copying over not copying the "Settings" folder from the update zip.`n`nChangelog:`n%changelog%
		IfMsgBox OK
		UrlDownloadToFile, *0 %UpdateUrl%, %Filename%
			if ErrorLevel = 1
				MsgBox, There was some error updating the file. You may have the latest version, or it is blocked.
			else if ErrorLevel = 0
				MsgBox, The update/ download appears to have been successful or you clicked cancel. Please check the update folder %A_ScriptDir% for the download. To install unzip it and replace the existing files with the ones found in the zip. 
			else 
				MsgBox, some other crazy error occured. 
	}
	Return
}

LaunchUpdate()
{
	MiscIni := MiscIni()
	IniRead, LastUpdate, %MiscIni%, Update Check, Last Update, 20230120080629
	EnvSub, LastUpdate, %A_Now%, hours
	If (LastUpdate < 9)
	{
		UpdateCheck()
	}
}