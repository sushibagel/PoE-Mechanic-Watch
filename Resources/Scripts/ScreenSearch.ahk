ScreenSearchHandler()
{
    HideoutStatus := IniPath("Hideout", "Read", , "In Hideout", "In Hideout", 0)
    If (HideoutStatus = 1) ; Active searches if the user is in the hideout
        {
            SetTimer(InfluenceScreenSearch)
            ; SetTimer(InfluenceOCR)
            SetTimer(MechanicScreenSearch, 0)
            SetTimer(MechanicOCR, 0)
        }
    Else
        {
            SetTimer(InfluenceScreenSearch, 0)
            ; SetTimer(InfluenceOCR, 0)
            SetTimer(MechanicScreenSearch, 500)
            SetTimer(MechanicOCR, 500)
        }
}

MechanicOCR()
{

}

MechanicScreenSearch()
{
    ScreenShot := ImagePutBuffer(0)                               ; Screen capture
    SearchMechanics := VariableStore("ImageSearch")
    For Mechanic in SearchMechanics
        {
            ImageFile := ImagePath(Mechanic, "Yes")
            Search := ImagePutBuffer(ImageFile)             ; Convert File -> Buffer
            If ScreenShot.ImageSearch(Search) ; Look in "ScreenShot" for "Search"
                {
                    Switch ; Match mechanic and toggle. 
                    {
                        Case Mechanic = "Blight" : Toggle("Blight", 1, "Off")
                        Case Mechanic = "Ritual Icon" : Toggle("Ritual", 1, "On")
                        Case Mechanic = "Ritual Shop" : Toggle("Ritual", 1, "Off")     
                    }
                }
        }
}

InfluenceScreenSearch()
{
    ScreenShot := ImagePutBuffer(0)                               ; Screen capture
    ActiveInfluence := GetInfluence()
    InfluenceMechanics := VariableStore("Influences")
    For Influence in InfluenceMechanics ; Check which Influence is on
        {
            ImageFile := ImagePath(Influence " On", "Yes")
            Search := ImagePutBuffer(ImageFile)             ; Convert File -> Buffer
            If ScreenShot.ImageSearch(Search) ; Look in "ScreenShot" for "Search"
                {
                    ChangeInfluence(Influence)
                }     
        }

    LoopTotal := 28
    If (ActiveInfluence = "Maven")
        {
            LoopTotal := 11
        }
    Loop LoopTotal
        {
            ImageFile := ImagePath(ActiveInfluence A_Index - 1, "Yes")
            Search := ImagePutBuffer(ImageFile)             ; Convert File -> Buffer
            If ScreenShot.ImageSearch(Search) ; Look in "ScreenShot" for "Search"
                {
                    CurrentCount := IniPath("Mechanics", "Read", , "Influence Track", ActiveInfluence, 0) ;Check if new count matches prior count
                    If !(CurrentCount = A_Index - 1)
                        {
                            IniPath("Mechanics", "Write", A_Index - 1, "Influence Track", ActiveInfluence)
                            RefreshOverlay()
                        }
                    Break
                }      
        }                                         
}
