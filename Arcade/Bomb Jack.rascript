// Bomb Jack
// #ID = 12011

GameStarted  = byte(0x0070)
ActivePlayer = byte(0x027)

PowerBallColor   = byte(0x045f)

LuckyCoinType  = byte(0x090c)
LuckyCoinState = byte(0x0900)

BonusMultiplier = byte(0x01ac)
PowerUpTimer = byte(0x0036)


// Check if the player collected Power Ball of a specific color
function PowerBallCollected(color) {
    return
        // A Power Ball colored 'color' disappeared
        prev(PowerBallColor == color) && PowerBallColor == 0x00
        
        &&
        
        // Player's power up timer increased
        prev(PowerUpTimer) == 0 && PowerUpTimer > 0
}

// Power to the Max
achievement(
    title = "Power to the Max",
    description = "Collect a gray Power Ball.",
    points = 0,
    trigger =
        // Player1 is in a game
        GameStarted == 0x01 && ActivePlayer == 0x00 &&
        
        // A P-Coin was on screen
        prev(PowerBallColor) != 0x00 &&
        
        trigger_when(
            // A grey P-Coin was collected
            PowerBallCollected(color = 0x07)
        )
)

// Touch the Rainbow
achievement(
    title = "Touch The Rainbow",
    description = "Get a Power Ball of each color: Blue, Red, Pink, Green, Aqua, Yellow and Gray.",
    points = 0,
    trigger =
        // Player1 in currently playing a game
        GameStarted == 0x01 && ActivePlayer == 0x00 &&
        
        measured(
            tally(
                7,
                once ( PowerBallCollected(color = 0x01) ), // One blue P-Coin was collected
                once ( PowerBallCollected(color = 0x02) ), // One red P-Coin was collected
                once ( PowerBallCollected(color = 0x03) ), // One pink P-Coin was collected
                once ( PowerBallCollected(color = 0x04) ), // One green P-Coin was collected
                once ( PowerBallCollected(color = 0x05) ), // One cyan P-Coin was collected
                once ( PowerBallCollected(color = 0x06) ), // One yellow P-Coin was collected
                once ( PowerBallCollected(color = 0x07) )  // One gray P-Coin was collected
            )
      )
)

achievement(
    title = "Double Up on Points",
    description = "Get a Bonus Coin and set the multiplier to X2.",
    points = 0,
    trigger = 
        // Player1 is in a game
        GameStarted == 0x01 && ActivePlayer == 0x00 &&
        
        // Bonus Coin was on screen
        prev(LuckyCoinState) == 0x07 && prev(LuckyCoinType) == 0x01 &&
        
        // Bonus Multiplier was 'X1'
        prev(BonusMultiplier) == 0x00 &&
        
        trigger_when(
            // Bonus Multiplier Increased
            BonusMultiplier > prev(BonusMultiplier)
        )
)

achievement(
    title = "I Got Five on It",
    description = "Get four Bonus Coins and set the multiplier to X5.",
    points = 0,
    trigger = 
        // Player1 in currently playing a game
        GameStarted == 0x01 && ActivePlayer == 0x00 &&
        
        // Bonus Coin was on screen
        prev(LuckyCoinState) == 0x07 && prev(LuckyCoinType) == 0x01 &&
        
        // Bonus Multiplier was 'X4'
        prev(BonusMultiplier) == 0x03 &&
        
        trigger_when(
            // Bonus Multiplier Increased
            BonusMultiplier > prev(BonusMultiplier)
        )
)