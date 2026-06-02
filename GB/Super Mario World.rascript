// Super Mario World
// #ID = 504

// #region Memory Locations
    FALSE = 0x00
    TRUE = 0x01

    function gameState() => byte(0xff9f)
        GAME_STATE_STARTED = 0x00
    function gameplayState() => byte(0xffb3)
        GAMEPLAY_PLATFORMING = 0x00
        GAMEPLAY_DEATH = 0x01
        GAMEPLAY_START_LIFE_OR_LEVEL = 0x02
        GAMEPLAY_FLYING = 0x0d
        GAMEPLAY_BONUS_INIT = 0x12
        GAMEPLAY_BONUS_GOAL = 0x1a
        GAMEPLAY_STAGE_COMPLETED = 0x07
        GAMEPLAY_NEW_GAME = 0x11
        GAMEPLAY_SECRET_AREA_INIT = 0x0a
    function currentStage() => byte(0x00ffb4)
        WORLD_1_1 = 0x11
        WORLD_1_3 = 0x13
        WORLD_2_2 = 0x22
        WORLD_4_3 = 0x43
    function currentWorld() => high4(0x00ffb4)
    function currentLevel() => low4(0x00ffb4)
    function stageProgress() => byte(0x00c0ab)
        STAGE_PROGRESS_START = 0x0c
    function timesGameCompleted() => byte(0xff9a)
    function secretAreaID() => word(0xfff4)
    function timeRemaining() => low4(0x00da02)*100 + high4(0x00da01)*10 + low4(0x00da01)

    function enemyType(index) => byte(0xd100 + (index-1)*0x10)
    function enemySuperballStats(index) => byte(0xd10c + (index-1)*0x10)

    function bonusGamePrize() => byte(0x00da17)
        BONUS_PRIZE_DECIDING = 0x00
        BONUS_PRIZE_1LIFE = 0x02
        BONUS_PRIZE_2LIVES = 0x03
        BONUS_PRIZE_3LIVES = 0x04
        BONUS_PRIZE_FLOWER = 0x10
    function score() => low4(0xc0a0) + high4(0xc0a0) * 10 + low4(0xc0a1) * 100 + high4(0xc0a1) * 1000 + low4(0xc0a2) * 10000 + high4(0xc0a2) * 100000
    function livesRemaining() => high4(0xda15)*10 + low4(0xda15)
    function marioSize() => byte(0xff99)
        MARIO_SIZE_SMALL = 0x00
        MARIO_SIZE_GROWING = 0x01
        MARIO_SIZE_SHRINKING = 0x03
    function superBallState() => byte(0xffb5)
    function coinsCollected() => high4(0xfffa)*10 + low4(0xfffa)
    function playerYPos() => byte(0xc201)
// #endregion Memory Locations

// #region Frames
// #endregion Frames

