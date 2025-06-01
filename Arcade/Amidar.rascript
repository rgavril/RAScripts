// Amidar
// #ID = 11847


function gameStarted() => byte(0x0006)
TRUE = 0x01
FALSE = 0x00

function credits() => byte(0x0002)

function dipSwitchLives() => byte(0x007)

function activePlayer() => byte(0x001e)
ACTIVE_PLAYER_1 = 0x00
ACTIVE_PLAYER_2 = 0x01

function stageType() => bit0(0x0380)
STAGE_TYPE_APE = 0x00
STAGE_TYPE_PAINT = 0x01

function currentStage() => byte(0x0280) + 1

function player1Stage() => byte(0x0380) + 1

function player1Lives() => byte(0x0388)

function player1Score() => bcd(tbyte(0x00a2))

function jumpsRemaining() => byte(0x285)

function gameState() => byte(0x000a)
GAME_STATE_MAZE_STARTING = 0x01
GAME_STATE_MAZE_PLAYING = 0x04
GAME_STATE_MAZE_COMPLETED = 0x05
GAME_STATE_MAZE_DYING = 0x07
GAME_STATE_BONUS_RESULTS = 0x15

function attackMode() => byte(0x01f5)
ATTACK_MODE_ON = 0xff
ATTACK_MODE_OFF = 0x00

function consecutiveAmidarsAttacked() => byte(0x1f7)

function painbrushStatus() => byte(0x0352)
BRUSH_PAINTING_OLD_TRACE = 0x00
BRUSH_NOT_PAITING = 0x01
BRUSH_PAINTING_NEW_TRACE = 0xff

function admidar1Sprite() => byte(0x0069)
SPRITE_BANANA = 0x21
SPRITE_5000_POINTS = 0x3c

function frameMazeGameCompleted() {
    return
        prev(gameState()) == GAME_STATE_MAZE_PLAYING  &&
        gameState() == GAME_STATE_MAZE_COMPLETED
}

function framePlayer1ProgressedToStage(stage) {
    return
        gameStarted() == TRUE &&
        prev(player1Stage()) == stage-1 &&
        player1Stage() == stage
}

function framePlayer1LivesZeroed() {
    return
        gameStarted() == TRUE
        && prev(player1Lives()) == 1
        && player1Lives() == 0
}

function frameGameStarted() {
    return
        prev(gameStarted()) == FALSE &&
        gameStarted() == TRUE
}

function frameCompletedMazeFromStage(stage) {
    return
        currentStage() == stage &&
        frameMazeGameCompleted()
}

function framePlayer1ScoreWentOver(score) {
    return
        prev(player1Score()) < score &&
        player1Score() >= score
}

function frameAdvancedFromBonusGameToMazeGame() {
    return
        prev(gameState()) == GAME_STATE_BONUS_RESULTS &&
        gameState() == GAME_STATE_MAZE_STARTING
}

function frameAdvancedFromBonusGameToApeGame() {
    return
        frameAdvancedFromBonusGameToMazeGame() &&
        stageType() == STAGE_TYPE_APE
}

function frameAdvancedFromBonusGameToPaintGame() {
    return
        frameAdvancedFromBonusGameToMazeGame() &&
        stageType() == STAGE_TYPE_PAINT
}

function frameRemainingJumpsDecreased() {
    return jumpsRemaining() < prev(jumpsRemaining())
}

function frameJumpUsed() {
    return
        gameState() == GAME_STATE_MAZE_PLAYING &&
        frameRemainingJumpsDecreased()
}

function frameAmidarAttacked() {
    return
        attackMode() == ATTACK_MODE_ON
        && prev(consecutiveAmidarsAttacked()) != consecutiveAmidarsAttacked()
}

function frameBonusGameWon() {
    return
        gameState() == GAME_STATE_BONUS_RESULTS
        && prev(admidar1Sprite()) == SPRITE_BANANA
        && admidar1Sprite() == SPRITE_5000_POINTS
}

