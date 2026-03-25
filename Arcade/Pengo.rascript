// Pengo (Arcade)
// #ID = 11914

// #region Memory Addresses
    TRUE = 0x01
    FALSE = 0x00

    function creditActiveFlag() => byte(0x0019)
    function credits() => byte(0x0008)
    function twoPlayerMode() => bit7(0x0016)
    function activePlayer() => bit0(0x0016) + 1

    function player1Score() => word(0x000e)
    function player1Round() => byte(0x0012)
    function player1Lives() => byte(0x0014)
    function player1LivesPlayed() => byte(0x0016) & 0x7F

    function player2Score() => byte(0x0010)
    function player2Round() => byte(0x0013)
    function player2Lives() => byte(0x0015)

    function roundTimeFrames() => byte(0x045b)
    function roundTimeSeconds() => byte(0x045c)
    function roundTimeMinutes() => byte(0x045d)
    function enemiesRemaining() => byte(0x0598)
    function eggsRemaining() => byte(0x05c1)
    function pengoState() => byte(0x0018)
    PENGO_STATE_ALIVE = 0x00
    PENGO_STATE_DEAD = 0xff

    function snoBeeSpeed(index) => byte(0x0506 + (index-1)*20)
    function screenPushStart() => byte(0x16c9)
    SCREEN_PUSHSTART_ON = 0x40
// #endregion Memory Addresses

// #region Frames
    function frameRoundOrLifeStarted() {
        return
            prev(word(0x144a)) != 0x5244 // "RD" message is not displayed
            && word(0x144a) == 0x5244    // "RD" message is displayed
    }

    function framePlayer1GameOvered() {
        return 
            prev(player1Lives()) > 0
            && player1Lives() == 0
    }
// #endregion Frames

// #region Complex Conditions
    function conditionInActiveGameplay() {
        return
            creditActiveFlag() == TRUE
            && screenPushStart() != SCREEN_PUSHSTART_ON
            && player1Lives() > 0
    }

    function conditionInAttractMode() {
        return
            creditActiveFlag() == FALSE 
            || screenPushStart() == SCREEN_PUSHSTART_ON
            || player1Lives() == 0
    }

    function checkpointGameStartedOnDifficulty(maxStartLives, minDifficulty) {
        return
            once(
                player1LivesPlayed() == 0
                && frameRoundOrLifeStarted()
                && snoBeeSpeed(1) <= 0x0c - minDifficulty + 1
                && player1Lives() <= maxStartLives
            )
    }
// #endregion Complex Conditions

achievement(
    title = "Test",
    description = "Test Achivement",
    points = 0,
    trigger = 
        checkpointGameStartedOnDifficulty(maxStartLives=3, minDifficulty=2)
        && byte(0x00) == 0xff
)

// #region Leaderboards
    leaderboard(
        title = "Hiscore Arcade",
        description = "Highest scores on medium or harder difficulty with a maximum of 3 lives",
        start = 
            checkpointGameStartedOnDifficulty(maxStartLives=3, minDifficulty=2)
            && never(screenPushStart() == SCREEN_PUSHSTART_ON)
            && never(creditActiveFlag() == FALSE)
            && framePlayer1GameOvered()
        ,
        cancel = always_false(),
        submit = always_true(),
        value = player1Score() * 10,
        format = "POINTS"
    )
// #endregion Leaderboards

// #region Rich Presence
    rich_presence_conditional_display(
        conditionInAttractMode(),
        "In Attract Mode with {0} credits",
        rich_presence_value("Credits", credits())
    )

    rich_presence_conditional_display(
        (conditionInActiveGameplay() && twoPlayerMode() == FALSE)
        ||
        (conditionInActiveGameplay() && twoPlayerMode() == TRUE && activePlayer() == 1),
        "Round {0} ● {1} Sno-Bees Left ● {2} Lives ● {3}",
        rich_presence_value("Round", player1Round()),
        rich_presence_value("SnoBees", enemiesRemaining()),
        rich_presence_value("Lives", player1Lives()),
        rich_presence_macro("Score", player1Score())
    )

    rich_presence_conditional_display(
        conditionInActiveGameplay() && twoPlayerMode() == TRUE && activePlayer() == 2,
        "Waiting for Player 2 ● {2} Lives ● {3}",
        rich_presence_value("Round", player1Round()),
        rich_presence_value("SnoBees", enemiesRemaining()),
        rich_presence_value("Lives", player1Lives()),
        rich_presence_macro("Score", player1Score())
    )

    rich_presence_display("Playing Pengo")
// #endregion Rich Presence