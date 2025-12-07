// Target : Renegade
// #ID = 2010

// #region Memory Addresses
	// Addresses : Gameplay State (0x01fe)
	// Current gameplay state, which can be one of the 3 values.
	function gameplayState() => byte(0x01fe)
	GAMEPLAY_STATE_PLAYING=0x20     // The game is currently started.
	GAMEPLAY_STATE_INPUT_NAME=0x24  // The game is waiting for the player to input their name.
	GAMEPLAY_STATE_ATTRACT=0x1d     // The game is in attract mode, showing the title screen and demo play.

	// Addresses : Stage (0x0091)
	// Current stage number, which internaly is zero-based but the function returns it as one-based.
	function stage() => byte(0x0091) + 1

	// Addresses : Game State (0x01fc)
	// Value varies throughout the gamplay but it can be used to determine the current state
	// by looking for transition between PLAYING and STAGE_COMPLETED or GAMEOVER.
	function gameState() => byte(0x01fc)
	GAMESTATE_PLAYING = 0x17          // The player is in a stage, actively playing.
	GAMESTATE_STAGE_COMPLETED = 0x35  // Happens for 1 frame, when the player completes a stage.
	GAMESTATE_GAMEOVER = 0x5d         // Happens for 1 frame, when the player loses all energy.

	// Addresses : Game Screen (0x008f)
	// Value varies throughout the gameplay, but it seams stable on few specific screens.
	function gameScreen() => byte(0x008f)
	GAMESCREEN_LEVEL_BRIEFING = 0x1a   // Level briefing screen, at gamestart and in between stages.
    GAMESCREEN_GAMEOVER_CONTNUE = 0x78 // Game Over and Continue screen.

	// Addresses : Entity Slots (0x03da, 0x03d9, 0x03d8, 0x03d7)
	// The type of entity in the specified slot.
	function entityType(slot) => byte(0x03da-(slot-1))
	ENTITY_TYPE = {
		"Enemy" : {
			"Sleazy Rider": 0x04,
			"Sleezy Rideress": 0x10,
			"Bat Boy": 0x16,
			"South Side Strangler": 0x1a,
			"Dagger Dude": 0x1e,
			"Skate Lord": 0x26,
			"Hammer Head": 0x2e,
			"Karate Clan Member": 0x30,
			"Bouncer": 0x32,
			"Bruise Brigade Member": 0x34
		},
		"Boss" : {
			"Achiles": 0x0a,
			"Siggy": 0x14,
			"Big Bob": 0x1c,
			"Mr. Big": 0x3a
		},
		"Prop" : {
			"Motocycle": 0x02,
			"Fire Extinguisher": 0x12,
			"Baseball Bat": 0x18,
			"Trash Bin": 0x2a,
			"Heart": 0x3e,
		},
		"Porjectile" : {
			"Achile's Tires": 0x08,
			"Dagger Dude's Knife": 0x20,
			"Mr. Big's Bullets or Knifes": 0x3c,
			"Skate Lord's Skateboard": 0x28,
		},
		"Empty": 0xff
	}

	// Addresses : Entity Timer (0x0411, 0x0410, 0x040f, 0x040e)
	// Number of frames left before the heart from a specific slot vanishes.
	//  - When the timer reaches 0x00, the heart vanishes automatically.
	//  - If the player picks up the heart, the timer will stop counting down.
	function entityTimer(slot) => byte(0x0411-(slot-1))

    // Addresses : Enemy State (0x03f3, 0x03f2, 0x03f1, 0x03f0)
    // Current state of the enemy in the specified slot.
    function enemyState(slot) => byte(0x03f3-(slot-1))
    ENEMY_STATE_DYING = 0x0c  // The enemy is in the process of dying, this state lasts for few frames.

	// Addresses : Player Energy (0x00da)
	// Current player energy, which is a value between 0x00 and 0x40.
	function playerEnergy() => byte(0x00da)

	// Addresses : Player Last Action (0x00e0)
	// Returns the last action performed by the player.
	// The value is persisted between frames, once set it will not change until the player performs a new action.
	function playerLastAction() => byte(0x00e0)
	PLAYER_LAST_ACTION = {
		"Punch 1": 0x02b,
		"Punch 2": 0x30,
		"Headbutt": 0x3a,
		"Pickup": 0x42,
		"Throw Extinguisher": 0x57,
		"Swing Baseball Bat": 0x5e,
		"Throw Trash Bin": 0x63
	}

	// Addresses : Player Death Count (0x041b)
	// Gets incremented each time the player dies, and resets to 0 when the game is started.
	// This can be used to determine if the player has used a continue or not.
	function playerDeathCount() => byte(0x041b)

    // Address: Score Digit (0x00c8, 0x00c7, 0x00c6, 0x00c5, 0x00c4, 0x00c3)
    // The score is stored in 6 digits, each digit is stored in a separate byte.
    function scoreDigit(index) => byte(0x03c8-(index-1))

    // Function: Score
    // Returns the current score as a number.
    function score() {
        return
              scoreDigit(6) * 100000
            + scoreDigit(5) * 10000
            + scoreDigit(4) * 1000
            + scoreDigit(3) * 100
            + scoreDigit(2) * 10
            + scoreDigit(1)
    }
