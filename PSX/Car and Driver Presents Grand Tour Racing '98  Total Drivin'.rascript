// Car and Driver Presents Grand Tour Racing '98 | Total Drivin'
// #ID = 25969

// #region Memory Addresses
    function activeScreen() => dword(0x0c1718)
    ACTIVE_SCREEN_MAIN_MENU = 0x24e720c6
    ACTIVE_SCREEN_IN_GAME = 0x80090e58
    ACTIVE_SCREEN_PAUSE_MENU_MAIN = 0x800ac898
    ACTIVE_SCREEN_PAUSE_MENU_PICTURE = 0x800acadc 
    ACTIVE_SCREEN_PAUSE_MENU_SOUND = 0x800acba0
    ACTIVE_SCREEN_PAUSE_MENU_QUIT = 0x800ac6a8
    ACTIVE_SCREEN_DEMO_GAMEPLAY = 0x8009046c
    ACTIVE_SCREEN_EXIT_GAMEPLAY = 0x800883e4

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

    function selectedRaceTrack() => word(0x026918)

    function currentRaceTotalLaps() => dword(0x0bd168)
    function currentSeasonRaceNumber() => byte(0x026e56) + 1
    function currentRaceTrack() => dword(0x0ba810)
    function currentRaceLocation() => dword(0x0bb498)

    function playerPointer() => dword(0x0b70f8)
    function playerPosition() => dword(tbyte(0x0b70f8)+0x590)
    function playerTeamId() => byte(tbyte(0x0b70f8)+0x128)
    function playerLap() => byte(tbyte(0x0b70f8)+0x574)
    function playerGameOver() => byte(tbyte(0x0b70f8)+0x619)
    function playerLap1Time() => dword(tbyte(0x0b70f8)+0x57c)
    function playerLap2Time() => dword(tbyte(0x0b70f8)+0x580)
    function playerLap3Time() => dword(tbyte(0x0b70f8)+0x584)

    function raceCountdownTimer() => dword(0x0bc394)

    function SplitScreenTopCarPointer() => dword(0x0c26a0)
    function SplitScreenBottomCarPointer() => dword(0x0c26a4)
// #endregion Memory Addresses

// #region Frame Functions
    function frameRaceCountdownTimerStarted() {
        return
            prev(raceCountdownTimer()) == 0
            && raceCountdownTimer() == 0x5f
    }

    function frameActiveScreenSwitchedToInGame() {
        return
            prev(activeScreen()) == 0
            && activeScreen() == ACTIVE_SCREEN_IN_GAME
    }
// #endregion Frame Functions

// #region Achivement Triggers
    function triggerRaceWin(location, track) {
        return
            currentRaceLocation() == location
            && currentRaceTrack() == track
            && playerPosition() == 1
            && playerLap() == currentRaceTotalLaps() + 1
            && playerPointer() > 0x80000000

            && once ( frameActiveScreenSwitchedToInGame())
            && once ( frameRaceCountdownTimerStarted() )

            && never( activeScreen() == ACTIVE_SCREEN_DEMO_GAMEPLAY )
            && never( activeScreen() == ACTIVE_SCREEN_EXIT_GAMEPLAY )
            && never( playerGameOver() > 0)
    }
// #endregion Achivement Triggers

// #region Achievements
    // Moscow 1 Track
    achievement(
        id = 551773,
        title = "Moscow Beginner",
        description = "Win a race on the Moscow 1 track with any team",
        trigger = triggerRaceWin(LOCATION_MOSCOW, 1),
        points = 3
    )

    // Moscow 2 Track
    achievement(
        title = "Moscow Experienced",
        description = "Win a race on the Moscow 2 track with any team",
        trigger = triggerRaceWin(LOCATION_MOSCOW, 2),
        points = 5
    )

    // Moscow 3 Track
    achievement(
        title = "Moscow Profecient",
        description = "Win a race on the Moscow 3 track with any team",
        trigger = triggerRaceWin(LOCATION_MOSCOW, 3),
        points = 5
    )

    // Moscow 4 Track
    achievement(
        title = "Moscow Expert",
        description = "Win a race on the Moscow 4 track with any team",
        trigger = triggerRaceWin(LOCATION_MOSCOW, 4),
        points = 10
    )

    // Moscow 5 Track
    achievement(
        title = "Moscow Master",
        description = "Win a race on the Moscow 5 track with any team",
        trigger = triggerRaceWin(LOCATION_MOSCOW, 5),
        points = 10
    )

    // Moscow 6 Track
    achievement(
        title = "Moscow Champion",
        description = "Win a race on the Moscow 6 track with any team",
        trigger = triggerRaceWin(LOCATION_MOSCOW, 6),
        points = 10
    )
