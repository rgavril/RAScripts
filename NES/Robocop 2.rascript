// Robocop 2 (NES)
// #ID = 1914

// #region Memory Addresses
    TRUE = 0x01
    FALSE = 0x00

    function activePlayer() => byte(0x0051)
    ACTIVE_PLAYER_1 = 0x00
    ACTIVE_PLAYER_2 = 0x14

    function livesRemaining() => byte(0x0058)
    function currentLevel() => byte(0x0059) + 1
    function secondChances() => byte(0x0064)

    function gameplayAction() => byte(0x05d1)
    GAMEACTION_LEVEL_FINISHED = 0xff

    function demoGameplay() => byte(0x059c)
// #endregion Memory Addresses

// #region Frames
    function frameLevelCleared() {
        return
            prev(gameplayAction()) != GAMEACTION_LEVEL_FINISHED
            && gameplayAction() == GAMEACTION_LEVEL_FINISHED
    }

    function frameSecondChanceUsed() {
        return
            secondChances() != prev(secondChances())
    }
// #endregion Frames

// #region Triggers
    function triggerLevelClearNoCalibration(level) {
        checkpointConditions = 
            once ( currentLevel() == level && frameLevelCleared() )

        cancelConditions =
            never( livesRemaining() == 0 )
            && never( demoGameplay() == TRUE )
            && never( activePlayer() != ACTIVE_PLAYER_1 )
            && never( frameSecondChanceUsed() )

        targetConditions =
            prev(currentLevel()) == level
            && currentLevel() == level+1

        return checkpointConditions && cancelConditions && targetConditions
    }

    function triggerLevelClear(level) {
        return
            demoGameplay() == FALSE
            && activePlayer() == ACTIVE_PLAYER_1
            && livesRemaining() > 0
            && currentLevel() == level
            && frameLevelCleared()
    }
// #endregion Triggers

// #region Achievements
    // #region Stage Clears
        achievement(
            id = 44630,
            title = "River Rouge",
            description = "Clear Level 1: River Rouge Complex Exterior",
            points = 5,
            trigger = triggerLevelClear(1)
        )

        achievement(
            id = 44632,
            title = "Nuke Lab",
            description = "Clear Level 2: River Rouge Interior, Part I",
            points = 5,
            trigger = triggerLevelClear(2)
        )

        achievement(
            id = 44634,
            title = "Nuke Store",
            description = "Clear Level 3: River Rouge Interior, Part II",
            points = 5,
            trigger = triggerLevelClear(3)
        )

        achievement(
            id = 44636,
            title = "Sludge Plant",
            description = "Clear Level 4: The Sludge Plant",
            points = 5,
            trigger = triggerLevelClear(4)
        )

        achievement(
            id = 44638,
            title = "Inside Sludge Plant",
            description = "Clear Level 5: Sludge Plant Interior",
            points = 5,
            trigger = triggerLevelClear(5)
        )

        achievement(
            id = 44640,
            title = "Factory Unit",
            description = "Clear Level 6: Nuke HQ Exterior",
            points = 5,
            trigger = triggerLevelClear(6)
        )

        achievement(
            id = 44642,
            title = "Restricted Zone",
            description = "Clear Level 7: Nuke Interior",
            points = 5,
            trigger = triggerLevelClear(7)
        )

        achievement(
            id = 44644,
            title = "Nuke HQ",
            description = "Clear Level 8: Cain",
            points = 5,
            trigger = triggerLevelClear(8)
        )

        achievement(
            id = 44645,
            title = "Civic Centrum 1",
            description = "Clear Level 9: Civic Centrum 1st Floor",
            points = 5,
            trigger = triggerLevelClear(9)
        )

        achievement(
            id = 44647,
            title = "Civic Centrum 2",
            description = "Clear Level 10: Civic Centrum 2nd Floor",
            points = 5,
            trigger = triggerLevelClear(10)
        )

        achievement(
            id = 44649,
            title = "Civic Centrum 3",
            description = "Clear Level 11: Civic Centrum 3rd Floor",
            points = 5,
            trigger = triggerLevelClear(11)
        )

        achievement(
            id = 44651,
            title = "Civic Centrum 4",
            description = "Clear Level 12: Civic Centrum 4th Floor",
            points = 5,
            trigger = triggerLevelClear(12)
        )

        achievement(
            id = 44653,
            title = "Centrum Roof",
            description = "Clear Level 13: Civic Centrum Roof",
            points = 5,
            trigger = triggerLevelClear(13)
        )
    // #endregion Stage Clears
// #endregion Achievements