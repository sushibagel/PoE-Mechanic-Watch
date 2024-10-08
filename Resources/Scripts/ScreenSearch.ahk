; Imageput seems to be significantly faster but can't handle variance as well as ImageSearch. 
ScreenSearchHandler()
{
    HideoutStatus := IniPath("Hideout", "Read", , "In Hideout", "In Hideout", 0)
    If (HideoutStatus = 1) ; Active searches if the user is in the hideout
    {
        InfluenceStatus := IniPath("Mechanics", "Read", , "Auto Mechanics", "Eldritch", 0)
        If (InfluenceStatus = 1) ; Verify auto search is on before starting.
        {
            InfluenceScreenSearch()
            InfluenceOCR()
        }
    }
    Else
    {
        MechanicScreenSearch()
        MechanicOCR()
        MavenOCRStatus := IniPath("Misc Data", "Read", , "Map", "Maven OCR", 0)
        If (MavenOCRStatus = 1)
        {
            MavenOCR()
        }
    }
}

MechanicScreenSearch()
{
    SearchMechanics := VariableStore("ImageSearch")
    For Mechanic in SearchMechanics
    {
        CheckActive := Mechanic
        If InStr(Mechanic, "Ritual")
        {
            CheckActive := "Ritual"
        }
        AutoActive := IniPath("Mechanics", "Read", , "Auto Mechanics", CheckActive, 0)
        If (AutoActive = 1) ; Check if auto search is enabled for the mechanics. 
        {
            ImageFile := ImagePath(Mechanic, "Yes")
            If ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*50 " ImageFile)
            {
                Switch ; Match mechanic and toggle.
                {
                    Case Mechanic = "Blight": CheckSeed("Blight", "Off")
                    Case Mechanic = "Ritual Icon": CheckSeed("Ritual", "On")
                    Case Mechanic = "Ritual Shop": CheckRitualStatus()
                }
            }
        }
    }
}

CheckRitualStatus()
{
    Active := IniPath("Mechanics", "Read", , "Mechanic Active", "Ritual", 0)
    Status := IniPath("Mechanics", "Read", , "Ritual Track", "Current Count", "")
    If (Active = 1) and ((Status = "3/3") or (Status = "4/4"))
        {
            ToggleMechanic("Ritual", 1, "Off")
            MapSeed := IniPath("Misc Data", "Read", , "Map", "Last Seed", "")
            IniPath("Mechanics", "Write", MapSeed, "Ritual Track", "Seed")
        }
}

CheckSeed(Mechanic, Status:= "On")
{
    MapSeed := IniPath("Misc Data", "Read", , "Map", "Last Seed", "")
    SeedCheck := IniPath("Mechanics", "Read", , Mechanic " Track", "Seed", "1")
    If (Mechanic = "Ritual")
        {
            SeedCheck := IniPath("Mechanics", "Read", , Mechanic " Track", "Active Seed", "1")
        }
    If !(MapSeed = SeedCheck)
        {
            ToggleMechanic(Mechanic, 1, Status)
            If (Mechanic = "Ritual")
                {
                    IniPath("Mechanics", "Write", "", "Ritual Track", "Current Count")
                    IniPath("Mechanics", "Write", MapSeed , Mechanic " Track", "Active Seed")
                }
        }
}


