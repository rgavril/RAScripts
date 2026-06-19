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
    function torpedoState() => byte(0x0072)
        TORPEDO_STATE_NOT_ON_SCREEN = 0x00
        TORPEDO_STATE_DROPPING = 0xff

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
    function ghostShipDeathAnimation() => byte(0x00ae)
        GHOSTSHIP_DEATH_FRAME1 = 0x27
        GHOSTSHIP_DEATH_FRAME2 = 0x26
    function sumarineDeathAnimation() => byte(0x008f)
        SUBMARINE_DEATH_FRAME1 = 0x0b
        SUBMARINE_DEATH_FRAME2 = 0x0a
    function islandState() => byte(0x0090)
        ISLAND_STATE_ALIVE = 0x03
        ISLAND_STATE_EXPLODING_FRAME1 = 0x04
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

    function frameTorpedoLaunched() {
        return
            prev(torpedoState()) == TORPEDO_STATE_NOT_ON_SCREEN
            && torpedoState() == TORPEDO_STATE_DROPPING
    }

    function frameTorpedoDespawned() {
        return
            prev(torpedoState()) != TORPEDO_STATE_NOT_ON_SCREEN
            && torpedoState() == TORPEDO_STATE_NOT_ON_SCREEN
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

    function triggerKillGhostship() {
        return
            cheatActive() == FALSE
            && gameStarted() == TRUE
            && prev(ghostShipDeathAnimation()) == GHOSTSHIP_DEATH_FRAME1
            && ghostShipDeathAnimation() == GHOSTSHIP_DEATH_FRAME2
    }

    function triggerKillSubmarine() {
        return
            cheatActive() == FALSE
            && gameStarted() == TRUE
            && prev(sumarineDeathAnimation()) == SUBMARINE_DEATH_FRAME1
            && sumarineDeathAnimation() == SUBMARINE_DEATH_FRAME2
    }

    function triggerKillIslandOneHit() {
        primingConditions =
            once(
                prev(islandState()) != ISLAND_STATE_ALIVE
                && islandState() == ISLAND_STATE_ALIVE
            )

        cancelConditions = 
            never(cheatActive() == TRUE)
            && never(gameStarted() == FALSE)
            && never(framePlaneDeathAnimationStarted())
            && never(
                once(frameTorpedoLaunched() && islandState() == ISLAND_STATE_ALIVE)
                && frameTorpedoDespawned() && islandState() == ISLAND_STATE_ALIVE
            )

        targetConditions = 
            prev(islandState()) == ISLAND_STATE_ALIVE
            && islandState() == ISLAND_STATE_EXPLODING_FRAME1

        return primingConditions && cancelConditions && trigger_when(targetConditions)
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

    // Ghost Ship (Appears when Aircraft Carrier is destroyed on it's first sprite-frame state during the night)
    achievement(
        title = "Ghost Ship",
        description = "Shot down an Ghost Ship and earn 100,000 points",
        points = 50,
        trigger = triggerKillGhostship()
    )

    // Submarine
    achievement(
        title = "Submarine",
        description = "Shot down an Submarine",
        points = 10,
        trigger = triggerKillSubmarine()
    )

    // Island in One Hit
    achievement(
        title = "Island One Hit",
        description = "Destroy a fort by firing no more than one torpedo after the fort becomes fully visible",
        points = 25,
        trigger = triggerKillIslandOneHit()
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