// Robo Warrior (NES)
// #ID = 1917

// #region Memory Addresses
    TRUE = 0x01
    FALSE = 0x00

    function demoMode() => byte(0x009b)
    function cheatEnabled() => byte(0x1ed)
    
    function music() => byte(0x00fa) & 0x7f
        MUSIC_ROOM_OF_IDOLS = 0x0b
    function sfx() => byte(0x00fb) & 0x7f
        SFX_ITEM_PICKUP = 0x03

    function deathTimer() => byte(0x007e)
    function playerLevel() => byte(0x0098)
    function playerRange() => byte(0x01c9)
    function itemBombQuantity() => byte(0x004c)
    function score() => byte(0x0049) * 100 + byte(0x0048) * 1000 + byte(0x0047) * 10000 + byte(0x0046) * 100000 + byte(0x0045) * 1000000

    function continuePeriod() => byte(0x0054)
    function currentPeriod() => byte(0x004a)
        PERIOD_1_1 = 0x01
        PERIOD_2_1 = 0x02
        PERIOD_2_2 = 0x03
        PERIOD_3_1 = 0x04
        PERIOD_3_2 = 0x05
        PERIOD_3_3 = 0x06
        PERIOD_4_1 = 0x07
        PERIOD_4_2 = 0x08
        PERIOD_4_3 = 0x09
        PERIOD_5_1 = 0x0a
        PERIOD_5_2 = 0x0b
        PERIOD_5_3 = 0x0c
        PERIOD_6_1 = 0x0d
        PERIOD_6_2 = 0x0e
        PERIOD_6_3 = 0x0f
        PERIOD_6_3 = 0x10
        PERIOD_7_1 = 0x11
        PERIOD_7_2 = 0x12
        PERIOD_7_3 = 0x13
        PERIOD_7_4 = 0x14
        PERIOD_7_5 = 0x15
        PERIOD_8_1 = 0x16
        PERIOD_8_2 = 0x17
        PERIOD_8_3 = 0x18
        PERIOD_8_4 = 0x19
        PERIOD_8_5 = 0x1a

    function currentMapTile() => byte(0x01c0)

    function energyMeter() => bitcount(0x01c6)
    function energyPods() => bitcount(0x01c7)


    function mainAreaTilemap(index) => byte(0x02fc + index)
        MAP_TILE_EXIT = 0x27
        MAP_TILE_WELL = 0x2a
    function hiddenTilemap(index) => byte(0x03d9 + index)
        HIDDEN_TILE_STAIRS = 0x1f
        HIDDEN_TILE_CANDLE = 0x19
    function mainAreaTilemapIndex() => byte(0x002b)
// #endregion Memory Addresses

// #region Frame Functions
    function frameDeathSequenceStarted() {
        return
            prev(deathTimer()) == 0x00
            && deathTimer() > 0x00
    }

    function frameMovedToTile(tileId) {
        return
            prev(currentMapTile() != tileId)
            && currentMapTile() == tileId
    }

    function frameHiddenTilemapRevealed(offset, tileType) {
        return
            prev(hiddenTilemap(offset)) == tileType
            && hiddenTilemap(offset) == tileType + 0x80
    }
// #endregion 

