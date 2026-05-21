// Super Mario Bros
// #ID = 1446

// #region Memory Locations
    TRUE = 0x01
    FALSE = 0x00

    function gameState() => byte(0x0770)
        GAMESTATE_TITLE_SCREEN = 0x00
        GAMESTATE_NORMAL_GAMEPLAY = 0x01
        GAMESTATE_FINISHED_WORLD = 0x02

    function livesRemaining() => byte(0x075a) + 1
    function currentWorld() => byte(0x075f) + 1
    function currentWorldStage() => byte(0x075c) + 1
    function activePowerup() => byte(0x0756)
        ACTIVE_POWERUP_NONE = 0x00
        ACTIVE_POWERUP_MUSHROOM = 0x01
        ACTIVE_POWERUP_FLOWER = 0x02

    function sfxEnemySmushed() => bit2(0x00f1)
    function sfxEnemyKO() => bit3(0x00f1)
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
            // New Game Started from World <targetWorld>
            frameGameStarted() 
            && currentWorld() == targetWorld
            ,
            // Advanced from another World to <targetWorld>
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

    function triggerPacifistMario(targetWorld) {
        primingConditions = tally(1,
            // New Game Started from Target World
            frameGameStarted() 
            && currentWorld() == targetWorld
            ,
            // Advanced from another World to Target World
            prev(currentWorld()) != targetWorld
            && currentWorld() == targetWorld
            && currentWorldStage() == 1
        )

        cancelConditions = 
            // Outside of Targeted World
            never(currentWorld() != targetWorld)
            // Game Over
            && never(livesRemaining() == 0xff+1)
            // In Title Screen
            && never(gameState() == GAMESTATE_TITLE_SCREEN)
            // Fire Flower Used
            && never(activePowerup() == ACTIVE_POWERUP_FLOWER)
            // Enemy Damaged
            && never(sfxEnemyKO() == TRUE)
            && never(sfxEnemySmushed() == TRUE)

        targetConditions =
            // Target World Finished
            currentWorld() == targetWorld
            && frameWorldFinished()

        return primingConditions && cancelConditions && trigger_when(targetConditions)
    }
// #endregion Triggers

// #region Achievements
    // #region Master Plumber
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
    // #endregion Master Plumber

    // #region Pacifist Mario
        achievement(
            id = 40403,
            title = "Pacifist Mario I",
            description = "Complete World 1 without harming enemies or being Fire Mario",
            points = 10,
            trigger = triggerPacifistMario(1)
        )

        achievement(
            id = 40404,
            title = "Pacifist Mario II",
            description = "Complete World 2 without harming enemies or being Fire Mario",
            points = 10,
            trigger = triggerPacifistMario(2)
        )

        achievement(
            id = 40405,
            title = "Pacifist Mario III",
            description = "Complete World 3 without harming enemies or being Fire Mario",
            points = 10,
            trigger = triggerPacifistMario(3)
        )

        achievement(
            id = 40406,
            title = "Pacifist Mario IV",
            description = "Complete World 4 without harming enemies or being Fire Mario",
            points = 10,
            trigger = triggerPacifistMario(4)
        )

        achievement(
            id = 40407,
            title = "Pacifist Mario V",
            description = "Complete World 5 without harming enemies or being Fire Mario",
            points = 25,
            trigger = triggerPacifistMario(5)
        )

        achievement(
            id = 40408,
            title = "Pacifist Mario VI",
            description = "Complete World 6 without harming enemies or being Fire Mario",
            points = 25,
            trigger = triggerPacifistMario(6)
        )

        achievement(
            id = 40409,
            title = "Pacifist Mario VII",
            description = "Complete World 7 without harming enemies or being Fire Mario",
            points = 25,
            trigger = triggerPacifistMario(7)
        )

        achievement(
            id = 40410,
            title = "Pacifist Mario VIII",
            description = "Complete World 8 without harming enemies or being Fire Mario",
            points = 25,
            trigger = triggerPacifistMario(8)
        )
    // #endregion
// #endregion Achievements