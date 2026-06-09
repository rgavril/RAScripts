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
    function livesRemaining() => byte(0x0482)

    function weapon() => byte(0x0476)
        WEAPON_DEFAULT = 0x00
        WEAPON_B = 0x01
        WEAPON_C = 0x02
        WEAPON_N = 0x03
        WEAPON_S = 0x04
        WEAPON_BACKPACK = 0x05

    function chargeAttackState() => byte(0x00b8)
        CHARGE_ATTACK_DISABLED = 0x00
        CHARGE_ATTACK_DISCHARGED = 0x80
        CHARGE_ATTACK_CHARGING = 0xc0
        CHARGE_ATTACK_CHARGED = 0xe0

    function backpackChargeAttack() => byte(0x0481)

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

    function triggerDamegelessStage(stageNumber) {
        stageIdStart = {
            2: STAGE_2_1,
            5: STAGE_5_1
        }

        stageIdEnd = {
            2: STAGE_2_2,
            5: STAGE_5_2
        }

        return
            frameInGameplay()
            && health() == 0x0e
            && prev(stage()) == stageIdEnd[stageNumber]
            && stage() == stageIdEnd[stageNumber] + 2
    }

    function triggerBackpackChargedInStage(stageId) {
        return
            stage() == stageId
            && weapon() == WEAPON_BACKPACK
            && prev(backpackChargeAttack()) == 0x00
            && backpackChargeAttack() == 0x80
    }
// #endregion Triggers

// #region Achievements
    achievement(
        id = 21892,
        title = "Beyond Batman",
        description = "Become invincible by collecting 8 energy capsules",
        points = 5,
        trigger = triggerEnergyCapsules(8)
    )

    achievement(
        id = 21893,
        title = "Bat-Nuke",
        description = "Use the backpack super power up weapon in Stage 4-1",
        points = 5,
        trigger = triggerBackpackChargedInStage(STAGE_4_1)
    )

    // #region Progressions
        achievement(
            id = 21880,
            title = "Bat in the Belfry",
            description = "Clear Stage 1: Gotham City Cathedral and defat Ace Ranger",
            points = 5,
            type = "progression",
            trigger = triggerStageCompleted(STAGE_1_3)
        )

        achievement(
            id = 21881,
            title = "A Bat-Jetpack!?",
            description = "Clear Stage 2: The Joker's Warehouse",
            points = 5,
            type = "progression",
            trigger = triggerStageCompleted(STAGE_2_2)
        )

        achievement(
            id = 21882,
            title = "Batman on Ice",
            description = "Clear Stage 3: Snow Mountain and defeat Minedroid",
            points = 10,
            type = "progression",
            trigger = triggerStageCompleted(STAGE_3_3)
        )

        achievement(
            id = 21883,
            title = "Deja Vu",
            // Clear Stage 4: Refinery and halt explosives production by taking out the Master CPU
            description = "Clear Stage 4: Joker's Refinery and defeat Master CPU",
            points = 10,
            type = "progression",
            trigger = triggerStageCompleted(STAGE_4_3)
        )

        achievement(
            id = 21884,
            title = "Sewer Surfin'",
            description = "Clear Stage 5: Underground Conduit",
            points = 10,
            type = "progression",
            trigger = triggerStageCompleted(STAGE_5_2)
        )

        achievement(
            id = 21885,
            title = "The Army's a Joke",
            description = "Clear Stage 6: Ammunition Base and defeat Jocker's flying machine",
            points = 25,
            type = "progression",
            trigger = triggerStageCompleted(STAGE_6_3)
        )
        
        achievement(
            id = 21886,
            title = "Outer Heaven",
            description = "Clear Stage 7: Island of Ha-Hacienda and defeat Joker once and for all",
            points = 25,
            type = "win_condition",
            trigger = triggerWinBossFight(STAGE_7_2)
        )
    // #endregion Progressions

    // #region Boss Fight Health Challenges
        achievement(
            id = 21889,
            title = "Ace of Aces",
            description = "Defeat Ace Ranger in Stage 1-3 without taking damage",
            points = 10,
            trigger = triggerWinBossFightEnergy(STAGE_1_3, 80000)
        )

        achievement(
            id = 21890,
            title = "Batman & Robot",
            description = "Defeat Minedroid in Stage 3-3 without taking damage",
            points = 10,
            trigger = triggerWinBossFightEnergy(STAGE_3_3, 80000)
        )

        achievement(
            id = 21931,
            title = "Oracle? Who Needs Her?",
            description = "Defeat the Master CPU in Stage 4-3 with 70,000 or more health remaining",
            points = 25,
            trigger = triggerWinBossFightEnergy(STAGE_4_3, 70000)
        )

        achievement(
            id = 21891,
            title = "The Killing Joke",
            description = "Defeat the Joker's flying machine in Stage 6-3 with 75,000 or more health remaining",
            points = 25,
            trigger = triggerWinBossFightEnergy(STAGE_6_3, 75000)
        )

        achievement(
            id = 21888,
            title = "One Last Laugh",
            description = "Defeat the Joker in Stage 7-2 with any weapon other than the Crossbow",
            points = 25,
            trigger = weapon() != WEAPON_C && triggerWinBossFight(STAGE_7_2)
        )

        achievement(
            id = 21887,
            title = "I Am the Night!",
            description = "Defeat the Joker in Stage 7-2 with two lives remaining",
            points = 25,
            trigger = livesRemaining() == 2 && triggerWinBossFight(STAGE_7_2)
        )
    // #endregion Boss Fight Health Challenges

    // #region Damageless Sub Stages
        achievement(
            id = 21933,
            title = "Gargoyle",
            description = "Clear Stage 1-1 without taking damage",
            points = 10,
            trigger = triggerDamagelessSubStage(STAGE_1_1)
        )

        achievement(
            id = 21934,
            title = "The Batman's Natural Habitat",
            description = "Clear Stage 1-2 without taking damage",
            points = 10,
            trigger = triggerDamagelessSubStage(STAGE_1_2)
        )

        achievement(
            id = 21935,
            title = "More Slippery Than You Look",
            description = "Clear Stage 3-1 without taking damage",
            points = 25,
            trigger = triggerDamagelessSubStage(STAGE_3_1)
        )

        achievement(
            id = 21936,
            title = "Pizza Power",
            description = "Clear Stage 5-1 without taking damage",
            points = 25,
            trigger = triggerDamagelessSubStage(STAGE_5_1)
        )
    // #endregion Damageless Sub Stages

    // #region Damageless Stages
        achievement(
            id = 21930,
            title = "Jetpack Master",
            description = "Clear all of Stage 2 with full health remaining",
            points = 10,
            trigger = triggerDamegelessStage(2)
        )

        achievement(
            id = 21932,
            title = "Frogman",
            description = "Clear all of Stage 5 with full health remaining",
            points = 10,
            trigger = triggerDamegelessStage(5)
        )
    // #endregion Damageless Stages
