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
// #endregion Frame Functions

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