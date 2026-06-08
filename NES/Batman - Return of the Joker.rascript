// Batman: Return of the Joker
// #ID = 4559

// #region Memory Locations
    ENCODED = [0xfe]
    for value in range(1,127) {
        array_push(ENCODED, (value-1)*2)
    }

   function stage() => byte(0x0400)
        STAGE_1_1 = 0x00
        STAGE_1_2 = 0x02
        STAGE_1_3 = 0x04
        STAGE_2_1 = 0x06
        STAGE_2_2 = 0x08
        STAGE_3_1 = 0x0a
        STAGE_3_2 = 0x0c
        STAGE_3_3 = 0x0e
        STAGE_4_1 = 0x10
        STAGE_4_2 = 0x12
        STAGE_4_3 = 0x14
        STAGE_5_1 = 0x16
        STAGE_5_2 = 0x18
        STAGE_6_1 = 0x1a
        STAGE_6_2 = 0x1c
        STAGE_6_3 = 0x1e
        STAGE_7_1 = 0x20
        STAGE_7_2 = 0x22

    function stageSection() => byte(0x402)
        SECTION_1 = 0x00
        SECTION_2 = 0x02
        SECTION_3 = 0x04
        SECTION_MAIN_MENU = 0xff

    function energyCapsules() => byte(0x0477)
    function health() => byte(0x0478)

    function bossFightBatmanHealth() => word(0x00b2) * 10
    function bossFightEnemyHealth() => word_be(0x00a9) * 10

    function musicStart() => byte(0x0041)
// #endregion Memory Locations

// #region Frames
    function frameBossDied() {
        return
            prev(bossFightEnemyHealth()) > 0
            && bossFightEnemyHealth() == 0
    }

    function frameInGameplay() {
        return
            prev(stageSection()) != SECTION_MAIN_MENU
            && stageSection() != SECTION_MAIN_MENU
    }
// #endregion Frames

// #region Triggers
    function triggerWinBossFight(stageId) {
        return
            stage() == stageId
            && bossFightBatmanHealth() > 0
            && frameBossDied()
    }

    function triggerWinBossFightEnergy(stageId, energy) {
        return
            stage() == stageId
            && bossFightBatmanHealth() >= energy
            && trigger_when(frameBossDied())
    }

    function triggerStageCompleted(stageId) {
        return
            frameInGameplay()
            && prev(stage()) == stageId
            && stage() == stageId + 2
    }

    function triggerEnergyCapsules(quantity) {
        return
            frameInGameplay()
            && prev(energyCapsules() != ENCODED[quantity])
            && energyCapsules() == ENCODED[quantity]
    }

    function triggerDamagelessSubStage(stageId) {

        stageMusicTheme = {
            STAGE_1_1: 0x04,
            STAGE_1_2: 0x04,
            STAGE_1_3: 0x03,
            STAGE_2_1: 0x0b,
            STAGE_2_2: 0x07,
            STAGE_3_1: 0x09,
            STAGE_3_2: 0x09,
            STAGE_3_3: 0x03,
            STAGE_4_1: 0x05,
            STAGE_4_2: 0x05,
            STAGE_4_3: 0x03,
            STAGE_5_1: 0x0b,
            STAGE_5_2: 0x07,
            STAGE_6_1: 0x04,
            STAGE_6_2: 0x04,
            STAGE_6_3: 0x03,
            STAGE_7_1: 0x0c,
            STAGE_7_2: 0x03
        }

        primingConditions = 
            once(
                stage() == stageId
                && prev(musicStart()) != stageMusicTheme[stageId]
                && musicStart() == stageMusicTheme[stageId]
            )

        cancelConditions =
            never(stage() != stageId && prev(stage()) != stageId)
            && never(health() != prev(health()))

        targetConditions = 
            prev(stage()) == stageId
            && stage() == stageId + 2

        return primingConditions && cancelConditions && trigger_when(targetConditions)
    }
// #endregion Triggers