InfluenceScreenSearch()
{
    ScreenShot := ImagePutBuffer({Window: "ahk_Group PoeWindow"}) ; Screen capture
    ActiveInfluence := GetInfluence()
    InfluenceMechanics := VariableStore("Influences")
    For Influence in InfluenceMechanics ; Check which Influence is on
    {
        ImageFile := ImagePath(Influence " On", "Yes")
        Search := ImagePutBuffer(ImageFile) ; Convert File -> Buffer
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
        Search := ImagePutBuffer(ImageFile) ; Convert File -> Buffer
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
            Pattern := GetPatterns(Mechanic, "1")
            If IsSet(OCRRegex)
            {
                OCRRegex := OCRRegex "|" Pattern
            }
            Else
            {
                OCRRegex := Pattern
            }
        }
    }
    If (ActiveOCR.Length > 0)
    {
        ActiveHwnd := WinWaitActive("ahk_group PoeOnly")
        WinGetPos(&XOCR, &YOCR, &WOCR, &HOCR, ActiveHwnd)
        XOCR := WOCR - WOCR // 3
        ScreenSearchIni := IniPath("ScreenSearch")
        XOCR := IniRead(ScreenSearchIni, "Side Area", "X", XOCR)
        YOCR := IniRead(ScreenSearchIni, "Side Area", "Y", YOCR)
        WOCR := IniRead(ScreenSearchIni, "Side Area", "W", WOCR)
        HOCR := IniRead(ScreenSearchIni, "Side Area", "H", HOCR)
        Try OCRText := OCR.WaitText(".*(?:" OCRRegex ").*", 500, OCR.FromWindow.Bind(OCR, "ahk_group PoeOnly", , 2, { X: XOCR, Y: YOCR, W: WOCR, H: HOCR, onlyClientArea: 1 }), , RegExMatch) ; Find text indicating missions are in the map.
        Try If (OCRText)
        {
            CheckOCR(OCRText, ActiveOCR)
        }
        RitualStatus := IniPath("Mechanics", "Read", , "Auto Mechanics", "Ritual")
        {
            ActiveHwnd := WinWaitActive("ahk_group PoeOnly")
            WinGetPos(&XOCR, &YOCR, &WOCR, &HOCR, ActiveHwnd)
            YOCR := HOCR - HOCR // 3
            XOCR := IniRead(ScreenSearchIni, "Ritual Area", "X", XOCR)
            YOCR := IniRead(ScreenSearchIni, "Ritual Area", "Y", YOCR)
            WOCR := IniRead(ScreenSearchIni, "Ritual Area", "W", WOCR)
            HOCR := IniRead(ScreenSearchIni, "Ritual Area", "H", HOCR)
            Try RitualOCR := OCR.WaitText("(113|213|313|114|214|314|414|1\/3|2\/3|3\/3|1\/4|2\/4|3\/4|4\/4)", 500, OCR.FromWindow.Bind(OCR, "ahk_group PoeOnly", , 2, { X: XOCR, Y: YOCR, W: WOCR, H: HOCR, onlyClientArea: 1 }), , RegExMatch) ; Find text indicating ritual are in the map.
            Try If (RitualOCR)
                {
                    RitualOCRMatch(RitualOCR)
                }
        }
    }
}

CheckOCR(TextFound, ActiveOCR)
{
    TextLines := Array()
    For Mechanic in ActiveOCR ;Find the mechanic and line that was matched.
    {
        SearchPatterns := GetPatterns(Mechanic, 1)
        OriginalMatchIndex := 0
        For Line in TextFound.Lines
        {
            TextLines.Push(Line.Text)
            If RegExMatch(TextLines[A_Index], SearchPatterns)
            {
                OriginalMatchIndex := A_Index
            }
        }
        For Line in TextLines
        {
            SearchPattern := GetPatterns(Mechanic, 2)
            If (RegExMatch(Line, SearchPatterns)) and !(InStr(Line, "Find and defeat the Syndicate Mastermind") or InStr(Line, "Follow Catarina and defeat her")) ; Check second set of patterns for a match  
            {
                IndexMatch := A_Index - 1
                Loop 2
                {
                    IndexMatch++
                    If InStr(TextLines[IndexMatch], "(")
                    {
                        MechanicCount := StrSplit(TextLines[IndexMatch], "(")
                        MechanicCount := StrSplit(MechanicCount[2], ")")
                        Try If InStr(MechanicCount[1], "/") ; If OCR read the backslash correctly we are done. If not we need to correct it.
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
                                CheckCountToggle(MechanicCount, Mechanic)
                                Break
                            }
                        }
                    }
                    If !InStr(TextLines[IndexMatch], "(") and (A_Index = 2) ; If "(" wasn't in the text we are probably at step 1 for the mechanic and can just activate it
                    {
                        CheckSeed(Mechanic, "On")
                    }
                }
            }
            Else ; If we don't find a match in series #2 check and see if it's because we've completed the mission
                {
                    If InStr(TextLines[OriginalMatchIndex + 1], "Mission Complete") and (OriginalMatchIndex > 0)
                    {
                        ToggleMechanic(Mechanic, 1, "Off")
                        MapSeed := IniPath("Misc Data", "Read", , "Map", "Last Seed", "")
                        IniPath("Mechanics", "Write", MapSeed, Mechanic " Track", "Seed")
                        Break
                    }
                }
        }

    }

}

