// Kid Dracula
// #ID = 2231

function gameState() => byte(0x00c9c0)
GAME_STATE_BOOT_LOGO = 0x00
GAME_STATE_ATTRACT = 0x01
GAME_STATE_START_MENU = 0x02
GAME_STATE_GAME_OVER_MENU = 0x07
GAME_STATE_MINIGAME = 0x0b
GAME_STATE_DEMO_GAMEPLAY = 0x0c
GAME_STATE_END_CREDITS = 0x0d
GAME_STATE_SOUND_TEST = 0x0e

function gameSubState() => byte(0x00c9c1)
SUB_STATE_PASSWORD_SCREEN = 0x06

MiniGameLookup = {
    0x01: "Grab Bat",
    0x02: "Stick' em",
    0x03: "Rock, Paper, Scissors",
    0x04: "Jump & Pop",
    0x05: "Guess the Number",
}

StageLookup = {
    0x01: "Castle",
    0x02: "Forest",
    0x03: "Clouds",
    0x04: "Pirate Ship",
    0x05: "Elevator",
    0x06: "Volcano",
    0x07: "Robot Mine",
    0x08: "Laboratory",
}

rich_presence_conditional_display(
    gameState() == GAME_STATE_BOOT_LOGO || gameState() == GAME_STATE_ATTRACT || gameState() == GAME_STATE_DEMO_GAMEPLAY ,
    "Watching Game's Attract Mode"
)

rich_presence_conditional_display(
    gameState() == GAME_STATE_SOUND_TEST,
    "Doing a Sound Check"
)

rich_presence_conditional_display(
    gameState() == GAME_STATE_END_CREDITS,
    "Watching the End Credits"
)

rich_presence_conditional_display(
    gameState() == GAME_STATE_START_MENU && gameSubState() == SUB_STATE_PASSWORD_SCREEN,
    "Waking Up Kid Dracula"
)

rich_presence_conditional_display(
    gameState() == GAME_STATE_START_MENU,
    "Starting a New Game"
)

rich_presence_conditional_display(
    gameState() == GAME_STATE_GAME_OVER_MENU,
    "Deciding to Continue or Quit"
)

rich_presence_conditional_display(
    gameState() == GAME_STATE_MINIGAME && byte(0x00C8CC) == 0,
    "Selecting a Minigame ⸱ Stage {0} ⸱ Coins: {1}{2}{3}",
    rich_presence_value("Stage", byte(0x00C8C1)),
    rich_presence_value("Hundreds", low4(0x00C8C7)),
    rich_presence_value("Tens", high4(0x00C8C6)),
    rich_presence_value("Ones", low4(0x00C8C6))
)

rich_presence_conditional_display(
    gameState() == GAME_STATE_MINIGAME && byte(0x00C8CC) != 0,
    "Minigame {4} ⸱ Stage {0} ⸱ Coins: {1}{2}{3}",
    rich_presence_value("Stage", byte(0x00C8C1)),
    rich_presence_value("Hundreds", low4(0x00C8C7)),
    rich_presence_value("Tens", high4(0x00C8C6)),
    rich_presence_value("Ones", low4(0x00C8C6)),
    rich_presence_lookup("MiniGame", byte(0x00C8CC), MiniGameLookup)
)


rich_presence_display(
    "Stage {1} {0} ⸱ Lives: {2} ⸱ Heart: {3}/{4} ⸱ Coins: {5}{6}{7}",
    rich_presence_lookup("StageName", byte(0x00C8C1), StageLookup),
    rich_presence_value("StageNumber", byte(0x00C8C1)),
    rich_presence_value("Lives", byte(0x00C8C3)),
    rich_presence_value("Health", byte(0x00C8C8)),
    rich_presence_value("HeartAmount", byte(0x00C8C4)),
    rich_presence_value("Hundreds", low4(0x00C8C7)),
    rich_presence_value("Tens", high4(0x00C8C6)),
    rich_presence_value("Ones", low4(0x00C8C6))
)
