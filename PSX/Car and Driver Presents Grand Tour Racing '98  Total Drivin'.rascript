// Car and Driver Presents Grand Tour Racing '98 | Total Drivin'
// #ID = 25969

// #region Memory Addresses
    function gameState() => dword(0x0c1718)
    GAME_STATE_NULL = 0x00000000
    GAME_STATE_IN_FRONTEND = 0x24e720c6
    GAME_STATE_IN_GAME = 0x80090e58
    GAME_STATE_PAUSE_MENU_MAIN = 0x800ac898
    GAME_STATE_PAUSE_MENU_PICTURE = 0x800acadc 
    GAME_STATE_PAUSE_MENU_SOUND = 0x800acba0
    GAME_STATE_PAUSE_MENU_QUIT = 0x800ac6a8
    GAME_STATE_DEMO_GAMEPLAY = 0x8009046c
    GAME_STATE_EXIT_GAMEPLAY = 0x800883e4

    function frontendScreen() => word(0x02690c)
    SCREEN_MAIN_MENU = 0x00
    SCREEN_RACE_RESULTS = 0x0c

    function selectedLocation() => word(0x026910)
    LOCATION_MOSCOW = 0x00
    LOCATION_EASTER_ISLAND = 0x01
    LOCATION_SWITZERLAND = 0x02
    LOCATION_SCOTLAND = 0x03
    LOCATION_HONG_KONG = 0x04
    LOCATION_EGYPT = 0x05

    function selectedPlayMode() => word(0x026912)
    PLAY_MODE_SINGLE_PLAYER = 0x00
    PLAY_MODE_TIME_ATTACK = 0x01
    PLAY_MODE_SEASON = 0x02
    PLAY_MODE_SPLIT_SCREEN = 0x03
    PLAY_MODE_HEAD_TO_HEAD = 0x04

    function selectedTeam() => word(0x02691a)
    TEAM_AHMED = 0x00
    TEAM_MORGEN = 0x01
    TEAM_ROSSI = 0x02
    TEAM_XU = 0x03
    TEAM_LUMIERE = 0x04
    TEAM_ROBERTS = 0x05
    TEAM_IVANOV = 0x06
    TEAM_BAPTISTE = 0x07

    function selectedRaceTrack() => word(0x026918)

    function currentRaceTotalLaps() => dword(0x0bd168)
    function currentRaceTrack() => dword(0x0ba810)
    function currentRaceLocation() => dword(0x0bb498)

    function currentSeasonRaceNumber() => byte(0x026e56) + 1
    function currentSeasonTeam() => byte(0x026e57)
    function currentSeasonPoints(teamID) => byte(0x026e4e + teamID)
    function previousRacePosition(teamID) => byte(0x026e46 + teamID)

    function playerPointer() => tbyte(0x0b70f8)
    function playerPosition() => dword(tbyte(0x0b70f8)+0x590)
    function playerteamID() => byte(tbyte(0x0b70f8)+0x128)
    function playerLap() => byte(tbyte(0x0b70f8)+0x574)
    function playerGameOver() => byte(tbyte(0x0b70f8)+0x619)
    function playerLap1Time() => dword(tbyte(0x0b70f8)+0x57c)
    function playerLap2Time() => dword(tbyte(0x0b70f8)+0x580)
    function playerLap3Time() => dword(tbyte(0x0b70f8)+0x584)
    function playerRaceTime() => dword(tbyte(0x0b70f8)+0x578)

    function speed() => word(0x0bca1c)

    function raceCountdownTimer() => dword(0x0bc394)

    function SplitScreenTopCarPointer() => dword(0x0c26a0)
    function SplitScreenBottomCarPointer() => dword(0x0c26a4)
// #endregion Memory Addresses

    teamLookup = {
        0: "Ahmed",
        1: "Morgen",
        2: "Rossi",
        3: "Xu",
        4: "Lumiere",
        5: "Roberts",
        6: "Ivanov",
        7: "Baptiste"
    }

    locationLookup = {
        0: "Moscow",
        1: "Easter Island",
        2: "Switzerland",
        3: "Scotland",
        4: "Hong Kong",
        5: "Egypt"
    }

// #region Frame Functions
    function frameRaceCountdownTimerStarted() {
        return
            prev(raceCountdownTimer()) == 0
            && raceCountdownTimer() == 0x5f
    }

    function frameGameStateSwitchedToInGame() {
        return
            prev(gameState()) == GAME_STATE_NULL
            && gameState() == GAME_STATE_IN_GAME
    }

    function frameSeasonRaceResultsAppeared() {
        return
            gameState() == GAME_STATE_IN_FRONTEND
            && prev(frontendScreen()) != SCREEN_RACE_RESULTS
            && frontendScreen() == SCREEN_RACE_RESULTS
    }

    function framePlayerLapIncreased() {
        return
            playerLap() == prev(playerLap()) + 1
    }

    function frameProgressedToSeasonRace(raceNumber) {
        return
            prev(currentSeasonRaceNumber()) == raceNumber - 1
            && currentSeasonRaceNumber() == raceNumber
    }

    function frameSeasonPointsDecreased(teamID) {
        return
            prev(currentSeasonPoints(teamID)) > currentSeasonPoints(teamID)
    }

    function frameLapCompleted() {
        return
            playerLap() == prev(playerLap()) + 1
    }

    function frameRaceCompleted() {
        return
            prev(playerLap()) == currentRaceTotalLaps()
            && playerLap() == currentRaceTotalLaps() + 1
    }
