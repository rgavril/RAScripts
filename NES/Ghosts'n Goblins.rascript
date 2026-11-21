// Ghosts'n Goblins (NES)
// #ID = 1710

// TODO:
// - Update damage detection logic for stage 1 no damage challenge
// - Make loop 1 and 2 achievements track whole loop not only ending stage

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

    function cheatCode() => byte(0x00a7)
        CHEAT_CODE_STAGE_SELECT = 0x0f
        CHEAT_CODE_CREDITS = 0x08
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
    function buttonB() => bit6(0x00cc)
    function buttonLeft() => bit1(0x00cc)
    function hudVisibility() => byte(0x0506)
        HUD_VISIBLE = 0x80
        HUD_HIDDEN = 0x00
// #endregion Memory Locations

// #region Frames
    function frameStageCompleted() {
        return prev(stageCompleted()) == STAGE_COMPLETED_NO
            && stageCompleted() == STAGE_COMPLETED_YES
    }

    function frameLifeLost() {
        return prev(lives()) > lives()
    }

    function frameLifeOrStageStarting() {
        return prev(hudVisibility()) == HUD_HIDDEN
            && hudVisibility() == HUD_VISIBLE
    }
// #endregion Frames

// #region Triggers
    function triggerCompleteStages(startStage, endStage) {
        requiredConditions =
            attractMode() == ATTRACT_MODE_INACTIVE
            && inDemo() == IN_DEMO_NO
            && activePlayer() == ACTIVE_PLAYER_1

        primingConditions =
            activePlayer() == ACTIVE_PLAYER_1
            && stage() == startStage
            && frameLifeOrStageStarting()

        completeConditions =
            stage() == endStage
            && frameStageCompleted()

        resetConditions =
            never(stage() < startStage)
            && never(stage() > endStage)
            && never(cheatCode() == CHEAT_CODE_STAGE_SELECT)

        return once(primingConditions) && resetConditions && requiredConditions && completeConditions
    }

    function triggerFinishQuest(quest) {
        return
            attractMode() == ATTRACT_MODE_INACTIVE
            && inDemo() == IN_DEMO_NO
            && cheatCode() != CHEAT_CODE_STAGE_SELECT
            && activePlayer() == ACTIVE_PLAYER_1
            && stage() == STAGE_7
            && prev(finalBossKills()) == quest - 1
            && finalBossKills() == quest
    }

    function triggerNoDaggerChallenge() {
        requiredConditions =
            attractMode() == ATTRACT_MODE_INACTIVE
            && inDemo() == IN_DEMO_NO
            && activePlayer() == ACTIVE_PLAYER_1

        primingConditions =
            activePlayer() == ACTIVE_PLAYER_1
            && stage() == STAGE_1A
            && frameLifeOrStageStarting()
            && finalBossKills() == 0

        completeConditions =
            prev(finalBossKills()) == 1
            && finalBossKills() == 2

        resetConditions =
            never(weapon() == WEAPON_DAGGER)
            && never(cheatCode() == CHEAT_CODE_STAGE_SELECT)

        return once(primingConditions) && resetConditions && requiredConditions && trigger_when(completeConditions) 
    }

    function triggerAstarothLanceChallenge() {
        return
            attractMode() == ATTRACT_MODE_INACTIVE
            && inDemo() == IN_DEMO_NO
            && cheatCode() == CHEAT_CODE_STAGE_SELECT
            && activePlayer() == ACTIVE_PLAYER_1
            && stage() == STAGE_7
            && weapon() == WEAPON_LANCE
            && finalBossKills() == prev(finalBossKills()) + 1
    }

    function triggerAstarothTimeChallenge() {
        return
            attractMode() == ATTRACT_MODE_INACTIVE
            && inDemo() == IN_DEMO_NO
            && activePlayer() == ACTIVE_PLAYER_1
            && stage() == STAGE_7
            && timeX00() == 0
            && time0X0() == 0
            && time00X() == 0 && prev(time00X()) > 0
    }

    function triggerStage1Damageless() {
        requiredConditions =
            attractMode() == ATTRACT_MODE_INACTIVE
            && inDemo() == IN_DEMO_NO
            && activePlayer() == ACTIVE_PLAYER_1

        primingConditions =
            activePlayer() == ACTIVE_PLAYER_1
            && stage() == STAGE_1A
            && frameLifeOrStageStarting()

        completeConditions =
            stage() == STAGE_1C
            && frameStageCompleted()

        resetConditions =
            never(cheatCode() == CHEAT_CODE_STAGE_SELECT)
            && never(stage() > STAGE_1C)
            && never( byte(0x00d6) == 0x60 && gameFPS() == GAME_FPS_20 )
            && never(frameLifeLost())

        return once(primingConditions) && resetConditions && requiredConditions && trigger_when(completeConditions)
    }

    function triggerStage2NoAttack() {
        requiredConditions =
            attractMode() == ATTRACT_MODE_INACTIVE
            && inDemo() == IN_DEMO_NO
            && activePlayer() == ACTIVE_PLAYER_1

        primingConditions =
            activePlayer() == ACTIVE_PLAYER_1
            && frameLifeOrStageStarting()
            && stage() == STAGE_2A

        completeConditions =
            stage() == STAGE_2D
            && prev(cameraXPosition()) < 0x0c00 && cameraXPosition() >= 0x0c00

        resetConditions =
            never(cheatCode() == CHEAT_CODE_STAGE_SELECT)
            && never(stage() > STAGE_2D)
            && never(stage() < STAGE_2A)
            && never(buttonB() == 1)

        return once(primingConditions) && resetConditions && trigger_when(completeConditions)
    }

    function triggerStage3NoBackButton() {
        requiredConditions =
            attractMode() == ATTRACT_MODE_INACTIVE
            && inDemo() == IN_DEMO_NO
            && activePlayer() == ACTIVE_PLAYER_1

        primingConditions =
            activePlayer() == ACTIVE_PLAYER_1
            && stage() == STAGE_3A
            && frameLifeOrStageStarting()

        completeConditions =
            stage() == STAGE_3B
            && prev(cameraXPosition()) < 0x0c70 && cameraXPosition() >= 0x0c70

        resetConditions =
            never(cheatCode() == CHEAT_CODE_STAGE_SELECT)
            && never(stage() > STAGE_3B)
            && never(stage() < STAGE_3A)
            && never(buttonLeft() == 1)

        return once(primingConditions) && resetConditions && trigger_when(completeConditions)
    }

    function triggerStage4Deathless() {
        requiredConditions =
            attractMode() == ATTRACT_MODE_INACTIVE
            && inDemo() == IN_DEMO_NO
            && activePlayer() == ACTIVE_PLAYER_1

        primingConditions =
            activePlayer() == ACTIVE_PLAYER_1
            && stage() == STAGE_4A
            && frameLifeOrStageStarting()

        completeConditions =
            stage() == STAGE_4B
            && frameStageCompleted()

        resetConditions =
            never(cheatCode() == CHEAT_CODE_STAGE_SELECT)
            && never(stage() > STAGE_4B)
            && never(stage() < STAGE_4A)
            && never(frameLifeLost())

        return once(primingConditions) && resetConditions && trigger_when(completeConditions)
    }

    function triggerStage5InTime() {
        requiredConditions =
            attractMode() == ATTRACT_MODE_INACTIVE
            && inDemo() == IN_DEMO_NO
            && activePlayer() == ACTIVE_PLAYER_1

        primingConditions =
            activePlayer() == ACTIVE_PLAYER_1
            && stage() == STAGE_5
            && frameLifeOrStageStarting()

        completeConditions =
            stage() == STAGE_5
            && frameStageCompleted()
            && timeX00() > 0

        resetConditions =
            never(cheatCode() == CHEAT_CODE_STAGE_SELECT)
            && never(stage() != STAGE_5)
            && never(timeX00() == 0)

        return once(primingConditions) && resetConditions && requiredConditions && trigger_when(completeConditions)
    }

    function triggerStage6Damageless() {
        requiredConditions =
            attractMode() == ATTRACT_MODE_INACTIVE
            && inDemo() == IN_DEMO_NO
            && activePlayer() == ACTIVE_PLAYER_1

        primingConditions =
            activePlayer() == ACTIVE_PLAYER_1
            && stage() == STAGE_6
            && frameLifeOrStageStarting()

        completeConditions =
            stage() == STAGE_6
            && frameStageCompleted()

        resetConditions =
            never(cheatCode() == CHEAT_CODE_STAGE_SELECT)
            && never(stage() != STAGE_6)
            && never( byte(0x00d6) == 0x60 && gameFPS() == GAME_FPS_20 )
            && never(frameLifeLost())

        return once(primingConditions) && resetConditions && requiredConditions && trigger_when(completeConditions)
    }

    function triggerStage6NoShield() {
        requiredConditions =
            attractMode() == ATTRACT_MODE_INACTIVE
            && inDemo() == IN_DEMO_NO
            && activePlayer() == ACTIVE_PLAYER_1

        primingConditions =
            activePlayer() == ACTIVE_PLAYER_1
            && stage() == STAGE_6
            && frameLifeOrStageStarting()

        completeConditions =
            stage() == STAGE_6
            && frameStageCompleted()
            && weapon() != WEAPON_SHIELD

        resetConditions =
            never(cheatCode() == CHEAT_CODE_STAGE_SELECT)
            && never(stage() != STAGE_6)

        return once(primingConditions) && resetConditions && requiredConditions && completeConditions
    }

    function triggerHiddenCredits() {
        return
            attractMode() == ATTRACT_MODE_INACTIVE
            && inDemo() == IN_DEMO_NO
            && activePlayer() == ACTIVE_PLAYER_1
            && stage() == STAGE_7
            && prev(cheatCode()) != CHEAT_CODE_CREDITS && cheatCode() == CHEAT_CODE_CREDITS
    }
