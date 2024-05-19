IniPath(FileRequested)
{
    Switch
    {
        Case FileRequested = "HideoutList": Return "Resources\Data\HideoutList.txt"
        Case FileRequested = "Launch": Return "Resources\Data\LaunchPath.ini"
        Case FileRequested = "Mechanics": Return "Resources\Settings\Mechanics.ini"
        Case FileRequested = "Overlay": Return "Resources\Settings\Overlay.ini"
        Case FileRequested = "Theme": Return "Resources\Settings\Theme.ini"
        Case FileRequested = "Transparency": Return "Resources\Settings\Transparency.ini"
    }
}

VariableStore(VariableRequested)
{
    Switch 
    {
        Case VariableRequested = "Influences": Return ["Eater", "Searing", "Maven"]
        Case VariableRequested = "Mechanics": Return ["Abyss", "Betrayal", "Blight", "Breach", "Einhar", "Expedition", "Harvest", "Incursion", "Legion", "Niko", "Ritual", "Ultimatum", "Generic"]
    }
}

ImagePath(FileRequested, AllowCustom)
{
    BasePath := "Resources\Images\Image Search\"
    Switch
        {
            Case FileRequested = "Quest Tracker Text": Append := "QuestTracker.png"
            Case FileRequested = "Ritual Icon": Append := "RitualIcon.png"
            Case FileRequested = "Ritual Text": Append := "RitualText.png"
            Case FileRequested = "Ritual Shop": Append := "RitualShop.png"
            Case FileRequested = "Influence Count": Append := "EldritchText.png"
            Case FileRequested = "Eater Completion": Append := FileRequested ".png"
            Case FileRequested = "Searing Completion": Append := FileRequested ".png"
            Case FileRequested = "Maven Completion": Append := FileRequested ".png"
            Case FileRequested = InStr(FileRequested, 0) || InStr(FileRequested, 1) || InStr(FileRequested, 2) || InStr(FileRequested, 3) || InStr(FileRequested, 4) || InStr(FileRequested, 5) || InStr(FileRequested, 6) || InStr(FileRequested, 7) || InStr(FileRequested, 8) || InStr(FileRequested, 9) || InStr(FileRequested, 0): Append := FileRequested ".png"
            Case FileRequested = "Eater On": Append := "eateron.png"
            Case FileRequested = "Searing On": Append := "searingon.png"
            Case FileRequested = "Maven On": Append := "mavenon.png"
        }
    If (AllowCustom = "Yes")
        {
            If InStr(FileRequested, "Searing") or InStr(FileRequested, "Eater") or InStr(FileRequested, "Maven")
                {
                    CustomPath := BasePath "Eldritch\Custom\" Append
                }
            Else
                {
                    CustomPath := BasePath "Custom\" Append
                }
           If FileExist(CustomPath)
            {
                ReturnedPath := CustomPath
            }
        }
    If !IsSet(ReturnedPath)
        {
            If InStr(FileRequested, "Searing") or InStr(FileRequested, "Eater") or InStr(FileRequested, "Maven")
                {
                    ReturnedPath := BasePath "Eldritch\" Append
                }
            Else
                {
                    ReturnedPath := BasePath Append
                }
        }
    Return ReturnedPath
}