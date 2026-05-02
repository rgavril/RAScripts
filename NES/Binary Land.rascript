// Binary Land
// #ID = 4808

// $0012: [8-bit] Game Started
//        0x00 = No
//        0x01 = Yes
//        
//        Found by: SlyShock
function gameStarted() => byte(0x0012)

// $001C: [8-bit] Playing As
//        0x00 = Gurin
//        0x01 = Malon
function playingAs() => byte(0x001C)

// $001D: [8-bit] Round
function round() => byte(0x001D)

// $001E: [8-bit] Lives
//        
//        Found by: FernandoFFS
function lives() => byte(0x001E)

// $0020: [8-bit] Round Won
//        0x01 = True
//        0x00 = False
//        
//        Found by: tele
function roundWon() => byte(0x0020)

// $0025: STAGE TOO

// $0026: [8-bit] Bonus Hears Remaining
//        0x00 = All Collected
function bonusHearsRemaining() => byte(0x0026)

// $0040: [8-bit] [UNSTABLE] Bonus Round Perfect Flag
//        FF=GET ALL HEARTS ON BONUS!
//        07=NENHUM
//        
//        Found by: FernandoFFS
//        
//        WARNING: This is a legacy code note. Seams unstable, please use 0x0026 in your logic.
function unstableBonusRoundPerfectFlag() => byte(0x0040)

// $0055: [8-bit] Time X00
//        
//        NOTE: Although this works and is stable, I would recommend using 0x005b because that memory location stores the actual timer value
//        
//        Found by: FernandoFFS
function timeX00() => byte(0x0055)

// $0056: [8-bit] Time 0X0
//        
//        NOTE: Although this works and is stable, I would recommend using 0x005b because that memory location stores the actual timer value
//        
//        Found by: FernandoFFS
function time0x0() => byte(0x0056)

// $0057: [8-bit] Time 00X
//        
//        NOTE: Although this works and is stable, I would recommend using 0x005b because that memory location stores the actual timer value
//        
//        Found by: FernandoFFS
function time00x() => byte(0x0057)

// $0058: [16-bit] Score / 100
//        Stores the score value divided by 100 since the last two digits are always zero
//        
//        Found by: Slyshock
function score100() => word(0x0058)

// $005B: [16-bit] Time Remaining
//        0x0000 = None / Out of Time
//        
//        Found by: JAM
function timeRemaining() => word(0x005B)

// $0531: [8-bit] [UNSTABLE] Stage Completed Flag
//        08=ENCONTER
//        0A=SECOND FRAME
//        
//        Found by: FernandoFFS
//        
//        WARNING: This is a legacy code note. Seams unstable, please use 0x0020 in your logic.
function unstableStageCompletedFlag() => byte(0x0531)

// $0858: SCORE: 0xx.x00 ?

// $0859: SCORE

