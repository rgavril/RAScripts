// Super Contra
// #ID = 1989

// #region Memory Addresses
    TRUE = 0x01
    FALSE = 0x00

    function gameState() => byte(0x0018)
    GAME_STATE_DEMO = 0x01
    GAME_STATE_INGAME = 0x04

    function currentArea() => byte(0x0050) + 1
    function currentAreaSection() => byte(0x0016)
    function numberOfPlayers() => byte(0x0022) + 1

    function player1Weapon() => low4(0x00b8)
    WEAPON_STANDARD = 0x00
    WEAPON_MACHINEGUN = 0x01
    WEAPON_SPREADGUN = 0x02
    WEAPON_LASER = 0x03
    WEAPON_FIREBALL = 0x04
    function player1JumpButton() => bit7(0x00f7)
    function player1Lives() => byte(0x0053)

    function cheatExtraLives() => byte(0x07ec)

    class gameObject {
        index = 0

        function type() => byte(0x06d8 + this.index)
        function state() => byte(0x0668 + this.index)
    }

    GAME_OBJECT_TYPES = {
        "Facehugger": 0x3e
    }

    GAME_OBJECT_STATES = {
        "Facehugger": {
            "Death": 0x04,
        }
    }
// #endregion Memory Addresses

// #region Frames
    function framePlayer1Died() {
        return prev(player1Lives()) > player1Lives()
    }
// #endregion Frames

// #region Triggers
    function triggerArea2BossChallenge() {
        cancelConditions =
               never( gameState()         != GAME_STATE_INGAME )
            && never( currentArea()       != 2                 )
            && never( cheatExtraLives()   == TRUE              )

        bossDiedCondition =
            any_of(range(0, 13), index =>
                once(
                    gameObject(index).type() == 0x69
                    && prev(gameObject(index).state()) == 0x02
                    && gameObject(index).state() == 0x03
                )
                &&
                trigger_when (
                    gameObject(index).type() == 0x69
                    && gameObject(index).state() == 0x07
                    && prev(gameObject(index).state()) != 0x07  
                )
            )

        redSoldierKilledCondition =
            never(any_of(range(0, 13), index =>
                prev(gameObject(index).type()) == 0x6a && 
                prev(gameObject(index).state()) == 0x04
            ))

        return cancelConditions && bossDiedCondition && redSoldierKilledCondition
    }

    function trigerArea7CrawlersChallange() {
        startConditions = 
            once(
                currentArea() == 7
                && currentAreaSection() == 0x00 // Stage Start
            )
            &&
            once(
                currentArea() == 7
                && currentAreaSection() == 0x08 // Vertical Shaft End & Eggs Room Start
            )

        cancelConditions =
            never(gameState()       != GAME_STATE_INGAME )
            && never(currentArea()     != 7                 )
            && never(numberOfPlayers() == 2                 )

        deathCrawlerCondition = 
            any_of(range(0, 13), index =>
                gameObject(index).type() == GAME_OBJECT_TYPES["Facehugger"]
                && gameObject(index).state() == GAME_OBJECT_STATES["Facehugger"]["Death"]
            )

        triggerCondition = 
            currentArea() == 7
            && prev(currentAreaSection()) == 0x0b // Eggs Room End
            && currentAreaSection() == 0x0c       // Boss Room

        return cancelConditions && startConditions && trigger_when(triggerCondition) && never(deathCrawlerCondition)
    }

    function triggerArea7BossChallenge() {
        cancelConditions =
               never( gameState()         != GAME_STATE_INGAME )
            && never( currentArea()       != 7                 )
            && never( numberOfPlayers()   != 1                 )
            && never( player1Weapon()     != WEAPON_STANDARD   )
            && never( player1JumpButton() == 1                 )
            && never( framePlayer1Died()                       )

        enemyConditions =
            any_of(range(0, 13), index =>
                // Priming Condition
                once(
                    gameObject(index).type() == 0x51
                    && prev(gameObject(index).state()) == 0x02
                    && gameObject(index).state() == 0x03
                )
                &&
                // Trigger Condition
                trigger_when (
                    gameObject(index).type() == 0x51
                    && gameObject(index).state() == 0x08
                    && prev(gameObject(index).state()) != 0x08
                )
            )

        return cancelConditions && enemyConditions
    }
// #endregion Triggers

// #region Achievements
    // #region Area 2 Challanges
        achievement(
            id = 50860,
            title = "Treadnought",
            description = "Defeat the Area 2 boss without killing either of the red soldiers and without using the extra lives code",
            points = 10,
            trigger = triggerArea2BossChallenge()
        )
    // #endregion Area 2 Challanges

    // #region Area 7 Challanges
        achievement(
            id = 51121,
            title = "Save the Face-Huggers!",
            description = "[1P Only] Reach the boss in Area 7 without killing any crawlers",
            points = 25,
            trigger = trigerArea7CrawlersChallange()
        )

        achievement(
            id = 51123,
            title = "Bare Bones, Naked Gun",
            description = "[1P Only] Defeat the Area 7 boss without jumping, dying, or using any power-ups",
            points = 25,
            trigger = triggerArea7BossChallenge()   
        )
    // #endregion Area 7 Challanges
// #endregion Achievements