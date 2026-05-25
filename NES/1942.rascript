// 1942
// #ID = 1515

// #region Memory Locations
    FALSE = 0x00
    TRUE = 0x01

    function inMainMenu() => byte(0x0004)
        MM_FALSE = 0x00
    function activePlayer() => byte(0x0386) + 1
    function player1Score() => byte(0x0427) * 100000 + byte(0x0428) * 10000 + byte(0x0429) * 1000 + byte(0x042a) * 100 + byte(0x042b) * 10 + byte(0x042c)
    function livesRemaining() => byte(0x0431) * 10 + byte(0x0432)

    function enemiesShot() => byte(0x0442) * 1000 + byte(0x0443) * 100 + byte(0x0444) * 10 + byte(0x0445)
    function currentStage() => 32 - byte(0x0438)
    function currentStageState() => byte(0x437)
        STAGE_STATE_COMPLETED = 0xff
    function quadShotEquiped() => bit1(0x048e)
    function leftSidePlaneState() => byte(0x048f)
    function righSidePlaneState() => byte(0x0490)
        PLANE_STATE_ATTACHING = 0x8c
        PLANE_STATE_ACTIVE = 0x88

// #endregion Memory Locations

// #regrion Triggers
    function triggerScoreWentOver(targetScore) {
        requiredConditions = 
            inMainMenu() == MM_FALSE

        scoreOverflowCondition = always_false()
        if (targetScore > 1000000 - 20000) {
            scoreOverflowCondition = 
                prev(byte(0x0427)) == 9 && prev(byte(0x0428)) >= 8
                && byte(0x0427) == 0
                && player1Score() > 0
        }

        scoreIncreasedCondition = 
            prev(player1Score()) < targetScore 
            && player1Score() >= targetScore

        return requiredConditions && (scoreIncreasedCondition || scoreOverflowCondition)
    }

    function triggerClearStage(stagesRemaining) {
        return
            inMainMenu() == MM_FALSE
            && currentStage() == stagesRemaining
            && prev(currentStageState()) != STAGE_STATE_COMPLETED
            && currentStageState() == STAGE_STATE_COMPLETED
    }

    function triggerEnemiesShot(target) {
        return
            inMainMenu() == MM_FALSE
            && prev(enemiesShot()) < target
            && measured(enemiesShot() >= target)
    }
// #endregion Triggers

