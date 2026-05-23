// Sky Destroyer
// #ID = 4794

// #region Memory Locations
    FALSE = 0x00
    TRUE = 0x01
    
    function activePlayer() => bit0(0x0050)+1
    function gameStarted() => bit7(0x0050)

    function sceneNumber() => byte(0x0031) + 1
    function sceneProgress() => byte(0x0030)
    function livesRemaining() => byte(0x002c)
    function score() => tbyte(0x0034)*10
// #endregion Memory Locations

// #region Rich Presence
    sceneProgressLookup = {
        0x00: "Day",
        0x01: "Evening",
        0x02: "Night",
        0x03: "Dawn",
        0x04: "Boss"
    }

    rich_presence_conditional_display(
        gameStarted() == TRUE,
        "Player {0} • Scene {1} ﹫ {2} • {3} Lives • {4}",
        rich_presence_value("Player", activePlayer()),
        rich_presence_value("SceneNumber", sceneNumber()),
        rich_presence_lookup("SceneProgress", sceneProgress(), sceneProgressLookup),
        rich_presence_value("Lives", livesRemaining()),
        rich_presence_macro("Score", score())
    )

    rich_presence_display("In Attract Mode")
// #endregion Rich Presence