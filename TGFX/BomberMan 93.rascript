// BomberMan '93 (TGFX)
// #ID = 2277

// #region Memory Locations
    function planet() => byte(0x1895)
    function stage() => byte(0x1896) + 1
    function score() => tbyte(0x00b2) * 100
    function livesRemaining() => byte(0x189f)
    function continuesRemaining() => byte(0x18a2)

    function gameState() => byte(0x18a1)
    GAME_STATE_MAIN_MENU = 0x00

    function mainMenuActivatedOption() => byte(0x1c72)
    MAIN_MENU_NORMAL_GAME = 0x00
    MAIN_MENU_BATTLE_GAME = 0x01
    MAIN_MENU_COM_LINK = 0x02
    MAIN_MENU_PASSWORD = 0x03
    MAIN_MENU_LOAD = 0x04
    MAIN_MENU_NONE = 0x05

    function battleModeTotalPlayers() => byte(0x189e)
// #endregion Memory Locations

// #region Rich Presence
    planetNameLookup = {
        0x00: "Quarry",
        0x01: "Blossom",
        0x02: "Inferno",
        0x03: "Wither",
        0x04: "Surf",
        0x05: "Icicle",
        0x06: "Techo"
    }

    planetLetterLookup = {
        0x00: "A",
        0x01: "B",
        0x02: "C",
        0x03: "D",
        0x04: "E",
        0x05: "F",
        0x06: "G"  
    }

    gameModifierLookup = {
        MAIN_MENU_PASSWORD: "ᵖ",
        MAIN_MENU_LOAD: "ˢ",
        MAIN_MENU_BATTLE_GAME: ""
    }

    rich_presence_conditional_display(
        gameState() != GAME_STATE_MAIN_MENU
        && mainMenuActivatedOption() == MAIN_MENU_COM_LINK,

        "Com-Link Game",
        rich_presence_value("BattleModePlayers", battleModeTotalPlayers())
    )

    rich_presence_conditional_display(
        gameState() != GAME_STATE_MAIN_MENU
        && mainMenuActivatedOption() == MAIN_MENU_BATTLE_GAME,

        "Battle Mode • {0} Player Match",
        rich_presence_value("BattleModePlayers", battleModeTotalPlayers())
    )

    rich_presence_conditional_display(
        gameState() != GAME_STATE_MAIN_MENU && (
            mainMenuActivatedOption() == MAIN_MENU_NORMAL_GAME
            || mainMenuActivatedOption() == MAIN_MENU_PASSWORD
            || mainMenuActivatedOption() == MAIN_MENU_LOAD
        ),

        "Planet {0} {1}-{2} • {3} Lives • {5} Continues • Score {4} {6}",
        rich_presence_lookup("PlanetName", planet(), planetNameLookup),
        rich_presence_lookup("PlanetLetter", planet(), planetLetterLookup),
        rich_presence_value("StageNumber", stage()),
        rich_presence_value("Lives", livesRemaining()),
        rich_presence_macro("Score", score()),
        rich_presence_value("Continues", continuesRemaining()),
        rich_presence_lookup("GameModifier", mainMenuActivatedOption(), gameModifierLookup)
    )

    rich_presence_display(
        "Playing Bomberman 93"
    )

// #endregion Rich Presence