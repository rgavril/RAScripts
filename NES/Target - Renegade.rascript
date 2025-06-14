// Target : Renegade
// #ID = 2010

function gameplayState() => byte(0x01fe)
GAMEPLAY_STATE_PLAYING=0x20
GAMEPLAY_STATE_INPUT_NAME=0x24
GAMEPLAY_STATE_ATTRACT=0x1d

function stage() => byte(0x0091) + 1

function gameState() => byte(0x01fc)
GAMESTATE_PLAYING = 0x17
GAMESTATE_STAGE_COMPLETED = 0x35
GAMESTATE_GAMEOVER = 0x5d

function gameScreen() => byte(0x008f)
GAMESCREEN_LEVEL_BRIEFING = 0x1a

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

function entityTimer(slot) => byte(0x0411-(slot-1))

function playerEnergy() => byte(0x00da)

function entityInteraction() => byte(0x03ef)
ENTITY_INTERACTION = {
    "Holding Extinguisher": 0x04,
    "Holding Baseball Bat": 0x08,
	"Holding Trash Bin": 0x0c,
	"None": 0x00
}

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

function playerDeathCount() => byte(0x041b)

function frameStageCompleted() {
	return
		prev(gameState()) == GAMESTATE_PLAYING
		&& gameState() == GAMESTATE_STAGE_COMPLETED
}

function frameGameOver() {
	return
		prev(gameState()) == GAMESTATE_PLAYING
		&& gameState() == GAMESTATE_GAMEOVER
}

function frameEnergyDecreased() {
	return
		playerEnergy() < prev(playerEnergy())
}

function frameEntityAppeared(slot, entityType) {
	return
		prev(entityType(slot)) != entityType
		&& entityType(slot) == entityType
}

function frameEntityVanished(slot, entityType) {
	return
		prev(entityType(slot)) == entityType
		&& entityType(slot) != prev(entityType(slot))
		// Strange, RATools complains when writing it like this :
		// && entityType(slot) != entityType
}

// Trigger : Stage Completed
// Used By :
//	- Parking Garage 3F : stageNumber = 1
//	- Parking Garage 2F : stageNumber = 2
//	- Parking Garage 1F : stageNumber = 3
//	- Downtown          : stageNumber = 4
//	- The Park          : stageNumber = 5
//	- Uptown            : stageNumber = 6
//	- The Pig Pen       : stageNumber = 7
function triggerStageCompleted(stageNumber) {
	// Priming Conditions
	primingConditions =
		gameplayState() == GAMEPLAY_STATE_PLAYING
		&& stage() == stageNumber

	// Goal Conditions
	goalConditions =
		frameStageCompleted()

	return primingConditions && goalConditions
}

// Trigger : Perfect Boss Fight
// Used By :
// 	- Achiles Belly-Kick Ballet   : bossEntityId = ENTITY_TYPE["Boss"]["Achiles"]
// 	- Siggy's Hysteria Treatment  : bossEntityId = ENTITY_TYPE["Boss"]["Siggy"]
// 	- Big Bob's Abs Check         : bossEntityId = ENTITY_TYPE["Boss"]["Big Bob"]
// 	- Mr. Big Disapointment       : bossEntityId = ENTITY_TYPE["Boss"]["Mr. Big"]
function triggerPerfectBossFight(bossEntityId) {
	// Priming Conditions
	primingConditions =
		gameplayState() == GAMEPLAY_STATE_PLAYING

	// Init & Goal Conditions
	goalConditions =
		any_of(range(1,4), slot =>
			once(frameEntityAppeared(slot, bossEntityId))
			&& trigger_when(frameEntityVanished(slot, bossEntityId))
		)

	// Cancel Conditions
	cancelConditions =
		never(frameGameOver())
		&& never(frameEnergyDecreased())

	return primingConditions && goalConditions && cancelConditions
}

// Trigger : Attack Mastery
// Used By :
//	- Headbutt Sensei    : attackAction = "Headbutt"          , totalKills = 15
//	- Baseball Superstar : attackAction = "Swing Baseball Bat", totalKills = 10
//	- Master Firefighter : attackAction = "Throw Extinguisher", totalKills =  5
//	- Skilled Trashman   : attackAction = "Throw Trash Bin"   , totalKills =  3
function triggerAttackMastery(attackAction, totalKills) {
	// Priming Conditions
	primingConditions =
		gameplayState() == GAMEPLAY_STATE_PLAYING

	// Goal Conditions
	goalConditions =
		tally_of( range(1,4), totalKills, slot =>
			any_of( ENTITY_TYPE["Enemy"], enemyName =>
				frameEntityVanished(slot, ENTITY_TYPE["Enemy"][enemyName])
				&& playerLastAction() == PLAYER_LAST_ACTION[attackAction]
			)
		)

	// Cancel Conditions
	cancelConditions =
		never(frameGameOver())

	return primingConditions && measured(goalConditions) && cancelConditions
}