function framePlayer1ScoreOveflowed() {
    return
        prev(gameStarted()) == TRUE
        && player1Score() < prev(player1Score())
}

// Trigger : Stages Completed
// Used By :
//  - Navigating the Basics    : startStage=1, endStage=2
//  - Intermediate Grid Runner : startStage=3, endStage=4
//  - Advanced Grid Tactics    : startStage=5, endStage=6
//  - Expert Grid Navigator    : startStage=7, endStage=8
function triggerStagesCompleted(startStage, endStage) {
    // Priming Conditions
    primingConditions =
        gameStarted() == TRUE
        && dipSwitchLives() <= 5
        && activePlayer() == ACTIVE_PLAYER_1

        if (startStage == 1) primingConditions = primingConditions
        && once(frameGameStarted())

        if (startStage > 1) primingConditions = primingConditions
        && once(framePlayer1ProgressedToStage(startStage))

    // Goal Conditions
    goalConditions =
        frameCompletedMazeFromStage(endStage)

    // Cancel Conditions
    cancelConditions =
        never(gameStarted() == FALSE)

    return primingConditions && goalConditions && cancelConditions
}

// Trigger : No Jump Challange
// Used By :
//  - Grounded Gorilla : targetStageType = STAGE_TYPE_APE
//  - Silent Roller    : targetStageType = STAGE_TYPE_PAINT
function triggerNoJumpChallange(targetStageType) {
    // Priming Conditions
    primingConditions =
        gameStarted() == TRUE
        && activePlayer() == ACTIVE_PLAYER_1

        if (targetStageType == STAGE_TYPE_APE) primingConditions = primingConditions
        && tally(1, frameAdvancedFromBonusGameToApeGame(), frameGameStarted() )

        if (targetStageType == STAGE_TYPE_PAINT) primingConditions = primingConditions
        && once(frameAdvancedFromBonusGameToPaintGame())

    // Goal Conditions
    goalConditions =
        frameMazeGameCompleted()

    // Cancel Conditions
    cancelCondition =
        never(frameJumpUsed())
        && never(gameState() == GAME_STATE_MAZE_DYING)

    return primingConditions && trigger_when(goalConditions) && cancelCondition
}

// Trigger : Score Milestone
// Used By :
//  - Breaking the Score Barrier : score =  10000
//  - A Life's Worth of Points   : score =  30000
//  - Century Scorer             : score = 100000
function triggerScoreMilestone(score) {
    // Priming Conditions
    primingConditions =
        gameStarted() == TRUE
        && dipSwitchLives() == 3
        && activePlayer() == ACTIVE_PLAYER_1

    // Goal Conditions
    goalConditions =
        framePlayer1ScoreWentOver(score)

    return primingConditions && goalConditions
}

// Trigger : Attack Combo
// Used By :
//  - Light Attack Combo : comboSize = 5
//  - Heavy Attack Combo : comboSize = 7
function triggerAttackCombo(comboSize) {
    // Priming Conditions
    primingConditions =
        gameStarted() == TRUE
        && activePlayer() == ACTIVE_PLAYER_1
        && gameState() == GAME_STATE_MAZE_PLAYING
        && attackMode() == ATTACK_MODE_ON

        if (comboSize == 6) primingConditions = primingConditions
        && currentStage() >= 3

        if (comboSize == 7) primingConditions = primingConditions
        && currentStage() >= 4

    // Goal Conditions
    goalConditions =
        repeated(comboSize,
            activePlayer() == ACTIVE_PLAYER_1
            && frameAmidarAttacked()
        )

    // Cancel Conditions
    cancelConditions =
        never(attackMode() == ATTACK_MODE_OFF)

    return primingConditions && cancelConditions && (trigger_when(goalConditions) || measured(goalConditions))
}