achievement(
    title = "A Long Journey Begins...", points = 1,
    description = "Complete Stage 1 as Gurin",
    id = 14361, badge = "621995", published = "10/1/2014 2:55:57 PM", modified = "8/1/2020 1:49:25 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 1 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "You're Blue Now", points = 1,
    description = "Complete Stage 2 as Gurin",
    id = 14362, badge = "621996", published = "10/1/2014 2:56:09 PM", modified = "8/1/2020 1:49:27 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 2 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "Purple Hearts for My Love", points = 1,
    description = "Complete Stage 3 as Gurin",
    id = 14363, badge = "621997", published = "10/1/2014 2:56:13 PM", modified = "8/1/2020 1:49:28 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 3 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "Holding a Candle for You", points = 2,
    description = "Complete Stage 4 as Gurin",
    id = 14364, badge = "621998", published = "10/1/2014 2:56:16 PM", modified = "8/1/2020 1:49:30 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 4 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "Love You to the Moon and Back", points = 2,
    description = "Complete Stage 5 as Gurin",
    id = 14365, badge = "621999", published = "10/1/2014 2:56:18 PM", modified = "8/1/2020 1:49:32 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 5 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "Hey, Look! A Mini-Me!", points = 2,
    description = "Complete Stage 6 as Gurin",
    id = 14366, badge = "622000", published = "10/1/2014 2:56:22 PM", modified = "8/1/2020 1:49:33 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 6 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "An Orchestra for My Love", points = 2,
    description = "Complete Stage 7 as Gurin",
    id = 14367, badge = "622001", published = "10/1/2014 2:56:24 PM", modified = "8/1/2020 1:49:35 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 7 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "Pink Hearts and a Tiny Gurin for You", points = 2,
    description = "Complete Stage 8 as Gurin",
    id = 14368, badge = "622002", published = "10/1/2014 2:56:30 PM", modified = "8/1/2020 1:49:36 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 8 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "Does Love Feel like Flying?", points = 3,
    description = "Complete Stage 9 as Gurin",
    id = 14369, badge = "622003", published = "10/1/2014 2:56:32 PM", modified = "10/3/2014 6:38:52 PM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 9 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "You're the Center of My Universe", points = 3,
    description = "Complete Stage 10 as Gurin",
    id = 14370, badge = "622004", published = "10/1/2014 2:56:34 PM", modified = "10/3/2014 6:38:55 PM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 10 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "My Heart's on My Sleeve", points = 3,
    description = "Complete Stage 11 as Gurin",
    id = 14371, badge = "622005", published = "10/1/2014 2:56:36 PM", modified = "10/3/2014 6:38:57 PM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 11 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "Trapped in Love with You", points = 3,
    description = "Complete Stage 12 as Gurin",
    id = 14372, badge = "622006", published = "10/1/2014 2:56:39 PM", modified = "8/1/2020 1:49:39 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 12 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "Flying Hearts for My Love", points = 5,
    description = "Complete Stage 13 as Gurin",
    id = 14373, badge = "622007", published = "10/1/2014 2:56:41 PM", modified = "11/23/2022 11:24:15 PM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 13 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "An Ember in My Heart", points = 4,
    description = "Complete Stage 14 as Gurin",
    id = 14374, badge = "622008", published = "10/1/2014 2:56:43 PM", modified = "8/1/2020 1:49:42 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 14 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "When We're Old and Grey", points = 4,
    description = "Complete Stage 15 as Gurin",
    id = 14375, badge = "622009", published = "10/1/2014 2:56:46 PM", modified = "8/1/2020 1:49:43 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 15 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "The Color of Pure Love", points = 4,
    description = "Complete Stage 16 as Gurin",
    id = 14376, badge = "622010", published = "10/1/2014 2:56:48 PM", modified = "8/1/2020 1:49:46 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 16 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "Budding Love", points = 4,
    description = "Complete Stage 17 as Gurin",
    id = 14377, badge = "622011", published = "10/1/2014 2:56:50 PM", modified = "8/1/2020 1:49:47 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 17 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "As Deep as the Ocean", points = 5,
    description = "Complete Stage 18 as Gurin",
    id = 14378, badge = "622012", published = "10/1/2014 2:56:52 PM", modified = "10/3/2014 6:39:12 PM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 18 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "I'd Kill a Spider for You", points = 5,
    description = "Complete Stage 19 as Gurin",
    id = 14379, badge = "622013", published = "10/1/2014 2:56:54 PM", modified = "10/24/2019 4:04:01 PM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 19 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "Braving Birds to See My Love", points = 5,
    description = "Complete Stage 20 as Gurin",
    id = 14380, badge = "622014", published = "10/1/2014 2:56:59 PM", modified = "10/15/2019 1:23:01 PM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 20 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "Heart (and Feathers) Aflame", points = 5,
    description = "Complete Stage 21 as Gurin",
    id = 14434, badge = "622015", published = "10/3/2014 6:16:33 PM", modified = "10/15/2019 1:23:01 PM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 21 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "My Love! We Meet at Last!", points = 10, type="win_condition",
    description = "Complete Stage 22 as Gurin",
    id = 14435, badge = "622016", published = "10/3/2014 6:16:36 PM", modified = "8/1/2020 1:49:50 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 22 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "A Quick Journey Begins!", points = 3,
    description = "Complete Stage 1 with 700 or more time left as Gurin",
    id = 14436, badge = "622017", published = "10/3/2014 6:17:19 PM", modified = "8/1/2020 1:49:51 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 1 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 700
)

achievement(
    title = "Quickly Turning Blue", points = 3,
    description = "Complete Stage 2 with 700 or more time left as Gurin",
    id = 14437, badge = "622018", published = "10/3/2014 6:17:22 PM", modified = "8/1/2020 1:49:53 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 2 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 700
)

achievement(
    title = "Perfect Purple Hearts for My Love", points = 3,
    description = "Get a perfect score on Stage 3 as Gurin",
    id = 14438, badge = "622019", published = "10/3/2014 6:17:28 PM", modified = "8/1/2020 1:49:54 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 3 && prev(roundWon()) == 0 && roundWon() == 1 &&
              bonusHearsRemaining() == 0
)

achievement(
    title = "Running with Candles", points = 4,
    description = "Complete Stage 4 with 500 or more time left as Gurin",
    id = 14439, badge = "622020", published = "10/3/2014 6:17:31 PM", modified = "8/1/2020 1:49:55 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 4 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 500
)

achievement(
    title = "Fast as a Rocket", points = 4,
    description = "Complete Stage 5 with 500 or more time left as Gurin",
    id = 14440, badge = "622021", published = "10/3/2014 6:17:33 PM", modified = "8/1/2020 1:49:57 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 5 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 500
)

