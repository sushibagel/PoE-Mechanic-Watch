CheckFirstRun() ;Check to see if all First Run Items are complete
{
    Global ItemSearch := "Client|Theme|Hideout|Mechanic|Position|MapPosition|AutoMechanic|Hotkey|Sound|LaunchAssist|Notification|ToolLauncher"
    Global Item
    Global each
    FirstRunPath := FirstRunIni()
    For each, Item in StrSplit(ItemSearch, "|")
    {
        %Item%State := IniRead(FirstRunPath, "Completion", Item, 0)
    }
    Return
}
