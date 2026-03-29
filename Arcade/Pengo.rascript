// Pengo (Arcade)
// #ID = 11914

// #region Memory Addresses
    TRUE = 0x01
    FALSE = 0x00

    function creditActiveFlag() => byte(0x0019)
    function credits() => byte(0x0008)
    function twoPlayerMode() => bit7(0x0016)
    function activePlayer() => bit0(0x0016) + 1
    function gameState() => byte(0x0016)

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
    function bonusReceived() => byte(0x05b6)
    function enemiesRemaining() => byte(0x0598)
    function eggsRemaining() => byte(0x05c1)
    function pengoState() => byte(0x0018)
    PENGO_STATE_ALIVE = 0x00
    PENGO_STATE_DEAD = 0xff

    function snoBeeComboSize(index) => byte(0x051a + (index-1)*0x20)
    function snoBeeSpeed(index) => byte(0x0506 + (index-1)*0x20)
    function snoBeeState(index) => byte(0x051f + (index-1)*0x20)
    SNOBEE_STATE_SQUASHED = 0x0c
    SNOBEE_STATE_HATCHING = 0x0f
    SNOBEE_STATE_SUNN_COLLECTED = 0x06

    function roundFinishTimeSeconds() => byte(0x0592)
    function roundFinishTimeMinutes() => byte(0x0593)

    function screenPushStart() => byte(0x16c9)
    SCREEN_PUSHSTART_ON = 0x40
    function screenIntermission() => byte(0x1773)
    SCREEN_INTERMISSION_ON = 0x47
    function tileBottomRighCorner() => byte(0x1412)
    TILE_STAR = 0x21
// #endregion Memory Addresses

// #region Frames
    function frameHUDRedraws() {
        return
            prev(word(0x144a)) != 0x5244 // "RD" message is not displayed
            && word(0x144a) == 0x5244    // "RD" message is displayed
    }

    function framePlayer1GameOvered() {
        return 
            prev(player1Lives()) > 0
            && player1Lives() == 0
    }

    function framePlayer1Died() {
        return
            prev(player1Lives()) > player1Lives()
    }

    function frameSnoBeeGotSquashed(index) {
        return
            prev(snoBeeState(index) != SNOBEE_STATE_SQUASHED)
            && snoBeeState(index) == SNOBEE_STATE_SQUASHED
    }
// #endregion Frames

// #region Triggers
    function triggerClearRound(targetRound) {
        return
            checkpointGameStartedOnDifficulty(maxStartLives=3, minDifficulty=2)
            && never(creditActiveFlag() == FALSE)
            && never(player1Lives() == 0)
            && activePlayer() == 1
            && player1Round() == targetRound
            
            && prev(screenIntermission()) != SCREEN_INTERMISSION_ON
            && screenIntermission() == SCREEN_INTERMISSION_ON
    }

    function triggerDiamonBonus(bonusPoints) {
        bonusReceivedFlag = 0xff
        if (bonusPoints == 10000) {
            bonusReceivedFlag = 0x00
        }

        return
            checkpointGameStartedOnDifficulty(maxStartLives=3, minDifficulty=2)
            && never(creditActiveFlag() == FALSE)
            && never(player1Lives() == 0)
            && activePlayer() == 1
            
            && bonusReceived() == bonusReceivedFlag
            && prev(tileBottomRighCorner()) != TILE_STAR
            && tileBottomRighCorner() == TILE_STAR

    }

    function triggerEggsDestroyed(targetCount) {
        requiredConditions =
            checkpointGameStartedOnDifficulty(maxStartLives=3, minDifficulty=2)
            && never(creditActiveFlag() == FALSE)
            && never(player1Lives() == 0)
            && activePlayer() == 1

        targetCondition =
            repeated(targetCount,
                eggsRemaining() < prev(eggsRemaining())
                && none_of(range(1,4), index =>
                    snoBeeState(index) == SNOBEE_STATE_HATCHING
                )
            )

        return requiredConditions && measured(targetCondition)
    }

    function triggerSnoBeeCombo(comboSize) {
        return
            checkpointGameStartedOnDifficulty(maxStartLives=3, minDifficulty=2)
            && never(creditActiveFlag() == FALSE)
            && never(player1Lives() == 0)
            && activePlayer() == 1

            //&& enemiesRemaining() == prev(enemiesRemaining()) - comboSize

            && any_of(range(1,4), index =>
                snoBeeComboSize(index) == comboSize
                && prev(snoBeeState(index)) != SNOBEE_STATE_SQUASHED
                && snoBeeState(index) == SNOBEE_STATE_SQUASHED
            )
    }

    function triggerSceneTime(minSeconds, maxSeconds) {
        return
            checkpointGameStartedOnDifficulty(maxStartLives=3, minDifficulty=2)
            && never(creditActiveFlag() == FALSE)
            && never(player1Lives() == 0)
            && activePlayer() == 1

            && prev(screenIntermission()) != SCREEN_INTERMISSION_ON
            && screenIntermission() == SCREEN_INTERMISSION_ON
            && roundFinishTimeMinutes() == 0
            && roundFinishTimeSeconds() >= minSeconds
            && roundFinishTimeSeconds() <= maxSeconds
    }

    function triggerStunCollector(targetCount) {
        requiredConditions =
            checkpointGameStartedOnDifficulty(maxStartLives=3, minDifficulty=2)
            && never(creditActiveFlag() == FALSE)
            && never(player1Lives() == 0)
            && activePlayer() == 1

        targetCondition =
            tally_of(range(1,4), targetCount, index =>
                prev(snoBeeState(index)) != SNOBEE_STATE_SUNN_COLLECTED
                && snoBeeState(index) == SNOBEE_STATE_SUNN_COLLECTED
            )

        return requiredConditions && measured(targetCondition)
    }

    function triggerPacifist() {
        requiredConditions =
            checkpointGameStartedOnDifficulty(maxStartLives=3, minDifficulty=2)
            && never(creditActiveFlag() == FALSE)
            && never(player1Lives() == 0)
            && activePlayer() == 1

        primingConditions = once(
            // New Round Started
            roundTimeFrames() == 0x00
            && roundTimeMinutes() == 0x00
            && roundTimeSeconds() == 0x00
            
            // Player Died
            && never(framePlayer1Died())
            
            // Enemy Stunned and Collected
            && never( any_of(range(1,4), index => 
                snoBeeState(index) == SNOBEE_STATE_SUNN_COLLECTED
            ))

            // Enemy Stunned and Collected
            && never( any_of(range(1,4), index => 
                snoBeeState(index) == SNOBEE_STATE_SQUASHED
            ))

            // Egg Destroyed
            && never ( 
                prev(eggsRemaining()) > eggsRemaining()
                && all_of(range(1,4), index => 
                    snoBeeState(index) != SNOBEE_STATE_HATCHING
                )
            )
        )

        triggerConditions = 
            prev(screenIntermission() != SCREEN_INTERMISSION_ON)
            && screenIntermission() == SCREEN_INTERMISSION_ON

        return requiredConditions && primingConditions && trigger_when(triggerConditions)
    }
