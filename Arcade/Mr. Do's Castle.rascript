// Mr. Do's Castle
// #ID = 12097

FALSE = 0x00
TRUE  = 0x01

// #region Memory Addresses
    function gameState() => byte(0x0001)
    function gameplayActive() => bit7(0x0001)
    function multiplayerMode() => bit5(0x0001)
    function activePlayer() => bit4(0x0001)
    ACTIVE_PLAYER_1 = 0
    ACTIVE_PLAYER_2 = 1

    function dipSwitchLives() => byte(0x0004)

    function dipSwitchDifficulty() => byte(0x0005)
    DIFFICULTY_1   = 0x02
    DIFFICULTY_2   = 0x04
    DIFFICULTY_3   = 0x06
    DIFFICULTY_4   = 0x08
    DIFFICULTY_DEFAULT = DIFFICULTY_1

    function sceneCompletedFlag() => byte(0x00a0)
    SCENE_COMPLETED_FLAG_ON = 0xc0

    function postStatus() => byte(0x00d3)
    POST_STATUS_FINISHED = 0x01

    function scene() => byte(0x0100)
    function lives() => byte(0x0103)
    function enemyCount() => byte(0x0104)
    function cherryRemaining() => byte(0x0105)
    function score_XX0000() => bcd(byte(0x010d))
    function score_00XX00() => bcd(byte(0x010e))
    function score_0000XX() => bcd(byte(0x010f))
    function score() => (score_XX0000() * 10000) + (score_00XX00() * 100) + score_0000XX()
    function keysCollected() => byte(0x0110)
    function lettersCollected() => byte(0x011a)
    function letterCollected_E() => bit7(0x011a)
    function letterCollected_X() => bit6(0x011a)
    function letterCollected_T() => bit5(0x011a)
    function letterCollected_R() => bit4(0x011a)
    function letterCollected_A() => bit3(0x011a)
    function shieldActive() => byte(0x011b)
    function shieldTimeRemaining() => byte(0x011c)
    function playerState() => byte(0x0150)
    function playerFalling() => bit1(playerState())
    function playerDying() => bit2(playerState())
    function playerUsingHammer() => bit5(playerState())
    function playerIsSpawned() => bit6(0x0150)
    function shieldCollected() => byte(0x011b)

    function enemiesSpawned() => bit6(0x02b0)
    function enemiesDieying() => bit2(0x02b0)

    class monster {
        index = 0

        function deathSequenceStarted() => bit1(0x179 + this.index*0x20)

        function frameIsDyeing() {
            return 
                prev(this.deathSequenceStarted() == FALSE)
                && this.deathSequenceStarted() == TRUE
        }

        function floorsDropped() => byte(0x018d + this.index*0x20)
    }
// #endregion Memory Addresses

// #region Frame IDs
    function framePlayer1LivesZeroed() {
        return
            gameplayActive() == TRUE
            && activePlayer() == ACTIVE_PLAYER_1
            && prev(activePlayer()) == ACTIVE_PLAYER_1
            && prev(lives()) == 1 && lives() == 0
    }

    function frameLivesZeroed() {
        return prev(lives()) == 1 && lives() == 0
    }

    function frameLivesDecreased() {
        return
            lives() < prev(lives()) 
    }

    function framePlayer1ScoreOverflowed() {
        return
            gameplayActive() == TRUE
            && prev(activePlayer()) == ACTIVE_PLAYER_1 && activePlayer() == ACTIVE_PLAYER_1
            && prev(score_XX0000()) == 99
            && score_XX0000() == 00
    }

    function frameSceneCompletedFlagRaised() {
        return
            prev(sceneCompletedFlag()) != SCENE_COMPLETED_FLAG_ON
            && sceneCompletedFlag() == SCENE_COMPLETED_FLAG_ON
    }

    function frameAdvancedToScene(scene) {
        return
            gameplayActive() == TRUE
            
            && prev(activePlayer()) == ACTIVE_PLAYER_1
            && prev(scene()) == scene-1 
            
            && activePlayer() == ACTIVE_PLAYER_1
            && scene() == scene   
    }

    function frameGameStarted() {
        return
            prev(gameplayActive()) == FALSE
            && gameplayActive() == TRUE
    }

    function frameCherriesRemainingZeroed() {
        return prev(cherryRemaining()) == 1 && cherryRemaining() == 0
    }

    function frameShieldCollected() {
        return
            prev(shieldCollected()) == FALSE
            && shieldCollected() == TRUE
    }

    function frameExtraFlagsCompleted() {
        return
            prev(lettersCollected()) & 0xf8 != 0xf8
            && lettersCollected() & 0xf8 == 0xf8
    }