// #endregion Achievements

// #region Rich Presence
    stageNumberLookup = {
        0x00: "1-1",
        0x02: "1-2",
        0x04: "1-3",
        0x06: "2-1",
        0x08: "2-2",
        0x0a: "3-1",
        0x0c: "3-2",
        0x0e: "3-3",
        0x10: "4-1",
        0x12: "4-2",
        0x14: "4-3",
        0x16: "5-1",
        0x18: "5-2",
        0x1a: "6-1",
        0x1c: "6-2",
        0x1e: "6-3",
        0x20: "7-1",
        0x22: "7-2"
    }

    stageNameLookup = {
        0x00: "Cathedral",
        0x02: "City Rooftops",
        0x04: "Ace Ranger",
        0x06: "Assembly Line",
        0x08: "Weapons Plant",
        0x0a: "Ice Valley",
        0x0c: "Excavation Mine",
        0x0e: "Minedroid",
        0x10: "Weapons Express",
        0x12: "Assembly Plant",
        0x14: "Master CPU",
        0x16: "Sewer System",
        0x18: "Deserted Tunnel",
        0x1a: "Missile Silo",
        0x1c: "Tank #329",
        0x1e: "The Joker",
        0x20: "Tiki Jungle",
        0x22: "Final Battle"
    }

    weaponLookup = {
        0x00: "Default",
        0x01: "Batarang",
        0x02: "Cross Bow",
        0x03: "Sonic Neutralizer",
        0x04: "Shield Star"
    }

    rich_presence_conditional_display(
        stageSection() != SECTION_MAIN_MENU && livesRemaining() != 0xff,
        "Stage {0}: {1} • Weapon: {2} • Lives: {3}",
        rich_presence_lookup("StageNumber", stage(), stageNumberLookup),
        rich_presence_lookup("StageName", stage(), stageNameLookup),
        rich_presence_lookup("Weapon", weapon(), weaponLookup),
        rich_presence_value("Lives", livesRemaining())
    )

    rich_presence_conditional_display(
        stageSection() != SECTION_MAIN_MENU && livesRemaining() == 0xff,
        "Stage {0}: {1} • Continue Screen",
        rich_presence_lookup("StageNumber", stage(), stageNumberLookup),
        rich_presence_lookup("StageName", stage(), stageNameLookup)
    )

    rich_presence_display(
        "In Main Menu"
    )


// #endregion Rich Presence