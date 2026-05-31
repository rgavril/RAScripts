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
        GAMEPLAY_BONUS_GOAL = 0x1a
        GAMEPLAY_STAGE_COMPLETED = 0x07
        GAMEPLAY_NEW_GAME = 0x11 
    function currentStage() => byte(0x00ffb4)
        WORLD_1_3 = 0x13
    function currentWorld() => high4(0x00ffb4)
    function stageProgress() => byte(0x00c0ab)
        STAGE_PROGRESS_START = 0x0c

    function bonusGamePrize() => byte(0x00da17)
        BONUS_PRIZE_DECIDING = 0x00
        BONUS_PRIZE_1LIFE = 0x02
        BONUS_PRIZE_2LIVES = 0x03
        BONUS_PRIZE_3LIVES = 0x04
        BONUS_PRIZE_FLOWER = 0x10

    //function score() => bcd(byte(0xc0a0)) + bcd(byte(0xc0a1)) * 100 + bcd(byte(0xc0a2)) * 10000
    function score() => low4(0xc0a0) + high4(0xc0a0) * 10 + low4(0xc0a1) * 100 + high4(0xc0a1) * 1000 + low4(0xc0a2) * 10000 + high4(0xc0a2) * 100000
    //function livesRemaining() => bcd(byte(0xda15))
    function livesRemaining() => high4(0xda15)*10 + low4(0xda15)
    function marioSize() => byte(0xff99)
        MARIO_SIZE_SMALL = 0x00
        MARIO_SIZE_GROWING = 0x01
    function superBallState() => byte(0xffb5)
    function coinsCollected() => byte(0xfffa)
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
// #endregion Achievements

// #region Leaderboards
// #endregion Leaderboards

// #region Rich Presence
// #endregion Rich Presence