// #region Achievements
    achievement(
        id = 21892,
        title = "Beyond Batman",
        description = "Get 8 energy capsules and become invincible!",
        points = 5,
        trigger = triggerEnergyCapsules(8)
    )

    // #region Progressions
        achievement(
            id = 21880,
            title = "Bat in the Belfry",
            description = "Defend Gotham Cathedral by defeating Ace Ranger and his airship!",
            points = 5,
            type = "progression",
            trigger = triggerStageCompleted(STAGE_1_3)
        )

        achievement(
            id = 21881,
            title = "A Bat-Jetpack!?",
            description = "Destroy the Joker's weapons stockpiles!",
            points = 5,
            type = "progression",
            trigger = triggerStageCompleted(STAGE_2_2)
        )

        achievement(
            id = 21882,
            title = "Batman on Ice",
            description = "Foil the Joker's mining scheme by defeating his Minedroid!",
            points = 10,
            type = "progression",
            trigger = triggerStageCompleted(STAGE_3_3)
        )

        achievement(
            id = 21883,
            title = "Deja Vu",
            description = "Shut down the Joker's explosives refinery by taking out the Master CPU!",
            points = 10,
            type = "progression",
            trigger = triggerStageCompleted(STAGE_4_3)
        )

        achievement(
            id = 21884,
            title = "Sewer Surfin'",
            description = "Make your way to the Joker's missile silo through the Gotham sewers!",
            points = 10,
            type = "progression",
            trigger = triggerStageCompleted(STAGE_5_2)
        )

        achievement(
            id = 21885,
            title = "The Army's a Joke",
            description = "Put a stop to the Joker's deadly plans and defeat his flying machine!",
            points = 25,
            type = "progression",
            trigger = triggerStageCompleted(STAGE_6_3)
        )
        
        achievement(
            id = 21886,
            title = "Outer Heaven",
            description = "Chase the Joker to his island hideout and take him out, once and for all!",
            points = 25,
            type = "win_condition",
            trigger = triggerWinBossFight(STAGE_7_2)
        )
    // #endregion Progressions

    // #region Boss Fight Health Challenges
        achievement(
            id = 21889,
            title = "Ace of Aces",
            description = "Defeat Ace Ranger in stage 1 without taking damage.",
            points = 10,
            trigger = triggerWinBossFightEnergy(STAGE_1_3, 80000)
        )

        achievement(
            id = 21890,
            title = "Batman & Robot",
            description = "Defeat the Joker's Minedroid in stage 3 without taking damage.",
            points = 10,
            trigger = triggerWinBossFightEnergy(STAGE_3_3, 80000)
        )

        achievement(
            id = 21931,
            title = "Oracle? Who Needs Her?",
            description = "Defeat the Master CPU in stage 4 with 70,000 or more health remaining.",
            points = 25,
            trigger = triggerWinBossFightEnergy(STAGE_4_3, 70000)
        )

        achievement(
            id = 21891,
            title = "The Killing Joke",
            description = "Defeat the Joker's flying machine in stage 6 with 75,000 or more health remaining.",
            points = 25,
            trigger = triggerWinBossFightEnergy(STAGE_6_3, 75000)
        )
    // #endregion Boss Fight Health Challenges

    // #region Damageless Stages
        achievement(
            id = 21933,
            title = "Gargoyle",
            description = "Clear the Gotham Cathedral, stage 1-1, without taking damage.",
            points = 10,
            trigger = triggerDamagelessSubStage(STAGE_1_1)
        )

        achievement(
            id = 21934,
            title = "The Batman's Natural Habitat",
            description = "Clear the City Rooftops, stage 1-2, without taking damage.",
            points = 10,
            trigger = triggerDamagelessSubStage(STAGE_1_2)
        )

        achievement(
            id = 21935,
            title = "More Slippery Than You Look",
            description = "Clear the Ice Valley, stage 3-1, without taking damage.",
            points = 25,
            trigger = triggerDamagelessSubStage(STAGE_3_1)
        )

        achievement(
            id = 21936,
            title = "Pizza Power",
            description = "Clear the Sewer System, stage 5-1, without taking damage.",
            points = 25,
            trigger = triggerDamagelessSubStage(STAGE_5_1)
        )
    // #endregion Damageless Stages
// #endregion Achievements