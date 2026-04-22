// Robo Warrior (NES)
// #ID = 1917

// #region Memory Addresses
    TRUE = 0x01
    FALSE = 0x00

    function demoMode() => byte(0x009b)
    function cheatEnabled() => byte(0x1ed)
    
    function music() => byte(0x00fa) & 0x7f
        MUSIC_OVERWORLD_1 = 0x01
        MUSIC_OVERWORLD_2 = 0x03
        MUSIC_ROOM_OF_IDOLS = 0x0b
    function sfx() => byte(0x00fb)
        SFX_ITEM_PICKUP = 0x03

    function deathTimer() => byte(0x007e)
    function playerLevel() => byte(0x0098)
    function playerRange() => byte(0x01c9)
    function itemBombQuantity() => byte(0x004c)
    function itemLampQuantity() => byte(0x004f)
    function chaliceCollected() => byte(0x0069)
    function currenSelectedItem() => byte(0x0099)
        SELECTED_ITEM_LAMP = 0x03
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
    function lightState() => byte(0x006d)
        LIGHT_FULL = 0x00
        LIGHT_DARK = 0x01
        LIGHT_CANDLE = 0x81

    function currentArea() => byte(0x00cd)
        MAIN_AREA = 0x00
        HIDDEN_AREA = 0x01
    function mainAreaTilemap(index) => byte(0x02fc + index)
        MAP_TILE_EXIT = 0x27
        MAP_TILE_WELL = 0x2a
    function hiddenTilemap(index) => byte(0x03d9 + index)
        HIDDEN_TILE_STAIRS = 0x1f
        HIDDEN_TILE_CANDLE = 0x19
    function mainAreaTilemapIndex() => byte(0x002b)
    function mainAreaTotalScroll() => byte(0x00dd)
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
            && prev(sfx()) != SFX_ITEM_PICKUP
            && sfx() == SFX_ITEM_PICKUP

        return cancelConditions && measured(repeated(totalTreasures, treasureCollected))
    }

    function triggerFindSecrets(periodId, numberOfSecrets, chaliceRequiredAfter = 0) {
        cancelConditions =
            never(demoMode() != FALSE)
            && never(cheatEnabled() != FALSE)
            && never(energyMeter() + energyPods() == 0)
            && never(currentPeriod() != periodId)

        pauseCondition = always_true()
        if (chaliceRequiredAfter > 0) {
            pauseCondition = unless(
                once(
                    currentPeriod() == periodId
                    && mainAreaTotalScroll() > chaliceRequiredAfter
                    && chaliceCollected() == FALSE
                    && never(energyMeter() + energyPods() == 0)
                )
            )
        }

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

        return cancelConditions && pauseCondition && measured(allSecretsFoundConditions)
    }

    function triggerCandleOnly(periodId) {
        primingConditions =
            once (
                (music() == MUSIC_OVERWORLD_1 || music() == MUSIC_OVERWORLD_2)
                && lightState() == LIGHT_DARK
            )

        cancelConditions =
            never(demoMode() != FALSE)
            && never(cheatEnabled() != FALSE)
            && never(energyMeter() + energyPods() == 0)
            && never(currentPeriod() != periodId)
            && never(
                itemLampQuantity() < prev(itemLampQuantity())
                && lightState() == LIGHT_FULL
            )

        targetConditions = 
            frameMovedToTile(MAP_TILE_EXIT)

        return primingConditions && cancelConditions && trigger_when(targetConditions)
    }
// #endregion Triggers

