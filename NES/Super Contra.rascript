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

    function gamePaused() => byte(0x0039)


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
    function player1ShootButton() => bit6(0x00f7)
    function player2ShootButton() => bit6(0x00f8)
    function player1JumpButton() => bit7(0x00f7)
    function player1RightButton() => bit0(0x00f7)
    function player1BackButton() => bit2(0x00f7)
    function player2BackButton() => bit2(0x00f8)
    function player1Lives() => byte(0x0053)
    function player1PositionX() => byte(0x054c)
    function player2PositionX() => byte(0x054d)
    function player1PositionY() => byte(0x0532)
    function player1InvincibilityFrames() => byte(0x00c4)
    function player2InvincibilityFrames() => byte(0x00c5)
    function player1State() => byte(0x00a0)
    function player2State() => byte(0x00a1)
    PLAYERSTATE_NORMAL = 0x02
    PLAYERSTATE_DEATH_ANIMATION_START = 0x03
    PLAYERSTATE_DEATH_ANIMATION_END = 0x04
    PLAYERSTATE_DEAD = 0x05

    function cheatExtraLives() => byte(0x07ec)

    function objectType(index) => byte(0x06d8 + index)
    function objectState(index) => byte(0x0668 + index)
    function objectHealth(index) => byte(0x0676 + index)
    function objectXPosition(index) => byte(0x053c + index)
// #endregion Memory Addresses

