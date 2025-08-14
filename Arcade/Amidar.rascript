// Amidar
// #ID = 11847

// #region Memory Addresses
    // Address : In Game
    // Indicates if the game is currently being played.
    function inGame() => byte(0x0006)
    TRUE = 0x01
    FALSE = 0x00

    // Address : Credits
    // Indicates the number of credits inserted.
    function credits() => byte(0x0002)

    // Address : DIP Switche Lives
    // Indicates then number of lives set by the DIP switch.
    function dipSwitchLives() => byte(0x007)

    // Address : Active Player
    // Indicates which player is currently active.
    function activePlayer() => byte(0x001e)
    ACTIVE_PLAYER_1 = 0x00  // Player 1 is active.
    ACTIVE_PLAYER_2 = 0x01  // Player 2 is active.

    // Address : Stage Type
    // Inidicates the type of stage currently being played.
    // Game alternates between two types, ape and paint, by looking if the stage is odd or even, we can determine the type.
    function stageType() => bit0(0x0380)
    STAGE_TYPE_APE = 0x00
    STAGE_TYPE_PAINT = 0x01

    // Address : Current Stage
    // Current stage number, internally stored as zero-based but returned as one-based.
    function currentStage() => byte(0x0280) + 1

    // Address : Player 1 Stage
    // Indicates Player 1's current stage number.
    // Internally stored as zero-based but returned as one-based.
    function player1Stage() => byte(0x0380) + 1

    // Address : Player 1 Lives
    // Indicates number of lives remaining for Player 1.
    function player1Lives() => byte(0x0388)

    // Address : Player 1 Score
    // Indicates Player 1's current score.
    function player1Score() => bcd(tbyte(0x00a2))
    function player1Score_XX0000() => byte(0x00a4)

    // Address : Jumps Remaining
    // Indicates number of jumps remaining.
    // Default is 3 and decreases by 1 each time a jump is used.
    function jumpsRemaining() => byte(0x285)

    // Address : Game State
    // Indicates the current state of the game.
    function gameState() => byte(0x000a)
    GAME_STATE_MAZE_STARTING = 0x01     // The maze is starting.
    GAME_STATE_MAZE_PLAYING = 0x04      // The maze is currently being played.
    GAME_STATE_MAZE_COMPLETED = 0x05    // The maze has been completed.
    GAME_STATE_MAZE_DYING = 0x07        // The player is dying.
    GAME_STATE_BONUS_RESULTS = 0x15     // The results of the bonus game are being displayed.

    // Address : Attack Mode
    // Indicates if the attack mode is currently active.
    function attackMode() => byte(0x01f5)
    ATTACK_MODE_ON = 0xff
    ATTACK_MODE_OFF = 0x00

    // Address : Attack Streak Length
    // Count of enemies killed in a attack.
    // This value only goes up to 6, then it rolls back to zero.
    // Best way to count a streak is to check how many times this value changed.
    function attackStreakLength() => byte(0x1f7)

    // Address : Painbrussh Status
    // Indicates the status of the paintbrush.
    // This value is used to determine if the player is painting a new trace or not.
    function paintbrushStatus() => byte(0x0352)
    BRUSH_PAINTING_OLD_TRACE = 0x00     // The brush is painting an old trace.
    BRUSH_NOT_PAITING = 0x01            // The brush is not painting.
    BRUSH_PAINTING_NEW_TRACE = 0xff     // The brush is painting a new trace.

    // Address : Amidar 1 Sprite
    // This address is used to determine the sprite being displayed for Amidar 1.
    // Because is also used in a bonus game to display the target sprite,
    // we can use it to determine if the bonus game was won or not.
    function amidar1Sprite() => byte(0x0069)
    SPRITE_BANANA = 0x21        // Banana sprite.
    SPRITE_5000_POINTS = 0x3c   // 5000 Points sprite.
// #endregion Memory Addresses

