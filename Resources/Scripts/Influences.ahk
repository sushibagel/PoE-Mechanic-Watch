#NoTrayIcon
#SingleInstance force
GroupAdd, PoeWindow, ahk_exe PathOfExileSteam.exe
GroupAdd, PoeWindow, ahk_exe PathOfExile.exe 
GroupAdd, PoeWindow, ahk_exe PathOfExileEGS.exe
DetectHiddenWindows, On
Global LogPath
Global SearingActive
Global EaterActive
Global InfluenceTrack
Global Influences
Global InfluenceActive
Global width
Global heigth
Global Length
Global HK
Global NotMaps
Global MyHideout
Global Background
Global Font
Global Secondary
Global CurrentInfluence
Global InfluenceSound
Global InfluenceSoundActive
Global ReminderText
GroupAdd, PoeWindow, ahk_exe PathOfExileSteam.exe
GroupAdd, PoeWindow, ahk_exe PathOfExile.exe 
GroupAdd, PoeWindow, ahk_exe PathOfExileEGS.exe
GroupAdd, PoeWindow, Reminder
GroupAdd, PoeWindow, Overlay

WinWaitActive, ahk_Group PoeWindow

GoSub, GetLogPath
StringTrimRight, UpOneLevel, A_ScriptDir, 7
Gosub, GetHideout

IniRead, InfluenceSound, %UpOneLevel%Settings/notification.ini, Sounds, Influence
IniRead, InfluenceSoundActive, %UpOneLevel%Settings/notification.ini, Active, Influence
IniRead, ColorMode, %UpOneLevel%Settings/Theme.ini, Theme, Theme
IniRead, Font, %UpOneLevel%Settings/Theme.ini, %ColorMode%, Font
IniRead, Background, %UpOneLevel%Settings/Theme.ini, %ColorMode%, Background
IniRead, Secondary, %UpOneLevel%Settings/Theme.ini, %ColorMode%, Secondary

NotMaps = Karui Shores
GoSub, HotkeySet

If Hotkey contains +
{
    StringReplace, Hotkey, Hotkey, + , Shift +%A_Space%,
}
If Hotkey contains ^
{
    StringReplace, Hotkey, Hotkey, ^ , Control +%A_Space%,
}
If Hotkey contains !
{
    StringReplace, Hotkey, Hotkey, ! , Alt +%A_Space%,
}
If Hotkey contains #
{
    StringReplace, Hotkey, Hotkey, # , Win +%A_Space%,
}

InfluenceTrack:
Gosub, InfluenceActive
Winwait, Overlay
WinGetPos,Width, Height, Length,, Overlay
height := height - 50
Length := Length - 10

FileRead, map, %UpOneLevel%Data\maplist.txt

Loop
For each, MapName in StrSplit(Map, "`n", "`r")
{
MapTrack  := TF_Tail(LogPath, 3)
If MapTrack contains %MapName%
{
	If MapTrack contains %NotMaps%
	{
		Gosub, InfluenceTrack
		Break
	}
	If (CurrentInfluence != None)
	{
    IniRead, InfluenceTrack, %UpOneLevel%Settings/Mechanics.ini, InfluenceTrack, %InfluenceActive%
	OldTrack = %InfluenceTrack%
    InfluenceTrack ++
	ControlSetText, %OldTrack%, %InfluenceTrack%, Overlay
    IniWrite, %InfluenceTrack%, %UpOneLevel%Settings/Mechanics.ini, InfluenceTrack, %InfluenceActive%
    Gui, Influence:Color, %Background%
    Gui, Influence:Font, c%Font% s10
    Gui, Influence:-Border
    Gui, Influence:+AlwaysOnTop
    Gui, Influence:Add, Text,,You just entered a new map, press %HK% to subtract 1 map
    Gui, Influence:Show, NoActivate x-1000 y%height%, Influence
    WinSet, Style, -0xC00000, Influence
    WinGetPos, Xi, Yi, Widthi, Heighti, Influence
    Gui, Influence:Hide
    width := Width  + (Length/2) - (Widthi/2)
    Gui, Influence:Show, NoActivate x%width% y%height%, Influence
    SetTimer, CloseGui, -3000

    If (InfluenceTrack = 14)
        {
            If (InfluenceActive = "Searing")
            {
                ReminderText = This is your 14th map. Don't forget to kill the boss for your Polaric Invitation
            }
            If (InfluenceActive = "Eater")
            {
                ReminderText = This is your 14th map. Don't forget to kill the boss for your Writhing Invitation
            }
            Gosub, Reminder
        }
    If (InfluenceTrack = 28)
            {
            If (InfluenceActive = "Searing")
            {
				ReminderText = This is your 28th map. Don't forget to kill the boss for your Incandescent Invitation
            }
            If (InfluenceActive = "Eater")
            {
                ReminderText = This is your 28th map. Don't forget to kill the boss for your Screaming Invitation
            }
            Gosub, Reminder
        }
	}
    Loop
    {
		IfWinNotActive, ahk_group PoeWindow
		{
			Sleep, 200
			IfWinNotActive, ahk_group PoeWindow
			{
				Gui, Reminder:Destroy
				Loop
				{
					IfWinActive, ahk_group PoeWindow
					{
						Gosub, Reminder
						Break
					}
				}
			}
		}
        MapTrack  := TF_Tail(LogPath, 2)
        If MapTrack contains %MyHideout%
        {
			Sleep 500
            Return
			Break
        }
    }
}
}

CloseGui:
Gui, Influence:Destroy
Return

ReminderButtonOK:
Gui, Reminder:Destroy
If (InfluenceTrack = 28)
{
    IniWrite, 0, %UpOneLevel%Settings/Mechanics.ini, InfluenceTrack, %InfluenceActive%
}
WinActivate, ahk_group PoeWindow
Return

ReminderButtonRevertCount:
Gui, Reminder:Destroy
Gosub, SubtractOne
Return

Reminder:
If (InfluenceTrack = 14) or (InfluenceTrack = 28)
{
	Gui, Reminder:Font, c%Font% s12
	Gui, Reminder:Add, Text,,%ReminderText%
	height1 := (A_ScreenHeight / 2) - 100
	width1 := (A_ScreenWidth / 2)-180
	Gui, Reminder:Font, s10
	Gui, Reminder:Color, %Background%
	Gui, Reminder:-Border
	Gui, Reminder:+AlwaysOnTop
	Gui, Reminder:Add, Button, x150 y40, OK
	Gui, Reminder:Add, Button, x300 y40, Revert Count
	Gui, Reminder:Show, x%width1% y%height1%, Reminder
	WinSet, Style, -0xC00000, Reminder
	Gosub, NotificationSound
	Return
}

SubtractOne:
Gosub, InfluenceActive
InfluenceActive = 
InfluenceTrack = 
If (EaterActive = 1)
{
    IniRead, InfluenceTrack, %UpOneLevel%Settings/Mechanics.ini, InfluenceTrack, Eater
    OldTrack = %InfluenceTrack%
    InfluenceTrack := InfluenceTrack - 1
	If(InfluenceTrack = -1)
	{
		InfluenceTrack = 27
	}
    IniWrite, %InfluenceTrack%, %UpOneLevel%Settings/Mechanics.ini, InfluenceTrack, Eater
}
If (SearingActive = 1)
{
    IniRead, InfluenceTrack, %UpOneLevel%Settings/Mechanics.ini, InfluenceTrack, Searing
    OldTrack = %InfluenceTrack%
    InfluenceTrack := InfluenceTrack - 1
		If(InfluenceTrack = -1)
	{
		InfluenceTrack = 27
	}
    IniWrite, %InfluenceTrack%, %UpOneLevel%Settings/Mechanics.ini, InfluenceTrack, Searing
}
Sleep, 100
ControlSetText, %OldTrack%, %InfluenceTrack%, Overlay
    Loop
    {
        MapTrack  := TF_Tail(LogPath, 3)
        If MapTrack contains %MyHideout%
        {
			Sleep 500
            Reload
			Break
        }
    }
Return

InfluenceActive:
FileRead, Influences, %UpOneLevel%Data/Influences.txt
For each, Influence in StrSplit(Influences, "|")
{
    IniRead, %Influence%, %UpOneLevel%Settings/Mechanics.ini, Influence, %Influence%
    If (%Influence% = 1)
    %Influence%Active := 1
    InfluenceActive = %Influence%
    If (%Influence% = 0)
    %Influence%Active := 0
}

If (SearingActive = 1)
{
    InfluenceActive = Searing
}

If (EaterActive = 1)
{
    InfluenceActive = Eater
}

If (EaterActive = 0) and (SearingActive = 0)
{
	CurrentInfluence = None
}
Else
{
	CurrentInfluence = %InfluenceActive%
}
Return

GetLogPath:
WinGet, POEpath, ProcessPath, Path of Exile

IfInstring, POEpath, PathOfExileSteam.exe
{
    StringTrimRight, POEPathTrim, POEpath, 20
}

IfInstring, POEpath, PathOfExile_x64Steam.exe
{
    StringTrimRight, POEPathTrim, POEpath, 23
}

IfInstring, POEpath, Client.exe
{
    StringTrimRight, POEPathTrim, POEpath, 10
}

IfInstring, POEpath, PathOfExile.exe
{
    StringTrimRight, POEPathTrim, POEpath, 15
}

IfInstring, POEpath, PathOfExile_x64.exe
{
    StringTrimRight, POEPathTrim, POEpath, 18
}

IfInstring, POEpath, PathOfExileEGS.exe
{
    StringTrimRight, POEPathTrim, POEpath, 18 
}

IfInstring, POEpath, PathOfExile_x64EGS.exe
{
    StringTrimRight, POEPathTrim, POEpath, 21 
}

If (LogPath = "logs\Client.txt")
{
    IniRead, LogPath, %UpOneLevel%\Data\LaunchPath.ini, POE, Log
    msgbox, help
}


LogPath = %POEPathTrim%logs\Client.txt
Return

HotkeySet:
IniRead, Hotkey1, %UpOneLevel%Settings/Hotkeys.ini, Hotkeys, 1
IniRead, ReloadCheck, %UpOneLevel%Settings/Hotkeys.ini, Reload, Influences
Hk := Hotkey1
If !(Hk = "")
{
	Hotkey, %HK%, SubtractOne
	If (ReloadCheck = 1)
	{
		Hotkey, %Hk%, Off
		IniWrite, 0, %UpOneLevel%Settings/Hotkeys.ini, Reload, Influences
	}
}
Return

GetHideout:
FileReadLine, hideoutcheck, %UpOneLevel%Settings/CurrentHideout.txt, 1
StringTrimLeft, MyHideout, hideoutcheck, 12 
Return

NotificationSound:
If (InfluenceSoundActive = 1)
{
	IniRead, CheckVolume, %UpOneLevel%/Settings/notification.ini, Volume, Influence
	SoundPlay, %UpOneLevel%/Sounds/blank.wav ;;;;; super hacky workaround but works....
	SetWindowVol("ahk_exe Autohotkey.exe", 0)
	CheckVolume = +%CheckVolume%
	SetWindowVol("ahk_exe Autohotkey.exe", CheckVolume)
	SoundPlay, %InfluenceSound%
}
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Volume Adjust Script ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Volume_Up::setWindowVol(,"+15")
Volume_Down::setWindowVol(,"-15")

setWindowVol(winName:="a",vol:="n"){
	if (vol=="n")
		return
	winGet,winPid,PID,% winName
	if !(volume:=GetVolumeObject(winPid))
		return
	vsign:=subStr(vol,1,1)
	if (vsign="+"||vsign="-") {
		vol:=subStr(vol,2),vol/=100
		
		VA_ISimpleAudioVolume_GetMasterVolume(volume,cvol)
		if (vsign="+")
			vol:=cvol+vol>1?1:cvol+vol
		else if (vsign="-")
			vol:=cvol-vol<0?0:cvol-vol
	} else
		vol/=100
	VA_ISimpleAudioVolume_SetMasterVolume(volume,vol),objRelease(volume)
}

VA_GetMasterVolume(channel="", device_desc="playback")
{
    if ! aev := VA_GetAudioEndpointVolume(device_desc)
        return
    if channel =
        VA_IAudioEndpointVolume_GetMasterVolumeLevelScalar(aev, vol)
    else
        VA_IAudioEndpointVolume_GetChannelVolumeLevelScalar(aev, channel-1, vol)
    ObjRelease(aev)
    return Round(vol*100,3)
}

VA_SetMasterVolume(vol, channel="", device_desc="playback")
{
    vol := vol>100 ? 100 : vol<0 ? 0 : vol
    if ! aev := VA_GetAudioEndpointVolume(device_desc)
        return
    if channel =
        VA_IAudioEndpointVolume_SetMasterVolumeLevelScalar(aev, vol/100)
    else
        VA_IAudioEndpointVolume_SetChannelVolumeLevelScalar(aev, channel-1, vol/100)
    ObjRelease(aev)
}

VA_GetMasterChannelCount(device_desc="playback")
{
    if ! aev := VA_GetAudioEndpointVolume(device_desc)
        return
    VA_IAudioEndpointVolume_GetChannelCount(aev, count)
    ObjRelease(aev)
    return count
}

VA_SetMasterMute(mute, device_desc="playback")
{
    if ! aev := VA_GetAudioEndpointVolume(device_desc)
        return
    VA_IAudioEndpointVolume_SetMute(aev, mute)
    ObjRelease(aev)
}

VA_GetMasterMute(device_desc="playback")
{
    if ! aev := VA_GetAudioEndpointVolume(device_desc)
        return
    VA_IAudioEndpointVolume_GetMute(aev, mute)
    ObjRelease(aev)
    return mute
}

;
; SUBUNIT CONTROLS
;

