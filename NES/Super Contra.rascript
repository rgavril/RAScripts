// Super Contra
// #ID = 1989

// #region Memory Addresses
    function gameState() => byte(0x0018)
    GAME_STATE_DEMO = 0x01
    GAME_STATE_INGAME = 0x04

    function currentArea() => byte(0x0050) + 1
    
    function currentAreaSection() => byte(0x0016)

    function numberOfPlayers() => byte(0x0022) + 1

    class gameObject {
        index = 0

        function type() => byte(0x06d8 + this.index)
        function state() => byte(0x0668 + this.index)
    }

    GAME_OBJECT_TYPES = {
        "Facehugger": 0x3e
    }

    GAME_OBJECT_STATES = {
        "Facehugger": {
            "Death": 0x04,
        }
    }
// #endregion Memory Addresses

// #region Triggers
function triggeChallangeA7_Crawlers() {
    startConditions = 
        once(
            currentArea() == 7
            && currentAreaSection() == 0x00 // Stage Start
        )
        &&
        once(
            currentArea() == 7
            && currentAreaSection() == 0x08 // Vertical Shaft End & Eggs Room Start
        )
   
    cancelConditions =
           never(gameState()       != GAME_STATE_INGAME )
        && never(currentArea()     != 7                 )
        && never(numberOfPlayers() == 2                 )

    deathCrawlerCondition = 
        any_of(range(0, 13), index =>
            gameObject(index).type() == GAME_OBJECT_TYPES["Facehugger"]
            && gameObject(index).state() == GAME_OBJECT_STATES["Facehugger"]["Death"]
        )

    triggerCondition = 
        currentArea() == 7
        && prev(currentAreaSection()) == 0x0b // Eggs Room End
        && currentAreaSection() == 0x0c       // Boss Room

    return cancelConditions && startConditions && trigger_when(triggerCondition) && never(deathCrawlerCondition)
}
// #endregion Triggers

// #region Achievements
achievement(
    title = "Test",
    description = "Test",
    points = 0,
    trigger = triggeChallangeA7_Crawlers()
)
// #endregion Achievements