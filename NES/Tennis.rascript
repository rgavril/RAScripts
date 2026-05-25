// Tennis
// #ID = 2017

// #region Memory Locations
    TRUE = 0x01
    FALSE = 0x00

    function inAttractMode() => byte(0x0038)
    function numberOfPlayers() => byte(0x0039) + 1
    function difficultyLevel() => byte(0x004c) + 1
    function gameplayState() => byte(0x003d)
        GAMEPLAY_STATE_SELECT_DIFFICULTY = 0x00
    function currentSet() => byte(0x0050) + 1

    function playerScoreForSet(setNumber) => low4(0x0051 + setNumber - 1)
    function computerScoreForSet(setNumber) => low4(0x0054  + setNumber - 1)
    function isSetWonByPlayer(setNumber) => bit7(0x0051 + setNumber - 1)
    function isSetWonByComputer(setNumber) => bit7(0x0054 + setNumber - 1)
    
    function inDeuceOrTie() => byte(0x0057)
    function playerPoints() => byte(0x0058)
    function computerPoints() => byte(0x0059)
    function gamesFinished() => byte(0x005a)
// #endregion Memory Locations

// #region Frames
    function frameGameWon() {
        return
            prev(isSetWonByPlayer(1)) + prev(isSetWonByPlayer(2)) + prev(isSetWonByPlayer(3)) < 2
            && isSetWonByPlayer(1) + isSetWonByPlayer(2) + isSetWonByPlayer(3) >= 2
    }
// #endregion Frames

// #region Triggers
    function triggerWinSinglesOnLevel(level) {
        return
            inAttractMode() == FALSE
            && numberOfPlayers() == 1
            && difficultyLevel() == level
            && frameGameWon()
    }

    function triggerStraightSetsLevel(level) {
        return
            inAttractMode() == FALSE
            && difficultyLevel() == level
            && isSetWonByComputer(1) == FALSE
            && isSetWonByComputer(2) == FALSE
            && isSetWonByComputer(3) == FALSE
            && frameGameWon()
    }

    function triggerTwo60SetsLevel(level) {
        return
            inAttractMode() == FALSE
            && difficultyLevel() == level
            
            && isSetWonByPlayer(1) == TRUE
            && playerScoreForSet(1) == 6
            && computerScoreForSet(1) == 0

            && prev(isSetWonByPlayer(2)) == FALSE
            && isSetWonByPlayer(2) == TRUE
            && playerScoreForSet(2) == 6
            && computerScoreForSet(2) == 0
    }

    function triggerWinGame() {
        return
            inAttractMode() == FALSE
            && any_of(range(1, 3), setNumber =>
                playerScoreForSet(setNumber) == prev(playerScoreForSet(setNumber)) + 1
            )
    }

    function triggerWinAnySet() {
        return
            inAttractMode() == FALSE
            && any_of(range(1, 3), setNumber =>
                prev(isSetWonByPlayer(setNumber)) == FALSE
                && isSetWonByPlayer(setNumber) == TRUE
            ) 
    }

    function triggerWinSet(setNumber) {
        return
            inAttractMode() == FALSE
            && prev(isSetWonByPlayer(setNumber)) == FALSE
            && isSetWonByPlayer(setNumber) == TRUE
    }

    function triggerTieBreaker() {
        return
            inAttractMode() == FALSE
            && any_of(range(1, 3), setNumber =>
                prev(playerScoreForSet(setNumber)) == 6
                && playerScoreForSet(setNumber) == 7
            )  
    }

    function triggerGamesInMatch(minGames) {
        return
            inAttractMode() == FALSE
            && prev(gamesFinished()) == minGames - 1
            && measured(gamesFinished() == minGames)
    }
// #endregion Triggers