achievement(
    title = "Can't Stop to Chat!", points = 4,
    description = "Complete Stage 6 with 500 or more time left as Gurin",
    id = 14441, badge = "622022", published = "10/3/2014 6:17:36 PM", modified = "8/1/2020 1:49:59 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 6 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 500
)

achievement(
    title = "Speeding Up the Record", points = 4,
    description = "Complete Stage 7 with 500 or more time left as Gurin",
    id = 14442, badge = "622023", published = "10/3/2014 6:17:38 PM", modified = "8/1/2020 1:50:00 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 7 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 500
)

achievement(
    title = "Perfect Pink Hearts and a Tiny Gurin for the Road", points = 5,
    description = "Get a perfect score on Stage 8 as Gurin",
    id = 14443, badge = "622024", published = "10/3/2014 6:17:41 PM", modified = "8/1/2020 1:50:01 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 8 && prev(roundWon()) == 0 && roundWon() == 1 &&
              bonusHearsRemaining() == 0
)

achievement(
    title = "Flying at the Speed of Sound", points = 5,
    description = "Complete Stage 9 with 500 or more time left as Gurin",
    id = 14444, badge = "622025", published = "10/3/2014 6:17:44 PM", modified = "8/1/2020 1:50:03 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 9 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 500
)

achievement(
    title = "Zoom in the Telescope", points = 5,
    description = "Complete Stage 10 with 400 or more time left as Gurin",
    id = 14445, badge = "622026", published = "10/3/2014 6:17:46 PM", modified = "8/1/2020 1:50:04 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 10 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 400
)

achievement(
    title = "No Time for Bleeding Hearts", points = 5,
    description = "Complete Stage 11 with 400 or more time left as Gurin",
    id = 14446, badge = "622027", published = "10/3/2014 6:17:49 PM", modified = "8/1/2020 1:50:05 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 11 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 400
)

achievement(
    title = "Love Doesn't Have to Be a Trap", points = 5,
    description = "Complete Stage 12 with 400 or more time left as Gurin",
    id = 14447, badge = "622028", published = "10/3/2014 6:17:51 PM", modified = "8/1/2020 1:50:08 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 12 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 400
)

achievement(
    title = "Perfect Flying Hearts for My Love", points = 10,
    description = "Get a perfect score on Stage 13 as Gurin",
    id = 14448, badge = "622029", published = "10/3/2014 6:17:53 PM", modified = "8/1/2020 1:49:40 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 13 && prev(roundWon()) == 0 && roundWon() == 1 &&
              bonusHearsRemaining() == 0
)

achievement(
    title = "A Flaring Ember in My Heart", points = 5,
    description = "Complete Stage 14 with 400 or more time left as Gurin",
    id = 14449, badge = "622030", published = "10/3/2014 6:17:56 PM", modified = "8/1/2020 1:50:11 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 14 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 400
)

achievement(
    title = "Speeding Through Life", points = 5,
    description = "Complete Stage 15 with 400 or more time left as Gurin",
    id = 14450, badge = "622031", published = "10/3/2014 6:17:58 PM", modified = "8/1/2020 1:50:13 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 15 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 400
)

achievement(
    title = "No Time to Analyze Colors!", points = 5,
    description = "Complete Stage 16 with 300 or more time left as Gurin",
    id = 14451, badge = "622032", published = "10/3/2014 6:18:00 PM", modified = "8/1/2020 1:50:14 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 16 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 300
)

achievement(
    title = "Flowering Love", points = 5,
    description = "Complete Stage 17 with 300 or more time left as Gurin",
    id = 14452, badge = "622033", published = "10/3/2014 6:18:02 PM", modified = "8/1/2020 1:50:16 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 17 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 300
)

achievement(
    title = "Perfect Ocean Hearts for My Love", points = 10,
    description = "Get a perfect score on Stage 18 as Gurin",
    id = 14453, badge = "622034", published = "10/3/2014 6:18:05 PM", modified = "10/15/2019 1:23:01 PM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 18 && prev(roundWon()) == 0 && roundWon() == 1 &&
              bonusHearsRemaining() == 0
)

achievement(
    title = "I'd Kill All the Spiders for You", points = 5,
    description = "Complete Stage 19 with 300 or more time left as Gurin",
    id = 14454, badge = "622035", published = "10/3/2014 6:18:08 PM", modified = "8/1/2020 1:50:18 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 19 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 300
)

achievement(
    title = "Moving as Fast as a Comet Flies", points = 5,
    description = "Complete Stage 20 with 300 or more time left as Gurin",
    id = 14455, badge = "622036", published = "10/3/2014 6:18:09 PM", modified = "8/1/2020 1:50:19 AM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 20 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 300
)

