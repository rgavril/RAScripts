// Vice: Project Doom
// #ID = 2060

// #region Memory Addresses
    TRUE = 0x01
    FALSE = 0x00

    function cheatActive() => byte(0x0093)

    function playerIsDead() => bit3(0x0160)

    function stageEndFlag() => byte(0x036b)
    function currSceneMode() => byte(0x0090)
    function nextSceneMode() => byte(0x0095)
    function currSceneIndex() => byte(0x0092)
    function nextSceneIndex() => byte(0x0097)
        STAGE_1_1 = 0x07
        STAGE_2_2 = 0x06
        STAGE_3_2 = 0x0b
        STAGE_4_2 = 0x26
        STAGE_5_3 = 0x17
        STAGE_6_3 = 0x16
        STAGE_7_3 = 0x2e
        STAGE_8_3 = 0x20
        STAGE_9_3 = 0x25
        STAGE_10_1 = 0x27
        STAGE_11_1 = 0x28
        STAGE_11_3 = 0x2c
        STAGE_11_4 = 0x2d
    function currSceneState() => byte(0x0091)
        STAGE_STATE_START = 0x00
        STAGE_STATE_ACTIVE = 0x01

    function time() => byte(0x035e)
    function lives() => byte(0x0362)
    function coins() => byte(0x0361)
    function grenades() => byte(0x0360)
    function bullets() => byte(0x035f)
    function health() => byte(0x0280)
    function score() => word(0x0363) * 100
// #endregion Memory Addresses

// #region Frame Functions
    function frameStageEndFlagSet() {
        return
            prev(stageEndFlag()) == FALSE
            && stageEndFlag() != FALSE
    }
// #endregion Frame Functions

// #region Triggers
    function triggerStageClear(stageIndex) {
        requiredConditions =
            cheatActive() == FALSE
            && currSceneMode() < 0x0b
            && currSceneIndex() == stageIndex
            && playerIsDead() == FALSE
            && frameStageEndFlagSet()

        return requiredConditions
    }

    function triggerStageSpeedrun(stageIndex, timeLeft) {
        return
            triggerStageClear(stageIndex)
            && time() >= timeLeft
        
        // Challange Indicator Version:
        // primingConditions =
        //     once(
        //         currSceneMode() < 0x0b
        //         && currSceneIndex() == stageIndex
        //         && currSceneState() == STAGE_STATE_START
        //     )

        // cancelConditions =
        //     never( cheatActive() != FALSE )
        //     && never( time() < timeLeft )

        // targetConditions =
        //     playerIsDead() == FALSE
        //     && frameStageEndFlagSet()

        // return primingConditions && cancelConditions && trigger_when(targetConditions)
    }

    function triggerScore(targetScore) {
        return
            cheatActive() == FALSE
            && currSceneMode() < 0x0b
            && prev(score()) < targetScore
            && score() >= targetScore
    }
// #endregion Triggers

// #region Achievements
    // #region Progression
        achievement(
            id = 22065,
            title = "Highway Patrol",
            description = "Take down the rogue driver on Route 246 and complete Stage 1",
            points = 5,
            type = "progression",
            trigger = triggerStageClear(STAGE_1_1)
        )

        achievement(
            id = 22066,
            title = "Murder on the Girders",
            description = "Defeat \"your guardian angel\" in the construction site and complete Stage 2",
            points = 5,
            type = "progression",
            trigger = triggerStageClear(STAGE_2_2)
        )

        achievement(
            id = 22067,
            title = "Urban Black Magic",
            description = "Defeat Kim Ron in Chinatown and complete Stage 3",
            points = 5,
            type = "progression",
            trigger = triggerStageClear(STAGE_3_2)
        )

        achievement(
            id = 22068,
            title = "Party in the CSA",
            description = "Fight your way through the industrial area and complete Stage 4",
            points = 5,
            type = "progression",
            trigger = triggerStageClear(STAGE_4_2)
        )

        achievement(
            id = 22069,
            title = "Tanks for the Vacation",
            description = "Defeat the M5 Scorpion in the jungles of Central America and complete Stage 5",
            points = 10,
            type = "progression",
            trigger = triggerStageClear(STAGE_5_3)
        )

        achievement(
            id = 22070,
            title = "Blades & Ladders",
            description = "Defeat the PCU-100 Vardkin in the factory and complete Stage 6",
            points = 10,
            type = "progression",
            trigger = triggerStageClear(STAGE_6_3)
        )

        achievement(
            id = 22071,
            title = "A Chip on My Shoulder",
            description = "Defeat the PCU-10 Rogue in the sewers and complete Stage 7",
            points = 10,
            type = "progression",
            trigger = triggerStageClear(STAGE_7_3)
        )

        achievement(
            id = 22072,
            title = "High-Voltage Nightmare",
            description = "Fight your way through the power plant and complete Stage 8",
            points = 10,
            type = "progression",
            trigger = triggerStageClear(STAGE_8_3)
        )

        achievement(
            id = 22073,
            title = "Everything but the Girl",
            description = "Fight your way through the Bio-Tech Lab and complete Stage 9",
            points = 10,
            type = "progression",
            trigger = triggerStageClear(STAGE_9_3)
        )

        achievement(
            id = 22074,
            title = "Death in the Fast Lane",
            description = "Take down the serpent on the way to the BEDA building and complete Stage 10",
            points = 10,
            type = "progression",
            trigger = triggerStageClear(STAGE_10_1)
        )

        achievement(
            id = 22075,
            title = "War-Torn Welcome",
            description = "Shoot down BEDA's forces at the entrance to the building and complete Stage 11-1",
            points = 10,
            type = "progression",
            trigger = triggerStageClear(STAGE_11_1)
        )

        achievement(
            id = 22076,
            title = "Hart to Hart",
            description = "Defeat Damian Hawke in the BEDA Corporation HQ and complete Stage 11-3",
            points = 10,
            type = "progression",
            trigger = triggerStageClear(STAGE_11_3)
        )

        achievement(
            id = 22077,
            title = "Every Dog Has Its Day...",
            description = "Defeat Damian Hawke's true form in Stage 11-4 and complete the game",
            points = 25,
            type = "win_condition",
            trigger = triggerStageClear(STAGE_11_4)
        )
    // #endregion Progression

    achievement(
        id = 22084,
        title = "Hitting the Speed Limit",
        description = "Complete Stage 1 with at least 203 seconds left",
        points = 10,
        trigger = triggerStageSpeedrun(STAGE_1_1, timeLeft=203)
    )

    // achievement(
    //     id = 22079,
    //     title = "Speedrun of Steel",
    //     description = "Defeat the Stage 2-2 boss within 8 seconds",
    //     points = 10,
    //     trigger = triggerStageSpeedrun(STAGE_2_2, timeLeft=250-8)
    // )

    achievement(
        id = 22181,
        title = "And It Was Fast as Lightning",
        description = "Complete Stage 3 with at least 239 seconds left",
        points = 10,
        trigger = triggerStageSpeedrun(STAGE_3_2, timeLeft=239)
    )

    achievement(
        id = 22183,
        title = "Bladed Blitz",
        description = "Complete Stage 6 with at least 236 seconds left",
        points = 25,
        trigger = triggerStageSpeedrun(STAGE_6_3, timeLeft=236)
    )

    achievement(
        id = 22182,
        title = "Mercenary Instincts",
        description = "Score 332,700 points",
        points = 25,
        trigger = triggerScore(332700)
    )