// #endregion Frame Functions

// #region Complex Conditions
    function isTeamOnTopSeasonPosition(teamID) {
        betterSeasonPosition = always_true()

        // Iterate thorough all teams
        for otherTeamID in range(0,7) {
            if (otherTeamID != teamID) {
                betterSeasonPosition = betterSeasonPosition
                    && __ornext(
                        (
                            currentSeasonPoints(teamID) == currentSeasonPoints(otherTeamID)
                            && previousRacePosition(teamID) < previousRacePosition(otherTeamID)
                        ) || (
                            currentSeasonPoints(teamID) > currentSeasonPoints(otherTeamID)
                        )
                    )
            }
        }

        return betterSeasonPosition
    }

    function whenLastSeasonRaceResultsAppeared() {
        return
            selectedPlayMode() == PLAY_MODE_SEASON
            && currentSeasonRaceNumber() == 6
            && frameSeasonRaceResultsAppeared()
    }
// #endregion Complex Conditions

// #region Achivement Triggers
    function triggerRaceWin(location, track) {
        return
            currentRaceLocation() == location
            && currentRaceTrack() == track
            && playerPointer() != 0

            && frameRaceCompleted()
            && playerPosition() == 1

            && once ( frameGameStateSwitchedToInGame())
            && once ( frameRaceCountdownTimerStarted() )

            && never( gameState() == GAME_STATE_DEMO_GAMEPLAY )
            && never( gameState() == GAME_STATE_EXIT_GAMEPLAY )
            && never( playerGameOver() > 0)
    }

    function triggerTimeTrial(location, track, time) {
        return
            currentRaceLocation() == location
            && currentRaceTrack() == track
            && playerPointer() != 0
            
            && frameLapCompleted()
            && (
                ( playerLap() == 2 && playerLap1Time() < (time[0]*60*100 + time[1]*100 + time[2]) * 3/10 )
                ||
                ( playerLap() > 2 && playerLap2Time() < (time[0]*60*100 + time[1]*100 + time[2]) * 3/10 )
            )

            && once ( frameGameStateSwitchedToInGame())
            && once ( frameRaceCountdownTimerStarted() )

            && never( gameState() == GAME_STATE_DEMO_GAMEPLAY )
            && never( gameState() == GAME_STATE_EXIT_GAMEPLAY )
            && never( playerGameOver() > 0)
    }

    function triggerLapMagic(laps, delay) {
        winConditions =
            playerPosition() == 1
            && playerLap() == currentRaceTotalLaps() + 1

        primingConditions =
            playerPointer() != 0
            && playerRaceTime() > delay * 3/10 * 100
            && currentRaceTotalLaps() == laps
            && once ( frameGameStateSwitchedToInGame() )
            && once ( frameRaceCountdownTimerStarted() )

        cancelConditions =
            never( gameState() == GAME_STATE_DEMO_GAMEPLAY )
            && never( gameState() == GAME_STATE_EXIT_GAMEPLAY )
            && never( playerGameOver() > 0 )
            && never( speed() != 0 && playerRaceTime() <= delay * 3/10 * 100 )

        return primingConditions && cancelConditions && trigger_when(winConditions)
    }

    function triggerUltimateSeason(teamID) {
        winConditions =
            currentSeasonTeam() == teamID
            && whenLastSeasonRaceResultsAppeared()
            && isTeamOnTopSeasonPosition(teamID)

        checkpointConditions =
            // Track that a progression was made through all 6 season races
            once( frameProgressedToSeasonRace(2) )
            && once( frameProgressedToSeasonRace(3) )
            && once( frameProgressedToSeasonRace(4) )
            && once( frameProgressedToSeasonRace(5) )
            && once( frameProgressedToSeasonRace(6) )

        cancelConditions =
            // Cancel was season was aborted or a old state was loaded
            never (
                any_of(range(0,7), teamID => frameSeasonPointsDecreased(teamID))
            )

            // Cancel if a season race is started in any location less than level 6
            && never(
                gameState() == GAME_STATE_IN_GAME
                && selectedPlayMode() == PLAY_MODE_SEASON
                && frameRaceCountdownTimerStarted()
                && currentRaceTrack() < 6
            )

        return checkpointConditions && cancelConditions && winConditions
    }

    function triggerTopSeason() {
        winConditions =
            whenLastSeasonRaceResultsAppeared()
            && any_of( range(0,7), teamID => 
                currentSeasonTeam() == teamID 
                && isTeamOnTopSeasonPosition(teamID)
            )

        checkpointConditions =
            // Track that a progression was made through all 6 season races
            once( frameProgressedToSeasonRace(2) )
            && once( frameProgressedToSeasonRace(3) )
            && once( frameProgressedToSeasonRace(4) )
            && once( frameProgressedToSeasonRace(5) )
            && once( frameProgressedToSeasonRace(6) )

        cancelConditions =
            // Cancel was season was aborted or a old state was loaded
            never (
                any_of(range(0,7), teamID => frameSeasonPointsDecreased(teamID))
            )

        return checkpointConditions && cancelConditions && winConditions
    }

    function triggerGoldSeason() {
        return
            triggerTopSeason()

            // Cancel when selected team has finished a race but is not on top position
            && none_of(range(0,7), teamID =>
                currentSeasonTeam() == teamID
                && frameSeasonRaceResultsAppeared()
                && previousRacePosition(teamID) != 1
            )
    }
