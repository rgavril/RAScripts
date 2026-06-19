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

    function bonusSequenceProgress() => byte(0x00c4)
        BONUS_SEQUENCE_END_MESSAGE = 0xf9
    function redPlanesEscaped() => byte(0x00b3)

    function heavyBomberState() => byte(0x007e)
        HEAVY_BOMBER_EXPLODING_FRAME1 = 0x09
        HEAVY_BOMBER_EXPLODING_FRAME2 = 0x0a
    function aircraftCarrierDeathAnimation() => byte(0x006c)
        AIRCRAFT_CARRIER_NOT_DEAD = 0x00
        AIRCRAFT_CARRIER_EXPLODING_FRAME_1 = 0x1e
    function satelliteState() => byte(0x00a7)
        SATELLITE_STATE_FALLING = 0x02
        SATELLITE_STATE_EXPLODING = 0x04
    function battleshipDeathAnimation() => byte(0x007d)
        BATTLESHIP_DEATH_FRAME1 = 0x09
        BATTLESHIP_DEATH_FRAME2 = 0x08
    function airshipDeathAnimation() => byte(0x00ab)
        AIRSHIP_DEATH_FRAME1 = 0x28
        AIRSHIP_DEATH_FRAME2 = 0x27
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

    function triggerBonusStageWon() {
        return
            cheatActive() == FALSE
            && gameStarted() == TRUE
            && redPlanesEscaped() == 0
            && prev(bonusSequenceProgress()) != BONUS_SEQUENCE_END_MESSAGE
            && bonusSequenceProgress() == BONUS_SEQUENCE_END_MESSAGE
    }

    function triggerKillHeavyBomber() {
        return
            cheatActive() == FALSE
            && gameStarted() == TRUE
            && prev(heavyBomberState()) == HEAVY_BOMBER_EXPLODING_FRAME1
            && heavyBomberState() == HEAVY_BOMBER_EXPLODING_FRAME2
    }

    function triggerKillAircraftCarrier() {
        return
            cheatActive() == FALSE
            && gameStarted() == TRUE
            && prev(aircraftCarrierDeathAnimation()) == AIRCRAFT_CARRIER_NOT_DEAD
            && aircraftCarrierDeathAnimation() == AIRCRAFT_CARRIER_EXPLODING_FRAME_1
    }

    function triggerKillSatellite() {
        return
            cheatActive() == FALSE
            && gameStarted() == TRUE
            && prev(satelliteState()) == SATELLITE_STATE_FALLING
            && satelliteState() == SATELLITE_STATE_EXPLODING
    }

    function triggerKillHighSpeedBattleship() {
        return
            cheatActive() == FALSE
            && gameStarted() == TRUE
            && prev(battleshipDeathAnimation()) == BATTLESHIP_DEATH_FRAME1
            && battleshipDeathAnimation() == BATTLESHIP_DEATH_FRAME2
    }

    function triggerKillAirship() {
        return
            cheatActive() == FALSE
            && gameStarted() == TRUE
            && prev(airshipDeathAnimation()) == AIRSHIP_DEATH_FRAME1
            && airshipDeathAnimation() == AIRSHIP_DEATH_FRAME2
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

    // Bonus Stage
    achievement(
        title = "Bonus Stage",
        description = "Shot down all red planes in from a Bonus Stage and earn 5,000 points",
        points = 10,
        trigger = triggerBonusStageWon()
    )

    // Heavy Bomber 
    achievement(
        title = "Heavy Bomber",
        description = "Take down a Heavy Bomber by destroying all of it's four engines",
        points = 5,
        trigger = triggerKillHeavyBomber()
    )

    // Aircraft Carrier
    achievement(
        title = "Aircraft Carrier",
        description = "Destroy a Aircraft Carrier before it vanishes over the horizon",
        points = 5,
        trigger = triggerKillAircraftCarrier()
    )

    // Sattelite (Appears after 2 heavy bombers are destroyed)
    achievement(
        title = "Satellite",
        description = "Shot down a falling Satellite before it hits the water",
        points = 10,
        trigger = triggerKillSatellite()
    )

    // High-Speed Battleship
    achievement(
        title = "High-Speed Battleship",
        description = "Destroy a High-Speed Battleship",
        points = 5,
        trigger = triggerKillHighSpeedBattleship()
    )

    // Airship (Appears when High-Speed Battleship is destroyed on it's final sprite-frame state)
    achievement(
        title = "Airship",
        description = "Shot down an Airship before it wanishes back behind the clouds",
        points = 25,
        trigger = triggerKillAirship()
    )

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