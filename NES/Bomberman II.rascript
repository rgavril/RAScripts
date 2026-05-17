// Bomberman II
// #ID = 1586

// #region Memory Addresses
    TRUE = 0x01
    FALSE = 0x00
    
    function lives() => byte(0x04e5)
    function score() => byte(0x03d0) + byte(0x03d1) * 10 + byte(0x03d2) * 100 + byte(0x03d3) * 1000 + byte(0x03d4) * 10000 + byte(0x03d5) * 100000 + byte(0x03d6) * 1000000

    function area() => byte(0x004b) + 1
        AREA_INTRO = 0x07
    function areaLevel() => byte(0x004c) + 1
    function isBonusStage() => byte(0x004e)
    function bonusItemCollected() => byte(0x00b4)
    function inGameplayScreen() => byte(0x0031)

    function sfx() => byte(0x0205)
        SFX_TITLE_SCREEN = 0x01
    function music() => byte(0x0206)
        MUSIC_TITLE_SCREEN = 0x0d
        MUSIC_GAME_MENU = 0x13
        MUSIC_GAME_OVER_JINGLE = 0x19
        MUSIC_STAGE_COMPLETED_JINGLE = 0x16

    function demoMode() => byte(0x03ef)
    function gameMode() => byte(0x0049)
        GAME_MODE_NORMAL = 0x00
        GAME_MODE_VS = 0x01
        GAME_MODE_BATTLE = 0x02
        GAME_MODE_PASSWORD = 0x03
// #endregion Memory Addresses

// region Frames
    function frameBonusItemCollected() {
        return
            prev(bonusItemCollected()) == FALSE
            && bonusItemCollected() == TRUE
    }

    function frameStageCompletedJingleStarted() {
        return
            prev(music()) != MUSIC_STAGE_COMPLETED_JINGLE
            && music() == MUSIC_STAGE_COMPLETED_JINGLE 
    }
// endregion Frames

// #region Triggers
    function triggerClearArea(areaNumber) {
        cancelConditions =
            never(demoMode() == TRUE)
            && never(music() == MUSIC_GAME_MENU)
            && never(area() != areaNumber)
        
        triggerConditions = 
            tally(8,
                once(areaLevel() == 1 && isBonusStage() == FALSE && frameStageCompletedJingleStarted()),
                once(areaLevel() == 2 && isBonusStage() == FALSE && frameStageCompletedJingleStarted()),
                once(areaLevel() == 3 && isBonusStage() == FALSE && frameStageCompletedJingleStarted()),
                once(areaLevel() == 4 && isBonusStage() == FALSE && frameStageCompletedJingleStarted()),
                once(areaLevel() == 6 && isBonusStage() == FALSE && frameStageCompletedJingleStarted()),
                once(areaLevel() == 7 && isBonusStage() == FALSE && frameStageCompletedJingleStarted()),
                once(areaLevel() == 8 && isBonusStage() == FALSE && frameStageCompletedJingleStarted())
            )

        return cancelConditions && measured(triggerConditions)
    }

    function triggerBonusArea(areaNumber) {
        cancelConditions =
            never(demoMode() == TRUE)
            && never(music() == MUSIC_GAME_MENU)
            && never(area() != areaNumber)

        primingConditions =
            once(
                area() == areaNumber
                && areaLevel() == 6
                && frameBonusItemCollected()
            )
        
        triggerConditions =
            frameStageCompletedJingleStarted()

        return cancelConditions && primingConditions && trigger_when(triggerConditions)
    }

    function triggerAnyLevelCleared() {
        return
            demoMode() == FALSE
            && inGameplayScreen() == TRUE
            && frameStageCompletedJingleStarted()
    }
// #endregion Triggers

