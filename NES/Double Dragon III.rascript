// Double Dragon III (NES)
// #ID = 1662

// #region Memory Locations
    function gameType() => byte(0x0034)
        GAME_TYPE_1P = 0x00
        GAME_TYPE_2P_A = 0x80
        GAME_TYPE_2P_B = 0xc0

    function stage() => byte(0x00f4)
        STAGE_1_USA = 0x00
        STAGE_2_CHINA = 0x01
        STAGE_3_JAPAN = 0x02
        STAGE_4_ITALY = 0x03
        STAGE_5_EGYPT = 0x04

    function subStage() => byte(0x00f3)

    function player1Char() => byte(0x0074)
    function player2Char() => byte(0x0075)
        PLAY_AS_BILLY = 0x00
        PLAY_AS_JIMMY = 0x01
        PLAY_AS_RANZOU = 0x02
        PLAY_AS_CHIN = 0x03

    function player1Health() => byte(0x045d)
    function player2Health() => byte(0x045e)
// #endregion

// #section Rich Presence
    stageLookup = {
        0x00: "USA",
        0x01: "China",
        0x02: "Japan",
        0x03: "Italy",
        0x04: "Egypt"
    }
    
    charLookup = {
        0x00: "Billy",
        0x01: "Jimmy",
        0x02: "Ranzou",
        0x03: "Chin"
    }

    gameTypeLookup = {
        0x00: "1P Game",
        0x80: "2P Game A",
        0xc0: "2P Game B"
    }

    rich_presence_conditional_display(
        player1Health() > 0 && player2Health() == 0,
        "Stage {0} · {1} · Playing as {2} in {3}",
        rich_presence_value("Stage", stage() + 1),
        rich_presence_lookup("GameType", gameType(), gameTypeLookup),
        rich_presence_lookup("Char", player1Char(), charLookup),
        rich_presence_lookup("Location", stage(), stageLookup)
    )

    rich_presence_conditional_display(
        player1Health() == 0 && player2Health() > 0,
        "Stage {0} · {1} · Playing as {2} in {3}",
        rich_presence_value("Stage", stage() + 1),
        rich_presence_lookup("GameType", gameType(), gameTypeLookup),
        rich_presence_lookup("Char", player2Char(), charLookup),
        rich_presence_lookup("Location", stage(), stageLookup)
    )

    rich_presence_conditional_display(
        player1Health() > 0 && player2Health() > 0,
        "Stage {0} · {1} · Playing as {2} and {3} in {4}",
        rich_presence_value("Stage", stage() + 1),
        rich_presence_lookup("GameType", gameType(), gameTypeLookup),
        rich_presence_lookup("Char", player1Char(), charLookup),
        rich_presence_lookup("Char", player2Char(), charLookup),
        rich_presence_lookup("Location", stage(), stageLookup)
    )

    rich_presence_display(
        "Playing Double Dragon III"
    )
// #endsection