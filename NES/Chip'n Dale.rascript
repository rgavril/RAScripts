// Chip 'n Dale: Rescue Rangers (NES)
// #ID = 1463

// #section Memory Addresses
    function stageId() => byte(0x0031)
        ZONE_0 = 0x00
        ZONE_A = 0x01
        ZONE_B = 0x02
        ZONE_C = 0x03
        ZONE_D = 0x04
        ZONE_E = 0x05
        ZONE_F = 0x06
        ZONE_G = 0x07
        ZONE_H = 0x08
        ZONE_I = 0x09
        ZONE_J = 0x0a
        ZONE_BONUS = 0x0d
    function stageSection() => byte(0x006e)
        ZONE_SECTION = {
            ZONE_0: [0x00, 0x01, 0x02, 0x18],
            ZONE_A: [0x00, 0x03],
            ZONE_B: [0x00, 0x04, 0x05, 0x06],
            ZONE_C: [0x00, 0x07, 0x19],
            ZONE_D: [0x00, 0x08, 0x09, 0x0a],
            ZONE_E: [0x00, 0x0b, 0x0c, 0x0d],
            ZONE_F: [0x00, 0x0e, 0x019],
            ZONE_G: [0x00, 0x0f, 0x10, 0x11],
            ZONE_H: [0x00, 0x17, 0x19],
            ZONE_I: [0x00, 0x12, 0x13, 0x14],
            ZONE_J: [0x00, 0x15, 0x16]
        }
    function stageClearTimer() => byte(0x006d)
    function soundQueueIndex() => byte(0x00db)
    function soundQueueSlot(index) => byte(0x00dc + index)
        ZONE_MUSIC = {
            ZONE_0: 0x00,
            ZONE_A: 0x05,
            ZONE_B: 0x01,
            ZONE_C: 0x05,
            ZONE_D: 0x02,
            ZONE_E: 0x05,
            ZONE_F: 0x06,
            ZONE_G: 0x03,
            ZONE_H: 0x06,
            ZONE_I: 0x06,
            ZONE_J: 0x04,
            ZONE_BONUS: 0x0c
        }

    function player1InvincibilityFrames() => byte(0x005e)
    function player2InvincibilityFrames() => byte(0x005f)
    function player1Lives() => low4(0x005b4) * 10 + low4(0x05b6)
    function player2Lives() => low4(0x005e4) * 10 + low4(0x05e6)
// #endsection Memory Addresses

// #section Frames
    function frameStageCompleted() {
        return
            prev(stageClearTimer()) == 0x00
            && stageClearTimer() != 0x00
    }
// #endsection Frames

// #section Triggers
    function triggerZoneClear(zone) {
        zoneSections = ZONE_SECTION[zone]
        lastZoneSection = array_pop(zoneSections)

        return
            stageId() == zone
            && stageSection() == lastZoneSection
            && frameStageCompleted()
    }

    function triggerZoneClearDamageless(zone) {
        zoneMusic = ZONE_MUSIC[zone]

        zoneSections = ZONE_SECTION[zone]
        zoneFirstSection = zoneSections[0]
        zoneLastSection = array_pop(zoneSections)

        primingCondition =
            stageSection() == zoneFirstSection
            && soundQueueSlot(soundQueueIndex()) == zoneMusic

        targetCondition =
            stageSection() == zoneLastSection
            && frameStageCompleted()

        cancelConditions = 
            never(stageId() != zone)
            && never(player1InvincibilityFrames() == 0x3b)
            && never(player2InvincibilityFrames() == 0x3b)

        return once(primingCondition) && cancelConditions && trigger_when(targetCondition)
    }

    function triggerZoneClearDeathless(zone) {
        zoneMusic = ZONE_MUSIC[zone]

        zoneSections = ZONE_SECTION[zone]
        zoneFirstSection = zoneSections[0]
        zoneLastSection = array_pop(zoneSections)

        primingCondition =
            stageSection() == zoneFirstSection
            && soundQueueSlot(soundQueueIndex()) == zoneMusic

        targetCondition =
            stageSection() == zoneLastSection
            && frameStageCompleted()

        cancelConditions = 
            never(stageId() != zone)
            && never(prev(player1Lives()) > player1Lives())
            && never(prev(player2Lives()) > player2Lives())

        return once(primingCondition) && cancelConditions && trigger_when(targetCondition)
    }
// #endsection Triggers

