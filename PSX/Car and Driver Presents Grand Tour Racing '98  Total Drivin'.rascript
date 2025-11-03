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
    GAME_STATE_PAUSE_INSERT_CD = 0x800ac5a8
    GAME_STATE_GAME_REPLAY = 0x80090824

    function frontendScreen() => word(0x02690c)
    SCREEN_MAIN_MENU = 0x00
    SCREEN_LOAD_MENU = 0x02
    SCREEN_RACE_RESULTS = 0x0c
    SCREEN_NAME_INPUT_NAME_FL = 0x07
    SCREEN_NAME_INPUT_NANE_TT = 0x08
    SCREEN_NAME_INPUT_NAME_FLTT = 0x09

    function memoryCardMessage() => word(0x033ecc)
    MEMCARD_SAVING = 0x10
    MEMCARD_LOADING = 0x12
    MEMCARD_CHECKING = 0x13
    MEMCARD_LOADED = 0x14
    MEMCARD_SAVED = 0x15

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
    function playerSpeed() => dword(tbyte(0x0b70f8)+0x668)
    function playerGameOverTimer() => dword(tbyte(0x0b70f8)+0x54c)

    function raceCountdownTimer() => dword(0x0bc394)

    function SplitScreenTopCarPointer() => dword(0x0c26a0)
    function SplitScreenBottomCarPointer() => dword(0x0c26a4)

    function cameraTarget() => dword(0x0c9860)
    CAMERA_TARGET_PLAYER = 0x80093cc0
    CAMERA_TARGET_ROTATE = 0x80093ce0
// #endregion Memory Addresses

// #region Lookups
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
// #endregion Lookups

// #region Frame Functions
    function frameRaceCountdownTimerStarted() {
        return
            prev(raceCountdownTimer()) != 0x5f
            && raceCountdownTimer() == 0x5f
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

    function onLastRaceSeasonResultsAppear() {
        return
            selectedPlayMode() == PLAY_MODE_SEASON
            && currentSeasonRaceNumber() == 6
            && frameSeasonRaceResultsAppeared()
    }

    function onSeasonStatsUpdated() {
        return
            selectedPlayMode() == PLAY_MODE_SEASON
            && currentSeasonRaceNumber() == 6

            // Game finished animation timer reseted
            && prev(playerGameOverTimer()) == 0xd3
            && playerGameOverTimer() == 0x00

            // Game state went from in game to something else
            && prev(gameState()) == GAME_STATE_IN_GAME
            && gameState() != GAME_STATE_IN_GAME
    }

    function onNewRaceStarted() {
        return
            frameRaceCountdownTimerStarted()
            && gameState() == GAME_STATE_IN_GAME
            && playerLap() == 0
            && playerRaceTime() == 0
            && playerLap1Time() == 0
    }

    function onSavedStateLoaded() {
        return
            gameState() == GAME_STATE_IN_FRONTEND
            && frontendScreen() == SCREEN_LOAD_MENU
            && prev(memoryCardMessage()) == MEMCARD_LOADING
            && memoryCardMessage() == MEMCARD_LOADED
    }

    function isGameplayActive() {
        return
            gameState() == GAME_STATE_IN_GAME
            && playerPointer() != 0
            && cameraTarget() == CAMERA_TARGET_PLAYER
    }

    function isGameplayPaused() {
        return
            gameState() == GAME_STATE_PAUSE_INSERT_CD
            || gameState() == GAME_STATE_PAUSE_MENU_MAIN
            || gameState() == GAME_STATE_PAUSE_MENU_MAIN
            || gameState() == GAME_STATE_PAUSE_MENU_PICTURE
            || gameState() == GAME_STATE_PAUSE_MENU_SOUND
            || gameState() == GAME_STATE_PAUSE_MENU_QUIT
    }
// #endregion Complex Conditions

// #region Achievement Triggers
    function triggerRaceFinish(location, track) {
        return
            currentRaceLocation() == location
            && currentRaceTrack() == track
            && playerPointer() != 0

            && frameRaceCompleted()

            && once ( onNewRaceStarted() )

            && never( gameState() == GAME_STATE_DEMO_GAMEPLAY )
            && never( gameState() == GAME_STATE_EXIT_GAMEPLAY )
            && never( playerGameOver() > 0)
    }

    function triggerRaceWin(location, track) {
        return
            currentRaceLocation() == location
            && currentRaceTrack() == track
            && playerPointer() != 0

            && frameRaceCompleted()
            && playerPosition() == 1

            && once ( onNewRaceStarted() )

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

            && once ( onNewRaceStarted() )

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
            && once ( onNewRaceStarted() )

        cancelConditions =
            never( gameState() == GAME_STATE_DEMO_GAMEPLAY )
            && never( gameState() == GAME_STATE_EXIT_GAMEPLAY )
            && never( playerGameOver() > 0 )
            && never( playerSpeed() != 0 && playerRaceTime() <= delay * 3/10 * 100 )

        return primingConditions && cancelConditions && trigger_when(winConditions)
    }

    function triggerUltimateSeason(teamID) {
        winConditions =
            currentSeasonTeam() == teamID
            && onLastRaceSeasonResultsAppear()
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
                && onNewRaceStarted()
                && currentRaceTrack() < 6
            )
            
            // Cancel if a save state was loaded
            && never ( onSavedStateLoaded() )

        return checkpointConditions && cancelConditions && winConditions
    }

    function triggerTopSeason() {
        winConditions =
            onLastRaceSeasonResultsAppear()
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
            
            // Cancel if a save state was loaded
            && never ( onSavedStateLoaded() )

        return checkpointConditions && cancelConditions && winConditions
    }

    function triggerGoldSeason() {
        extraCancelConditions =
            // Cancel when user's team finished a season race but is not on 1st position 
            never (
                any_of(range(0,7), teamID =>
                    frameSeasonRaceResultsAppeared()
                    && currentSeasonTeam() == teamID
                    && previousRacePosition(teamID) != 1
                )
            )

        return triggerTopSeason() && extraCancelConditions
    }
