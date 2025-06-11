// Target : Renegade
// #ID = 2010

function gameplayState() => byte(0x01fe)
GAMEPLAY_STATE_ACTIVE=0x20
GAMEPLAY_STATE_INPUT_NAME=0x24
GAMEPLAY_STATE_INACTIVE=0x1d

function stage() => byte(0x0091) + 1
stageNameLookup = {
	0x01: "Parking Garage L3",
	0x02: "Parking Garage L2",
	0x03: "Parking Garage L1",
	0x04: "Downtown",
	0x05: "The Park",
	0x06: "Uptown",
	0x07: "The Pig Pen"
}

function gameState() => byte(0x01fc)
GAMESTATE_IN_GAMEPLAY = 0x17
GAMESTATE_LEVEL_COMPLETED = 0x35
GAMESTATE_GAME_OVER = 0x5d

function entity1Type() => byte(0x03da)
function entity2Type() => byte(0x03d9)
function entity3Type() => byte(0x03d8)
function entity4Type() => byte(0x03d7)

entitySlots = range(1,4)
function entityType(slot) => byte(0x03da+slot-1)
ENTITY_TYPE_EMPTY = 0xff

function entity1Energy() => byte(0x0407)
function entity2Energy() => byte(0x0406)
function entity3Energy() => byte(0x0405)
function entity4Energy() => byte(0x0404)

function playerEnergy() => byte(0x00da)

bossesLookup = {
	0x0a: "Achiles", // Belly-Kick Ballet
	0x14: "Siggy",   // Stomp, Don't Be Stomped
	0x1c: "Big Bob",
	0x3a: "Mr. Big"
}

function frameStageCompleted() {
	return
		prev(gameState()) == GAMESTATE_IN_GAMEPLAY
		&& gameState() == GAMESTATE_LEVEL_COMPLETED
}

function frameGameOver() {
	return
		prev(gameState()) == GAMESTATE_IN_GAMEPLAY
		&& gameState() == GAMESTATE_GAME_OVER
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
		&& entityType(slot) == ENTITY_TYPE_EMPTY
}

function triggerStageCompleted(stageNumber) {
	// Priming Conditions
	primingConditions =
		gameplayState() == GAMEPLAY_STATE_ACTIVE
		&& stage() == stageNumber

	// Goal Conditions
	goalConditions =
		frameStageCompleted()

	return primingConditions && goalConditions
}

function triggerBoss(bossId) {
	return
		gameplayState() == GAMEPLAY_STATE_ACTIVE
		&& any_of(range(1,4), slot =>
			once(frameEntityAppeared(slot, bossId))
			&& trigger_when(frameEntityVanished(slot, bossId))
		)
		&& never(frameGameOver())
		&& never(frameTookDamage())
}

for stageIndex in stageNameLookup {
	achievement(
		title = format("{0}", stageNameLookup[stageIndex]),
		description = format("Complete Stage {0}", stageIndex),
		points = 0,
		type = "progression",
		trigger = triggerStageCompleted(stageIndex)
	)
}

for bossIndex in bossesLookup {
	achievement(
		title = format("Humiliate {0}", bossesLookup[bossIndex]),
		description = format("Kill {0} without taking damage.", bossesLookup[bossIndex]),
		points = 0,
		trigger = triggerBoss(bossIndex)
	)
}
