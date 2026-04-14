// Robo Warrior (NES)
// #ID = 1917

// #region Memory Addresses
    TRUE = 0x01
    FALSE = 0x00

    function demoMode() => byte(0x009b)
    function cheatEnabled() => byte(0x1ed)

    function playerLevel() => byte(0x0098)
    function playerRange() => byte(0x01c9)
    function itemBombQuantity() => byte(0x004c)
    function score() => byte(0x0049) * 100 + byte(0x0048) * 1000 + byte(0x0047) * 10000 + byte(0x0046) * 100000 + byte(0x0045) * 1000000

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
// #endregion Memory Addresses

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