// #region Triggers
    function triggerCollectMushroom() {
        return
            gameState() == GAME_STATE_STARTED
            && (gameplayState() == GAMEPLAY_PLATFORMING || gameplayState() == GAMEPLAY_FLYING)
            && prev(marioSize()) == MARIO_SIZE_SMALL
            && marioSize() == MARIO_SIZE_GROWING
    }

    function triggerCollectFlower() {
        return
            gameState() == GAME_STATE_STARTED
            && gameplayState() == GAMEPLAY_PLATFORMING
            && prev(superBallState()) == FALSE
            && superBallState() != FALSE
    }

    function triggerCoins(quantity) {
        return
            gameState() == GAME_STATE_STARTED
            && prev(coinsCollected() < quantity)
            && measured(coinsCollected() >= quantity)
    }

    function triggerWorld13TopCoins() {
        cancelConditions = 
            never(gameState() != GAME_STATE_STARTED)
            && never(currentStage() != WORLD_1_3)
            && never(gameplayState() == GAMEPLAY_DEATH)

        requiredConditions =
            repeated(28,
                gameplayState() == GAMEPLAY_PLATFORMING
                && (playerYPos() <= 35 || playerYPos() >= 230)
                && prev(coinsCollected()) != coinsCollected()
            )

        return cancelConditions && measured(requiredConditions)
    }

    function triggerCoinlessWorld(worldNumber) {
        primingConditions = 
            once(
                currentStage() == worldNumber*0x10 + 1
                && gameplayState() == GAMEPLAY_START_LIFE_OR_LEVEL
                && stageProgress() == STAGE_PROGRESS_START
            )

        cancelConditions = 
            never(gameState() != GAME_STATE_STARTED)
            && never(currentWorld() != worldNumber)
            && never(prev(coinsCollected()) != coinsCollected())

        targetConditions = 
            currentStage() == worldNumber*0x10 + 3
            && prev(gameplayState()) != GAMEPLAY_STAGE_COMPLETED
            && gameplayState() == GAMEPLAY_STAGE_COMPLETED

        return primingConditions && cancelConditions && trigger_when(targetConditions)
    }

    function triggerBonusGame3Lives() {
        return
            gameState() == GAME_STATE_STARTED
            && gameplayState() == GAMEPLAY_BONUS_GOAL
            && prev(bonusGamePrize() == BONUS_PRIZE_DECIDING)
            && bonusGamePrize() == BONUS_PRIZE_3LIVES
    }

    function triggerDeathlessExtraLives(quantity) {
        primingConditions = 
            once (
                prev(gameplayState()) != GAMEPLAY_NEW_GAME
                && gameplayState() == GAMEPLAY_NEW_GAME
            )

        cancelConditions = 
            never(gameState() != GAME_STATE_STARTED)
            && never(gameplayState() == GAMEPLAY_DEATH)

        targetConditions =
            prev(livesRemaining()) < quantity
            && measured(livesRemaining() >= quantity, primingConditions)

        return primingConditions && cancelConditions && targetConditions
    }

    function triggerScore(targetScore) {
        return
            gameState() == GAME_STATE_STARTED
            && prev(score()) < targetScore
            && score() >= targetScore
    }

    function triggerHardModeDeathlessScore(targetScore) {
        primingConditions = 
            once (
                timesGameCompleted() == 1
                && prev(gameplayState()) != GAMEPLAY_NEW_GAME
                && gameplayState() == GAMEPLAY_NEW_GAME
            )
        
        cancelConditions = 
            never(gameState() != GAME_STATE_STARTED)
            && never(gameplayState() == GAMEPLAY_DEATH)

        targetConditions =
            prev(score()) < targetScore
            && score() >= targetScore

        return primingConditions && cancelConditions && targetConditions
    }

    function triggerWorldClear(worldNumber) {
        return
            gameState() == GAME_STATE_STARTED
            && currentStage() == worldNumber*0x10 + 3
            && prev(gameplayState()) != GAMEPLAY_STAGE_COMPLETED
            && gameplayState() == GAMEPLAY_STAGE_COMPLETED
    }

    function triggerDeathlessWorld(worldNumber) {
        primingConditions = 
            once(
                currentStage() == worldNumber*0x10 + 1
                && gameplayState() == GAMEPLAY_START_LIFE_OR_LEVEL
                && stageProgress() == STAGE_PROGRESS_START
            )

        cancelConditions = 
            never(gameState() != GAME_STATE_STARTED)
            && never(currentWorld() != worldNumber)
            && never(gameplayState() == GAMEPLAY_DEATH)
        
        targetConditions = 
            currentStage() == worldNumber*0x10 + 3
            && prev(gameplayState()) != GAMEPLAY_STAGE_COMPLETED
            && gameplayState() == GAMEPLAY_STAGE_COMPLETED

        return primingConditions && cancelConditions && trigger_when(targetConditions)
    }

    function triggerAllBonusGamesWorld(worldNumber) {
        requiredConditions =
            once (
                currentStage() == worldNumber*0x10 + 1
                && prev(gameplayState()) != GAMEPLAY_BONUS_INIT
                && gameplayState() == GAMEPLAY_BONUS_INIT
            )
            && once (
                currentStage() == worldNumber*0x10 + 2
                && prev(gameplayState()) != GAMEPLAY_BONUS_INIT
                && gameplayState() == GAMEPLAY_BONUS_INIT
            )

        cancelConditions = 
            never(gameState() != GAME_STATE_STARTED)
            && never(currentWorld() != worldNumber)

        return requiredConditions && cancelConditions
    }

    function triggerWorldSecrets(worldNumber) {
        secretAreaIDs = [
            [],
            [0x0501, 0x0a02, 0x0702, 0x0b01],
            [0x0701, 0x0e02, 0x0501, 0x0f02],
            [0x0602, 0x1101, 0x0801, 0x0f02, 0x0701, 0x0b02],
            [0x0302, 0x1602, 0x0601, 0x1201]
        ]

        requiredConditions = tally_of(secretAreaIDs[worldNumber], length(secretAreaIDs[worldNumber]), secretID =>
            once(
                currentWorld() == worldNumber
                && prev(gameplayState()) != GAMEPLAY_SECRET_AREA_INIT
                && gameplayState() == GAMEPLAY_SECRET_AREA_INIT
                && secretAreaID() == secretID
            )
        )

        cancelConditions = 
            never(gameState() != GAME_STATE_STARTED)
            && never(currentWorld() != worldNumber)

        return cancelConditions && measured(requiredConditions)
    }

    function triggerSpeedrun(targetStage, time) {
        primingConditions = 
            once(
                currentStage() == targetStage
                && gameplayState() == GAMEPLAY_START_LIFE_OR_LEVEL
                && stageProgress() == STAGE_PROGRESS_START
            )

        cancelConditions = 
            never(gameState() != GAME_STATE_STARTED)
            && never(currentStage() != targetStage)
            && never(gameplayState() == GAMEPLAY_DEATH)
            && never(gameplayState() == GAMEPLAY_SECRET_AREA_INIT)
            && never(timeRemaining() < 400 - time)

        targetConditions = 
            currentStage() == targetStage
            && prev(gameplayState()) != GAMEPLAY_STAGE_COMPLETED
            && gameplayState() == GAMEPLAY_STAGE_COMPLETED

        return primingConditions && cancelConditions && trigger_when(targetConditions)
    }

    function triggerBossKillByProjectiles(targetWorld) {
        bossByWorld = [
            {},
            {"enemyTypeBossAlive": 0x08, "enemyTypeBossDead": 0x4f, "superballBonus": 0xc0}, // World 1
            {"enemyTypeBossAlive": 0x1a, "enemyTypeBossDead": 0x4f, "superballBonus": 0xc0}, // World 2
            {"enemyTypeBossAlive": 0x32, "enemyTypeBossDead": 0x4f, "superballBonus": 0xc0}  // World 3
        ]

        enemyTypeBossAlive = bossByWorld[targetWorld]["enemyTypeBossAlive"]
        enemyTypeBossDead = bossByWorld[targetWorld]["enemyTypeBossDead"]
        superballBonus = bossByWorld[targetWorld]["superballBonus"]

        requiredConditions =
            gameState() == GAME_STATE_STARTED
            && currentStage() == targetWorld*0x10 + 3

        targetConditions =
            any_of(range(1,8), index =>
                prev(enemyType(index)) == enemyTypeBossAlive
                && enemyType(index) == enemyTypeBossDead

                && prev(enemySuperballStats(index)) == superballBonus
                && enemySuperballStats(index) == 0x00
            )
        
        return requiredConditions && targetConditions
    }

    function triggerFinalBossPerfect() {
        primingConditions = 
            tally_of(range(1,8), 1, index =>
                prev(enemyType(index)) != 0x61
                && enemyType(index) == 0x61
            )

        cancelConditions = 
            never(gameState() != GAME_STATE_STARTED)
            && never(currentStage() != WORLD_4_3)
            && never(marioSize() == MARIO_SIZE_SHRINKING)
            && never(gameplayState() == GAMEPLAY_DEATH)

        targetConditions =
            prev(gameplayState()) != GAMEPLAY_STAGE_COMPLETED
            && gameplayState() == GAMEPLAY_STAGE_COMPLETED

        return primingConditions && cancelConditions && trigger_when(targetConditions)
    }

    function triggerOneTakeHardMode() {
        primingConditions = once(
            currentStage() == WORLD_1_1
            && prev(gameplayState()) != GAMEPLAY_NEW_GAME
            && gameplayState() == GAMEPLAY_NEW_GAME
        )

        cancelConditions = 
            never(gameState() != GAME_STATE_STARTED)
            && never(timesGameCompleted() != 1)

        targetConditions = 
            currentStage() == WORLD_4_3
            && prev(gameplayState()) != GAMEPLAY_STAGE_COMPLETED
            && gameplayState() == GAMEPLAY_STAGE_COMPLETED

        return primingConditions && cancelConditions && trigger_when(targetConditions)
    }
