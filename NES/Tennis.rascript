// Tennis
// #ID = 2017


// https://github.com/cyneprepou4uk/NES-Games-Disassembly/blob/main/Tennis/bank_ram.inc

// #region Memory Locations
    TRUE = 0x01
    FALSE = 0x00

    function inAttractMode() => byte(0x0038)
    function numberOfPlayers() => byte(0x0039) + 1
    function currentDifficulty() => byte(0x004c) + 1
    function startDifficulty() => byte(0x003a) + 1
    function gameplayState() => byte(0x003d)
        GAMEPLAY_STATE_SELECT_DIFFICULTY = 0x00
        GAMEPLAY_STATE_NEW_GAME = 0x01
        GAMEPLAY_STATE_NEW_BALL = 0x02
        GAMEPLAY_SCORE_UPDATED = 0x06
        GAMEPLAY_STATE_GAME_END = 0x0b
    function currentSet() => byte(0x0050) + 1

    function playerScoreForSet(setNumber) => low4(0x0051 + setNumber - 1)
    function computerScoreForSet(setNumber) => low4(0x0054  + setNumber - 1)
    function isSetWonByPlayer(setNumber) => bit7(0x0051 + setNumber - 1)
    function isSetWonByComputer(setNumber) => bit7(0x0054 + setNumber - 1)
    
    function lastHitter() => byte(0x005b)
        LAST_HITTER_PLAYER = 0x01
    
    function inDeuceOrTie() => byte(0x0057)
        IN_DEUCE = 0x01
        IN_TIE = 0x02
    function playerPoints() => byte(0x0058)
    function computerPoints() => byte(0x0059)
    function gamesFinished() => byte(0x005a)
    function matchesWon() => byte(0x004d)

    function playerBallShotCounter() => byte(0x0304)
    function servingTeam() => bit1(0x008d)
        SERVING_TEAM_PLAYER = 0x00
        SERVING_TEAM_CPU = 0x01

    function ballSFX() => byte(0x00ff)
        BALL_BOUNCE_ON_GROUND = 0x01
        BALL_BOUNCE_ON_OBJECT = 0x02
        BALL_NORMAL_SHOT = 0x04
        BALL_NET_SHOT = 0x10
        BALL_SERVER_SHOT = 0x20
        BALL_LOB_UP = 0x40
        BALL_LOB_DOWN = 0xc0
// #endregion Memory Locations

// #region Frames
    function frameMatchWon() {
        return
            prev(isSetWonByPlayer(1)) + prev(isSetWonByPlayer(2)) + prev(isSetWonByPlayer(3)) < 2
            && isSetWonByPlayer(1) + isSetWonByPlayer(2) + isSetWonByPlayer(3) >= 2
    }

    function framePointWon() {
        return
            prev(gameplayState()) != GAMEPLAY_SCORE_UPDATED
            && gameplayState() == GAMEPLAY_SCORE_UPDATED
            && lastHitter() == LAST_HITTER_PLAYER
    }
// #endregion Frames