// #region Triggers
    function triggerClearPeriod(periodId) {
        return
            demoMode() == FALSE
            && cheatEnabled() == FALSE
            && energyMeter() + energyPods() > 0
            && currentPeriod() == periodId
            && frameMovedToTile(MAP_TILE_EXIT)
    }

    function triggerWellOfHope(periodId) {
        return
            demoMode() == FALSE
            && cheatEnabled() == FALSE
            && energyMeter() + energyPods() > 0
            && currentPeriod() == periodId
            && frameMovedToTile(MAP_TILE_WELL)
    }

    function triggerRoomOfIdols(periodId, totalTreasures) {
        cancelConditions =
            never(demoMode() != FALSE)
            && never(cheatEnabled() != FALSE)
            && never(energyMeter() + energyPods() == 0)
            && never(currentPeriod() != periodId)

        treasureCollected =
            music() == MUSIC_ROOM_OF_IDOLS
            && prev(currentMapTile()) > 0x1b
            && currentMapTile() <= 0x1b

        return cancelConditions && measured(repeated(totalTreasures, treasureCollected))
    }

    function triggerFindSecrets(periodId, numberOfSecrets, chaliceRequiredAfter = 0) {
        cancelConditions =
            never(demoMode() != FALSE)
            && never(cheatEnabled() != FALSE)
            && never(energyMeter() + energyPods() == 0)
            && never(currentPeriod() != periodId)

        // pauseCondition = always_true()
        // if (chaliceRequiredAfter > 0) {
        //     pauseCondition = unless()
        // }

        secretFoundConditions = []
        // Hidden Stairs
        for offset in range(0, 186) { // Stairs
            array_push(secretFoundConditions, frameHiddenTilemapRevealed(offset, HIDDEN_TILE_STAIRS))
        }
        // Hidden Walls
        for offset in range(0, 221) {
            array_push(secretFoundConditions,
                prev(mainAreaTilemap(offset)) & 0xf0 == 0xc0
                && mainAreaTilemap(offset) & 0xf0 != 0xc0
                && mainAreaTilemapIndex() == prev(mainAreaTilemapIndex())
            )
        }
        allSecretsFoundConditions = tally(numberOfSecrets, secretFoundConditions)

        return cancelConditions && measured(allSecretsFoundConditions)
    }
// #endregion Triggers

