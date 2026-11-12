// King's Field II
// #ID = 14377

// #section Memory Locations
    function attractModeState() => byte(0x10268)
        ATTRACT_MODE_ON = 0x00
        ATTRACT_MODE_OFF = 0x01

    function lifeFrameCounter() => dword(0x199488)

    function truthGlassFromMenuState() => dword(0x1ffe20)
    function truthGlassFromSelectState() => dword(0x1ffe28)
        TRUTH_GLASS_STATE_ON = 0x8017e088

    function truthGlassFromMenuObjectID() => dword(0x1ffe24)
    function truthGlassFromSelectObjectID() => dword(0x1ffe2c)
// #endsection Memory Locations

// #section Triggers
    function triggerTruthGlass(objectIDs) {
        return
            attractModeState() == ATTRACT_MODE_OFF
            && lifeFrameCounter() > 0x00
            && any_of(objectIDs, objectID => 
                ( prev(truthGlassFromMenuState()) != TRUTH_GLASS_STATE_ON && truthGlassFromMenuState() == TRUTH_GLASS_STATE_ON && truthGlassFromMenuObjectID() == objectID )
                ||
                ( prev(truthGlassFromSelectState()) != TRUTH_GLASS_STATE_ON && truthGlassFromSelectState() == TRUTH_GLASS_STATE_ON && truthGlassFromSelectObjectID() == objectID )
            )
    }
// #endsection Triggers

