// Time Pilot
// #ID = 11902

// #region Memory Addresses
    // Adddress: Dip Switch Lives
    // Indicates the number of lives per player based on dip switch settings
    function dipSwitchLives() => byte(0x01c1)

    // Address: Dip Switch Difficulty
    // Indicates the game difficulty based on dip switch settings
    function dipSwitchDifficulty() => byte(0x01c4) + 1

    // Address: Game State
    // Inidicates whether the game is in demo mode or playing mode
    function attractMode() => byte(0x0530)
    ATTRACT_OFF = 0xff
    ATTRACT_ON = 0x00

    // Address: Gameplay State
    // Indicates the current gameplay state
    function gameState() => byte(0x01ac)
    STATE_NEW_LIFE_READY_MESSAGE = 0x05
    STATE_PRE_GAMEPLAY_TRANSITION = 0x06
    STATE_IN_GAMEPLAY = 0x07
    STATE_GAME_OVER = 0x08
    STATE_STAGE_COMPLETED = 0x0d
    STATE_NEXT_STAGE_STARTED = 0x0e


    // Address: Player 1 Score
    // Indicates the current score of player 1
    function player1Score() => bcd(tbyte(0x0533))

    // Address: Current Stage
    // Indicates the current stage the player is on
    function currentStage() => byte(0x0501)

    // Address: Current Player Lives
    // Indicates the number of lives the player has remaining
    function currentPlayerLives() => byte(0x0500)

    // Address: Current Age
    // Indicates the year the player is figthing in
    function currentAge() => byte(0x0504)
    AGE_1910 = 0x00
    AGE_1940 = 0x01
    AGE_1970 = 0x02
    AGE_1982 = 0x03
    AGE_2001 = 0x04

    // Address: Active Player
    // Indicates which player is currently active (1 or 2)
    function activePlayer() => byte(0x0532)
    ACTIVE_PLAYER_1 = 0x00
    ACTIVE_PLAYER_2 = 0x01

    // Address: Player Status
    // Indicates the current status of the player (on screen, got hit, not on screen)
    function playerStatus() => byte(0x0000)

    // Address: Queued Player Bullets
    // Indicates the number of bullets currently queued to be fired by the player
    function queuedPlayerBullets() => byte(0x0281)

    // Address: Parachute Status
    // Indicates the current status of the parachuting pilot
    function parachuteStatus() => byte(0x00f0)
    PARACHUTE_NOT_ON_SCREEN = 0x00
    PARACHUTE_ON_SCREEN = 0xff
    PARACHUTE_RESCUED = 0xf0

    // Address: Enemy Kills Remaining
    // Indicates the number of enemies remaining until the boss appears
    function enemyKillsRemaining() => byte(0x0502)

    // Address: Boss Spawned
    // Indicates whether the boss has spawned or not
    function bossSpawned() => byte(0x050d)
    BOSS_NOT_SPAWNED = 0x00
    BOSS_SPAWNED = 0xff

    // Address: Boss Status
    // Indicates the current status of the boss
    function bossStatus() => byte(0x00a0)
    OBJECT_ON_SCREEN = 0xff
    OBJECT_IS_HIT = 0xf0
    OBJECT_NOT_SPAWNED = 0x00

    // Address: Special Enemy Status
    // Indicates the current status of the special enemy
    function specialEnemyStatus() => byte(0x00c0)

    // Address: Credits
    // Indicates the number of credits currently available
    function credits() => byte(0x186)

    // Address: Enemy Formation Size
    // Indicates the number of enemies currently in the formation
    function enemyFormationSize() => byte(0x0011)

    // Address: Enemy Formation Timer
    // Indicates how long the current enemy formation is still active
    function enemyFormationTimer() => byte(0x0012)
// #endregion