achievement(
    title = "A Pink Journey Begins...", points = 1,
    description = "Complete Stage 1 as Malon",
    id = 14459, badge = "622037", published = "10/3/2014 9:37:19 PM", modified = "8/1/2020 1:50:21 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 1 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "Blue Spiders, Blue Walls", points = 1,
    description = "Complete Stage 2 as Malon",
    id = 14460, badge = "622038", published = "10/3/2014 9:37:21 PM", modified = "8/1/2020 1:50:22 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 2 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "Purple Hearts for My Darling", points = 1,
    description = "Complete Stage 3 as Malon",
    id = 14461, badge = "622039", published = "10/3/2014 9:37:23 PM", modified = "8/1/2020 1:50:23 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 3 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "Holding a Candle in My Heart", points = 2,
    description = "Complete Stage 4 as Malon",
    id = 14462, badge = "622040", published = "10/3/2014 9:37:25 PM", modified = "8/1/2020 1:50:25 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 4 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "Love You All the Way to Neptune", points = 2,
    description = "Complete Stage 5 as Malon",
    id = 14463, badge = "622041", published = "10/3/2014 9:37:28 PM", modified = "8/1/2020 1:50:26 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 5 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "Hey, Look! A Mini-You!", points = 2,
    description = "Complete Stage 6 as Malon",
    id = 14464, badge = "622042", published = "10/3/2014 9:37:30 PM", modified = "8/1/2020 1:50:27 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 6 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "A Concert for My Darling", points = 2,
    description = "Complete Stage 7 as Malon",
    id = 14465, badge = "622043", published = "10/3/2014 9:37:32 PM", modified = "8/1/2020 1:50:28 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 7 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "Pink Hearts and a Tiny Love for Me", points = 2,
    description = "Complete Stage 8 as Malon",
    id = 14466, badge = "622044", published = "10/3/2014 9:37:34 PM", modified = "8/1/2020 1:50:30 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 8 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "Flying Through Love", points = 3,
    description = "Complete Stage 9 as Malon",
    id = 14467, badge = "622045", published = "10/3/2014 9:37:36 PM", modified = "10/3/2014 9:39:10 PM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 9 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "You Are My Everything", points = 3,
    description = "Complete Stage 10 as Malon",
    id = 14468, badge = "622046", published = "10/3/2014 9:37:38 PM", modified = "10/3/2014 9:39:12 PM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 10 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "Your Heart's on Your Sleeve", points = 3,
    description = "Complete Stage 11 as Malon",
    id = 14469, badge = "622047", published = "10/3/2014 9:37:40 PM", modified = "10/3/2014 9:39:14 PM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 11 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "Is This Love a Trap?", points = 3,
    description = "Complete Stage 12 as Malon",
    id = 14470, badge = "622048", published = "10/3/2014 9:37:41 PM", modified = "8/1/2020 1:50:33 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 12 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "Flying Hearts for My Darling", points = 3,
    description = "Complete Stage 13 as Malon",
    id = 14471, badge = "622049", published = "10/3/2014 9:37:43 PM", modified = "10/3/2014 9:39:17 PM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 13 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "An Ember in Your Heart", points = 4,
    description = "Complete Stage 14 as Malon",
    id = 14472, badge = "622050", published = "10/3/2014 9:37:46 PM", modified = "8/1/2020 1:50:34 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 14 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "I'll Still Love You, Even Then", points = 4,
    description = "Complete Stage 15 as Malon",
    id = 14473, badge = "622051", published = "10/3/2014 9:37:47 PM", modified = "8/1/2020 1:50:35 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 15 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "The Color of Affection", points = 4,
    description = "Complete Stage 16 as Malon",
    id = 14474, badge = "622052", published = "10/3/2014 9:37:50 PM", modified = "8/1/2020 1:50:37 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 16 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "A Love That's Just Beginning", points = 4,
    description = "Complete Stage 17 as Malon",
    id = 14475, badge = "622053", published = "10/3/2014 9:37:51 PM", modified = "8/1/2020 1:50:41 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 17 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "As Wide as the Sky", points = 5,
    description = "Complete Stage 18 as Malon",
    id = 14476, badge = "622054", published = "10/3/2014 9:37:54 PM", modified = "7/21/2020 2:30:25 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 18 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "I'll Let You Kill Spiders for Me", points = 5,
    description = "Complete Stage 19 as Malon",
    id = 14477, badge = "622055", published = "10/3/2014 9:37:55 PM", modified = "10/15/2019 1:23:01 PM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 19 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "Flying High to See My Darling", points = 5,
    description = "Complete Stage 20 as Malon",
    id = 14478, badge = "622056", published = "10/3/2014 9:37:57 PM", modified = "10/3/2014 9:39:30 PM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 20 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "Braving the Fire", points = 5,
    description = "Complete Stage 21 as Malon",
    id = 14479, badge = "622057", published = "10/3/2014 9:37:59 PM", modified = "10/3/2014 9:39:32 PM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 21 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "My Darling! I Missed You!", points = 10, type="win_condition",
    description = "Complete Stage 22 as Malon",
    id = 14480, badge = "622058", published = "10/3/2014 9:38:02 PM", modified = "8/1/2020 1:50:44 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 22 && prev(roundWon()) == 0 && roundWon() == 1
)

