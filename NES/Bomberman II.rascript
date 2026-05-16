// Bomberman II
// #ID = 1586

// #region Memory Addresses
    TRUE = 0x01
    FALSE = 0x00
    
    function lives() => byte(0x04e5)
    function score() => byte(0x03d0) + byte(0x03d1) * 10 + byte(0x03d2) * 100 + byte(0x03d3) * 1000 + byte(0x03d4) * 10000 + byte(0x03d5) * 100000 + byte(0x03d6) * 1000000

    function area() => byte(0x004b) + 1
        AREA_INTRO = 0x07
    function subArea() => byte(0x004c) + 1

    function sfx() => byte(0x0205)
        SFX_TITLE_SCREEN = 0x01
    function music() => byte(0x0206)
        MUSIC_TITLE_SCREEN = 0x0d
        MUSIC_GAME_MENU = 0x13
        MUSIC_GAME_OVER_JINGLE = 0x19

    function demoMode() => byte(0x03ef)
    function gameMode() => byte(0x0049)
        GAME_MODE_NORMAL = 0x00
        GAME_MODE_VS = 0x01
        GAME_MODE_BATTLE = 0x02
// #endregion Memory Addresses

// #region Leaderboards
leaderboard(
        title = "High Score",
        description = "Highest score achieved in normal mode",
        format = "SCORE",
        start = 
            demoMode() == FALSE
            && gameMode() == GAME_MODE_NORMAL
            && score() > 0
            && prev(lives()) == 0x00
            && lives() == 0xff,
        cancel = always_false(),
        submit = always_true(),
        value = score()
)

// #endregion Leaderboards

// #region Rich Presence
    rich_presence_conditional_display(
        // In Game Menus
            music() & 0x7f == MUSIC_GAME_MENU
        // In Title Screen
            || sfx() & 0x7f == SFX_TITLE_SCREEN
            || music() & 0x7f == MUSIC_TITLE_SCREEN
        // In Game Over Screen
            || music() & 0x7f == MUSIC_GAME_OVER_JINGLE
            || lives() == 0xff
        // During Intro Animation
            || (
                area() == AREA_INTRO // Intro Animation Area
                && gameMode() == GAME_MODE_NORMAL
            )
        // In Demo Mode
            || demoMode() == TRUE,
        "Preparing to Play Bomberman II"
    )

    rich_presence_conditional_display(
        gameMode() == GAME_MODE_NORMAL,
        "Area {0}-{1} ● {2} Lives ● Score {3}",
        rich_presence_value("Area", area()),
        rich_presence_value("SubArea", subArea()),
        rich_presence_value("Lives", lives()),
        rich_presence_macro("Score", score())
    )

    rich_presence_conditional_display(
        gameMode() == GAME_MODE_VS,
        "Multiplayer VS Mode"
    )

    rich_presence_conditional_display(
        gameMode() == GAME_MODE_BATTLE,
        "Multiplayer Battle Mode"
    )

    rich_presence_display("Playing Bomberman II")
// #endregion Rich Presence