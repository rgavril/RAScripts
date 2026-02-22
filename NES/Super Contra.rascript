// Super Contra
// #ID = 1989

// #region Memory Addresses
    TRUE = 0x01
    FALSE = 0x00

    function gameState() => byte(0x0018)
    GAMESTATE_DEMOPLAY = 0x01
    GAMESTATE_STAGE_SELECT = 0x02
    GAMESTATE_ACTIVEPLAY_BOOT = 0x03
    GAMESTATE_ACTIVEPLAY = 0x04

    function gameScreen() => byte(0x0038)
    SCREEN_MAIN_MENU = 0x00
    SCREEN_AREA_INTRO = 0x01
    SCREEN_GAMEPLAY_BOOT = 0x02
    SCREEN_GAMEPLAY = 0x03
    SCREEN_AREA_COMPLETE = 0x04
    SCREEN_GAME_OVER_BOOT = 0x05
    SCREEN_GAME_OVER = 0x06
    SCREEN_CONTINUE = 0x07
    SCREEN_GAME_ENDING = 0x08


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
    PLAYERSTATE_NORMAL = 0x02
    PLAYERSTATE_DEATH_ANIMATION_START = 0x03
    PLAYERSTATE_DEATH_ANIMATION_END = 0x04
    PLAYERSTATE_DEAD = 0x05

    function cheatExtraLives() => byte(0x07ec)

    function objectType(index) => byte(0x06d8 + index)
    function objectState(index) => byte(0x0668 + index)
    function objectXPosition(index) => byte(0x053c + index)
// #endregion Memory Addresses

// #region Frames
    function framePlayer1Died() {
        return
            prev(player1State()) == PLAYERSTATE_NORMAL
            && player1State() == PLAYERSTATE_DEATH_ANIMATION_START
    }

    function frameAreaCompleted() {
        return
            gameState() == GAMESTATE_ACTIVEPLAY
            && prev(gameScreen()) != SCREEN_GAMEPLAY
            && gameScreen() == SCREEN_AREA_COMPLETE
    }

    function frameAreaStarted() {
        return
            prev(gameScreen()) == SCREEN_AREA_INTRO
            && gameScreen() == SCREEN_GAMEPLAY_BOOT
    }
// #endregion Frames