// #endregion Frame IDs

// #region Triggers
    function triggerSceneProgression(startScene, endScene) {
        goalConditions = always_true()
        for sceneIndex in range(startScene, endScene) {
            goalConditions = goalConditions 
                && once ( scene() == sceneIndex && frameSceneCompletedFlagRaised() )
        }

        cancelConditions =
               never( postStatus()      != POST_STATUS_FINISHED )
            && never( dipSwitchLives()  >  3                    )
            && never( gameplayActive()  != TRUE                 )
            && never( multiplayerMode() == TRUE                 )
            && never( frameLivesZeroed() )

        return cancelConditions && goalConditions
    }

    function triggerCherryPicker(sceneNumber) {
        primingConditions = once(
            prev(scene() == sceneNumber - 1 )
            && scene() == sceneNumber
        )

        requiredConditions =
            scene() == sceneNumber
        
        goalConditions =
            frameCherriesRemainingZeroed()

        cancelConditions =
               never( postStatus()      != POST_STATUS_FINISHED )
            && never( gameplayActive()  != TRUE                 )
            && never( multiplayerMode() == TRUE                 )
            && never( scene()           != sceneNumber          )
            && never( frameLivesDecreased() )

        return cancelConditions && primingConditions && requiredConditions && trigger_when(goalConditions)
    }

    function triggerStarvation() {
        primingConditions =
            once(scene() == 1 && frameCherriesRemainingZeroed())
        
        goalConditions =
            once(scene() == 2 && frameCherriesRemainingZeroed())
            && once(scene() == 3 && frameCherriesRemainingZeroed())
            && once(scene() == 4 && frameCherriesRemainingZeroed())

        cancelConditions =
               never( postStatus()      != POST_STATUS_FINISHED )
            && never( dipSwitchLives()  >  3                    )
            && never( gameplayActive()  != TRUE                 )
            && never( multiplayerMode() == TRUE                 )
            && never( frameLivesZeroed() )
        
        return cancelConditions && primingConditions && trigger_when(goalConditions)
    }

    function triggerAlphaStreak(size) {
        goalConditions = 
            tally_of(range(1,8), size, difference => prev(enemyCount()) - enemyCount() >= difference)

        cancelConditions =
            never(postStatus() != POST_STATUS_FINISHED)
            && never(gameplayActive() != TRUE)
            && never(activePlayer() != ACTIVE_PLAYER_1)
            && never(shieldActive() != TRUE)
            && never(scene() != scene())
        
        return cancelConditions && measured(goalConditions)
    }

    function triggerShieldStreak(size) {
        goalConditions = 
            repeated(size, frameShieldCollected())

        cancelConditions =
               never( postStatus()      != POST_STATUS_FINISHED )
            && never( dipSwitchLives()  >  3                    )
            && never( gameplayActive()  != TRUE                 )
            && never( multiplayerMode() == TRUE                 )
            && never( frameLivesZeroed() )
            && never( frameSceneCompletedFlagRaised() && keysCollected() != 0xff)
        
        return cancelConditions && measured(goalConditions)
    }

    function triggerExtraLife() {
        goalConditions =
               postStatus()      == POST_STATUS_FINISHED
            && dipSwitchLives()  <=  3
            && gameplayActive()  == TRUE
            && multiplayerMode() == FALSE
            && frameExtraFlagsCompleted()
        
        return goalConditions
    }

    function triggerExtraLives(size) {
        goalCondition =
            repeated(size, frameExtraFlagsCompleted())

        cancelConditions =
               never( postStatus()      != POST_STATUS_FINISHED )
            && never( dipSwitchLives()  >  3                    )
            && never( gameplayActive()  != TRUE                 )
            && never( multiplayerMode() == TRUE                 )
            && never( frameLivesZeroed() )

        return cancelConditions && measured(goalCondition)
    }

    function triggerScoreXX0000(tensOfThousands) {
        goalConditions =
               postStatus()      == POST_STATUS_FINISHED
            && dipSwitchLives()  <=  3
            && gameplayActive()  == TRUE
            && multiplayerMode() == FALSE
            
            && prev(bcd(score_XX0000())) < tensOfThousands
            && bcd(score_XX0000())   >= tensOfThousands
        
        return goalConditions
    }

    function triggerOneLifeStreak(size) {
        goalConditions = 
            tally_of(range(1,8), size, 
            difference => 
                enemiesSpawned() == TRUE &&
                prev(enemyCount()) - enemyCount() >= difference
        )

        cancelConditions =
               never( postStatus()      != POST_STATUS_FINISHED)
            && never( gameplayActive()  != TRUE                )
            && never( multiplayerMode() == TRUE                )
            && never( frameLivesDecreased() )

        pauseConditions =
            unless( shieldActive() == TRUE )
        
        return cancelConditions && pauseConditions && measured(goalConditions)
    }

    function triggerOneHitStreak(size) {
        goalConditions = 
            tally_of(range(1,8), size, 
            difference => 
                enemiesSpawned() == TRUE &&
                prev(enemyCount()) - enemyCount() >= difference
        )

        cancelConditions =
               never( postStatus()      != POST_STATUS_FINISHED )
            && never( gameplayActive()  != TRUE                 )
            && never( multiplayerMode() == TRUE                 )
            && never( enemiesDieying()  == FALSE                )

        pauseConditions =
            unless( shieldActive() == TRUE )
        
        return cancelConditions && pauseConditions && goalConditions
    }

    function triggerUnicornDrop(floors) {
        goalConditions =
               postStatus()      == POST_STATUS_FINISHED
            && gameplayActive()  == TRUE
            && multiplayerMode() == FALSE
            
            && any_of(range(0,7), index => 
                prev(monster(index).floorsDropped() == floors-1) 
                && monster(index).floorsDropped() == floors
            )

        return goalConditions 
    }