// #endregion Achievement Triggers

// #region Achievements
    // #region Race Challanges
        raceChallangeAchivements = [
            { "id": 551773, "location": LOCATION_MOSCOW,        "track": 1 },
            { "id": 552471, "location": LOCATION_MOSCOW,        "track": 2 },
            { "id": 552472, "location": LOCATION_MOSCOW,        "track": 3 },
            { "id": 552473, "location": LOCATION_MOSCOW,        "track": 4 },
            { "id": 552474, "location": LOCATION_MOSCOW,        "track": 5 },
            { "id": 552475, "location": LOCATION_MOSCOW,        "track": 6 },
            { "id": 552991, "location": LOCATION_EASTER_ISLAND, "track": 1 },
            { "id": 552992, "location": LOCATION_EASTER_ISLAND, "track": 2 },
            { "id": 552993, "location": LOCATION_EASTER_ISLAND, "track": 3 },
            { "id": 552994, "location": LOCATION_EASTER_ISLAND, "track": 4 },
            { "id": 552995, "location": LOCATION_EASTER_ISLAND, "track": 5 },
            { "id": 552996, "location": LOCATION_EASTER_ISLAND, "track": 6 },
            { "id": 552997, "location": LOCATION_SWITZERLAND,   "track": 1 },
            { "id": 552998, "location": LOCATION_SWITZERLAND,   "track": 2 },
            { "id": 552999, "location": LOCATION_SWITZERLAND,   "track": 3 },
            { "id": 553000, "location": LOCATION_SWITZERLAND,   "track": 4 },
            { "id": 553001, "location": LOCATION_SWITZERLAND,   "track": 5 },
            { "id": 553002, "location": LOCATION_SWITZERLAND,   "track": 6 },
            { "id": 553004, "location": LOCATION_SCOTLAND,      "track": 1 },
            { "id": 553005, "location": LOCATION_SCOTLAND,      "track": 2 },
            { "id": 553006, "location": LOCATION_SCOTLAND,      "track": 3 },
            { "id": 553007, "location": LOCATION_SCOTLAND,      "track": 4 },
            { "id": 553008, "location": LOCATION_SCOTLAND,      "track": 5 },
            { "id": 553009, "location": LOCATION_SCOTLAND,      "track": 6 },
            { "id": 552477, "location": LOCATION_EGYPT,         "track": 1 },
            { "id": 553011, "location": LOCATION_EGYPT,         "track": 2 },
            { "id": 553012, "location": LOCATION_EGYPT,         "track": 3 },
            { "id": 553013, "location": LOCATION_EGYPT,         "track": 4 },
            { "id": 553014, "location": LOCATION_EGYPT,         "track": 5 },
            { "id": 553015, "location": LOCATION_EGYPT,         "track": 6 },
            { "id": 552476, "location": LOCATION_HONG_KONG,     "track": 1 },
            { "id": 553016, "location": LOCATION_HONG_KONG,     "track": 2 },
            { "id": 553017, "location": LOCATION_HONG_KONG,     "track": 3 },
            { "id": 553018, "location": LOCATION_HONG_KONG,     "track": 4 },
            { "id": 553019, "location": LOCATION_HONG_KONG,     "track": 5 },
            { "id": 553020, "location": LOCATION_HONG_KONG,     "track": 6 },
        ]

        for definition in raceChallangeAchivements {
            trackDifficulty = ["", "Beginner", "Experienced", "Proficient", "Expert", "Master", "Champion"]
            trackPoints     = [ 0, 3, 3, 5, 5, 5, 10 ]

            genTitle = ""
            genTitle = genTitle + locationLookup[ definition["location"] ]
            genTitle = genTitle + " "
            genTitle = genTitle + trackDifficulty[ definition["track"] ]

            genDescription = ""
            genDescription = genDescription + "Finish in 1st place on the "
            genDescription = genDescription + locationLookup[ definition["location"] ]
            genDescription = genDescription + " "
            genDescription = genDescription + definition["track"]
            genDescription = genDescription + " track in One Player or Season mode"

            genPoints = trackPoints[ definition["track"] ]

            achievement(
                id = definition["id"],
                title = genTitle,
                description = genDescription,
                points = genPoints,
                trigger = triggerRaceWin(definition["location"], definition["track"])
            )
        }
    // #endregion Race Challanges

    // #region Hidden Track Challanges
        hiddenTrackAchivements = [
            { "id": 554955, "location": LOCATION_MOSCOW },
            { "id": 554956, "location": LOCATION_EASTER_ISLAND },
            { "id": 554957, "location": LOCATION_SWITZERLAND },
            { "id": 554958, "location": LOCATION_SCOTLAND },
            { "id": 554959, "location": LOCATION_EGYPT },
            { "id": 554960, "location": LOCATION_HONG_KONG },
        ]

        for definition in hiddenTrackAchivements {
            genTitle = ""
            genTitle = genTitle + locationLookup[ definition["location"] ]
            genTitle = genTitle + " "
            genTitle = genTitle + "Secret Track"

            genDescription = ""
            genDescription = genDescription + "Discover and finish a race on "
            genDescription = genDescription + locationLookup[ definition["location"] ]
            genDescription = genDescription + "'s hidden track"

            achievement(
                id = definition["id"],
                title = genTitle,
                description = genDescription,
                points = 5,
                trigger = triggerRaceFinish(definition["location"], 7)
            )
        }
    // #endregion Hidden Track Challanges

    // #region Time Attack Challanges
        timeAttackAchievements = [
            { "id": 554481, "location": LOCATION_MOSCOW,        "track": 1, "time": [1, 21, 46] },
            { "id": 554482, "location": LOCATION_MOSCOW,        "track": 2, "time": [1, 26, 23] },
            { "id": 554483, "location": LOCATION_MOSCOW,        "track": 3, "time": [0, 54, 39] },
            { "id": 554484, "location": LOCATION_MOSCOW,        "track": 4, "time": [1, 01, 38] },
            { "id": 554485, "location": LOCATION_MOSCOW,        "track": 5, "time": [1, 10, 14] },
            { "id": 554486, "location": LOCATION_MOSCOW,        "track": 6, "time": [1, 21, 32] },
            { "id": 554487, "location": LOCATION_EASTER_ISLAND, "track": 1, "time": [1, 17, 88] },
            { "id": 554488, "location": LOCATION_EASTER_ISLAND, "track": 2, "time": [1, 22, 98] },
            { "id": 554489, "location": LOCATION_EASTER_ISLAND, "track": 3, "time": [1, 15, 31] },
            { "id": 554490, "location": LOCATION_EASTER_ISLAND, "track": 4, "time": [1, 15, 99] },
            { "id": 554491, "location": LOCATION_EASTER_ISLAND, "track": 5, "time": [1, 27, 49] },
            { "id": 554492, "location": LOCATION_EASTER_ISLAND, "track": 6, "time": [1, 32, 59] },
            { "id": 554493, "location": LOCATION_SWITZERLAND,   "track": 1, "time": [1, 25, 82] },
            { "id": 554494, "location": LOCATION_SWITZERLAND,   "track": 2, "time": [1, 24, 07] },
            { "id": 554495, "location": LOCATION_SWITZERLAND,   "track": 3, "time": [1, 19, 58] },
            { "id": 554496, "location": LOCATION_SWITZERLAND,   "track": 4, "time": [1, 53, 05] },
            { "id": 554497, "location": LOCATION_SWITZERLAND,   "track": 5, "time": [1, 55, 71] },
            { "id": 554498, "location": LOCATION_SWITZERLAND,   "track": 6, "time": [1, 52, 65] },
            { "id": 554499, "location": LOCATION_SCOTLAND,      "track": 1, "time": [1, 33, 03] },
            { "id": 554500, "location": LOCATION_SCOTLAND,      "track": 2, "time": [1, 32, 22] },
            { "id": 554501, "location": LOCATION_SCOTLAND,      "track": 3, "time": [1, 30, 28] },
            { "id": 554502, "location": LOCATION_SCOTLAND,      "track": 4, "time": [1, 36, 56] },
            { "id": 554503, "location": LOCATION_SCOTLAND,      "track": 5, "time": [1, 33, 76] },
            { "id": 554504, "location": LOCATION_SCOTLAND,      "track": 6, "time": [1, 45, 92] },
            { "id": 554505, "location": LOCATION_EGYPT,         "track": 1, "time": [1, 57, 13] },
            { "id": 554506, "location": LOCATION_EGYPT,         "track": 2, "time": [2, 00, 09] },
            { "id": 554507, "location": LOCATION_EGYPT,         "track": 3, "time": [2, 24, 65] },
            { "id": 554508, "location": LOCATION_EGYPT,         "track": 4, "time": [1, 47, 45] },
            { "id": 554509, "location": LOCATION_EGYPT,         "track": 5, "time": [2, 15, 88] },
            { "id": 554510, "location": LOCATION_EGYPT,         "track": 6, "time": [2, 13, 51] },
            { "id": 554511, "location": LOCATION_HONG_KONG,     "track": 1, "time": [1, 01, 09] },
            { "id": 554512, "location": LOCATION_HONG_KONG,     "track": 2, "time": [0, 57, 30] },
            { "id": 554513, "location": LOCATION_HONG_KONG,     "track": 3, "time": [0, 38, 96] },
            { "id": 554514, "location": LOCATION_HONG_KONG,     "track": 4, "time": [0, 40, 00] },
            { "id": 554515, "location": LOCATION_HONG_KONG,     "track": 5, "time": [1, 08, 05] },
            { "id": 554516, "location": LOCATION_HONG_KONG,     "track": 6, "time": [1, 12, 72] },
        ]

        for definition in timeAttackAchievements {
            trackPoints = [ 0, 3, 3, 5, 5, 5, 10 ]

            genTitle = ""
            genTitle = genTitle + locationLookup[ definition["location"] ]
            genTitle = genTitle + " "
            genTitle = genTitle + definition["track"]
            genTitle = genTitle + " Time Trial"

            genDescription = ""
            genDescription = genDescription + "Finish a lap faster than"
            genDescription = genDescription + " " 
            genDescription = genDescription + definition["time"][0]
            if (definition["time"][1] <= 9)
                genDescription = genDescription + ":0" + definition["time"][1]
            else
                genDescription = genDescription + ":" + definition["time"][1]
            if (definition["time"][2] <= 9)
                genDescription = genDescription + ":0" + definition["time"][2]
            else
                genDescription = genDescription + ":" + definition["time"][2]
            genDescription = genDescription + " "
            genDescription = genDescription + "on the "
            genDescription = genDescription + locationLookup[ definition["location"] ]
            genDescription = genDescription + " "
            genDescription = genDescription + definition["track"]
            genDescription = genDescription + " "
            genDescription = genDescription + "track in Time Attack, One Player of Season mode"

            genPoints = trackPoints[ definition["track"] ]

            achievement(
                id = definition["id"],
                title = genTitle,
                description = genDescription,
                points = genPoints,
                trigger = triggerTimeTrial(definition["location"], definition["track"], definition["time"])
            )
        }
    // #endregion

    // #region Ultimate Season Wins
        achievement(
            title       = "Ahmed's Ultimate Challenge",
            description = "Win a Season with Team Ahmed where every race is held on a Track 6 variation",
            points      = 25,
            trigger     = triggerUltimateSeason(TEAM_AHMED),
            id          = 552824
        )

        achievement(
            title       = "Morgen's Ultimate Challenge",
            description = "Win a Season with Team Morgen where every race is held on a Track 6 variation",
            points      = 25,
            trigger     = triggerUltimateSeason(TEAM_MORGEN),
            id          = 552825
        )

        achievement(
            title       = "Rossi's Ultimate Challenge",
            description = "Win a Season with Team Rossi where every race is held on a Track 6 variation",
            points      = 25,
            trigger     = triggerUltimateSeason(TEAM_ROSSI),
            id          = 553214
        )

        achievement(
            title       = "Xu's Ultimate Challenge",
            description = "Win a Season with Team Xu where every race is held on a Track 6 variation",
            points      = 25,
            trigger     = triggerUltimateSeason(TEAM_XU),
            id          = 553215
        )

        achievement(
            title       = "Lumiere's Ultimate Challenge",
            description = "Win a Season with Team Lumiere where every race is held on a Track 6 variation",
            points      = 25,
            trigger     = triggerUltimateSeason(TEAM_LUMIERE),
            id          = 553216
        )

        achievement(
            title       = "Roberts' Ultimate Challenge",
            description = "Win a Season with Team Roberts where every race is held on a Track 6 variation",
            points      = 25,
            trigger     = triggerUltimateSeason(TEAM_ROBERTS),
            id          = 553217
        )

        achievement(
            title       = "Ivanov's Ultimate Challenge",
            description = "Win a Season with Team Ivanov where every race is held on a Track 6 variation",
            points      = 25,
            trigger     = triggerUltimateSeason(TEAM_IVANOV),
            id          = 553218
        )

        achievement(
            title       = "Baptiste's Ultimate Challenge",
            description = "Win a Season with Team Baptise where every race is held on a Track 6 variation",
            points      = 25,
            trigger     = triggerUltimateSeason(TEAM_BAPTISTE),
            id          = 553219
        )
    // #endregion Ultimate Season Wins

    achievement(
        title       = "Top Season",
        description = "Finish Season Mode in 1st place overall with any team",
        points      = 5,
        trigger     = triggerTopSeason(),
        type        = "win_condition",
        id          = 553226
    )

    achievement(
        title       = "Gold Season",
        description = "Win Season Mode by achieving a 1st place finish in every race",
        points      = 10,
        trigger     = triggerGoldSeason(),
        id          = 554954
    )

    achievement(
        title       = "Two Laps Magic",
        description = "Win a 2-lap race after remaining completely motionless at the starting position for at least 20 seconds",
        points      = 5,
        trigger     = triggerLapMagic(laps=2, delay=20),
        id          = 554004
    )

    achievement(
        title       = "Three Laps Magic",
        description = "Win a 3-lap race after remaining completely motionless at the starting position for at least 30 seconds",
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
            isGameplayActive()
            && selectedLocation() == locationId
            && currentRaceTrack() == trackNumber
            && playerLap() > 1
            && framePlayerLapIncreased()
    }

    function valueBestLapLeaderboard() {
        return max_of(
            measured( tally(0, always_false())),
            measured( playerLap1Time() * 10/3, when = prev(playerLap()) == 1 ),
            measured( playerLap2Time() * 10/3, when = prev(playerLap()) == 2 ),
            measured( playerLap3Time() * 10/3, when = prev(playerLap()) == 3 && currentRaceTotalLaps() == 3),
            measured( playerLap2Time() * 10/3, when = prev(playerLap()) >= 3 && currentRaceTotalLaps() >= 4)
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
            cancel = always_false(),
            submit = always_true(),
            value = valueBestLapLeaderboard()
        )
    }


    bestRaceTimeLeaderboardDefinitions = [
        {"id":144937, "trackName": "Moscow 1", "locationId": LOCATION_MOSCOW, "trackNumber": 1 },
        {"id":144938, "trackName": "Moscow 2", "locationId": LOCATION_MOSCOW, "trackNumber": 2 },
        {"id":144939, "trackName": "Moscow 3", "locationId": LOCATION_MOSCOW, "trackNumber": 3 },
        {"id":144940, "trackName": "Moscow 4", "locationId": LOCATION_MOSCOW, "trackNumber": 4 },
        {"id":144941, "trackName": "Moscow 5", "locationId": LOCATION_MOSCOW, "trackNumber": 5 },
        {"id":144942, "trackName": "Moscow 6", "locationId": LOCATION_MOSCOW, "trackNumber": 6 },

        {"id":144943, "trackName": "Easter Island 1", "locationId": LOCATION_EASTER_ISLAND, "trackNumber": 1 },
        {"id":144944, "trackName": "Easter Island 2", "locationId": LOCATION_EASTER_ISLAND, "trackNumber": 2 },
        {"id":144945, "trackName": "Easter Island 3", "locationId": LOCATION_EASTER_ISLAND, "trackNumber": 3 },
        {"id":144946, "trackName": "Easter Island 4", "locationId": LOCATION_EASTER_ISLAND, "trackNumber": 4 },
        {"id":144947, "trackName": "Easter Island 5", "locationId": LOCATION_EASTER_ISLAND, "trackNumber": 5 },
        {"id":144948, "trackName": "Easter Island 6", "locationId": LOCATION_EASTER_ISLAND, "trackNumber": 6 },

        {"id":144949, "trackName": "Switzerland 1", "locationId": LOCATION_SWITZERLAND, "trackNumber": 1 },
        {"id":144950, "trackName": "Switzerland 2", "locationId": LOCATION_SWITZERLAND, "trackNumber": 2 },
        {"id":144951, "trackName": "Switzerland 3", "locationId": LOCATION_SWITZERLAND, "trackNumber": 3 },
        {"id":144952, "trackName": "Switzerland 4", "locationId": LOCATION_SWITZERLAND, "trackNumber": 4 },
        {"id":144953, "trackName": "Switzerland 5", "locationId": LOCATION_SWITZERLAND, "trackNumber": 5 },
        {"id":144954, "trackName": "Switzerland 6", "locationId": LOCATION_SWITZERLAND, "trackNumber": 6 },

        {"id":144955, "trackName": "Scotland 1", "locationId": LOCATION_SCOTLAND, "trackNumber": 1 },
        {"id":144956, "trackName": "Scotland 2", "locationId": LOCATION_SCOTLAND, "trackNumber": 2 },
        {"id":144957, "trackName": "Scotland 3", "locationId": LOCATION_SCOTLAND, "trackNumber": 3 },
        {"id":144958, "trackName": "Scotland 4", "locationId": LOCATION_SCOTLAND, "trackNumber": 4 },
        {"id":144959, "trackName": "Scotland 5", "locationId": LOCATION_SCOTLAND, "trackNumber": 5 },
        {"id":144960, "trackName": "Scotland 6", "locationId": LOCATION_SCOTLAND, "trackNumber": 6 },

        {"id":144961, "trackName": "Hong Kong 1", "locationId": LOCATION_HONG_KONG, "trackNumber": 1 },
        {"id":144962, "trackName": "Hong Kong 2", "locationId": LOCATION_HONG_KONG, "trackNumber": 2 },
        {"id":144963, "trackName": "Hong Kong 3", "locationId": LOCATION_HONG_KONG, "trackNumber": 3 },
        {"id":144964, "trackName": "Hong Kong 4", "locationId": LOCATION_HONG_KONG, "trackNumber": 4 },
        {"id":144965, "trackName": "Hong Kong 5", "locationId": LOCATION_HONG_KONG, "trackNumber": 5 },
        {"id":144966, "trackName": "Hong Kong 6", "locationId": LOCATION_HONG_KONG, "trackNumber": 6 },

        {"id":144967, "trackName": "Egypt 1", "locationId": LOCATION_EGYPT, "trackNumber": 1 },
        {"id":144968, "trackName": "Egypt 2", "locationId": LOCATION_EGYPT, "trackNumber": 2 },
        {"id":144969, "trackName": "Egypt 3", "locationId": LOCATION_EGYPT, "trackNumber": 3 },
        {"id":144970, "trackName": "Egypt 4", "locationId": LOCATION_EGYPT, "trackNumber": 4 },
        {"id":144971, "trackName": "Egypt 5", "locationId": LOCATION_EGYPT, "trackNumber": 5 },
        {"id":144972, "trackName": "Egypt 6", "locationId": LOCATION_EGYPT, "trackNumber": 6 }
    ]

    function startBestRaceTimeLeaderboard(locationId, trackNumber) {
        return
            isGameplayActive()
            && selectedLocation() == locationId
            && currentRaceTrack() == trackNumber
            && frameRaceCompleted()
            && any_of(
                [ PLAY_MODE_SINGLE_PLAYER, PLAY_MODE_SEASON ],
                playModeId => selectedPlayMode() == playModeId
            )
    }

    function valueBestRaceTimeLeaderboard() {
        return playerRaceTime() * 10/3
    }

    for definition in bestRaceTimeLeaderboardDefinitions {
        leaderboard(
            // id = definition["id"],
            title = definition["trackName"] + " : Best Race Time",
            description = "Fastest Race Time on the " + definition["trackName"] + " Track",
            format = "MILLISECS",
            lower_is_better = true,
            start = startBestRaceTimeLeaderboard(definition["locationId"], definition["trackNumber"]),
            cancel = always_false(),
            submit = always_true(),
            value = valueBestRaceTimeLeaderboard()
        )
    }

