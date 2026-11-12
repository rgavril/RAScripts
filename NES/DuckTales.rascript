// DuckTales (NES)
// #ID = 1472

// #region Memory Locations
    function gameScreen() => byte(0x002b)
        GAME_SCREEN_IN_STAGE = 0x08

    function gameState() => byte(0x00df)
        GAME_STATE_STAGE_COMPLETED = 0x0f

    function stage() => byte(0x00f6)
        STAGE_AMAZON = 0x00
        STAGE_TRANSYLVANIA = 0x01
        STAGE_AFRICAN_MINES = 0x02
        STAGE_HIMALAYAS = 0x03
        STAGE_MOON = 0x04
        STAGE_ENTER_BOSS_ROOM = 0x05
        STAGE_GAME_END = 0x09

    function mapVerticalPosition() => byte(0x00f1)
    function mapHorizontalPosition() => word(0x00f2)

    function money() => 
        byte(0x032a) * 1 +
        byte(0x0329) * 10 + 
        byte(0x0328) * 100 + 
        byte(0x0327) * 1000 +
        byte(0x0326) * 10000 +
        byte(0x0325) * 100000 +
        byte(0x0324) * 1000000

// #endregion Memory Locations

// #region Triggers
    function triggerAmazonStatueNoPay() {
        pauseLockConditions =
            unless(
                once(
                    // Lock Condition
                    stage() == STAGE_AMAZON
                    && money() == prev(money()) - 300000
                    
                    // Unlock Condition
                    && never(
                        gameScreen() != GAME_SCREEN_IN_STAGE
                    )
                )
            )

        triggerConditions =
            stage() == STAGE_AMAZON
            && prev(gameState()) != GAME_STATE_STAGE_COMPLETED
            && gameState() == GAME_STATE_STAGE_COMPLETED

        return pauseLockConditions && triggerConditions
    }
// #endregion Triggers

// #region Achievements
    achievement(
        id = 45106,
        title = "Statue of Limitations",
        description = "Reach and defeat the Incan Sentinel in the Amazon without paying the statue to reach the top floor",
        points = 3,
        trigger = triggerAmazonStatueNoPay()
    )
// #endregion Achievements