// #region Frames
    function framePlayer1Died() {
        return
            prev(player1State()) == PLAYERSTATE_NORMAL
            && player1State() == PLAYERSTATE_DEATH_ANIMATION_START
    }

    function framePlayer2Died() {
        return
            prev(player2State()) == PLAYERSTATE_NORMAL
            && player2State() == PLAYERSTATE_DEATH_ANIMATION_START
    }

    function frameAreaCompleted() {
        return
            gameState() == GAMESTATE_ACTIVEPLAY
            && prev(gameScreen()) == SCREEN_GAMEPLAY
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
                && frameAreaStarted()
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
            prev(currentAreaHorizontalPosition()) < 0x0b00 // 0x0b00 ~ Fourth Upward Slope Start
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

        pauseConditions =
            unless( gamePaused() == TRUE )

        return 
            cancelConditions 
            && startCondition
            && trigger_when(triggerCondition)
            && pauseConditions
    }

    function triggerArea2NoBackButton() {
        startConditions = 
            once(
                currentArea() == 2
                && frameAreaStarted()
            )

        cancelConditions =
            never( gameState() != GAMESTATE_ACTIVEPLAY )
            && never( currentArea() != 2 )
            && never( player1BackButton() == TRUE )
            && never( player2BackButton() == TRUE )

        targetConditions =
            frameAreaCompleted()

        pauseConditions =
            unless( gamePaused() == TRUE )

        return
            startConditions
            && cancelConditions
            && trigger_when(targetConditions)
            && pauseConditions
    }

    function triggerArea2BossChallenge() {
        cancelConditions =
            never( gameState() != GAMESTATE_ACTIVEPLAY  )
            && never( currentArea() != 2 )
            && never( cheatExtraLives() == TRUE )
            && never(
                // Red Gunner Died:
                any_of(range(0, 13), index =>
                    // NOTE: Use previous frame state for red gunner death check.
                    // This avoids false challenge failure caused by the shared 
                    // death effect between red and green gunners.
                    prev(objectType(index)) == 0x6a // 0x6a ~ Red Gunner
                    && prev(objectState(index)) == 0x04 // 0x04 ~ Died
                )
            )

        primingAndTargetCondition = 
            // NOTE: Grouped priming and target conditions to prevent
            // unnecessary Alt Groups.
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

        return
            cancelConditions
            && primingAndTargetCondition
    }

    function triggerArea3WaterChallenge() {
        startConditions =
            once(
                prev(currentAreaHorizontalPosition()) < 0x080c - 0x04 // 0x080c ~ First Puddle Start
                && currentAreaHorizontalPosition() >= 0x080c - 0x04 // 0x080c ~ First Puddle Start
            )

        cancelConditions = 
            never( gameState() != GAMESTATE_ACTIVEPLAY  )
            && never( currentArea() != 3 )
            && never( numberOfPlayers() == 2 )
            && never( player1ShootButton() == TRUE )
            && never( framePlayer1Died() )

        triggerConditions =
            prev(currentAreaHorizontalPosition()) <= 0x0c00 + 0x04 // 0x0c00 ~ Last Puddle End
            && currentAreaHorizontalPosition() > 0x0c00  + 0x04 // 0x0c00 ~ Last Puddle End

        pauseConditions = 
            unless( gamePaused() == TRUE )

        return
            startConditions
            && cancelConditions
            && trigger_when(triggerConditions)
            && pauseConditions
    }

    function triggerArea3SpiderWalk() {
        cancelConditions =
            never( gameState() != GAMESTATE_ACTIVEPLAY  )
            && never( currentArea() != 3 )
            && never( numberOfPlayers() == 2 )
            && never( currentAreaSection() != 0x0e ) // 0x0e ~ Spider Room
            && never( player1PositionY() > 0x74 ) // 0x74 ~ When on Spider
        
        walkingFromLeftConditions =
            once(
                player1PositionX() <= 0x20 // 0x20 ~ Left Side of Screen
            )
            && 
            trigger_when (
                prev(player1PositionX()) < 0xe0 // 0xe0 ~ Right Side of Screen
                && player1PositionX() >= 0xe0 // 0xe0 ~ Right Side of Screen
            )

        walkingFromRighConditions =
            once(
                player1PositionX() >= 0xe0 // 0xe0 ~ Right Side of Screen
            )
            && 
            trigger_when (
                prev(player1PositionX()) > 0x20 // 0x20 ~ Left Side of Screen
                && player1PositionX() <= 0x20 // 0x20 ~ Left Side of Screen
            )
        return
            cancelConditions
            && ( walkingFromLeftConditions || walkingFromRighConditions )
    }

    function triggerArea3EarthquakeDrill() {
        primingConditions =
            once(
                prev(currentAreaHorizontalPosition()) < 0x0f18 // 0x0f18 ~ Earthquake Start
                && currentAreaHorizontalPosition() >= 0x0f18 // 0x0f18 ~ Earthquake Start
            )
        
        cancelConditions =
            never( gameState() != GAMESTATE_ACTIVEPLAY  )
            && never( currentArea() != 3 )
            && never( numberOfPlayers() == 2 )
            && never( 
                currentAreaHorizontalPosition() >= 0x1000 // 0x1000 ~ Earthquake Zone Start
                && player1RightButton() != TRUE
            )

        targetConditions =
            prev(currentAreaHorizontalPosition()) < 0x1318   // 0x1318  ~ Earthquake Zone End
            && currentAreaHorizontalPosition() >= 0x1318  // 0x1318  ~ Earthquake Zone End

        pauseConditions =
            unless( gamePaused() == TRUE )

        return
            primingConditions
            && cancelConditions
            && trigger_when(primingConditions && targetConditions)
            && pauseConditions
    }

    function triggerArea3BossChallenge() {
        primingConditions =
            tally_of(range(0, 13), 4, index =>
                prev(objectType(index)) != 0x50 // 0x50 ~ Boss Turret
                && objectType(index) == 0x50 // 0x50 ~ Boss Turret
            )

        cancelConditions =
            never( gameState() != GAMESTATE_ACTIVEPLAY  )
            && never( currentArea() != 3 )
            && never( cheatExtraLives() == TRUE )
            && never(
                // Main Boss Target Health Decreased
                any_of(range(0, 13), index => 
                    objectType(index) == 0x4b // 0x4b ~ Boss Main Target
                    && prev(objectHealth(index)) == 0x28 // 0x28 ~ Full Health
                    && objectHealth(index) < 0x28 // 0x28 ~ Full Health
                )
            )

        targetConditions =
            none_of(range(0, 13), index => 
                objectType(index) == 0x50 // 0x50 ~ Boss Turret
            )

        return
            primingConditions
            && cancelConditions
            && trigger_when(targetConditions)
    }

    function triggerArea4RightSideAscend() {
        startConditions =
            once(
                prev(currentAreaVerticalPosition()) == 0x0c00
                && currentAreaVerticalPosition() < 0x0c00
            )

        cancelConditions =
               never( gameState() != GAMESTATE_ACTIVEPLAY  )
            && never( currentArea() != 4 )

        triggerConditions =
            prev(currentAreaVerticalPosition()) != 0x001a
            && currentAreaVerticalPosition() == 0x001a

        Player1OnTheLeft =
            player1InvincibilityFrames() == 0
            && player1State() == 0x02
            && (currentAreaVerticalPosition() < 0x0500 || currentAreaVerticalPosition() > 0x050e)
            && player1PositionX() < (0xff / 2)

        Player2OnTheLeft =
            player2InvincibilityFrames() == 0
            && player2State() == 0x02
            && (currentAreaVerticalPosition() < 0x0500 || currentAreaVerticalPosition() > 0x050e)
            && player2PositionX() < (0xff / 2)

        return 
            startConditions
            && cancelConditions
            && never(Player1OnTheLeft)
            && never(Player2OnTheLeft)
            && trigger_when(triggerConditions)
    }

    function triggerArea5UphillChallenge() {
        primingCondition =
            once(
                currentArea() == 5
                && frameAreaStarted()
            )

        cancelConditions =
            never( gameState() != GAMESTATE_ACTIVEPLAY )
            && never( currentArea() != 5 )

        runningSoldierKilled =
            any_of(range(0, 13), index =>
                (
                    objectType(index) == 0x03 // 0x03 ~ Running Soldier
                    && objectState(index) == 0x05 // 0x05 ~ Death Animation Start
                )
            )

        grassTurretDestroyed =
            any_of(range(0, 13), index =>
                objectType(index) == 0x0b // 0x0b ~ Area 5 Turret on Grass 
                && objectState(index) == 0x07 // 0x07 ~ Death Animation Start
            )

        rockTurretDestroyed =
            any_of(range(0, 13), index =>
                objectType(index) == 0x0a // 0x0b ~ Area 5 Turret on Rock 
                && objectState(index) == 0x07 // 0x07 ~ Death Animation Start
            )
        
        targetConditions =
            once(
                prev(currentAreaVerticalPosition()) > 0x0006 // 0x0006 ~ Top of the Hill
                && currentAreaVerticalPosition() <= 0x0006 // 0x0006 ~ Top of the Hill
            ) 
            && once(
                prev(currentAreaHorizontalPosition()) < 0x0118 // 0x0118 ~ Start of Green Containers
                && currentAreaHorizontalPosition() >= 0x0118 // 0x0118 ~ Start of Green Containers
            )

        return 
            primingCondition
            && cancelConditions
            && never(runningSoldierKilled)
            && never(grassTurretDestroyed)
            && never(rockTurretDestroyed)
            && trigger_when(targetConditions)
    }

    function triggerArea5DownhillChallenge() {
        primingConditions = 
            once(
                prev(currentAreaVerticalPosition()) > 0x0006 // 0x0006 ~ Top of the Hill
                && currentAreaVerticalPosition() <= 0x0006 // 0x0006 ~ Top of the Hill
            ) 
            && once(
                prev(currentAreaHorizontalPosition()) < 0x0118 // 0x0118 ~ Start of Green Containers
                && currentAreaHorizontalPosition() >= 0x0118 // 0x0118 ~ Start of Green Containers
            )
        
        cancelConditions =
            never( gameState() != GAMESTATE_ACTIVEPLAY )
            && never( currentArea() != 5 )
            && never( player1ShootButton() == TRUE )
            && never( player2ShootButton() == TRUE )
            && never( framePlayer1Died() )
            && never( framePlayer2Died() )


        targetConditions =
            once(
                prev(currentAreaVerticalPosition()) < 0x0118 // 0x0118 ~ Boss Room
                && currentAreaVerticalPosition() >= 0x0118 // 0x0118 ~ Boss Room
            )
            && once(
                prev(currentAreaHorizontalPosition()) < 0x0700// 0x0700 ~ Boss Room
                && currentAreaHorizontalPosition() >= 0x0700 // 0x0700 ~ Boss Room
            )

        pauseConditions = 
            unless( gamePaused() == TRUE )

        return
            primingConditions
            && cancelConditions
            && trigger_when(targetConditions)
            && pauseConditions
    }

    function triggerArea4BossChallenge() {
        primingCondition = 
            // A total of 9 (out of 9) Boss Cannons spawned
            tally_of(range(0, 13), 9, index =>
                prev(objectType(index)) != 0x43 // 0x43 ~ Boss Cannon
                && objectType(index) == 0x43 // 0x43 ~ Boss Cannon
            )

        cancelConditions =
            never( gameState() != GAMESTATE_ACTIVEPLAY  )
            && never( currentArea() != 4 )
            && never( cheatExtraLives() == TRUE )

        targetConditions =
            // A total of 7 (out of 9) Boss Cannons died
            tally_of(range(0, 13), 7, index =>
                objectType(index) == 0x43 // 0x43 ~ Boss Cannon
                && prev(objectState(index)) != 0x07 // 0x07 ~ Death Animation Start
                && objectState(index) == 0x07 // 0x07 ~ Death Animation Start
            )

        leftTurretDeath = 
            any_of(range(0, 13), index => 
                // If a Boss Cannon died
                objectType(index) == 0x43 // 0x43 ~ Boss Cannon
                && prev(objectState(index)) != 0x07 // 0x07 ~ Death Animation Start
                && objectState(index) == 0x07 // 0x07 ~ Death Animation Start
                
                // And is the left most object on the screen
                && all_of(range(0, 13), index2 => 
                    objectXPosition(index) <= objectXPosition(index2)
                )
            )

        rightTurretDeath = 
            any_of(range(0, 13), index =>
                // If a Boss Cannon died
                objectType(index) == 0x43 // 0x43 ~ Boss Cannon
                && prev(objectState(index)) != 0x07 // 0x07 ~ Death Animation Start
                && objectState(index) == 0x07 // 0x07 ~ Death Animation Start

                // And is the right most object on the screen
                && all_of(range(0, 13), index2 => 
                    objectXPosition(index) >= objectXPosition(index2)
                )
            )

        return
            primingCondition
            && cancelConditions
            && trigger_when(targetConditions)
            && never(leftTurretDeath)
            && never(rightTurretDeath)
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
            title = "Gates of Fort Firestorm",
            description = "Clear Area 1",
            points = 5,
            trigger = triggerAreaClear(1),
            type = "progression"
        )

        achievement(
            id = 11332,
            title = "Warped Mind Command Center",
            description = "Clear Area 2, without using stage select",
            points = 5,
            trigger = triggerAreaClear(2),
            type = "progression"
        )

        achievement(
            id = 11333,
            title = "Tropics of Torture",
            description = "Clear Area 3, without using stage select",
            points = 5,
            trigger = triggerAreaClear(3),
            type = "progression"
        )

        achievement(
            id = 11334,
            title = "Lair of the Jungle Aliens",
            description = "Clear Area 4, without using stage select",
            points = 5,
            trigger = triggerAreaClear(4),
            type = "progression"
        )

        achievement(
            id = 11335,
            title = "Massacre Mountains",
            description = "Clear Area 5, without using stage select",
            points = 5,
            trigger = triggerAreaClear(5),
            type = "progression"
        )

        achievement(
            id = 11336,
            title = "Jagger Froid's Defense Line",
            description = "Clear Area 6, without using stage select",
            points = 5,
            trigger = triggerAreaClear(6),
            type = "progression"
        )

        achievement(
            id = 11337,
            title = "Radioactive Lava Fields",
            description = "Clear Area 7, without using stage select",
            points = 10,
            trigger = triggerAreaClear(7),
            type = "progression"
        )

        achievement(
            id = 11338,
            title = "Red Falcon's Poison Palace",
            description = "Clear Area 8 and beat the game, without using stage select",
            points = 10,
            trigger = triggerAreaClear(8),
            type = "win_condition"
        )
    // #endregion Area Clear Achievements

    // #region Deathless Area Clear Achievements
        achievement(
            id = 11342,
            title = "Perfect Infiltration",
            description = "Clear Area 1 without dying in single player mode",
            points = 10,
            trigger = triggerAreaClearDeathless(1)
        )

        achievement(
            id = 11343,
            title = "Command Center Immunity Protocol",
            description = "Clear Area 2 without dying in single player mode",
            points = 10,
            trigger = triggerAreaClearDeathless(2)
        )

        achievement(
            id = 11344,
            title = "Jungle Torture Survivor",
            description = "Clear Area 3 without dying in single player mode",
            points = 10,
            trigger = triggerAreaClearDeathless(3)
        )

        achievement(
            id = 11345,
            title = "Lair Purge Specialist",
            description = "Clear Area 4 without dying in single player mode",
            points = 10,
            trigger = triggerAreaClearDeathless(4)
        )

        achievement(
            id = 11346,
            title = "Expert Mountaineer",
            description = "Clear Area 5 without dying in single player mode",
            points = 10,
            trigger = triggerAreaClearDeathless(5)
        )

        achievement(
            id = 11347,
            title = "Unscratched Shock Trooper",
            description = "Clear Area 6 without dying in single player mode",
            points = 10,
            trigger = triggerAreaClearDeathless(6)
        )

        achievement(
            id = 11348,
            title = "Certified Hazmat Operative",
            description = "Clear Area 7 without dying in single player mode",
            points = 25,
            trigger = triggerAreaClearDeathless(7)
        )

        achievement(
            id = 11349,
            title = "Pure Lethal Antidote",
            description = "Clear Area 8 without dying in single player mode",
            points = 25,
            trigger = triggerAreaClearDeathless(8)
        )
    // #endregion Deathless Area Clear Achievements

    // #region Area 1 Challanges
        achievement(
            id = 50936,
            title = "Gun Hurdling Champion", // Alternative : Target Discrimination Directive / Selective Fire Protocol
            description = "Reach the fourth upward slope in Area 1 without killing green soldiers or destroying turrets",
            points = 10,
            trigger = triggerArea1GreenSoldiersChallange()
        )

        achievement(
            id = 51067,
            title = "Grounded AA Specialist",
            description = "Defeat the Area 1 boss in single player mode without jumping or using the extra lives code",
            points = 5,
            trigger = triggerArea1BossChallange()
        )
    // #endregion Area 1 Challanges

    // #region Area 2 Challenges
        achievement(
            id = 50937,
            title = "Tough Guys Don't Look Back", // No Retreat Protocol, Relentless Advance
            description = "Clear Area 2 without going backwards or using the extra lives code",
            points = 10,
            trigger = triggerArea2NoBackButton()
        )

        achievement(
            id = 50860,
            title = "Chain of Command Execution",
            description = "Defeat the Area 2 boss without killing either red soldier or using the extra lives code",
            points = 10,
            trigger = triggerArea2BossChallenge()
        )
    // #endregion Area 2 Challenges

    // #region Area 3 Challenges
        achievement(
            id = 50857,
            title = "Marshland Ghost",
            description = "Cross the swamp section in Area 3 in single player mode without shooting or dying",
            points = 5,
            trigger = triggerArea3WaterChallenge()
        )

        achievement(
            id = 50858,
            title = "Spider Wrangler",
            description = "Ride from one side of the screen to the other on top of the Area 3 miniboss in single player mode",
            points = 3,
            trigger = triggerArea3SpiderWalk()
        )

        achievement(
            id = 50859,
            title = "Earthquake Drill", // Fault Line Runner
            description = "Cross the Area 3 earthquake section in single player mode while holding right the entire time",
            points = 5,
            trigger = triggerArea3EarthquakeDrill()
        )

        achievement(
            id = 50864,
            title = "Sensor Core Isolation",
            description = "Destroy all 4 turrets of the Area 3 boss without damaging its core and without using the extra lives code",
            points = 10,
            trigger = triggerArea3BossChallenge()
        )
    // #endregion Area 3 Challenges

    // #region Area 4 Challenges
        achievement(
            title = "The Right Way Up",
            description = "Ascend Area 4 on the right half of the screen with exceptions allowed for the second elevator access platform or during knockback and invulnerability. Extra lives code not allowed",
            points = 10,
            trigger = triggerArea4RightSideAscend()
        )

        // DISABLED TO SPEED UP RATOOLS, ENABLE ON CHANGES !
        /*
        achievement(
            id = 50866,
            title = "Armed to the Teeth", // Central Void Execution
            description = "Eliminate all but the two outermost laser cannons on the Area 4 boss without using the extra lives code",
            points = 10,
            trigger = triggerArea4BossChallenge()
        )
        */
    // #endregion Area 4 Challenges

    // #region Area 5 Challenges
        achievement(
            title = "Peak Trigger Discipline",
            description = "Reach the top of the Area 5 cliff without eliminating any turrets or running soldiers and without using the extra lives code",
            points = 10,
            trigger = triggerArea5UphillChallenge()
        )

        achievement(
            id = 51077,
            title = "Come On Down, Everybody!",
            description = "From the top of the Area 5 cliff, reach the boss without firing or dying",
            points = 5,
            trigger = triggerArea5DownhillChallenge()
        )
    // #endregion Area 5 Chellenges
 
    // #region Area 7 Challenges
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
    // #endregion Area 7 Challenges

    // #region Area 8 Challenges
        achievement(
            title = "None Shall Pass",
            description = "Don't let any of the running enemies for Area 8 get from one side of the screen to the other.",
            points = 10,
            trigger = triggerArea8RunningEnemies()
        )
    // #endregion Area 8 Challenges
// #endregion Achievements