// Robocop 2 (NES)
// #ID = 1914

// #region Memory Addresses
    TRUE = 0x01
    FALSE = 0x00

    function activePlayer() => byte(0x0051)
    ACTIVE_PLAYER_1 = 0x00
    ACTIVE_PLAYER_2 = 0x14

    function unstableLivesRemaining() => byte(0x0058)
    function totalLivesRemaining() => byte(0x0058) + byte(0x008d)
    function currentLevel() => byte(0x0059) + 1
    function secondChances() => byte(0x0064)
    function arrestedMade() => byte(0x0057) * 10 + byte(0x0056)
    function health() => byte(0x0054) + byte(0x0055) * 10
    function nukesCollected() => byte(0x0052) + byte(0x0053) * 10
    function score() => 
          byte(0x005a)
        + byte(0x005b) * 10
        + byte(0x005c) * 100
        + byte(0x005d) * 1000
        + byte(0x005e) * 10000
        + byte(0x005f) * 100000
        + byte(0x0060) * 1000000
        + byte(0x0061) * 10000000

    function gameplayAction() => byte(0x05d1)
    GAMEACTION_LEVEL_FINISHED = 0xff

    function demoGameplay() => byte(0x059c)

    function finalFightRound() => byte(0x00a7) + 1
    function finalFightHealth() => byte(0x009f) * 10 + byte(0x00a0)
    function finalFightRoundState() => byte(0x00a5)
    FINALFIGHTROUND_ONGOING = 0x00
    FINALFIGHTROUND_WON = 0x01
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

    function frameArrestMade() {
        return
            arrestedMade() != prev(arrestedMade())
    }

    function framePlayerDied() {
        return
            totalLivesRemaining() < prev(totalLivesRemaining())
    }

    function frameGameOver() {
        return
            totalLivesRemaining() == 0
            && prev(totalLivesRemaining()) > 0
    }

    function frameFinalFightRoundWon() {
        return
            prev(finalFightRoundState()) == FINALFIGHTROUND_ONGOING
            && finalFightRoundState() == FINALFIGHTROUND_WON
    }
// #endregion Frames

// #region Triggers
    function triggerLevelClearNoCalibration(level) {
        checkpointConditions = 
            once ( currentLevel() == level && frameLevelCleared() )

        cancelConditions =
            never( totalLivesRemaining() == 0 )
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
            && currentLevel() == level
            && totalLivesRemaining() > 0
            && frameLevelCleared()
    }

    function triggerLevelArrests(level, arrestsRequired) {
        cancelConditions =
            never( demoGameplay() == TRUE )
            && never( activePlayer() != ACTIVE_PLAYER_1 )
            && never( currentLevel() != level )
            && never( frameGameOver() )
            && never( framePlayerDied() )

        targetConditions =
            repeated(arrestsRequired, frameArrestMade() )

        return cancelConditions && measured(targetConditions)
    }

    function triggerScore(scoreRequired) {
        return
            demoGameplay() == FALSE
            && totalLivesRemaining() > 0
            && prev(activePlayer()) == ACTIVE_PLAYER_1
            && activePlayer() == ACTIVE_PLAYER_1
            && prev(score()) < scoreRequired
            && score() >= scoreRequired
    }

    function triggerFinalFight() {
        cancelConditions =
            never( demoGameplay() == TRUE )
            && never( activePlayer() != ACTIVE_PLAYER_1 )
            && never( totalLivesRemaining() == 0 )
            && never( currentLevel() != 14 )
            && never( finalFightHealth() == 0 )

        targetConditions =
            repeated(3, frameFinalFightRoundWon())

        return cancelConditions && targetConditions
    }
// #endregion Triggers