VA_GetVolume(subunit_desc="1", channel="", device_desc="playback")
{
    if ! avl := VA_GetDeviceSubunit(device_desc, subunit_desc, "{7FB7B48F-531D-44A2-BCB3-5AD5A134B3DC}")
        return
    VA_IPerChannelDbLevel_GetChannelCount(avl, channel_count)
    if channel =
    {
        vol = 0
        
        Loop, %channel_count%
        {
            VA_IPerChannelDbLevel_GetLevelRange(avl, A_Index-1, min_dB, max_dB, step_dB)
            VA_IPerChannelDbLevel_GetLevel(avl, A_Index-1, this_vol)
            this_vol := VA_dB2Scalar(this_vol, min_dB, max_dB)
            
            ; "Speakers Properties" reports the highest channel as the volume.
            if (this_vol > vol)
                vol := this_vol
        }
    }
    else if channel between 1 and channel_count
    {
        channel -= 1
        VA_IPerChannelDbLevel_GetLevelRange(avl, channel, min_dB, max_dB, step_dB)
        VA_IPerChannelDbLevel_GetLevel(avl, channel, vol)
        vol := VA_dB2Scalar(vol, min_dB, max_dB)
    }
    ObjRelease(avl)
    return vol
}

VA_SetVolume(vol, subunit_desc="1", channel="", device_desc="playback")
{
    if ! avl := VA_GetDeviceSubunit(device_desc, subunit_desc, "{7FB7B48F-531D-44A2-BCB3-5AD5A134B3DC}")
        return
    
    vol := vol<0 ? 0 : vol>100 ? 100 : vol
    
    VA_IPerChannelDbLevel_GetChannelCount(avl, channel_count)
    
    if channel =
    {
        ; Simple method -- resets balance to "center":
        ;VA_IPerChannelDbLevel_SetLevelUniform(avl, vol)
        
        vol_max = 0
        
        Loop, %channel_count%
        {
            VA_IPerChannelDbLevel_GetLevelRange(avl, A_Index-1, min_dB, max_dB, step_dB)
            VA_IPerChannelDbLevel_GetLevel(avl, A_Index-1, this_vol)
            this_vol := VA_dB2Scalar(this_vol, min_dB, max_dB)
            
            channel%A_Index%vol := this_vol
            channel%A_Index%min := min_dB
            channel%A_Index%max := max_dB
            
            ; Scale all channels relative to the loudest channel.
            ; (This is how Vista's "Speakers Properties" dialog seems to work.)
            if (this_vol > vol_max)
                vol_max := this_vol
        }
        
        Loop, %channel_count%
        {
            this_vol := vol_max ? channel%A_Index%vol / vol_max * vol : vol
            this_vol := VA_Scalar2dB(this_vol/100, channel%A_Index%min, channel%A_Index%max)            
            VA_IPerChannelDbLevel_SetLevel(avl, A_Index-1, this_vol)
        }
    }
    else if channel between 1 and %channel_count%
    {
        channel -= 1
        VA_IPerChannelDbLevel_GetLevelRange(avl, channel, min_dB, max_dB, step_dB)
        VA_IPerChannelDbLevel_SetLevel(avl, channel, VA_Scalar2dB(vol/100, min_dB, max_dB))
    }
    ObjRelease(avl)
}

VA_GetChannelCount(subunit_desc="1", device_desc="playback")
{
    if ! avl := VA_GetDeviceSubunit(device_desc, subunit_desc, "{7FB7B48F-531D-44A2-BCB3-5AD5A134B3DC}")
        return
    VA_IPerChannelDbLevel_GetChannelCount(avl, channel_count)
    ObjRelease(avl)
    return channel_count
}

VA_SetMute(mute, subunit_desc="1", device_desc="playback")
{
    if ! amute := VA_GetDeviceSubunit(device_desc, subunit_desc, "{DF45AEEA-B74A-4B6B-AFAD-2366B6AA012E}")
        return
    VA_IAudioMute_SetMute(amute, mute)
    ObjRelease(amute)
}

VA_GetMute(subunit_desc="1", device_desc="playback")
{
    if ! amute := VA_GetDeviceSubunit(device_desc, subunit_desc, "{DF45AEEA-B74A-4B6B-AFAD-2366B6AA012E}")
        return
    VA_IAudioMute_GetMute(amute, muted)
    ObjRelease(amute)
    return muted
}

;
; AUDIO METERING
;

VA_GetAudioMeter(device_desc="playback")
{
    if ! device := VA_GetDevice(device_desc)
        return 0
    VA_IMMDevice_Activate(device, "{C02216F6-8C67-4B5B-9D00-D008E73E0064}", 7, 0, audioMeter)
    ObjRelease(device)
    return audioMeter
}

VA_GetDevicePeriod(device_desc, ByRef default_period, ByRef minimum_period="")
{
    defaultPeriod := minimumPeriod := 0
    if ! device := VA_GetDevice(device_desc)
        return false
    VA_IMMDevice_Activate(device, "{1CB9AD4C-DBFA-4c32-B178-C2F568A703B2}", 7, 0, audioClient)
    ObjRelease(device)
    ; IAudioClient::GetDevicePeriod
    DllCall(NumGet(NumGet(audioClient+0)+9*A_PtrSize), "ptr",audioClient, "int64*",default_period, "int64*",minimum_period)
    ; Convert 100-nanosecond units to milliseconds.
    default_period /= 10000
    minimum_period /= 10000    
    ObjRelease(audioClient)
    return true
}

VA_GetAudioEndpointVolume(device_desc="playback")
{
    if ! device := VA_GetDevice(device_desc)
        return 0
    VA_IMMDevice_Activate(device, "{5CDF2C82-841E-4546-9722-0CF74078229A}", 7, 0, endpointVolume)
    ObjRelease(device)
    return endpointVolume
}

VA_GetDeviceSubunit(device_desc, subunit_desc, subunit_iid)
{
    if ! device := VA_GetDevice(device_desc)
        return 0
    subunit := VA_FindSubunit(device, subunit_desc, subunit_iid)
    ObjRelease(device)
    return subunit
}

VA_FindSubunit(device, target_desc, target_iid)
{
    if target_desc is integer
        target_index := target_desc
    else
        RegExMatch(target_desc, "(?<_name>.*?)(?::(?<_index>\d+))?$", target)
    ; v2.01: Since target_name is now a regular expression, default to case-insensitive mode if no options are specified.
    if !RegExMatch(target_name,"^[^\(]+\)")
        target_name := "i)" target_name
    r := VA_EnumSubunits(device, "VA_FindSubunitCallback", target_name, target_iid
            , Object(0, target_index ? target_index : 1, 1, 0))
    return r
}

VA_FindSubunitCallback(part, interface, index)
{
    index[1] := index[1] + 1 ; current += 1
    if (index[0] == index[1]) ; target == current ?
    {
        ObjAddRef(interface)
        return interface
    }
}

VA_EnumSubunits(device, callback, target_name="", target_iid="", callback_param="")
{
    VA_IMMDevice_Activate(device, "{2A07407E-6497-4A18-9787-32F79BD0D98F}", 7, 0, deviceTopology)
    VA_IDeviceTopology_GetConnector(deviceTopology, 0, conn)
    ObjRelease(deviceTopology)
    VA_IConnector_GetConnectedTo(conn, conn_to)
    VA_IConnector_GetDataFlow(conn, data_flow)
    ObjRelease(conn)
    if !conn_to
        return ; blank to indicate error
    part := ComObjQuery(conn_to, "{AE2DE0E4-5BCA-4F2D-AA46-5D13F8FDB3A9}") ; IID_IPart
    ObjRelease(conn_to)
    if !part
        return
    r := VA_EnumSubunitsEx(part, data_flow, callback, target_name, target_iid, callback_param)
    ObjRelease(part)
    return r ; value returned by callback, or zero.
}

VA_EnumSubunitsEx(part, data_flow, callback, target_name="", target_iid="", callback_param="")
{
    r := 0
    
    VA_IPart_GetPartType(part, type)
   
    if type = 1 ; Subunit
    {
        VA_IPart_GetName(part, name)
        
        ; v2.01: target_name is now a regular expression.
        if RegExMatch(name, target_name)
        {
            if target_iid =
                r := %callback%(part, 0, callback_param)
            else
                if VA_IPart_Activate(part, 7, target_iid, interface) = 0
                {
                    r := %callback%(part, interface, callback_param)
                    ; The callback is responsible for calling ObjAddRef()
                    ; if it intends to keep the interface pointer.
                    ObjRelease(interface)
                }

            if r
                return r ; early termination
        }
    }
    
    if data_flow = 0
        VA_IPart_EnumPartsIncoming(part, parts)
    else
        VA_IPart_EnumPartsOutgoing(part, parts)
    
    VA_IPartsList_GetCount(parts, count)
    Loop %count%
    {
        VA_IPartsList_GetPart(parts, A_Index-1, subpart)        
        r := VA_EnumSubunitsEx(subpart, data_flow, callback, target_name, target_iid, callback_param)
        ObjRelease(subpart)
        if r
            break ; early termination
    }
    ObjRelease(parts)
    return r ; continue/finished enumeration
}

; device_desc = device_id
;               | ( friendly_name | 'playback' | 'capture' ) [ ':' index ]
VA_GetDevice(device_desc="playback")
{
    static CLSID_MMDeviceEnumerator := "{BCDE0395-E52F-467C-8E3D-C4579291692E}"
        , IID_IMMDeviceEnumerator := "{A95664D2-9614-4F35-A746-DE8DB63617E6}"
    if !(deviceEnumerator := ComObjCreate(CLSID_MMDeviceEnumerator, IID_IMMDeviceEnumerator))
        return 0
    
    device := 0
    
    if VA_IMMDeviceEnumerator_GetDevice(deviceEnumerator, device_desc, device) = 0
        goto VA_GetDevice_Return
    
    if device_desc is integer
    {
        m2 := device_desc
        if m2 >= 4096 ; Probably a device pointer, passed here indirectly via VA_GetAudioMeter or such.
        {
            ObjAddRef(device := m2)
            goto VA_GetDevice_Return
        }
    }
    else
        RegExMatch(device_desc, "(.*?)\s*(?::(\d+))?$", m)
    
    if m1 in playback,p
        m1 := "", flow := 0 ; eRender
    else if m1 in capture,c
        m1 := "", flow := 1 ; eCapture
    else if (m1 . m2) = ""  ; no name or number specified
        m1 := "", flow := 0 ; eRender (default)
    else
        flow := 2 ; eAll
    
    if (m1 . m2) = ""   ; no name or number (maybe "playback" or "capture")
    {
        VA_IMMDeviceEnumerator_GetDefaultAudioEndpoint(deviceEnumerator, flow, 0, device)
        goto VA_GetDevice_Return
    }

    VA_IMMDeviceEnumerator_EnumAudioEndpoints(deviceEnumerator, flow, 1, devices)
    
    if m1 =
    {
        VA_IMMDeviceCollection_Item(devices, m2-1, device)
        goto VA_GetDevice_Return
    }
    
    VA_IMMDeviceCollection_GetCount(devices, count)
    index := 0
    Loop % count
        if VA_IMMDeviceCollection_Item(devices, A_Index-1, device) = 0
            if InStr(VA_GetDeviceName(device), m1) && (m2 = "" || ++index = m2)
                goto VA_GetDevice_Return
            else
                ObjRelease(device), device:=0

VA_GetDevice_Return:
    ObjRelease(deviceEnumerator)
    if devices
        ObjRelease(devices)
    
    return device ; may be 0
}

VA_GetDeviceName(device)
{
    static PKEY_Device_FriendlyName
    if !VarSetCapacity(PKEY_Device_FriendlyName)
        VarSetCapacity(PKEY_Device_FriendlyName, 20)
        ,VA_GUID(PKEY_Device_FriendlyName :="{A45C254E-DF1C-4EFD-8020-67D146A850E0}")
        ,NumPut(14, PKEY_Device_FriendlyName, 16)
    VarSetCapacity(prop, 16)
    VA_IMMDevice_OpenPropertyStore(device, 0, store)
    ; store->GetValue(.., [out] prop)
    DllCall(NumGet(NumGet(store+0)+5*A_PtrSize), "ptr", store, "ptr", &PKEY_Device_FriendlyName, "ptr", &prop)
    ObjRelease(store)
    VA_WStrOut(deviceName := NumGet(prop,8))
    return deviceName
}

VA_SetDefaultEndpoint(device_desc, role)
{
    /* Roles:
         eConsole        = 0  ; Default Device
         eMultimedia     = 1
         eCommunications = 2  ; Default Communications Device
    */
    if ! device := VA_GetDevice(device_desc)
        return 0
    if VA_IMMDevice_GetId(device, id) = 0
    {
        cfg := ComObjCreate("{294935CE-F637-4E7C-A41B-AB255460B862}"
                          , "{568b9108-44bf-40b4-9006-86afe5b5a620}")
        hr := VA_xIPolicyConfigVista_SetDefaultEndpoint(cfg, id, role)
        ObjRelease(cfg)
    }
    ObjRelease(device)
    return hr = 0
}


;
; HELPERS
;

; Convert string to binary GUID structure.
VA_GUID(ByRef guid_out, guid_in="%guid_out%") {
    if (guid_in == "%guid_out%")
        guid_in :=   guid_out
    if  guid_in is integer
        return guid_in
    VarSetCapacity(guid_out, 16, 0)
	DllCall("ole32\CLSIDFromString", "wstr", guid_in, "ptr", &guid_out)
	return &guid_out
}

; Convert binary GUID structure to string.
VA_GUIDOut(ByRef guid) {
    VarSetCapacity(buf, 78)
    DllCall("ole32\StringFromGUID2", "ptr", &guid, "ptr", &buf, "int", 39)
    guid := StrGet(&buf, "UTF-16")
}

; Convert COM-allocated wide char string pointer to usable string.
VA_WStrOut(ByRef str) {
    str := StrGet(ptr := str, "UTF-16")
    DllCall("ole32\CoTaskMemFree", "ptr", ptr)  ; FREES THE STRING.
}

VA_dB2Scalar(dB, min_dB, max_dB) {
    min_s := 10**(min_dB/20), max_s := 10**(max_dB/20)
    return ((10**(dB/20))-min_s)/(max_s-min_s)*100
}

VA_Scalar2dB(s, min_dB, max_dB) {
    min_s := 10**(min_dB/20), max_s := 10**(max_dB/20)
    return log((max_s-min_s)*s+min_s)*20
}


;
; INTERFACE WRAPPERS
;   Reference: Core Audio APIs in Windows Vista -- Programming Reference
;       http://msdn2.microsoft.com/en-us/library/ms679156(VS.85).aspx
;

;
; IMMDevice : {D666063F-1587-4E43-81F1-B948E807363F}
;
VA_IMMDevice_Activate(this, iid, ClsCtx, ActivationParams, ByRef Interface) {
    return DllCall(NumGet(NumGet(this+0)+3*A_PtrSize), "ptr", this, "ptr", VA_GUID(iid), "uint", ClsCtx, "uint", ActivationParams, "ptr*", Interface)
}
VA_IMMDevice_OpenPropertyStore(this, Access, ByRef Properties) {
    return DllCall(NumGet(NumGet(this+0)+4*A_PtrSize), "ptr", this, "uint", Access, "ptr*", Properties)
}
VA_IMMDevice_GetId(this, ByRef Id) {
    hr := DllCall(NumGet(NumGet(this+0)+5*A_PtrSize), "ptr", this, "uint*", Id)
    VA_WStrOut(Id)
    return hr
}
VA_IMMDevice_GetState(this, ByRef State) {
    return DllCall(NumGet(NumGet(this+0)+6*A_PtrSize), "ptr", this, "uint*", State)
}

;
; IDeviceTopology : {2A07407E-6497-4A18-9787-32F79BD0D98F}
;
VA_IDeviceTopology_GetConnectorCount(this, ByRef Count) {
    return DllCall(NumGet(NumGet(this+0)+3*A_PtrSize), "ptr", this, "uint*", Count)
}
VA_IDeviceTopology_GetConnector(this, Index, ByRef Connector) {
    return DllCall(NumGet(NumGet(this+0)+4*A_PtrSize), "ptr", this, "uint", Index, "ptr*", Connector)
}
VA_IDeviceTopology_GetSubunitCount(this, ByRef Count) {
    return DllCall(NumGet(NumGet(this+0)+5*A_PtrSize), "ptr", this, "uint*", Count)
}
VA_IDeviceTopology_GetSubunit(this, Index, ByRef Subunit) {
    return DllCall(NumGet(NumGet(this+0)+6*A_PtrSize), "ptr", this, "uint", Index, "ptr*", Subunit)
}
VA_IDeviceTopology_GetPartById(this, Id, ByRef Part) {
    return DllCall(NumGet(NumGet(this+0)+7*A_PtrSize), "ptr", this, "uint", Id, "ptr*", Part)
}
VA_IDeviceTopology_GetDeviceId(this, ByRef DeviceId) {
    hr := DllCall(NumGet(NumGet(this+0)+8*A_PtrSize), "ptr", this, "uint*", DeviceId)
    VA_WStrOut(DeviceId)
    return hr
}
VA_IDeviceTopology_GetSignalPath(this, PartFrom, PartTo, RejectMixedPaths, ByRef Parts) {
    return DllCall(NumGet(NumGet(this+0)+9*A_PtrSize), "ptr", this, "ptr", PartFrom, "ptr", PartTo, "int", RejectMixedPaths, "ptr*", Parts)
}

;
; IConnector : {9c2c4058-23f5-41de-877a-df3af236a09e}
;
VA_IConnector_GetType(this, ByRef Type) {
    return DllCall(NumGet(NumGet(this+0)+3*A_PtrSize), "ptr", this, "int*", Type)
}
VA_IConnector_GetDataFlow(this, ByRef Flow) {
    return DllCall(NumGet(NumGet(this+0)+4*A_PtrSize), "ptr", this, "int*", Flow)
}
VA_IConnector_ConnectTo(this, ConnectTo) {
    return DllCall(NumGet(NumGet(this+0)+5*A_PtrSize), "ptr", this, "ptr", ConnectTo)
}
VA_IConnector_Disconnect(this) {
    return DllCall(NumGet(NumGet(this+0)+6*A_PtrSize), "ptr", this)
}
VA_IConnector_IsConnected(this, ByRef Connected) {
    return DllCall(NumGet(NumGet(this+0)+7*A_PtrSize), "ptr", this, "int*", Connected)
}
VA_IConnector_GetConnectedTo(this, ByRef ConTo) {
    return DllCall(NumGet(NumGet(this+0)+8*A_PtrSize), "ptr", this, "ptr*", ConTo)
}
VA_IConnector_GetConnectorIdConnectedTo(this, ByRef ConnectorId) {
    hr := DllCall(NumGet(NumGet(this+0)+9*A_PtrSize), "ptr", this, "ptr*", ConnectorId)
    VA_WStrOut(ConnectorId)
    return hr
}
VA_IConnector_GetDeviceIdConnectedTo(this, ByRef DeviceId) {
    hr := DllCall(NumGet(NumGet(this+0)+10*A_PtrSize), "ptr", this, "ptr*", DeviceId)
    VA_WStrOut(DeviceId)
    return hr
}

;
; IPart : {AE2DE0E4-5BCA-4F2D-AA46-5D13F8FDB3A9}
;
VA_IPart_GetName(this, ByRef Name) {
    hr := DllCall(NumGet(NumGet(this+0)+3*A_PtrSize), "ptr", this, "ptr*", Name)
    VA_WStrOut(Name)
    return hr
}
VA_IPart_GetLocalId(this, ByRef Id) {
    return DllCall(NumGet(NumGet(this+0)+4*A_PtrSize), "ptr", this, "uint*", Id)
}
VA_IPart_GetGlobalId(this, ByRef GlobalId) {
    hr := DllCall(NumGet(NumGet(this+0)+5*A_PtrSize), "ptr", this, "ptr*", GlobalId)
    VA_WStrOut(GlobalId)
    return hr
}
VA_IPart_GetPartType(this, ByRef PartType) {
    return DllCall(NumGet(NumGet(this+0)+6*A_PtrSize), "ptr", this, "int*", PartType)
}
VA_IPart_GetSubType(this, ByRef SubType) {
    VarSetCapacity(SubType,16,0)
    hr := DllCall(NumGet(NumGet(this+0)+7*A_PtrSize), "ptr", this, "ptr", &SubType)
    VA_GUIDOut(SubType)
    return hr
}
VA_IPart_GetControlInterfaceCount(this, ByRef Count) {
    return DllCall(NumGet(NumGet(this+0)+8*A_PtrSize), "ptr", this, "uint*", Count)
}
VA_IPart_GetControlInterface(this, Index, ByRef InterfaceDesc) {
    return DllCall(NumGet(NumGet(this+0)+9*A_PtrSize), "ptr", this, "uint", Index, "ptr*", InterfaceDesc)
}
VA_IPart_EnumPartsIncoming(this, ByRef Parts) {
    return DllCall(NumGet(NumGet(this+0)+10*A_PtrSize), "ptr", this, "ptr*", Parts)
}
VA_IPart_EnumPartsOutgoing(this, ByRef Parts) {
    return DllCall(NumGet(NumGet(this+0)+11*A_PtrSize), "ptr", this, "ptr*", Parts)
}
VA_IPart_GetTopologyObject(this, ByRef Topology) {
    return DllCall(NumGet(NumGet(this+0)+12*A_PtrSize), "ptr", this, "ptr*", Topology)
}
VA_IPart_Activate(this, ClsContext, iid, ByRef Object) {
    return DllCall(NumGet(NumGet(this+0)+13*A_PtrSize), "ptr", this, "uint", ClsContext, "ptr", VA_GUID(iid), "ptr*", Object)
}
VA_IPart_RegisterControlChangeCallback(this, iid, Notify) {
    return DllCall(NumGet(NumGet(this+0)+14*A_PtrSize), "ptr", this, "ptr", VA_GUID(iid), "ptr", Notify)
}
VA_IPart_UnregisterControlChangeCallback(this, Notify) {
    return DllCall(NumGet(NumGet(this+0)+15*A_PtrSize), "ptr", this, "ptr", Notify)
}

;
; IPartsList : {6DAA848C-5EB0-45CC-AEA5-998A2CDA1FFB}
;
VA_IPartsList_GetCount(this, ByRef Count) {
    return DllCall(NumGet(NumGet(this+0)+3*A_PtrSize), "ptr", this, "uint*", Count)
}
VA_IPartsList_GetPart(this, INdex, ByRef Part) {
    return DllCall(NumGet(NumGet(this+0)+4*A_PtrSize), "ptr", this, "uint", Index, "ptr*", Part)
}

;
; IAudioEndpointVolume : {5CDF2C82-841E-4546-9722-0CF74078229A}
;
VA_IAudioEndpointVolume_RegisterControlChangeNotify(this, Notify) {
    return DllCall(NumGet(NumGet(this+0)+3*A_PtrSize), "ptr", this, "ptr", Notify)
}
VA_IAudioEndpointVolume_UnregisterControlChangeNotify(this, Notify) {
    return DllCall(NumGet(NumGet(this+0)+4*A_PtrSize), "ptr", this, "ptr", Notify)
}
VA_IAudioEndpointVolume_GetChannelCount(this, ByRef ChannelCount) {
    return DllCall(NumGet(NumGet(this+0)+5*A_PtrSize), "ptr", this, "uint*", ChannelCount)
}
VA_IAudioEndpointVolume_SetMasterVolumeLevel(this, LevelDB, GuidEventContext="") {
    return DllCall(NumGet(NumGet(this+0)+6*A_PtrSize), "ptr", this, "float", LevelDB, "ptr", VA_GUID(GuidEventContext))
}
VA_IAudioEndpointVolume_SetMasterVolumeLevelScalar(this, Level, GuidEventContext="") {
    return DllCall(NumGet(NumGet(this+0)+7*A_PtrSize), "ptr", this, "float", Level, "ptr", VA_GUID(GuidEventContext))
}
VA_IAudioEndpointVolume_GetMasterVolumeLevel(this, ByRef LevelDB) {
    return DllCall(NumGet(NumGet(this+0)+8*A_PtrSize), "ptr", this, "float*", LevelDB)
}
VA_IAudioEndpointVolume_GetMasterVolumeLevelScalar(this, ByRef Level) {
    return DllCall(NumGet(NumGet(this+0)+9*A_PtrSize), "ptr", this, "float*", Level)
}
VA_IAudioEndpointVolume_SetChannelVolumeLevel(this, Channel, LevelDB, GuidEventContext="") {
    return DllCall(NumGet(NumGet(this+0)+10*A_PtrSize), "ptr", this, "uint", Channel, "float", LevelDB, "ptr", VA_GUID(GuidEventContext))
}
VA_IAudioEndpointVolume_SetChannelVolumeLevelScalar(this, Channel, Level, GuidEventContext="") {
    return DllCall(NumGet(NumGet(this+0)+11*A_PtrSize), "ptr", this, "uint", Channel, "float", Level, "ptr", VA_GUID(GuidEventContext))
}
VA_IAudioEndpointVolume_GetChannelVolumeLevel(this, Channel, ByRef LevelDB) {
    return DllCall(NumGet(NumGet(this+0)+12*A_PtrSize), "ptr", this, "uint", Channel, "float*", LevelDB)
}
VA_IAudioEndpointVolume_GetChannelVolumeLevelScalar(this, Channel, ByRef Level) {
    return DllCall(NumGet(NumGet(this+0)+13*A_PtrSize), "ptr", this, "uint", Channel, "float*", Level)
}
VA_IAudioEndpointVolume_SetMute(this, Mute, GuidEventContext="") {
    return DllCall(NumGet(NumGet(this+0)+14*A_PtrSize), "ptr", this, "int", Mute, "ptr", VA_GUID(GuidEventContext))
}
VA_IAudioEndpointVolume_GetMute(this, ByRef Mute) {
    return DllCall(NumGet(NumGet(this+0)+15*A_PtrSize), "ptr", this, "int*", Mute)
}
VA_IAudioEndpointVolume_GetVolumeStepInfo(this, ByRef Step, ByRef StepCount) {
    return DllCall(NumGet(NumGet(this+0)+16*A_PtrSize), "ptr", this, "uint*", Step, "uint*", StepCount)
}
VA_IAudioEndpointVolume_VolumeStepUp(this, GuidEventContext="") {
    return DllCall(NumGet(NumGet(this+0)+17*A_PtrSize), "ptr", this, "ptr", VA_GUID(GuidEventContext))
}
VA_IAudioEndpointVolume_VolumeStepDown(this, GuidEventContext="") {
    return DllCall(NumGet(NumGet(this+0)+18*A_PtrSize), "ptr", this, "ptr", VA_GUID(GuidEventContext))
}
VA_IAudioEndpointVolume_QueryHardwareSupport(this, ByRef HardwareSupportMask) {
    return DllCall(NumGet(NumGet(this+0)+19*A_PtrSize), "ptr", this, "uint*", HardwareSupportMask)
}
VA_IAudioEndpointVolume_GetVolumeRange(this, ByRef MinDB, ByRef MaxDB, ByRef IncrementDB) {
    return DllCall(NumGet(NumGet(this+0)+20*A_PtrSize), "ptr", this, "float*", MinDB, "float*", MaxDB, "float*", IncrementDB)
}

;
; IPerChannelDbLevel  : {C2F8E001-F205-4BC9-99BC-C13B1E048CCB}
;   IAudioVolumeLevel : {7FB7B48F-531D-44A2-BCB3-5AD5A134B3DC}
;   IAudioBass        : {A2B1A1D9-4DB3-425D-A2B2-BD335CB3E2E5}
;   IAudioMidrange    : {5E54B6D7-B44B-40D9-9A9E-E691D9CE6EDF}
;   IAudioTreble      : {0A717812-694E-4907-B74B-BAFA5CFDCA7B}
;
VA_IPerChannelDbLevel_GetChannelCount(this, ByRef Channels) {
    return DllCall(NumGet(NumGet(this+0)+3*A_PtrSize), "ptr", this, "uint*", Channels)
}
VA_IPerChannelDbLevel_GetLevelRange(this, Channel, ByRef MinLevelDB, ByRef MaxLevelDB, ByRef Stepping) {
    return DllCall(NumGet(NumGet(this+0)+4*A_PtrSize), "ptr", this, "uint", Channel, "float*", MinLevelDB, "float*", MaxLevelDB, "float*", Stepping)
}
VA_IPerChannelDbLevel_GetLevel(this, Channel, ByRef LevelDB) {
    return DllCall(NumGet(NumGet(this+0)+5*A_PtrSize), "ptr", this, "uint", Channel, "float*", LevelDB)
}
VA_IPerChannelDbLevel_SetLevel(this, Channel, LevelDB, GuidEventContext="") {
    return DllCall(NumGet(NumGet(this+0)+6*A_PtrSize), "ptr", this, "uint", Channel, "float", LevelDB, "ptr", VA_GUID(GuidEventContext))
}
VA_IPerChannelDbLevel_SetLevelUniform(this, LevelDB, GuidEventContext="") {
    return DllCall(NumGet(NumGet(this+0)+7*A_PtrSize), "ptr", this, "float", LevelDB, "ptr", VA_GUID(GuidEventContext))
}
VA_IPerChannelDbLevel_SetLevelAllChannels(this, LevelsDB, ChannelCount, GuidEventContext="") {
    return DllCall(NumGet(NumGet(this+0)+8*A_PtrSize), "ptr", this, "uint", LevelsDB, "uint", ChannelCount, "ptr", VA_GUID(GuidEventContext))
}

;
; IAudioMute : {DF45AEEA-B74A-4B6B-AFAD-2366B6AA012E}
;
VA_IAudioMute_SetMute(this, Muted, GuidEventContext="") {
    return DllCall(NumGet(NumGet(this+0)+3*A_PtrSize), "ptr", this, "int", Muted, "ptr", VA_GUID(GuidEventContext))
}
VA_IAudioMute_GetMute(this, ByRef Muted) {
    return DllCall(NumGet(NumGet(this+0)+4*A_PtrSize), "ptr", this, "int*", Muted)
}

;
; IAudioAutoGainControl : {85401FD4-6DE4-4b9d-9869-2D6753A82F3C}
;
VA_IAudioAutoGainControl_GetEnabled(this, ByRef Enabled) {
    return DllCall(NumGet(NumGet(this+0)+3*A_PtrSize), "ptr", this, "int*", Enabled)
}
VA_IAudioAutoGainControl_SetEnabled(this, Enable, GuidEventContext="") {
    return DllCall(NumGet(NumGet(this+0)+4*A_PtrSize), "ptr", this, "int", Enable, "ptr", VA_GUID(GuidEventContext))
}

;
; IAudioMeterInformation : {C02216F6-8C67-4B5B-9D00-D008E73E0064}
;
VA_IAudioMeterInformation_GetPeakValue(this, ByRef Peak) {
    return DllCall(NumGet(NumGet(this+0)+3*A_PtrSize), "ptr", this, "float*", Peak)
}
VA_IAudioMeterInformation_GetMeteringChannelCount(this, ByRef ChannelCount) {
    return DllCall(NumGet(NumGet(this+0)+4*A_PtrSize), "ptr", this, "uint*", ChannelCount)
}
VA_IAudioMeterInformation_GetChannelsPeakValues(this, ChannelCount, PeakValues) {
    return DllCall(NumGet(NumGet(this+0)+5*A_PtrSize), "ptr", this, "uint", ChannelCount, "ptr", PeakValues)
}
VA_IAudioMeterInformation_QueryHardwareSupport(this, ByRef HardwareSupportMask) {
    return DllCall(NumGet(NumGet(this+0)+6*A_PtrSize), "ptr", this, "uint*", HardwareSupportMask)
}

;
; IAudioClient : {1CB9AD4C-DBFA-4c32-B178-C2F568A703B2}
;
VA_IAudioClient_Initialize(this, ShareMode, StreamFlags, BufferDuration, Periodicity, Format, AudioSessionGuid) {
    return DllCall(NumGet(NumGet(this+0)+3*A_PtrSize), "ptr", this, "int", ShareMode, "uint", StreamFlags, "int64", BufferDuration, "int64", Periodicity, "ptr", Format, "ptr", VA_GUID(AudioSessionGuid))
}
VA_IAudioClient_GetBufferSize(this, ByRef NumBufferFrames) {
    return DllCall(NumGet(NumGet(this+0)+4*A_PtrSize), "ptr", this, "uint*", NumBufferFrames)
}
VA_IAudioClient_GetStreamLatency(this, ByRef Latency) {
    return DllCall(NumGet(NumGet(this+0)+5*A_PtrSize), "ptr", this, "int64*", Latency)
}
VA_IAudioClient_GetCurrentPadding(this, ByRef NumPaddingFrames) {
    return DllCall(NumGet(NumGet(this+0)+6*A_PtrSize), "ptr", this, "uint*", NumPaddingFrames)
}
VA_IAudioClient_IsFormatSupported(this, ShareMode, Format, ByRef ClosestMatch) {
    return DllCall(NumGet(NumGet(this+0)+7*A_PtrSize), "ptr", this, "int", ShareMode, "ptr", Format, "ptr*", ClosestMatch)
}
VA_IAudioClient_GetMixFormat(this, ByRef Format) {
    return DllCall(NumGet(NumGet(this+0)+8*A_PtrSize), "ptr", this, "uint*", Format)
}
VA_IAudioClient_GetDevicePeriod(this, ByRef DefaultDevicePeriod, ByRef MinimumDevicePeriod) {
    return DllCall(NumGet(NumGet(this+0)+9*A_PtrSize), "ptr", this, "int64*", DefaultDevicePeriod, "int64*", MinimumDevicePeriod)
}
VA_IAudioClient_Start(this) {
    return DllCall(NumGet(NumGet(this+0)+10*A_PtrSize), "ptr", this)
}
VA_IAudioClient_Stop(this) {
    return DllCall(NumGet(NumGet(this+0)+11*A_PtrSize), "ptr", this)
}
VA_IAudioClient_Reset(this) {
    return DllCall(NumGet(NumGet(this+0)+12*A_PtrSize), "ptr", this)
}
VA_IAudioClient_SetEventHandle(this, eventHandle) {
    return DllCall(NumGet(NumGet(this+0)+13*A_PtrSize), "ptr", this, "ptr", eventHandle)
}
VA_IAudioClient_GetService(this, iid, ByRef Service) {
    return DllCall(NumGet(NumGet(this+0)+14*A_PtrSize), "ptr", this, "ptr", VA_GUID(iid), "ptr*", Service)
}

;
; IAudioSessionControl : {F4B1A599-7266-4319-A8CA-E70ACB11E8CD}
;
/*
AudioSessionStateInactive = 0
AudioSessionStateActive = 1
AudioSessionStateExpired = 2
*/
VA_IAudioSessionControl_GetState(this, ByRef State) {
    return DllCall(NumGet(NumGet(this+0)+3*A_PtrSize), "ptr", this, "int*", State)
}
VA_IAudioSessionControl_GetDisplayName(this, ByRef DisplayName) {
    hr := DllCall(NumGet(NumGet(this+0)+4*A_PtrSize), "ptr", this, "ptr*", DisplayName)
    VA_WStrOut(DisplayName)
    return hr
}
VA_IAudioSessionControl_SetDisplayName(this, DisplayName, EventContext) {
    return DllCall(NumGet(NumGet(this+0)+5*A_PtrSize), "ptr", this, "wstr", DisplayName, "ptr", VA_GUID(EventContext))
}
VA_IAudioSessionControl_GetIconPath(this, ByRef IconPath) {
    hr := DllCall(NumGet(NumGet(this+0)+6*A_PtrSize), "ptr", this, "ptr*", IconPath)
    VA_WStrOut(IconPath)
    return hr
}
VA_IAudioSessionControl_SetIconPath(this, IconPath) {
    return DllCall(NumGet(NumGet(this+0)+7*A_PtrSize), "ptr", this, "wstr", IconPath)
}
VA_IAudioSessionControl_GetGroupingParam(this, ByRef Param) {
    VarSetCapacity(Param,16,0)
    hr := DllCall(NumGet(NumGet(this+0)+8*A_PtrSize), "ptr", this, "ptr", &Param)
    VA_GUIDOut(Param)
    return hr
}
VA_IAudioSessionControl_SetGroupingParam(this, Param, EventContext) {
    return DllCall(NumGet(NumGet(this+0)+9*A_PtrSize), "ptr", this, "ptr", VA_GUID(Param), "ptr", VA_GUID(EventContext))
}
VA_IAudioSessionControl_RegisterAudioSessionNotification(this, NewNotifications) {
    return DllCall(NumGet(NumGet(this+0)+10*A_PtrSize), "ptr", this, "ptr", NewNotifications)
}
VA_IAudioSessionControl_UnregisterAudioSessionNotification(this, NewNotifications) {
    return DllCall(NumGet(NumGet(this+0)+11*A_PtrSize), "ptr", this, "ptr", NewNotifications)
}

;
; IAudioSessionManager : {BFA971F1-4D5E-40BB-935E-967039BFBEE4}
;
VA_IAudioSessionManager_GetAudioSessionControl(this, AudioSessionGuid) {
    return DllCall(NumGet(NumGet(this+0)+3*A_PtrSize), "ptr", this, "ptr", VA_GUID(AudioSessionGuid))
}
VA_IAudioSessionManager_GetSimpleAudioVolume(this, AudioSessionGuid, StreamFlags, ByRef AudioVolume) {
    return DllCall(NumGet(NumGet(this+0)+4*A_PtrSize), "ptr", this, "ptr", VA_GUID(AudioSessionGuid), "uint", StreamFlags, "uint*", AudioVolume)
}

;
; IMMDeviceEnumerator
;
VA_IMMDeviceEnumerator_EnumAudioEndpoints(this, DataFlow, StateMask, ByRef Devices) {
    return DllCall(NumGet(NumGet(this+0)+3*A_PtrSize), "ptr", this, "int", DataFlow, "uint", StateMask, "ptr*", Devices)
}
VA_IMMDeviceEnumerator_GetDefaultAudioEndpoint(this, DataFlow, Role, ByRef Endpoint) {
    return DllCall(NumGet(NumGet(this+0)+4*A_PtrSize), "ptr", this, "int", DataFlow, "int", Role, "ptr*", Endpoint)
}
VA_IMMDeviceEnumerator_GetDevice(this, id, ByRef Device) {
    return DllCall(NumGet(NumGet(this+0)+5*A_PtrSize), "ptr", this, "wstr", id, "ptr*", Device)
}
VA_IMMDeviceEnumerator_RegisterEndpointNotificationCallback(this, Client) {
    return DllCall(NumGet(NumGet(this+0)+6*A_PtrSize), "ptr", this, "ptr", Client)
}
VA_IMMDeviceEnumerator_UnregisterEndpointNotificationCallback(this, Client) {
    return DllCall(NumGet(NumGet(this+0)+7*A_PtrSize), "ptr", this, "ptr", Client)
}

;
; IMMDeviceCollection
;
VA_IMMDeviceCollection_GetCount(this, ByRef Count) {
    return DllCall(NumGet(NumGet(this+0)+3*A_PtrSize), "ptr", this, "uint*", Count)
}
VA_IMMDeviceCollection_Item(this, Index, ByRef Device) {
    return DllCall(NumGet(NumGet(this+0)+4*A_PtrSize), "ptr", this, "uint", Index, "ptr*", Device)
}

;
; IControlInterface
;
VA_IControlInterface_GetName(this, ByRef Name) {
    hr := DllCall(NumGet(NumGet(this+0)+3*A_PtrSize), "ptr", this, "ptr*", Name)
    VA_WStrOut(Name)
    return hr
}
VA_IControlInterface_GetIID(this, ByRef IID) {
    VarSetCapacity(IID,16,0)
    hr := DllCall(NumGet(NumGet(this+0)+4*A_PtrSize), "ptr", this, "ptr", &IID)
    VA_GUIDOut(IID)
    return hr
}


/*
    INTERFACES REQUIRING WINDOWS 7 / SERVER 2008 R2
*/

;
; IAudioSessionControl2 : {bfb7ff88-7239-4fc9-8fa2-07c950be9c6d}
;   extends IAudioSessionControl
;
VA_IAudioSessionControl2_GetSessionIdentifier(this, ByRef id) {
    hr := DllCall(NumGet(NumGet(this+0)+12*A_PtrSize), "ptr", this, "ptr*", id)
    VA_WStrOut(id)
    return hr
}
VA_IAudioSessionControl2_GetSessionInstanceIdentifier(this, ByRef id) {
    hr := DllCall(NumGet(NumGet(this+0)+13*A_PtrSize), "ptr", this, "ptr*", id)
    VA_WStrOut(id)
    return hr
}
VA_IAudioSessionControl2_GetProcessId(this, ByRef pid) {
    return DllCall(NumGet(NumGet(this+0)+14*A_PtrSize), "ptr", this, "uint*", pid)
}
VA_IAudioSessionControl2_IsSystemSoundsSession(this) {
    return DllCall(NumGet(NumGet(this+0)+15*A_PtrSize), "ptr", this)
}
VA_IAudioSessionControl2_SetDuckingPreference(this, OptOut) {
    return DllCall(NumGet(NumGet(this+0)+16*A_PtrSize), "ptr", this, "int", OptOut)
}

;
; IAudioSessionManager2 : {77AA99A0-1BD6-484F-8BC7-2C654C9A9B6F}
;   extends IAudioSessionManager
;
VA_IAudioSessionManager2_GetSessionEnumerator(this, ByRef SessionEnum) {
    return DllCall(NumGet(NumGet(this+0)+5*A_PtrSize), "ptr", this, "ptr*", SessionEnum)
}
VA_IAudioSessionManager2_RegisterSessionNotification(this, SessionNotification) {
    return DllCall(NumGet(NumGet(this+0)+6*A_PtrSize), "ptr", this, "ptr", SessionNotification)
}
VA_IAudioSessionManager2_UnregisterSessionNotification(this, SessionNotification) {
    return DllCall(NumGet(NumGet(this+0)+7*A_PtrSize), "ptr", this, "ptr", SessionNotification)
}
VA_IAudioSessionManager2_RegisterDuckNotification(this, SessionNotification) {
    return DllCall(NumGet(NumGet(this+0)+8*A_PtrSize), "ptr", this, "ptr", SessionNotification)
}
VA_IAudioSessionManager2_UnregisterDuckNotification(this, SessionNotification) {
    return DllCall(NumGet(NumGet(this+0)+9*A_PtrSize), "ptr", this, "ptr", SessionNotification)
}

;
; IAudioSessionEnumerator : {E2F5BB11-0570-40CA-ACDD-3AA01277DEE8}
;
VA_IAudioSessionEnumerator_GetCount(this, ByRef SessionCount) {
    return DllCall(NumGet(NumGet(this+0)+3*A_PtrSize), "ptr", this, "int*", SessionCount)
}
VA_IAudioSessionEnumerator_GetSession(this, SessionCount, ByRef Session) {
    return DllCall(NumGet(NumGet(this+0)+4*A_PtrSize), "ptr", this, "int", SessionCount, "ptr*", Session)
}


/*
    UNDOCUMENTED INTERFACES
*/

; Thanks to Dave Amenta for publishing this interface - http://goo.gl/6L93L
; IID := "{568b9108-44bf-40b4-9006-86afe5b5a620}"
; CLSID := "{294935CE-F637-4E7C-A41B-AB255460B862}"
VA_xIPolicyConfigVista_SetDefaultEndpoint(this, DeviceId, Role) {
    return DllCall(NumGet(NumGet(this+0)+12*A_PtrSize), "ptr", this, "wstr", DeviceId, "int", Role)
}

;
; ISimpleAudioVolume : {87CE5498-68D6-44E5-9215-6DA47EF883D8}
;
VA_ISimpleAudioVolume_SetMasterVolume(this, ByRef fLevel, GuidEventContext="") {
    return DllCall(NumGet(NumGet(this+0)+3*A_PtrSize), "ptr", this, "float", fLevel, "ptr", VA_GUID(GuidEventContext))
}
VA_ISimpleAudioVolume_GetMasterVolume(this, ByRef fLevel) {
    return DllCall(NumGet(NumGet(this+0)+4*A_PtrSize), "ptr", this, "float*", fLevel)
}
VA_ISimpleAudioVolume_SetMute(this, ByRef Muted, GuidEventContext="") {
    return DllCall(NumGet(NumGet(this+0)+5*A_PtrSize), "ptr", this, "int", Muted, "ptr", VA_GUID(GuidEventContext))
}
VA_ISimpleAudioVolume_GetMute(this, ByRef Muted) {
    return DllCall(NumGet(NumGet(this+0)+6*A_PtrSize), "ptr", this, "int*", Muted)
}

;Required for app specific mute
GetVolumeObject(Param = 0)
{
    static IID_IASM2 := "{77AA99A0-1BD6-484F-8BC7-2C654C9A9B6F}"
    , IID_IASC2 := "{bfb7ff88-7239-4fc9-8fa2-07c950be9c6d}"
    , IID_ISAV := "{87CE5498-68D6-44E5-9215-6DA47EF883D8}"
    
    ; Get PID from process name
    if Param is not Integer
    {
        Process, Exist, %Param%
        Param := ErrorLevel
    }
    
    ; GetDefaultAudioEndpoint
    DAE := VA_GetDevice()
    
    ; activate the session manager
    VA_IMMDevice_Activate(DAE, IID_IASM2, 0, 0, IASM2)
    
    ; enumerate sessions for on this device
    VA_IAudioSessionManager2_GetSessionEnumerator(IASM2, IASE)
    VA_IAudioSessionEnumerator_GetCount(IASE, Count)
    
    ; search for an audio session with the required name
    Loop, % Count
    {
        ; Get the IAudioSessionControl object
        VA_IAudioSessionEnumerator_GetSession(IASE, A_Index-1, IASC)
        
        ; Query the IAudioSessionControl for an IAudioSessionControl2 object
        IASC2 := ComObjQuery(IASC, IID_IASC2)
        ObjRelease(IASC)
        
        ; Get the session's process ID
        VA_IAudioSessionControl2_GetProcessID(IASC2, SPID)
        
        ; If the process name is the one we are looking for
        if (SPID == Param)
        {
            ; Query for the ISimpleAudioVolume
            ISAV := ComObjQuery(IASC2, IID_ISAV)
            
            ObjRelease(IASC2)
            break
        }
        ObjRelease(IASC2)
    }
    ObjRelease(IASE)
    ObjRelease(IASM2)
    ObjRelease(DAE)
    return ISAV
}



;;;;;;;; TF Info Here ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
/*
Name          : TF: Textfile & String Library for AutoHotkey
Version       : 3.8
Documentation : https://github.com/hi5/TF
AutoHotkey.com: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=576
AutoHotkey.com: http://www.autohotkey.com/forum/topic46195.html (Also for examples)
License       : see license.txt (GPL 2.0)

Credits & History: See documentation at GH above.

Structure of most functions:

TF_...(Text, other parameters)
	{
	 ; get the basic data we need for further processing and returning the output:
	 TF_GetData(OW, Text, FileName)
	 ; OW = 0 Copy inputfile
	 ; OW = 1 Overwrite inputfile
	 ; OW = 2 Return variable
	 ; Text : either contents of file or the var that was passed on
	 ; FileName : Used in case OW is 0 or 1 (=file), not used for OW=2 (variable)

	 ; Creates a matchlist for use in Loop below
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; A_ThisFunc useful for debugging your scripts

	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			{
			...
			}
		 Else
			{
			...
			}
		}
	 ; either copy or overwrite file or return variable
	 Return TF_ReturnOutPut(OW, OutPut, FileName, TrimTrailing, CreateNewFile)
	 ; OW 0 or 1 = file
	 ; Output = new content of file to save or variable to return
	 ; FileName
	 ; TrimTrailing: because of the loops used most functions will add trailing newline, this will remove it by default
	 ; CreateNewFile: To create a file that doesn't exist this parameter is needed, only used in few functions
	}

*/

TF_CountLines(Text)
	{
	 TF_GetData(OW, Text, FileName)
	 StringReplace, Text, Text, `n, `n, UseErrorLevel
	 Return ErrorLevel + 1
	}

TF_ReadLines(Text, StartLine = 1, EndLine = 0, Trailing = 0)
	{
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			OutPut .= A_LoopField "`n"
		 Else if (A_Index => EndLine)
			Break
		}
	 OW = 2 ; make sure we return variable not process file
	 Return TF_ReturnOutPut(OW, OutPut, FileName, Trailing)
	}