// #endregion Memory Addresses

// #region Frame Functions
    // Frame : Stage Completed
    function frameStageCompleted() {
        return
            prev(gameState()) == GAMESTATE_PLAYING
            && gameState() == GAMESTATE_STAGE_COMPLETED
    }

    // Frame : Game Over
    function frameGameOver() {
        return
            prev(gameState()) == GAMESTATE_PLAYING
            && gameState() == GAMESTATE_GAMEOVER
    }

    // Frame : Player Energy Decreased
    function framePlayerEnergyDecreased() {
        return prev(playerEnergy()) > playerEnergy()
    }

    // Frame : Entity Appeared
    // If a specific entity type has appeared in the specified slot.
    function frameEntityAppeared(slot, entityType) {
        return
            prev(entityType(slot)) != entityType
            && entityType(slot) == entityType
    }

    // Frame : Entity Vanished
    // If a specific entity type has vanished from the specified slot.
    function frameEntityVanished(slot, entityType) {
        return
            prev(entityType(slot)) == entityType
            && entityType(slot) != prev(entityType(slot))
            // Strange, RATools complains when writing it like this :
            // && entityType(slot) != entityType
    }

    // Frame : Enemy Died
    // If an enemy entity from a specific slot has died.
    // Note: This is different from "Entity Vanished", as it only counts when the enemy dies,
    // not when it vanishes for other reasons (e.g. going off screen).
    function frameEnemyDied(slot) {
        return
            prev(enemyState(slot)) != ENEMY_STATE_DYING
            && enemyState(slot) == ENEMY_STATE_DYING
    }
// #endregion Frame Functions

