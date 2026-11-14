// Ghosts'n Goblins (NES)
// #ID = 1710

// #region Memory Locations
    function stage() => byte(0x00ac)
        STAGE_1A = 0x00
        STAGE_1B = 0x01
        STAGE_1C = 0x02

        STAGE_2A = 0x03
        STAGE_2B = 0x04
        STAGE_2C = 0x05
        STAGE_2D = 0x06

        STAGE_3A = 0x07
        STAGE_3B = 0x08

        STAGE_4A = 0x09
        STAGE_4B = 0x0a

        STAGE_5 = 0x0b
        STAGE_6 = 0x0c
        STAGE_7 = 0x0d

    function stageCompleted() => byte(0x00c9)
        STAGE_COMPLETED_NO = 0x00
        STAGE_COMPLETED_YES = 0xff

    function gameState() => byte(0x0004)
        GAME_STATE_PLAYING = 0x00
        GAME_STATE_NOT_PLAYING = 0x80

    function inDemo() => byte(0x0094)
        IN_DEMO_NO = 0x00
        IN_DEMO_YES = 0xff

    function stageSelect() => byte(0x00a7)
        STAGE_SELECT_ACTIVE = 0x0f
        STAGE_SELECT_INACTIVE = 0x00
    function activePlayer() => byte(0x00ba)
        ACTIVE_PLAYER_1 = 0x00
        ACTIVE_PLAYER_2 = 0x01
// #endregion Memory Locations

// #region Frames
    function frameStageCompleted() {
        return prev(stageCompleted()) == STAGE_COMPLETED_NO
            && stageCompleted() == STAGE_COMPLETED_YES
    }
// #endregion Frames

// #region Triggers
    function triggerFinishStage(stage) {
        return
            gameState() == GAME_STATE_PLAYING
            && inDemo() == IN_DEMO_NO
            && stageSelect() != STAGE_SELECT_ACTIVE
            && activePlayer() == ACTIVE_PLAYER_1
            && stage() == stage
            && frameStageCompleted()
    }
// #endregion Triggers

// #region Achievements
    achievement(
        id = 16421,
        title = "Strange Unicorn",
        description = "Complete Stage 1",
        points = 5,
        trigger = triggerFinishStage(STAGE_1C),
        type = "progression"
    )
    
    achievement(
        id = 16422,
        title = "Dangerous Duo",
        description = "Complete Stage 2",
        points = 10,
        trigger = triggerFinishStage(STAGE_2D),
        type = "progression"
    )

    achievement(
        id = 16423,
        title = "Dragon Snake",
        description = "Complete Stage 3",
        points = 10,
        trigger = triggerFinishStage(STAGE_3B),
        type = "progression"
    )

    achievement(
        id = 16424,
        title = "No New Ideas for Bosses",
        description = "Complete Stage 4",
        points = 10,
        trigger = triggerFinishStage(STAGE_4B),
        type = "progression"
    )

    achievement(
        id = 16425,
        title = "Real Satan",
        description = "Complete Stage 5",
        points = 25,
        trigger = triggerFinishStage(STAGE_5),
        type = "progression"
    )

    achievement(
        id = 16426,
        title = "More Satans?!",
        description = "Complete Stage 6",
        points = 25,
        trigger = triggerFinishStage(STAGE_6),
        type = "progression"
    )
// #endregion Achievements