TF_ReplaceInLines(Text, StartLine = 1, EndLine = 0, SearchText = "", ReplaceText = "")
	{
	 TF_GetData(OW, Text, FileName)
	 IfNotInString, Text, %SearchText%
		Return Text ; SearchText not in TextFile so return and do nothing, we have to return Text in case of a variable otherwise it would empty the variable contents bug fix 3.3
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			{
			 StringReplace, LoopField, A_LoopField, %SearchText%, %ReplaceText%, All
			 OutPut .= LoopField "`n"
			}
		 Else
			OutPut .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_Replace(Text, SearchText, ReplaceText="")
	{
	 TF_GetData(OW, Text, FileName)
	 IfNotInString, Text, %SearchText%
		Return Text ; SearchText not in TextFile so return and do nothing, we have to return Text in case of a variable otherwise it would empty the variable contents bug fix 3.3
	 Loop
		{
		 StringReplace, Text, Text, %SearchText%, %ReplaceText%, All
		 if (ErrorLevel = 0) ; No more replacements needed.
			break
		}
	 Return TF_ReturnOutPut(OW, Text, FileName, 0)
	}

TF_RegExReplaceInLines(Text, StartLine = 1, EndLine = 0, NeedleRegEx = "", Replacement = "")
	{
	 options:="^[imsxADJUXPS]+\)" ; Hat tip to sinkfaze http://www.autohotkey.com/forum/viewtopic.php?t=60062
	 If RegExMatch(searchText,options,o)
		searchText := RegExReplace(searchText,options,(!InStr(o,"m") ? "m$0" : "$0"))
	 Else searchText := "m)" . searchText
	 TF_GetData(OW, Text, FileName)
		If (RegExMatch(Text, SearchText) < 1)
			Return Text ; SearchText not in TextFile so return and do nothing, we have to return Text in case of a variable otherwise it would empty the variable contents bug fix 3.3

	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			{
			 LoopField := RegExReplace(A_LoopField, NeedleRegEx, Replacement)
			 OutPut .= LoopField "`n"
			}
		 Else
			OutPut .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_RegExReplace(Text, NeedleRegEx = "", Replacement = "")
	{
	 options:="^[imsxADJUXPS]+\)" ; Hat tip to sinkfaze http://www.autohotkey.com/forum/viewtopic.php?t=60062
	 if RegExMatch(searchText,options,o)
		searchText := RegExReplace(searchText,options,(!InStr(o,"m") ? "m$0" : "$0"))
	 else searchText := "m)" . searchText
	 TF_GetData(OW, Text, FileName)
		If (RegExMatch(Text, SearchText) < 1)
			Return Text ; SearchText not in TextFile so return and do nothing, we have to return Text in case of a variable otherwise it would empty the variable contents bug fix 3.3
	 Text := RegExReplace(Text, NeedleRegEx, Replacement)
	 Return TF_ReturnOutPut(OW, Text, FileName, 0)
	}

TF_RemoveLines(Text, StartLine = 1, EndLine = 0)
	{
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			Continue
		 Else
			OutPut .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_RemoveBlankLines(Text, StartLine = 1, EndLine = 0)
	{
	 TF_GetData(OW, Text, FileName)
	 If (RegExMatch(Text, "[\S]+?\r?\n?") < 1)
	 	Return Text ; No empty lines so return and do nothing, we have to return Text in case of a variable otherwise it would empty the variable contents bug fix 3.3
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			OutPut .= (RegExMatch(A_LoopField,"[\S]+?\r?\n?")) ? A_LoopField "`n" :
		 Else
			OutPut .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_RemoveDuplicateLines(Text, StartLine = 1, Endline = 0, Consecutive = 0, CaseSensitive = false)
	{
	 TF_GetData(OW, Text, FileName)
	 If (StartLine = "")
	 	StartLine = 1
	 If (Endline = 0 OR Endline = "")
		EndLine := TF_Count(Text, "`n") + 1
	 Loop, Parse, Text, `n, `r
		{
		 If (A_Index < StartLine)
			Section1 .= A_LoopField "`n"
		 If A_Index between %StartLine% and %Endline%
			{
			 If (Consecutive = 1)
				{
				 If (A_LoopField <> PreviousLine) ; method one for consecutive duplicate lines
					 Section2 .= A_LoopField "`n"
				 PreviousLine:=A_LoopField
				}
			 Else
				{
				 If !(InStr(SearchForSection2,"__bol__" . A_LoopField . "__eol__",CaseSensitive)) ; not found
				 	{
				 	 SearchForSection2 .= "__bol__" A_LoopField "__eol__" ; this makes it unique otherwise it could be a partial match
					 Section2 .= A_LoopField "`n"
				 	}
				}
			}
		 If (A_Index > EndLine)
			Section3 .= A_LoopField "`n"
		}
	 Output .= Section1 Section2 Section3
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_InsertLine(Text, StartLine = 1, Endline = 0, InsertText = "")
	{
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			Output .= InsertText "`n" A_LoopField "`n"
		 Else
			Output .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_ReplaceLine(Text, StartLine = 1, Endline = 0, ReplaceText = "")
	{
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			Output .= ReplaceText "`n"
		 Else
			Output .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_InsertPrefix(Text, StartLine = 1, EndLine = 0, InsertText = "")
	{
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			OutPut .= InsertText A_LoopField "`n"
		 Else
			OutPut .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_InsertSuffix(Text, StartLine = 1, EndLine = 0 , InsertText = "")
	{
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			OutPut .= A_LoopField InsertText "`n"
		 Else
			OutPut .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_TrimLeft(Text, StartLine = 1, EndLine = 0, Count = 1)
	{
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			{
			 StringTrimLeft, StrOutPut, A_LoopField, %Count%
			 OutPut .= StrOutPut "`n"
			}
		 Else
			OutPut .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_TrimRight(Text, StartLine = 1, EndLine = 0, Count = 1)
	{
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			{
			 StringTrimRight, StrOutPut, A_LoopField, %Count%
			 OutPut .= StrOutPut "`n"
			}
		 Else
			OutPut .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_AlignLeft(Text, StartLine = 1, EndLine = 0, Columns = 80, Padding = 0)
	{
	 Trim:=A_AutoTrim ; store trim settings
	 AutoTrim, On ; make sure AutoTrim is on
	 TF_GetData(OW, Text, FileName)
	 If (Endline = 0 OR Endline = "")
		EndLine := TF_Count(Text, "`n") + 1
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			{
			 LoopField = %A_LoopField% ; Make use of AutoTrim, should be faster then a RegExReplace. Trims leading and trailing spaces!
			 SpaceNum := Columns-StrLen(LoopField)-1
			 If (SpaceNum > 0) and (Padding = 1) ; requires padding + keep padding
				{
				 Left:=TF_SetWidth(LoopField,Columns, 0) ; align left
				 OutPut .= Left "`n"
				}
			 Else
				OutPut .= LoopField "`n"
			}
		 Else
		 	OutPut .= A_LoopField "`n"
		}
	 AutoTrim, %Trim%	; restore original Trim
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_AlignCenter(Text, StartLine = 1, EndLine = 0, Columns = 80, Padding = 0)
	{
	 Trim:=A_AutoTrim ; store trim settings
	 AutoTrim, On ; make sure AutoTrim is on
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			{
			 LoopField = %A_LoopField% ; Make use of AutoTrim, should be faster then a RegExReplace
			 SpaceNum := (Columns-StrLen(LoopField)-1)/2
			 If (Padding = 1) and (LoopField = "") ; skip empty lines, do not fill with spaces
				{
				 OutPut .= "`n"
				 Continue
				}
			 If (StrLen(LoopField) >= Columns)
				{
				 OutPut .= LoopField "`n" ; add as is
				 Continue
				}
			 Centered:=TF_SetWidth(LoopField,Columns, 1) ; align center using set width
			 OutPut .= Centered "`n"
			}
		 Else
			OutPut .= A_LoopField "`n"
		}
	 AutoTrim, %Trim%	; restore original Trim
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_AlignRight(Text, StartLine = 1, EndLine = 0, Columns = 80, Skip = 0)
	{
	 Trim:=A_AutoTrim ; store trim settings
	 AutoTrim, On ; make sure AutoTrim is on
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			{
			 LoopField = %A_LoopField% ; Make use of AutoTrim, should be faster then a RegExReplace
			 If (Skip = 1) and (LoopField = "") ; skip empty lines, do not fill with spaces
				{
				 OutPut .= "`n"
				 Continue
				}
			 If (StrLen(LoopField) >= Columns)
				{
				 OutPut .= LoopField "`n" ; add as is
				 Continue
				}
			 Right:=TF_SetWidth(LoopField,Columns, 2) ; align right using set width
			 OutPut .= Right "`n"
			}
		 Else
			OutPut .= A_LoopField "`n"
		}
	 AutoTrim, %Trim%	; restore original Trim
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

; Based on: CONCATenate text files, ftp://garbo.uwasa.fi/pc/ts/tsfltc22.zip
TF_ConCat(FirstTextFile, SecondTextFile, OutputFile = "", Blanks = 0, FirstPadMargin = 0, SecondPadMargin = 0)
	{
	 If (Blanks > 0)
		Loop, %Blanks%
			InsertBlanks .= A_Space
	 If (FirstPadMargin > 0)
		Loop, %FirstPadMargin%
			PaddingFile1 .= A_Space
	 If (SecondPadMargin > 0)
		Loop, %SecondPadMargin%
			PaddingFile2 .= A_Space
	 Text:=FirstTextFile
	 TF_GetData(OW, Text, FileName)
	 StringSplit, Str1Lines, Text, `n, `r
	 Text:=SecondTextFile
	 TF_GetData(OW, Text, FileName)
	 StringSplit, Str2Lines, Text, `n, `r
	 Text= ; clear mem

	 ; first we need to determine the file with the most lines for our loop
	 If (Str1Lines0 > Str2Lines0)
		MaxLoop:=Str1Lines0
	 Else
		MaxLoop:=Str2Lines0
	 Loop, %MaxLoop%
		{
		 Section1:=Str1Lines%A_Index%
		 Section2:=Str2Lines%A_Index%
		 OutPut .= Section1 PaddingFile1 InsertBlanks Section2 PaddingFile2 "`n"
		 Section1= ; otherwise it will remember the last line from the shortest file or var
		 Section2=
		}
	 OW=1 ; it is probably 0 so in that case it would create _copy, so set it to 1
	 If (OutPutFile = "") ; if OutPutFile is empty return as variable
		OW=2
	 Return TF_ReturnOutPut(OW, OutPut, OutputFile, 1, 1)
	}

TF_LineNumber(Text, Leading = 0, Restart = 0, Char = 0) ; HT ribbet.1
	{
	 global t
	 TF_GetData(OW, Text, FileName)
	 Lines:=TF_Count(Text, "`n") + 1
	 Padding:=StrLen(Lines)
	 If (Leading = 0) and (Char = 0)
		Char := A_Space
	 Loop, %Padding%
		PadLines .= Char
	 Loop, Parse, Text, `n, `r
		{
		 If Restart = 0
			MaxNo = %A_Index%
		 Else
			{
			 MaxNo++
			 If MaxNo > %Restart%
				MaxNo = 1
			}
		 LineNumber:= MaxNo
		 If (Leading = 1)
			{
			 LineNumber := Padlines LineNumber ; add padding
			 StringRight, LineNumber, LineNumber, StrLen(Lines) ; remove excess padding
			}
		 If (Leading = 0)
			{
			 LineNumber := LineNumber Padlines ; add padding
			 StringLeft, LineNumber, LineNumber, StrLen(Lines) ; remove excess padding
			}
		 OutPut .= LineNumber A_Space A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

; skip = 1, skip shorter lines (e.g. lines shorter startcolumn position)
; modified in TF 3.4, fixed in 3.5
TF_ColGet(Text, StartLine = 1, EndLine = 0, StartColumn = 1, EndColumn = 1, Skip = 0)
	{
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 If (StartColumn < 0)
		{
		 StartColumn++
		 Loop, Parse, Text, `n, `r ; parsing file/var
			{
			 If A_Index in %TF_MatchList%
				{
				 output .= SubStr(A_LoopField,StartColumn) "`n"
				}
			 else
				 output .= A_LoopField "`n"
			}
		 Return TF_ReturnOutPut(OW, OutPut, FileName)
		}
	 if RegExMatch(StartColumn, ",|\+|-")
		{
		 StartColumn:=_MakeMatchList(Text, StartColumn, 1, 1)
		 Loop, Parse, Text, `n, `r ; parsing file/var
			{
			 If A_Index in %TF_MatchList%
				{
				 loop, parse, A_LoopField ; parsing LINE char by char
					{
					 If A_Index in %StartColumn% ; if col in index get char
						output .= A_LoopField
					}
				 output .= "`n"
				}
			 else
				 output .= A_LoopField "`n"
			}
		 output .= A_LoopField "`n"
		}
	 else
		{
		 EndColumn:=(EndColumn+1)-StartColumn
		 Loop, Parse, Text, `n, `r
			{
			 If A_Index in %TF_MatchList%
				{
				 StringMid, Section, A_LoopField, StartColumn, EndColumn
				 If (Skip = 1) and (StrLen(A_LoopField) < StartColumn)
					Continue
				 OutPut .= Section "`n"
				}
			}
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

; Based on: COLPUT.EXE & CUT.EXE, ftp://garbo.uwasa.fi/pc/ts/tsfltc22.zip
; modified in TF 3.4
TF_ColPut(Text, Startline = 1, EndLine = 0, StartColumn = 1, InsertText = "", Skip = 0)
	{
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 If RegExMatch(StartColumn, ",|\+")
		{
		 StartColumn:=_MakeMatchList(Text, StartColumn, 0, 1)
		 Loop, Parse, Text, `n, `r ; parsing file/var
			{
			 If A_Index in %TF_MatchList%
				{
				 loop, parse, A_LoopField ; parsing LINE char by char
					{
					 If A_Index in %StartColumn% ; if col in index insert text
						output .= InsertText A_LoopField
					 Else
						output .= A_LoopField
					}
				 output .= "`n"
				}
			 else
				 output .= A_LoopField "`n"
			}
		 output .= A_LoopField "`n"
		}
	 else
		{
		 StartColumn--
		 Loop, Parse, Text, `n, `r
			{
			 If A_Index in %TF_MatchList%
				{
				 If (StartColumn > 0)
					{
					 StringLeft, Section1, A_LoopField, StartColumn
					 StringMid, Section2, A_LoopField, StartColumn+1
					 If (Skip = 1) and (StrLen(A_LoopField) < StartColumn)
						OutPut .= Section1 Section2 "`n"
					}
				 Else
					{
					 Section1:=SubStr(A_LoopField, 1, StrLen(A_LoopField) + StartColumn + 1)
					 Section2:=SubStr(A_LoopField, StrLen(A_LoopField) + StartColumn + 2)
					 If (Skip = 1) and (A_LoopField = "")
						OutPut .= Section1 Section2 "`n"
					}
				 OutPut .= Section1 InsertText Section2 "`n"
				}
			 Else
				OutPut .= A_LoopField "`n"
			}
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

; modified TF 3.4
TF_ColCut(Text, StartLine = 1, EndLine = 0, StartColumn = 1, EndColumn = 1)
	{
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 If RegExMatch(StartColumn, ",|\+|-")
		{
		 StartColumn:=_MakeMatchList(Text, StartColumn, EndColumn, 1)
		 Loop, Parse, Text, `n, `r ; parsing file/var
			{
			 If A_Index in %TF_MatchList%
				{
				 loop, parse, A_LoopField ; parsing LINE char by char
					{
					 If A_Index not in %StartColumn% ; if col not in index get char
						output .= A_LoopField
					}
				 output .= "`n"
				}
			 else
				 output .= A_LoopField "`n"
			}
		 output .= A_LoopField "`n"
		}
	 else
		{
		 StartColumn--
		 EndColumn++
		 Loop, Parse, Text, `n, `r
			{
			 If A_Index in %TF_MatchList%
				{
				 StringLeft, Section1, A_LoopField, StartColumn
				 StringMid, Section2, A_LoopField, EndColumn
				 OutPut .= Section1 Section2 "`n"
				}
			 Else
				OutPut .= A_LoopField "`n"
			}
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_ReverseLines(Text, StartLine = 1, EndLine = 0)
	{
	 TF_GetData(OW, Text, FileName)
	 StringSplit, Line, Text, `n, `r ; line0 is number of lines
	 If (EndLine = 0 OR EndLine = "")
		EndLine:=Line0
	 If (EndLine > Line0)
		EndLine:=Line0
	 CountDown:=EndLine+1
	 Loop, Parse, Text, `n, `r
		{
		 If (A_Index < StartLine)
			Output1 .= A_LoopField "`n" ; section1
		 If A_Index between %StartLine% and %Endline%
			{
			 CountDown--
			 Output2 .= Line%CountDown% "`n" section2
			}
		 If (A_Index > EndLine)
			 Output3 .= A_LoopField "`n"
		}
	 OutPut.= Output1 Output2 Output3
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

;TF_SplitFileByLines
;example:
;TF_SplitFileByLines("TestFile.txt", "4", "sfile_", "txt", "1") ; split file every 3 lines
; InFile = 0 skip line e.g. do not include the actual line in any of the output files
; InFile = 1 include line IN current file
; InFile = 2 include line IN next file
TF_SplitFileByLines(Text, SplitAt, Prefix = "file", Extension = "txt", InFile = 1)
	{
	 LineCounter=1
	 FileCounter=1
	 Where:=SplitAt
	 Method=1
	 ; 1 = default, splitat every X lines,
	 ; 2 = splitat: - rotating if applicable
	 ; 3 = splitat: specific lines comma separated
	 TF_GetData(OW, Text, FileName)

	 IfInString, SplitAt, `- ; method 2
		{
		 StringSplit, Split, SplitAt, `-
		 Part=1
		 Where:=Split%Part%
		 Method=2
		}
	 IfInString, SplitAt, `, ; method 3
		{
		 StringSplit, Split, SplitAt, `,
		 Part=1
		 Where:=Split%Part%
		 Method=3
		}
	 Loop, Parse, Text, `n, `r
		{
		 OutPut .= A_LoopField "`n"
		 If (LineCounter = Where)
			{
			 If (InFile = 0)
				{
				 StringReplace, CheckOutput, PreviousOutput, `n, , All
				 StringReplace, CheckOutput, CheckOutput, `r, , All
				 If (CheckOutput <> "") and (OW <> 2) ; skip empty files
					TF_ReturnOutPut(1, PreviousOutput, Prefix FileCounter "." Extension, 0, 1)
				 If (CheckOutput <> "") and (OW = 2) ; skip empty files
					 TF_SetGlobal(Prefix FileCounter,PreviousOutput)
				 Output:=
				}
			 If (InFile = 1)
				{
				 StringReplace, CheckOutput, Output, `n, , All
				 StringReplace, CheckOutput, CheckOutput, `r, , All
				 If (CheckOutput <> "") and (OW <> 2) ; skip empty files
				 	 TF_ReturnOutPut(1, Output, Prefix FileCounter "." Extension, 0, 1)
				 If (CheckOutput <> "") and (OW = 2) ; skip empty files
				 	 TF_SetGlobal(Prefix FileCounter,Output)
				 Output:=
				}
			 If (InFile = 2)
				{
				 OutPut := PreviousOutput
				 StringReplace, CheckOutput, Output, `n, , All
				 StringReplace, CheckOutput, CheckOutput, `r, , All
				 If (CheckOutput <> "") and (OW <> 2) ; skip empty files
					 TF_ReturnOutPut(1, Output, Prefix FileCounter "." Extension, 0, 1)
				 If (CheckOutput <> "") and (OW = 2) ; output to array
				 	 TF_SetGlobal(Prefix FileCounter,Output)
				 OutPut := A_LoopField "`n"
				}
			 If (Method <> 3)
				 LineCounter=0 ; reset
			 FileCounter++ ; next file
			 Part++
			 If (Method = 2) ; 2 = splitat: - rotating if applicable
			 	{
			 If (Part > Split0)
					{
					 Part=1
					}
				 Where:=Split%Part%
				}
			 If (Method = 3) ; 3 = splitat: specific lines comma separated
				{
				 If (Part > Split0)
					Where:=Split%Split0%
				 Else
					Where:=Split%Part%
				}
			}
		 LineCounter++
		 PreviousOutput:=Output
		 PreviousLine:=A_LoopField
		}
	 StringReplace, CheckOutput, Output, `n, , All
	 StringReplace, CheckOutput, CheckOutput, `r, , All
	 If (CheckOutPut <> "") and (OW <> 2) ; skip empty files
		TF_ReturnOutPut(1, Output, Prefix FileCounter "." Extension, 0, 1)
	 If (CheckOutput <> "") and (OW = 2) ; output to array
		{
		 TF_SetGlobal(Prefix FileCounter,Output)
		 TF_SetGlobal(Prefix . "0" , FileCounter)
		}
	}

; TF_SplitFileByText("TestFile.txt", "button", "sfile_", "txt") ; split file at every line with button in it, can be regexp
; InFile = 0 skip line e.g. do not include the actual line in any of the output files
; InFile = 1 include line IN current file
; InFile = 2 include line IN next file
TF_SplitFileByText(Text, SplitAt, Prefix = "file", Extension = "txt", InFile = 1)
	{
	 LineCounter=1
	 FileCounter=1
	 TF_GetData(OW, Text, FileName)
	 SplitPath, TextFile,, Dir
	 Loop, Parse, Text, `n, `r
		{
		 OutPut .= A_LoopField "`n"
		 FoundPos:=RegExMatch(A_LoopField, SplitAt)
		 If (FoundPos > 0)
			{
			 If (InFile = 0)
				{
				 StringReplace, CheckOutput, PreviousOutput, `n, , All
				 StringReplace, CheckOutput, CheckOutput, `r, , All
				 If (CheckOutput <> "") and (OW <> 2) ; skip empty files
					TF_ReturnOutPut(1, PreviousOutput, Prefix FileCounter "." Extension, 0, 1)
				 If (CheckOutput <> "") and (OW = 2) ; output to array
					TF_SetGlobal(Prefix FileCounter,PreviousOutput)
				 Output:=
				}
			 If (InFile = 1)
				{
				 StringReplace, CheckOutput, Output, `n, , All
				 StringReplace, CheckOutput, CheckOutput, `r, , All
				 If (CheckOutput <> "") and (OW <> 2) ; skip empty files
					TF_ReturnOutPut(1, Output, Prefix FileCounter "." Extension, 0, 1)
				 If (CheckOutput <> "") and (OW = 2) ; output to array
					TF_SetGlobal(Prefix FileCounter,Output)
				 Output:=
				}
			 If (InFile = 2)
				{
				 OutPut := PreviousOutput
				 StringReplace, CheckOutput, Output, `n, , All
				 StringReplace, CheckOutput, CheckOutput, `r, , All
				 If (CheckOutput <> "") and (OW <> 2) ; skip empty files
					TF_ReturnOutPut(1, Output, Prefix FileCounter "." Extension, 0, 1)
				 If (CheckOutput <> "") and (OW = 2) ; output to array
					TF_SetGlobal(Prefix FileCounter,Output)
				 OutPut := A_LoopField "`n"
				}
			 LineCounter=0 ; reset
			 FileCounter++ ; next file
			}
		 LineCounter++
		 PreviousOutput:=Output
		 PreviousLine:=A_LoopField
		}
	 StringReplace, CheckOutput, Output, `n, , All
	 StringReplace, CheckOutput, CheckOutput, `r, , All
	 If (CheckOutPut <> "") and (OW <> 2) ; skip empty files
		TF_ReturnOutPut(1, Output, Prefix FileCounter "." Extension, 0, 1)
	 If (CheckOutput <> "") and (OW = 2) ; output to array
		{
		 TF_SetGlobal(Prefix FileCounter,Output)
		 TF_SetGlobal(Prefix . "0" , FileCounter)
		}
	}

TF_Find(Text, StartLine = 1, EndLine = 0, SearchText = "", ReturnFirst = 1, ReturnText = 0)
	{
	 options:="^[imsxADJUXPS]+\)"
	 if RegExMatch(searchText,options,o)
		searchText:=RegExReplace(searchText,options,(!InStr(o,"m") ? "m$0(*ANYCRLF)" : "$0"))
	 else searchText:="m)(*ANYCRLF)" searchText
	 options:="^[imsxADJUXPS]+\)" ; Hat tip to sinkfaze, see http://www.autohotkey.com/forum/viewtopic.php?t=60062
	 if RegExMatch(searchText,options,o)
		searchText := RegExReplace(searchText,options,(!InStr(o,"m") ? "m$0" : "$0"))
	 else searchText := "m)" . searchText

	 TF_GetData(OW, Text, FileName)
	 If (RegExMatch(Text, SearchText) < 1)
		Return "0" ; SearchText not in file or error, so do nothing

	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			{
			 If (RegExMatch(A_LoopField, SearchText) > 0)
				{
				 If (ReturnText = 0)
					Lines .= A_Index "," ; line number
				 Else If (ReturnText = 1)
					Lines .= A_LoopField "`n" ; text of line
				 Else If (ReturnText = 2)
					Lines .= A_Index ": " A_LoopField "`n" ; add line number
				 If (ReturnFirst = 1) ; only return first occurrence
					Break
				}
			}
		}
	 If (Lines <> "")
		StringTrimRight, Lines, Lines, 1 ; trim trailing , or `n
	 Else
		Lines = 0 ; make sure we return 0
	 Return Lines
	}

TF_Prepend(File1, File2)
	{
FileList=
(
%File1%
%File2%
)
TF_Merge(FileList,"`n", "!" . File2)
Return
	}

TF_Append(File1, File2)
	{
FileList=
(
%File2%
%File1%
)
TF_Merge(FileList,"`n", "!" . File2)
Return
	}

; For TF_Merge You will need to create a Filelist variable, one file per line,
; to pass on to the function:
; FileList=
; (
; c:\file1.txt
; c:\file2.txt
; )
; use Loop (files & folders) to create one quickly if you want to merge all TXT files for example
;
; Loop, c:\*.txt
;   FileList .= A_LoopFileFullPath "`n"
;
; By default, a new line is used as a separator between two text files
; !merged.txt deletes target file before starting to merge files
TF_Merge(FileList, Separator = "`n", FileName = "merged.txt")
	{
	 OW=0
	 Loop, Parse, FileList, `n, `r
		{
		 Append2File= ; Just make sure it is empty
		 IfExist, %A_LoopField%
			{
			 FileRead, Append2File, %A_LoopField%
			 If not ErrorLevel ; Successfully loaded
				Output .= Append2File Separator
			}
		}

	 If (SubStr(FileName,1,1)="!") ; check if we want to delete the target file before we start
		{
		 FileName:=SubStr(FileName,2)
		 OW=1
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName, 0, 1)
	}

TF_Wrap(Text, Columns = 80, AllowBreak = 0, StartLine = 1, EndLine = 0)
	{
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 If (AllowBreak = 1)
		Break=
	 Else
		Break=[ \r?\n]
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			{
			 If (StrLen(A_LoopField) > Columns)
				{
				 LoopField := A_LoopField " " ; just seems to work better by adding a space
				 OutPut .= RegExReplace(LoopField, "(.{1," . Columns . "})" . Break , "$1`n")
				}
			 Else
				OutPut .= A_LoopField "`n"
			}
		 Else
			 OutPut .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_WhiteSpace(Text, RemoveLeading = 1, RemoveTrailing = 1, StartLine = 1, EndLine = 0) {
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Trim:=A_AutoTrim ; store trim settings
	 AutoTrim, On ; make sure AutoTrim is on
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			{
			 If (RemoveLeading = 1) AND (RemoveTrailing = 1)
				{
				 LoopField = %A_LoopField%
				 Output .= LoopField "`n"
					 Continue
				}
			 If (RemoveLeading = 1) AND (RemoveTrailing = 0)
				{
				 LoopField := A_LoopField . "."
				 LoopField = %LoopField%
				 StringTrimRight, LoopField, LoopField, 1
				 Output .= LoopField "`n"
					 Continue
				}
			 If (RemoveLeading = 0) AND (RemoveTrailing = 1)
				{
				 LoopField := "." A_LoopField
				 LoopField = %LoopField%
				 StringTrimLeft, LoopField, LoopField, 1
				 Output .= LoopField "`n"
					 Continue
				}
			 If (RemoveLeading = 0) AND (RemoveTrailing = 0)
				{
				 Output .= A_LoopField "`n"
					 Continue
				}
			}
		 Else
			Output .= A_LoopField "`n"
		}
	AutoTrim, %Trim%	; restore original Trim
	Return TF_ReturnOutPut(OW, OutPut, FileName)
}

; Delete lines from file1 in file2 (using StringReplace)
; Partialmatch = 2 added in 3.4
TF_Substract(File1, File2, PartialMatch = 0) {
	Text:=File1
	TF_GetData(OW, Text, FileName)
	Str1:=Text
	Text:=File2
	TF_GetData(OW, Text, FileName)
		OutPut:=Text
	If (OW = 2)
		File1= ; free mem in case of var/text
	OutPut .= "`n" ; just to make sure the StringReplace will work

	If (PartialMatch = 2)
		{
		 Loop, Parse, Str1, `n, `r
			{
			 IfInString, Output, %A_LoopField%
				{
				 Output:= RegExReplace(Output, "im)^.*" . A_LoopField . ".*\r?\n?", replace)
				}
			}
		}
	Else If (PartialMatch = 1) ; allow paRTIal match
		{
		 Loop, Parse, Str1, `n, `r
			StringReplace, Output, Output, %A_LoopField%, , All ; remove lines from file1 in file2
		}
	Else If (PartialMatch = 0)
		{
		 search:="m)^(.*)$"
		 replace=__bol__$1__eol__
		 Output:=RegExReplace(Output, search, replace)
		 StringReplace, Output, Output, `n__eol__,__eol__ , All ; strange fix but seems to be needed.
		 Loop, Parse, Str1, `n, `r
			StringReplace, Output, Output, __bol__%A_LoopField%__eol__, , All ; remove lines from file1 in file2
		}
	If (PartialMatch = 0)
		{
		 StringReplace, Output, Output, __bol__, , All
		 StringReplace, Output, Output, __eol__, , All
		}

	; Remove all blank lines from the text in a variable:
	Loop
		{
		 StringReplace, Output, Output, `r`n`r`n, `r`n, UseErrorLevel
		 if (ErrorLevel = 0) or (ErrorLevel = 1) ; No more replacements needed.
			break
		}
	Return TF_ReturnOutPut(OW, OutPut, FileName, 0)
}

; Similar to "BK Replace EM" RangeReplace
TF_RangeReplace(Text, SearchTextBegin, SearchTextEnd, ReplaceText = "", CaseSensitive = "False", KeepBegin = 0, KeepEnd = 0)
	{
	 TF_GetData(OW, Text, FileName)
	 IfNotInString, Text, %SearchText%
		Return Text ; SearchTextBegin not in TextFile so return and do nothing, we have to return Text in case of a variable otherwise it would empty the variable contents bug fix 3.3
	 Start = 0
	 End = 0
	 If (KeepBegin = 1)
		 KeepBegin:=SearchTextBegin
	 Else
		 KeepBegin=
	 If (KeepEnd = 1)
		 KeepEnd:= SearchTextEnd
	 Else
		 KeepEnd=
	 If (SearchTextBegin = "")
		 Start=1
	 If (SearchTextEnd = "")
		 End=2

	 Loop, Parse, Text, `n, `r
		{
		 If (End = 1) ; end has been found already, replacement made simply continue to add all lines
			{
			 Output .= A_LoopField "`n"
				 Continue
			}
		 If (Start = 0) ; start hasn't been found
			{
			 If (InStr(A_LoopField,SearchTextBegin,CaseSensitive)) ; start has been found
				{
				 Start = 1
				 KeepSection := SubStr(A_LoopField, 1, InStr(A_LoopField, SearchTextBegin)-1)
				 EndSection := SubStr(A_LoopField, InStr(A_LoopField, SearchTextBegin)-1)
				 ; check if SearchEndText is in second part of line
				 If (InStr(EndSection,SearchTextEnd,CaseSensitive)) ; end found
					{
					 EndSection := ReplaceText KeepEnd SubStr(EndSection, InStr(EndSection, SearchTextEnd) + StrLen(SearchTextEnd) ) "`n"
					 If (End <> 2)
						End=1
					 If (End = 2)
					 	EndSection=
					}
				 Else
					EndSection=
				 Output .= KeepSection KeepBegin EndSection
				 Continue
				}
			 Else
				Output .= A_LoopField "`n" ; if not found yet simply add
				}
		 If (Start = 1) and (End <> 2) ; start has been found, now look for end if end isn't an empty string
			{
			 If (InStr(A_LoopField,SearchTextEnd,CaseSensitive)) ; end found
				{
				 End = 1
				 Output .= ReplaceText KeepEnd SubStr(A_LoopField, InStr(A_LoopField, SearchTextEnd) + StrLen(SearchTextEnd) ) "`n"
				}
			}
		}
	 If (End = 2)
		Output .= ReplaceText
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

; Create file of X lines and Y columns, fill with space or other character(s)
TF_MakeFile(Text, Lines = 1, Columns = 1, Fill = " ")
	{
	 OW=1
	 If (Text = "") ; if OutPutFile is empty return as variable
		OW=2
	 Loop, % Columns
		Cols .= Fill
	 Loop, % Lines
		Output .= Cols "`n"
	 Return TF_ReturnOutPut(OW, OutPut, Text, 1, 1)
	}

; Convert tabs to spaces, shorthand for TF_ReplaceInLines
TF_Tab2Spaces(Text, TabStop = 4, StartLine = 1, EndLine =0)
	{
	 Loop, % TabStop
		Replace .= A_Space
	 Return TF_ReplaceInLines(Text, StartLine, EndLine, A_Tab, Replace)
	}

; Convert spaces to tabs, shorthand for TF_ReplaceInLines
TF_Spaces2Tab(Text, TabStop = 4, StartLine = 1, EndLine =0)
	{
	 Loop, % TabStop
		Replace .= A_Space
	 Return TF_ReplaceInLines(Text, StartLine, EndLine, Replace, A_Tab)
	}

; Sort (section of) a text file
TF_Sort(Text, SortOptions = "", StartLine = 1, EndLine = 0) ; use the SORT options http://www.autohotkey.com/docs/commands/Sort.htm
	{
	 TF_GetData(OW, Text, FileName)
	 If StartLine contains -,+,`, ; no sections, incremental or multiple line input
		Return
	 If (StartLine = 1) and (Endline = 0) ; process entire file
		{
		 Output:=Text
		 Sort, Output, %SortOptions%
		}
	 Else
		{
		 Output := TF_ReadLines(Text, 1, StartLine-1) ; get first section
		 ToSort := TF_ReadLines(Text, StartLine, EndLine) ; get section to sort
		 Sort, ToSort, %SortOptions%
		 OutPut .= ToSort
		 OutPut .= TF_ReadLines(Text, EndLine+1) ; append last section
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName, 0) ; https://github.com/hi5/TF/issues/11
	}

TF_Tail(Text, Lines = 1, RemoveTrailing = 0, ReturnEmpty = 1)
	{
	 TF_GetData(OW, Text, FileName)
	 Neg = 0
	 If (Lines < 0)
		{
		 Neg=1
		 Lines:= Lines * -1
		}
	 If (ReturnEmpty = 0) ; remove blank lines first so we can't return any blank lines anyway
		{
		 Loop, Parse, Text, `n, `r
			OutPut .= (RegExMatch(A_LoopField,"[\S]+?\r?\n?")) ? A_LoopField "`n" :
		 StringTrimRight, OutPut, OutPut, 1 ; remove trailing `n added by loop above
		 Text:=OutPut
		 OutPut=
	}
	 If (Neg = 1) ; get only one line!
		{
		 Lines++
		 Output:=Text
		 StringGetPos, Pos, Output, `n, R%Lines% ; These next two Lines by Tuncay see
		 StringTrimLeft, Output, Output, % ++Pos ; http://www.autoHotkey.com/forum/viewtopic.php?p=262375#262375
		 StringGetPos, Pos, Output, `n
		 StringLeft, Output, Output, % Pos
		 Output .= "`n"
		}
	 Else
		{
		 Output:=Text
		 StringGetPos, Pos, Output, `n, R%Lines% ; These next two Lines by Tuncay see
		 StringTrimLeft, Output, Output, % ++Pos ; http://www.autoHotkey.com/forum/viewtopic.php?p=262375#262375
		 Output .= "`n"
		}
	 OW = 2 ; make sure we return variable not process file
	 Return TF_ReturnOutPut(OW, OutPut, FileName, RemoveTrailing)
	}

TF_Count(String, Char)
	{
	StringReplace, String, String, %Char%,, UseErrorLevel
	Return ErrorLevel
	}

TF_Save(Text, FileName, OverWrite = 1) { ; HugoV write file
	Return TF_ReturnOutPut(OverWrite, Text, FileName, 0, 1)
	}

TF(TextFile, CreateGlobalVar = "T") { ; read contents of file in output and %output% as global var ...  http://www.autohotkey.com/forum/viewtopic.php?p=313120#313120
	 global
	 FileRead, %CreateGlobalVar%, %TextFile%
	 Return, (%CreateGlobalVar%)
	}

; TF_Join
; SmartJoin: Detect if CHAR(s) is/are already present at the end of the line before joining the next, this to prevent unnecessary double spaces for example.
; Char: character(s) to use between new lines, defaults to a space. To use nothing use ""
TF_Join(Text, StartLine = 1, EndLine = 0, SmartJoin = 0, Char = 0)
	{
	 If ( (InStr(StartLine,",") > 0) AND (InStr(StartLine,"-") = 0) ) OR (InStr(StartLine,"+") > 0)
		Return Text ; can't do multiplelines, only multiple sections of lines e.g. "1,5" bad "1-5,15-10" good, "2+2" also bad
	 TF_GetData(OW, Text, FileName)
	 If (InStr(Text,"`n") = 0)
		Return Text ; there are no lines to join so just return Text
	 If (InStr(StartLine,"-") > 0)	; OK, we need some counter-intuitive string mashing to substract ONE from the "endline" parameter
		{
		 Loop, Parse, StartLine, CSV
			{
			 StringSplit, part, A_LoopField, -
			 NewStartLine .= part1 "-" (part2-1) ","
			}
		 StringTrimRight, StartLine, NewStartLine, 1
		}
	 If (Endline > 0)
		Endline--
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc)
	 If (Char = 0)
		Char:=A_Space
	 Char_Org:=Char
	 GetRightLen:=StrLen(Char)-1
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			{
			 If (SmartJoin = 1)
				{
				 GetRightText:=SubStr(A_LoopField,0)
				 If (GetRightText = Char)
					Char=
				}
			 Output .= A_LoopField Char
			 Char:=Char_Org
			}
		 Else
			Output .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

;----- Helper functions ----------------

TF_SetGlobal(var, content = "") ; helper function for TF_Split* to return array and not files, credits Tuncay :-)
	{
	 global
	 %var% := content
	}

; Helper function to determine if VAR/TEXT or FILE is passed to TF
; Update 11 January 2010 (skip filecheck if `n in Text -> can't be file)
TF_GetData(byref OW, byref Text, byref FileName)
	{
	 If (text = 0 "") ; v3.6 -> v3.7 https://github.com/hi5/TF/issues/4 and https://autohotkey.com/boards/viewtopic.php?p=142166#p142166 in case user passes on zero/zeros ("0000") as text - will error out when passing on one 0 and there is no file with that name
		{
		 IfNotExist, %Text% ; additional check to see if a file 0 exists
			{
			 MsgBox, 48, TF Lib Error, % "Read Error - possible reasons (see documentation):`n- Perhaps you used !""file.txt"" vs ""!file.txt""`n- A single zero (0) was passed on to a TF function as text"
			 ExitApp
			}
		}
	 OW=0 ; default setting: asume it is a file and create file_copy
	 IfNotInString, Text, `n ; it can be a file as the Text doesn't contact a newline character
		{
		 If (SubStr(Text,1,1)="!") ; first we check for "overwrite"
			{
			 Text:=SubStr(Text,2)
			 OW=1 ; overwrite file (if it is a file)
			}
		 IfNotExist, %Text% ; now we can check if the file exists, it doesn't so it is a var
			{
			 If (OW=1) ; the variable started with a ! so we need to put it back because it is variable/text not a file
				Text:= "!" . Text
			 OW=2 ; no file, so it is a var or Text passed on directly to TF
			}
		}
	 Else ; there is a newline character in Text so it has to be a variable
		{
		 OW=2
		}
	 If (OW = 0) or (OW = 1) ; it is a file, so we have to read into var Text
		{
		 Text := (SubStr(Text,1,1)="!") ? (SubStr(Text,2)) : Text
		 FileName=%Text% ; Store FileName
		 FileRead, Text, %Text% ; Read file and return as var Text
		 If (ErrorLevel > 0)
			{
			 MsgBox, 48, TF Lib Error, % "Can not read " FileName
			 ExitApp
			}
		}
	 Return
	}

; Skan - http://www.autohotkey.com/forum/viewtopic.php?p=45880#45880
; SetWidth() : SetWidth increases a String's length by adding spaces to it and aligns it Left/Center/Right. ( Requires Space() )
TF_SetWidth(Text,Width,AlignText)
	{
	 If (AlignText!=0 and AlignText!=1 and AlignText!=2)
		AlignText=0
	 If AlignText=0
		{
		 RetStr= % (Text)TF_Space(Width)
		 StringLeft, RetText, RetText, %Width%
		}
	 If AlignText=1
		{
		 Spaces:=(Width-(StrLen(Text)))
		 RetStr= % TF_Space(Round(Spaces/2))(Text)TF_Space(Spaces-(Round(Spaces/2)))
		}
	 If AlignText=2
		{
		 RetStr= % TF_Space(Width)(Text)
		 StringRight, RetStr, RetStr, %Width%
		}
	 Return RetStr
	}

; Skan - http://www.autohotkey.com/forum/viewtopic.php?p=45880#45880
TF_Space(Width)
	{
	 Loop,%Width%
		Space=% Space Chr(32)
	 Return Space
	}

; Write to file or return variable depending on input
TF_ReturnOutPut(OW, Text, FileName, TrimTrailing = 1, CreateNewFile = 0) {
	If (OW = 0) ; input was file, file_copy will be created, if it already exist file_copy will be overwritten
		{
		 IfNotExist, % FileName ; check if file Exist, if not return otherwise it would create an empty file. Thanks for the idea Murp|e
			{
			 If (CreateNewFile = 1) ; CreateNewFile used for TF_SplitFileBy* and others
				{
				 OW = 1
				 Goto CreateNewFile
				}
			 Else
				Return
			}
		 If (TrimTrailing = 1)
			 StringTrimRight, Text, Text, 1 ; remove trailing `n
		 SplitPath, FileName,, Dir, Ext, Name
		 If (Dir = "") ; if Dir is empty Text & script are in same directory
			Dir := A_WorkingDir
		 IfExist, % Dir "\backup" ; if there is a backup dir, copy original file there
			FileCopy, % Dir "\" Name "_copy." Ext, % Dir "\backup\" Name "_copy.bak", 1
		 FileDelete, % Dir "\" Name "_copy." Ext
		 FileAppend, %Text%, % Dir "\" Name "_copy." Ext
		 Return Errorlevel ? False : True
		}
	 CreateNewFile:
	 If (OW = 1) ; input was file, will be overwritten by output
		{
		 IfNotExist, % FileName ; check if file Exist, if not return otherwise it would create an empty file. Thanks for the idea Murp|e
			{
			If (CreateNewFile = 0) ; CreateNewFile used for TF_SplitFileBy* and others
				Return
			}
		 If (TrimTrailing = 1)
			 StringTrimRight, Text, Text, 1 ; remove trailing `n
		 SplitPath, FileName,, Dir, Ext, Name
		 If (Dir = "") ; if Dir is empty Text & script are in same directory
			Dir := A_WorkingDir
		 IfExist, % Dir "\backup" ; if there is a backup dir, copy original file there
			FileCopy, % Dir "\" Name "." Ext, % Dir "\backup\" Name ".bak", 1
		 FileDelete, % Dir "\" Name "." Ext
		 FileAppend, %Text%, % Dir "\" Name "." Ext
		 Return Errorlevel ? False : True
		}
	If (OW = 2) ; input was var, return variable
		{
		 If (TrimTrailing = 1)
			StringTrimRight, Text, Text, 1 ; remove trailing `n
		 Return Text
		}
	}

; _MakeMatchList()
; Purpose:
; Make a MatchList which is used in various functions
; Using a MatchList gives greater flexibility so you can process multiple
; sections of lines in one go avoiding repetitive fileread/append actions
; For TF 3.4 added COL = 0/1 option (for TF_Col* functions) and CallFunc for
; all TF_* functions to facilitate bug tracking
_MakeMatchList(Text, Start = 1, End = 0, Col = 0, CallFunc = "Not available")
	{
	 ErrorList=
	 (join|
Error 01: Invalid StartLine parameter (non numerical character)`nFunction used: %CallFunc%
Error 02: Invalid EndLine parameter (non numerical character)`nFunction used: %CallFunc%
Error 03: Invalid StartLine parameter (only one + allowed)`nFunction used: %CallFunc%
	 )
	 StringSplit, ErrorMessage, ErrorList, |
	 Error = 0

	 If (Col = 1)
		{
		 LongestLine:=TF_Stat(Text)
		 If (End > LongestLine) or (End = 1) ; FIXITHERE BUG
			End:=LongestLine
		}

	 TF_MatchList= ; just to be sure
	 If (Start = 0 or Start = "")
		Start = 1

	 ; some basic error checking

	 ; error: only digits - and + allowed
	 If (RegExReplace(Start, "[ 0-9+\-\,]", "") <> "")
		 Error = 1

	 If (RegExReplace(End, "[0-9 ]", "") <> "")
		 Error = 2

	 ; error: only one + allowed
	 If (TF_Count(Start,"+") > 1)
		 Error = 3

	 If (Error > 0 )
		{
		 MsgBox, 48, TF Lib Error, % ErrorMessage%Error%
		 ExitApp
		}

	 ; Option #0 [ added 30-Oct-2010 ]
	 ; Startline has negative value so process X last lines of file
	 ; endline parameter ignored

	 If (Start < 0) ; remove last X lines from file, endline parameter ignored
		{
		 Start:=TF_CountLines(Text) + Start + 1
		 End=0 ; now continue
		}

	 ; Option #1
	 ; StartLine has + character indicating startline + incremental processing.
	 ; EndLine will be used
	 ; Make TF_MatchList

	 IfInString, Start, `+
		{
		 If (End = 0 or End = "") ; determine number of lines
			End:= TF_Count(Text, "`n") + 1
		 StringSplit, Section, Start, `, ; we need to create a new "TF_MatchList" so we split by ,
		 Loop, %Section0%
			{
			 StringSplit, SectionLines, Section%A_Index%, `+
			 LoopSection:=End + 1 - SectionLines1
			 Counter=0
			 	 TF_MatchList .= SectionLines1 ","
			 Loop, %LoopSection%
				{
				 If (A_Index >= End) ;
					Break
				 If (Counter = (SectionLines2-1)) ; counter is smaller than the incremental value so skip
					{
					 TF_MatchList .= (SectionLines1 + A_Index) ","
					 Counter=0
					}
				 Else
					Counter++
				}
			}
		 StringTrimRight, TF_MatchList, TF_MatchList, 1 ; remove trailing ,
		 Return TF_MatchList
		}

	 ; Option #2
	 ; StartLine has - character indicating from-to, COULD be multiple sections.
	 ; EndLine will be ignored
	 ; Make TF_MatchList

	 IfInString, Start, `-
		{
		 StringSplit, Section, Start, `, ; we need to create a new "TF_MatchList" so we split by ,
		 Loop, %Section0%
			{
			 StringSplit, SectionLines, Section%A_Index%, `-
			 LoopSection:=SectionLines2 + 1 - SectionLines1
			 Loop, %LoopSection%
				{
				 TF_MatchList .= (SectionLines1 - 1 + A_Index) ","
				}
			}
		 StringTrimRight, TF_MatchList, TF_MatchList, 1 ; remove trailing ,
		 Return TF_MatchList
		}

	 ; Option #3
	 ; StartLine has comma indicating multiple lines.
	 ; EndLine will be ignored

	 IfInString, Start, `,
		{
		 TF_MatchList:=Start
		 Return TF_MatchList
		}

	 ; Option #4
	 ; parameters passed on as StartLine, EndLine.
	 ; Make TF_MatchList from StartLine to EndLine

	 If (End = 0 or End = "") ; determine number of lines
			End:= TF_Count(Text, "`n") + 1
	 LoopTimes:=End-Start
	 Loop, %LoopTimes%
		{
		 TF_MatchList .= (Start - 1 + A_Index) ","
		}
	 TF_MatchList .= End ","
	 StringTrimRight, TF_MatchList, TF_MatchList, 1 ; remove trailing ,
	 Return TF_MatchList
	}

; added for TF 3.4 col functions - currently only gets longest line may change in future
TF_Stat(Text)
	{
	 TF_GetData(OW, Text, FileName)
	 Sort, Text, f _AscendingLinesL
	 Pos:=InStr(Text,"`n")-1
	 Return pos
	}

_AscendingLinesL(a1, a2) ; used by TF_Stat
	{
	 Return StrLen(a2) - StrLen(a1)
	}

/* -------------- */