// #endregion Triggers

// #region Achievements
    achievement(
        id = 1144,
        title = "Mushroom Man",
        description = "Grab a mushroom",
        points = 1,
        trigger = triggerCollectMushroom()
    )

    achievement(
        id = 75397,
        title = "Weaponized Balls",
        description = "Grab a Superball Flower from an item box and obtain the Superball ability",
        points = 2,
        trigger = triggerCollectFlower()
    )

    achievement(
        id = 1124,
        title = "Pocket Change",
        description = "Collect 99 coins",
        points = 2,
        trigger = triggerCoins(99)
    )

    achievement(
        id = 75400,
        title = "The Pyramid's Secret",
        description = "Collect all 28 coins on top of World 1-3",
        points = 5,
        trigger = triggerWorld13TopCoins()
    )

    achievement(
        id = 1355,
        title = "Coin Allergy",
        description = "Complete World 1 without collecting any coins",
        points = 25,
        trigger = triggerCoinlessWorld(1)
    )

    achievement(
        id = 1232,
        title = "Mamma Mia!",
        description = "Get 3 extra lives from the bonus game",
        points = 3,
        trigger = triggerBonusGame3Lives()
    )

    achievement(
        id = 75398,
        title = "Heart Collector",
        description = "Obtain 15 extra lives without dying",
        points = 10,
        trigger = triggerDeathlessExtraLives(15)
    )

    // #region Score Challenges
        achievement(
            id = 1145,
            title = "The Start of Something Big",
            description = "Accumulate 20,000 points",
            points = 5,
            trigger = triggerScore(20000)
        )

        achievement(
            id = 1246,
            title = "An Adventure Told in Points",
            description = "Accumulate 100,000 points",
            points = 5,
            trigger = triggerScore(100000)
        )

        achievement(
            id = 1236,
            title = "Super, Super Mario!",
            description = "Accumulate 250,000 points",
            points = 10,
            trigger = triggerScore(250000)
        )

        achievement(
            id = 75401,
            title = "Legend",
            description = "Accumulate 100,000 points on Hard Mode without dying [No Level Select Mode Allowed]",
            points = 25,
            trigger = triggerHardModeDeathlessScore(100000)
        )
    // #endregion Score Challenges

    // #region Stage Clears
        achievement(
            id = 1237,
            title = "The Sphinx's Riddle",
            description = "Complete World 1",
            points = 5,
            type = "progression",
            trigger = triggerWorldClear(1)
        )

        achievement(
            id = 1238,
            title = "Deep Sea Diver",
            description = "Complete World 2",
            points = 5,
            type = "progression",
            trigger = triggerWorldClear(2)
        )

        achievement(
            id = 1239,
            title = "Trouble on the Beachside",
            description = "Complete World 3",
            points = 5,
            type = "progression",
            trigger = triggerWorldClear(3)
        )

        achievement(
            id = 1235,
            title = "Sarasaland Rescue!",
            description = "Complete World 4",
            points = 10,
            type = "win_condition",
            trigger = triggerWorldClear(4)
        )
    // #endregion Stage Clears

    // #region Deathless Stage Clears
        achievement(
            id = 75393,
            title = "Birabuto Kingdom Master",
            description = "Complete World 1 without dying",
            points = 10,
            trigger = triggerDeathlessWorld(1)
        )

        achievement(
            id = 75394,
            title = "Muda Kingdom Master",
            description = "Complete World 2 without dying",
            points = 10,
            trigger = triggerDeathlessWorld(2)
        )

        achievement(
            id = 75395,
            title = "Easton Kingdom Master",
            description = "Complete World 3 without dying",
            points = 10,
            trigger = triggerDeathlessWorld(3)
        )

        achievement(
            id = 75396,
            title = "Chai Kingdom Master",
            description = "Complete World 4 without dying",
            points = 25,
            trigger = triggerDeathlessWorld(4)
        )
    // #endregion Deathless Stage Clears

    // #region Bonus Seeker
        achievement(
            id = 75403,
            title = "Birabuto Kingdom Bonus Seeker",
            description = "Enter the bonus games in World 1-1 and World 1-2",
            points = 5,
            trigger = triggerAllBonusGamesWorld(1)
        )

        achievement(
            id = 75404,
            title = "Muda Kingdom Bonus Seeker",
            description = "Enter the bonus games in World 2-1 and World 2-2",
            points = 5,
            trigger = triggerAllBonusGamesWorld(2)
        )

        achievement(
            id = 75405,
            title = "Easton Kingdom Bonus Seeker",
            description = "Enter the bonus games in World 3-1 and World 3-2",
            points = 5,
            trigger = triggerAllBonusGamesWorld(3)
        )

        achievement(
            id = 75406,
            title = "Chai Kingdom Bonus Seeker",
            description = "Enter the bonus games in World 4-1 and World 4-2",
            points = 5,
            trigger = triggerAllBonusGamesWorld(4)
        )
    // #endregion Bonus Seeker

    // #region Secret Seeker
        achievement(
            id = 75407,
            title = "Birabuto Kingdom Secret Seeker",
            description = "Find every secret area in World 1",
            points = 10,
            trigger = triggerWorldSecrets(1)
        )

        achievement(
            id = 75408,
            title = "Muda Kingdom Secret Seeker",
            description = "Find every secret area in World 2",
            points = 10,
            trigger = triggerWorldSecrets(2)
        )

        achievement(
            id = 75409,
            title = "Easton Kingdom Secret Seeker",
            description = "Find every secret area in World 3",
            points = 10,
            trigger = triggerWorldSecrets(3)
        )

        achievement(
            id = 75410,
            title = "Chai Kingdom Secret Seeker",
            description = "Find every secret area in World 4",
            points = 10,
            trigger = triggerWorldSecrets(4)
        )
    // #endregion Secret Seeker

    // #region Speedruns
        achievement(
            id = 1244,
            title = "Muda Kingdom Speedrunner",
            description = "Complete World 2-2 in under 70 seconds without using checkpoints or pipes",
            points = 10,
            trigger = triggerSpeedrun(WORLD_2_2, 70)
        )
    // #endregion Speedruns

    // #region Boss Challenges
        achievement(
            id = 75390,
            title = "Lion Tamer",
            description = "Defeat King Totomesu with superballs",
            points = 10,
            trigger = triggerBossKillByProjectiles(1)
        )

        achievement(
            id = 75391,
            title = "Dragon Tamer",
            description = "Without taking damage, defeat Dragonzamasu with torpedos",
            points = 10,
            trigger = triggerBossKillByProjectiles(2)
        )

        achievement(
            id = 75392,
            title = "Throwdown at the Beach",
            description = "Defeat Hiyoihoi with superballs",
            points = 10,
            trigger = triggerBossKillByProjectiles(3)
        )

        achievement(
            id = 75399,
            title = "Perfect Rescue!",
            description = "Defeat Biokinton and Tatanga without taking damage",
            points = 10,
            trigger = triggerFinalBossPerfect()
        )
    // #endregion Boss Challenges

    achievement(
        id = 1339,
        title = "Rescue Redux",
        description = "Beat the game on hard mode",
        points = 25,
        trigger = timesGameCompleted() == 1 && triggerWorldClear(4)
    )

    achievement(
        id = 75402,
        title = "Sarasaland King",
        description = "Beat the game on hard mode without using a continue",
        points = 25,
        trigger = triggerOneTakeHardMode()
    )
// #endregion Achievements

// #region Leaderboards
// #endregion Leaderboards

// #region Rich Presence
    rich_presence_conditional_display(
        gameState() == GAME_STATE_STARTED && timesGameCompleted() == 0,
        "World {0}-{1} • Normal Mode • {2} Lives • Score {3}",
        rich_presence_value("World", currentWorld()),
        rich_presence_value("Level", currentLevel()),
        rich_presence_value("Lives", livesRemaining()),
        rich_presence_macro("Score", score())
    )

    rich_presence_conditional_display(
        gameState() == GAME_STATE_STARTED && timesGameCompleted() > 0,
        "World {0}-{1} • Hard Mode • {2} Lives • Score {3}",
        rich_presence_value("World", currentWorld()),
        rich_presence_value("Level", currentLevel()),
        rich_presence_value("Lives", livesRemaining()),
        rich_presence_macro("Score", score()),
        rich_presence_value("Loop", timesGameCompleted() + 1)
    )

    rich_presence_display("In Attract Mode")
// #endregion Rich Presence