achievement(
    title = "A Quick Pink Journey Begins!", points = 3,
    description = "Complete Stage 1 with 700 or more time left as Malon",
    id = 14481, badge = "622059", published = "10/3/2014 9:38:04 PM", modified = "8/1/2020 1:50:45 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 1 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 700
)

achievement(
    title = "Fast Blue Spiders, Solid Blue Walls", points = 3,
    description = "Complete Stage 2 with 700 or more time left as Malon",
    id = 14482, badge = "622060", published = "10/3/2014 9:38:07 PM", modified = "8/1/2020 1:50:46 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 2 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 700
)

achievement(
    title = "Perfect Purple Hearts for My Darling", points = 3,
    description = "Get a perfect score on Stage 3 as Malon",
    id = 14483, badge = "622061", published = "10/3/2014 9:38:09 PM", modified = "8/1/2020 1:50:48 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 3 && prev(roundWon()) == 0 && roundWon() == 1 &&
              bonusHearsRemaining() == 0
)

achievement(
    title = "This Candle Won't Blow Out", points = 4,
    description = "Complete Stage 4 with 500 or more time left as Malon",
    id = 14484, badge = "622062", published = "10/3/2014 9:38:11 PM", modified = "8/1/2020 1:50:49 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 4 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 500
)

achievement(
    title = "To Neptune and Back at the Speed of Light", points = 4,
    description = "Complete Stage 5 with 500 or more time left as Malon",
    id = 14485, badge = "622063", published = "10/3/2014 9:38:13 PM", modified = "8/1/2020 1:50:50 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 5 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 500
)

achievement(
    title = "No Time for Small Talk", points = 4,
    description = "Complete Stage 6 with 500 or more time left as Malon",
    id = 14486, badge = "622064", published = "10/3/2014 9:38:15 PM", modified = "8/1/2020 1:50:52 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 6 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 500
)

achievement(
    title = "Tempo Up!", points = 4,
    description = "Complete Stage 7 with 500 or more time left as Malon",
    id = 14487, badge = "622065", published = "10/3/2014 9:38:17 PM", modified = "8/1/2020 1:50:54 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 7 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 500
)

achievement(
    title = "Perfect Pink Hearts and a Tiny Love for Me", points = 5,
    description = "Get a perfect score on Stage 8 as Malon",
    id = 14488, badge = "622066", published = "10/3/2014 9:38:19 PM", modified = "8/1/2020 1:50:55 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 8 && prev(roundWon()) == 0 && roundWon() == 1 &&
              bonusHearsRemaining() == 0
)

achievement(
    title = "Flying Fast Through Love", points = 5,
    description = "Complete Stage 9 with 500 or more time left as Malon",
    id = 14489, badge = "622067", published = "10/3/2014 9:38:21 PM", modified = "8/1/2020 1:50:56 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 9 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 500
)

achievement(
    title = "Hold Hands, but Move Quickly", points = 5,
    description = "Complete Stage 10 with 400 or more time left as Malon",
    id = 14490, badge = "622068", published = "10/3/2014 9:38:23 PM", modified = "8/1/2020 1:50:57 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 10 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 400
)

achievement(
    title = "Too Fast to See Your Tells", points = 5,
    description = "Complete Stage 11 with 400 or more time left as Malon",
    id = 14491, badge = "622069", published = "10/3/2014 9:38:24 PM", modified = "8/1/2020 1:50:59 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 11 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 400
)

achievement(
    title = "I'll Free You Quickly!", points = 5,
    description = "Complete Stage 12 with 400 or more time left as Malon",
    id = 14492, badge = "622070", published = "10/3/2014 9:38:26 PM", modified = "8/1/2020 1:51:01 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 12 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 400
)

achievement(
    title = "Perfect Flying Hearts for My Darling", points = 10,
    description = "Get a perfect score on Stage 13 as Malon",
    id = 14493, badge = "622071", published = "10/3/2014 9:38:28 PM", modified = "7/21/2020 2:33:52 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 13 && prev(roundWon()) == 0 && roundWon() == 1 &&
              bonusHearsRemaining() == 0
)

achievement(
    title = "Embers in the Wind", points = 5,
    description = "Complete Stage 14 with 400 or more time left as Malon",
    id = 14494, badge = "622072", published = "10/3/2014 9:38:30 PM", modified = "8/1/2020 1:51:02 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 14 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 400
)