// #endregion Achivement Triggers

// #region Achievements
    // #region Moscow Race Challanges
        achievement(
            id          = 551773,
            title       = "Moscow Beginner",
            description = "Finish 1st place on the Moscow Level 1 track with any team during One Player or Season gameplay",
            points      = 3,
            trigger     = triggerRaceWin(LOCATION_MOSCOW, 1)
        )

        achievement(
            id          = 552471,
            title       = "Moscow Experienced",
            description = "Finish 1st place on the Moscow Level 2 track with any team during One Player or Season gameplay",
            points      = 5,
            trigger     = triggerRaceWin(LOCATION_MOSCOW, 2)
        )

        achievement(
            id          = 552472,
            title       = "Moscow Profecient",
            description = "Finish 1st place on the Moscow Level 3 track with any team during One Player or Season gameplay",
            points      = 5,
            trigger     = triggerRaceWin(LOCATION_MOSCOW, 3)
        )

        achievement(
            id          = 552473,
            title       = "Moscow Expert",
            description = "Finish 1st place on the Moscow Level 4 track with any team during One Player or Season gameplay",
            points =      10,
            trigger =     triggerRaceWin(LOCATION_MOSCOW, 4)
        )

        achievement(
            id          = 552474,
            title       = "Moscow Master",
            description = "Finish 1st place on the Moscow Level 5 track with any team during One Player or Season gameplay",
            points =      10,
            trigger =     triggerRaceWin(LOCATION_MOSCOW, 5)
        )

        achievement(
            id          = 552475,
            title       = "Moscow Champion",
            description = "Finish 1st place on the Moscow Level 6 track with any team during One Player or Season gameplay",
            points      = 10,
            trigger     = triggerRaceWin(LOCATION_MOSCOW, 6)
        )
    // #endregion Moscow Race Challanges

    // #region Easter Island Race Challanges
        achievement(
            id          = 552991,
            title       = "Easter Island Beginner",
            description = "Finish 1st place on the Easter Island Level 1 track with any team during One Player or Season gameplay",
            points      = 3,
            trigger     = triggerRaceWin(LOCATION_EASTER_ISLAND, 1)
        )

        achievement(
            id          = 552992,
            title       = "Easter Island Experienced",
            description = "Finish 1st place on the Easter Island Level 2 track with any team during One Player or Season gameplay",
            points      = 5,
            trigger     = triggerRaceWin(LOCATION_EASTER_ISLAND, 2)
        )

        achievement(
            id          = 552993,
            title       = "Easter Island Profecient",
            description = "Finish 1st place on the Easter Island Level 3 track with any team during One Player or Season gameplay",
            points      = 5,
            trigger     = triggerRaceWin(LOCATION_EASTER_ISLAND, 3)
        )

        achievement(
            id          = 552994,
            title       = "Easter Island Expert",
            description = "Finish 1st place on the Easter Island Level 4 track with any team during One Player or Season gameplay",
            points =      10,
            trigger =     triggerRaceWin(LOCATION_EASTER_ISLAND, 4)
        )

        achievement(
            id          = 552995,
            title       = "Easter Island Master",
            description = "Finish 1st place on the Easter Island Level 5 track with any team during One Player or Season gameplay",
            points =      10,
            trigger =     triggerRaceWin(LOCATION_EASTER_ISLAND, 5)
        )

        achievement(
            id          = 552996,
            title       = "Easter Island Champion",
            description = "Finish 1st place on the Easter Island Level 6 track with any team during One Player or Season gameplay",
            points      = 10,
            trigger     = triggerRaceWin(LOCATION_EASTER_ISLAND, 6)
        )
    // #endregion Easter Island Race Challanges

    // #region Switzerland Race Challanges
        achievement(
            id          = 552997,
            title       = "Switzerland Beginner",
            description = "Finish 1st place on the Switzerland Level 1 track with any team during One Player or Season gameplay",
            points      = 3,
            trigger     = triggerRaceWin(LOCATION_SWITZERLAND, 1)
        )

        achievement(
            id          = 552998,
            title       = "Switzerland Experienced",
            description = "Finish 1st place on the Switzerland Level 2 track with any team during One Player or Season gameplay",
            points      = 5,
            trigger     = triggerRaceWin(LOCATION_SWITZERLAND, 2)
        )

        achievement(
            id          = 552999,
            title       = "Switzerland Profecient",
            description = "Finish 1st place on the Switzerland Level 3 track with any team during One Player or Season gameplay",
            points      = 5,
            trigger     = triggerRaceWin(LOCATION_SWITZERLAND, 3)
        )

        achievement(
            id          = 553000,
            title       = "Switzerland Expert",
            description = "Finish 1st place on the Switzerland Level 4 track with any team during One Player or Season gameplay",
            points =      10,
            trigger =     triggerRaceWin(LOCATION_SWITZERLAND, 4)
        )

        achievement(
            id          = 553001,
            title       = "Switzerland Master",
            description = "Finish 1st place on the Switzerland Level 5 track with any team during One Player or Season gameplay",
            points =      10,
            trigger =     triggerRaceWin(LOCATION_SWITZERLAND, 5)
        )

        achievement(
            id          = 553002,
            title       = "Switzerland Champion",
            description = "Finish 1st place on the Switzerland Level 6 track with any team during One Player or Season gameplay",
            points      = 10,
            trigger     = triggerRaceWin(LOCATION_SWITZERLAND, 6)
        )
    // #endregion Switzerland Race Challanges

    // #region Scotland Race Challanges
        achievement(
            title       = "Scotland Beginner",
            description = "Finish 1st place on the Scotland Level 1 track with any team during One Player or Season gameplay",
            points      = 3,
            trigger     = triggerRaceWin(LOCATION_SCOTLAND, 1),
            id          = 553004
        )

        achievement(
            title       = "Scotland Experienced",
            description = "Finish 1st place on the Scotland Level 2 track with any team during One Player or Season gameplay",
            points      = 5,
            trigger     = triggerRaceWin(LOCATION_SCOTLAND, 2),
            id          = 553005
        )

        achievement(
            title       = "Scotland Profecient",
            description = "Finish 1st place on the Scotland Level 3 track with any team during One Player or Season gameplay",
            points      = 5,
            trigger     = triggerRaceWin(LOCATION_SCOTLAND, 3),
            id          = 553006
        )

        achievement(
            title       = "Scotland Expert",
            description = "Finish 1st place on the Scotland Level 4 track with any team during One Player or Season gameplay",
            points =      10,
            trigger =     triggerRaceWin(LOCATION_SCOTLAND, 4),
            id          = 553007
        )

        achievement(
            title       = "Scotland Master",
            description = "Finish 1st place on the Scotland Level 5 track with any team during One Player or Season gameplay",
            points =      10,
            trigger =     triggerRaceWin(LOCATION_SCOTLAND, 5),
            id          = 553008
        )

        achievement(
            title       = "Scotland Champion",
            description = "Finish 1st place on the Scotland Level 6 track with any team during One Player or Season gameplay",
            points      = 10,
            trigger     = triggerRaceWin(LOCATION_SCOTLAND, 6),
            id          = 553009
        )
    // #endregion Scotland Race Challanges

    // #region Hong Kong Race Challanges
        achievement(
            title       = "Hong Kong Beginner",
            description = "Finish 1st place on the Hong Kong Level 1 track with any team during One Player or Season gameplay",
            points      = 3,
            trigger     = triggerRaceWin(LOCATION_HONG_KONG, 1),
            id          = 552477
        )

        achievement(
            title       = "Hong Kong Experienced",
            description = "Finish 1st place on the Hong Kong Level 2 track with any team during One Player or Season gameplay",
            points      = 5,
            trigger     = triggerRaceWin(LOCATION_HONG_KONG, 2),
            id          = 553011
        )

        achievement(
            title       = "Hong Kong Profecient",
            description = "Finish 1st place on the Hong Kong Level 3 track with any team during One Player or Season gameplay",
            points      = 5,
            trigger     = triggerRaceWin(LOCATION_HONG_KONG, 3),
            id          = 553012
        )

        achievement(
            title       = "Hong Kong Expert",
            description = "Finish 1st place on the Hong Kong Level 4 track with any team during One Player or Season gameplay",
            points =      10,
            trigger =     triggerRaceWin(LOCATION_HONG_KONG, 4),
            id          = 553013
        )

        achievement(
            title       = "Hong Kong Master",
            description = "Finish 1st place on the Hong Kong Level 5 track with any team during One Player or Season gameplay",
            points =      10,
            trigger =     triggerRaceWin(LOCATION_HONG_KONG, 5),
            id          = 553014
        )

        achievement(
            title       = "Hong Kong Champion",
            description = "Finish 1st place on the Hong Kong Level 6 track with any team during One Player or Season gameplay",
            points      = 10,
            trigger     = triggerRaceWin(LOCATION_HONG_KONG, 6),
            id          = 553015
        )
    // #endregion Hong Kong Race Challanges

    // #region Egypt Race Challanges
        achievement(
            title       = "Egypt Beginner",
            description = "Finish 1st place on the Egypt Level 1 track with any team during One Player or Season gameplay",
            points      = 3,
            trigger     = triggerRaceWin(LOCATION_EGYPT, 1),
            id          = 552476
        )

        achievement(
            title       = "Egypt Experienced",
            description = "Finish 1st place on the Egypt Level 2 track with any team during One Player or Season gameplay",
            points      = 5,
            trigger     = triggerRaceWin(LOCATION_EGYPT, 2),
            id          = 553016
        )

        achievement(
            title       = "Egypt Profecient",
            description = "Finish 1st place on the Egypt Level 3 track with any team during One Player or Season gameplay",
            points      = 5,
            trigger     = triggerRaceWin(LOCATION_EGYPT, 3),
            id          = 553017
        )

        achievement(
            title       = "Egypt Expert",
            description = "Finish 1st place on the Egypt Level 4 track with any team during One Player or Season gameplay",
            points =      10,
            trigger =     triggerRaceWin(LOCATION_EGYPT, 4),
            id          = 553018
        )

        achievement(
            title       = "Egypt Master",
            description = "Finish 1st place on the Egypt Level 5 track with any team during One Player or Season gameplay",
            points =      10,
            trigger =     triggerRaceWin(LOCATION_EGYPT, 5),
            id          = 553019
        )

        achievement(
            title       = "Egypt Champion",
            description = "Finish 1st place on the Egypt Level 6 track with any team during One Player or Season gameplay",
            points      = 10,
            trigger     = triggerRaceWin(LOCATION_EGYPT, 6),
            id          = 553020
        )
    // #endregion Egypt Race Challanges

    // #region Time Attack Challanges
        timeAttackAchievements = [
            { "id": 554481, "location": LOCATION_MOSCOW,        "track": 1, "time": [1, 21, 82] },
            { "id": 554482, "location": LOCATION_MOSCOW,        "track": 2, "time": [1, 26, 91] },
            { "id": 554483, "location": LOCATION_MOSCOW,        "track": 3, "time": [0, 55, 68] },
            { "id": 554484, "location": LOCATION_MOSCOW,        "track": 4, "time": [1, 02, 99] },
            { "id": 554485, "location": LOCATION_MOSCOW,        "track": 5, "time": [1, 11, 45] },
            { "id": 554486, "location": LOCATION_MOSCOW,        "track": 6, "time": [1, 22, 36] },
            { "id": 554487, "location": LOCATION_EASTER_ISLAND, "track": 1, "time": [1, 18, 90] },
            { "id": 554488, "location": LOCATION_EASTER_ISLAND, "track": 2, "time": [1, 25, 45] },
            { "id": 554489, "location": LOCATION_EASTER_ISLAND, "track": 3, "time": [1, 18, 32] },
            { "id": 554490, "location": LOCATION_EASTER_ISLAND, "track": 4, "time": [1, 20, 01] },
            { "id": 554491, "location": LOCATION_EASTER_ISLAND, "track": 5, "time": [1, 29, 98] },
            { "id": 554492, "location": LOCATION_EASTER_ISLAND, "track": 6, "time": [1, 36, 61] },
            { "id": 554493, "location": LOCATION_SWITZERLAND,   "track": 1, "time": [1, 27, 75] },
            { "id": 554494, "location": LOCATION_SWITZERLAND,   "track": 2, "time": [1, 25, 20] },
            { "id": 554495, "location": LOCATION_SWITZERLAND,   "track": 3, "time": [1, 21, 04] },
            { "id": 554496, "location": LOCATION_SWITZERLAND,   "track": 4, "time": [1, 57, 22] },
            { "id": 554497, "location": LOCATION_SWITZERLAND,   "track": 5, "time": [1, 59, 80] },
            { "id": 554498, "location": LOCATION_SWITZERLAND,   "track": 6, "time": [1, 55, 61] },
            { "id": 554499, "location": LOCATION_SCOTLAND,      "track": 1, "time": [1, 34, 41] },
            { "id": 554500, "location": LOCATION_SCOTLAND,      "track": 2, "time": [1, 33, 43] },
            { "id": 554501, "location": LOCATION_SCOTLAND,      "track": 3, "time": [1, 31, 79] },
            { "id": 554502, "location": LOCATION_SCOTLAND,      "track": 4, "time": [1, 38, 29] },
            { "id": 554503, "location": LOCATION_SCOTLAND,      "track": 5, "time": [1, 35, 31] },
            { "id": 554504, "location": LOCATION_SCOTLAND,      "track": 6, "time": [1, 52, 45] },
            { "id": 554505, "location": LOCATION_EGYPT,         "track": 1, "time": [1, 59, 09] },
            { "id": 554506, "location": LOCATION_EGYPT,         "track": 2, "time": [2, 02, 75] },
            { "id": 554507, "location": LOCATION_EGYPT,         "track": 3, "time": [2, 26, 54] },
            { "id": 554508, "location": LOCATION_EGYPT,         "track": 4, "time": [1, 49, 72] },
            { "id": 554509, "location": LOCATION_EGYPT,         "track": 5, "time": [2, 20, 67] },
            { "id": 554510, "location": LOCATION_EGYPT,         "track": 6, "time": [2, 18, 52] },
            { "id": 554511, "location": LOCATION_HONG_KONG,     "track": 1, "time": [1, 02, 67] },
            { "id": 554512, "location": LOCATION_HONG_KONG,     "track": 2, "time": [0, 58, 61] },
            { "id": 554513, "location": LOCATION_HONG_KONG,     "track": 3, "time": [0, 39, 57] },
            { "id": 554514, "location": LOCATION_HONG_KONG,     "track": 4, "time": [0, 41, 26] },
            { "id": 554515, "location": LOCATION_HONG_KONG,     "track": 5, "time": [1, 09, 34] },
            { "id": 554516, "location": LOCATION_HONG_KONG,     "track": 6, "time": [1, 13, 80] },
        ]

        for definition in timeAttackAchievements {
            trackDifficulty = ["", "Beginer", "Experienced", "Proficient", "Expert", "Master", "Champion"]

            genTitle = ""
            genTitle = genTitle + locationLookup[ definition["location"] ]
            genTitle = genTitle + " "
            // genTitle = genTitle + trackDifficulty[ definition["track"] ]
            genTitle = genTitle + definition["track"]
            genTitle = genTitle + " Time Trial"

            genDescription = ""
            genDescription = genDescription + "Finish a lap under"
            genDescription = genDescription + " " 
            genDescription = genDescription + definition["time"][0] + ":" + definition["time"][1] + ":" + definition["time"][2]
            genDescription = genDescription + " "
            genDescription = genDescription + "on the "
            genDescription = genDescription + locationLookup[ definition["location"] ]
            genDescription = genDescription + " "
            genDescription = genDescription + definition["track"]
            genDescription = genDescription + " "
            genDescription = genDescription + "track"

            achievement(
                title = genTitle,
                description = genDescription,
                points = 5,
                trigger = triggerTimeTrial(definition["location"], definition["track"], definition["time"])
            )
        }
    // #endregion

    // #region Ultimate Season Wins
        achievement(
            title       = "Ahmed's Ultimate Challenge",
            description = "Win a Season with Team Ahmed where every track raced is at Level 6",
            points      = 25,
            trigger     = triggerUltimateSeason(TEAM_AHMED),
            id          = 552824
        )

        achievement(
            title       = "Morgen's Ultimate Challenge",
            description = "Win a Season with Team Morgen where every track raced is at Level 6",
            points      = 25,
            trigger     = triggerUltimateSeason(TEAM_MORGEN),
            id          = 552825
        )

        achievement(
            title       = "Rossi's Ultimate Challenge",
            description = "Win a Season with Team Rossi where every track raced is at Level 6",
            points      = 25,
            trigger     = triggerUltimateSeason(TEAM_ROSSI),
            id          = 553214
        )

        achievement(
            title       = "Xu's Ultimate Challenge",
            description = "Win a Season with Team Xu where every track raced is at Level 6",
            points      = 25,
            trigger     = triggerUltimateSeason(TEAM_ROSSI),
            id          = 553215
        )

        achievement(
            title       = "Lumiere's Ultimate Challenge",
            description = "Win a Season with Team Lumiere where every track raced is at Level 6",
            points      = 25,
            trigger     = triggerUltimateSeason(TEAM_LUMIERE),
            id          = 553216
        )

        achievement(
            title       = "Roberts' Ultimate Challenge",
            description = "Win a Season with Team Roberts where every track raced is at Level 6",
            points      = 25,
            trigger     = triggerUltimateSeason(TEAM_ROBERTS),
            id          = 553217
        )

        achievement(
            title       = "Ivanov's Ultimate Challenge",
            description = "Win a Season with Team Ivanov where every track raced is at Level 6",
            points      = 25,
            trigger     = triggerUltimateSeason(TEAM_IVANOV),
            id          = 553218
        )

        achievement(
            title       = "Baptiste's Ultimate Challenge",
            description = "Win a Season with Team Baptiste where every track raced is at Level 6",
            points      = 25,
            trigger     = triggerUltimateSeason(TEAM_BAPTISTE),
            id          = 553219
        )
    // #endregion Ultimate Season Wins

    achievement(
        title       = "Top Season",
        description = "Finish a Season on the 1st place using any team",
        points      = 5,
        trigger     = triggerTopSeason(),
        type        = "win_condition",
        id          = 553226
    )

    // achievement(
    //     title       = "Gold Season",
    //     description = "Win a Season by finishing first on all six races",
    //     points      = 10,
    //     trigger     = triggerGoldSeason(),
    // )

    achievement(
        title       = "Two Laps Magic",
        description = "Win 2 lap race while delaying your start for at least 20 seconds",
        points      = 5,
        trigger     = triggerLapMagic(laps=2, delay=20),
        id          = 554004
    )

    achievement(
        title       = "Three Laps Magic",
        description = "Win 3 lap race while delaying your start for at least 30 seconds",
        points      = 10,
        trigger     = triggerLapMagic(laps=3, delay=30),
        id          = 554003
    )