// #region Achievement Triggers
    // Trigger : Stage Completed
    // Complete a specific stage.
    function triggerStageCompleted(stageNumber) {
        // Required Conditions
        requiredConditions =
            gameplayState() == GAMEPLAY_STATE_PLAYING
            && stage() == stageNumber

        // Goal Conditions
        goalConditions =
            frameStageCompleted()

        return requiredConditions && goalConditions
    }

    // Trigger : Perfect Boss Fight
    // Defeat a specific boss without taking damage.
    function triggerPerfectBossFight(bossEntityId) {
        // Required Conditions
        requiredConditions =
            gameplayState() == GAMEPLAY_STATE_PLAYING

        // Start & Trigger Conditions
        startAndTriggerConditions =
            // For any of the 4 entity slots
            any_of(range(1,4), slot =>
                // Start when the boss entity has appeared
                once(frameEntityAppeared(slot, bossEntityId))

                // Trigger when the boss entity has vanished
                && trigger_when(frameEntityVanished(slot, bossEntityId))
            )

        // Cancel Conditions
        cancelConditions =
            never(frameGameOver())
            && never(framePlayerEnergyDecreased())
            && never(gameplayState() == GAMEPLAY_STATE_ATTRACT)

        // Return
        return requiredConditions && startAndTriggerConditions && cancelConditions
    }

    // Trigger : Attack Mastery
    // Make a certain number of kills using a specific attack before game over.
    function triggerAttackMastery(attackAction, totalKills) {
        // Required Conditions
        requiredConditions =
            gameplayState() == GAMEPLAY_STATE_PLAYING

        // Goal Conditions
        goalConditions =
            // Count when in any of the 4 entity slots
            tally_of( range(1,4), totalKills, slot =>
                // an enemy entity has vanished
                any_of( ENTITY_TYPE["Enemy"], enemyName =>
                    entityType(slot) == ENTITY_TYPE["Enemy"][enemyName]
                )
                // and the player last action was the specified attack action
                && frameEnemyDied(slot)
                && playerLastAction() == PLAYER_LAST_ACTION[attackAction]
            )

        // Cancel Conditions
        resetConditions =
            never(frameGameOver())
            && never(gameplayState() == GAMEPLAY_STATE_ATTRACT)

        return requiredConditions && measured(goalConditions) && resetConditions
    }

    // Trigger : Hearts Challenge
    // Pick up a certain number of hearts before game over.
    function triggerHeartsChallange(size) {
        // Priming Conditions:
        requiredConditions =
            gameplayState() == GAMEPLAY_STATE_PLAYING

        // Goal Conditions:
        goalCondition =
            // Count when in any of the 4 entity slots
            tally_of(range(1,4), size, slot =>
                // a heart entity has vanished before its timer ran out
                frameEntityVanished(slot, ENTITY_TYPE["Prop"]["Heart"])
                && entityTimer(slot) != 0x00

                // and the player last action was a pickup
                && playerLastAction() == PLAYER_LAST_ACTION["Pickup"]
            )

        // Reset Conditions:
        resetConditions =
            never(frameGameOver())
            && never(gameplayState() == GAMEPLAY_STATE_ATTRACT)

        return requiredConditions && measured(goalCondition) && resetConditions
    }

    // Trigger : One Credit Clear
    // Complete the game without using a continue.
    function triggerOneCreditClear() {
        return 
            gameplayState() == GAMEPLAY_STATE_PLAYING
            && playerDeathCount() == 0
            && once(stage() == 1 && frameStageCompleted())
            && once(stage() == 2 && frameStageCompleted())
            && once(stage() == 3 && frameStageCompleted())
            && once(stage() == 4 && frameStageCompleted())
            && once(stage() == 5 && frameStageCompleted())
            && once(stage() == 6 && frameStageCompleted())
            && once(stage() == 7 && frameStageCompleted())
            && never(frameGameOver())
            && never(gameplayState() == GAMEPLAY_STATE_ATTRACT)
    }

    // Trigger : Score Challenge
    // Score a certain number of points without using a continue.
    function triggerScoreChallenge(targetScore) {
        // Required Conditions
        requiredConditions =
            gameplayState() == GAMEPLAY_STATE_PLAYING
            && playerDeathCount() == 0

        // Goal Conditions
        goalConditions =
            prev(score()) < targetScore
            && score() >= targetScore

        return requiredConditions && goalConditions
    }
// #endregion Achievement Triggers