// #section Achievements
    // Progression Achievements
    achievement(id = 11394, title = "Rescue Rangers 0 (The Lab)", description = "Clear Zone 0", points = 3, trigger = triggerZoneClear(ZONE_0), type = "progression")
    achievement(id = 11395, title = "Rescue Rangers A (The Tree)", description = "Clear Zone A", points = 2, trigger = triggerZoneClear(ZONE_A))
    achievement(id = 11396, title = "Rescue Rangers B (The Diner)", description = "Clear Zone B", points = 3, trigger = triggerZoneClear(ZONE_B))
    achievement(id = 11397, title = "Rescue Rangers C (The Library)", description = "Clear Zone C", points = 4, trigger = triggerZoneClear(ZONE_C))
    achievement(id = 11398, title = "Rescue Rangers D (The Toy Store)", description = "Clear Zone D", points = 4, trigger = triggerZoneClear(ZONE_D))
    achievement(id = 11399, title = "Rescue Rangers E (The Park)", description = "Clear Zone E", points = 5, trigger = triggerZoneClear(ZONE_E), type = "progression")
    achievement(id = 11400, title = "Rescue Rangers F (The Factory)", description = "Clear Zone F", points = 5, trigger = triggerZoneClear(ZONE_F))
    achievement(id = 11401, title = "Rescue Rangers G (The Casino)", description = "Clear Zone G", points = 5, trigger = triggerZoneClear(ZONE_G), type = "progression")
    achievement(id = 11402, title = "Rescue Rangers H (The Sewers)", description = "Clear Zone H", points = 5, trigger = triggerZoneClear(ZONE_H), type = "progression")
    achievement(id = 11403, title = "Rescue Rangers I (The Bureau)", description = "Clear Zone I", points = 5, trigger = triggerZoneClear(ZONE_I), type = "progression")
    achievement(id = 11404, title = "Rescue Rangers J (The Post Office)", description = "Clear Zone J", points = 5, trigger = triggerZoneClear(ZONE_J), type = "progression")

    // Deathless Achievements
    achievement(id = 11405, title = "Monty's Challenge 0 (The Lab)", description = "Clear Zone 0 without dying", points = 5, trigger = triggerZoneClearDeathless(ZONE_0))
    achievement(id = 11406, title = "Monty's Challenge A (The Tree)", description = "Clear Zone A without dying", points = 10, trigger = triggerZoneClearDeathless(ZONE_A))
    achievement(id = 11407, title = "Monty's Challenge B (The Diner)", description = "Clear Zone B without dying", points = 10, trigger = triggerZoneClearDeathless(ZONE_B))
    achievement(id = 11408, title = "Monty's Challenge C (The Library)", description = "Clear Zone C without dying", points = 10, trigger = triggerZoneClearDeathless(ZONE_C))
    achievement(id = 11409, title = "Monty's Challenge D (The Toy Store)", description = "Clear Zone D without dying", points = 10, trigger = triggerZoneClearDeathless(ZONE_D))
    achievement(id = 11410, title = "Monty's Challenge E (The Park)", description = "Clear Zone E without dying", points = 10, trigger = triggerZoneClearDeathless(ZONE_E))
    achievement(id = 11411, title = "Monty's Challenge F (The Factory)", description = "Clear Zone F without dying", points = 4, trigger = triggerZoneClearDeathless(ZONE_F))
    achievement(id = 11412, title = "Monty's Challenge G (The Casino)", description = "Clear Zone G without dying", points = 10, trigger = triggerZoneClearDeathless(ZONE_G))
    achievement(id = 11413, title = "Monty's Challenge H (The Sewers)", description = "Clear Zone H without dying", points = 10, trigger = triggerZoneClearDeathless(ZONE_H))
    achievement(id = 11414, title = "Monty's Challenge I (The Bureau)", description = "Clear Zone I without dying", points = 10, trigger = triggerZoneClearDeathless(ZONE_I))
    achievement(id = 11415, title = "Monty's Challenge J (The Post Office)", description = "Clear Zone J without dying", points = 10, trigger = triggerZoneClearDeathless(ZONE_J))

    // Damageless Achievements
    achievement(id = 11416, title = "Zipper's Challenge 0 (The Lab)", description = "Clear Zone 0 without taking damage", points = 10, trigger = triggerZoneClearDamageless(ZONE_0))
    achievement(id = 11417, title = "Zipper's Challenge A (The Tree)", description = "Clear Zone A without taking damage", points = 10, trigger = triggerZoneClearDamageless(ZONE_A))
    achievement(id = 11418, title = "Zipper's Challenge B (The Diner)", description = "Clear Zone B without taking damage", points = 10, trigger = triggerZoneClearDamageless(ZONE_B))
    achievement(id = 11419, title = "Zipper's Challenge C (The Library)", description = "Clear Zone C without taking damage", points = 10, trigger = triggerZoneClearDamageless(ZONE_C))
    achievement(id = 11420, title = "Zipper's Challenge D (The Toy Store)", description = "Clear Zone D without taking damage", points = 10, trigger = triggerZoneClearDamageless(ZONE_D))
    achievement(id = 11421, title = "Zipper's Challenge E (The Park)", description = "Clear Zone E without taking damage", points = 10, trigger = triggerZoneClearDamageless(ZONE_E))
    achievement(id = 11422, title = "Zipper's Challenge F (The Factory)", description = "Clear Zone F without taking damage", points = 10, trigger = triggerZoneClearDamageless(ZONE_F))
    achievement(id = 11423, title = "Zipper's Challenge G (The Casino)", description = "Clear Zone G without taking damage", points = 10, trigger = triggerZoneClearDamageless(ZONE_G))
    achievement(id = 11424, title = "Zipper's Challenge H (The Sewers)", description = "Clear Zone H without taking damage", points = 10, trigger = triggerZoneClearDamageless(ZONE_H))
    achievement(id = 11425, title = "Zipper's Challenge I (The Bureau)", description = "Clear Zone I without taking damage", points = 10, trigger = triggerZoneClearDamageless(ZONE_I))
    achievement(id = 11426, title = "Zipper's Challenge J (The Post Office)", description = "Clear Zone J without taking damage", points = 10, trigger = triggerZoneClearDamageless(ZONE_J))

// #endsection Achievements