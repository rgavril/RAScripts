// Super Mario Bros
// #ID = 1446

// #region Memory Locations
    function gameState() => byte(0x0770)
        GAMESTATE_TITLE_SCREEN = 0x00
        GAMESTATE_NORMAL_GAMEPLAY = 0x01
        GAMESTATE_FINISHED_WORLD = 0x02

    function livesRemaining() => byte(0x075a) + 1
    function currentWorld() => byte(0x075f) + 1
    function currentWorldStage() => byte(0x075c) + 1
// #endregion

// #region Frames
    function frameGameStarted() {
        return
            prev(gameState()) == GAMESTATE_TITLE_SCREEN
            && gameState() == GAMESTATE_NORMAL_GAMEPLAY
    }

    function frameWorldFinished() {
        return
            prev(gameState()) == GAMESTATE_NORMAL_GAMEPLAY
            && gameState() == GAMESTATE_FINISHED_WORLD
    }

    function frameLivesDecreased() {
        return
             livesRemaining() < prev(livesRemaining())
    }
// #endregion

// #region Triggers
    function triggerMasterPlumber(targetWorld) {
        primingConditions = tally(1,
            // New Game Started from World
            frameGameStarted() 
            && currentWorld() == targetWorld
            ,
            // Advanced from another World
            prev(currentWorld()) != targetWorld
            && currentWorld() == targetWorld
            && currentWorldStage() == 1
        )

        cancelConditions = 
            never(currentWorld() != targetWorld)
            && never(gameState() == GAMESTATE_TITLE_SCREEN)
            && never(frameLivesDecreased())

        targetConditions = 
            currentWorld() == targetWorld
            && frameWorldFinished()

        return primingConditions && cancelConditions && trigger_when(targetConditions)
    }
// #endregion Triggers

// #region Achievements
    achievement(
        id = 39673,
        title = "Master Plumber I",
        description = "Complete World 1 without losing a life",
        points = 10,
        trigger = triggerMasterPlumber(1)
    )

    achievement(
        id = 39674,
        title = "Master Plumber II",
        description = "Complete World 2 without losing a life",
        points = 10,
        trigger = triggerMasterPlumber(2)
    )

    achievement(
        id = 39675,
        title = "Master Plumber III",
        description = "Complete World 3 without losing a life",
        points = 10,
        trigger = triggerMasterPlumber(3)
    )

    achievement(
        id = 39676,
        title = "Master Plumber IV",
        description = "Complete World 4 without losing a life",
        points = 10,
        trigger = triggerMasterPlumber(4)
    )

    achievement(
        id = 39677,
        title = "Master Plumber V",
        description = "Complete World 5 without losing a life",
        points = 10,
        trigger = triggerMasterPlumber(5)
    )

    achievement(
        id = 39678,
        title = "Master Plumber VI",
        description = "Complete World 6 without losing a life",
        points = 10,
        trigger = triggerMasterPlumber(6)
    )

    achievement(
        id = 39679,
        title = "Master Plumber VII",
        description = "Complete World 7 without losing a life",
        points = 25,
        trigger = triggerMasterPlumber(7)
    )

    achievement(
        id = 3387,
        title = "Master Plumber VIII",
        description = "Complete World 8 while not losing a life",
        points = 25,
        trigger = triggerMasterPlumber(8)
    )
// #endregion Achievements