// #endregion Achievements

// #region Leaderboards
    bestLapLeaderboardDefinitions = [
        { "trackName": "Moscow 1", "locationId": LOCATION_MOSCOW, "trackNumber": 1 },
        { "trackName": "Moscow 2", "locationId": LOCATION_MOSCOW, "trackNumber": 2 },
        { "trackName": "Moscow 3", "locationId": LOCATION_MOSCOW, "trackNumber": 3 },
        { "trackName": "Moscow 4", "locationId": LOCATION_MOSCOW, "trackNumber": 4 },
        { "trackName": "Moscow 5", "locationId": LOCATION_MOSCOW, "trackNumber": 5 },
        { "trackName": "Moscow 6", "locationId": LOCATION_MOSCOW, "trackNumber": 6 },

        { "trackName": "Easter Island 1", "locationId": LOCATION_EASTER_ISLAND, "trackNumber": 1 },
        { "trackName": "Easter Island 2", "locationId": LOCATION_EASTER_ISLAND, "trackNumber": 2 },
        { "trackName": "Easter Island 3", "locationId": LOCATION_EASTER_ISLAND, "trackNumber": 3 },
        { "trackName": "Easter Island 4", "locationId": LOCATION_EASTER_ISLAND, "trackNumber": 4 },
        { "trackName": "Easter Island 5", "locationId": LOCATION_EASTER_ISLAND, "trackNumber": 5 },
        { "trackName": "Easter Island 6", "locationId": LOCATION_EASTER_ISLAND, "trackNumber": 6 },

        { "trackName": "Switzerland 1", "locationId": LOCATION_SWITZERLAND, "trackNumber": 1 },
        { "trackName": "Switzerland 2", "locationId": LOCATION_SWITZERLAND, "trackNumber": 2 },
        { "trackName": "Switzerland 3", "locationId": LOCATION_SWITZERLAND, "trackNumber": 3 },
        { "trackName": "Switzerland 4", "locationId": LOCATION_SWITZERLAND, "trackNumber": 4 },
        { "trackName": "Switzerland 5", "locationId": LOCATION_SWITZERLAND, "trackNumber": 5 },
        { "trackName": "Switzerland 6", "locationId": LOCATION_SWITZERLAND, "trackNumber": 6 },

        { "trackName": "Scotland 1", "locationId": LOCATION_SCOTLAND, "trackNumber": 1 },
        { "trackName": "Scotland 2", "locationId": LOCATION_SCOTLAND, "trackNumber": 2 },
        { "trackName": "Scotland 3", "locationId": LOCATION_SCOTLAND, "trackNumber": 3 },
        { "trackName": "Scotland 4", "locationId": LOCATION_SCOTLAND, "trackNumber": 4 },
        { "trackName": "Scotland 5", "locationId": LOCATION_SCOTLAND, "trackNumber": 5 },
        { "trackName": "Scotland 6", "locationId": LOCATION_SCOTLAND, "trackNumber": 6 },

        { "trackName": "Hong Kong 1", "locationId": LOCATION_HONG_KONG, "trackNumber": 1 },
        { "trackName": "Hong Kong 2", "locationId": LOCATION_HONG_KONG, "trackNumber": 2 },
        { "trackName": "Hong Kong 3", "locationId": LOCATION_HONG_KONG, "trackNumber": 3 },
        { "trackName": "Hong Kong 4", "locationId": LOCATION_HONG_KONG, "trackNumber": 4 },
        { "trackName": "Hong Kong 5", "locationId": LOCATION_HONG_KONG, "trackNumber": 5 },
        { "trackName": "Hong Kong 6", "locationId": LOCATION_HONG_KONG, "trackNumber": 6 },

        { "trackName": "Egypt 1", "locationId": LOCATION_EGYPT, "trackNumber": 1 },
        { "trackName": "Egypt 2", "locationId": LOCATION_EGYPT, "trackNumber": 2 },
        { "trackName": "Egypt 3", "locationId": LOCATION_EGYPT, "trackNumber": 3 },
        { "trackName": "Egypt 4", "locationId": LOCATION_EGYPT, "trackNumber": 4 },
        { "trackName": "Egypt 5", "locationId": LOCATION_EGYPT, "trackNumber": 5 },
        { "trackName": "Egypt 6", "locationId": LOCATION_EGYPT, "trackNumber": 6 }
    ]

    function startBestLapLeaderboard(locationId, trackNumber) {
        return
            activeScreen() == ACTIVE_SCREEN_IN_GAME
            && playerPointer() > 0x80000000
            && selectedLocation() == locationId
            && selectedRaceTrack() == trackNumber
            && playerLap() == prev(playerLap()) + 1
            && playerLap() > 1
    }

    function cancelBestLapLeaderboard() {
        return
            activeScreen() == ACTIVE_SCREEN_EXIT_GAMEPLAY
            || activeScreen() == ACTIVE_SCREEN_MAIN_MENU
            || playerGameOver() > 0
            || playerPointer() <= 0x80000000
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
    teamLookup = {
        0: "Ahmed",
        1: "Morgen",
        2: "Rossi",
        3: "Xu",
        4: "Lumiere",
        5: "Roberts",
        6: "Ivanov",
        7: "Baptise"
    }

    locationLookup = {
        0: "Moscow",
        1: "Easter Island",
        2: "Switzerland",
        3: "Scotland",
        4: "Hong Kong",
        5: "Egypt"
    }

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
            activeScreen() == ACTIVE_SCREEN_IN_GAME ||
            activeScreen() == ACTIVE_SCREEN_PAUSE_MENU_MAIN ||
            activeScreen() == ACTIVE_SCREEN_PAUSE_MENU_PICTURE ||
            activeScreen() == ACTIVE_SCREEN_PAUSE_MENU_SOUND ||
            activeScreen() == ACTIVE_SCREEN_PAUSE_MENU_QUIT
        )
        && playerPointer() != 0
        && selectedPlayMode() == PLAY_MODE_SINGLE_PLAYER,

        "Playing Single Race with Team {0} on {1} {2} • Position {3} • Lap {4}/{5}",

        rich_presence_lookup("Team", playerTeamId(), teamLookup, "Unknown"),             // 0 : Team
        rich_presence_lookup("Location", selectedLocation(), locationLookup, "Unknown"), // 1 : Location
        rich_presence_macro("Number", selectedRaceTrack()),                              // 2 : Track
        rich_presence_macro("Number", playerPosition()),                                 // 3 : Position
        rich_presence_macro("Number", playerLap()),                                      // 4 : Current Lap
        rich_presence_macro("Number", currentRaceTotalLaps())                            // 5 : Total Laps
    )

    // Season Race
    rich_presence_conditional_display(
        (
            activeScreen() == ACTIVE_SCREEN_IN_GAME ||
            activeScreen() == ACTIVE_SCREEN_PAUSE_MENU_MAIN ||
            activeScreen() == ACTIVE_SCREEN_PAUSE_MENU_PICTURE ||
            activeScreen() == ACTIVE_SCREEN_PAUSE_MENU_SOUND ||
            activeScreen() == ACTIVE_SCREEN_PAUSE_MENU_QUIT
        )
        && playerPointer() != 0
        && selectedPlayMode() == PLAY_MODE_SEASON,

        "Playing Season Race {3} with Team {0} on {1} {2}",

        rich_presence_lookup("Team", playerTeamId(), teamLookup, "Unknown"),             // 0 : Team
        rich_presence_lookup("Location", selectedLocation(), locationLookup, "Unknown"), // 1 : Location
        rich_presence_macro("Number", selectedRaceTrack()),                              // 2 : Track
        rich_presence_macro("Number", currentSeasonRaceNumber())                         // 3 : Season Race
    )

    // Time Attack
    rich_presence_conditional_display(
        (
            activeScreen() == ACTIVE_SCREEN_IN_GAME ||
            activeScreen() == ACTIVE_SCREEN_PAUSE_MENU_MAIN ||
            activeScreen() == ACTIVE_SCREEN_PAUSE_MENU_PICTURE ||
            activeScreen() == ACTIVE_SCREEN_PAUSE_MENU_SOUND ||
            activeScreen() == ACTIVE_SCREEN_PAUSE_MENU_QUIT
        )
        && playerPointer() != 0
        && selectedPlayMode() == PLAY_MODE_TIME_ATTACK,

        "Playing Time Attack with Team {0} on {1} {2}",

        rich_presence_lookup("Team", playerTeamId(), teamLookup, "Unknown"),             // 0 : Team
        rich_presence_lookup("Location", selectedLocation(), locationLookup, "Unknown"), // 1 : Location
        rich_presence_macro("Number", selectedRaceTrack())                               // 2 : Track
    )

    // Two Player Modes
    rich_presence_conditional_display(
        activeScreen() == 0
        && (selectedPlayMode() == PLAY_MODE_SPLIT_SCREEN || selectedPlayMode() == PLAY_MODE_HEAD_TO_HEAD)
        && SplitScreenBottomCarPointer() >= 0x80000000
        && SplitScreenTopCarPointer() >= 0x80000000,
        "Playing a Split Screen 2-Player Race"
    )

    rich_presence_display("Preparing to start a new {0} race.",
        rich_presence_lookup("PlayMode", selectedPlayMode(), playModeLookup, "Unknown")
    )
// #endregion Rich Presence