// Trigger : Heart Challange
// Used By :
//	- Heart Collector : size = 10
function triggerHeartsChallange(size) {
	primingConditions =
		gameplayState() == GAMEPLAY_STATE_PLAYING

	goalConditions =
		tally_of(range(1,4), size, slot =>
			playerLastAction() == PLAYER_LAST_ACTION["Pickup"]
			&& frameEntityVanished(slot, ENTITY_TYPE["Prop"]["Heart"])
			&& entityTimer(slot) != 0x00
		)

	cancelConditions =
		never(frameGameOver())

	return primingConditions && measured(goalConditions) && cancelConditions
}

// Trigger : Enemies Count
function triggerEnemiesCount(totalKills) {
	// Priming Conditions
	primingConditions =
		gameplayState() == GAMEPLAY_STATE_PLAYING

	// Goal Conditions
	goalConditions =
		tally_of( range(1,4), totalKills, slot =>
			any_of( ENTITY_TYPE["Enemy"], enemyName =>
				frameEntityVanished(slot, ENTITY_TYPE["Enemy"][enemyName])
			)
		)

	// Pause Conditions
	pauseConditions =
		unless(gameplayState() != GAMEPLAY_STATE_PLAYING)

	return primingConditions && pauseConditions && measured(goalConditions)
}

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
	points = 25,
	type = "win_condition",
	trigger = triggerStageCompleted(7)
)

// Achievement : Achiles Belly-Kick Ballet
achievement (
	title = "Achiles Belly-Kick Ballet",
	description = "Defeat Achiles without taking damage.",
	points = 5,
	trigger = triggerPerfectBossFight(ENTITY_TYPE["Boss"]["Achiles"])
)

// Achievement : Siggy's Hysteria Treatment
achievement (
	title = "Siggy's Hysteria Treatment",
	description = "Defeat Siggy without taking damage.",
	points = 5,
	trigger = triggerPerfectBossFight(ENTITY_TYPE["Boss"]["Siggy"])
)

// Achievement : Big Bob's Abs Check
achievement (
	title = "Big Bob's Abs Check",
	description = "Defeat Big Bob without taking damage.",
	points = 5,
	trigger = triggerPerfectBossFight(ENTITY_TYPE["Boss"]["Big Bob"])
)

// Achievement : Mr. Big Disapointment
achievement (
	title = "Mr. Big Disapointment",
	description = "Defeat Mr. Big without taking damage.",
	points = 10,
	trigger = triggerPerfectBossFight(ENTITY_TYPE["Boss"]["Mr. Big"])
)

// Achievement : Headbutt Sensei
achievement (
	title = "Headbutt Sensei",
	description = "Kill 15 enemies by headbutting before game over.",
	points = 5,
	trigger = triggerAttackMastery("Headbutt", totalKills=15)
)

// Achievement : Baseball Superstar
achievement (
	title = "Baseball Superstar",
	description = "Kill 10 enemies using the Baseball Bat before game over.",
	points = 5,
	trigger = triggerAttackMastery("Swing Baseball Bat", totalKills=10)
)

// Achievement : Master Firefighter
achievement (
	title = "Master Firefighter",
	description = "Kill 5 enemies using the Extinguisher before game over.",
	points = 10,
	trigger = triggerAttackMastery("Throw Extinguisher", totalKills=5)
)

// Achievement : Skilled Trashman
achievement (
	title = "Skilled Trashman",
	description = "Kill 3 enemies using the Trash Bin before game over.",
	points = 10,
	trigger = triggerAttackMastery("Throw Trash Bin", totalKills=3)
)

// Achievement : Heart Collector
achievement (
	title = "Heart Collector",
	description = "Collect 20 hearts before game over.",
	points = 10,
	trigger = triggerHeartsChallange(20)
)

// Achivement : One Credit Clear
achievement (
	title = "One Credit Clear",
	description = "Complete the game without using a continue.",
	points = 25,
	trigger =
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
)

// Achievement : Street Fight Champion
achievement (
	title = "Street Fight Champion",
	description = "Defeat 150 enemies in a single gaming session.",
	points = 10,
	trigger = triggerEnemiesCount(150)
)

// Rich Presence : Lookups
stageNamesLookup = {
	0x01: "parking garage",
	0x02: "parking garage",
	0x03: "garage 1st Level",
	0x04: "downtown",
	0x05: "the park",
	0x06: "uptown",
	0x07: "'The Pig Pen'"
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
	gameplayState() == GAMEPLAY_STATE_PLAYING
	&& gameScreen() == GAMESCREEN_LEVEL_BRIEFING,

	"In {0}, resting.",
	rich_presence_lookup("StageName", stage(), stageNamesLookup)
)

// Rich Presence : Enemies on Screen
for enemyType in enemyNamesLookup {
	rich_presence_conditional_display(
		gameplayState() == GAMEPLAY_STATE_PLAYING
		&& any_of(range(1,4), slot => entityType(slot) == enemyType),

		"In {0}, fighting {1}",
		rich_presence_lookup("StageName", stage(), stageNamesLookup),
		enemyNamesLookup[enemyType]
	)
}

// Rich Presence : In Gameplay
rich_presence_conditional_display(
	gameplayState() == GAMEPLAY_STATE_PLAYING,

	"In {0}, walking.",
	rich_presence_lookup("StageName", stage(), stageNamesLookup)
)

// Rich Presence : Default
rich_presence_display(
	"Getting ready to rumble."
)