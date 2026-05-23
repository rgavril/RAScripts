// Tennis
// #ID = 2017

// #region Memory Locations
    TRUE = 0x01
    FALSE = 0x00

    function inAttractMode() => byte(0x0038)
    function numberOfPlayers() => byte(0x0039) + 1
    function difficultyLevel() => byte(0x003a) + 1
    function gameplayState() => byte(0x003d)
        GAMEPLAY_STATE_SELECT_DIFFICULTY = 0x00
    function currentSet() => byte(0x0050) + 1

    function playerScoreForSet(setNumber) => low4(0x0051 + setNumber - 1)
    function computerScoreForSet(setNumber) => low4(0x0054  + setNumber - 1)
    function isSetWonByPlayer(setNumber) => bit7(0x0051 + setNumber - 1)
    function isSetWonByComputer(setNumber) => bit7(0x0054 + setNumber - 1)
    
    function inDeuce() => byte(0x0057)
    function playerPoints() => byte(0x0058)
    function computerPoints() => byte(0x0059)
// #endregion Memory Locations


// #region Rich Presence
    gameTypeLookup = {
        1: "Single",
        2: "Double"
    }

    playerPointsLookup = {
        0x0000: "0",
        0x0001: "15",
        0x0002: "30",
        0x0003: "40",
        0x0100: "40",
        0x0101: "A"
    }

    rich_presence_conditional_display(
        inAttractMode() != TRUE
        && gameplayState() != GAMEPLAY_STATE_SELECT_DIFFICULTY
        // && currentSet() == 1
        ,
        "Level {1} • {0} • Sets {10}-{11} ({4}-{5}, {6}-{7}, {8}-{9}) • Points {2}-{3}",
        rich_presence_lookup("GameType", numberOfPlayers(), gameTypeLookup),
        rich_presence_value("Level", difficultyLevel()),
        rich_presence_lookup("Points", inDeuce() * 0x100  + playerPoints(), playerPointsLookup),
        rich_presence_lookup("Points", inDeuce() * 0x100  + computerPoints(), playerPointsLookup),
        rich_presence_value("Game", playerScoreForSet(1)),
        rich_presence_value("Game", computerScoreForSet(1)),
        rich_presence_value("Game", playerScoreForSet(2)),
        rich_presence_value("Game", computerScoreForSet(2)),
        rich_presence_value("Game", playerScoreForSet(3)),
        rich_presence_value("Game", computerScoreForSet(3)),
        rich_presence_value("Set", isSetWonByPlayer(1) + isSetWonByPlayer(2) + isSetWonByPlayer(3)),
        rich_presence_value("Set", isSetWonByComputer(1) + isSetWonByComputer(2) + isSetWonByComputer(3))
    )

    rich_presence_display("In Attract Mode")
// #endregion Rich Presence