; Ritual is looked for next in a different zone
RitualOCRMatch(RitualOCR)
{
    TextLines := Array()
    For Line in RitualOCR.Lines
    {
        TextLines.Push(Line.Text)
        If (RegExMatch(TextLines[A_Index], "(113|213|313|114|214|314|414|1\/3|2\/3|3\/3|1\/4|2\/4|3\/4|4\/4)", &RitualMatch)) and !RegExMatch(TextLines[A_Index], "(?i)^(?:e(?:ncounters|inhar)|alva|niko|jun|\(\))$")
        {
            If !InStr(RitualMatch[1], "/")
                {
                    RitualMatch := StrSplit(RitualMatch[1])
                    RitualMatch := RitualMatch[1] "/" RitualMatch[3]
                }
            Else
                {
                    RitualMatch := RitualMatch[1]
                }
            CurrentCount := IniPath("Mechanics", "Read", , "Ritual Track", "Current Count", "")
            CheckCountToggle(RitualMatch, "Ritual", "No") ; Apply ritual count but don't toggle ritual. Ritual is only toggled by image matching to avoid false positives. 
            RitualStatus := IniPath("Mechanics", "Read", , "Mechanic Active", "Ritual", 0)
            If ((RitualMatch = "3/3") or (RitualMatch = "4/4")) and !(RitualMatch = CurrentCount) and (RitualStatus = 1)
                {
                    QuickNotify("You've completed the final ritual. Don't forget to collect your rewards.", 3)
                }
        }
    }
}

CheckCountToggle(MechanicCount, Mechanic, Toggle:="Yes")
{
    CurrentCount := IniPath("Mechanics", "Read", , Mechanic " Track", "Current Count", "")
    If !(CurrentCount = MechanicCount)
    {
        IniPath("Mechanics", "Write", MechanicCount, Mechanic " Track", "Current Count")
        ActiveStatus := IniPath("Mechanics", "Read", , "Mechanic Active", Mechanic, 0)
        If (Toggle = "Yes") and IsSet(Mechanic) and (ActiveStatus = 0)
            {
                ToggleMechanic(Mechanic, 1, "On")
            }
        Else
            {
                RefreshOverlay()
            }
    }
}

GetPatterns(Mechanic, Version)
{
    Switch
    {
        Case Mechanic = "Einhar":
        {
            If (Version = 1)
                Return "Find and weaken|weaken the beasts|Einhar, Beastmaster|Einhar Beastmaster"
            If (Version = 2)
                Return "Find and weaken|weaken the beasts"
        }
        Case Mechanic = "Niko":
        {
            If (Version = 1)
                Return "Master of the Depths|Niko, Master|Niko Master|Master of the Depths|Find the Voltaxic|Voltaxic Sulphite deposits"
            If (Version = 2)
                Return "Find the Voltaxic|Voltaxic Sulphite deposits"
        }
        Case Mechanic = "Betrayal":
        {
            If (Version = 1)
                Return "Jun, Veiled|Jun Veiled|Veiled Master|Immortal Syndicate Encounters|Complete the Immortal|the Immortal Syndicate|Syndicate encounter"
            If (Version = 2)
                Return "Immortal Syndicate Encounters|Complete the Immortal|the Immortal Syndicate|Syndicate encounter"
        }
        Case Mechanic = "Incursion":
        {
            If (Version = 1)
                Return "Master Explorer|Alva, Master|Alva Master|Complete the temporal|the temporal Incursion"
            If (Version = 2)
                Return "Complete the temporal|the temporal Incursion"
        }
    }
}