// #region Frame Functions
    // Frame : Maze Completed
    // Happens when a maze was completed successfully.
    function frameMazeCompleted() {
        return
            prev(gameState()) == GAME_STATE_MAZE_PLAYING
            && gameState() == GAME_STATE_MAZE_COMPLETED
    }

    // Frame : Player 1 Advanced to Stage
    // Happens when Player 1 has advanced to a specific stage.
    function framePlayer1AdvancedToStage(stage) {
        return
            inGame() == TRUE
            && prev(player1Stage()) == stage-1
            && player1Stage() == stage
    }

    // Frame : Player 1 Lives Zeroed
    // Happens when Player 1 has lost all lives.
    function framePlayer1LivesZeroed() {
        return
            inGame() == TRUE
            && prev(player1Lives()) == 1
            && player1Lives() == 0
    }

    // Frame : Game Started
    function frameGameStarted() {
        return
            prev(inGame()) == FALSE
            && inGame() == TRUE
    }

    // Frame : Maze Completed on Stage
    // Happens when the maze has been completed on a specific stage.
    function frameMazeCompletedOnStage(stage) {
        return
            currentStage() == stage
            && frameMazeCompleted()
    }

    // Frame : Player 1 Score Exceeded
    // Happens when when Player 1's score has exceeded a specific value.
    function framePlayer1ScoreExceeded(score) {
        return
            prev(player1Score()) < score
            && player1Score() >= score
    }

    // Frame : Maze Started After Bonus
    // Happens when player first started a maze after the bonus game has been played.
    function frameMazeStartedAfterBonus() {
        return
            prev(gameState()) == GAME_STATE_BONUS_RESULTS
            && gameState() == GAME_STATE_MAZE_STARTING
    }

    // Frame : Ape Maze Started After Bonus
    function frameApeMazeStartedAfterBonus() {
        return
            frameMazeStartedAfterBonus() &&
            stageType() == STAGE_TYPE_APE
    }

    // Frame : Paint Maze Started After Bonus
    function framePaintMazeStartedAfterBonus() {
        return
            frameMazeStartedAfterBonus() &&
            stageType() == STAGE_TYPE_PAINT
    }

    // Frame : Jump Used
    // Happens when a jump has been used during a maze game.
    function frameJumpUsed() {
        return
            gameState() == GAME_STATE_MAZE_PLAYING
            && jumpsRemaining() < prev(jumpsRemaining())
    }

    // Frame : Amidar Attacked
    // Happens when an Amidar has attacked by the player.
    function frameAmidarAttacked() {
        return
            attackMode() == ATTACK_MODE_ON
            && prev(attackStreakLength()) != attackStreakLength()
    }

    // Frame : Bonus Game Won
    // Happens when player has won the bonus game.
    function frameBonusGameWon() {
        return
            gameState() == GAME_STATE_BONUS_RESULTS
            && prev(amidar1Sprite()) == SPRITE_BANANA
            && amidar1Sprite() == SPRITE_5000_POINTS
    }

    // Frame : Player 1 Score Overflowed
    // Happens when Player 1's score has overflowed and rolled over to zero.
    function framePlayer1ScoreOverflowed() {
        return
            inGame() == TRUE
            && prev(player1Score_XX0000()) == 0x99
            && player1Score_XX0000() == 0x00
    }
// #endregion Frame Functions

// #region Achievement Triggers
    // Trigger : Stage Completed
    // Complete a specific stages.
    function triggerStageCompleted(endStage) {
        // Required Conditions
        requiredConditions =
            inGame() == TRUE
            && dipSwitchLives() <= 5
            && activePlayer() == ACTIVE_PLAYER_1

        // Goal Conditions
        goalConditions =
            frameMazeCompletedOnStage(endStage)

        return requiredConditions && goalConditions
    }

    // Trigger : No Jump Challange
    // Complete a specific maze type without using any jumps.
    function triggerNoJumpChallange(targetStageType) {
        // Required Conditions
        requiredConditions =
            inGame() == TRUE
            && activePlayer() == ACTIVE_PLAYER_1

        // Start Conditions
        if (targetStageType == STAGE_TYPE_APE)
            // Since the game starts with an ape stage, on ape stage challanges
            // we can start the challange when the game starts
            // or when the player has advanced to a new ape stage.
            startCondition =
                once(frameApeMazeStartedAfterBonus())
                || once(frameGameStarted())
        else
            // For paint stages, we start the challange when 
            // the player has advanced to a new paint stage.
            startCondition = 
                once(framePaintMazeStartedAfterBonus())

        // Goal Conditions
        goalConditions =
            frameMazeCompleted()

        // Cancel Conditions
        cancelCondition =
            never(frameJumpUsed())
            && never(gameState() == GAME_STATE_MAZE_DYING)

        return requiredConditions && startCondition && trigger_when(goalConditions) && cancelCondition
    }

    // Trigger : Score Milestone
    // Score more than a specific number of points.
    function triggerScoreMilestone(score) {
        // Required Conditions
        requiredConditions =
            inGame() == TRUE
            && dipSwitchLives() == 3
            && activePlayer() == ACTIVE_PLAYER_1

        // Goal Conditions
        goalConditions =
            framePlayer1ScoreExceeded(score)

        return requiredConditions && goalConditions
    }

    // Trigger : Attack Combo
    // Attack a specific number of Amidars in a single maze.
    function triggerAttackCombo(comboSize) {
        // Priming Conditions
        primingConditions =
            inGame() == TRUE
            && activePlayer() == ACTIVE_PLAYER_1
            && gameState() == GAME_STATE_MAZE_PLAYING
            && attackMode() == ATTACK_MODE_ON

            // Until stage 3, there are less than 6 Amidars in the maze
            if (comboSize == 6) primingConditions = primingConditions
            && currentStage() >= 3

            // Until stage 4, there are less than 7 Amidars in the maze.
            if (comboSize == 7) primingConditions = primingConditions
            && currentStage() >= 4

        // Goal Conditions
        goalConditions =
            repeated(comboSize,
                activePlayer() == ACTIVE_PLAYER_1
                && frameAmidarAttacked()
            )

        // Reset Conditions
        resetConditions =
            never(attackMode() == ATTACK_MODE_OFF)

        return primingConditions && resetConditions && (trigger_when(goalConditions) || measured(goalConditions))
    }

    // Trigger : Paint Challange
    // Complete a paint stage without canceling any painted lines.
    function triggerPaintChallange() {
        // Priming Conditions
        primingConditions =
            inGame() == TRUE
            && activePlayer() == ACTIVE_PLAYER_1
            && once(framePaintMazeStartedAfterBonus())

        // Goal Conditions
        goalConditions =
            frameMazeCompleted()

        // Cancel Conditions
        cancelConditions =
            never(paintbrushStatus() == BRUSH_NOT_PAITING)
            && never(gameState() == GAME_STATE_MAZE_DYING)

        return primingConditions && trigger_when(goalConditions) && cancelConditions
    }

    // Trigger : Banana Eating Challange
    // Win a specific number of bonus games on a single credit.
    function triggerBananaEatingChallange(quantity) {
        // Goal Conditions
        goalConditions =
            inGame() == TRUE
            && dipSwitchLives() == 3
            && activePlayer() == ACTIVE_PLAYER_1
            && frameBonusGameWon()

        // Cancel Conditions
        cancelConditions =
            never(inGame() == FALSE)

        if (quantity > 1)
            return measured(repeated(quantity, goalConditions)) && cancelConditions
        else
            return goalConditions
    }