achievement(
    title = "Speeding Through Love", points = 5,
    description = "Complete Stage 15 with 400 or more time left as Malon",
    id = 14495, badge = "622073", published = "10/3/2014 9:38:32 PM", modified = "8/1/2020 1:51:03 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 15 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 400
)

achievement(
    title = "No Time for Color Theory", points = 5,
    description = "Complete Stage 16 with 300 or more time left as Malon",
    id = 14496, badge = "622074", published = "10/3/2014 9:38:34 PM", modified = "8/1/2020 1:51:05 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 16 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 300
)

achievement(
    title = "A Love That's Growing Quickly", points = 5,
    description = "Complete Stage 17 with 300 or more time left as Malon",
    id = 14497, badge = "622075", published = "10/3/2014 9:38:36 PM", modified = "8/1/2020 1:51:06 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 17 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 300
)

achievement(
    title = "As Wide as the Perfect Sky", points = 10,
    description = "Get a perfect score on Stage 18 as Malon",
    id = 14498, badge = "622076", published = "10/3/2014 9:38:37 PM", modified = "10/8/2014 1:56:01 PM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 18 && prev(roundWon()) == 0 && roundWon() == 1 &&
              bonusHearsRemaining() == 0
)

achievement(
    title = "Okay, Maybe Just One Spider", points = 5,
    description = "Complete Stage 19 with 300 or more time left as Malon",
    id = 14499, badge = "622077", published = "10/3/2014 9:38:39 PM", modified = "8/1/2020 1:51:10 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 19 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 300
)

achievement(
    title = "Moving Fast as a Bird Flies", points = 5,
    description = "Complete Stage 20 with 300 or more time left as Malon",
    id = 14500, badge = "622078", published = "10/3/2014 9:38:41 PM", modified = "8/1/2020 1:51:11 AM",
    trigger = gameStarted() == 1 && playingAs() == 1 && round() == 20 && prev(roundWon()) == 0 && roundWon() == 1 &&
              timeRemaining() >= 300
)

achievement(
    title = "Just Getting Started", points = 2,
    description = "Get 60,000 points",
    id = 14502, badge = "622079", published = "10/3/2014 10:50:58 PM", modified = "8/1/2020 1:51:12 AM",
    trigger = gameStarted() == 1 && prev(score100()) < 600 && score100() >= 600
)

achievement(
    title = "Some Bonuses Here and There", points = 3,
    description = "Get 90,000 points",
    id = 14503, badge = "622080", published = "10/3/2014 10:51:01 PM", modified = "8/1/2020 1:51:13 AM",
    trigger = gameStarted() == 1 && prev(score100()) < 900 && score100() >= 900
)

achievement(
    title = "Can You See Through Walls?", points = 5,
    description = "Get 140,000 points",
    id = 14504, badge = "622081", published = "10/3/2014 10:51:03 PM", modified = "8/1/2020 1:51:15 AM",
    trigger = gameStarted() == 1 && prev(score100()) < 1400 && score100() >= 1400
)

achievement(
    title = "Amazing Bonus Finder!", points = 10,
    description = "Get 221,000 points",
    id = 14505, badge = "622082", published = "10/3/2014 10:51:33 PM", modified = "7/21/2020 2:34:07 AM",
    trigger = gameStarted() == 1 && prev(score100()) < 2210 && score100() >= 2210
)

achievement(
    title = "We Can Make It Out Alive", points = 10,
    description = "Complete Stage 20 with 3 or more lives remaining",
    id = 14456, badge = "622083", published = "10/3/2014 6:28:15 PM", modified = "10/24/2019 4:04:01 PM",
    trigger = gameStarted() == 1 && playingAs() == 0 && round() == 20 && prev(roundWon()) == 0 && roundWon() == 1 &&
              lives() >= 3
)

leaderboard(
    id = 3428, title = "Round 1",
    description = "Most time left clearing Round 1",
    start  = round() == 1 && gameStarted() == 1 && timeX00() == 9,
    cancel = round() != 1,
    submit = unstableStageCompletedFlag() == 8 && round() == 1,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()) * 1,
    format = "VALUE"
)

leaderboard(
    id = 3420, title = "Round 2",
    description = "Most time left clearing Round 2",
    start  = round() == 2 && timeX00() == 9,
    cancel = round() != 2,
    submit = unstableStageCompletedFlag() == 8 && round() == 2,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()) * 1,
    format = "VALUE"
)

leaderboard(
    id = 3425, title = "Bonus Round 3",
    description = "Most time left perfecting Bonus Round 3",
    start  = round() == 3 && timeX00() == 4,
    cancel = round() != 3,
    submit = unstableStageCompletedFlag() == 8 && round() == 3 && unstableBonusRoundPerfectFlag() == 255,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()) * 1,
    format = "VALUE"
)

