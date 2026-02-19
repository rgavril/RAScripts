// Super Contra
// #ID = 1989

// #region Memory Addresses
    TRUE = 0x01
    FALSE = 0x00

    function gameplayState() => byte(0x0018)
    GAMEPLAY_DEMO = 0x01
    GAMEPLAY_STARTED = 0x04

    function gameState() => byte(0x0038)
    GAMESTATE_MAIN_MENU = 0x00
    GAMESTATE_AREA_INTRO = 0x01
    GAMESTATE_IN_GAME = 0x03
    GAMESTATE_AREA_COMPLETE = 0x04
    GAMESTATE_GAME_OVER = 0x05
    GAMESTATE_GAME_OVER_SCREEN = 0x06

    function currentArea() => byte(0x0050) + 1
    function currentAreaSection() => byte(0x0016)
    function currentAreaHorizontalPosition() => word(0x0064)
    function currentAreaVerticalPosition() => word(0x0073)
    function numberOfPlayers() => byte(0x0022) + 1

    function player1Weapon() => low4(0x00b8)
    WEAPON_STANDARD = 0x00
    WEAPON_MACHINEGUN = 0x01
    WEAPON_SPREADGUN = 0x02
    WEAPON_LASER = 0x03
    WEAPON_FIREBALL = 0x04
    function player1JumpButton() => bit7(0x00f7)
    function player1Lives() => byte(0x0053)
    function player1PositionX() => word(0x054c)
    function player1InvincibilityFrames() => byte(0x00c4)
    function player1State() => byte(0x00a0)

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

    function objectType(index) => byte(0x06d8 + index)
    function objectState(index) => byte(0x0668 + index)
    function objectXPosition(index) => byte(0x053c + index)
// #endregion Memory Addresses

// #region Frames
    function framePlayer1Died() {
        return prev(player1Lives()) > player1Lives()
    }

    function frameAreaCompleted() {
        return 
            prev(gameState()) != GAMESTATE_IN_GAME
            && gameState() == GAMESTATE_AREA_COMPLETE
    }
// #endregion Frames