// #endregion Achievement Triggers

// #region Achievement Definitions
    // Achievement : Navigating the Basics
    achievement(
        id = 514157,
        title = "Navigating the Basics",
        points = 5,
        type = "progression",
        description = "Complete stages 1 and 2 with the Lives DIP switch set to 5 or fewer.",
        trigger = triggerStageCompleted(2)
    )

    // Achievement : Intermediate Grid Runner
    achievement(
        id = 514158,
        title = "Intermediate Grid Runner",
        points = 10,
        type = "progression",
        description = "Complete stages 3 and 4 with the Lives DIP switch set to 5 or fewer.",
        trigger = triggerStageCompleted(4)
    )

    // Achievement : Advanced Grid Tactics
    achievement(
        id = 514159,
        title = "Advanced Grid Tactics",
        points = 10,
        type = "progression",
        description = "Complete stages 5 and 6 with the Lives DIP switch set to 5 or fewer.",
        trigger = triggerStageCompleted(6)
    )

    // Achievement : Expert Grid Navigator
    achievement(
        id = 514160,
        title = "Expert Grid Navigator",
        points = 25,
        type = "win_condition",
        description = "Complete stages 7 and 8 with the Lives DIP switch set to 5 or fewer.",
        trigger = triggerStageCompleted(8)
    )

    // Achievement : Breaking the Score Barrier
    achievement(
        id = 514148,
        title = "Breaking the Score Barrier",
        points = 1,
        description = "Score 10,000 points with the Lives DIP switch set to 3.",
        trigger = triggerScoreMilestone(10000)
    )

    // Achievement : A Life's Worth of Points
    achievement(
        id = 514149,
        title = "A Life's Worth of Points",
        points = 5,
        description = "Score 30,000 points with the Lives DIP switch set to 3.",
        trigger = triggerScoreMilestone(30000)
    )

    // Achievement : Century Scorer
    achievement(
        id = 514150,
        title = "Century Scorer",
        points = 25,
        description = "Score 100,000 points with the Lives DIP switch set to 3.",
        trigger = triggerScoreMilestone(100000)
    )

    // Achievement : Grounded Gorilla
    achievement(
        id = 514154,
        title = "Grounded Gorilla",
        points = 5,
        description = "Finish a gorilla stage without using any jumps or losing a life.",
        trigger = triggerNoJumpChallange(STAGE_TYPE_APE)
    )

    // Achievement : Silent Roller
    achievement(
        id = 514155,
        title = "Silent Roller",
        points = 5,
        description = "Finish a paint stage without using any jumps or losing a life.",
        trigger = triggerNoJumpChallange(STAGE_TYPE_PAINT)
    )

    // Achievement : Commited Painter
    achievement(
        id = 514156,
        title = "Commited Painter",
        points = 10,
        description = "Finish a paint stage without canceling any painted lines or losing a life.",
        trigger = triggerPaintChallange()
    )

    // Achievement : Light Attack Combo
    achievement(
        id = 514161,
        title = "Light Attack Combo",
        points = 5,
        description = "Attack five enemies in a row and earn a 1600 bonus.",
        trigger = triggerAttackCombo(5)
    )

    // Achievement : Heavey Attack Combo
    achievement(
        id = 514162,
        title = "Heavy Attack Combo",
        points = 10,
        description = "Attack seven enemies in a row and earn a 3200 bonus.",
        trigger = triggerAttackCombo(7)
    )

    // Achievement : Banana Bite
    achievement(
        id = 514151,
        title = "Banana Bite",
        points = 1,
        description = "Win a bonus stage having the Lives DIP switch set to 3.",
        trigger = triggerBananaEatingChallange(1)
    )

    // Achievement : Banana Binge
    achievement(
        id = 514152,
        title = "Banana Binge",
        points = 3,
        description = "Win two bonus stages on one credit having the Lives DIP switch set to 3.",
        trigger = triggerBananaEatingChallange(2)
    )

    // Achievement : Banana Overload
    achievement(
        id = 514153,
        title = "Banana Overload",
        points = 5,
        description = "Win three bonus stages on one credit having the Lives DIP switch set to 3.",
        trigger = triggerBananaEatingChallange(3)
    )