// #section Achievements
    achievement(
        id = 113053,
        title = "The Treasure Hunter",
        description = "Use the Truth Glass to gain further knowledge about Jose Harven",
        points = 1,
        trigger = triggerTruthGlass([0x00000133])
    )

    achievement(
        id = 113054,
        title = "The Novice Salesman",
        description = "Use the Truth Glass to gain further knowledge about Raffy Foss",
        points = 1,
        trigger = triggerTruthGlass([0x00000132])
    )

    achievement(
        id = 113055,
        title = "The Refugee Keymaker",
        description = "Use the Truth Glass to gain further knowledge about Mark Wozz",
        points = 1,
        trigger = triggerTruthGlass([0x0000014f])
    )

    achievement(
        id = 113056,
        title = "The Champion's Companion",
        description = "Use the Truth Glass to gain further knowledge about Fai Fadin",
        points = 1,
        trigger = triggerTruthGlass([0x00000145])
    )

    achievement(
        id = 113057,
        title = "The Unsettled Excavator",
        description = "Use the Truth Glass to gain further knowledge about Rand Ferrer",
        points = 1,
        trigger = triggerTruthGlass([0x00000147])
    )

    achievement(
        id = 113058,
        title = "The Exiled Gourmand",
        description = "Use the Truth Glass to gain further knowledge about Al Hunt",
        points = 1,
        trigger = triggerTruthGlass([0x00000143])
    )

    achievement(
        id = 113059,
        title = "The Champion's Sister",
        description = "Use the Truth Glass to gain further knowledge about Nola Bagil",
        points = 1,
        trigger = triggerTruthGlass([0x00000136])
    )

    achievement(
        id = 113060,
        type="missable",
        title = "The Forsaken Nobleman",
        description = "Use the Truth Glass to gain further knowledge about Earnest Clyde",
        points = 1,
        trigger = triggerTruthGlass([0x00000150, 0x0000015a])
    )

    achievement(
        id = 113061,
        title = "The Mournful Matriarch",
        description = "Use the Truth Glass to gain further knowledge about Krola Amgun",
        points = 1,
        trigger = triggerTruthGlass([0x0000014b, 0x0000014c])
    )

    achievement(
        id = 113062,
        title = "The Idle Entrepeneur",
        description = "Use the Truth Glass to gain further knowledge about Kehl Hunt",
        points = 1,
        trigger = triggerTruthGlass([0x00000151, 0x00000152])
    )

    achievement(
        id = 113063,
        title = "The Mysterious Clairvoyant",
        description = "Use the Truth Glass to gain further knowledge about Meryl",
        points = 1,
        trigger = triggerTruthGlass([0x00000139])
    )

    achievement(
        id = 113064,
        title = "The Young Adventurer",
        description = "Use the Truth Glass to gain further knowledge about Sandler Amgun",
        points = 1,
        trigger = triggerTruthGlass([0x0000014d, 0x0000014e])
    )

    achievement(
        id = 113065,
        title = "The Ancient Merchant",
        description = "Use the Truth Glass to gain further knowledge about Celffy Foss",
        points = 1,
        trigger = triggerTruthGlass([0x00000130, 0x00000131])
    )

    achievement(
        id = 113066,
        title = "The Crystal Crafter",
        description = "Use the Truth Glass to gain further knowledge about Radd Bilheim",
        points = 1,
        trigger = triggerTruthGlass([0x0000014a])
    )

    achievement(
        id = 113067,
        title = "The Ailing Daughter",
        description = "Use the Truth Glass to gain further knowledge about Gigi Budwell",
        points = 1,
        trigger = triggerTruthGlass([0x0000013a, 0x0000013c])
    )

    achievement(
        id = 113068,
        title = "The Solitary Elder",
        description = "Use the Truth Glass to gain further knowledge about Harris Carvitto",
        points = 1,
        trigger = triggerTruthGlass([0x00000144])
    )

    achievement(
        id = 113069,
        type="missable",
        title = "The Devoted Apparition",
        description = "Use the Truth Glass to gain further knowledge about Karen Shore while she is visible",
        points = 1,
        trigger = triggerTruthGlass([0x00000140])
    )

    achievement(
        id = 113070,
        title = "The Obstinate Traveler",
        description = "Use the Truth Glass to gain further knowledge about Cliff Lore",
        points = 1,
        trigger = triggerTruthGlass([0x00000146])
    )

    achievement(
        id = 113071,
        title = "The Careless Descendant",
        description = "Use the Truth Glass to gain further knowledge about Dalf Vice",
        points = 1,
        trigger = triggerTruthGlass([0x00000149])
    )

    achievement(
        id = 113072,
        title = "The Reputable Prospector",
        description = "Use the Truth Glass to gain further knowledge about David Tabler",
        points = 1,
        trigger = triggerTruthGlass([0x00000148])
    )

    achievement(
        id = 113073,
        title = "The Caring Father",
        description = "Use the Truth Glass to gain further knowledge about Teo Budwell",
        points = 1,
        trigger = triggerTruthGlass([0x0000013d, 0x0000013f])
    )

    achievement(
        id = 113074,
        title = "The Master Craftsman",
        description = "Use the Truth Glass to gain further knowledge about Leon Shore",
        points = 1,
        trigger = triggerTruthGlass([0x00000141, 0x00000142])
    )

    achievement(
        id = 113075,
        title = "The Dragon's Puppet",
        description = "Use the Truth Glass to gain further knowledge about Miria",
        points = 1,
        trigger = triggerTruthGlass([0x0000015d])
    )

    achievement(
        id = 113076,
        title = "The Omniscient Tree",
        description = "Use the Truth Glass to gain further knowledge about the Dragon Grass",
        points = 1,
        trigger = triggerTruthGlass([0x0000015b])
    )

    achievement(
        id = 113077,
        title = "The Dormant Soul",
        description = "Use the Truth Glass to gain further knowledge about the Grave of a Saint",
        points = 1,
        trigger = triggerTruthGlass([0x00000159])
    )

    achievement(
        id = 113078,
        title = "The Archmage's Construct",
        description = "Use the Truth Glass to gain further knowledge about the Skeleton of One-Eyed Giant",
        points = 1,
        trigger = triggerTruthGlass([0x0000011c])
    )

    achievement(
        id = 113079,
        type="missable",
        title = "The Guardian Portrait",
        description = "Use the Truth Glass to gain further knowledge about The Picture of a King",
        points = 1,
        trigger = triggerTruthGlass([0x0000011d])
    )

    achievement(
        id = 113080,
        type="missable",
        title = "The Greatest Warrior",
        description = "Use the Truth Glass to gain further knowledge about Dias Bagil",
        points = 1,
        trigger = triggerTruthGlass([0x00000113])
    )

    achievement(
        id = 113081,
        title = "Demon of the Deep",
        description = "Use the Truth Glass to gain further knowledge about the Kraken",
        points = 1,
        trigger = triggerTruthGlass([0x0000010d])
    )

    achievement(
        id = 113082,
        title = "A Slime Draws Near!",
        description = "Use the Truth Glass to gain further knowledge about the Green Slime",
        points = 1,
        trigger = triggerTruthGlass([0x000000f0])
    )

    achievement(
        id = 113083,
        title = "Red Means Dead",
        description = "Use the Truth Glass to gain further knowledge about the Poison Slime",
        points = 1,
        trigger = triggerTruthGlass([0x000000f1])
    )

    achievement(
        id = 113084,
        title = "Flying Fish",
        description = "Use the Truth Glass to gain further knowledge about the Sigill",
        points = 1,
        trigger = triggerTruthGlass([0x000000f2])
    )

    achievement(
        id = 113085,
        title = "Snail in Shining Armor",
        description = "Use the Truth Glass to gain further knowledge about the S-Knight",
        points = 1,
        trigger = triggerTruthGlass([0x00000100])
    )

    achievement(
        id = 113086,
        title = "Buzz Off!",
        description = "Use the Truth Glass to gain further knowledge about the Baltail",
        points = 1,
        trigger = triggerTruthGlass([0x000000f4, 0x000000f5])
    )

    achievement(
        id = 113087,
        title = "Why Is It Always Poison?",
        description = "Use the Truth Glass to gain further knowledge about the Poison Baltail",
        points = 1,
        trigger = triggerTruthGlass([0x000000f7])
    )

    achievement(
        id = 113088,
        title = "Little Shop of Horrors",
        description = "Use the Truth Glass to gain further knowledge about the Head Eater",
        points = 1,
        trigger = triggerTruthGlass([0x000000fe])
    )

    achievement(
        id = 113089,
        title = "Mean Spirited",
        description = "Use the Truth Glass to gain further knowledge about the Ghost",
        points = 1,
        trigger = triggerTruthGlass([0x000000fa])
    )

    achievement(
        id = 113090,
        title = "Pest Control",
        description = "Use the Truth Glass to gain further knowledge about the Termite",
        points = 1,
        trigger = triggerTruthGlass([0x00000106])
    )

    achievement(
        id = 113091,
        type="missable",
        title = "Killer Queen",
        description = "Use the Truth Glass to gain further knowledge about the Queen Termite",
        points = 1,
        trigger = triggerTruthGlass([0x00000109])
    )

    achievement(
        id = 113092,
        title = "Bad to the Bone",
        description = "Use the Truth Glass to gain further knowledge about the Skeleton",
        points = 1,
        trigger = triggerTruthGlass([0x00000105])
    )

    achievement(
        id = 113093,
        title = "Don't Lose Your Head",
        description = "Use the Truth Glass to gain further knowledge about the Psythe",
        points = 1,
        trigger = triggerTruthGlass([0x00000108])
    )

    achievement(
        id = 113094,
        title = "Bad Company",
        description = "Use the Truth Glass to gain further knowledge about Necron's Soldiers",
        points = 1,
        trigger = triggerTruthGlass([0x00000101])
    )

    achievement(
        id = 113095,
        title = "On the Mark",
        description = "Use the Truth Glass to gain further knowledge about Necron's Archers",
        points = 1,
        trigger = triggerTruthGlass([0x00000102])
    )

    achievement(
        id = 113096,
        title = "Melanat Monstrosity",
        description = "Use the Truth Glass to gain further knowledge about the Mogle",
        points = 1,
        trigger = triggerTruthGlass([0x000000ff])
    )

    achievement(
        id = 113097,
        title = "Aspen for Trouble",
        description = "Use the Truth Glass to gain further knowledge about the Log Stalker",
        points = 1,
        trigger = triggerTruthGlass([0x0000010b])
    )

    achievement(
        id = 113098,
        title = "Hot and Bothered",
        description = "Use the Truth Glass to gain further knowledge about the Fire-Elemental",
        points = 1,
        trigger = triggerTruthGlass([0x000000f9])
    )

    achievement(
        id = 113099,
        title = "Why the Long Face?",
        description = "Use the Truth Glass to gain further knowledge about the Earth-Elemental",
        points = 1,
        trigger = triggerTruthGlass([0x0000010f])
    )

    achievement(
        id = 113100,
        title = "Blue in the Face",
        description = "Use the Truth Glass to gain further knowledge about the Refma",
        points = 1,
        trigger = triggerTruthGlass([0x00000110])
    )

    achievement(
        id = 113101,
        type="missable",
        title = "Redheads Feel More Pain",
        description = "Use the Truth Glass to gain further knowledge about the Red Refma",
        points = 1,
        trigger = triggerTruthGlass([0x00000123])
    )

    achievement(
        id = 113102,
        title = "Breik New Ground",
        description = "Use the Truth Glass to gain further knowledge about the Reik",
        points = 1,
        trigger = triggerTruthGlass([0x000000fb])
    )

    achievement(
        id = 113103,
        title = "Flying Without Wings",
        description = "Use the Truth Glass to gain further knowledge about the Kald",
        points = 1,
        trigger = triggerTruthGlass([0x00000107])
    )

    achievement(
        id = 113104,
        title = "Let's Break the Ice",
        description = "Use the Truth Glass to gain further knowledge about the Tarn",
        points = 1,
        trigger = triggerTruthGlass([0x00000111])
    )

    achievement(
        id = 113105,
        title = "Out of Their Element",
        description = "Use the Truth Glass to gain further knowledge about the Copper Knight",
        points = 1,
        trigger = triggerTruthGlass([0x00000112])
    )

    achievement(
        id = 113106,
        title = "Stirring the Pot",
        description = "Use the Truth Glass to gain further knowledge about the Salamander",
        points = 1,
        trigger = triggerTruthGlass([0x00000118])
    )

    achievement(
        id = 113107,
        title = "Spitting Fire",
        description = "Use the Truth Glass to gain further knowledge about the Billent",
        points = 1,
        trigger = triggerTruthGlass([0x0000011a])
    )

    achievement(
        id = 113108,
        title = "Better the Devil You Know",
        description = "Use the Truth Glass to gain further knowledge about the Demon Lord",
        points = 1,
        trigger = triggerTruthGlass([0x0000010c])
    )

    achievement(
        id = 113109,
        title = "The Devil Wears Carbon",
        description = "Use the Truth Glass to gain further knowledge about the Mecha-Demon Lord",
        points = 1,
        trigger = triggerTruthGlass([0x0000011e])
    )

    achievement(
        id = 113110,
        title = "Come On, Give Me a Breik!",
        description = "Use the Truth Glass to gain further knowledge about the Mecha-Reik",
        points = 1,
        trigger = triggerTruthGlass([0x00000120])
    )

    achievement(
        id = 113111,
        title = "It's Not a Bug, It's a Feature",
        description = "Use the Truth Glass to gain further knowledge about the Mecha-Termite",
        points = 1,
        trigger = triggerTruthGlass([0x0000011f])
    )

    achievement(
        id = 113112,
        title = "They're a Bitt Much...",
        description = "Use the Truth Glass to gain further knowledge about the Bitt",
        points = 1,
        trigger = triggerTruthGlass([0x00000122])
    )

    achievement(
        id = 113113,
        title = "Moonlight Dragon",
        description = "Use the Truth Glass to gain further knowledge about Guyra",
        points = 1,
        trigger = triggerTruthGlass([0x00000117])
    )

// #endsection Achievements