// #region Triggers
    function triggerAreaClear(area) {
        return
            gameplayState() == GAMEPLAY_STARTED
            && currentArea() == area
            && frameAreaCompleted()
    }

    function triggerArea1GreenSoldiersChallange() {
        cancelConditions =
               never( gameplayState()     != GAMEPLAY_STARTED  )
            && never( currentArea()       != 1                 )

        greenSoldierKilledCondition =
            any_of(range(0, 13), index =>
                gameObject(index).type() == 0x03 &&
                gameObject(index).state() == 0x05
            )

        turretDestroyedCondition =
            any_of(range(0, 13), index =>
                gameObject(index).type() == 0x20 &&
                gameObject(index).state() == 0x06
            )
        
        primingCondition =
            once(
                currentArea() == 1
                && currentAreaHorizontalPosition() == 0x0104 // Start of Area 1 (Helicopter)
            )

        targetConditions =
            currentArea() == 1
            && prev(currentAreaHorizontalPosition()) < 0x0b00 // Fourth Upward Slope Start
            && currentAreaHorizontalPosition() >= 0x0b00 // Fourth Upward Slope Start

        return 
            primingCondition && trigger_when(targetConditions)
            && cancelConditions
            && never(greenSoldierKilledCondition) && never(turretDestroyedCondition)
    }

    function triggerArea2BossChallenge() {
        cancelConditions =
               never( gameplayState()     != GAMEPLAY_STARTED  )
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

    function triggerArea4RightSideAscend() {
        cancelConditions =
               never( gameplayState()     != GAMEPLAY_STARTED  )
            && never( currentArea()       != 4                 )

        startConditions =
            once(
                prev(currentAreaVerticalPosition()) == 0x0c00
                && currentAreaVerticalPosition() < 0x0c00
            )

        triggerConditions =
            prev(currentAreaVerticalPosition()) != 0x001a
            && currentAreaVerticalPosition() == 0x001a

        P1OnTheLeft =
            player1InvincibilityFrames() == 0
            && player1State() == 0x02
            && (currentAreaVerticalPosition() < 0x0500 || currentAreaVerticalPosition() > 0x050e)
            && player1PositionX() < (0xff / 2)

        return startConditions && trigger_when(triggerConditions) && cancelConditions && never(P1OnTheLeft)
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
            never(gameplayState()      != GAMEPLAY_STARTED  )
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
               never( gameplayState()     != GAMEPLAY_STARTED  )
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

    function triggerArea8RunningEnemies() {
        startConditions = once(
            currentArea() == 8
            && prev(currentAreaSection()) == 0x00 // Stage Start
            && currentAreaSection() == 0x01 // First Area with Running Enemies
        )

        targetConditions = once(
            currentArea() == 8
            && prev(currentAreaSection()) == 0x0d // Pre-Boss Room
            && currentAreaSection() == 0x0e // Boss Room
        )

        cancelConditions =
               never( gameplayState()     != GAMEPLAY_STARTED  )
            && never( currentArea()       != 8                 )

        enemyEscapeOnRight =
            never(any_of(range(0, 13), index =>
                objectType(index) == 0x03
                && prev(objectXPosition(index)) < 0xfe
                && objectXPosition(index) >= 0xfe
            ))

        enemyEscapeOnLeft = 
            never(any_of(range(0, 13), index =>
                objectType(index) == 0x03
                && prev(objectXPosition(index)) > 0x06
                && objectXPosition(index) <= 0x06
            ))

        return startConditions && trigger_when(targetConditions) && cancelConditions && enemyEscapeOnLeft && enemyEscapeOnRight
    }
// #endregion Triggers

// #region Achievements
    // #region Area Clear Achievements
        achievement(
            title = "Lightning and Grenades",
            description = "Clear Area 1",
            points = 5,
            trigger = triggerAreaClear(1),
            type = "progression"
        )

        achievement(
            title = "Military Fortress",
            description = "Clear Area 2",
            points = 5,
            trigger = triggerAreaClear(2),
            type = "progression"
        )

        achievement(
            title = "Return to the Jungle",
            description = "Clear Area 3",
            points = 5,
            trigger = triggerAreaClear(3),
            type = "progression"
        )

        achievement(
            title = "Mechanical Factory",
            description = "Clear Area 4",
            points = 10,
            trigger = triggerAreaClear(4),
            type = "progression"
        )

        achievement(
            title = "Perilous Cliff",
            description = "Clear Area 5",
            points = 10,
            trigger = triggerAreaClear(5),
            type = "progression"
        )

        achievement(
            title = "Terror Under your Feet",
            description = "Clear Area 6",
            points = 10,
            trigger = triggerAreaClear(6),
            type = "progression"
        )

        achievement(
            title = "Belly of the Beast",
            description = "Clear Area 7",
            points = 10,
            trigger = triggerAreaClear(7),
            type = "progression"
        )

        achievement(
            title = "Crushing Catastrophe",
            description = "Clear Area 8 and beat the game",
            points = 10,
            trigger = triggerAreaClear(8),
            type = "win_condition"
        )
    // #endregion Area Clear Achievements

    // #region Area 1 Challanges
        achievement(
            id = 50936,
            title = "Gun Hurdling Champion",
            description = "Reach the fourth upward slope in Area 1 without killing any green soldiers or destroying any turrets",
            points = 25,
            trigger = triggerArea1GreenSoldiersChallange()
        )
    // #endregion Area 1 Challanges

    // #region Area 2 Challanges
        achievement(
            id = 50860,
            title = "Treadnought",
            description = "Defeat the Area 2 boss without killing either of the red soldiers and without using the extra lives code",
            points = 10,
            trigger = triggerArea2BossChallenge()
        )
    // #endregion Area 2 Challanges

    // #region Area 4 Challanges
        achievement(
            title = "The Right Way Up",
            description = "Ascend Area 4 while staying on the right half of the screen. Left half allowed only for knockback, respawning and the elevator 2 access platform. Extra lives code not allowed",
            points = 10,
            trigger = triggerArea4RightSideAscend()
        )
    // #endregion Area 4 Challanges

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

    // #region Area 8 Challanges
        achievement(
            title = "The Only Way to be Sure",
            description = "Don't let any of the running enemies for Area 8 get from one side of the screen to the other.",
            points = 10,
            trigger = triggerArea8RunningEnemies()
        )
    // #endregion Area 8 Challanges
// #endregion Achievements