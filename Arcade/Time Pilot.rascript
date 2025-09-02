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
    function gameState() => byte(0x0530)
    GAME_STATE_PLAYING = 0xff
    GAME_STATE_DEMO = 0x00

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

    // Address: Enemy Kills Remaining
    // Indicates the number of enemies remaining until the boss appears
    function enemyKillsRemaining() => byte(0x0502)

    // Address: Boss Spawned
    // Indicates whether the boss has spawned or not
    function bossSpawned() => byte(0x050d)
    BOSS_NOT_SPAWNED = 0x00
    BOSS_SPAWNED = 0xff

    function bossStatus() => byte(0x00a0)
    PLANE_ON_SCREEN = 0xff
    PLANE_GOT_HIT = 0xf0
    PLANE_NOT_ON_SCREEN = 0x00

    // Address: Credits
    // Indicates the number of credits currently available
    function credits() => byte(0x186)
// #endregion

// #region Frame Functions
    // Frame : Game Started
    // Happens on a new game is started
    function frameGameStarted() {
        return
            prev(gameState() == GAME_STATE_DEMO)
            && (gameState() == GAME_STATE_PLAYING)
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
            prev(playerStatus() == PLANE_ON_SCREEN)
            && (playerStatus() == PLANE_GOT_HIT)
    }

    // Frame : Stage Completed
    // Happens when the current stage is completed
    function frameStageCompleted() {
        return
            enemyKillsRemaining() == 0
            && bossSpawned() == BOSS_SPAWNED
            && prev(bossStatus() == PLANE_GOT_HIT)
            && bossStatus() > 0x00 && bossStatus() < 0xf0
    }
// #endregion Frame Functions

// #region Achievement Triggers
    // Trigger: Age Completed
    // Triggers when the specified age is completed
    function triggerAgeCompleted(age) {
        return
            activePlayer() == ACTIVE_PLAYER_1
            && gameState() == GAME_STATE_PLAYING
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
            && gameState() == GAME_STATE_PLAYING
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
        //     && never(gameState() == GAME_STATE_DEMO)
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
        gameState() == GAME_STATE_PLAYING,

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