// #region Frame Functions
    // Frame : Game Started
    // Happens on a new game is started
    function frameGameStarted() {
        return
            prev(attractMode() == ATTRACT_ON)
            && (attractMode() == ATTRACT_OFF)
    }

    // Frame : Player 1 Game Over
    // Happens when player 1 loses their last life
    function framePlayer1GameOver() {
        return
            activePlayer() == ACTIVE_PLAYER_1
            && prev(currentPlayerLives() > 0)
            && (currentPlayerLives() == 0)
    }

    // Frame : Player Got Hit
    // Happens when player gets hit and loses a life
    function framePlayerGotHit() {
        return
            prev(playerStatus() == OBJECT_ON_SCREEN)
            && (playerStatus() == OBJECT_IS_HIT)
    }

    // Frame : Player Fired Bullet
    // Happens when player fires a bullet
    function framePlayerFiredBullet() {
        return 
            prev(queuedPlayerBullets() == 0)
            && (queuedPlayerBullets() > 0)
            
    }

    // Frame : Parachute Rescued
    // Happens when a parachute is rescued
    function frameParachuteRescued() {
        return
            prev(parachuteStatus() == PARACHUTE_ON_SCREEN)
            && (parachuteStatus() == PARACHUTE_RESCUED)      
    }

    // Frame : Life Started
    // Happens when a new life starts
    function frameLifeStarted() {
        return
            prev(gameState() == STATE_NEW_LIFE_READY_MESSAGE)
            && (gameState() == STATE_PRE_GAMEPLAY_TRANSITION)
    }

    // Frame : Stage Completed
    // Happens when the current stage is completed
    function frameStageCompleted() {
        return
            enemyKillsRemaining() == 0
            && bossSpawned() == BOSS_SPAWNED
            && prev(bossStatus() == OBJECT_IS_HIT)
            && bossStatus() > 0x00 && bossStatus() < 0xf0
    }

    // Frame : Enemy Formation Killed
    // Happens when an entire enemy formation is destroyed
    function frameFormationKill() {
        return
            prev(enemyFormationSize() > 0)
            && enemyFormationSize() == 0
            && enemyFormationTimer() > 0
    }

    // Frame : Mid-Size Bomber Killed
    // Happens when a mid-size bomber from 1940 is destroyed
    function frameBomberKilled() {
        return
            currentAge() == AGE_1940
            && prev(specialEnemyStatus() == OBJECT_IS_HIT)
            && specialEnemyStatus() > 0x00 && specialEnemyStatus() < 0xf0

    }
// #endregion Frame Functions

// #region Achievement Triggers
    // Trigger: Age Completed
    // Triggers when the specified age is completed
    function triggerAgeCompleted(age) {
        return
            activePlayer() == ACTIVE_PLAYER_1
            && attractMode() == ATTRACT_OFF
            && dipSwitchDifficulty() == 4
            && dipSwitchLives() == 3
            && currentAge() == age
            && frameStageCompleted()
    }

    // Trigger: No Death Till Stage
    // Triggers when the player reaches the specified stage without losing a life
    function triggerNoDeathTillStage(stage) {
        // Required Conditions
        requiredConditions =
            activePlayer() == ACTIVE_PLAYER_1
            && attractMode() == ATTRACT_OFF
            && dipSwitchDifficulty() >= 4

        // Start Conditions
        startConditions =
            frameGameStarted()

        // Canclel Conditions
        cancelConditions =
            framePlayerGotHit()

        // Goal Conditions
        goalConditions =
            currentStage() == stage
            && prev(currentStage()) == stage-1

        return
            requiredConditions
            && once(startConditions)
            && trigger_when(goalConditions)
            && never(cancelConditions)
    }

    // Trigger: Rescue Mission
    // Triggers when the player rescues a specified number of parachutes in a single life
    // without shooting any bullets
    function triggerRescueMission(year, count) {
        primingConditions =
            dipSwitchLives() == 3
            && dipSwitchDifficulty() >= 4
            && never(activePlayer() != ACTIVE_PLAYER_1)
            && never(attractMode() != ATTRACT_OFF)
            && never(currentAge() != year)
            && never(framePlayerGotHit())
            && never(framePlayerFiredBullet())
            && once(frameLifeStarted())
            && disable_when(framePlayerFiredBullet(), until=frameLifeStarted())

        goalConditions =
            repeated(count, frameParachuteRescued() && never(framePlayerFiredBullet()))

        return 
            primingConditions
            && trigger_when(measured(goalConditions))
    }

    // Trigger: Formation Kills
    // Triggers when the player destroys an entire enemy formation a specified number of times
    function triggerForationKills(count) {
        requiredConditions =
            dipSwitchLives() == 3
            && dipSwitchDifficulty() >= 4
            && never(activePlayer() != ACTIVE_PLAYER_1)
            && never(attractMode() != ATTRACT_OFF)

        goalCondition =
            repeated(count, frameFormationKill())
        
        return
            requiredConditions
            && measured(goalCondition)
    }

    // Trigger: Bomber Kills
    // Triggers when the player destroys a specified number of mid-size bombers from 1940
    function triggerBomberKills(count) {
        requiredConditions =
            dipSwitchLives() == 3
            && dipSwitchDifficulty() >= 4
            && never(activePlayer() != ACTIVE_PLAYER_1)
            && never(attractMode() != ATTRACT_OFF)

        goalCondition =
            repeated(count, frameBomberKilled())
        
        return
            requiredConditions
            && measured(goalCondition)
    }
// #endregion Achievement Triggers