// #endregion Triggers

// #region Achievements
    // #region Progress Achievements
        achievement(
            title = "Castle Castellan",
            description = "Complete Scene 2 in a 3 lives or less game",
            type = "progression",
            points = 3,
            trigger = triggerSceneProgression(1, 2)
        )

        achievement(
            title = "High Citadel Lord",
            description = "Complete Scene 4 in a 3 lives or less game",
            type = "win_condition",
            points = 5,
            trigger = triggerSceneProgression(1, 4)
        )

        achievement(
            title = "Emperor of the Infinite Loop",
            description = "Complete Scene 8 in a 3 lives or less game",
            points = 10,
            trigger = triggerSceneProgression(1, 8)
        )
    // #endregion

    // #region Cherry Related Achievements
        achievement(
            title = "Cherry Snack",
            description = "Clear all Cherry blocks from Scenes 1 without dying",
            points = 5,
            trigger = triggerCherryPicker(1)
        )

        achievement(
            title = "Cherry Jam",
            description = "Clear all Cherry blocks from Scenes 2 without dying, rack skip allowed",
            points = 5,
            trigger = triggerCherryPicker(2)
        )

        achievement(
            title = "Cherry Pie",
            description = "Clear all Cherry blocks from Scenes 3 without dying, rack skip allowed",
            points = 5,
            trigger = triggerCherryPicker(3)
        )

        achievement(
            title = "Cherry Cake",
            description = "Clear all Cherry blocks from Scenes 4 without dying, rack skip allowed",
            points = 5,
            trigger = triggerCherryPicker(4)
        )

        achievement(
            title = "Starvation Strategy",
            description = "Clear all Cherry blocks from Scenes 1 to 4 in a 3 lives or less game",
            points = 25,
            trigger = triggerStarvation()
        )
    // #endregion

    // #region Shield Challanges
        achievement(
            title = "Unbroken Aegis",
            description = "Collect the Shield in 4 consecutive scenes, starting with 3 lives or less",
            points = 10,
            trigger = triggerShieldStreak(size=4)
        )

        achievement(
            title = "Alphabet Soup",
            description = "Slay at least 4 Alphamonsters within one scene",
            points = 5,
            trigger = triggerAlphaStreak(size=4)
        )

        achievement(
            title = "Banner of Life",
            description = "Complete the EXTRA flags and earn an extra life, starting with 3 lives or less",
            points = 5,
            trigger = triggerExtraLife()
        )

        achievement(
            title = "Succession Strategy",
            description = "Earn two extra lives in a single game, starting with 3 lives or less",
            points = 10,
            trigger = triggerExtraLives(size=2)
        )
    // #endregion Shield Challanges

    // #region Monster Related Achievements
        achievement(
            title = "Hunting Strategy",
            description = "Slay 35 Unicorns without losing a life",
            points = 25,
            trigger = triggerOneLifeStreak(35)
        )

        achievement(
            title = "Long Way Down",
            description = "Send a Unicorn plummeting down 4 floors",
            points = 10,
            trigger = triggerUnicornDrop(4)
        )

        achievement(
            title = "Crowd Control",
            description = "Slay at least 4 Unicorns with a single block or trap",
            points = 5,
            trigger = triggerOneHitStreak(4)
        )
    // #endregion Monster Related Achievements

    // #region Score Achievements
        achievement(
            title = "Noble Reward",
            description = "Reach a score of 40,000 points in a 3 lives or less game",
            points = 10,
            trigger = triggerScoreXX0000(4)
        )

        achievement(
            title = "Sovereign Wealth",
            description = "Reach a score of 100,000 points in a 3 lives or less game",
            points = 25,
            trigger = triggerScoreXX0000(10)
        )
    // #endregion Score Achievements