// #endregion Achievement

// #region Rich Presence
    stageNameLookup = {
        0x00 : "Stage 4-1",
        0x02 : "Stage 2-1",
        0x03 : "Stage 2-1",
        0x04 : "Stage 2-1",
        0x05 : "Stage 2-1",
        0x06 : "Stage 2-2",
        0x07 : "Stage 1-1",
        0x08 : "Stage 3-1",
        0x09 : "Stage 3-1",
        0x0a : "Stage 3-1",
        0x0b : "Stage 3-2",
        0x0c : "Stage 5-1",
        0x0d : "Stage 5-1",
        0x0e : "Stage 5-2",
        0x0f : "Stage 5-2",
        0x10 : "Stage 7-1",
        0x11 : "End Credits",
        0x12 : "Stage 6-1",
        0x13 : "Stage 6-1",
        0x14 : "Stage 6-1",
        0x15 : "Stage 6-2",
        0x16 : "Stage 6-3",
        0x17 : "Stage 5-3",
        0x18 : "Stage 7-2",
        0x19 : "Stage 7-2",
        0x1a : "Stage 7-2",
        0x1b : "Stage 7-2",
        0x1c : "Stage 8-1",
        0x1d : "Stage 8-1",
        0x1e : "Stage 8-1",
        0x1f : "Stage 8-2",
        0x20 : "Stage 8-3",
        0x21 : "Stage 9-1",
        0x22 : "Stage 9-1",
        0x23 : "Stage 9-1",
        0x24 : "Stage 9-2",
        0x25 : "Stage 9-3",
        0x26 : "Stage 4-2",
        0x27 : "Stage 10-1",
        0x28 : "Stage 11-1",
        0x29 : "Stage 11-2",
        0x2a : "Stage 11-2",
        0x2b : "Stage 11-2",
        0x2c : "Stage 11-3",
        0x2d : "Stage 11-4",
        0x2e : "Stage 7-3",
        0x2f : "Stage 6-2",
        0x30 : "Stage 8-2"
    }

    rich_presence_conditional_display(
        currSceneMode() < 0x0b,
        "{0} ● {1} Lives ● 🔫 {2} ● 💣 {3} ● 💰 {4} ● {5}",
        rich_presence_lookup("Stage", currSceneIndex(), stageNameLookup),
        rich_presence_value("Lives", lives()),
        rich_presence_value("Bullets", bullets()),
        rich_presence_value("Grenades", grenades()),
        rich_presence_value("Coins", coins()),
        rich_presence_macro("Score", score())
    )

    rich_presence_conditional_display(
        nextSceneMode() < 0x0b,
        "{0} ● {1} Lives ● 🔫 {2} ● 💣 {3} ● 💰 {4} ● {5}",
        rich_presence_lookup("Stage", nextSceneIndex(), stageNameLookup),
        rich_presence_value("Lives", lives()),
        rich_presence_value("Bullets", bullets()),
        rich_presence_value("Grenades", grenades()),
        rich_presence_value("Coins", coins()),
        rich_presence_macro("Score", score())
    )

    rich_presence_display("In Attract Mode")
    
// #endregion Rich Presence