// #region Achievement Definitions
    // Achievement : Parking Garage 3F
    achievement(
        title = "Parking Garage 3F",
        description = "Complete Stage 1",
        points = 5,
        type = "progression",
        trigger = triggerStageCompleted(1)
    )

    // Achievement : Parking Garage 2F
    achievement(
        title = "Parking Garage 2F",
        description = "Complete Stage 2",
        points = 5,
        type = "progression",
        trigger = triggerStageCompleted(2)
    )

    // Achievement : Parking Garage 1F
    achievement(
        title = "Parking Garage 1F",
        description = "Complete Stage 3",
        points = 5,
        type = "progression",
        trigger = triggerStageCompleted(3)
    )

    // Achievement : Downtown
    achievement(
        title = "Downtown",
        description = "Complete Stage 4",
        points = 10,
        type = "progression",
        trigger = triggerStageCompleted(4)
    )

    // Achievement : The Park
    achievement(
        title = "The Park",
        description = "Complete Stage 5",
        points = 10,
        type = "progression",
        trigger = triggerStageCompleted(5)
    )

    // Achievement : Uptown
    achievement(
        title = "Uptown",
        description = "Complete Stage 6",
        points = 10,
        type = "progression",
        trigger = triggerStageCompleted(6)
    )

    // Achievement : The Pig Pen
    achievement(
        title = "The Pig Pen",
        description = "Complete Stage 7",
        points = 10,
        type = "win_condition",
        trigger = triggerStageCompleted(7)
    )

    /*
    // Achievement : Achiles Belly-Kick Ballet
    achievement (
        title = "Achiles Belly-Kick Ballet",
        description = "Defeat Achiles without taking damage",
        points = 5,
        trigger = triggerPerfectBossFight(ENTITY_TYPE["Boss"]["Achiles"])
    )

    // Achievement : Siggy's Hysteria Treatment
    achievement (
        title = "Siggy's Hysteria Treatment",
        description = "Defeat Siggy without taking damage",
        points = 5,
        trigger = triggerPerfectBossFight(ENTITY_TYPE["Boss"]["Siggy"])
    )

    // Achievement : Big Bob's Abs Check
    achievement (
        title = "Big Bob's Abs Check",
        description = "Defeat Big Bob without taking damage",
        points = 5,
        trigger = triggerPerfectBossFight(ENTITY_TYPE["Boss"]["Big Bob"])
    )

    // Achievement : Mr. Big Disapointment
    achievement (
        title = "Mr. Big Disapointment",
        description = "Defeat Mr. Big without taking damage",
        points = 10,
        trigger = triggerPerfectBossFight(ENTITY_TYPE["Boss"]["Mr. Big"])
    )

    // Achievement : Headbutt Sensei
    achievement (
        title = "Headbutt Sensei",
        description = "Kill 15 enemies by headbutting before game over",
        points = 5,
        trigger = triggerAttackMastery("Headbutt", totalKills=15)
    )

    // Achievement : Baseball Superstar
    achievement (
        title = "Baseball Superstar",
        description = "Kill 10 enemies using the Baseball Bat before game over",
        points = 5,
        trigger = triggerAttackMastery("Swing Baseball Bat", totalKills=10)
    )

    // Achievement : Master Firefighter
    achievement (
        title = "Master Firefighter",
        description = "Kill 5 enemies using the Extinguisher before game over",
        points = 10,
        trigger = triggerAttackMastery("Throw Extinguisher", totalKills=5)
    )

    // Achievement : Skilled Trashman
    achievement (
        title = "Skilled Trashman",
        description = "Kill 3 enemies using the Trash Bin before game over",
        points = 10,
        trigger = triggerAttackMastery("Throw Trash Bin", totalKills=3)
    )

    // Achievement : Heart Collector
    achievement (
        title = "Heart Collector",
        description = "Collect 20 hearts before game over",
        points = 10,
        trigger = triggerHeartsChallange(20)
    )

    // Achivement : One Credit Clear
    achievement (
        title = "One Credit Clear",
        description = "Complete the game without using a continue",
        points = 25,
        trigger = triggerOneCreditClear()
    )

    // Achivement : 5000 Points
    achievement (
        title = "5000 Points",
        description = "Score 5000 points without using a continue",
        points = 5,
        trigger = triggerScoreChallenge(5000)
    )

    // Achivement : 10000 Points
    achievement (
        title = "10000 Points",
        description = "Score 10000 points without using a continue",
        points = 5,
        trigger = triggerScoreChallenge(10000)
    )

    // Achivement : 20000 Points
    achievement (
        title = "20000 Points",
        description = "Score 20000 points without using a continue",
        points = 10,
        trigger = triggerScoreChallenge(20000)
    )
    */