// #region Triggers
    function triggerAreaClear(area) {
        cancelConditions = 
            never( gameState() != GAMESTATE_ACTIVEPLAY )
        
        requiredConditions = 
            all_of(range(1, area), areaNumber => 
                once( currentArea() == areaNumber && frameAreaCompleted() )
            )

        return cancelConditions && requiredConditions
    }

    function triggerAreaClearDeathless(area) {
        startConditions = 
            once(
                currentArea() == area
                && frameAreaStarted()
            )

        targetConditions =
            currentArea() == area
            && frameAreaCompleted()

        cancelConditions =
            never( gameState() != GAMESTATE_ACTIVEPLAY )
            && never( numberOfPlayers() != 1)
            && never( framePlayer1Died() )

        return startConditions && cancelConditions && targetConditions
    }
 
    function triggerArea1GreenSoldiersChallange() {
        primingCondition =
            once(
                currentArea() == 1
                && currentAreaHorizontalPosition() == 0x0104 // 0x0104 ~ Start of Area 1 (Helicopter)
            )

        cancelConditions =
            never( gameState() != GAMESTATE_ACTIVEPLAY )
            && never( currentArea() != 1 )

        greenSoldierKilledCondition =
            any_of(range(0, 13), index =>
                objectType(index) == 0x03 // 0x03 ~ Running Soldier
                && objectState(index) == 0x05 // 0x05 ~ Death Animation Start
            )

        turretDestroyedCondition =
            any_of(range(0, 13), index =>
                objectType(index) == 0x20 // 0x20 ~ Area 1 Turret
                && objectState(index) == 0x06 // 0x06 ~ Death Animation Start
            )

        targetConditions =
            currentArea() == 1
            && prev(currentAreaHorizontalPosition()) < 0x0b00 // 0x0b00 ~ Fourth Upward Slope Start
            && currentAreaHorizontalPosition() >= 0x0b00 // 0x0b00 ~ Fourth Upward Slope Start

        return 
            primingCondition
            && cancelConditions
            && never(greenSoldierKilledCondition)
            && never(turretDestroyedCondition)
            && trigger_when(targetConditions)
    }

    function triggerArea1BossChallange() {
        cancelConditions =
            never( gameState() != GAMESTATE_ACTIVEPLAY  )
            && never( currentArea() != 1 )
            && never( cheatExtraLives() == TRUE )
            && never( numberOfPlayers() == 2 )
            && never( player1JumpButton() == TRUE )

        startCondition =
            once(
                prev(currentAreaSection()) != 0x0c // 0x0c ~ Area 1 Boss Fight
                && currentAreaSection() == 0x0c // 0x0c ~ Area 1 Boss Fight
            )

        triggerCondition =
            any_of(range(0,13), index=>
                objectType(index) == 0x21 // 0x21 ~ Helicopter Main Target
                && prev(objectState(index)) != 0x07 // 0x07 ~ Death Animation Started
                && objectState(index) == 0x07 // 0x07 ~ Death Animation Started
            )

        return cancelConditions && startCondition && trigger_when(triggerCondition)
    }

    function triggerArea2BossChallenge() {
        cancelConditions =
            never( gameState() != GAMESTATE_ACTIVEPLAY  )
            && never( currentArea() != 2 )
            && never( cheatExtraLives() == TRUE )

        bossDiedCondition =
            any_of(range(0, 13), index =>
                // Priming Condition: Green Gunner is Spawned
                once(
                    objectType(index) == 0x69 // Green Gunner
                    && prev(objectState(index)) == 0x02 // Spawning in previous frame
                    && objectState(index) == 0x03 // Active
                )
                &&

                // Trigger Condition: Green Gunner is Dead
                trigger_when (
                    objectType(index) == 0x69 // Green Gunner
                    && objectState(index) == 0x07 // Dead
                    && prev(objectState(index)) != 0x07 // Not Dead 
                )
            )

        redSoldierKilledCondition =
            // Cancel Condition: Any of the two red gunners are killed
            never(any_of(range(0, 13), index =>
                prev(objectType(index)) == 0x6a // Red Gunner
                && prev(objectState(index)) == 0x04 // Died

                // NOTE: We check for the death condition in the previous frame to avoid
                // cancelling the challange when the green gunner dies, as the red gunners
                // die in the same frame as the green gunner due to a shared death effect.
            ))

        return cancelConditions && bossDiedCondition && redSoldierKilledCondition
    }

    function triggerArea4RightSideAscend() {
        cancelConditions =
               never( gameState() != GAMESTATE_ACTIVEPLAY  )
            && never( currentArea() != 4 )

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
                && currentAreaSection() == 0x00 // 0x00 ~ Stage Start
            )
            &&
            once(
                currentArea() == 7
                && currentAreaSection() == 0x08 // 0x08 ~ Vertical Shaft End & Eggs Room Start
            )

        cancelConditions =
            never( gameState() != GAMESTATE_ACTIVEPLAY  )
            && never( currentArea() != 7 )
            && never( numberOfPlayers() == 2 )

        deathCrawlerCondition = 
            any_of( range(0, 13), index =>
                objectType(index) == 0x3e // Facehugger
                && objectState(index) == 0x04 // Dead
            )

        triggerCondition = 
            currentArea() == 7
            && prev(currentAreaSection()) == 0x0b // 0x0b ~ Eggs Room End
            && currentAreaSection() == 0x0c // 0x0c ~ Boss Room

        return cancelConditions && startConditions && trigger_when(triggerCondition) && never(deathCrawlerCondition)
    }

    function triggerArea7BossChallenge() {
        cancelConditions =
               never( gameState() != GAMESTATE_ACTIVEPLAY )
            && never( currentArea() != 7 )
            && never( numberOfPlayers() != 1 )
            && never( player1Weapon() != WEAPON_STANDARD )
            && never( player1JumpButton() == 1 )
            && never( framePlayer1Died() )

        enemyConditions =
            any_of(range(0, 13), index =>
                // Priming Condition
                once(
                    objectType(index) == 0x51
                    && prev(objectState(index)) == 0x02
                    && objectState(index) == 0x03
                )
                &&
                // Trigger Condition
                trigger_when (
                    objectType(index) == 0x51
                    && objectState(index) == 0x08
                    && prev(objectState(index)) != 0x08
                )
            )

        return cancelConditions && enemyConditions
    }

    function triggerArea8RunningEnemies() {
        startConditions = once(
            currentArea() == 8
            && currentAreaSection() == 0x00 // 0x00 ~ Stage Start
        )

        targetConditions = once(
            currentArea() == 8
            && prev(currentAreaSection()) == 0x0d // 0x0d ~ Pre-Boss Room
            && currentAreaSection() == 0x0e // 0x0e ~ Boss Room
        )

        cancelConditions =
               never( gameState() != GAMESTATE_ACTIVEPLAY  )
            && never( currentArea() != 8 )

        enemyEscapeOnRight =
            never(any_of(range(0, 13), index =>
                   objectType(index)  == 0x03 // 0x03 ~ Running Soldier
                && objectState(index) == 0x02 // 0x02 ~ Walking
                && prev(objectXPosition(index)) <  0xfe // 0xfe ~ Despawn Point Right Side of Screen
                && objectXPosition(index) >= 0xfe // 0xfe ~ Despawn Point Right Side of Screen
            ))

        enemyEscapeOnLeft = 
            never(any_of(range(0, 13), index =>
                   objectType(index)  == 0x03 // 0x03 ~ Running Soldier
                && objectState(index) == 0x02 // 0x02 ~ Walking
                && prev(objectXPosition(index)) >  0x06 // 0x06 ~ Despawn Point of Left Side of Screen
                && objectXPosition(index) <= 0x06 // 0x06 ~ Despawn Point of Left Side of Screen
            ))

        return startConditions && trigger_when(targetConditions) && cancelConditions && enemyEscapeOnLeft && enemyEscapeOnRight
    }