// #region Achivements
    // #region Period 1-1
        achievement(
            title = "Reboot Initiated",
            description = "Complete Period 1-1",
            points = 5,
            trigger = triggerClearPeriod(PERIOD_1_1),
            type = "progression"
        )

        achievement(
            title = "Altile's Baptism",
            description = "Discover and use the Well of Hope from Period 1-1",
            points = 2,
            trigger = triggerWellOfHope(PERIOD_1_1)
        )

        achievement(
            title = "Fringe Demolitionist",
            description = "Uncover all hidden underground entrances and destroy all fake walls from Period 1-1 without looping",
            points = 3,
            trigger = triggerFindSecrets(PERIOD_1_1, 4, chaliceRequiredAfter = 0x1c)
        )

        achievement(
            title = "Test of the First Idol",
            description = "Discover and collect all treasures from the Room of Idols from Period 1-1",
            points = 2,
            trigger = triggerRoomOfIdols(PERIOD_1_1, 2)
        )
    // #endregion

    // #region Period 2-1
        achievement(
            title = "Outland Reconnaissance",
            description = "Complete Period 2-1",
            points = 5,
            trigger = triggerClearPeriod(PERIOD_2_1),
            type = "progression"
        )

        achievement(
            title = "Wasteland Cartographer",
            description = "Uncover all hidden underground entrances and destroy all fake walls from Period 2-1",
            points = 3,
            trigger = triggerFindSecrets(PERIOD_2_1, 8)
        )

        achievement(
            title = "Favor of the Barrens",
            description = "Discover and collect all treasures from the Room of Idols from Period 2-1",
            points = 2,
            trigger = triggerRoomOfIdols(PERIOD_2_2, 3)
        )
    // #endregion

    // #region Period 2-2
        achievement(
            title = "The Emerald Passage",
            description = "Complete Period 2-2",
            points = 5,
            trigger = triggerClearPeriod(PERIOD_2_2),
            type = "progression"
        )

        achievement(
            title = "Outland Flare",
            description = "Complete Period 2-2 without using a lamp",
            points = 5,
            trigger = triggerCandleOnly(PERIOD_2_2)
        )

        achievement(
            title = "Structural Exposure",
            description = "Uncover all hidden underground entrances and destroy all fake walls from Period 2-2",
            points = 2,
            trigger = triggerFindSecrets(PERIOD_2_2, 4)
        )

        achievement(
            title = "Obscure Grace",
            description = "Discover and collect all treasures from the Room of Idols from Period 2-2",
            points = 3,
            trigger = triggerRoomOfIdols(PERIOD_2_2, 4)
        )
    // #endregion

    // #region Period 3-1
        achievement(
            title = "Hallowed Return",
            description = "Complete Period 3-1",
            points = 5,
            trigger = triggerClearPeriod(PERIOD_3_1),
            type = "progression"
        )

        achievement(
            title = "Sacred Blueprint",
            description = "Uncover all hidden underground entrances and destroy all fake walls from Period 3-1 without looping",
            points = 5,
            trigger = triggerFindSecrets(PERIOD_3_1, 7, chaliceRequiredAfter = 0x24)
        )

        achievement(
            title = "Trial of the Trinity",
            description = "Discover and collect all treasures from the Room of Idols from Period 3-1",
            points = 3,
            trigger = triggerRoomOfIdols(PERIOD_3_1, 2)
        )
    // #endregion

    // #region Period 3-2
        achievement(
            title = "Sanctum Penetration",
            description = "Complete Period 3-2",
            points = 5,
            trigger = triggerClearPeriod(PERIOD_3_2),
            type = "progression"
        )

        achievement(
            title = "Temple Infrastructure",
            description = "Uncover all hidden underground entrances and destroy all fake walls from Period 3-2",
            points = 3,
            trigger = triggerFindSecrets(PERIOD_3_2, 5)
        )

        achievement(
            title = "Origin of the Grace",
            description = "Discover and collect all treasures from the Room of Idols from Period 3-2",
            points = 3,
            trigger = triggerRoomOfIdols(PERIOD_3_2, 3)
        )
    // #endregion

    // #region Period 3-3 (Boss: Globula)
        achievement(
            title = "Lord of the Amoebas",
            description = "Defeat Globula and complete Period 3-3",
            points = 5,
            trigger = triggerClearPeriod(PERIOD_3_3),
            type = "progression"
        )
    // #endregion

    // #region Period 4-1
        achievement(
            title = "Iron Hills Entry",
            description = "Complete Period 4-1",
            points = 10,
            trigger = triggerClearPeriod(PERIOD_4_1),
            type = "progression"
        )

        achievement(
            title = "Rust-Free Waters",
            description = "Discover and use the Well of Hope from Period 4-1",
            points = 2,
            trigger = triggerWellOfHope(PERIOD_4_1)
        )

        achievement(
            title = "Iron Ore Prospector",
            description = "Uncover all hidden underground entrances and destroy all fake walls from Period 4-1",
            points = 10,
            trigger = triggerFindSecrets(PERIOD_4_1, 20)
        )

        achievement(
            title = "The Miner's Icons",
            description = "Discover and collect all treasures from the Room of Idols from Period 4-1",
            points = 5,
            trigger = triggerRoomOfIdols(PERIOD_4_1, 8)
        )
    // #endregion

    // #region Period 4-2
        achievement(
            title = "The Steel Divide",
            description = "Complete Period 4-2",
            points = 10,
            trigger = triggerClearPeriod(PERIOD_4_2),
            type = "progression"
        )

        achievement(
            title = "Shadow of the Forge",
            description = "Complete Period 4-2 without using a lamp",
            points = 10,
            trigger = triggerCandleOnly(PERIOD_4_2)
        )

        achievement(
            title = "Idols of the Iron Deep",
            description = "Discover and collect all treasures from the Room of Idols from Period 4-2",
            points = 5,
            trigger = triggerRoomOfIdols(PERIOD_4_2, 4)
        )

        achievement(
            title = "Iron Hills Excavator",
            description = "Uncover all hidden underground entrances and destroy all fake walls from Period 4-2, the first time you pass them and without looping more than once",
            points = 10,
            trigger = 
                unless( mainAreaTotalScroll() > 0x4a && mainAreaTotalScroll() < 0x8d )
                && triggerFindSecrets(PERIOD_4_2, 7, chaliceRequiredAfter = 0x4a) 
        )
    // #endregion

    // #region Period 4-3
        achievement(
            title = "Strongroom Escape",
            description = "Complete Period 4-3",
            points = 5,
            trigger = triggerClearPeriod(PERIOD_4_3),
            type = "progression"
        )

        achievement(
            title = "Silver Maze Designer",
            description = "Uncover all hidden underground entrances and destroy all fake walls from Period 4-1",
            points = 10,
            trigger = triggerFindSecrets(PERIOD_4_3, 15)
        )

        achievement(
            title = "Iron Lion of Zion",
            description = "Discover and collect all treasures from the Room of Idols from Period 4-3",
            points = 2,
            trigger = triggerRoomOfIdols(PERIOD_4_3, 1)
        )


    // #endregion

    // #region Period 5-1
        achievement(
            title = "Technological Hub Crossing",
            description = "Clear Period 5-1",
            points = 25,
            trigger = triggerClearPeriod(PERIOD_5_1),
            type = "progression"
        )

        achievement(
            title = "Circuit Breaker",
            description = "Uncover all hidden underground entrances and destroy all fake walls from Period 5-1 without looping",
            points = 10,
            trigger = triggerFindSecrets(PERIOD_5_1, 12, chaliceRequiredAfter=0x35)
        )

        achievement(
            title = "Tech-Lords Altar",
            description = "Discover and collect all treasures from the Room of Idols from Period 5-1",
            points = 3,
            trigger = triggerRoomOfIdols(PERIOD_5_1, 3)
        )
    // #endregion

    // #region Period 5-2
        achievement(
            title = "Intellicon Dead-Zone",
            description = "Clear Period 5-2",
            points = 5,
            trigger = triggerClearPeriod(PERIOD_5_2),
            type = "progression"
        )

        achievement(
            title = "Void Surveyor",
            description = "Uncover all hidden underground entrances and destroy all fake walls from Period 5-2",
            points = 5,
            trigger = triggerFindSecrets(PERIOD_5_2, 3)
        )

        achievement(
            title = "Hidden Logic Icons",
            description = "Discover and collect all treasures from the Room of Idols from Period 5-2",
            points = 3,
            trigger = triggerRoomOfIdols(PERIOD_5_2, 3)
        )
    // #endregion

    // #region Period 5-3 (Boss: Viripides)
        achievement(
            title = "Lord of the Dragons",
            description = "Defeat Viripides and complete Period 5-3",
            points = 5,
            trigger = triggerClearPeriod(PERIOD_5_3),
            type = "progression"
        )
    // endregion

    // #region Period 6-1
        achievement(
            title = "Progress 6-1",
            description = "Clear Period 6-1",
            points = 10,
            trigger = triggerClearPeriod(PERIOD_6_1),
            type = "progression"
        )

        achievement(
            title = "Secrets 6-1",
            description = "Uncover all hidden underground entrances and destroy all fake walls from Period 6-1",
            points = 5,
            trigger = triggerFindSecrets(PERIOD_6_1, 9)
        )

        achievement(
            title = "Room of Idols 6-1",
            description = "Discover and collect all treasures from the Room of Idols from Period 6-1",
            points = 3,
            trigger = triggerRoomOfIdols(PERIOD_6_1, 3)
        )


    // #endregion

    // #region Well of Hope
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

    // #region Candle Only Levels
        achievement(
            title = "Candle Light 6-3",
            description = "Complete Period 6-3 without using a lamp",
            points = 10,
            trigger = triggerCandleOnly(PERIOD_6_3)
        )

        achievement(
            title = "Cangle Light 8-2",
            description = "Complete Period 8-2 without using a lamp",
            points = 10,
            trigger = triggerCandleOnly(PERIOD_8_2)
        )
    // #endregion
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