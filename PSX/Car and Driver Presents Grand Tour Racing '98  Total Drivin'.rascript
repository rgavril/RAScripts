// Car and Driver Presents Grand Tour Racing '98 | Total Drivin'
// #ID = 25969

// #region Memory Addresses
    function activeScreen() => dword(0x0c1718)
    ACTIVE_SCREEN_IN_GAME = 0x80090e58
    ACTIVE_SCREEN_PAUSE_MENU_MAIN = 0x800ac898
    ACTIVE_SCREEN_PAUSE_MENU_PICTURE = 0x800acadc 
    ACTIVE_SCREEN_PAUSE_MENU_SOUND = 0x800acba0
    ACTIVE_SCREEN_PAUSE_MENU_QUIT = 0x800ac6a8

    function selectedLocation() => word(0x026910)
    function selectedLevel() => word(0x026918)
    function selectedPlayMode() => word(0x026912)
    PLAY_MODE_SINGLE_PLAYER = 0x00
    PLAY_MODE_TIME_ATTACK = 0x01
    PLAY_MODE_SEASON = 0x02
    PLAY_MODE_SPLIT_SCREEN = 0x03
    PLAY_MODE_HEAD_TO_HEAD = 0x04

    function currentRaceTotalLaps() => dword(0x0bd168)
    function currentSeasonRaceNumber() => byte(0x026e56) + 1

    function playerPointer() => dword(0x0b70ec)
    function playerPosition() => dword(tbyte(0x0b70ec)+0x590)
    function playerTeamId() => byte(tbyte(0x0b70ec)+0x128)
    function playerLap() => byte(tbyte(0x0b70ec)+0x574)

    function SplitScreenTopCarPointer() => dword(0x0c26a0)
    function SplitScreenBottomCarPointer() => dword(0x0c26a4)
// #endregion Memory Addresses

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
        rich_presence_macro("Number", selectedLevel()),                                  // 2 : Level
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
        rich_presence_macro("Number", selectedLevel()),                                  // 2 : Level
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
        rich_presence_macro("Number", selectedLevel())                                   // 2 : Level
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