// #region Achievements
    achievement(
        id = 27338,
        title = "Level Clear!",
        description = "Complete a stage",
        points = 5,
        trigger = triggerAnyLevelCleared()
    )

    // #region Progression
        achievement(
            id = 27339,
            title = "Prison Demolition",
            description = "Complete Area 1",
            type = "progression",
            points = 10,
            trigger = triggerClearArea(1)
        )

        achievement(
            id = 27341,
            title = "Only You Can Start Forest Fires",
            description = "Complete Area 2",
            type = "progression",
            points = 10,
            trigger = triggerClearArea(2)
        )

        achievement(
            id = 27343,
            title = "Leveling the Summit",
            description = "Complete Area 3",
            type = "progression",
            points = 10,
            trigger = triggerClearArea(3)
        )

        achievement(
            id = 27345,
            title = "Cold Water and Burning Fire",
            description = "Complete Area 4",
            type = "progression",
            points = 10,
            trigger = triggerClearArea(4)
        )

        achievement(
            id = 27347,
            title = "Reckless Mining Technique",
            description = "Complete Area 5",
            type = "progression",
            points = 10,
            trigger = triggerClearArea(5)
        )

        achievement(
            id = 27349,
            title = "Have Mercy, Please!",
            description = "Catch up to Black Bomber and get your revenge!",
            type = "win_condition",
            points = 25,
            trigger = triggerClearArea(6)
        )
    // #endregion Progression

    // #region Bonus Level
        achievement(
            id = 27340,
            title = "Bonus on a Prison Tour",
            description = "Find the bonus level in Area 1",
            points = 10,
            trigger = triggerBonusArea(1)
        )

        achievement(
            id = 27342,
            title = "Bonus on a Forest Stroll",
            description = "Find the bonus level in Area 2",
            points = 10,
            trigger = triggerBonusArea(2)
        )

        achievement(
            id = 27344,
            title = "Bonus on a Mountain Hike",
            description = "Find the bonus level in Area 3",
            points = 10,
            trigger = triggerBonusArea(3)
        )

        achievement(
            id = 27346,
            title = "Bonus on a Lakeside Swim",
            description = "Find the bonus level in Area 4",
            points = 10,
            trigger = triggerBonusArea(4)
        )

        achievement(
            id = 27348,
            title = "Bonus on a Caving Expedition",
            description = "Find the bonus level in Area 5",
            points = 10,
            trigger = triggerBonusArea(5)
        )

        achievement(
            id = 27350,
            title = "Bonus on a Dungeon Delve",
            description = "Find the bonus level in Area 6",
            points = 10,
            trigger = triggerBonusArea(6)
        )
    // #endregion Bonus Levels

// #endregion Achievements


// #region Leaderboards
    leaderboard(
            title = "High Score",
            description = "Highest score achieved in normal mode",
            format = "SCORE",
            start = 
                demoMode() == FALSE
                && gameMode() == GAME_MODE_NORMAL
                && score() > 0
                && prev(lives()) == 0x00
                && lives() == 0xff,
            cancel = always_false(),
            submit = always_true(),
            value = score()
    )
// #endregion Leaderboards

// #region Rich Presence
    rich_presence_conditional_display(
        // In Game Menus
            music() & 0x7f == MUSIC_GAME_MENU
        // In Title Screen
            || sfx() & 0x7f == SFX_TITLE_SCREEN
            || music() & 0x7f == MUSIC_TITLE_SCREEN
        // In Game Over Screen
            || music() & 0x7f == MUSIC_GAME_OVER_JINGLE
            || lives() == 0xff
        // During Intro Animation
            || (
                area() == AREA_INTRO // Intro Animation Area
                && gameMode() == GAME_MODE_NORMAL
            )
        // In Demo Mode
            || demoMode() == TRUE,
        "Preparing to Play Bomberman II"
    )

    rich_presence_conditional_display(
        gameMode() == GAME_MODE_NORMAL,
        "Area {0}-{1} ● {2} Lives ● Score {3}",
        rich_presence_value("Area", area()),
        rich_presence_value("areaLevel", areaLevel()),
        rich_presence_value("Lives", lives()),
        rich_presence_macro("Score", score())
    )

    rich_presence_conditional_display(
        gameMode() == GAME_MODE_VS,
        "Multiplayer VS Mode"
    )

    rich_presence_conditional_display(
        gameMode() == GAME_MODE_BATTLE,
        "Multiplayer Battle Mode"
    )

    rich_presence_display("Playing Bomberman II")
// #endregion Rich Presence