// #region Achievements
    // #region Level Wins
        achievement(
            id = 349659,
            title = "Break Out Ya Tennis Shoes",
            description = "Win a game of singles on Level 1",
            type = "win_condition",
            points = 3,
            trigger = triggerWinSinglesOnLevel(1)
        )

        achievement(
            id = 349660,
            title = "A Bit Faster",
            description = "Win a game of singles on Level 2",
            type = "win_condition",
            points = 5,
            trigger = triggerWinSinglesOnLevel(2)
        )

        achievement(
            id = 349661,
            title = "Quick Feet",
            description = "Win a game of singles on Level 3",
            type = "win_condition",
            points = 5,
            trigger = triggerWinSinglesOnLevel(3)
        )

        achievement(
            id = 349662,
            title = "Break Out Ya Running Shoes",
            description = "Win a game of singles on Level 4",
            type = "win_condition",
            points = 10,
            trigger = triggerWinSinglesOnLevel(4)
        )

        achievement(
            id = 349663,
            title = "Please Slow Down",
            description = "Win a game of singles on Level 5",
            type = "win_condition",
            points = 25,
            trigger = triggerWinSinglesOnLevel(5)
        )
    // #endregion Level Wins

    // #region Level Straight Wins
        achievement(
            id = 28255,
            title = "Baby Steps",
            description = "Beat Level 1 in straight sets",
            points = 5,
            trigger = triggerStraightSetsLevel(1)
        )

        achievement(
            id = 28256,
            title = "New Guy on Tour",
            description = "Beat Level 2 in straight sets",
            points = 10,
            trigger = triggerStraightSetsLevel(2)
        )

        achievement(
            id = 28257,
            title = "Moments Till Stardom",
            description = "Beat Level 3 in straight sets",
            points = 10,
            trigger = triggerStraightSetsLevel(3)
        )

        achievement(
            id = 28258,
            title = "Tennis Star",
            description = "Beat Level 4 in straight sets",
            points = 25,
            trigger = triggerStraightSetsLevel(4)
        )

        achievement(
            id = 28259,
            title = "Tennis Legend",
            description = "Beat Level 5 in straight sets",
            points = 50,
            trigger = triggerStraightSetsLevel(5)
        )
    // #endregion Level Straight Wins

    // #region Level 6-0, 6-0 Wins
        achievement(
            id = 28280,
            title = "Start of Something New",
            description = "Beat Level 1 in straight sets 6-0 6-0",
            points = 10,
            trigger = triggerTwo60SetsLevel(1)
        )

        achievement(
            id = 28281,
            title = "Two to Tango",
            description = "Beat Level 2 in straight sets 6-0 6-0",
            points = 25,
            trigger = triggerTwo60SetsLevel(2)
        )

        achievement(
            id = 28282,
            title = "Three Is Usually Company",
            description = "Beat Level 3 in straight sets 6-0 6-0",
            points = 25,
            trigger = triggerTwo60SetsLevel(3)
        )
    // #endregion Level 6-0, 6-0 Wins

    achievement(
        id = 28274,
        title = "Game",
        description = "Win a game in any match",
        points = 3,
        trigger = triggerWinGame()
    )

    achievement(
        id = 28275,
        title = "Set",
        description = "Win a set in any match",
        points = 5,
        trigger = triggerWinAnySet()
    )

    achievement(
        id = 28276,
        title = "Tie Breaker",
        description = "Win a tie-breaker game",
        points = 3,
        trigger = triggerTieBreaker()
    )

    achievement(
        id = 28283,
        title = "Long Match Day",
        description = "Play 38 or more games in a single match",
        points = 10,
        trigger = triggerGamesInMatch(38)
    )

    achievement(
        id = 28277,
        title = "First of Many",
        description = "Win the first set of a match",
        points = 5,
        trigger = triggerWinSet(1)
    )

    achievement(
        id = 28278,
        title = "Second of the Match",
        description = "Win the second set of a match",
        points = 5,
        trigger = triggerWinSet(2)
    )

    achievement(
        id = 28279,
        title = "Final Set",
        description = "Win the third set of a match",
        points = 5,
        trigger = triggerWinSet(3)
    )
// #endregion Achievements

// #region Rich Presence
    gameTypeLookup = {
        1: "Single",
        2: "Double"
    }

    pointTypeLookup = {
        0x00: "Points",
        0x01: "Deuce",
        0x02: "Tie-Break    "
    }

    playerPointsLookup = {
        0x0000: "0",
        0x0001: "15",
        0x0002: "30",
        0x0003: "40",

        0x0100: "0",
        0x0101: "A",
        
        0x0200: "0",
        0x0201: "1",
        0x0202: "2",
        0x0203: "3",
        0x0204: "4",
        0x0205: "5",
        0x0206: "6",
        0x0207: "7"
    }

    rich_presence_conditional_display(
        inAttractMode() != TRUE
        && gameplayState() != GAMEPLAY_STATE_SELECT_DIFFICULTY
        // && currentSet() == 1
        ,
        "Level {1} • {0} • Sets {10}-{11} ({4}-{5}, {6}-{7}, {8}-{9}) • {12} {2}-{3}",
        rich_presence_lookup("GameType", numberOfPlayers(), gameTypeLookup),
        rich_presence_value("Level", difficultyLevel()),
        rich_presence_lookup("Points", inDeuceOrTie() * 0x100 + playerPoints(), playerPointsLookup),
        rich_presence_lookup("Points", inDeuceOrTie() * 0x100 + computerPoints(), playerPointsLookup),
        rich_presence_value("Game", playerScoreForSet(1)),
        rich_presence_value("Game", computerScoreForSet(1)),
        rich_presence_value("Game", playerScoreForSet(2)),
        rich_presence_value("Game", computerScoreForSet(2)),
        rich_presence_value("Game", playerScoreForSet(3)),
        rich_presence_value("Game", computerScoreForSet(3)),
        rich_presence_value("Set", isSetWonByPlayer(1) + isSetWonByPlayer(2) + isSetWonByPlayer(3)),
        rich_presence_value("Set", isSetWonByComputer(1) + isSetWonByComputer(2) + isSetWonByComputer(3)),
        rich_presence_lookup("PoinsType", inDeuceOrTie(), pointTypeLookup)
    )

    rich_presence_display("In Attract Mode")
// #endregion Rich Presence