// #region Achievements
    // #region Stage Clears
        achievement(
            id = 44630,
            type = "progression",
            title = "Towards the Nuke Lab",
            description = "Clear Level 1: River Rouge Complex Exterior",
            points = 5,
            trigger = triggerLevelClear(1)
        )

        achievement(
            id = 44632,
            type = "progression",
            title = "Infiltrating the Nuke Lab",
            description = "Clear Level 2: River Rouge Interior, Part I",
            points = 5,
            trigger = triggerLevelClear(2)
        )

        achievement(
            id = 44634,
            type = "progression",
            title = "Deep Inside the Nuke Lab",
            description = "Clear Level 3: River Rouge Interior, Part II",
            points = 5,
            trigger = triggerLevelClear(3)
        )

        achievement(
            id = 44636,
            type = "progression",
            title = "Sludge Plant Approach",
            description = "Clear Level 4: The Sludge Plant",
            points = 5,
            trigger = triggerLevelClear(4)
        )

        achievement(
            id = 44638,
            type = "progression",
            title = "The Sludge Deep",
            description = "Clear Level 5: Sludge Plant Interior",
            points = 5,
            trigger = triggerLevelClear(5)
        )

        achievement(
            id = 44640,
            type = "progression",
            title = "Storming the HQ",
            description = "Clear Level 6: Nuke HQ Exterior",
            points = 5,
            trigger = triggerLevelClear(6)
        )

        achievement(
            id = 44642,
            type = "progression",
            title = "Restricted Access Breach",
            description = "Clear Level 7: Nuke HQ Interior",
            points = 5,
            trigger = triggerLevelClear(7)
        )

        achievement(
            id = 44644,
            type = "progression",
            title = "Goodbye Cain",
            description = "Defeat Cain and clear Level 8",
            points = 5,
            trigger = triggerLevelClear(8)
        )

        achievement(
            id = 44645,
            type = "progression",
            title = "Ground Floor Flush",
            description = "Clear Level 9: Civic Centrum 1st Floor",
            points = 5,
            trigger = triggerLevelClear(9)
        )

        achievement(
            id = 44647,
            type = "progression",
            title = "Middle Floor Sweep",
            description = "Clear Level 10: Civic Centrum 2nd Floor",
            points = 5,
            trigger = triggerLevelClear(10)
        )

        achievement(
            id = 44649,
            type = "progression",
            title = "Upper Floor Assault",
            description = "Clear Level 11: Civic Centrum 3rd Floor",
            points = 5,
            trigger = triggerLevelClear(11)
        )

        achievement(
            id = 44651,
            type = "progression",
            title = "Executive Floor Purge",
            description = "Clear Level 12: Civic Centrum 4th Floor",
            points = 5,
            trigger = triggerLevelClear(12)
        )

        achievement(
            id = 44653,
            type = "progression",
            title = "Detroit Rooftop Showdown",
            description = "Clear Level 13: Civic Centrum Roof",
            points = 5,
            trigger = triggerLevelClear(13)
        )
    // #endregion Stage Clears

    // #region Arrests
        achievement(
            id = 44631,
            title = "The River Rouge Bust", // River Rouge
            description = "Arrest all target villains in Level 1: River Rouge Complex Exterior",
            points = 10,
            trigger = triggerLevelArrests(1, 5)
        )

        achievement(
            id = 44633,
            title = "River Rouge Rescue Operation I", // River Rouge
            description = "Rescue all hostages in Level 2: River Rouge Interior, Part I",
            points = 10,
            trigger = triggerLevelArrests(2, 5)
        )

        achievement(
            id = 44635,
            title = "River Rouge Rescue Operation II", // River Rouge
            description = "Rescue all hostages in Level 3: River Rouge Interior, Part II",
            points = 10,
            trigger = triggerLevelArrests(3, 5)
        )

        achievement(
            id = 44637,
            title = "The Sludge Plant Bust", // Sludge Plant
            description = "Apprehend all suspects in Level 4: The Sludge Plant",
            points = 10,
            trigger = triggerLevelArrests(4, 5)
        )

        achievement(
            id = 44639,
            title = "Sludge Plant Rescue Operation", // Sludge Plant
            description = "Rescue all hostages in Level 5: Sludge Plant Interior",
            points = 10,
            trigger = triggerLevelArrests(5, 5)
        )

        achievement(
            id = 44641,
            title = "The Nuke HQ Bust", // Nuke HQ : Factory unit in the restricted zone
            description = "Arrest all target villains in Level 6: Nuke HQ Exterior",
            points = 10,
            trigger = triggerLevelArrests(6, 5)
        )

        achievement(
            id = 44643,
            title = "Nuke HQ Rescue Operation", // Nuke HQ
            description = "Rescue all hostages in Level 7: Nuke HQ Interior",
            points = 10,
            trigger = triggerLevelArrests(7, 6)
        )

        achievement(
            id = 44646,
            title = "Civic Centrum Rescue Operation I", // Civic Centrum : The new civic centrum building
            description = "Rescue all hostages in Level 9: Civic Centrum 1st Floor",
            points = 10,
            trigger = triggerLevelArrests(9, 5)
        )

        achievement(
            id = 44648,
            title = "Civic Centrum Rescue Operation II", // Civic Centrum
            description = "Rescue all hostages in Level 10: Civic Centrum 2nd Floor",
            points = 10,
            trigger = triggerLevelArrests(10, 5)
        )

        achievement(
            id = 44650,
            title = "Civic Centrum Data Recovery I", // Civic Centrum
            description = "Reclaim all memory units in Level 11: Civic Centrum 3rd Floor",
            points = 10,
            trigger = triggerLevelArrests(11, 5)
        )

        achievement(
            id = 44652,
            title = "Civic Centrum Data Recovery II", // Civic Centrum
            description = "Reclaim all memory units in Level 12: Civic Centrum 4th Floor",
            points = 10,
            trigger = triggerLevelArrests(12, 5)
        )

        achievement(
            id = 44654,
            title = "Rooftop Savior", // Civic Centrum : The roof of the Centrum Building
            description = "Rescue all hostages in Level 13: Civic Centrum Roof",
            points = 10,
            trigger = triggerLevelArrests(13, 6)
        )
    // #endregion Arrests

    // #region Score Achievements
        achievement(
            id = 44628,
            title = "I'd Buy That for a Dollar!",
            description = "Score more than 1,000,000 points",
            points = 10,
            trigger = triggerScore(1000000)
        )

        achievement(
            id = 44629,
            title = "I'd Buy That for Another Dollar!",
            description = "Score more than 2,500,000 points",
            points = 25,
            trigger = triggerScore(2500000)
        )
    // #endregion Score Achievements

    // #region Final Fight
        achievement(
            id = 44626,
            title = "Robocop 2",
            description = "Defeat Robocop 2 in the last battle",
            points = 25,
            trigger = triggerFinalFight(),
            type = "win_condition"
        )

        achievement(
            id = 44627,
            title = "Robocop 2 Mastered",
            description = "Defeat Robocop 2 in the final battle with more than 50 Health",
            points = 25,
            trigger = triggerFinalFight() && finalFightHealth() > 50
        )
    // #endregion Final Fight