// #endregion Achievement Definitions

// #region Rich Presence
    // Rich Presence : Lookups
    stageNamesLookup = {
        0x01: "Parking Garage 3F",
        0x02: "Parking Garage 2F",
        0x03: "Parking Garage 1F",
        0x04: "Downtown",
        0x05: "the Park",
        0x06: "Uptown",
        0x07: "the Pig Pen"
    }

    enemyNamesLookup = {
        0x02: "Motocycles",
        0x04: "Sleazy Riders",
        0x10: "Sleazy Rideress",
        0x16: "Bat Bosses",
        0x1a: "South Side Stranglers",
        0x1e: "Dagger Dudes",
        0x26: "Skate Lords",
        0x2e: "Hammer Heads",
        0x30: "Karate Clan",
        0x32: "Bouncers",
        0x34: "Bruise Brigade",
        0x0a: "Achiles",
        0x14: "Siggy",
        0x1c: "Big Bob",
        0x3a: "Mr. Big"
    }

    // Rich Presence : Briefing Screen
    rich_presence_conditional_display (
        gameplayState() == GAMEPLAY_STATE_PLAYING && gameScreen() == GAMESCREEN_LEVEL_BRIEFING,
        "{1} Briefing Screen",
        rich_presence_value("StageNumber", stage()),
        rich_presence_lookup("StageName", stage(), stageNamesLookup)
    )

    rich_presence_conditional_display (
        gameplayState() == GAMEPLAY_STATE_PLAYING && gameScreen() == GAMESCREEN_GAMEOVER_CONTNUE,
        "Suffered a defeat in {1}",
        rich_presence_value("StageNumber", stage()),
        rich_presence_lookup("StageName", stage(), stageNamesLookup)
    )

    // Rich Presence : Enemies on Screen
    for enemyType in enemyNamesLookup {
        rich_presence_conditional_display(
            gameplayState() == GAMEPLAY_STATE_PLAYING && any_of(range(1,4), slot => entityType(slot) == enemyType),

            "Fighting {6} in {1} ⸱ ❤️ {2}% ⸱ ⏱️ {3}:{4}{5}",
            rich_presence_value("StageNumber", stage()),
            rich_presence_lookup("StageName", stage(), stageNamesLookup),
            rich_presence_value("PlayerLife", playerEnergy() * 100 / 0x40),
            rich_presence_value("TimeMinutes", byte(0x00e8)),
            rich_presence_value("TimeSecondsX0", byte(0x00ea)),
            rich_presence_value("TimeSeconds0X", byte(0x00eb)),
            enemyNamesLookup[enemyType]
        )
    }

    // Rich Presence : In Gameplay
    rich_presence_conditional_display(
        gameplayState() == GAMEPLAY_STATE_PLAYING,

        "Fighting in {1} ⸱ ❤️ {2}% ⸱ ⏱️ {3}:{4}{5}",
        rich_presence_value("StageNumber", stage()),
        rich_presence_lookup("StageName", stage(), stageNamesLookup),
        rich_presence_value("PlayerLife", playerEnergy() * 100 / 0x40),
        rich_presence_value("TimeMinutes", byte(0x00e8)),
        rich_presence_value("TimeSecondsX0", byte(0x00ea)),
        rich_presence_value("TimeSeconds0X", byte(0x00eb))
    )

    // Rich Presence : Default
    rich_presence_display(
        "Getting Ready to Rumble"
    )
// #endregion Rich Presence