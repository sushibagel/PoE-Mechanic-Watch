Global CurrentLocation

iniChoose()
{
    LocationIni := StorageIni()
    CurrentLocation := IniRead(LocationIni, "Settings Location", "Location")
    If InStr(CurrentLocation, "A_ScriptDir")
    {
        CurrentLocation := %CurrentLocation%
    }
    yh := (A_ScreenHeight/2) -150
    wh := A_ScreenWidth/2
    xh := (A_ScreenWidth/2)
    ewh := wh - (wh/3.5)
    iniChoose := Gui()
    iniChoose.Opt("+E0x02000000 +E0x00080000") ; WS_EX_COMPOSITED WS_EX_LAYERED
    iniChoose.BackColor := Background
    iniChoose.SetFont("c" . Font . " s12")
    iniChoose.Add("GroupBox", "h10 xn x10")
    Space := "y+2"
    iniChoose.Opt("-Caption")
    iniChoose.SetFont("c" . Font . " s11")
    iniChoose.Title := "iniChoose"
    iniChoose.Show("w" . wh)
    WinGetPos(&X, &Y, &w, &h, "iniChoose")
    If (h < 85)
    {
        h := "85"
    }
    iniChoose.Destroy()
    iniChoose.Opt("+E0x02000000 +E0x00080000") ; WS_EX_COMPOSITED WS_EX_LAYERED
    iniChoose.SetFont("c" . Font . " s12")
    iniChoose.Add("Text", "+Center w" . wh, "Select where you want your settings files saved")
    iniChoose.SetFont("c" . Font . " s8")
    iniChoose.Add("Text", "+Center w" . wh, "Note: By changing your storage location the following subfolders will be added to the parent directory selected (Resources, Settings, Data)")
    iniChoose.SetFont("c" . Font . " s12")
    iniChoose.Add("GroupBox", "w" . wh . " h10 xn")
    Space := "y+2"
    iniChoose.Opt("-Caption")
    iniChoose.SetFont("c" . Font . " s11")
    xh := xh - (w/2)
    yh2 := yh + h
    h := h - 30
    iniChoose.SetFont("c" . Font . " s10")
    iniChoose.Add("Text", "xs x10 Section", "Current Location:")
    iniChoose.SetFont("cBlack")
    ogcEditCurrentLocation := iniChoose.Add("Edit", "ys vCurrentLocation w" . ewh, CurrentLocation)
    iniChoose.SetFont("c" . Font)
    ogcButtonSelectLocation := iniChoose.Add("Button", "ys", "Select Location")
    ogcButtonSelectLocation.OnEvent("Click", iniChooseButtonSelectLocation.Bind("Normal"))
    ogcButtonClose := iniChoose.Add("Button", "xn x20 Section", "Close")
    ogcButtonClose.OnEvent("Click", iniChooseButtonClose.Bind("Normal"))
    iniChoose.BackColor := Background
    iniChoose.Title := "iniChoose"
    iniChoose.Show("x" . xh . " y" . yh . " w" . wh)
    WinWaitClose("iniChoose")
    Return
}

iniChooseButtonClose()
{
    oSaved := iniChoose.Submit("0")
    CurrentLocation := oSaved.CurrentLocation
    iniChoose.Destroy()
    Return
}

iniChooseButtonSelectLocation()
{
    LocationIni := StorageIni()
    oSaved := iniChoose.Submit("0")
    CurrentLocation := oSaved.CurrentLocation
    iniChoose.Destroy()
    NewLocation := DirSelect(1, %A_ScriptDir%, "Please select the parent folder you'd like for your settings files.")
    IniWrite(NewLocation, LocationIni, "Settings Location", "Location")
    CopyFolder := CurrentLocation "\Resources\Settings\*.ini"
    NewSettings := NewLocation "\Resources\Settings"
    CopyData := CurrentLocation "\Resources\Data\*.ini"
    NewData := NewLocation "\Resources\Data"
    DirCreate(NewSettings)
    DirCreate(NewData)
    FileCopy(CopyFolder, NewSettings "\*.ini")
    FileCopy(CopyData, NewData "\*.ini")
    iniChoose()
    Return
}