// #endregion Achievement Definitions

// #region Leaderboards
    // Leaderboard Start : Hiscore
    // Start condition for the Hiscore leaderboards.
    function startHiscoreLeaderboard(lives) {
        return
            dipSwitchLives() == lives
            && (once(framePlayer1LivesZeroed()) || once(framePlayer1ScoreOverflowed()))
            && never(inGame() == FALSE)
    }

    // Leaderboard Value : Hiscore
    // Value function for the Hiscore leaderboards.
    function valueHiscoreLeaderboard() {
        reset =
            never(inGame() == FALSE) &&
            measured( tally(0, always_false()) )

        overflow_none = measured( player1Score())
        overflow_1st  = measured( player1Score() + 1000000, when = repeated(1, framePlayer1ScoreOverflowed()) )
        overflow_2nd  = measured( player1Score() + 2000000, when = repeated(2, framePlayer1ScoreOverflowed()) )
        overflow_3rd  = measured( player1Score() + 3000000, when = repeated(3, framePlayer1ScoreOverflowed()) )
        overflow_4th  = measured( player1Score() + 4000000, when = repeated(4, framePlayer1ScoreOverflowed()) )
        overflow_5th  = measured( player1Score() + 5000000, when = repeated(5, framePlayer1ScoreOverflowed()) )

        return max_of(reset, overflow_none, overflow_1st, overflow_2nd, overflow_3rd, overflow_4th, overflow_5th)
    }

    // Leaderboard : Hiscore 3 Lives
    leaderboard(
        id = 128966,
        title = "Hiscore 3 Lives",
        description = "Highest score on 3 lives game.",
        format = "SCORE",
        start =
            startHiscoreLeaderboard(lives=3),
        cancel =
            always_false(),
        submit =
            framePlayer1LivesZeroed(),
        value =
            valueHiscoreLeaderboard()
    )

    // Leaderboard : Hiscore 5 Lives
    leaderboard(
        id = 128967,
        title = "Hiscore 5 Lives",
        description = "Highest score on 5 lives game.",
        format = "SCORE",
        start =
            startHiscoreLeaderboard(lives=5),
        cancel =
            always_false(),
        submit =
            framePlayer1LivesZeroed(),
        value =
            valueHiscoreLeaderboard()
    )

    // Leaderboard : Highest Stage
    leaderboard(
        id = 129461,
        title = "Highest Stage",
        description = "Highest stage reached with 5 lives or less.",
        format = "VALUE",
        start =
            dipSwitchLives() <= 5
            && framePlayer1LivesZeroed(),
        cancel =
            inGame() == FALSE,
        submit =
            always_true(),
        value =
            player1Stage()
    )
// #endregion Leaderboards

// #region Rich Presence
    // Rich Presence : When Game is Started
    rich_presence_conditional_display(
        inGame() == TRUE,

        "Stage: {0} | Lives: {1} | Score: {2}",
        rich_presence_macro("Number", player1Stage()),
        rich_presence_macro("Number", player1Lives()),
        rich_presence_macro("Score", player1Score())
    )

    // Rich Presence : Default
    rich_presence_display(
        "In Attract Mode with {0} Credits.",
        rich_presence_macro("Number", credits())
    )
// #endregion Rich Presence