// #endregion Triggers

// #region Achievements
    // #region Progressions
        achievement(
            id = 16421,
            title = "Strange Unicorn",
            description = "Complete Stage 1",
            points = 5,
            trigger = triggerCompleteStages(STAGE_1A, STAGE_1C),
            type = "progression"
        )
        
        achievement(
            id = 16422,
            title = "Dangerous Duo",
            description = "Complete Stage 2",
            points = 10,
            trigger = triggerCompleteStages(STAGE_2A, STAGE_2D),
            type = "progression"
        )

        achievement(
            id = 16423,
            title = "Dragon Snake",
            description = "Complete Stage 3",
            points = 10,
            trigger = triggerCompleteStages(STAGE_3A, STAGE_3B),
            type = "progression"
        )

        achievement(
            id = 16424,
            title = "No New Ideas for Bosses",
            description = "Complete Stage 4",
            points = 10,
            trigger = triggerCompleteStages(STAGE_4A, STAGE_4B),
            type = "progression"
        )

        achievement(
            id = 16425,
            title = "Real Satan",
            description = "Complete Stage 5",
            points = 25,
            trigger = triggerCompleteStages(STAGE_5, STAGE_5),
            type = "progression"
        )

        achievement(
            id = 16426,
            title = "More Satans?!",
            description = "Complete Stage 6",
            points = 25,
            trigger = triggerCompleteStages(STAGE_6, STAGE_6),
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
        id = 16470,
        title = "Ace Survivor",
        description = "Run out of time during the battle with Astaroth",
        points = 25,
        trigger = triggerAstarothTimeChallenge()
    )

    achievement(
        id = 16428,
        title = "This Weapon Has No Effect...",
        description = "Complete Stage 6 without acquiring a shield",
        points = 25,
        trigger = triggerStage6NoShield()
    )

    achievement(
        id = 16463,
        title = "Hystorical Entry",
        description = "View the credits",
        points = 10,
        trigger = triggerHiddenCredits()
    )

    // #region Stage Challenges
        achievement(
            id = 16464,
            title = "Magic Panties",
            description = "Complete Stage 1 without taking damage",
            points = 10,
            trigger = triggerStage1Damageless()
        )

        achievement(
            id = 16465,
            title = "Zombie Rights Organization",
            description = "During Stage 2, reach the boss without pressing the B button",
            points = 50,
            trigger = triggerStage2NoAttack()
        )

        achievement(
            id = 16466,
            title = "Right Way to Go!",
            description = "During Stage 3, reach the boss without pressing left",
            points = 50,
            trigger = triggerStage3NoBackButton()
        )

        achievement(
            id = 16467,
            title = "Magic Armor",
            description = "Complete Stage 4 without dying",
            points = 25,
            trigger = triggerStage4Deathless()
        )

        achievement(
            id = 16468,
            title = "Fast Paced Escape",
            description = "Complete Stage 5 with at least 60 seconds remaining on the timer",
            points = 25,
            trigger = triggerStage5InTime()
        )

        achievement(
            id = 16469,
            title = "Last Action Hero",
            description = "Complete Stage 6 without being damaged",
            points = 50,
            trigger = triggerStage6Damageless()
        )
    // #endregion Stage Challenges

    // #region Achievements