// #endregion Triggers

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
                && frameHUDRedraws()
                && snoBeeSpeed(1) <= 0x0c - minDifficulty + 1
                && player1Lives() <= maxStartLives
            )
    }
// #endregion Complex Conditions

// #region Achievemets
    achievement(
        title = "March of the Pengos",
        description = "Clear Round 2 on medium or higher difficulty, starting with 3 lives or fewer",
        type = "progression",
        points = 5,
        trigger = triggerClearRound(2)
    )

    achievement(
        title = "Glacier Shakers",
        description = "Clear Round 4 on medium or higher difficulty, starting with 3 lives or fewer",
        type = "progression",
        points = 5,
        trigger = triggerClearRound(4)
    )

    achievement(
        title = "The Royal Salute",
        description = "Clear Round 6 on medium or higher difficulty, starting with 3 lives or fewer",
        type = "progression",
        points = 10,
        trigger = triggerClearRound(6)
    )

    achievement(
        title = "Jumping Jack Frost",
        description = "Clear Round 8 on medium or higher difficulty, starting with 3 lives or fewer",
        type = "progression",
        points = 10,
        trigger = triggerClearRound(8)
    )

    achievement(
        title = "Tuxedo Virtuoso",
        description = "Clear Round 10 on medium or higher difficulty, starting with 3 lives or fewer",
        type = "progression",
        points = 10,
        trigger = triggerClearRound(10)
    )

    achievement(
        title = "The Final Note",
        description = "Clear Round 12 on medium or higher difficulty, starting with 3 lives or fewer",
        type = "win_condition",
        points = 25,
        trigger = triggerClearRound(12)
    )

    achievement(
        title = "Rough Cut",
        description = "Align the diamond blocks against any border on medium difficulty or higher, starting with 3 lives or fewer",
        points = 5,
        trigger = triggerDiamonBonus(5000)
    )

    achievement(
        title = "Brilliant Cut",
        description = "Align the diamond blocks away from the border on medium difficulty or higher, starting with 3 lives or fewer",
        points = 10,
        trigger = triggerDiamonBonus(10000)
    )

    achievement(
        title = "Eggs-Terminator",
        description = "Destroy at lest 20 eggs in a single game on medium difficulty or higher, starting with 3 lives or fewer",
        points = 10,
        trigger = triggerEggsDestroyed(20)
    )

    achievement(
        title = "Stunning Collection",
        description = "Collect 30 stunned Sno-Bees in a single session on medium difficulty or higher starting with 3 lives or less",
        points = 10,
        trigger = triggerStunCollector(30)
    )

    achievement(
        title = "Double Wood",
        description = "Crush 2 Sno-Bees at once with an ice block on medium difficulty or higher, starting with 3 lives or fewer",
        points = 5,
        trigger = triggerSnoBeeCombo(2)
    )

    achievement(
        title = "Sno-Bee Spare",
        description = "Crush 3 Sno-Bees at once with an ice block on medium difficulty or higher, starting with 3 lives or fewer",
        points = 10,
        trigger = triggerSnoBeeCombo(3)
    )

    achievement(
        title = "Four-Bee Strike",
        description = "Crush 4 Sno-Bees at once with an ice block on medium difficulty or higher, starting with 3 lives or fewer",
        points = 25,
        trigger = triggerSnoBeeCombo(4)
    )

    achievement(
        title = "Glacial Pace",
        description = "Finish a round under 29 seconds on medium difficulty or higher, starting with 3 lives or fewer",
        points = 5,
        trigger = triggerSceneTime(1, 29)
    )

    achievement(
        title = "Arctic Sprint",
        description = "Finish a round under 19 seconds on medium difficulty or higher, starting with 3 lives or fewer",
        points = 10,
        trigger = triggerSceneTime(1, 19)
    )

    achievement(
        title = "Absolute Nonviolence",
        description = "Complete a round without killing any enemies or dying on medium difficulty or higher",
        points = 25,
        trigger = triggerPacifist()
    )
// #endregion Achievements

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