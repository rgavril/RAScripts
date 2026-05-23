// Sky Destroyer
// #ID = 4794

// #region Memory Locations
    FALSE = 0x00
    TRUE = 0x01
    
    function activePlayer() => bit0(0x0050)+1
    function gameStarted() => bit7(0x0050)

    function cheatActive() => bit0(0x0000)

    function sceneNumber() => byte(0x0031) + 1
    function sceneProgress() => byte(0x0030)
    function livesRemaining() => byte(0x002c)
    function score() => tbyte(0x0034)*10
    function bonusStageCounter() => byte(0x00c4)
    function planeDeathAnimation() => byte(0x006d)

    function missonCompletedCountdown() => byte(0x00c0)

// #endregion Memory Locations

// #region Frames
    function frameLivesDecreased() {
        return
            prev(livesRemaining()) > livesRemaining()
    }

    function frameBonusStageFinished() {
        return
            prev(bonusStageCounter()) > 0
            && bonusStageCounter() == 0
    }

    function framePlaneDeathAnimationStarted() {
        return
            prev(planeDeathAnimation()) == 0x00
            && planeDeathAnimation() != 0x00
    }
// #endregion Frames

// #region Triggers
    function triggerCompleteScene(scene) {
        return
            cheatActive() == FALSE
            && gameStarted() == TRUE
            && prev(sceneNumber()) == scene
            && sceneNumber() == scene + 1
            && prev(activePlayer()) == activePlayer()
    }

    function triggerDeathlessScene(scene) {
        primingConditions = 
            sceneNumber() == scene
            && frameBonusStageFinished()
            

        if (scene == 1) {
            primingConditions = 
               prev(gameStarted()) == FALSE
               && gameStarted() == TRUE
        }

        cancelConditions = 
            never(cheatActive() != FALSE)
            && never(gameStarted() != TRUE)
            && never(prev(sceneNumber()) != scene && sceneNumber() != scene)
            && never(frameLivesDecreased())
            && never(framePlaneDeathAnimationStarted())

        triggerConditions =
            prev(sceneNumber() == scene)
            && sceneNumber() == scene + 1

        return once(primingConditions) && cancelConditions && trigger_when(triggerConditions)
    }

    function triggerScore(score) {
        return
            cheatActive() == FALSE
            && gameStarted() == TRUE
            && prev(score()) < score
            && score() >= score
    }
// #endregion Triggers

// #region Leaderboards
    leaderboard(
        title = "Best Shooter",
        description = "Highest score achieved before game over",
        format = "POINTS",
        start = 
            cheatActive() == FALSE
            && gameStarted() == TRUE
            && livesRemaining() == 0
            && framePlaneDeathAnimationStarted(),
        cancel = always_false(),
        submit = always_true(),
        value = score()
    )

    leaderboard(
        title = "Longest Flight",
        description = "Highest scene reached before game over",
        format = "VALUE",
        start = 
            cheatActive() == FALSE
            && gameStarted() == TRUE
            && livesRemaining() == 0
            && framePlaneDeathAnimationStarted(),
        cancel = always_false(),
        submit = always_true(),
        value = sceneNumber()
    )
// #endregion

// #region Achievements
    // #region Stage Clears
        achievement(
            id = 153827,
            title = "Warming Up The Engine",
            description = "Complete Scene 1",
            points = 3,
            type = "progression",
            trigger = triggerCompleteScene(1)
        )

        achievement(
            id = 153829,
            title = "Getting There",
            description = "Complete Scene 5",
            points = 5,
            type = "progression",
            trigger = triggerCompleteScene(5)
        )

        achievement(
            id = 153831,
            title = "I Kindly Claim This",
            description = "Complete Scene 10, the copyright symbol",
            points = 10,
            type = "win_condition",
            trigger = triggerCompleteScene(10)
        )

        achievement(
            id = 153833,
            title = "Sesame Street: Elmo's ABCs",
            description = "Complete Scene 16, the letter A",
            points = 10,
            trigger = triggerCompleteScene(16)
        )
    // #endregion Stage Clears
    
    // #region Stage Clear Deathless
        achievement(
            id = 153828,
            title = "Carrier",
            description = "Complete Scene 1 without dying",
            points = 5,
            trigger = triggerDeathlessScene(1)
        )

        achievement(
            id = 153830,
            title = "Dog Fight",
            description = "Complete Scene 5 without dying",
            points = 10,
            trigger = triggerDeathlessScene(5)
        )

        achievement(
            id = 153832,
            title = "Nintendo Loves It",
            description = "Complete Scene 10 without dying",
            points = 25,
            trigger = triggerDeathlessScene(10)
        )

        achievement(
            id = 153834,
            title = "Mario's Early Years: Fun With Letters",
            description = "Complete Scene 16 without dying",
            points = 25,
            trigger = triggerDeathlessScene(16)
        )

        achievement(
            id = 153835,
            title = "Who Wants To Be A Millionaire?",
            description = "Score over 500,000 points",
            points = 25,
            trigger = triggerScore(500000)
        )
    // #endregion Stage Clear Deathless
// #endregion Achievements

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
        rich_presence_lookup("SceneProgress", sceneProgress() % 4, sceneProgressLookup),
        rich_presence_value("Lives", livesRemaining()),
        rich_presence_macro("Score", score())
    )

    rich_presence_display("In Attract Mode")
// #endregion Rich Presence