InfluenceOCR()
{
    ActiveHwnd := WinWaitActive("ahk_group PoeOnly")
    WinGetPos(&XOCR, &YOCR, &WOCR, &HOCR, ActiveHwnd)
    ScreenSearchIni := IniPath("ScreenSearch")
    If !(XOCR = "")
    {
        XOCR := IniRead(ScreenSearchIni, "Influence Area", "X", XOCR)
        YOCR := IniRead(ScreenSearchIni, "Influence Area", "Y", YOCR)
        WOCR := IniRead(ScreenSearchIni, "Influence Area", "W", WOCR)
        HOCR := IniRead(ScreenSearchIni, "Influence Area", "H", HOCR)
        OCRRegex := "Searing Exarch Progress:|Eater of Worlds Progress:|Maven Progress:"
        OCRText := OCR.WaitText(".*(?:" OCRRegex ").*", 500, OCR.FromWindow.Bind(OCR, "ahk_group PoeOnly", , 2, { X: XOCR, Y: YOCR, W: WOCR, H: HOCR, onlyClientArea: 1 }), , RegExMatch) ; Find text indicating missions are in the map.
        TextLines := Array()
    }
    If (OCRText)
    {
        For Line in OCRText.Lines
            {
                TextLines.Push(Line.Text)
                If RegExMatch(TextLines[A_Index], OCRRegex, &FoundText)
                {
                    CurrentCount := StrSplit(TextLines[A_Index], FoundText[0], "`n `t")
                    If InStr(CurrentCount[2], "/")
                    {
                        CurrentCount := StrSplit(CurrentCount[2], "/", "`n `t")
                        CurrentCount := CurrentCount[1]
                    }
                    Else
                    {
                        If (StrLen(CurrentCount[2]) = 4)
                            {
                                CurrentCount := StrSplit(CurrentCount[2],, "`n `t")
                                CurrentCount := CurrentCount[1]
                            }
                        Else If (StrLen(CurrentCount[2]) = 5)
                            {
                                CurrentCount := StrSplit(CurrentCount[2],, "`n `t")
                                CurrentCount := CurrentCount[1] CurrentCount[2]
                            }
                    }
                    InfluenceMatch := StrSplit(FoundText[0], A_Space, "`n `t")
                    IniCount := IniPath("Mechanics", "Read", , "Influence Track", InfluenceMatch[1], 0)
                    Try If !(IniCount = CurrentCount) and !(CurrentCount = "")
                    {
                        IniPath("Mechanics", "Write", CurrentCount, "Influence Track", InfluenceMatch[1])
                        RefreshOverlay
                    }
                }
            }
    }
}

MavenOCR()
{
    ActiveHwnd := WinWaitActive("ahk_group PoeOnly")
    WinGetPos(&XOCR, &YOCR, &WOCR, &HOCR, ActiveHwnd)
    ScreenSearchIni := IniPath("ScreenSearch")
    If !(XOCR = "")
    {
        XOCR := IniRead(ScreenSearchIni, "Maven Area", "X", XOCR)
        YOCR := IniRead(ScreenSearchIni, "Maven Area", "Y", YOCR)
        WOCR := IniRead(ScreenSearchIni, "Maven Area", "W", WOCR)
        HOCR := IniRead(ScreenSearchIni, "Maven Area", "H", HOCR)
        OCRRegex := "Witnessed by the|Completion Witnessed"
        Try OCRText := OCR.WaitText(".*(?:" OCRRegex ").*", 500, OCR.FromWindow.Bind(OCR, "ahk_group PoeOnly", , 2, { X: XOCR, Y: YOCR, W: WOCR, H: HOCR, onlyClientArea: 1 }), , RegExMatch) ; Find text indicating a maven witness was completed.
        Try If (OCRText)
        {
            For Line in OCRText.Lines
                If RegExMatch(Line.Text, OCRRegex) ;Find the line containing witness completion
                {
                    WitnessInfo := Line.Text
                    WitnessInfo := StrSplit(WitnessInfo, "Completion Witnessed") ;Get boss/map name.
                    WitnessInfo := Trim(WitnessInfo[1], "`t `n")
                    BossCategory := IniPath("Maven", "Read", , "Maven", WitnessInfo, "Map Bosses") 
                    If (BossCategory = "The Formed") or (BossCategory = "The Forgotten") or (BossCategory = "The Feared") ;or (BossCategory = "The Hidden") or (BossCategory = "The Elderslayers")
                    {
                        IniPath("Mechanics", "Write", 1, BossCategory, WitnessInfo)
                    }
                    Else If (BossCategory = "Map Bosses")
                    {
                        Bosses := GetBosses("Map Bosses")
                        BossCount := Bosses.Length + 1
                        IniPath("Mechanics", "Write", WitnessInfo, "Maven Map", "Maven Map " BossCount)
                        ; msgbox Bosses.Length
                        ; need to write map boss completion to next available line. 
                    }
                    Break
                }
        }

    }
}