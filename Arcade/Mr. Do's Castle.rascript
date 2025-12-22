// Mr. Do's Castle
// #ID = 12097

FALSE = 0x00
TRUE  = 0x01

// #region Memory Addresses
    function gameState() => byte(0x0001)
    function gameplayActive() => bit7(0x0001)
    function activePlayer() => bit4(0x0001)
    ACTIVE_PLAYER_1 = 0
    ACTIVE_PLAYER_2 = 1

    function dipSwitchLives() => byte(0x0004)

    function dipSwitchDifficulty() => byte(0x0005)
    DIFFICULTY_1   = 0x02
    DIFFICULTY_2   = 0x04
    DIFFICULTY_3   = 0x06
    DIFFICULTY_4   = 0x08
    DIFFICULTY_DEFAULT = DIFFICULTY_1

    function sceneCompletedFlag() => byte(0x00a0)
    SCENE_COMPLETED_FLAG_ON = 0x0c

    function postStatus() => byte(0x00d3)
    POST_STATUS_FINISHED = 0x01

    function scene() => byte(0x0101)
    function lives() => byte(0x0103)
    function enemyCount() => byte(0x0104)
    function cherryRemaining() => byte(0x0105)
    function score_XX0000() => bcd(byte(0x010d))
    function score_00XX00() => bcd(byte(0x010e))
    function score_0000XX() => bcd(byte(0x010f))
    function score() => (score_XX0000() * 10000) + (score_00XX00() * 100) + score_0000XX()
    function keysCollected() => byte(0x0110)
    function lettersCollected() => byte(0x011a)
    function letterCollected_E() => bit7(0x011a)
    function letterCollected_X() => bit6(0x011a)
    function letterCollected_T() => bit5(0x011a)
    function letterCollected_R() => bit4(0x011a)
    function letterCollected_A() => bit3(0x011a)
    function shieldActive() => byte(0x011b)
    function shieldTimeRemaining() => byte(0x011c)
    function playerState() => byte(0x0150)
    function playerFalling() => bit1(playerState())
    function playerDying() => bit2(playerState())
    function playerUsingHammer() => bit5(playerState())
// #endregion Memory Addresses

// #region Frame IDs
    function framePlayer1LivesZeroed() {
        return
            gameplayActive() == TRUE
            && activePlayer() == ACTIVE_PLAYER_1
            && prev(activePlayer()) == ACTIVE_PLAYER_1
            && prev(lives()) == 1 && lives() == 0
    }

    function framePlayer1ScoreOverflowed() {
        return
            gameplayActive() == TRUE
            && prev(activePlayer()) == ACTIVE_PLAYER_1
            && activePlayer() == ACTIVE_PLAYER_1
            && prev(score_XX0000()) == 99
            && score_XX0000() == 00
    }
// #endregion Frame IDs

// #region Leaderboards
    function startHighscoreLeaderboard() {
        return
            dipSwitchLives() <= 3
            && (
                once(framePlayer1LivesZeroed()) 
                ||
                once(framePlayer1ScoreOverflowed())
            )
            && never(gameplayActive() == FALSE)
    }

    function valueHighscoreLeaderboard() {
        reset =
            never(gameplayActive() == FALSE) &&
            measured( tally(0, always_false()) )

        overflow_none = measured( score() )
        overflow_1st  = measured( score() + 1000000, when = repeated(1, framePlayer1ScoreOverflowed()) )
        overflow_2nd  = measured( score() + 2000000, when = repeated(2, framePlayer1ScoreOverflowed()) )

        return max_of(reset, overflow_none, overflow_1st, overflow_2nd)
        return score()
    }

    leaderboard(
        title = "High Score",
        description = "Highest score starting with maximum 3 lives at any difficulty",
        format = "SCORE",
        start = startHighscoreLeaderboard(),
        cancel = always_false(),
        submit = framePlayer1LivesZeroed(),
        value = valueHighscoreLeaderboard()
    )
// #endregion Leaderboards

// #region Rich Presence
    rich_presence_conditional_display(
        postStatus() == POST_STATUS_FINISHED
        && gameplayActive() == TRUE,

        "Scene {0} • 🦄 {1}  • 🍒 {2} • 🤡 {3} • 🚩 {5}{6}{7}{8}{9} • 💯 {4}",
        
        rich_presence_macro("Number", scene()),
        rich_presence_macro("Number", enemyCount()),
        rich_presence_macro("Number", cherryRemaining()),
        rich_presence_macro("Number", lives()),
        rich_presence_macro("Score", score()),
        rich_presence_lookup("Letter_E", letterCollected_E(), {TRUE: "E", FALSE: "_"}), // 🅔 Ⓔ
        rich_presence_lookup("Letter_X", letterCollected_X(), {TRUE: "X", FALSE: "_"}), // 🅧 Ⓧ
        rich_presence_lookup("Letter_T", letterCollected_T(), {TRUE: "T", FALSE: "_"}), // 🅣 Ⓣ
        rich_presence_lookup("Letter_R", letterCollected_R(), {TRUE: "R", FALSE: "_"}), // 🅡 Ⓡ
        rich_presence_lookup("Letter_A", letterCollected_A(), {TRUE: "A", FALSE: "_"})  // 🅐 Ⓐ
    )

    rich_presence_conditional_display(
        postStatus() == POST_STATUS_FINISHED
        && gameplayActive() == FALSE,

        "Attract Mode • Difficulty: {0} • Start Lives: {1}",

        rich_presence_macro("Number", dipSwitchDifficulty()-1),
        rich_presence_macro("Number", dipSwitchLives())
    )

    rich_presence_display(
        "Starting Mr. Do's Castle"
    )
// #endregion Rich Presence