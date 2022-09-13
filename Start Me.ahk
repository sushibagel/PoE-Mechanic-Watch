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

MechanicsIni := "Resources/Settings/Mechanics.ini"
Mechanics := "Abyss|Blight|Breach|Expedition|Harvest|Incursion|Metamorph|Ritual|Generic"
Auto := "Blight|Expedition|Incursion"
Influence := "Eater|Searing"
If FileExist(MechanicsIni) ;Check that Mechanics.ini is up-to-date
{
    IniRead, MechanicsSection, %MechanicsIni%, Mechanics
    If(MechanicsSection = "") ;check for "Mechanics" Section
    {
        IniRead, MechanicsSection, %MechanicsIni%, Checkboxes ; If there is a "Checkboxes" section use those settings
        If(MechanicsSection != "")
        {
            For each, Mechanic in Strsplit(Mechanics, "|")
            {
                IniRead, MechanicState, %MechanicsIni%, Checkboxes, %Mechanic%
                If (MechanicState = "Error")
                {
                    MechanicState = 0
                }
                IniWrite, %MechanicState%, %MechanicsIni%, Mechanics, %Mechanic%
            }
        }
        Else
        {
            For each, Mechanic in Strsplit(Mechanics, "|")
            {
                IniWrite, 0, %MechanicsIni%, Mechanics, %Mechanic%
            }
        }
    }

    IniRead, MechanicsSection, %MechanicsIni%, Mechanic Active
    If(MechanicsSection = "") ;Check that "Mechanics Active" section is up-to-date
    {
        For each, Mechanic in Strsplit(Mechanics, "|")
        {
            IniWrite, 0, %MechanicsIni%, Mechanic Active, %Mechanic%
        }
    }

    IniRead, MechanicsSection, %MechanicsIni%, Auto Mechanics
    If(MechanicsSection = "") ;check for "Auto Mechanics" Section
    {
        If FileExist("Resources/Settings/AutoMechanics.ini") ; If there is a "AutoMechanics.ini" use those settings
        {
            For each, Mechanic in Strsplit(Auto, "|")
            {
                IniRead, MechanicState, Resources/Settings/AutoMechanics.ini, Checkboxes, %Mechanic%
                If (MechanicState = "Error")
                {
                    MechanicState = 0
                }
                IniWrite, %MechanicState%, %MechanicsIni%, Auto Mechanics, %Mechanic%
            }
        }
        Else
        {
            For each, Mechanic in Strsplit(Auto, "|")
            {
                IniWrite, 0, %MechanicsIni%, Auto Mechanics, %Mechanic%
            }
        }
    }

    IniRead, MechanicsSection, %MechanicsIni%, Influence
    If(MechanicsSection = "") ;check for "Influence" Section
    {
        For each, Mechanic in Strsplit(Influence, "|")
        {
            IniWrite, 0, %MechanicsIni%, Influence, %Mechanic%
        }
    }

    IniRead, MechanicsSection, %MechanicsIni%, Influence Track
    If(MechanicsSection = "") ;check for "Influence Track" Section
    {
        IniRead, MechanicsSection, %MechanicsIni%, InfluenceTrack ; If there is a "InfluenceTrack" section use those settings
        If(MechanicsSection != "")
        {
            For each, Mechanic in Strsplit(Influence, "|")
            {
                IniRead, MechanicState, %MechanicsIni%, InfluenceTrack, %Mechanic%
                If (MechanicState = "Error")
                {
                    MechanicState = 0
                }
                IniWrite, %MechanicState%, %MechanicsIni%, Influence Track, %Mechanic%
            }
        }
        Else
        {
            For each, Mechanic in Strsplit(Influence, "|")
            {
                IniWrite, 0, %MechanicsIni%, Influence Track, %Mechanic%
            }
        }
    }
}



;Run, PoE Mechanic Watch.ahk
ExitApp