// #endregion Triggers

// #region Achievements
    // #region Area Clear Achievements
        achievement(
            id = 11331,
            title = "Lightning and Grenades",
            description = "Clear Area 1",
            points = 5,
            trigger = triggerAreaClear(1),
            type = "progression"
        )

        achievement(
            id = 11332,
            title = "Military Fortress",
            description = "Clear Area 2, without using stage select",
            points = 5,
            trigger = triggerAreaClear(2),
            type = "progression"
        )

        achievement(
            id = 11333,
            title = "Return to the Jungle",
            description = "Clear Area 3, without using stage select",
            points = 5,
            trigger = triggerAreaClear(3),
            type = "progression"
        )

        achievement(
            id = 11334,
            title = "Mechanical Factory",
            description = "Clear Area 4, without using stage select",
            points = 5,
            trigger = triggerAreaClear(4),
            type = "progression"
        )

        achievement(
            id = 11335,
            title = "Perilous Cliff",
            description = "Clear Area 5, without using stage select",
            points = 5,
            trigger = triggerAreaClear(5),
            type = "progression"
        )

        achievement(
            id = 11336,
            title = "Terror Under your Feet",
            description = "Clear Area 6, without using stage select",
            points = 5,
            trigger = triggerAreaClear(6),
            type = "progression"
        )

        achievement(
            id = 11337,
            title = "Belly of the Beast",
            description = "Clear Area 7, without using stage select",
            points = 10,
            trigger = triggerAreaClear(7),
            type = "progression"
        )

        achievement(
            id = 11338,
            title = "Crushing Catastrophe",
            description = "Clear Area 8 and beat the game, without using stage select",
            points = 10,
            trigger = triggerAreaClear(8),
            type = "win_condition"
        )
    // #endregion Area Clear Achievements

    // #region Deathless Area Clear Achievements
        achievement(
            id = 11342,
            title = "Thunder Landing",
            description = "Clear Area 1 without dying in single player mode",
            points = 10,
            trigger = triggerAreaClearDeathless(1)
        )

        achievement(
            id = 11343,
            title = "In a Tight Squeeze",
            description = "Clear Area 2 without dying in single player mode",
            points = 10,
            trigger = triggerAreaClearDeathless(2)
        )

        achievement(
            id = 11344,
            title = "Jungle Juncture",
            description = "Clear Area 3 without dying in single player mode",
            points = 10,
            trigger = triggerAreaClearDeathless(3)
        )

        achievement(
            id = 11345,
            title = "No Escape",
            description = "Clear Area 4 without dying in single player mode",
            points = 10,
            trigger = triggerAreaClearDeathless(4)
        )

        achievement(
            id = 11346,
            title = "Massacre Mountains",
            description = "Clear Area 5 without dying in single player mode",
            points = 10,
            trigger = triggerAreaClearDeathless(5)
        )

        achievement(
            id = 11347,
            title = "Hotter than Hell",
            description = "Clear Area 6 without dying in single player mode",
            points = 10,
            trigger = triggerAreaClearDeathless(6)
        )

        achievement(
            id = 11348,
            title = "Creature from Outer Space",
            description = "Clear Area 7 without dying in single player mode",
            points = 25,
            trigger = triggerAreaClearDeathless(7)
        )

        achievement(
            id = 11349,
            title = "Deathbed",
            description = "Clear Area 8 without dying in single player mode",
            points = 25,
            trigger = triggerAreaClearDeathless(8)
        )
    // #endregion Deathless Area Clear Achievements

    // #region Area 1 Challanges
        achievement(
            id = 50936,
            title = "Gun Hurdling Champion",
            description = "Reach the fourth upward slope in Area 1 without killing green soldiers or destroying turrets",
            points = 10,
            trigger = triggerArea1GreenSoldiersChallange()
        )

        achievement(
            id = 51067,
            title = "Anti-Aerial Attack",
            description = "[1P Only] Defeat the Area 1 boss without jumping and without using the extra lives code",
            points = 5,
            trigger = triggerArea1BossChallange()
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
            title = "None Shall Pass",
            description = "Don't let any of the running enemies for Area 8 get from one side of the screen to the other.",
            points = 10,
            trigger = triggerArea8RunningEnemies()
        )
    // #endregion Area 8 Challanges
// #endregion Achievements