leaderboard(
    id = 3433, title = "Round 4",
    description = "Most time left clearing Round 4",
    start  = round() == 4 && timeX00() == 9,
    cancel = round() != 4,
    submit = unstableStageCompletedFlag() == 8 && round() == 4,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()) * 1,
    format = "VALUE"
)

leaderboard(
    id = 3417, title = "Round 5",
    description = "Most time left clearing Round 5",
    start  = round() == 5 && timeX00() == 9,
    cancel = round() != 5,
    submit = unstableStageCompletedFlag() == 8 && round() == 5,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()) * 1,
    format = "VALUE"
)

leaderboard(
    id = 3430, title = "Round 6",
    description = "Most time left clearing Round 6",
    start  = round() == 6 && timeX00() == 9,
    cancel = round() != 6,
    submit = unstableStageCompletedFlag() == 8 && round() == 6,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()) * 1,
    format = "VALUE"
)

leaderboard(
    id = 3413, title = "Round 7",
    description = "Most time left clearing Round 7",
    start  = round() == 7 && timeX00() == 9,
    cancel = round() != 7,
    submit = unstableStageCompletedFlag() == 8 && round() == 7,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()) * 1,
    format = "VALUE"
)

leaderboard(
    id = 3422, title = "Bonus Round 8",
    description = "Most time left perfecting Bonus Round 8",
    start  = round() == 8 && timeX00() == 4,
    cancel = round() != 8,
    submit = unstableStageCompletedFlag() == 8 && round() == 8 && unstableBonusRoundPerfectFlag() == 247,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()) * 1,
    format = "VALUE"
)

leaderboard(
    id = 3427, title = "Round 9",
    description = "Most time left clearing Round 9",
    start  = round() == 9 && timeX00() == 9,
    cancel = round() != 9,
    submit = unstableStageCompletedFlag() == 8 && round() == 9,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()) * 1,
    format = "VALUE"
)

leaderboard(
    id = 3435, title = "Round 10",
    description = "Most time left clearing Round 10",
    start  = round() == 10 && timeX00() == 7,
    cancel = round() != 10,
    submit = unstableStageCompletedFlag() == 8 && round() == 10,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()) * 1,
    format = "VALUE"
)

leaderboard(
    id = 3419, title = "Round 11",
    description = "Most time left clearing Round 11",
    start  = round() == 11 && timeX00() == 7,
    cancel = round() != 11,
    submit = unstableStageCompletedFlag() == 8 && round() == 11,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()) * 1,
    format = "VALUE"
)

leaderboard(
    id = 3432, title = "Round 12",
    description = "Most time left clearing Round 12",
    start  = round() == 12 && timeX00() == 7,
    cancel = round() != 12,
    submit = unstableStageCompletedFlag() == 8 && round() == 12,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()) * 1,
    format = "VALUE"
)

leaderboard(
    id = 3416, title = "Bonus Round 13",
    description = "Most time left perfecting Bonus Round 13",
    start  = round() == 13 && timeX00() == 3,
    cancel = round() != 13,
    submit = unstableStageCompletedFlag() == 8 && round() == 13 && unstableBonusRoundPerfectFlag() == 248,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()) * 1,
    format = "VALUE"
)

leaderboard(
    id = 3424, title = "Round 14",
    description = "Most time left clearing Round 14",
    start  = round() == 14 && timeX00() == 7,
    cancel = round() != 14,
    submit = unstableStageCompletedFlag() == 8 && round() == 14,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()) * 1,
    format = "VALUE"
)

leaderboard(
    id = 3429, title = "Round 15",
    description = "Most time left clearing Round 15",
    start  = round() == 15 && timeX00() == 7,
    cancel = round() != 15,
    submit = unstableStageCompletedFlag() == 8 && round() == 15,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()) * 1,
    format = "VALUE"
)

leaderboard(
    id = 3411, title = "Round 16",
    description = "Most time left clearing Round 16",
    start  = round() == 16 && timeX00() == 7,
    cancel = round() != 16,
    submit = unstableStageCompletedFlag() == 8 && round() == 16,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()) * 1,
    format = "VALUE"
)

leaderboard(
    id = 3421, title = "Round 17",
    description = "Most time left clearing Round 17",
    start  = round() == 17 && timeX00() == 7,
    cancel = round() != 17,
    submit = unstableStageCompletedFlag() == 8 && round() == 17,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()) * 1,
    format = "VALUE"
)

leaderboard(
    id = 3426, title = "Bonus Round 18",
    description = "Most time left perfecting Bonus Round 18",
    start  = round() == 18 && timeX00() == 3,
    cancel = round() != 18,
    submit = unstableStageCompletedFlag() == 8 && round() == 18 && unstableBonusRoundPerfectFlag() == 254,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()) * 1,
    format = "VALUE"
)

