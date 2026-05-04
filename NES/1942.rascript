// 1942
// #ID = 1515

// #region Memory Locations
    function gameState() => byte(0x0106)
        GAMESTATE_PLAYING = 0xff

    function player1Score() => byte(0x0427) * 100000 + byte(0x0428) * 10000 + byte(0x0429) * 1000 + byte(0x042a) * 100 + byte(0x042b) * 10 + byte(0x042c)
// #endregion Memory Locations

// #regrion Triggers
    function triggerScoreWentOver(targetScore) {
        requiredConditions = 
            gameState() == GAMESTATE_PLAYING

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
// #endregion Triggers

// #region Achivements
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
// #endregion Achievements