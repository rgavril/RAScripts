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
    
    function currentStage() => byte(0x00ffb4)
        WORLD_1_3 = 0x13
    function currentWorld() => high4(0x00ffb4)

    function stageProgress() => byte(0x00c0ab)
        STAGE_PROGRESS_START = 0x0c 

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
// #endregion Achievements

// #region Leaderboards
// #endregion Leaderboards

// #region Rich Presence
// #endregion Rich Presence