// #endregion Achievements

// #region Leaderboards
    function startHighscoreLeaderboard() {
        return
            dipSwitchLives() <= 3
            && (
                once(framePlayer1LivesZeroed()) 
                ||
                once(framePlayer1ScoreOverflowed())
            )
            && never(gameplayActive() == FALSE)
    }

    function valueHighscoreLeaderboard() {
        reset =
            never(gameplayActive() == FALSE) &&
            measured( tally(0, always_false()) )

        overflow_none = measured( score() )
        overflow_1st  = measured( score() + 1000000, when = repeated(1, framePlayer1ScoreOverflowed()) )
        overflow_2nd  = measured( score() + 2000000, when = repeated(2, framePlayer1ScoreOverflowed()) )

        return max_of(reset, overflow_none, overflow_1st, overflow_2nd)
        return score()
    }

    leaderboard(
        title = "High Score",
        description = "Highest score starting with maximum 3 lives at any difficulty",
        format = "SCORE",
        start = startHighscoreLeaderboard(),
        cancel = always_false(),
        submit = framePlayer1LivesZeroed(),
        value = valueHighscoreLeaderboard()
    )
// #endregion Leaderboards

// #region Rich Presence
    rich_presence_conditional_display(
        postStatus() == POST_STATUS_FINISHED
        && gameplayActive() == TRUE,

        "Scene {0} • 🦄 {1}  • 🍒 {2} • 🤡 {3} • 🚩 {5}{6}{7}{8}{9} • 💯 {4}",
        
        rich_presence_macro("Number", scene()),
        rich_presence_macro("Number", enemyCount()),
        rich_presence_macro("Number", cherryRemaining()),
        rich_presence_macro("Number", lives()),
        rich_presence_macro("Score", score()),
        rich_presence_lookup("Letter_E", letterCollected_E(), {TRUE: "E", FALSE: "_"}), // 🅔 Ⓔ
        rich_presence_lookup("Letter_X", letterCollected_X(), {TRUE: "X", FALSE: "_"}), // 🅧 Ⓧ
        rich_presence_lookup("Letter_T", letterCollected_T(), {TRUE: "T", FALSE: "_"}), // 🅣 Ⓣ
        rich_presence_lookup("Letter_R", letterCollected_R(), {TRUE: "R", FALSE: "_"}), // 🅡 Ⓡ
        rich_presence_lookup("Letter_A", letterCollected_A(), {TRUE: "A", FALSE: "_"})  // 🅐 Ⓐ
    )

    rich_presence_conditional_display(
        postStatus() == POST_STATUS_FINISHED
        && gameplayActive() == FALSE,

        "Attract Mode • Difficulty: {0} • Start Lives: {1}",

        rich_presence_macro("Number", dipSwitchDifficulty()-1),
        rich_presence_macro("Number", dipSwitchLives())
    )

    rich_presence_display(
        "Starting Mr. Do's Castle"
    )
// #endregion Rich Presence