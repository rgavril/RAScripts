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
    function inGameplayScreen() => byte(0x0031)
    
    function blocksRemaining() => byte(0x04e2)
    function bonusItemCollected() => byte(0x00b4)
    function bombBlastLength_US() => byte(0x0093)
    function bombBlastLength_EU() => byte(0x0092)
    function bombSupply_US() => byte(0x0090)
    function bombSupply_EU() => byte(0x008f)
    function blastInvincibilityStarted() => byte(0x00b0)
    function blastInvincibilitySeconds() => byte(0x00b2)
    function detonatorPowerup() => byte(0x00af)
    function skatesPowerup() => byte(0x00b3)
    function wallPassPowerup() => byte(0x00ad)
    function bombPassPowerup() => byte(0x00ae)
    function stageTimer() => byte(0x055d) * 100 + byte(0x055c) * 10 + byte(0x055b)

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

    function triggerFlamePowerupCollected() {
        requiredConditions = 
            demoMode() == FALSE
            && prev(inGameplayScreen()) == TRUE
            && inGameplayScreen() == TRUE
            && gameMode() != GAME_MODE_VS
            && gameMode() != GAME_MODE_BATTLE

        triggerConditions = (
            bombBlastLength_US() > prev(bombBlastLength_US())
            || bombBlastLength_EU() > prev(bombBlastLength_EU())
        )

        return requiredConditions && triggerConditions
    }

    function triggerDetonatorPowerupCollected() {
        requiredConditions = 
            demoMode() == FALSE
            && prev(inGameplayScreen()) == TRUE
            && inGameplayScreen() == TRUE
            && gameMode() != GAME_MODE_VS
            && gameMode() != GAME_MODE_BATTLE

        triggerConditions = 
            prev(detonatorPowerup()) == FALSE
            && detonatorPowerup() == TRUE

        return requiredConditions && triggerConditions
    }

    function triggerSkatesPowerupCollected() {
        requiredConditions = 
            demoMode() == FALSE
            && prev(inGameplayScreen()) == TRUE
            && inGameplayScreen() == TRUE
            && gameMode() != GAME_MODE_VS
            && gameMode() != GAME_MODE_BATTLE

        triggerConditions = 
            prev(skatesPowerup()) == FALSE
            && skatesPowerup() == TRUE

        return requiredConditions && triggerConditions
    }

    function triggerBlastInvincibilityCollected(seconds) {
        requiredConditions = 
            demoMode() == FALSE
            && prev(inGameplayScreen()) == TRUE
            && inGameplayScreen() == TRUE
            && gameMode() != GAME_MODE_VS
            && gameMode() != GAME_MODE_BATTLE

        triggerConditions =
            prev(blastInvincibilitySeconds()) != seconds
            && blastInvincibilitySeconds() == seconds
            && prev(blastInvincibilityStarted()) == 0
            && blastInvincibilityStarted() != 0

        return requiredConditions && triggerConditions
    }

    function triggerWallPassPowerupCollected() {
        requiredConditions = 
            demoMode() == FALSE
            && prev(inGameplayScreen()) == TRUE
            && inGameplayScreen() == TRUE
            && gameMode() != GAME_MODE_VS
            && gameMode() != GAME_MODE_BATTLE

        triggerConditions = 
            prev(wallPassPowerup()) == FALSE
            && wallPassPowerup() == TRUE

        return requiredConditions && triggerConditions
    }

    function triggerBombPassPowerupCollected() {
        requiredConditions = 
            demoMode() == FALSE
            && prev(inGameplayScreen()) == TRUE
            && inGameplayScreen() == TRUE
            && gameMode() != GAME_MODE_VS
            && gameMode() != GAME_MODE_BATTLE

        triggerConditions = 
            prev(bombPassPowerup()) == FALSE
            && bombPassPowerup() == TRUE

        return requiredConditions && triggerConditions
    }

    function triggerFlameMax() {
        cancelConditions =
            never(demoMode() == TRUE)
            && never(area() == AREA_INTRO)
            && never(music() == MUSIC_GAME_MENU)
            && never(music() == MUSIC_TITLE_SCREEN)
            && never(gameMode() == GAME_MODE_VS)
            && never(gameMode() == GAME_MODE_BATTLE)

        triggerConditions = repeated(4,
            prev(inGameplayScreen()) == TRUE
            && inGameplayScreen() == TRUE
            && prev(bombBlastLength_US()) < bombBlastLength_US()
        )

        measuredIfCondition = 
            once(
                bombBlastLength_US() == 0
                && inGameplayScreen() == TRUE
            )

        return cancelConditions && measured(triggerConditions, measuredIfCondition)
    }

    function triggerBombsMax() {
        cancelConditions =
            never(demoMode() == TRUE)
            && never(area() == AREA_INTRO)
            && never(music() == MUSIC_GAME_MENU)
            && never(music() == MUSIC_TITLE_SCREEN)
            && never(gameMode() == GAME_MODE_VS)
            && never(gameMode() == GAME_MODE_BATTLE)

        triggerConditions = repeated(7,
            prev(inGameplayScreen()) == TRUE
            && inGameplayScreen() == TRUE
            && prev(bombSupply_US()) < bombSupply_US()
        )

        measuredIfCondition = 
            once(
                bombSupply_US() == 0
                && inGameplayScreen() == TRUE
            )

        return cancelConditions && measured(triggerConditions, measuredIfCondition)
    }

    function triggerFinalStageLivesRemaining(minLives) {
        return
            demoMode() == FALSE
            && inGameplayScreen() == TRUE
            && area() == 6
            && areaLevel() == 8
            && lives() >= minLives
            && frameStageCompletedJingleStarted()
    }

    function triggerLives(quantity) {
        requiredConditions = 
            demoMode() == FALSE
            && prev(inGameplayScreen()) == TRUE
            && inGameplayScreen() == TRUE
            && gameMode() != GAME_MODE_VS
            && gameMode() != GAME_MODE_BATTLE

        triggerConditions = 
            prev(lives()) == quantity-1
            && lives() == quantity

        return requiredConditions && triggerConditions
    }

    function triggerScore(targetScore) {
        requiredConditions = 
            demoMode() == FALSE
            && prev(inGameplayScreen()) == TRUE
            && inGameplayScreen() == TRUE

        triggerConditions = 
            prev(score()) < targetScore
            && score() >= targetScore

        return requiredConditions && triggerConditions
    }

    function triggerMaxBombsExploding() {
        return
            demoMode() == FALSE
            && prev(inGameplayScreen()) == TRUE
            && inGameplayScreen() == TRUE
            && isBonusStage() == FALSE
            && prev(byte(0x6001) + byte(0x6002) + byte(0x6003) + byte(0x6004) + byte(0x6005) + byte(0x6006) + byte(0x6007) + byte(0x6008)) < 8
            && byte(0x6001) + byte(0x6002) + byte(0x6003) + byte(0x6004) + byte(0x6005) + byte(0x6006) + byte(0x6007) + byte(0x6008) == 8
    }

    function triggerFinalStageBlocksDestroyed() {
        return
            demoMode() == FALSE
            && prev(inGameplayScreen()) == TRUE
            && inGameplayScreen() == TRUE
            && area() == 6
            && areaLevel() == 8
            && prev(blocksRemaining()) > 0
            && blocksRemaining() == 0
    }

    function triggerFinalStageTimeRemaining(minSeconds) {
        return
            demoMode() == FALSE
            && inGameplayScreen() == TRUE
            && area() == 6
            && areaLevel() == 8
            && stageTimer() >= minSeconds
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

    achievement(
        id = 27351,
        title = "Flamin' Hot",
        description = "Obtain a Flame Face powerup and increase your bombs' flame length",
        points = 5,
        trigger = triggerFlamePowerupCollected()
    )

    achievement(
        id = 27352,
        title = "Heartburn",
        description = "Obtain a Detonator powerup and gain the ability to detonate bombs remotely",
        points = 5,
        trigger = triggerDetonatorPowerupCollected()
    )

    achievement(
        id = 27354,
        title = "Skating on Thin Ice",
        description = "Obtain a Skate powerup and increase your maximum movement speed",
        points = 5,
        trigger = triggerSkatesPowerupCollected()
    )

    achievement(
        id = 27355,
        title = "I'm Invincible! (From Myself)",
        description = "Obtain a Flameproof powerup and become immune to explosions for 15 seconds",
        points = 5,
        trigger = triggerBlastInvincibilityCollected(15)
    )

    achievement(
        id = 27356,
        title = "Protection from Your Own Mistakes",
        description = "Obtain a Vest powerup and and gain the ability to survive explosion for 23 seconds",
        points = 5,
        trigger = triggerBlastInvincibilityCollected(23)
    )

    achievement(
        id = 27357,
        title = "Like a Ghost",
        description = "Obtain a Wall Pass powerup and gain the ability to walk through soft blocks",
        points = 5,
        trigger = triggerWallPassPowerupCollected()
    )

    achievement(
        id = 27358,
        title = "No More Stupid Deaths!",
        description = "Obtain a Bomb Pass powerup and gain the ability to walk through bombs",
        points = 5,
        trigger = triggerBombPassPowerupCollected()
    )

    achievement(
        id = 27359,
        title = "Burnin' Up",
        description = "Increase your flame length to its maximum",
        points = 10,
        trigger = triggerFlameMax()
    )

    achievement(
        id = 27360,
        title = "Bombs Away, All the Way",
        description = "Increase your bomb limit to its maximum",
        points = 10,
        trigger = triggerBombsMax()
    )

    achievement(
        id = 27365,
        title = "Bomber Domination",
        description = "Complete the game with at least 4 lives remaining",
        points = 25,
        trigger = triggerFinalStageLivesRemaining(4)
    )

    achievement(
        id = 27366,
        title = "A Surplus of Bombermen",
        description = "Have 3 lives remaining",
        points = 5,
        trigger = triggerLives(3)
    )

    achievement(
        id = 27367,
        title = "A Lifetime Supply of Bombermen",
        description = "Have 5 lives remaining",
        points = 10,
        trigger = triggerLives(5)
    )

    achievement(
        id = 27401,
        title = "Maximum Ordinance",
        description = "Have the maximum amount of active bombs out at once, and watch them explode!",
        points = 10,
        trigger = triggerMaxBombsExploding()
    )

    achievement(
        id = 27402,
        title = "Block Blaster",
        description = "Destroy every possible wall in Area 6-8",
        points = 10,
        trigger = triggerFinalStageBlocksDestroyed()
    )

    achievement(
        id = 27403,
        title = "Final Time Attack",
        description = "Finish Area 6-8 with more than 60 seconds remaining",
        points = 10,
        trigger = triggerFinalStageTimeRemaining(60)
    )

    // #region Score
        achievement(
            id = 27368,
            title = "Bombing Trainee",
            description = "Obtain a score of 50,000",
            points = 10,
            trigger = triggerScore(50000)
        )

        achievement(
            id = 27369,
            title = "Bombing Amateur",
            description = "Obtain a score of 100,000",
            points = 5,
            trigger = triggerScore(100000)
        )

        achievement(
            id = 27370,
            title = "Bombing Professional",
            description = "Obtain a score of 150,000",
            points = 10,
            trigger = triggerScore(150000)
        )

        achievement(
            id = 27371,
            title = "Bombing Champion",
            description = "Obtain a score of 250,000",
            points = 10,
            trigger = triggerScore(250000)
        )
    // #endregion Score

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