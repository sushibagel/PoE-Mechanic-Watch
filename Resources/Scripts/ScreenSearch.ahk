ScreenSearchHandler()
{
    HideoutStatus := IniPath("Hideout", "Read", , "In Hideout", "In Hideout", 0)
    If (HideoutStatus = 1) ; Active searches if the user is in the hideout
        {
            InfluenceScreenSearch()
            ; SetTimer(InfluenceScreenSearch)
            ; SetTimer(InfluenceOCR)
            ; SetTimer(MechanicScreenSearch, 0)
            ; SetTimer(MechanicOCR, 0)
        }
    Else
        {
            ; SetTimer(MechanicScreenSearch, 500)
            ; SetTimer(MechanicOCR, 500)
            ; SetTimer(InfluenceScreenSearch, 0)
            ; SetTimer(InfluenceOCR, 0)
            MechanicScreenSearch()
            MechanicOCR()
        }
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

MechanicOCR()
{
    OCRMechanics := VariableStore("OCRSearch")
    ActiveOCR := Array()
    For Mechanic in OCRMechanics ; Check if any OCR Mechanics are active
        {
            OCRActive := IniPath("Mechanics", "Read", , "Auto Mechanics", Mechanic, 0)
            If (OCRActive = 1)
                {
                    ActiveOCR.Push(Mechanic)
                }
        }
    If (ActiveOCR.Length > 0)
        {
            ScreenSearchIni := IniPath("ScreenSearch")
            XOCR := IniRead(ScreenSearchIni, "Quest Tracker Text", "X", A_ScreenWidth/2)
            YOCR := IniRead(ScreenSearchIni, "Quest Tracker Text", "Y", 0)
            WOCR := IniRead(ScreenSearchIni, "Quest Tracker Text", "W", A_ScreenWidth/2)
            HOCR := IniRead(ScreenSearchIni, "Quest Tracker Text", "H", A_ScreenHeight)
            OCRText := OCR.FromRect(XOCR, YOCR, WOCR, HOCR) ; Get OCR Image
            For Mechanic in ActiveOCR
                {
                    SearchPatterns := GetPatterns(Mechanic)
                    If (RegExMatch(OCRText.Text, SearchPatterns[1])) ;First find a match in the complete pattern
                        {
                            For Line in OCRText.Lines
                            If (RegExMatch(Line.Text, SearchPatterns[2])) ; Check second set of patterns for a match
                                {
                                    IndexMatch := A_Index - 1
                                    Loop 2
                                        {
                                            IndexMatch++
                                            ; msgbox OCRText.Lines.Text[2]
                                        }
                                }
                        }

                }
        }

    ; Ritual needs a seperate search since a different image location would be used. 
}

GetPatterns(Mechanic)
{
    PatternArray := Array()
    Switch 
    {
        Case Mechanic = "Einhar" : PatternArray.Push(".*(?:Find and weaken|weaken the beasts|Einhar, Beastmaster|Einhar Beastmaster).*") PatternArray.Push(".*(?:Find and weaken|weaken the beasts).*") PatternArray.Push("Mission Complete") 
            
        Case Mechanic = "Niko" : PatternArray.Push(".*(?:Master of the Depths|Niko, Master|Niko Master|Master of the Depths|Find the Voltaxic|Voltaxic Sulphite deposits).*") PatternArray.Push(".*(?:Find the Voltaxic|Voltaxic Sulphite deposits).*") PatternArray.Push("Mission Complete") 

        Case Mechanic = "Betrayal" : PatternArray.Push(".*(?:Jun, Veiled|Jun Veiled|Veiled Master|Immortal Syndicate Encounters|Complete the Immortal|the Immortal Syndicate|Syndicate encounter).*") PatternArray.Push(".*(?:Immortal Syndicate Encounters|Complete the Immortal|the Immortal Syndicate|Syndicate encounter).*") PatternArray.Push("Mission Complete") 
        
        Case Mechanic = "Incursion" : PatternArray.Push(".*(?:Master Explorer|Alva, Master|Alva Master|Complete the temporal|the temporal Incursion).*") PatternArray.Push(".*(?:Complete the temporal|the temporal Incursion).*") PatternArray.Push("Mission Complete")
    }
    Return PatternArray
}

; ### need to add a check for Screen Searches that the screen search feature is actually turned on for each mechanic. 