// #endregion Leaderboards

// #region Rich Presence
    playModeLookup = {
        0: "Single Player",
        1: "Time Attack",
        2: "Season",
        3: "Split Screen",
        4: "Head to Head"
    }

    // Single Player
    rich_presence_conditional_display(
        isGameplayActive() 
        && selectedPlayMode() == PLAY_MODE_SINGLE_PLAYER,

        "Playing Single Race with Team {0} on {1} {2} • Position {3} • Lap {4}/{5}",

        rich_presence_lookup("Team", playerteamID(), teamLookup, "Unknown"),             // 0 : Team
        rich_presence_lookup("Location", selectedLocation(), locationLookup, "Unknown"), // 1 : Location
        rich_presence_macro("Number", currentRaceTrack()),                               // 2 : Track
        rich_presence_macro("Number", playerPosition()),                                 // 3 : Position
        rich_presence_macro("Number", playerLap()),                                      // 4 : Current Lap
        rich_presence_macro("Number", currentRaceTotalLaps())                            // 5 : Total Laps
    )

    // Season Race
    rich_presence_conditional_display(
        isGameplayActive()
        && selectedPlayMode() == PLAY_MODE_SEASON,

        "Playing Season Race {3} with Team {0} on {1} {2}",

        rich_presence_lookup("Team", playerteamID(), teamLookup, "Unknown"),             // 0 : Team
        rich_presence_lookup("Location", selectedLocation(), locationLookup, "Unknown"), // 1 : Location
        rich_presence_macro("Number", currentRaceTrack()),                               // 2 : Track
        rich_presence_macro("Number", currentSeasonRaceNumber())                         // 3 : Season Race
    )

    // Time Attack
    rich_presence_conditional_display(
        isGameplayActive()
        && selectedPlayMode() == PLAY_MODE_TIME_ATTACK,

        "Playing Time Attack with Team {0} on {1} {2}",

        rich_presence_lookup("Team", playerteamID(), teamLookup, "Unknown"),             // 0 : Team
        rich_presence_lookup("Location", selectedLocation(), locationLookup, "Unknown"), // 1 : Location
        rich_presence_macro("Number", currentRaceTrack())                                // 2 : Track
    )

    // Two Player Modes
    rich_presence_conditional_display(
        gameState() == GAME_STATE_NULL
        && (selectedPlayMode() == PLAY_MODE_SPLIT_SCREEN || selectedPlayMode() == PLAY_MODE_HEAD_TO_HEAD)
        && SplitScreenBottomCarPointer() >= 0x80000000
        && SplitScreenTopCarPointer() >= 0x80000000,

        "Playing a Split Screen 2-Player Race"
    )

    // Race Replay
    rich_presence_conditional_display(
        gameState() == GAME_STATE_GAME_REPLAY,

        "Watching Race Replay from {0} {1}",

        rich_presence_lookup("Location", selectedLocation(), locationLookup, "Unknown"), // 0 : Location
        rich_presence_macro("Number", currentRaceTrack())                                // 1 : Track
    )

    // Demo Gameplay
    rich_presence_conditional_display(
        gameState() == GAME_STATE_DEMO_GAMEPLAY,

        "Watching Demo Gameplay from {0} {1}",

        rich_presence_lookup("Location", selectedLocation(), locationLookup, "Unknown"), // 0 : Location
        rich_presence_macro("Number", currentRaceTrack())                                // 1 : Track
    )

    rich_presence_display("Preparing for a {0} Race",
        rich_presence_lookup("PlayMode", selectedPlayMode(), playModeLookup, "Unknown")
    )
// #endregion Rich Presence
