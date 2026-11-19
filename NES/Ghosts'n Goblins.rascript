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

    function attractMode() => byte(0x0004)
        ATTRACT_MODE_INACTIVE = 0x00
        ATTRACT_MODE_ACTIVE = 0x80

    function inDemo() => byte(0x0094)
        IN_DEMO_NO = 0x00
        IN_DEMO_YES = 0xff

    function stageSelect() => byte(0x00a7)
        STAGE_SELECT_ACTIVE = 0x0f
        STAGE_SELECT_INACTIVE = 0x00
    function activePlayer() => byte(0x00ba)
        ACTIVE_PLAYER_1 = 0x00
        ACTIVE_PLAYER_2 = 0x01
    function finalBossKills() => byte(0x00aa)
    function weapon() => byte(0x00c5)
        WEAPON_AXE = 0x36
        WEAPON_LANCE = 0x40
        WEAPON_DAGGER = 0x42
        WEAPON_FIRE = 0x44
        WEAPON_SHIELD = 0x4f
    function gameFPS() => byte(0x00cd)
        GAME_FPS_30 = 0x02
        GAME_FPS_20 = 0x03
    
    function cameraXPosition() => word(0x006c)
    function timeX00() => byte(0x06f6)
    function time0X0() => byte(0x06fa)
    function time00X() => byte(0x06fc)
    function lives() => byte(0x0715)
// #endregion Memory Locations

// #region Frames
    function frameStageCompleted() {
        return prev(stageCompleted()) == STAGE_COMPLETED_NO
            && stageCompleted() == STAGE_COMPLETED_YES
    }

    function frameLifeLost() {
        return prev(lives()) > lives()
    }
// #endregion Frames

// #region Triggers
    function triggerFinishStage(stage) {
        return
            attractMode() == ATTRACT_MODE_INACTIVE
            && inDemo() == IN_DEMO_NO
            && stageSelect() != STAGE_SELECT_ACTIVE
            && activePlayer() == ACTIVE_PLAYER_1
            && stage() == stage
            && frameStageCompleted()
    }

    function triggerFinishQuest(quest) {
        return
            attractMode() == ATTRACT_MODE_INACTIVE
            && inDemo() == IN_DEMO_NO
            && stageSelect() != STAGE_SELECT_ACTIVE
            && activePlayer() == ACTIVE_PLAYER_1
            && stage() == STAGE_7
            && prev(finalBossKills()) == quest - 1
            && finalBossKills() == quest
    }

    function triggerNoDaggerChallenge() {
        completeConditions =
            prev(finalBossKills()) == 1
            && finalBossKills() == 2

        primingConditions =
            prev(attractMode()) != ATTRACT_MODE_INACTIVE
            && attractMode() == ATTRACT_MODE_INACTIVE
            && inDemo() == IN_DEMO_NO
            && activePlayer() == ACTIVE_PLAYER_1
            && stage() == STAGE_1A
            && weapon() != WEAPON_DAGGER
            && finalBossKills() == 0

        resetConditions =
            weapon() == WEAPON_DAGGER
            || stageSelect() == STAGE_SELECT_ACTIVE

        
        requiredConditions =
            attractMode() == ATTRACT_MODE_INACTIVE
            && inDemo() == IN_DEMO_NO
            && activePlayer() == ACTIVE_PLAYER_1


        return once(primingConditions) && never(resetConditions) && trigger_when(completeConditions) && requiredConditions
    }

    function triggerAstarothLanceChallenge() {
        return
            attractMode() == ATTRACT_MODE_INACTIVE
            && inDemo() == IN_DEMO_NO
            && stageSelect() == STAGE_SELECT_ACTIVE
            && activePlayer() == ACTIVE_PLAYER_1
            && stage() == STAGE_7
            && weapon() == WEAPON_LANCE
            && finalBossKills() == prev(finalBossKills()) + 1
    }

    function triggerStage1NoDamageChallenge() {
        completeConditions =
            stage() == STAGE_1C
            && frameStageCompleted()

        primingConditions =
            stage() == STAGE_1A
            && cameraXPosition() == 0x00
            && timeX00() == 0x02
            && time0X0() == 0x00
            && time00X() == 0x00

        resetConditions =
            never( byte(0x00d6) == 0x60 && gameFPS() == GAME_FPS_20 )
            && never(frameLifeLost())
            && never(attractMode() == ATTRACT_MODE_ACTIVE)
            && never(inDemo() == IN_DEMO_YES)
            && never(activePlayer() != ACTIVE_PLAYER_1)
            && never(stage() > STAGE_1C)

        return resetConditions && once(primingConditions) && trigger_when(completeConditions)
    }
// #endregion Triggers

// #region Achievements
    // #region Progressions
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
            id = 16427,
            title = "More Evil than the Devil Himself",
            description = "Complete the first quest",
            points = 25,
            trigger = triggerFinishQuest(1),
            type = "progression"
        )

        achievement(
            id = 16429,
            title = "Congraturation!",
            description = "This story is happy end!",
            points = 50,
            trigger = triggerFinishQuest(2),
            type = "win_condition"
        )
    // #endregion Progressions

    achievement(
        id = 16792,
        title = "Standard Zombie Killing Equipment",
        description = "Defeat Astaroth with a lance",
        points = 25,
        trigger = triggerAstarothLanceChallenge()
    )

    achievement(
        id = 16471,
        title = "The Hard Way",
        description = "Complete the game without ever acquiring a dagger",
        points = 50,
        trigger = triggerNoDaggerChallenge()
    )

    achievement(
        id = 16464,
        title = "Magic Panties",
        description = "Complete Stage 1 without taking damage",
        points = 10,
        trigger = triggerStage1NoDamageChallenge()
    )
// #endregion Achievements