// #region Triggers
    function triggerWinSinglesOnLevel(level) {
        return
            inAttractMode() == FALSE
            && numberOfPlayers() == 1
            && currentDifficulty() == level
            && frameMatchWon()
    }

    function triggerStraightSetsLevel(level) {
        return
            inAttractMode() == FALSE
            && currentDifficulty() == level
            && isSetWonByComputer(1) == FALSE
            && isSetWonByComputer(2) == FALSE
            && isSetWonByComputer(3) == FALSE
            && frameMatchWon()
    }

    function triggerStraightSetsMinLevel(level) {
        return
            inAttractMode() == FALSE
            && currentDifficulty() >= level
            && isSetWonByComputer(1) == FALSE
            && isSetWonByComputer(2) == FALSE
            && isSetWonByComputer(3) == FALSE
            && frameMatchWon()
    }

    function triggerTwo60SetsLevel(level) {
        return
            inAttractMode() == FALSE
            && currentDifficulty() == level
            
            && isSetWonByPlayer(1) == TRUE
            && playerScoreForSet(1) == 6
            && computerScoreForSet(1) == 0

            && prev(isSetWonByPlayer(2)) == FALSE
            && isSetWonByPlayer(2) == TRUE
            && playerScoreForSet(2) == 6
            && computerScoreForSet(2) == 0
    }

    function triggerTwo60SetsMinLevel(level) {
        return
            inAttractMode() == FALSE
            && currentDifficulty() >= level
            
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

    function triggerWinSetFlawless() {
        return
            inAttractMode() == FALSE
            && any_of(range(1,3), setNumber =>
                prev(isSetWonByPlayer(setNumber)) == FALSE
                && isSetWonByPlayer(setNumber) == TRUE
                && playerScoreForSet(setNumber) == 6
                && computerScoreForSet(setNumber) == 0
            )
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

    function triggerLobShotPoint() {
        // Score a point from a lob shot
        primingConditions = 
                once(
                    ballSFX() == BALL_LOB_UP 
                    && playerBallShotCounter() > 0x00
                )

        cancelConditions = 
                    never(ballSFX() == BALL_NORMAL_SHOT)
                    && never(ballSFX() == BALL_NET_SHOT)
                    && never(ballSFX() == BALL_SERVER_SHOT)

        targetConditions = 
            playerPoints() > prev(playerPoints())

        return primingConditions && cancelConditions && trigger_when(targetConditions)
    }

    function triggerLobPointsPerSet(times) {
        pauseConditions = unless(
            once(
                // Pause when last shot was NOT a lob shot
                (
                    ballSFX() == BALL_NORMAL_SHOT
                    || ballSFX() == BALL_NET_SHOT
                    || ballSFX() == BALL_SERVER_SHOT
                )
                // Unpause when last shot was a lob shot
                && never(
                    ballSFX() == BALL_LOB_UP
                    && playerBallShotCounter() > 0x00
                )
            )
        )

        resetConditions = 
            never(inAttractMode() == TRUE)
            && never(currentSet() != prev(currentSet()))

        triggerCondition =
            repeated(times, framePointWon())

        return 
            pauseConditions && measured(triggerCondition) && (resetConditions || always_false())
    }

    function triggerNetPointsPerSet(times) {
        pauseConditions = unless(
            once(
                // Pause when last shot was NOT a net shot
                (
                    ballSFX() == BALL_NORMAL_SHOT
                    || ballSFX() == BALL_LOB_UP
                    || ballSFX() == BALL_SERVER_SHOT
                )
                // Unpause when last shot was a net shot
                && never(
                    ballSFX() == BALL_NET_SHOT
                    && playerBallShotCounter() > 0x00
                )
            )
        )

        resetConditions = 
            never(inAttractMode() == TRUE)
            && never(currentSet() != prev(currentSet()))

        triggerCondition =
            repeated(times, framePointWon())

        return 
            pauseConditions && measured(triggerCondition) && (resetConditions || always_false())
    }

    function triggerAcesInSingleGame(times) {
        pauseConditions = unless(
            once(
                // Pause when last shot was NOT a serve shot
                (
                    ballSFX() == BALL_NORMAL_SHOT
                    || ballSFX() == BALL_LOB_UP
                    || ballSFX() == BALL_NET_SHOT
                )
                // Unpause when last shot was a serve shot
                && never(
                    ballSFX() == BALL_SERVER_SHOT
                )
            )
        )

        resetConditions = 
            never(inAttractMode() == TRUE)
            && never(gamesFinished() != prev(gamesFinished()))

        triggerCondition =
            repeated(times, 
                framePointWon()
                && servingTeam() == SERVING_TEAM_PLAYER
            )

        return 
            pauseConditions && measured(triggerCondition) && (resetConditions || always_false())
    }

    function triggerWinCup(minStartDifficulty) {
        return
            inAttractMode() == FALSE
            && startDifficulty() >= minStartDifficulty
            && prev(matchesWon()) == 1
            && matchesWon() == 2
    }

    function triggerWinDeuceMinPlays(balls) {
        ballsRequiredCondition = repeated(balls - 1, 
            inDeuceOrTie() == IN_DEUCE
            && (
                playerPoints() != prev(playerPoints())
                ||
                computerPoints() != prev(computerPoints())
            )
        )

        cancelConditions = 
            never(inAttractMode() == TRUE)
            && never(prev(inDeuceOrTie() != IN_DEUCE))

        triggerCondition =
            any_of(range(1, 3), setNumber =>
                playerScoreForSet(setNumber) == prev(playerScoreForSet(setNumber)) + 1
            )

        return ballsRequiredCondition && cancelConditions && trigger_when(triggerCondition)
    }
// #endregion Triggers

// #region Achievements
    // #region Level Wins
        achievement(
            id = 349659,
            title = "Break Out Ya Tennis Shoes",
            description = "Win a game of singles on Level 1",
            points = 3,
            trigger = triggerWinSinglesOnLevel(1)
        )

        achievement(
            id = 349660,
            title = "A Bit Faster",
            description = "Win a game of singles on Level 2",
            points = 5,
            trigger = triggerWinSinglesOnLevel(2)
        )

        achievement(
            id = 349661,
            title = "Quick Feet",
            description = "Win a game of singles on Level 3",
            points = 5,
            trigger = triggerWinSinglesOnLevel(3)
        )

        achievement(
            id = 349662,
            title = "Break Out Ya Running Shoes",
            description = "Win a game of singles on Level 4",
            points = 10,
            trigger = triggerWinSinglesOnLevel(4)
        )

        achievement(
            id = 349663,
            title = "Please Slow Down",
            description = "Win a game of singles on Level 5",
            points = 10,
            trigger = triggerWinSinglesOnLevel(5)
        )
    // #endregion Level Wins

    // #region Level Straight Wins
        achievement(
            id = 28255,
            title = "[DEMOTED] Baby Steps",
            description = "Beat Level 1 in straight sets",
            points = 5,
            trigger = triggerStraightSetsLevel(1)
        )

        achievement(
            id = 28256,
            title = "[DEMOTED] New Guy on Tour",
            description = "Beat Level 2 in straight sets",
            points = 10,
            trigger = triggerStraightSetsLevel(2)
        )

        achievement(
            id = 28257,
            title = "[DEMOTED] Moments Till Stardom",
            description = "Beat Level 3 in straight sets",
            points = 10,
            trigger = triggerStraightSetsLevel(3)
        )

        achievement(
            id = 28258,
            title = "Tennis Star",
            description = "Beat Level 4 or above in straight sets",
            points = 25,
            trigger = triggerStraightSetsMinLevel(4)
        )

        achievement(
            id = 28259,
            title = "[DEMOTED] Tennis Legend",
            description = "Beat Level 5 in straight sets",
            points = 50,
            trigger = triggerStraightSetsLevel(5)
        )
    // #endregion Level Straight Wins

    // #region Level 6-0, 6-0 Wins
        achievement(
            id = 28280,
            title = "[DEMOTED] Start of Something New",
            description = "Beat Level 1 in straight sets 6-0 6-0",
            points = 10,
            trigger = triggerTwo60SetsLevel(1)
        )

        achievement(
            id = 28281,
            title = "Absolute Winner",
            description = "Beat Level 2 or above with a score of 6-0, 6-0",
            points = 25,
            trigger = triggerTwo60SetsMinLevel(2)
        )

        achievement(
            id = 28282,
            title = "[DEMOTED] Three Is Usually Company",
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
        title = "[DEMOTED] First of Many",
        description = "Win the first set of a match",
        points = 5,
        trigger = triggerWinSet(1)
    )

    achievement(
        id = 28278,
        title = "[DEMOTED] Second of the Match",
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

    achievement(
        title = "Bombs Away",
        description = "Score 10 points from a lob in a single set",
        points = 5,
        trigger = triggerLobPointsPerSet(10)
    )

    achievement(
        title = "Net Superiority",
        description = "Score 10 points from the net in a single set",
        points = 5,
        trigger = triggerNetPointsPerSet(10)
    )

    achievement(
        title = "Tournament Champion",
        description = "Win the cup by winning 2 consecutive matches starting from any Level",
        points = 10,
        type = "win_condition",
        trigger = triggerWinCup(minStartDifficulty = 1)
    )

    achievement(
        title = "Grand Slam Winner",
        description = "Win the gold cup by winning 2 consecutive matches starting from Level 5",
        points = 25,
        trigger = triggerWinCup(minStartDifficulty = 5)
    )

    achievement(
        title = "Flawless Victory",
        description = "Win a set without conceding any points",
        points = 10,
        trigger = triggerWinSetFlawless()
    )

    achievement(
        title = "Pair of Aces",
        description = "Score 2 aces in a single game",
        points = 3,
        trigger = triggerAcesInSingleGame(2)
    )

    achievement(
        title = "King of Deuces",
        description = "Play through a minimum of 5 serves during a single Deuce before winning the game",
        points = 5,
        trigger = triggerWinDeuceMinPlays(5)
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
        0x02: "Tie-Break"
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
        rich_presence_value("Level", currentDifficulty()),
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