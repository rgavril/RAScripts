// Contra
// #ID = 1447

// #region Memory Addresses
    function gameState() => byte(0x0018)
    GAME_STATE_ACTIVEPLAY = 0x05

    function gameplayState() => byte(0x002c)
    GAMEPLAY_STATE_GAME_OVER = 0x06


    function currentStage() => byte(0x0030) + 1
    function stageProgress() => word_be(0x0064)

    function objectType(index) => byte(0x0528 + index)
    function objectState(index) => byte(0x04b8 + index)
    function objectHealth(index) => byte(0x0578 + index)
// #endregion Memory Addresses

// #region Triggers
    function triggerStage8BossChallange() {
        cancelConditions = 
            never( gameState() != GAME_STATE_ACTIVEPLAY )
            && never( gameplayState() == GAMEPLAY_STATE_GAME_OVER )
            && never( currentStage() != 8 )
            && never(
                // Alien Crawler Died:
                any_of(range(0, 15), index =>
                    // NOTE: Use previous frame state for death check.
                    // This avoids false challenge failure caused by the shared death effect between boss and minions
                    prev(objectType(index)) == 0x14 // 0x14 ~ Alien Crawler
                    //&& prev(objectState(index)) == 0x06 // 0x06 ~ Died

                    && prev(objectState(index)) >= 0x01 // 0x01 ~ Spawning
                    && prev(objectHealth(index)) > objectHealth(index)
                )
            )
            && never(
                // Alien Crawler Spawner Died:
                any_of(range(0, 15), index =>
                    // NOTE: Use previous frame state for death check.
                    // This avoids false challenge failure caused by the shared death effect between boss and minions
                    prev(objectType(index)) == 0x15 // 0x15 ~ Alien Crawler Spawner
                    //&& prev(objectState(index)) == 0x03 // 0x03 ~ Died

                    && prev(objectState(index)) >= 0x01 // 0x01 ~ Spawning
                    && prev(objectHealth(index)) > objectHealth(index)
                )
            )

        primingConditions = 
            once(
                prev(stageProgress()) < 0x0890
                && stageProgress() >= 0x0890
            )

        targetConditions = 
            // Main Boss Died:
            any_of(range(0, 15), index =>
                objectType(index) == 0x16 // 0x16 ~ Final Stage Boss Brain
                && objectState(index) == 0x04 // 0x04 ~ Died
            )

        return primingConditions && trigger_when(targetConditions) && cancelConditions
    }
// #endregion Triggers

// #region Achievements
    achievement(
        id = 6849,
        title = "Die-pass Operation",
        description = "Defeat the final boss without damaging the aliens or their spawners",
        trigger = triggerStage8BossChallange(),
        points = 10
    )
// #endregion Achievements