leaderboard(
    id = 3434, title = "Round 19",
    description = "Most time left clearing Round 19",
    start  = round() == 19 && timeX00() == 7,
    cancel = round() != 19,
    submit = unstableStageCompletedFlag() == 8 && round() == 19,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()) * 1,
    format = "VALUE"
)

leaderboard(
    id = 3418, title = "Round 20",
    description = "Most time left clearing Round 20",
    start  = round() == 20 && timeX00() == 7,
    cancel = round() != 20,
    submit = unstableStageCompletedFlag() == 8 && round() == 20,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()) * 1,
    format = "VALUE"
)

leaderboard(
    id = 3442, title = "Round 21",
    description = "Most time left clearing Round 21",
    start  = round() == 21 && timeX00() == 7,
    cancel = round() != 21,
    submit = unstableStageCompletedFlag() == 8 && round() == 21,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()),
    format = "VALUE"
)

leaderboard(
    id = 3484, title = "Round 22",
    description = "Most time left clearing Round 22",
    start  = round() == 22 && timeX00() == 7,
    cancel = round() != 22,
    submit = unstableStageCompletedFlag() == 8 && round() == 22,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()),
    format = "VALUE"
)

leaderboard(
    id = 3485, title = "Bonus Round 23",
    description = "Most time left perfecting Bonus Round 23",
    start  = round() == 23 && timeX00() == 7,
    cancel = round() != 23,
    submit = unstableStageCompletedFlag() == 8 && round() == 23 && unstableBonusRoundPerfectFlag() >= 247,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()),
    format = "VALUE"
)

leaderboard(
    id = 3486, title = "Round 24",
    description = "Most time left clearing Round 24",
    start  = round() == 24 && timeX00() == 7,
    cancel = round() != 24,
    submit = unstableStageCompletedFlag() == 8 && round() == 24,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()),
    format = "VALUE"
)

leaderboard(
    id = 3487, title = "Round 25",
    description = "Most time left clearing Round 25",
    start  = round() == 25 && timeX00() == 7,
    cancel = round() != 25,
    submit = unstableStageCompletedFlag() == 8 && round() == 25,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()),
    format = "VALUE"
)

leaderboard(
    id = 3488, title = "Round 26",
    description = "Most time left clearing Round 26",
    start  = round() == 26 && timeX00() == 7,
    cancel = round() != 26,
    submit = unstableStageCompletedFlag() == 8 && round() == 26,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()),
    format = "VALUE"
)

leaderboard(
    id = 3489, title = "Round 27",
    description = "Most time left clearing Round 27",
    start  = round() == 27 && timeX00() == 7,
    cancel = round() != 27,
    submit = unstableStageCompletedFlag() == 8 && round() == 27,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()),
    format = "VALUE"
)

leaderboard(
    id = 3490, title = "Bonus Round 28",
    description = "Most time left perfecting Bonus Round 28",
    start  = round() == 28 && timeX00() == 7,
    cancel = round() != 28,
    submit = unstableStageCompletedFlag() == 8 && round() == 28 && unstableBonusRoundPerfectFlag() >= 247,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()),
    format = "VALUE"
)

leaderboard(
    id = 3491, title = "Round 29",
    description = "Most time left clearing Round 29",
    start  = round() == 29 && timeX00() == 7,
    cancel = round() != 29,
    submit = unstableStageCompletedFlag() == 8 && round() == 29,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()),
    format = "VALUE"
)

leaderboard(
    id = 3492, title = "Round 30",
    description = "Most time left clearing Round 30",
    start  = round() == 30 && timeX00() == 7,
    cancel = round() != 30,
    submit = unstableStageCompletedFlag() == 8 && round() == 30,
    value  = bcd(timeX00()) * 100 + bcd(time0x0()) * 10 + bcd(time00x()),
    format = "VALUE"
)

leaderboard(
    id = 3423, title = "High Score",
    description = "Highest score achieved",
    start  = round() == 1 && gameStarted() == 1 && timeX00() == 9,
    cancel = gameStarted() == 0,
    submit = lives() == 0,
    value  = score100() * 100,
    format = "VALUE"
)

leaderboard(
    id = 5643, title = "High Stage (Gurin)",
    description = "Highest Stage Reached playing as Gurin",
    start  = round() == 1 && gameStarted() == 1 && timeX00() == 9 && playingAs() == 0,
    cancel = gameStarted() == 0,
    submit = lives() == 0,
    value  = round(),
    format = "VALUE"
)

leaderboard(
    id = 5644, title = "High Stage (Malon)",
    description = "Highest Stage Reached playing as Malon",
    start  = round() == 1 && gameStarted() == 1 && timeX00() == 9 && playingAs() == 1,
    cancel = gameStarted() == 0,
    submit = lives() == 0,
    value  = round(),
    format = "VALUE"
)