// Trigger : Paint Challange
// Used By :
//  - Commited Painter
function triggerPaintChallange() {
    // Priming Conditions
    primingConditions =
        gameStarted() == TRUE
        && activePlayer() == ACTIVE_PLAYER_1
        && once(frameAdvancedFromBonusGameToPaintGame())

    // Goal Conditions
    goalConditions =
        frameMazeGameCompleted()

    // Cancel Conditions
    cancelConditions =
        never(painbrushStatus() == BRUSH_NOT_PAITING)
        && never(gameState() == GAME_STATE_MAZE_DYING)

    return primingConditions && trigger_when(goalConditions) && cancelConditions
}

// Trigger : Banana Easting Challange
// Used By :
//  - Banana Bite     : quantity = 1
//  - Banana Binge    : quantity = 2
//  - Banana Overload : quantity = 3
function triggerBananaEatingChallange(quantity) {
    // Goal Conditions
    goalConditions =
        gameStarted() == TRUE
        && dipSwitchLives() == 3
        && activePlayer() == ACTIVE_PLAYER_1
        && frameBonusGameWon()

    // Cancel Conditions
    cancelConditions =
        never(gameStarted() == FALSE)

    if (quantity > 1)
        return measured(repeated(quantity, goalConditions)) && cancelConditions
    else
        return goalConditions
}

// Leaderboard Start : Hiscore
// Used By :
//  - Hiscore 3 Lives : lives = 3
//  - Hiscore 5 Lives : lives = 5
function startHiscoreLeaderboard(lives) {
    return
        dipSwitchLives() == lives
        && (once(framePlayer1LivesZeroed()) || once(framePlayer1ScoreOveflowed()) )
        && never(gameStarted() == FALSE)
}

// Leaderboard Value : Hiscore
// Used By :
//  - Hiscore 3 Lives
//  - Hiscore 5 Lives
function valueHiscoreLeaderboard() {
    reset =
        never(gameStarted() == FALSE) &&
        measured( tally(0, always_false()) )

    overflow_none = measured( player1Score())
    overflow_1st  = measured( player1Score() + 1000000, when = repeated(1, framePlayer1ScoreOveflowed()) )
    overflow_2nd  = measured( player1Score() + 2000000, when = repeated(2, framePlayer1ScoreOveflowed()) )
    overflow_3rd  = measured( player1Score() + 3000000, when = repeated(3, framePlayer1ScoreOveflowed()) )

    return max_of(reset, overflow_none, overflow_1st, overflow_2nd, overflow_3rd)
}

// Achievement : Navigating the Basics
achievement(
    id = 514157,
    title = "Navigating the Basics",
    points = 5,
    type = "progression",
    description = "Complete stages 1 and 2 with the Lives DIP switch set to 5 or fewer.",
    trigger = triggerStagesCompleted(startStage=1, endStage=2)
)

// Achievement : Intermediate Grid Runner
achievement(
    id = 514158,
    title = "Intermediate Grid Runner",
    points = 10,
    type = "progression",
    description = "Complete stages 3 and 4 with the Lives DIP switch set to 5 or fewer.",
    trigger = triggerStagesCompleted(startStage=3, endStage=4)
)

// Achievement : Advanced Grid Tactics
achievement(
    id = 514159,
    title = "Advanced Grid Tactics",
    points = 25,
    type = "progression",
    description = "Complete stages 5 and 6 with the Lives DIP switch set to 5 or fewer.",
    trigger = triggerStagesCompleted(startStage=5, endStage=6)
)

// Achievement : Expert Grid Navigator
achievement(
    id = 514160,
    title = "Expert Grid Navigator",
    points = 25,
    type = "win_condition",
    description = "Complete stages 7 and 8 with the Lives DIP switch set to 5 or fewer.",
    trigger = triggerStagesCompleted(startStage=7 , endStage=8)
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
    points = 10,
    description = "Finish a gorilla stage without using any jumps or losing a life.",
    trigger = triggerNoJumpChallange(STAGE_TYPE_APE)
)

// Achievement : Silent Roller
achievement(
    id = 514155,
    title = "Silent Roller",
    points = 10,
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
        gameStarted() == FALSE,
    submit =
        always_true(),
    value =
        player1Stage()
)

// Rich Presence : When Game is Started
rich_presence_conditional_display(
    gameStarted() == TRUE,

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