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
    GAMESTATE_SOUND_MODE = 0x05

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
    function gameBeatenOnce() => byte(0x0051)


    function currentArea() => byte(0x0050) + 1
    function currentAreaSection() => byte(0x0016)
    function currentAreaHorizontalPosition() => word(0x0064)
    function currentAreaVerticalPosition() => word(0x0073)
    function numberOfPlayers() => byte(0x0022) + 1
    function activePlayers() => byte(0x0096)
    ACTIVE_PLAYER1 = 0x00
    ACTIVE_PLAYER2 = 0x01
    ACTIVE_BOTH = 0x02

    function player1Score() => byte(0x1)
    function player2Score() => byte(0x1)
    function player1Weapon() => low4(0x00b8)
    function player2Weapon() => low4(0x00b9)
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
    function player1Lives() => byte(0x0053) + 1
    function player2Lives() => byte(0x0054) + 1
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
    function player1Score() => bcd(byte(0x07e3)) * 10 + bcd(byte(0x07e4)) * 1000 + bcd(byte(0x07e5)) * 100000

    function cheatExtraLives() => byte(0x07ec)

    function objectType(index) => byte(0x06d8 + index)
    function objectState(index) => byte(0x0668 + index)
    function objectHealth(index) => byte(0x0676 + index)
    function objectXPosition(index) => byte(0x053c + index)
    function objectFlag0(index) => bit0(0x071e + index)
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
        primingConditions =
            once(
                currentArea() == 1
                && frameAreaStarted()
            )

        cancelConditions =
            never( gameState() != GAMESTATE_ACTIVEPLAY )
            && never( gameScreen() == SCREEN_GAME_OVER )
            && never( cheatExtraLives() == TRUE )
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
            primingConditions
            && cancelConditions
            && never(greenSoldierKilledCondition)
            && never(turretDestroyedCondition)
            && trigger_when(targetConditions)
    }

    function triggerArea1BossChallange() {
        cancelConditions =
            never( gameState() != GAMESTATE_ACTIVEPLAY  )
            && never( gameScreen() == SCREEN_GAME_OVER )
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
            && never( gameScreen() == SCREEN_GAME_OVER )
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
            && never( gameScreen() == SCREEN_GAME_OVER )
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
            && never( gameScreen() == SCREEN_GAME_OVER )
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
            && never( gameScreen() == SCREEN_GAME_OVER )
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
            && never( gameScreen() == SCREEN_GAME_OVER )
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
            && never( gameScreen() == SCREEN_GAME_OVER )
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
            && never( gameScreen() == SCREEN_GAME_OVER )
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

    function triggerArea4BossChallenge() {
        primingCondition = 
            once(
                prev(currentAreaVerticalPosition()) > 0x001a
                && currentAreaVerticalPosition() == 0x0001a
            )

        cancelConditions =
            never( gameState() != GAMESTATE_ACTIVEPLAY  )
            && never( gameScreen() == SCREEN_GAME_OVER )
            && never( currentArea() != 4 )
            && never( cheatExtraLives() == TRUE )

        targetConditions =
            // A total of 7 (out of 9) Boss Cannons died
            tally_of(range(0, 13), 7, index =>
                objectType(index) == 0x43 // 0x43 ~ Boss Cannon
                && prev(objectState(index)) != 0x07 // 0x07 ~ Death Animation Start
                && objectState(index) == 0x07 // 0x07 ~ Death Animation Start
            )

        outermostTurretDied =
            // Turret Died & First Object in the List (index 0)
            (
                objectType(0) == 0x43 // 0x43 ~ Boss Cannon
                && prev(objectState(0)) != 0x07 // 0x07 ~ Death Animation Start
                && objectState(0) == 0x07 // 0x07 ~ Death Animation Start

            // Turret Died & First Turret in the List
            ) || any_of(range(1, 13), index =>
                objectType(index) == 0x43 // 0x43 ~ Boss Cannon
                && prev(objectState(index)) != 0x07 // 0x07 ~ Death Animation Start
                && objectState(index) == 0x07 // 0x07 ~ Death Animation Start

                // It's First Turret
                && none_of(range(0, index-1), index2 =>
                    objectType(index2) == 0x43
                )
            
            // Turret Died & Last Object in the List (index 13)
            || (
                objectType(13) == 0x43 // 0x43 ~ Boss Cannon
                && prev(objectState(13)) != 0x07 // 0x07 ~ Death Animation Start
                && objectState(13) == 0x07 // 0x07 ~ Death Animation Start
            )

            // Turret Died & Last Turret in the List
            ) || any_of(range(1, 12), index =>
                objectType(index) == 0x43 // 0x43 ~ Boss Cannon
                && prev(objectState(index)) != 0x07 // 0x07 ~ Death Animation Start
                && objectState(index) == 0x07 // 0x07 ~ Death Animation Start

                // It Last Turret
                && none_of(range(index+1, 13), index2 =>
                    objectType(index2) == 0x43
                )
            )

        return
            primingCondition
            && cancelConditions
            && never(outermostTurretDied)
            && trigger_when(targetConditions)
    }

    function triggerArea5UphillChallenge() {
        primingCondition =
            once(
                currentArea() == 5
                && frameAreaStarted()
            )

        cancelConditions =
            never( gameState() != GAMESTATE_ACTIVEPLAY )
            && never( gameScreen() == SCREEN_GAME_OVER )
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
            && never( gameScreen() == SCREEN_GAME_OVER )
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

    function triggerArea5BossChallenge() {
        primingConditions = 
            once(
                prev(currentAreaVerticalPosition()) < 0x0118 // 0x0118 ~ Boss Room
                && currentAreaVerticalPosition() >= 0x0118 // 0x0118 ~ Boss Room
            )
            && once(
                prev(currentAreaHorizontalPosition()) < 0x0700// 0x0700 ~ Boss Room
                && currentAreaHorizontalPosition() >= 0x0700 // 0x0700 ~ Boss Room
            )

        cancelConditions =
            never( gameState() != GAMESTATE_ACTIVEPLAY )
            && never( gameScreen() == SCREEN_GAME_OVER )
            && never( currentArea() != 5 )

        skullDied = 
            any_of(range(0, 13), index =>
                (
                    // NOTE: Use previous frame state for red skull death check.
                    // This avoids false challenge failure caused by the shared 
                    // death effect between skull and main boss.
                    prev(objectType(index)) == 0x5a // 0x5a ~ Skull
                    && prev(objectState(index)) == 0x05 // 0x05 ~ Death Animation Start
                )
            )

        bossDied = 
            any_of(range(0, 13), index =>
                (
                    objectType(index) == 0x59 // 0x59 ~ Boss
                    && objectState(index) == 0x07 // 0x07 ~ Death Animation Start
                )
            )

        return
            primingConditions
            && cancelConditions
            && never(skullDied)
            && trigger_when(bossDied)
    }

    function triggerArea6PacifistChallenge() {
        startConditions =
            once(
                currentArea() == 6
                && frameAreaStarted()
            )

        cancelConditions =
               never( gameState() != GAMESTATE_ACTIVEPLAY  )
            && never( gameScreen() == SCREEN_GAME_OVER )
            && never( currentArea() != 6 )
            && never( numberOfPlayers() != 1 )
            && never( framePlayer1Died() )

        enemiesKilled = 
            // Blue Spider Killed
            any_of(range(0, 13), index =>
                objectType(index) == 0x24 // 0x0b ~ BlueSpider
                && objectState(index) == 0x05 // 0x05 ~ Death Animation Start
            )
            
            // Ground Mouth Killed
            || any_of(range(0, 13), index =>
                objectType(index) == 0x5d // 0x5d ~ Mouth
                && objectState(index) == 0x05 // 0x05 ~ Death Animation Start
            )
            
            // Red Rotating Bug
            || any_of(range(0, 13), index =>
                objectType(index) == 0x5f // 0x5f ~ Red Rotating Bug
                && objectState(index) == 0x06 // 0x06 ~ Death Animation Start
            )

            // Spiky Red Bug
            || any_of(range(0, 13), index =>
                objectType(index) == 0x60 // 0x60 ~ Spiky Red Bug
                && objectState(index) == 0x06 // 0x06 ~ Death Animation Start
            )   

        pauseConditions =
            unless ( gamePaused() == TRUE )

        triggerConditions = 
            prev(currentAreaVerticalPosition()) > 0x0100 // 0x0100 ~ Boss Room
            && currentAreaVerticalPosition() <= 0x0100 // 0x0100 ~ Boss Room

        return
            startConditions
            && cancelConditions
            && never(enemiesKilled)
            && trigger_when(triggerConditions)
            && pauseConditions
    }

    function triggerArea6BossChallenge() {
        primingConditions =
            tally_of(range(0, 13), 1, index =>
                objectType(index) == 0x65 // 0x65 ~ Boss Head 2nd Form
                && objectState(index) == 0x05 // 0x05 ~ Entering the Screen
            )

        cancelConditions =
            never( gameState() != GAMESTATE_ACTIVEPLAY  )
            && never( gameScreen() == SCREEN_GAME_OVER )
            && never( currentArea() != 6 )
            && never( cheatExtraLives() == TRUE )
            && never( player1ShootButton() == TRUE && player1Weapon() != WEAPON_STANDARD )
            && never( player2ShootButton() == TRUE && player2Weapon() != WEAPON_STANDARD )
        
        bossWasDamaged =
            any_of(range(0, 13), index =>
                objectType(index) == 0x65 // 0x65 ~ Boss Head 2nd Form
                && objectHealth(index) < 0x40 // 0x40 ~ Max Health of Boss
            )

        targetConditions =
            any_of(range(0, 13), index =>
                objectType(index) == 0x66 // 0x66 ~ Snake
                && prev(objectState(index)) != 0x04 // 0x04 ~ Death Sequence Started
                && objectState(index) == 0x04 // 0x04 ~ Death Sequence Started
            )

        return
            primingConditions
            && cancelConditions
            && never(bossWasDamaged)
            && trigger_when(targetConditions)
    }

    function triggerArea7RunnersChalleange() {
        startConditions = 
            once(
                currentArea() == 7
                && frameAreaStarted()
            )

        cancelConditions =
            never( gameState() != GAMESTATE_ACTIVEPLAY  )
            && never( gameScreen() == SCREEN_GAME_OVER )
            && never( currentArea() != 7 )
            && never( cheatExtraLives() == TRUE )

        runningSkeletonKilled = any_of(range(0, 13), index =>
            objectType(index) == 0x03 // 0x03 ~ Running Soldier
            && objectState(index) == 0x05 // 0x05 ~ Death Sequence Started
        )

        triggerConditions =
            prev(currentAreaVerticalPosition()) < 0x0810 // 0x0810 ~ Top of Egg Room
            && currentAreaVerticalPosition() >= 0x0810 // 0x0810 ~ Top of Egg Room
            // prev(currentAreaVerticalPosition()) < 0x0610 // 0x0610 ~ No Soldiers Beyond this Point
            // && currentAreaVerticalPosition() >= 0x0610 // 0x0610 ~ No Soldiers Beyond this Point

        return
            startConditions
            && cancelConditions
            && never(runningSkeletonKilled)
            && trigger_when(triggerConditions)
    }

    function trigerArea7CrawlersChallange() {
        startConditions = 
            once(
                prev(currentAreaVerticalPosition()) < 0x0810 // 0x0810 ~ Top of Egg Room
                && currentAreaVerticalPosition() >= 0x0810 // 0x0810 ~ Top of Egg Room
            )

        cancelConditions =
            never( gameState() != GAMESTATE_ACTIVEPLAY  )
            && never( gameScreen() == SCREEN_GAME_OVER )
            && never( currentArea() != 7 )
            && never( numberOfPlayers() == 2 )

        deathCrawlerCondition = 
            any_of( range(0, 13), index =>
                objectType(index) == 0x3e // 0x3e ~ Facehugger
                && objectState(index) == 0x04 // 0x04 ~ Death Sequence Start
            )

        triggerCondition =
            prev(currentAreaVerticalPosition()) < 0x0c02 // 0x0c02 ~ Top of Boss Room
            && currentAreaVerticalPosition() >= 0x0c02 // 0x0c02 ~ Top of Boss Room

        return
            startConditions
            && cancelConditions
            && never(deathCrawlerCondition)
            && trigger_when(triggerCondition) 
    }

    function triggerArea7BossChallenge() {
        cancelConditions =
               never( gameState() != GAMESTATE_ACTIVEPLAY )
            && never( gameScreen() == SCREEN_GAME_OVER )
            && never( currentArea() != 7 )
            && never( numberOfPlayers() != 1 )
            && never( player1ShootButton() == TRUE && player1Weapon() != WEAPON_STANDARD )
            && never( player1JumpButton() == TRUE )
            && never( framePlayer1Died() )

        bossSpawnedAndDied =
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

        pauseConditions = 
            unless ( gamePaused() == TRUE )

        return cancelConditions && bossSpawnedAndDied && pauseConditions
    }

    function triggerArea8RunningEnemies() {
        startConditions = once(
            currentArea() == 8
            && currentAreaSection() == 0x00 // 0x00 ~ Stage Start
        )

        cancelConditions =
               never( gameState() != GAMESTATE_ACTIVEPLAY  )
            && never( gameScreen() == SCREEN_GAME_OVER )
            && never( currentArea() != 8 )
            && never( cheatExtraLives() == TRUE )

        enemyEscapeOnRight =
            any_of(range(0, 13), index =>
                   objectType(index)  == 0x03 // 0x03 ~ Running Soldier
                && objectState(index) == 0x02 // 0x02 ~ Walking
                && objectFlag0(index) == 1 // 1 ~ Walking from Left to Right
                && prev(objectXPosition(index)) <  0xfe // 0xfe ~ Despawn Point Right Side of Screen
                && objectXPosition(index) >= 0xfe // 0xfe ~ Despawn Point Right Side of Screen
            )

        enemyEscapeOnLeft = 
            any_of(range(0, 13), index =>
                   objectType(index)  == 0x03 // 0x03 ~ Running Soldier
                && objectState(index) == 0x02 // 0x02 ~ Walking
                && objectFlag0(index) == 0 // 0 ~ Walking from Right to Left
                && prev(objectXPosition(index)) >  0x06 // 0x06 ~ Despawn Point of Left Side of Screen
                && objectXPosition(index) <= 0x06 // 0x06 ~ Despawn Point of Left Side of Screen
            )

        targetConditions = 
            prev(currentAreaSection()) == 0x0d // 0x0d ~ Pre-Boss Room
            && currentAreaSection() == 0x0e // 0x0e ~ Boss Room

        return
            startConditions 
            && cancelConditions 
            && never(enemyEscapeOnLeft)
            && never(enemyEscapeOnRight)
            && trigger_when(targetConditions)
    }

    function triggerArea8BossChallange() {
        cancelConditions =
            never( gameState() != GAMESTATE_ACTIVEPLAY )
            && never( gameScreen() == SCREEN_GAME_OVER )
            && never( currentArea() != 8 )
            && never( framePlayer1Died() )

        explodingProjectilesCondition =
            tally_of(range(0, 13), 30, index =>
                player1PositionY() <= 0x35 // 0x35 ~ Top of Boss
                && objectType(index) == 0x37 // 0x37 ~ Exploding Bullet
                && prev(objectState(index)) != 0x05 // 0x05 ~ Killed
                && objectState(index) == 0x05 // 0x05 ~ Killed
            )

        bossDied = any_of(range(0, 13), index => 
            objectType(index) == 0x6d // 0x6d ~ Boss Main Target
            && objectState(index) == 0x09 // 0x09 ~ Death Sequence Start 
        )

        return
            cancelConditions
            && measured(explodingProjectilesCondition)
            && trigger_when(bossDied)
    }

    function triggerLaserChallange() {
        requiredConditions =
            gameState() == GAMESTATE_ACTIVEPLAY
            && player1Weapon() == WEAPON_LASER
            && frameAreaCompleted()

        return requiredConditions
    }

    function triggerSpreadChallange() {
        requiredConditions =
            gameState() == GAMESTATE_ACTIVEPLAY
            && currentArea() == 1

        player1GotSpread =
            prev(player1Weapon()) != WEAPON_SPREADGUN 
            && player1Weapon() == WEAPON_SPREADGUN

        player2GotSpread = 
            prev(player2Weapon()) != WEAPON_SPREADGUN
            && player2Weapon() == WEAPON_SPREADGUN

        return 
            requiredConditions
            && ( player1GotSpread || player2GotSpread )
    }

    function triggerLoopOneNoCheat() {
        cancelConditions =
               never( gameState() != GAMESTATE_ACTIVEPLAY  )
            && never( cheatExtraLives() == TRUE )
        
        firstLoopCheckpoints =
               once( currentArea() == 1 && frameAreaCompleted() && gameBeatenOnce() == FALSE )
            && once( currentArea() == 2 && frameAreaCompleted() && gameBeatenOnce() == FALSE )
            && once( currentArea() == 3 && frameAreaCompleted() && gameBeatenOnce() == FALSE )
            && once( currentArea() == 4 && frameAreaCompleted() && gameBeatenOnce() == FALSE )
            && once( currentArea() == 5 && frameAreaCompleted() && gameBeatenOnce() == FALSE )
            && once( currentArea() == 6 && frameAreaCompleted() && gameBeatenOnce() == FALSE )
            && once( currentArea() == 7 && frameAreaCompleted() && gameBeatenOnce() == FALSE )
            && once( currentArea() == 8 && frameAreaCompleted() && gameBeatenOnce() == FALSE )

        return cancelConditions && firstLoopCheckpoints
    }

    function triggerLoopTwoNoCheat() {
        cancelConditions =
               never( gameState() != GAMESTATE_ACTIVEPLAY  )
            && never( cheatExtraLives() == TRUE )
        
        firstLoopCheckpoints =
               once( currentArea() == 1 && frameAreaCompleted() && gameBeatenOnce() == FALSE )
            && once( currentArea() == 2 && frameAreaCompleted() && gameBeatenOnce() == FALSE )
            && once( currentArea() == 3 && frameAreaCompleted() && gameBeatenOnce() == FALSE )
            && once( currentArea() == 4 && frameAreaCompleted() && gameBeatenOnce() == FALSE )
            && once( currentArea() == 5 && frameAreaCompleted() && gameBeatenOnce() == FALSE )
            && once( currentArea() == 6 && frameAreaCompleted() && gameBeatenOnce() == FALSE )
            && once( currentArea() == 7 && frameAreaCompleted() && gameBeatenOnce() == FALSE )
            && once( currentArea() == 8 && frameAreaCompleted() && gameBeatenOnce() == FALSE )

        secondLoopCheckpoints = 
               once( currentArea() == 1 && frameAreaCompleted() && gameBeatenOnce() == TRUE )
            && once( currentArea() == 2 && frameAreaCompleted() && gameBeatenOnce() == TRUE )
            && once( currentArea() == 3 && frameAreaCompleted() && gameBeatenOnce() == TRUE )
            && once( currentArea() == 4 && frameAreaCompleted() && gameBeatenOnce() == TRUE )
            && once( currentArea() == 5 && frameAreaCompleted() && gameBeatenOnce() == TRUE )
            && once( currentArea() == 6 && frameAreaCompleted() && gameBeatenOnce() == TRUE )
            && once( currentArea() == 7 && frameAreaCompleted() && gameBeatenOnce() == TRUE )
            && once( currentArea() == 8 && frameAreaCompleted() && gameBeatenOnce() == TRUE )

        return cancelConditions && firstLoopCheckpoints && secondLoopCheckpoints
    }

    function triggerGunlessAnyLoop() {
        startConditions =
            once( currentArea() == 1 && frameAreaStarted() )

        cancelConditions =
               never( gameState() != GAMESTATE_ACTIVEPLAY  )
            && never( cheatExtraLives() == TRUE )
            && never( numberOfPlayers() != 1 )
        
        areasCompleted =
               once( currentArea() == 1 && frameAreaCompleted() )
            && once( currentArea() == 2 && frameAreaCompleted() )
            && once( currentArea() == 3 && frameAreaCompleted() )
            && once( currentArea() == 4 && frameAreaCompleted() )
            && once( currentArea() == 5 && frameAreaCompleted() )
            && once( currentArea() == 6 && frameAreaCompleted() )
            && once( currentArea() == 7 && frameAreaCompleted() )
            && once( currentArea() == 8 && frameAreaCompleted() )

        upgradedWeaponUsed = 
            player1Weapon() != WEAPON_STANDARD
            && player1ShootButton() == TRUE
            && gamePaused() == FALSE

        return
            startConditions
            && cancelConditions
            && never( upgradedWeaponUsed )
            && trigger_when( areasCompleted )
    }

    function triggerExtraLivesCode() {
        return
            gameScreen() == SCREEN_MAIN_MENU
            && prev(cheatExtraLives()) == FALSE
            && cheatExtraLives() == TRUE
    }

    function triggerSoundMenuCode() {
        return
            gameScreen() == SCREEN_MAIN_MENU
            && prev(gameState()) != GAMESTATE_SOUND_MODE
            && gameState() == GAMESTATE_SOUND_MODE
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

        achievement(
            id = 50866,
            title = "Armed to the Teeth", // Central Void Execution
            description = "Eliminate all but the two outermost laser cannons on the Area 4 boss without using the extra lives code",
            points = 10,
            trigger = triggerArea4BossChallenge()
        )
        
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

        achievement(
            title = "To Hit or Not to Hit",
            description = "Beat the Area 5 boss without damaging any of the skulls and without using the extra lives code",
            points = 10,
            trigger = triggerArea5BossChallenge()
        )
    // #endregion Area 5 Challenges
 
    // #region Area 6 Challenges
        achievement(
            title = "The Shield of Compassion",
            description = "Reach the Area 6 boss without eliminating any enemies or dying in single player mode",
            points = 10,
            trigger = triggerArea6PacifistChallenge()
        )

        achievement(
            title = "Save the Beast for Last",
            description = "Using the default gun, destroy the snake on the second form of the Area 6 boss without hitting the boss itself or using the extra lives code",
            points = 10,
            trigger = triggerArea6BossChallenge()
        )
    // #endregion Area 6 Challenges

    // #region Area 7 Challenges
        achievement(
            title = "Egg Room Escort",
            description = "Reach the egg room in Area 7 without killing any running soldiers or using the extra lives code",
            points = 5,
            trigger = triggerArea7RunnersChalleange()
        )

        achievement(
            id = 51121,
            title = "Save the Face-Huggers!",
            description = "Reach the Area 7 boss without killing any hatchlings or using the extra lives code",
            points = 5,
            trigger = trigerArea7CrawlersChallange()
        )

        achievement(
            id = 51123,
            title = "Rooted Rifleman",
            description = "Defeat the Area 7 boss using only the default gun without jumping, dying, or using the extra lives code in single player mode",
            points = 25,
            trigger = triggerArea7BossChallenge()   
        )
    // #endregion Area 7 Challenges

    // #region Area 8 Challenges
        achievement(
            title = "You Shall Not Pass",
            description = "Reach the boss in Area 8 without letting any running soldiers cross from one side of the screen to the other or using the extra lives code",
            points = 10,
            trigger = triggerArea8RunningEnemies()
        )

        achievement(
            title = "Grand Finale Fireworks",
            description = "Defeat the Area 8 boss in a single-player game after firing 30 projectiles in a single life while standing on its head",
            points = 5,
            trigger = triggerArea8BossChallange()
        )
    // #endregion Area 8 Challenges

    // #region Generic Challenges
        achievement(
            id = 50832,
            title = "Spread's Got Competition",
            description = "Defeat any boss using the Laser in one player mode",
            points = 10,
            trigger = triggerLaserChallange()
        )

        achievement(
            title = "It's a Secret to Everyone",
            description = "Acquire the Spread Gun in Area 1 without using the extra lives code",
            points = 3,
            trigger = triggerSpreadChallange()
        )

        achievement(
            id = 50933,
            title = "Super Ace Soldier",
            description = "Beat the game without using the extra lives code",
            points = 25,
            trigger = triggerLoopOneNoCheat()
        )

        achievement(
            id = 50932,
            title = "Can't Get Enough",
            description = "Beat the second loop without using the extra lives code",
            points = 25,
            trigger = triggerLoopTwoNoCheat()
        )

        achievement(
            id = 50934,
            title = "Super Gunless",
            description = "Beat the game in one player mode using only the default weapon and no extra lives code",
            points = 25,
            trigger = triggerGunlessAnyLoop()
        )

        achievement(
            id = 11329,
            title = "Strength of a Legion",
            description = "Enter the extra lives code on the title screen",
            points = 1,
            trigger = triggerExtraLivesCode()
        )

        achievement(
            id = 11328,
            title = "Wartime Songs",
            description = "Access the Sound Mode",
            points = 1,
            trigger = triggerSoundMenuCode()
        )
    // #endregion Generic Challenges
// #endregion Achievements

// #region Leaderboards
    // Leaderboard : High Score
    leaderboard(
        id = 2249,
        title = "High Score One Credit",
        description = "Highest score until game over using 3 lives",
        format = "SCORE",
        start =
            gameState() == GAMESTATE_ACTIVEPLAY
            && cheatExtraLives() == FALSE
            && (prev(gameScreen()) == SCREEN_MAIN_MENU || prev(gameScreen()) == SCREEN_CONTINUE)
            && gameScreen() == SCREEN_AREA_INTRO,
        cancel =
            always_false(),
        submit = 
            prev(gameScreen()) == SCREEN_GAMEPLAY
            && gameScreen() == SCREEN_GAME_OVER_BOOT,
        value =
            player1Score()
    )

    // Leaderboard : High Score
    leaderboard(
        id = 2250,
        title = "High Score First Life",
        description = "Highest score achieved before first death",
        format = "SCORE",
        start =
            gameState() == GAMESTATE_ACTIVEPLAY
            && (prev(gameScreen()) == SCREEN_MAIN_MENU || prev(gameScreen()) == SCREEN_CONTINUE)
            && gameScreen() == SCREEN_AREA_INTRO,
        cancel =
            always_false(),
        submit = 
            framePlayer1Died(),
        value =
            player1Score()
    )

    // Leaderboard : Speedrun Area 1 to 8
    for areaNumber in range(1,8) {
        leaderboard(
            title = "Speedrun Area " + areaNumber,
            description = "Fastest time to clear Area " + areaNumber,
            format = "TIME",
            lower_is_better = true,
            start = 
                currentArea() == areaNumber
                && gameState() == GAMESTATE_ACTIVEPLAY
                && prev(gameScreen()) != SCREEN_AREA_INTRO
                && gameScreen() == SCREEN_AREA_INTRO,
            cancel = 
                gameScreen() == SCREEN_GAME_OVER,
            submit =
                prev(currentArea()) == areaNumber
                && prev(gameScreen()) == SCREEN_AREA_COMPLETE
                && currentArea() != areaNumber,
            value =
                measured(always_true())
        )
    }

    // Leaderboard : Speedrun Full Game
    leaderboard(
        title = "Speedrun Full Game",
        description = "Fastest time to finish the game on one credit",
        format = "TIME",
        lower_is_better = true,
        start =
            currentArea() == 1
            && gameState() == GAMESTATE_ACTIVEPLAY
            && prev(gameScreen()) != SCREEN_AREA_INTRO
            && gameScreen() == SCREEN_AREA_INTRO,
        cancel =
            gameScreen() == SCREEN_GAME_OVER
            || gameState() != GAMESTATE_ACTIVEPLAY
            ,
        submit =
            prev(currentArea()) == 8
            && prev(gameScreen()) == SCREEN_AREA_COMPLETE
            && currentArea() != 8,
        value =
            measured( always_true() )
    )
// #endregion Leaderboards

// #region Rich Presence
    weaponNameLookup = {
        WEAPON_STANDARD: "Default Gun",
        WEAPON_MACHINEGUN: "Machine Gun",
        WEAPON_FIREBALL: "Flame Thrower",
        WEAPON_SPREADGUN: "Spread Gun",
        WEAPON_LASER: "Laser"

    }

    loopLookup = {
        0x00: "",
        0x01: "²"
    }

    rich_presence_conditional_display(
        gameState() == GAMESTATE_ACTIVEPLAY && numberOfPlayers() == 1,
        "Area {0}{1} ● Single Player ● {2} and {3} Lives",
        rich_presence_value("Area", currentArea()),
        rich_presence_lookup("Loop", gameBeatenOnce(), loopLookup),
        rich_presence_lookup("Weapon", player1Weapon(), weaponNameLookup),
        rich_presence_value("Lives", player1Lives())
    )

    rich_presence_conditional_display(
        gameState() ==  GAMESTATE_ACTIVEPLAY && numberOfPlayers() == 2 && activePlayers() == ACTIVE_BOTH,
        "Area {0}{1} ● Co-Op Game ● {2} and {3} Lives ● {4} and {5} Lives",
        rich_presence_value("Area", currentArea()),
        rich_presence_lookup("Loop", gameBeatenOnce(), loopLookup),
        rich_presence_lookup("Weapon", player1Weapon(), weaponNameLookup),
        rich_presence_value("Lives", player1Lives()),
        rich_presence_lookup("Weapon", player2Weapon(), weaponNameLookup),
        rich_presence_value("Lives", player2Lives())
    )

    rich_presence_conditional_display(
        gameState() ==  GAMESTATE_ACTIVEPLAY && numberOfPlayers() == 2 && activePlayers() == ACTIVE_PLAYER1,
        "Area {0}{1} ● Co-Op Game ● {2} and {3} Lives ● Scorpion Died",
        rich_presence_lookup("Loop", gameBeatenOnce(), loopLookup),
        rich_presence_value("Area", currentArea()),
        rich_presence_lookup("Weapon", player1Weapon(), weaponNameLookup),
        rich_presence_value("Lives", player1Lives()),
        rich_presence_lookup("Weapon", player2Weapon(), weaponNameLookup),
        rich_presence_value("Lives", player2Lives())
    )

    rich_presence_conditional_display(
        gameState() ==  GAMESTATE_ACTIVEPLAY && numberOfPlayers() == 2 && activePlayers() == ACTIVE_PLAYER2,
        "Area {0}{1} ● Co-Op Game ● Mad Dog Died ● {4} and {5} Lives",
        rich_presence_value("Area", currentArea()),
        rich_presence_lookup("Loop", gameBeatenOnce(), loopLookup),
        rich_presence_lookup("Weapon", player1Weapon(), weaponNameLookup),
        rich_presence_value("Lives", player1Lives()),
        rich_presence_lookup("Weapon", player2Weapon(), weaponNameLookup),
        rich_presence_value("Lives", player2Lives())
    )

    rich_presence_display(
        "Preparing to fight Red Falcon"
    )
// #endregion Rich Presence