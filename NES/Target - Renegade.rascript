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

function entity1Energy() => byte(0x0407)
function entity2Energy() => byte(0x0406)
function entity3Energy() => byte(0x0405)
function entity4Energy() => byte(0x0404)

function playerEnergy() => byte(0x00da)

bossesLookup = {
	0x0a: "Achiles",
	0x14: "Siggy",
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

function triggerStageCompleted(stageNumber) {
	return
		gameplayState() == GAMEPLAY_STATE_ACTIVE
		&& stage() == stageNumber
		&& frameStageCompleted()
}

function triggerBoss(bossIndex) {
	return
		gameplayState() == GAMEPLAY_STATE_ACTIVE
		&& (
			once (
				prev(entity1Type()) != bossIndex && entity1Type() == bossIndex
			)
			&& trigger_when(
				entity1Type() == 0xff
			)

			|| once (
				prev(entity2Type()) != bossIndex && entity2Type() == bossIndex
			)
			&& trigger_when(
				entity2Type() == 0xff
			)

			|| once (
				prev(entity3Type()) != bossIndex && entity3Type() == bossIndex
			)
			&& trigger_when(
				entity3Type() == 0xff
			)

			|| once (
				prev(entity4Type()) != bossIndex && entity4Type() == bossIndex
			)
			&& trigger_when(
				entity4Type() == 0xff
			)
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