// #region Achivements
    // #region Progress Achievements
        achievement(
            id = 178300,
            title = "Midway",
            description = "Clear through Last 29 Stage",
            points = 5,
            type = "progression",
            trigger = triggerClearStage(29)
        )

        achievement(
            id = 178301,
            title = "Marshall",
            description = "Clear through Last 25 Stage",
            points = 5,
            type = "progression",
            trigger = triggerClearStage(25)
        )

        achievement(
            id = 178302,
            title = "Attu",
            description = "Clear through Last 21 Stage",
            points = 5,
            type = "progression",
            trigger = triggerClearStage(21)
        )

        achievement(
            id = 178303,
            title = "Rabaul",
            description = "Clear through Last 17 Stage",
            points = 5,
            type = "progression",
            trigger = triggerClearStage(17)
        )

        achievement(
            id = 178304,
            title = "Leyte",
            description = "Clear through Last 13 Stage",
            points = 5,
            type = "progression",
            trigger = triggerClearStage(13)
        )

        achievement(
            id = 178305,
            title = "Saipan",
            description = "Clear through Last 9 Stage",
            points = 5,
            type = "progression",
            trigger = triggerClearStage(9)
        )

        achievement(
            id = 178306,
            title = "Iwojima",
            description = "Clear through Last 5 Stage",
            points = 5,
            type = "progression",
            trigger = triggerClearStage(5)
        )

        achievement(
            id = 178307,
            title = "Okinawa",
            description = "Clear through Last 1 Stage",
            points = 5,
            type = "win_condition",
            trigger = triggerClearStage(1)
        )
    // #endregion Progress Achievements
    
    // #region Point Achievements
        achievement(
            title = "Sergeant",
            description = "Earn 100.000 Points",
            trigger = triggerScoreWentOver(100000),
            points = 2
        )

        achievement(
            title = "Master Sergeant",
            description = "Earn 200.000 Points",
            trigger = triggerScoreWentOver(200000),
            points = 2
        )

        achievement(
            title = "First Lieutenant",
            description = "Earn 300.000 Points",
            trigger = triggerScoreWentOver(300000),
            points = 2
        )

        achievement(
            title = "Captain",
            description = "Earn 400.000 Points",
            trigger = triggerScoreWentOver(400000),
            points = 3
        )

        achievement(
            title = "Major",
            description = "Earn 500.000 Points",
            trigger = triggerScoreWentOver(500000),
            points = 3
        )

        achievement(
            title = "Lieutenant Colonel",
            description = "Earn 600.000 Points",
            trigger = triggerScoreWentOver(600000),
            points = 5
        )

        achievement(
            title = "Colonel",
            description = "Earn 700.000 Points",
            trigger = triggerScoreWentOver(700000),
            points = 5
        )

        achievement(
            title = "Brigadier General",
            description = "Earn 800.000 Points",
            trigger = triggerScoreWentOver(800000),
            points = 5
        )

        achievement(
            title = "Major General",
            description = "Earn 900.000 Points",
            trigger = triggerScoreWentOver(900000),
            points = 10
        )

        achievement(
            title = "Lieutenant General",
            description = "Earn 990.000 Points",
            trigger = triggerScoreWentOver(990000),
            points = 25
        )
    // #endregion Point Achievements

    // #region Enemy Shot Achievements
        achievement(
            id = 3608,
            title = "Dogfighter",
            description = "Shoot down 100 Enemy Airplanes",
            points = 2,
            trigger = triggerEnemiesShot(100)
        )

        achievement(
            id = 3609,
            title = "Dogfighter 2",
            description = "Shoot down 500 Enemy Airplanes",
            points = 3,
            trigger = triggerEnemiesShot(500)
        )

        achievement(
            id = 3610,
            title = "Dogfighter 3",
            description = "Shoot down 1000 Enemy Airplanes",
            points = 5,
            trigger = triggerEnemiesShot(1000)
        )

        achievement(
            id = 3611,
            title = "Massacre",
            description = "Shoot down 2000 Enemy Airplanes",
            points = 10,
            trigger = triggerEnemiesShot(2000)
        )

        achievement(
            id = 3612,
            title = "Massacre 2",
            description = "Shoot down 3000 Enemy Airplanes",
            points = 25,
            trigger = triggerEnemiesShot(3000)
        )
    // #endregion Enemy Shot Achievements

    achievement(
        id = 3646,
        title = "Quadshot",
        description = "Get the Quadshot Upgrade",
        points = 2,
        trigger = 
            inMainMenu() == MM_FALSE
            && prev(quadShotEquiped()) == FALSE
            && quadShotEquiped() == TRUE
    )

    achievement(
        id = 3645,
        title = "Swat Kats",
        description = "Obtain 9 Lives",
        points = 25,
        trigger = 
            inMainMenu() == MM_FALSE
            && prev(livesRemaining()) < 9
            && measured(livesRemaining() >= 9, livesRemaining() > 2)
    )

    achievement(
        id = 3613,
        title = "Reinforcements",
        description = "Earn an Extra Life",
        points = 3,
        trigger = 
            prev(inMainMenu()) == MM_FALSE
            && inMainMenu() == MM_FALSE
            && livesRemaining() > prev(livesRemaining())
    )

    achievement(
        id = 3647,
        title = "Twin Fighters",
        description = "Get the Twin Fighters Upgrade",
        points = 3,
        trigger = 
            inMainMenu() == MM_FALSE
            && prev(leftSidePlaneState() != PLANE_STATE_ATTACHING)
            && leftSidePlaneState() == PLANE_STATE_ATTACHING

    )
// #endregion Achievements

// #region Rich Presence
    rich_presence_conditional_display(
        inMainMenu() == MM_FALSE,
        "Last {0} Stage • {1} Lives • {2} Kills • {3}",
        rich_presence_value("Stage", currentStage()),
        rich_presence_value("Lives", livesRemaining()),
        rich_presence_value("Kills", enemiesShot()),
        rich_presence_macro("Score", player1Score()),
        rich_presence_value("Player", activePlayer())
    )

    rich_presence_display("In Main Menu")
// #endregion Rich Presence