// #region Achivements
    // #region Level Clears
        achievement(
            title = "The Fringes",
            description = "Clear the first level",
            points = 5,
            trigger = triggerClearPeriod(PERIOD_1_1),
            type = "progression"
        )

        achievement(
            title = "The Outlands",
            description = "Clear the second level",
            points = 10,
            trigger = triggerClearPeriod(PERIOD_2_2),
            type = "progression"
        )

        achievement(
            title = "The Lands of Temples",
            description = "Clear the third level",
            points = 10,
            trigger = triggerClearPeriod(PERIOD_3_3),
            type = "progression"
        )

        achievement(
            title = "The Iron Hills",
            description = "Clear the forth level",
            points = 10,
            trigger = triggerClearPeriod(PERIOD_4_3),
            type = "progression"
        )

        achievement(
            title = "Intellicon",
            description = "Clear the fifth level",
            points = 10,
            trigger = triggerClearPeriod(PERIOD_5_3),
            type = "progression"
        )

        achievement(
            title = "Oceania",
            description = "Clear the sixth level",
            points = 10,
            trigger = triggerClearPeriod(PERIOD_6_3),
            type = "progression"
        )

        achievement(
            title = "Outer City",
            description = "Clear the seventh level",
            points = 25,
            trigger = triggerClearPeriod(PERIOD_7_5),
            type = "progression"
        )

        achievement(
            title = "Regency",
            description = "Clear the eigth level",
            points = 25,
            trigger = triggerClearPeriod(PERIOD_8_5),
            type = "win_condition"
        )
    // #endregion Level Clear

    // #region Well of Hope
        achievement(
            title = "Well of Hope 1-1",
            description = "Discover and use the Well of Hope from Period 1-1",
            points = 3,
            trigger = triggerWellOfHope(PERIOD_1_1)
        )

        achievement(
            title = "Well of Hope 4-1",
            description = "Discover and use the Well of Hope from Period 4-1",
            points = 3,
            trigger = triggerWellOfHope(PERIOD_4_1)
        )

        achievement(
            title = "Well of Hope 6-3",
            description = "Discover and use the Well of Hope from Period 6-3",
            points = 3,
            trigger = triggerWellOfHope(PERIOD_6_3)
        )

        achievement(
            title = "Well of Hope 7-1",
            description = "Discover and use the Well of Hope from Period 7-1",
            points = 3,
            trigger = triggerWellOfHope(PERIOD_7_1)
        )

        achievement(
            title = "Well of Hope 8-1",
            description = "Discover and use the Well of Hope from Period 8-1",
            points = 3,
            trigger = triggerWellOfHope(PERIOD_8_1)
        )
    // #endregion Well of Hope

    // #region Room of Idols
        achievement(
            title = "Room of Idols 1-1",
            description = "Discover and collect all treasures from the Room of Idols from Period 1-1",
            points = 3,
            trigger = triggerRoomOfIdols(PERIOD_1_1, 2)
        )

        achievement(
            title = "Room of Idols 2-1",
            description = "Discover and collect all treasures from the Room of Idols from Period 2-1",
            points = 3,
            trigger = triggerRoomOfIdols(PERIOD_2_1, 3)
        )

        achievement(
            title = "Room of Idols 2-2",
            description = "Discover and collect all treasures from the Room of Idols from Period 2-2",
            points = 3,
            trigger = triggerRoomOfIdols(PERIOD_2_2, 4)
        )

        achievement(
            title = "Room of Idols 3-1",
            description = "Discover and collect all treasures from the Room of Idols from Period 3-1",
            points = 3,
            trigger = triggerRoomOfIdols(PERIOD_3_1, 2)
        )

        achievement(
            title = "Room of Idols 3-2",
            description = "Discover and collect all treasures from the Room of Idols from Period 3-2",
            points = 3,
            trigger = triggerRoomOfIdols(PERIOD_3_2, 3)
        )

        achievement(
            title = "Room of Idols 4-1",
            description = "Discover and collect all treasures from the Room of Idols from Period 4-1",
            points = 3,
            trigger = triggerRoomOfIdols(PERIOD_4_1, 8)
        )

        achievement(
            title = "Room of Idols 4-2",
            description = "Discover and collect all treasures from the Room of Idols from Period 4-2",
            points = 3,
            trigger = triggerRoomOfIdols(PERIOD_4_2, 4)
        )

        achievement(
            title = "Room of Idols 4-3",
            description = "Discover and collect all treasures from the Room of Idols from Period 4-3",
            points = 3,
            trigger = triggerRoomOfIdols(PERIOD_4_3, 1)
        )

        achievement(
            title = "Room of Idols 5-1",
            description = "Discover and collect all treasures from the Room of Idols from Period 5-1",
            points = 3,
            trigger = triggerRoomOfIdols(PERIOD_5_1, 3)
        )

        achievement(
            title = "Room of Idols 5-2",
            description = "Discover and collect all treasures from the Room of Idols from Period 5-2",
            points = 3,
            trigger = triggerRoomOfIdols(PERIOD_5_2, 3)
        )

        achievement(
            title = "Room of Idols 6-1",
            description = "Discover and collect all treasures from the Room of Idols from Period 6-1",
            points = 3,
            trigger = triggerRoomOfIdols(PERIOD_6_1, 3)
        )

        achievement(
            title = "Room of Idols 6-2",
            description = "Discover and collect all treasures from the Room of Idols from Period 6-2",
            points = 3,
            trigger = triggerRoomOfIdols(PERIOD_6_2, 6)
        )

        achievement(
            title = "Room of Idols 7-1",
            description = "Discover and collect all treasures from the Room of Idols from Period 7-1",
            points = 3,
            trigger = triggerRoomOfIdols(PERIOD_7_1, 2)
        )

        achievement(
            title = "Room of Idols 7-2",
            description = "Discover and collect all treasures from the Room of Idols from Period 7-2",
            points = 3,
            trigger = triggerRoomOfIdols(PERIOD_7_2, 8)
        )

        achievement(
            title = "Room of Idols 8-2",
            description = "Discover and collect all treasures from the Room of Idols from Period 8-2",
            points = 3,
            trigger = triggerRoomOfIdols(PERIOD_8_2, 5)
        )

        achievement(
            title = "Room of Idols 8-3",
            description = "Discover and collect all treasures from the Room of Idols from Period 8-3",
            points = 3,
            trigger = triggerRoomOfIdols(PERIOD_8_3, 5)
        )
    // #endregion Room of Idols

    // #region Cave Finder
        achievement(
            title = "Cave Finder 1-1",
            description = "Uncover all hidden underground entrances and destroy all fake walls from Period 1-1 without looping",
            points = 3,
            trigger = triggerFindSecrets(PERIOD_1_1, 4)
        )
    // #endregion Cave Finder