// #region Achievements
    // Achievement: Age of the Biplane
    achievement(
        title = "Age of the Biplane",
        description = "Complete the A.D. 1910 stage using the default settings.",
        points = 3,
        type = "progression",
        trigger = triggerAgeCompleted(AGE_1910)
    )

    // Achievement: Age of the Monoplane
    achievement(
        title = "Age of the Monoplane",
        description = "Complete the A.D. 1940 stage using the default settings.",
        points = 5,
        type = "progression",
        trigger = triggerAgeCompleted(AGE_1940)
    )

    // Achievement: Age of the Helicopter
    achievement(
        title = "Age of the Helicopter",
        description = "Complete the A.D. 1970 stage using the default settings.",
        points = 5,
        type = "progression",
        trigger = triggerAgeCompleted(AGE_1970)
    )

    // Achievement: Age of the Jet Plane
    achievement(
        title = "Age of the Jet Plane",
        description = "Complete the A.D. 1982 stage using the default settings.",
        points = 10,
        type = "progression",
        trigger = triggerAgeCompleted(AGE_1982)
    )

    // Achievement: Age of the UFO
    achievement(
        title = "Age of the UFO",
        description = "Complete the A.D. 2001 stage using the default settings.",
        points = 25,
        type = "win_condition",
        trigger = triggerAgeCompleted(AGE_2001)
    )

    // Achievement: Perfect First Flight
    achievement(
        title = "Perfect First Flight",
        description = "Reach 1940 without getting hit on default of higher difficulty.",
        points = 5,
        trigger = triggerNoDeathTillStage(2)
    )

    // Achievement: Immortal Pilot
    achievement(
        title = "Immortal Pilot",
        description = "Reach 2001 without getting hit on default of higher difficulty.",
        points = 25,
        trigger = triggerNoDeathTillStage(5)
    )

    // Achievement: Carnegie Hero Medal
    achievement(
        title = "Carnegie Hero Medal",
        description = "Rescue 5 parachutes from 1910 in a single life, without opening fire, on default or higher difficulty.",
        points = 10,
        trigger = triggerRescueMission(year = AGE_1910, count = 5)
    )

    // Achievement: Navy and Marine Corps Medal
    achievement(
        title = "Navy and Marine Corps Medal", // Savior of Dunkirk
        description = "Rescue 4 parachutes from 1940 in a single life, without opening fire, on default or higher difficulty.",
        points = 10,
        trigger = triggerRescueMission(year = AGE_1940, count = 4)
    )

    // Achievement: Silver Lifesaving Medal
    achievement(
        title = "Silver Lifesaving Medal", // Son Tay Savior
        description = "Rescue 3 parachutes from 1970 in a single life, without opening fire, on default or higher difficulty.",
        points = 10,
        trigger = triggerRescueMission(year = AGE_1970, count = 3)
    )

    // Achievement: Gold Lifesaving Medal
    achievement(
        title = "Gold Lifesaving Medal", // Falklands Rescue
        description = "Rescue 2 parachutes from 1982 in a single life, without opening fire, on default or higher difficulty.",
        points = 10,
        trigger = triggerRescueMission(year = AGE_1982, count = 2)
    )

    // Achievement: Squadon Sweap
    achievement(
        title = "Squadon Sweap",
        description = "Destroy an entire enemy formation 5 times in a single game, using the default settings.",
        points = 3,
        trigger = triggerForationKills(count = 5)
    )

    // Achievement: Bomber Barrage
    achievement(
        title = "Bomber Barrage",
        description = "Destroy five mid-size bombers from 1940 in one life, with difficulty set to 4 or higher.",
        points = 5,
        trigger = triggerBomberKills(count = 5)
    )
// endregion Achievements

// #region Leaderboards
    // Leaderboard Start : Hiscore
    // Start condition for the Hiscore leaderboards.
    function startHighscoreLeaderboard() {
        return
            frameGameStarted()
            && dipSwitchLives() == 3
            && dipSwitchDifficulty() == 4
        // return
        //     dipSwitchLives() == 3
        //     && (once(framePlayer1GameOver()))
        //     && never(attractMode() == ATTRACT_ON)
    }

    // Leaderboard Value : Hiscore
    // Value function for the Hiscore leaderboards.
    function valueHighscoreLeaderboard() {
      return player1Score()
    }

    // Leaderboard: Player 1 Score
    leaderboard(
        title = "Hiscore Arcade Mode",
        description = "Highest score using default settings",
        format = "SCORE",
        start = startHighscoreLeaderboard(),
        cancel = always_false(),
        submit = framePlayer1GameOver(),
        value = valueHighscoreLeaderboard()
    )
// #endregion Leaderboards

// #region Rich Presence
    // Rich Presence : When Game is Started
    rich_presence_conditional_display(
        attractMode() == ATTRACT_OFF,

        "Fighting {3} ( Stage: {0} | Lives: {1} | Score: {2} )",
        rich_presence_macro("Number", currentStage()),
        rich_presence_macro("Number", currentPlayerLives()),
        rich_presence_macro("Score", player1Score()),
        rich_presence_lookup("Age", currentAge(),
            {
                AGE_1910: "Biplanes in 1910 A.D.",
                AGE_1940: "Monoplanes in 1940 A.D.",
                AGE_1970: "Hilicopters in 1970 A.D.",
                AGE_1982: "Superjets in 1982 A.D.",
                AGE_2001: "Flying Saucers in 2001 A.D."
            }
        )
    )

    // Fighting monoplanes in 

    // Rich Presence : Default
    rich_presence_display(
        "In Attract Mode with {0} Credits.",
        rich_presence_macro("Number", credits())
    )
// #endregion Rich Presence