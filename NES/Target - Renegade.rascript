// Target : Renegade
// #ID = 2010

function gameplayState() => byte(0x01fe)
GAMEPLAY_STATE_PLAYING=0x20
GAMEPLAY_STATE_INPUT_NAME=0x24
GAMEPLAY_STATE_ATTRACT=0x1d

function stage() => byte(0x0091) + 1

function gameState() => byte(0x01fc)
GAMESTATE_FIGHTING = 0x17
GAMESTATE_STAGE_COMPLETED = 0x35
GAMESTATE_GAMEOVER = 0x5d

function entityType(slot) => byte(0x03da+slot-1)
ENTITY_TYPE = {
	"Enemy" : {
		"Motocycle": 0x02,
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

function playerEnergy() => byte(0x00da)

function frameStageCompleted() {
	return
		prev(gameState()) == GAMESTATE_FIGHTING
		&& gameState() == GAMESTATE_STAGE_COMPLETED
}

function frameGameOver() {
	return
		prev(gameState()) == GAMESTATE_FIGHTING
		&& gameState() == GAMESTATE_GAMEOVER
}

function frameTookDamage() {
	return
		prev(playerEnergy()) > playerEnergy()
}

function frameEntityAppeared(slot, entityType) {
	return
		prev(entityType(slot)) != entityType
		&& entityType(slot) == entityType
}

function frameEntityVanished(slot, entityType) {
	return
		prev(entityType(slot)) == entityType
		&& entityType(slot) == ENTITY_TYPE["Empty"]
}

// Trigger : Stage Completed
// Used By :
//	- Garage Level 3 : stageNumber = 1
//	- Garage Level 2 : stageNumber = 2
//	- Garage Level 1 : stageNumber = 3
//	- Downtown       : stageNumber = 4
//	- The Park       : stageNumber = 5
//	- Uptown         : stageNumber = 6
//	- The Pig Pen    : stageNumber = 7
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
// Used By:
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
		&& never(frameTookDamage())

	return primingConditions && goalConditions && cancelConditions
}

// Trigger : Weapon Mastery
function triggerWeaponMaster(count, )

// Achievement : Garage Level 3
achievement(
	title = "Garage Level 3",
	description = "Complete Stage 1",
	points = 0,
	type = "progression",
	trigger = triggerStageCompleted(1)
)

// Achievement : Garage Level 2
achievement(
	title = "Garage Level 2",
	description = "Complete Stage 2",
	points = 0,
	type = "progression",
	trigger = triggerStageCompleted(2)
)

// Achievement : Garage Level 1
achievement(
	title = "Garage Level 1",
	description = "Complete Stage 3",
	points = 0,
	type = "progression",
	trigger = triggerStageCompleted(3)
)

// Achievement : Downtown
achievement(
	title = "Downtown",
	description = "Complete Stage 4",
	points = 0,
	type = "progression",
	trigger = triggerStageCompleted(4)
)

// Achievement : The Park
achievement(
	title = "The Park",
	description = "Complete Stage 5",
	points = 0,
	type = "progression",
	trigger = triggerStageCompleted(5)
)

// Achievement : Uptown
achievement(
	title = "Uptown",
	description = "Complete Stage 6",
	points = 0,
	type = "progression",
	trigger = triggerStageCompleted(6)
)

// Achievement : The Pig Pen
achievement(
	title = "The Pig Pen",
	description = "Complete Stage 7",
	points = 0,
	type = "win_condition",
	trigger = triggerStageCompleted(7)
)

// Achievement : Achiles Belly-Kick Ballet
achievement (
	title = "Achiles Belly-Kick Ballet",
	description = "Kill Achiles without taking damage.",
	points = 0,
	trigger = triggerPerfectBossFight(ENTITY_TYPE["Boss"]["Achiles"])
)

// Achievement : Siggy's Hysteria Treatment
achievement (
	title = "Siggy's Hysteria Treatment",
	description = "Kill Siggy without taking damage.",
	points = 0,
	trigger = triggerPerfectBossFight(ENTITY_TYPE["Boss"]["Siggy"])
)

// Achievement : Big Bob's Abs Check
achievement (
	title = "Big Bob's Abs Check",
	description = "Kill Big Bob without taking damage.",
	points = 0,
	trigger = triggerPerfectBossFight(ENTITY_TYPE["Boss"]["Big Bob"])
)

// Achievement : Mr. Big Disapointment
achievement (
	title = "Mr. Big Disapointment",
	description = "Kill Mr. Big without taking damage.",
	points = 0,
	trigger = triggerPerfectBossFight(ENTITY_TYPE["Boss"]["Mr. Big"])
)


// Rich Presence : When Game is Started
stageMessageLookup = {
	0x01: "Rumbling with the Sleazy Riders in Garage Level 3",
	0x02: "Rumbling with the Sleazy Riders in Garage Level 2",
	0x03: "Kicking Bat Boys and South Side Stranglers in Garage Level 1",
	0x04: "Annihilating the Dagger Dudes and Bruise Brigade in Downtown",
	0x05: "Cleaning The Park of Skate Lords and Hammer Heads.",
	0x06: "Fighting Karate Klan and Bouncers in Uptown",
	0x07: "Finghing Bouncers and the Bruise Brigade at 'The Pig Pen'"
}
rich_presence_conditional_display(
	gameplayState() == GAMEPLAY_STATE_PLAYING,

	"{0}.",
	rich_presence_lookup("StageMessage", stage(), stageMessageLookup)
)

// Rich Presence : Default
rich_presence_display(
	"Getting ready to rumble."
)
