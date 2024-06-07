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
            TextLines := Array()
            For Mechanic in ActiveOCR
                {
                    SearchPatterns := GetPatterns(Mechanic)
                    If (RegExMatch(OCRText.Text, SearchPatterns[1])) ;First find a match in the complete pattern
                        {
                            OriginalMatchIndex := 0
                            For Line in OCRText.Lines
                                {
                                    TextLines.Push(Line.Text)
                                    If RegExMatch(TextLines[A_Index], SearchPatterns[1])
                                        {
                                            OriginalMatchIndex := A_Index
                                        }
                                }
                            For Line in TextLines
                                {
                                    If (RegExMatch(Line, SearchPatterns[2])) ; Check second set of patterns for a match
                                        {
                                            IndexMatch := A_Index - 1
                                            Loop 2
                                                {
                                                    IndexMatch++
                                                    If InStr(TextLines[IndexMatch], "(")
                                                        {

                                                            MechanicCount := StrSplit(TextLines[IndexMatch], "(")
                                                            MechanicCount := StrSplit(MechanicCount[2], ")")
                                                            If InStr(MechanicCount[1], "/") ; If OCR read the backslash correctly we are done. If not we need to correct it. 
                                                                {
                                                                   MechanicCount := MechanicCount[1]
                                                                   CheckCountToggle(MechanicCount, Mechanic)
                                                                   Break
                                                                }
                                                            Else ; If we didn't find a back a backslash we most likely got a "1' or "l" instead, so we have to figure out what the correct count is. 
                                                                {
                                                                    If (StrLen(MechanicCount[1]) = 3) ; if the count is 3 digit then the middle character should be "/"
                                                                        {
                                                                            MechanicCount := StrSplit(MechanicCount[1])
                                                                            MechanicCount := MechanicCount[1] "/" MechanicCount[3]
                                                                            CheckCountToggle(MechanicCount, Mechanic)
                                                                            Break
                                                                        }
                                                                    If (StrLen(MechanicCount[1]) = 4)
                                                                        {
                                                                            MechanicCount := StrSplit(MechanicCount[1])
                                                                            MechanicCount := MechanicCount[1] "/" MechanicCount[3] MechanicCount[4]
                                                                            CheckCountToggle(MechanicCount, Mechanic)
                                                                            Break
                                                                         }
                                                                    If (StrLen(MechanicCount[1]) = 5)
                                                                    {
                                                                        MechanicCount := StrSplit(MechanicCount[1])
                                                                        MechanicCount := MechanicCount[1] MechanicCount[2] "/" MechanicCount[4] MechanicCount[5]
                                                                    }
                                                                }
                                                        }
                                                    If !InStr(TextLines[IndexMatch], "(") and (A_Index = 2) ; If "(" wasn't in the text we are probably at step 1 for the mechanic and can just activate it
                                                        {
                                                            Toggle(Mechanic, 1, "On")
                                                            Break
                                                        }
                                                }
                                        }
                                    Else ; If we don't find a match in series #2 check and see if it's because we've completed the mission
                                        {
                                            If InStr(TextLines[OriginalMatchIndex + 1], "Mission Complete") and (OriginalMatchIndex > 0)
                                                {
                                                    Toggle(Mechanic, 1, "Off")
                                                    Break
                                                }
                                        }
                                }

                        }

                }
        }

    ; Ritual needs a seperate search since a different image location would be used. 
}

CheckCountToggle(MechanicCount, Mechanic)
{
    CurrentCount := IniPath("Mechanics", "Read", , Mechanic " Track", "Current Count", "")
    If !(CurrentCount = MechanicCount)
        {
            IniPath("Mechanics", "Write", MechanicCount, Mechanic " Track", "Current Count")
            Toggle(Mechanic, 1, "On")
        }
}


GetPatterns(Mechanic)
{
    PatternArray := Array()
    Switch 
    {
        Case Mechanic = "Einhar" : PatternArray.Push(".*(?:Find and weaken|weaken the beasts|Einhar, Beastmaster|Einhar Beastmaster).*") PatternArray.Push(".*(?:Find and weaken|weaken the beasts).*")
            
        Case Mechanic = "Niko" : PatternArray.Push(".*(?:Master of the Depths|Niko, Master|Niko Master|Master of the Depths|Find the Voltaxic|Voltaxic Sulphite deposits).*") PatternArray.Push(".*(?:Find the Voltaxic|Voltaxic Sulphite deposits).*") 

        Case Mechanic = "Betrayal" : PatternArray.Push(".*(?:Jun, Veiled|Jun Veiled|Veiled Master|Immortal Syndicate Encounters|Complete the Immortal|the Immortal Syndicate|Syndicate encounter).*") PatternArray.Push(".*(?:Immortal Syndicate Encounters|Complete the Immortal|the Immortal Syndicate|Syndicate encounter).*") 
        
        Case Mechanic = "Incursion" : PatternArray.Push(".*(?:Master Explorer|Alva, Master|Alva Master|Complete the temporal|the temporal Incursion).*") PatternArray.Push(".*(?:Complete the temporal|the temporal Incursion).*") 
    }
    Return PatternArray
}

; ### need to add a check for Screen Searches that the screen search feature is actually turned on for each mechanic. 