// #endregion Achivements

// #region Leaderboards
    leaderboard(
        title = "High Score First Life",
        description = "Highest score reached on the first life, without using continue",
        format = "POINTS",
        start =
            once( prev(currentPeriod()) == 0x00 && currentPeriod() == 0x01 )
            && never(continuePeriod() != 0x00)
            && demoMode() == FALSE
            && cheatEnabled() == FALSE
            && frameDeathSequenceStarted()
        ,
        cancel = always_false(),
        submit = always_true(),
        value = score()
    )

    leaderboard(
        title = "High Score Any Life",
        description = "Highest score reached on any life, continue allowed",
        format = "POINTS",
        start =
            demoMode() == FALSE
            && cheatEnabled() == FALSE
            && frameDeathSequenceStarted()
        ,
        cancel = always_false(),
        submit = always_true(),
        value = score()
    )
// #endregion Leaderboards

// #region Rich Presence
    periodLoopkup = {
        0x00: "Opening Stage",
        0x01: "Period 1-1: The Fringes",
        0x02: "Period 2-1: The Outlands 1",
        0x03: "Period 2-2: The Outlands 2",
        0x04: "Period 3-1: The Lands of Temples 1",
        0x05: "Period 3-2: The Lands of Temples 2",
        0x06: "Period 3-3: The Lands of Temples Boss - Globula",
        0x07: "Period 4-1: The Iron Hills 1",
        0x08: "Period 4-2: The Iron Hills 2",
        0x09: "Period 4-3: The Iron Hills 3",
        0x0a: "Period 5-1: Intellicon 1",
        0x0b: "Period 5-2: Intellicon 2",
        0x0c: "Period 5-3: Intellicon Boss - Viripides ",
        0x0d: "Period 6-1: Oceania 1",
        0x0e: "Period 6-2: Oceania 2",
        0x0f: "Period 6-3: Oceania 3",
        0x10: "Period 6-3: Oceania Boss - Aquarian",
        0x11: "Period 7-1: Outer City 1",
        0x12: "Period 7-2: Outer City 2",
        0x13: "Period 7-3: Outer City Boss - Lian",
        0x14: "Period 7-4: Outer City 4",
        0x15: "Period 7-5: Outer City Boss - Pyrodine",
        0x16: "Period 8-1: Regency 1",
        0x17: "Period 8-2: Regency 2",
        0x18: "Period 8-3: Regency 3",
        0x19: "Period 8-4: Regency Boss - Gholem",
        0x1a: "Period 8-5: Regency Boss - Xur",
        0x1b: "Game Ending Credits"
    }

    rich_presence_conditional_display(
        demoMode() == FALSE
        && energyMeter() + energyPods() > 0
        ,
        "{0} ● 🔋 {1}/4 ● ⚡ {2}/8 ● {3}",
        rich_presence_lookup("Period", currentPeriod(), periodLoopkup),
        rich_presence_value("EnergyPods", energyPods()),
        rich_presence_value("EnergyMeter", energyMeter()),
        rich_presence_macro("Score", score())
    )

    rich_presence_display(
        "Preparing to fight Xantho Empire"
    )
// #endregion Rich Presence