// #endregion Achievements

// #region Leaderboards
    bestLapLeaderboardDefinitions = [
        {"id":143064, "trackName": "Moscow 1", "locationId": LOCATION_MOSCOW, "trackNumber": 1 },
        {"id":143065, "trackName": "Moscow 2", "locationId": LOCATION_MOSCOW, "trackNumber": 2 },
        {"id":143066, "trackName": "Moscow 3", "locationId": LOCATION_MOSCOW, "trackNumber": 3 },
        {"id":143067, "trackName": "Moscow 4", "locationId": LOCATION_MOSCOW, "trackNumber": 4 },
        {"id":143068, "trackName": "Moscow 5", "locationId": LOCATION_MOSCOW, "trackNumber": 5 },
        {"id":143069, "trackName": "Moscow 6", "locationId": LOCATION_MOSCOW, "trackNumber": 6 },

        {"id":143070, "trackName": "Easter Island 1", "locationId": LOCATION_EASTER_ISLAND, "trackNumber": 1 },
        {"id":143071, "trackName": "Easter Island 2", "locationId": LOCATION_EASTER_ISLAND, "trackNumber": 2 },
        {"id":143072, "trackName": "Easter Island 3", "locationId": LOCATION_EASTER_ISLAND, "trackNumber": 3 },
        {"id":143073, "trackName": "Easter Island 4", "locationId": LOCATION_EASTER_ISLAND, "trackNumber": 4 },
        {"id":143074, "trackName": "Easter Island 5", "locationId": LOCATION_EASTER_ISLAND, "trackNumber": 5 },
        {"id":143075, "trackName": "Easter Island 6", "locationId": LOCATION_EASTER_ISLAND, "trackNumber": 6 },

        {"id":143076, "trackName": "Switzerland 1", "locationId": LOCATION_SWITZERLAND, "trackNumber": 1 },
        {"id":143077, "trackName": "Switzerland 2", "locationId": LOCATION_SWITZERLAND, "trackNumber": 2 },
        {"id":143078, "trackName": "Switzerland 3", "locationId": LOCATION_SWITZERLAND, "trackNumber": 3 },
        {"id":143079, "trackName": "Switzerland 4", "locationId": LOCATION_SWITZERLAND, "trackNumber": 4 },
        {"id":143080, "trackName": "Switzerland 5", "locationId": LOCATION_SWITZERLAND, "trackNumber": 5 },
        {"id":143081, "trackName": "Switzerland 6", "locationId": LOCATION_SWITZERLAND, "trackNumber": 6 },

        {"id":143082, "trackName": "Scotland 1", "locationId": LOCATION_SCOTLAND, "trackNumber": 1 },
        {"id":143083, "trackName": "Scotland 2", "locationId": LOCATION_SCOTLAND, "trackNumber": 2 },
        {"id":143084, "trackName": "Scotland 3", "locationId": LOCATION_SCOTLAND, "trackNumber": 3 },
        {"id":143085, "trackName": "Scotland 4", "locationId": LOCATION_SCOTLAND, "trackNumber": 4 },
        {"id":143086, "trackName": "Scotland 5", "locationId": LOCATION_SCOTLAND, "trackNumber": 5 },
        {"id":143087, "trackName": "Scotland 6", "locationId": LOCATION_SCOTLAND, "trackNumber": 6 },

        {"id":143088, "trackName": "Hong Kong 1", "locationId": LOCATION_HONG_KONG, "trackNumber": 1 },
        {"id":143089, "trackName": "Hong Kong 2", "locationId": LOCATION_HONG_KONG, "trackNumber": 2 },
        {"id":143090, "trackName": "Hong Kong 3", "locationId": LOCATION_HONG_KONG, "trackNumber": 3 },
        {"id":143091, "trackName": "Hong Kong 4", "locationId": LOCATION_HONG_KONG, "trackNumber": 4 },
        {"id":143092, "trackName": "Hong Kong 5", "locationId": LOCATION_HONG_KONG, "trackNumber": 5 },
        {"id":143093, "trackName": "Hong Kong 6", "locationId": LOCATION_HONG_KONG, "trackNumber": 6 },

        {"id":143094, "trackName": "Egypt 1", "locationId": LOCATION_EGYPT, "trackNumber": 1 },
        {"id":143095, "trackName": "Egypt 2", "locationId": LOCATION_EGYPT, "trackNumber": 2 },
        {"id":143096, "trackName": "Egypt 3", "locationId": LOCATION_EGYPT, "trackNumber": 3 },
        {"id":143097, "trackName": "Egypt 4", "locationId": LOCATION_EGYPT, "trackNumber": 4 },
        {"id":143098, "trackName": "Egypt 5", "locationId": LOCATION_EGYPT, "trackNumber": 5 },
        {"id":143099, "trackName": "Egypt 6", "locationId": LOCATION_EGYPT, "trackNumber": 6 }
    ]

    function startBestLapLeaderboard(locationId, trackNumber) {
        return
            gameState() == GAME_STATE_IN_GAME
            && playerPointer() != 0
            && selectedLocation() == locationId
            && selectedRaceTrack() == trackNumber
            && playerLap() > 1
            && framePlayerLapIncreased()
    }

    function cancelBestLapLeaderboard() {
        return
            gameState() == GAME_STATE_EXIT_GAMEPLAY
            || gameState() == GAME_STATE_IN_FRONTEND
            || playerGameOver() > 0
            || playerPointer() == 0
    }

    function valueBestLapLeaderboard() {
        return max_of(
            measured( tally(0, always_false())),
            measured( playerLap1Time() * 10/3, when = prev(playerLap()) == 1 ),
            measured( playerLap2Time() * 10/3, when = prev(playerLap()) >= 2 )
        )
    }

    for definition in bestLapLeaderboardDefinitions {
        leaderboard(
            id = definition["id"],
            title = definition["trackName"] + " : Best Lap",
            description = "Fastest Lap Time on the " + definition["trackName"] + " Track",
            format = "MILLISECS",
            lower_is_better = true,
            start = startBestLapLeaderboard(definition["locationId"], definition["trackNumber"]),
            cancel = cancelBestLapLeaderboard(),
            submit = always_true(),
            value = valueBestLapLeaderboard()
        )
    }