// #endregion Achievements

// #region Leaderboards
    // Leaderboard : High Score
    leaderboard(
        title = "Highest Score",
        description = "Aim for the highest score possible measured in units of 100 points",
        format = "SCORE",
        start = 
            prev(demoGameplay()) == FALSE 
            && prev(activePlayer()) == ACTIVE_PLAYER_1
            && demoGameplay() == FALSE 
            && activePlayer() == ACTIVE_PLAYER_1
            && frameGameOver(),
        cancel = always_false(),
        submit = always_true(),
        value = score() / 100
    )
// #endregion Leaderboards

// #region Rich Presence
    zeroPaddedLookup = {
        0: "0",
        1: "0",
        2: "0",
        3: "0",
        4: "0",
        5: "0",
        6: "0",
        7: "0",
        8: "0",
        9: "0"
    }

    rich_presence_conditional_display(
        demoGameplay() == FALSE && activePlayer() == ACTIVE_PLAYER_1 && unstableLivesRemaining() > 0 && currentLevel() < 14,
        
        "Level {0} ● {1} Lives ● 🧪 {2}{3} ● 🙋🏻 0{4} ● ⚡️ {5}{6} ● Score {7}",
        // Level 1 ● 3 Lives ● 🧪 00 🙋🏻 01 ⚡️ 12 ● Score 1234
        rich_presence_value("Level", currentLevel()),
        rich_presence_value("Lives", unstableLivesRemaining()),
        rich_presence_lookup("ZeroPadding", nukesCollected(), zeroPaddedLookup),
        rich_presence_value("Nukes", nukesCollected()),
        rich_presence_value("Arrests", arrestedMade()),
        rich_presence_lookup("ZeroPadding", health(), zeroPaddedLookup),
        rich_presence_value("Health", health()),
        rich_presence_macro("Score", score())
    )

    rich_presence_conditional_display(
        demoGameplay() == FALSE && activePlayer() == ACTIVE_PLAYER_1 && unstableLivesRemaining() > 0 && currentLevel() == 14,
        
        "Level {0} ● {1} Lives ● Round {2} ● ⚡️{3}{4} vs ⚡️{5}{6} ● Score {7}",
        // Level 14 ● 3 Lives ● Round 1 ● ⚡️30 vs ⚡️99 ● Score 1234
        rich_presence_value("Level", currentLevel()),
        rich_presence_value("Lives", unstableLivesRemaining()),
        rich_presence_value("Round", finalFightRound()),
        rich_presence_value("Health_0X", byte(0x9f)), // Health Tens
        rich_presence_value("Health_X0", byte(0xa0)), // Health Units
        rich_presence_value("Health_0X_Enemy", byte(0xa1)), // Health Tens Enemy
        rich_presence_value("Health_X0_Enemy", byte(0xa2)), // Health Units Enemy
        rich_presence_macro("Score", score())
    )

    // Rich Presence : Default
    rich_presence_display(
        "Preparing to uphold the law"
    )
// #endregion Rich Presence