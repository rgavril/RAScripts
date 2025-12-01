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

    // Address: Type of Game
    // Indicates whether it's a one player or two player game
    function typeOfGame() => byte(0x531)
    TYPE_OF_GAME_1P = 0x00
    TYPE_OF_GAME_2P = 0xff

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
    function player1Score_XX0000() => byte(0x0535)

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
    function specialEnemy1Status() => byte(0x00c0)
    function specialEnemy2Status() => byte(0x00d0)
    function specialEnemy3Status() => byte(0x00e0)

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

    // Frame : Player 1 Score Overflowed
    // Happens when player 1's score overflows back to 0
    function framePlayer1ScoreOverflowed() {
        return
            attractMode() == ATTRACT_OFF
            && gameState() == STATE_IN_GAMEPLAY
            && prev(player1Score_XX0000()) == 0x99
            && (player1Score_XX0000() == 0x00)
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

    // Frame : Enemy Killed
    // Happens when a specified enemy is destroyed
    function frameEnemyKilled(enemyStatusAddress) {
        return
            // Object was hit
            prev(enemyStatusAddress == OBJECT_IS_HIT)
            // Object kill animation timer started
            && enemyStatusAddress > 0x00
            && enemyStatusAddress < 0xf0
    }

    // Frame : Score Went Over
    // Happens when the player's score goes over a specified value
    function frameScoreWentOver(score) {
        return
            prev(player1Score() < score)
            && player1Score() >= score
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

    // Trigger: Back to the Future
    // Triggers when the player reaches 2010 in the second loop using default settings
    function triggerBackToTheFuture() {
        // Required Conditions
        requiredConditions =
            activePlayer() == ACTIVE_PLAYER_1
            && attractMode() == ATTRACT_OFF
            && dipSwitchDifficulty() == 4
            && dipSwitchLives() == 3
            && prev(currentStage() == 9)
            && currentStage() == 10

        return requiredConditions
    }

    // Trigger: Rescue Mission
    // Triggers when the player rescues a specified number of parachutes in a single life
    // without shooting any bullets
    function triggerRescueMission(year, count) {
        primingConditions =
            dipSwitchDifficulty() >= 4
            && never(activePlayer() != ACTIVE_PLAYER_1)
            && never(attractMode() != ATTRACT_OFF)
            && never(currentAge() != year)
            && never(framePlayerGotHit())
            && never(framePlayerFiredBullet())
            && once(frameLifeStarted())
            && disable_when(framePlayerFiredBullet(), until=frameLifeStarted())

        goalConditions =
            repeated(count, frameParachuteRescued() && never(frameLifeStarted()))

        return 
            primingConditions
            && trigger_when(measured(goalConditions))
    }

    // Trigger: Formation Kills
    // Triggers when the player destroys an entire enemy formation a specified number of times in a single game
    function triggerForationKills(count, age) {
        requiredConditions =
            dipSwitchLives() == 3
            && dipSwitchDifficulty() >= 4
            && never(activePlayer() != ACTIVE_PLAYER_1)
            && never(attractMode() != ATTRACT_OFF)
            && never(framePlayer1GameOver())

        goalCondition =
            repeated(count, frameFormationKill() && currentAge() == age)
        
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
            && never(framePlayer1GameOver())

        goalCondition =
            repeated(5, currentAge() == AGE_1940 && frameEnemyKilled(specialEnemy1Status()))
        
        return
            requiredConditions
            && measured(goalCondition)
    }

    // Trigger: Missile Kills
    // Triggers when the player destroys a specified number of homing missiles
    function triggerMissileKills(count) {
        requiredConditions =
            dipSwitchLives() == 3
            && dipSwitchDifficulty() >= 4
            && never(activePlayer() != ACTIVE_PLAYER_1)
            && never(attractMode() != ATTRACT_OFF)
            && never(framePlayer1GameOver())

        goalCondition =
            tally(count,
                currentAge() == AGE_1970 && frameEnemyKilled(specialEnemy1Status()),
                currentAge() == AGE_1970 && frameEnemyKilled(specialEnemy2Status()),
                currentAge() == AGE_1970 && frameEnemyKilled(specialEnemy3Status()),

                currentAge() == AGE_1982 && frameEnemyKilled(specialEnemy1Status()),
                currentAge() == AGE_1982 && frameEnemyKilled(specialEnemy2Status()),
                currentAge() == AGE_1982 && frameEnemyKilled(specialEnemy3Status())
            )

        return
            requiredConditions
            && measured(goalCondition)
    }

    function triggerBombKills(count) {
        requiredConditions =
            dipSwitchLives() == 3
            && dipSwitchDifficulty() >= 4
            && never(activePlayer() != ACTIVE_PLAYER_1)
            && never(attractMode() != ATTRACT_OFF)
            && never(framePlayer1GameOver())

        goalCondition =
            tally(count,
                currentAge() == AGE_1910 && frameEnemyKilled(specialEnemy1Status()),
                currentAge() == AGE_1910 && frameEnemyKilled(specialEnemy2Status()),
                currentAge() == AGE_1910 && frameEnemyKilled(specialEnemy3Status())
            )

        return
            requiredConditions
            && measured(goalCondition)
    }
    // Trigger: Highscore
    // Triggers when the player reaches a specified score
    function triggerHighscore(score) {
        return
            activePlayer() == ACTIVE_PLAYER_1
            && attractMode() == ATTRACT_OFF
            && dipSwitchDifficulty() == 4
            && dipSwitchLives() == 3
            && frameScoreWentOver(score)
    }
// #endregion Achievement Triggers

// #region Achievements
    // Achievement: Age of the Biplane
    achievement(
        id = 540954,
        title = "Age of the Biplane",
        description = "Complete the A.D. 1910 stage on default settings.",
        points = 3,
        type = "progression",
        trigger = triggerAgeCompleted(AGE_1910)
    )

    // Achievement: Age of the Monoplane
    achievement(
        id = 540958,
        title = "Age of the Monoplane",
        description = "Complete the A.D. 1940 stage on default settings.",
        points = 3,
        type = "progression",
        trigger = triggerAgeCompleted(AGE_1940)
    )

    // Achievement: Age of the Helicopter
    achievement(
        id = 540957,
        title = "Age of the Helicopter",
        description = "Complete the A.D. 1970 stage on default settings.",
        points = 5,
        type = "progression",
        trigger = triggerAgeCompleted(AGE_1970)
    )

    // Achievement: Age of the Jet Plane
    achievement(
        id = 540956,
        title = "Age of the Jet Plane",
        description = "Complete the A.D. 1982 stage on default settings.",
        points = 10,
        type = "progression",
        trigger = triggerAgeCompleted(AGE_1982)
    )

    // Achievement: Age of the UFO
    achievement(
        id = 540955,
        title = "Age of the UFO",
        description = "Complete the A.D. 2001 stage on default settings.",
        points = 25,
        type = "win_condition",
        trigger = triggerAgeCompleted(AGE_2001)
    )

    // Achievement: Perfect First Flight
    achievement(
        id = 540994,
        title = "Perfect First Flight",
        //description = "Reach 1940 without getting hit on default or higher difficulty.",
        description = "Complete the first stage without getting hit on default or higher difficulty.",
        points = 5,
        trigger = triggerNoDeathTillStage(2)
    )

    // Achievement: Immortal Pilot
    achievement(
        id = 540995,
        title = "Immortal Pilot",
        // description = "Reach 2001 without getting hit on default or higher difficulty.",
        description = "Complete stages 1 to 4 without getting hit on default or higher difficulty.",
        points = 25,
        trigger = triggerNoDeathTillStage(5)
    )

    // Achievement: Back to the Future
    achievement(
        id = 542121,
        title = "Back to the... Flying Saucers",
        // description = "Reach 2001 in the second loop on default settings.",
        description = "Complete stages 1 to 9 on default settings.",
        points = 25,
        trigger = triggerBackToTheFuture()
    )

    // Achievement: Carnegie Hero Medal
    achievement(
        id = 541012,
        title = "Carnegie Hero Medal",
        description = "Rescue 3 parachutes from 1910 in a single life, without opening fire, on default or higher difficulty.",
        points = 3,
        trigger = triggerRescueMission(year = AGE_1910, count = 3)
    )

    // Achievement: Navy and Marine Corps Medal
    achievement(
        id = 541013,
        title = "Navy and Marine Corps Medal", // Savior of Dunkirk
        description = "Rescue 3 parachutes from 1940 in a single life, without opening fire, on default or higher difficulty.",
        points = 5,
        trigger = triggerRescueMission(year = AGE_1940, count = 3)
    )

    // Achievement: Silver Lifesaving Medal
    achievement(
        id = 541014,
        title = "Silver Lifesaving Medal", // Son Tay Savior
        description = "Rescue 3 parachutes from 1970 in a single life, without opening fire, on default or higher difficulty.",
        points = 10,
        trigger = triggerRescueMission(year = AGE_1970, count = 3)
    )

    // Achievement: Gold Lifesaving Medal
    achievement(
        id = 541015,
        title = "Gold Lifesaving Medal", // Falklands Rescue
        description = "Rescue 3 parachutes from 1982 in a single life, without opening fire, on default or higher difficulty.",
        points = 10,
        trigger = triggerRescueMission(year = AGE_1982, count = 3)
    )

    // Achievement: Biplane Formation Breaker
    achievement(
        id = 541536,
        title = "Biplane Formation Breaker",
        description = "Destroy 4 biplane formations from 1910 in a single game, on default settings.",
        points = 5,
        trigger = triggerForationKills(age=AGE_1910, count = 4)
    )

    // Achievement: Monoplane Squadron Crusher
    achievement(
        id = 542019,
        title = "Monoplane Squadron Crusher",
        description = "Destroy 4 monoplane formations from 1940 in a single game, on default settings.",
        points = 5,
        trigger = triggerForationKills(age=AGE_1940, count = 4)
    )

    // Achievement: Helicopter Group Purger
    achievement(
        title = "Helicopter Group Purger",
        description = "Destroy 4 helicopter formations from 1970 in a single game, on default settings.",
        points = 10,
        trigger = triggerForationKills(age=AGE_1970, count = 4)
    )

    // Achievement: Jet Plane Flight Terminator
    achievement(
        title = "Jet Plane Flight Terminator",
        description = "Destroy 4 jet plane formations from 1982 in a single game, on default settings.",
        points = 10,
        trigger = triggerForationKills(age=AGE_1982, count = 4)
    )

    // Achievement: Bomber Barrage
    achievement(
        id = 541644,
        title = "Bomber Barrage",
        description = "Destroy 5 mid-size bombers from 1940 in a single game, on default settings.",
        points = 5,
        trigger = triggerBomberKills(count = 5)
    )

    // Achievement: Missile Annihilator
    achievement(
        id = 541649,
        title = "Missile Annihilator",
        description = "Destroy 50 homing missiles in a single game, on default settings.",
        points = 5,
        trigger = triggerMissileKills(count = 50)
    )

    // Achievement: Bomb Defuser
    achievement(
        id = 542269,
        title = "Bomb Disposal Expert",
        description = "Destroy 10 bombs from 1910 in a single game, on default settings.",
        points = 5,
        trigger = triggerBombKills(count = 10)
    )

    // Achievement: Ace Cadet
    achievement(
        title = "Ace Cadet",
        description = "Achieve a score of 100,000 points on default settings.",
        points = 5,
        trigger = triggerHighscore(100000)
    )

    // Achievement: Master Pilot
    achievement(
        title = "Master Pilot",
        description = "Achieve a score of 200,000 points on default settings.",
        points = 10,
        trigger = triggerHighscore(200000)
    )
// endregion Achievements

// #region Leaderboards
    // Leaderboard Start : Hiscore
    // Start condition for the Hiscore leaderboards.
    function startHighscoreLeaderboard() {
        return
            dipSwitchLives() == 3
            && dipSwitchDifficulty() == 4
            && (once(framePlayer1GameOver()) || once(framePlayer1ScoreOverflowed()))
            && never(attractMode() == ATTRACT_ON)
    }

    // Leaderboard Value : Hiscore
    // Value function for the Hiscore leaderboards.
    function valueHighscoreLeaderboard() {
        reset =
            never(attractMode() == ATTRACT_ON) &&
            measured( tally(0, always_false()) )

        return max_of(
            reset,
            measured( player1Score()),
            measured( player1Score() + 1000000, when = repeated(1, framePlayer1ScoreOverflowed()) ),
            measured( player1Score() + 2000000, when = repeated(2, framePlayer1ScoreOverflowed()) ),
            measured( player1Score() + 3000000, when = repeated(3, framePlayer1ScoreOverflowed()) ),
            measured( player1Score() + 4000000, when = repeated(4, framePlayer1ScoreOverflowed()) ),
            measured( player1Score() + 5000000, when = repeated(5, framePlayer1ScoreOverflowed()) ),
            measured( player1Score() + 6000000, when = repeated(6, framePlayer1ScoreOverflowed()) ),
            measured( player1Score() + 7000000, when = repeated(7, framePlayer1ScoreOverflowed()) ),
            measured( player1Score() + 8000000, when = repeated(8, framePlayer1ScoreOverflowed()) ),
            measured( player1Score() + 9000000, when = repeated(9, framePlayer1ScoreOverflowed()) )
        )
    }

    // Leaderboard: Player 1 Score
    leaderboard(
        id = 138551,
        title = "Hiscore Arcade Mode",
        description = "Highest score on default settings",
        format = "SCORE",
        start = startHighscoreLeaderboard(),
        cancel = always_false(),
        submit = framePlayer1GameOver(),
        value = valueHighscoreLeaderboard()
    )

    function startSpeedrunLeaderboard(stage) {
        return
            dipSwitchDifficulty() == 4
            && attractMode() == ATTRACT_OFF
            && typeOfGame() == TYPE_OF_GAME_1P
            && currentStage() == stage
            && prev(gameState()) != STATE_NEW_LIFE_READY_MESSAGE
            && gameState() == STATE_NEW_LIFE_READY_MESSAGE
    }

    function submitSpeedrunLeaderboard(stage) {
        return
            prev(currentStage() == stage)
            && currentStage() != stage
    }

    // Leaderboard: Speedrun Stage 1
    leaderboard(
        id = 138651,
        title = "Speedrun Stage 1",
        description = "Fastest time to complete 1st stage on default difficulty",
        format = "TIME",
        lower_is_better = true,
        start = startSpeedrunLeaderboard(stage = 1),
        cancel = gameState() == STATE_GAME_OVER,
        submit = submitSpeedrunLeaderboard(stage = 1),
        value = measured(always_true())
    )

    // Leaderboard: Speedrun Stage 2
    leaderboard(
        id = 138652,
        title = "Speedrun Stage 2",
        description = "Fastest time to complete 2nd stage on default difficulty",
        format = "TIME",
        lower_is_better = true,
        start = startSpeedrunLeaderboard(stage = 2),
        cancel = gameState() == STATE_GAME_OVER,
        submit = submitSpeedrunLeaderboard(stage = 2),
        value = measured(always_true())
    )

    // Leaderboard: Speedrun Stage 3
    leaderboard(
        id = 138653,
        title = "Speedrun Stage 3",
        description = "Fastest time to complete 3rd stage on default difficulty",
        format = "TIME",
        lower_is_better = true,
        start = startSpeedrunLeaderboard(stage = 3),
        cancel = gameState() == STATE_GAME_OVER,
        submit = submitSpeedrunLeaderboard(stage = 3),
        value = measured(always_true())
    )

    // Leaderboard: Speedrun Stage 4
    leaderboard(
        id = 138654,
        title = "Speedrun Stage 4",
        description = "Fastest time to complete 4th stage on default difficulty",
        format = "TIME",
        lower_is_better = true,
        start = startSpeedrunLeaderboard(stage = 4),
        cancel = gameState() == STATE_GAME_OVER,
        submit = submitSpeedrunLeaderboard(stage = 4),
        value = measured(always_true())
    )

    // Leaderboard: Speedrun Stage 5
    leaderboard(
        id = 138655,
        title = "Speedrun Stage 5",
        description = "Fastest time to complete 5th stage on default difficulty",
        format = "TIME",
        lower_is_better = true,
        start = startSpeedrunLeaderboard(stage = 5),
        cancel = gameState() == STATE_GAME_OVER,
        submit = submitSpeedrunLeaderboard(stage = 5),
        value = measured(always_true())
    )

// #endregion Leaderboards

// #region Rich Presence
    // Rich Presence : When Game is Started
    rich_presence_conditional_display(
        attractMode() == ATTRACT_OFF,

        "Fighting {3} • Stage: {0} • Lives: {1} • Score: {2}",
        rich_presence_macro("Number", currentStage()),
        rich_presence_macro("Number", currentPlayerLives()),
        rich_presence_macro("Score", player1Score()),
        rich_presence_lookup("Age", currentAge(),
            {
                AGE_1910: "Biplanes in A.D. 1910",
                AGE_1940: "Monoplanes in A.D. 1940",
                AGE_1970: "Hilicopters in A.D. 1970",
                AGE_1982: "Superjets in A.D. 1982",
                AGE_2001: "Flying Saucers in A.D. 2001"
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