// #endregion Leaderboards

// #region Rich Presence
    playModeLookup = {
        0: "single player",
        1: "time attack",
        2: "season",
        3: "split screen",
        4: "head to head"
    }

    // Single Player
    rich_presence_conditional_display(
        (
            gameState() == GAME_STATE_IN_GAME ||
            gameState() == GAME_STATE_PAUSE_MENU_MAIN ||
            gameState() == GAME_STATE_PAUSE_MENU_PICTURE ||
            gameState() == GAME_STATE_PAUSE_MENU_SOUND ||
            gameState() == GAME_STATE_PAUSE_MENU_QUIT
        )
        && playerPointer() != 0
        && selectedPlayMode() == PLAY_MODE_SINGLE_PLAYER,

        "Playing Single Race with Team {0} on {1} {2} • Position {3} • Lap {4}/{5}",

        rich_presence_lookup("Team", playerteamID(), teamLookup, "Unknown"),             // 0 : Team
        rich_presence_lookup("Location", selectedLocation(), locationLookup, "Unknown"), // 1 : Location
        rich_presence_macro("Number", selectedRaceTrack()),                              // 2 : Track
        rich_presence_macro("Number", playerPosition()),                                 // 3 : Position
        rich_presence_macro("Number", playerLap()),                                      // 4 : Current Lap
        rich_presence_macro("Number", currentRaceTotalLaps())                            // 5 : Total Laps
    )

    // Season Race
    rich_presence_conditional_display(
        (
            gameState() == GAME_STATE_IN_GAME ||
            gameState() == GAME_STATE_PAUSE_MENU_MAIN ||
            gameState() == GAME_STATE_PAUSE_MENU_PICTURE ||
            gameState() == GAME_STATE_PAUSE_MENU_SOUND ||
            gameState() == GAME_STATE_PAUSE_MENU_QUIT
        )
        && playerPointer() != 0
        && selectedPlayMode() == PLAY_MODE_SEASON,

        "Playing Season Race {3} with Team {0} on {1} {2}",

        rich_presence_lookup("Team", playerteamID(), teamLookup, "Unknown"),             // 0 : Team
        rich_presence_lookup("Location", selectedLocation(), locationLookup, "Unknown"), // 1 : Location
        rich_presence_macro("Number", selectedRaceTrack()),                              // 2 : Track
        rich_presence_macro("Number", currentSeasonRaceNumber())                         // 3 : Season Race
    )

    // Time Attack
    rich_presence_conditional_display(
        (
            gameState() == GAME_STATE_IN_GAME ||
            gameState() == GAME_STATE_PAUSE_MENU_MAIN ||
            gameState() == GAME_STATE_PAUSE_MENU_PICTURE ||
            gameState() == GAME_STATE_PAUSE_MENU_SOUND ||
            gameState() == GAME_STATE_PAUSE_MENU_QUIT
        )
        && playerPointer() != 0
        && selectedPlayMode() == PLAY_MODE_TIME_ATTACK,

        "Playing Time Attack with Team {0} on {1} {2}",

        rich_presence_lookup("Team", playerteamID(), teamLookup, "Unknown"),             // 0 : Team
        rich_presence_lookup("Location", selectedLocation(), locationLookup, "Unknown"), // 1 : Location
        rich_presence_macro("Number", selectedRaceTrack())                               // 2 : Track
    )

    // Two Player Modes
    rich_presence_conditional_display(
        gameState() == GAME_STATE_NULL
        && (selectedPlayMode() == PLAY_MODE_SPLIT_SCREEN || selectedPlayMode() == PLAY_MODE_HEAD_TO_HEAD)
        && SplitScreenBottomCarPointer() >= 0x80000000
        && SplitScreenTopCarPointer() >= 0x80000000,
        "Playing a Split Screen 2-Player Race"
    )

    rich_presence_display("Preparing to start a new {0} race.",
        rich_presence_lookup("PlayMode", selectedPlayMode(), playModeLookup, "Unknown")
    )
// #endregion Rich Presence
