// Vice: Project Doom
// #ID = 2060

// #region Memory Addresses
    function currSceneMode() => byte(0x0090)
    function nextSceneMode() => byte(0x0095)
    function currSceneIndex() => byte(0x0092)
    function nextSceneIndex() => byte(0x0097)
// #endregion Memory Addresses

// #region Rich Presence
    stageNameLookup = {
        0x00 : "Stage 4-1",
        0x02 : "Stage 2-1",
        0x03 : "Stage 2-1",
        0x04 : "Stage 2-1",
        0x05 : "Stage 2-1",
        0x06 : "Stage 2-2",
        0x07 : "Stage 1-1",
        0x08 : "Stage 3-1",
        0x09 : "Stage 3-1",
        0x0a : "Stage 3-1",
        0x0b : "Stage 3-2",
        0x0c : "Stage 5-1",
        0x0d : "Stage 5-1",
        0x0e : "Stage 5-2",
        0x0f : "Stage 5-2",
        0x10 : "Stage 7-1",
        0x11 : "End Credits",
        0x12 : "Stage 6-1",
        0x13 : "Stage 6-1",
        0x14 : "Stage 6-1",
        0x15 : "Stage 6-2",
        0x16 : "Stage 6-3",
        0x17 : "Stage 5-3",
        0x18 : "Stage 7-2",
        0x19 : "Stage 7-2",
        0x1a : "Stage 7-2",
        0x1b : "Stage 7-2",
        0x1c : "Stage 8-1",
        0x1d : "Stage 8-1",
        0x1e : "Stage 8-1",
        0x1f : "Stage 8-2",
        0x20 : "Stage 8-3",
        0x21 : "Stage 9-1",
        0x22 : "Stage 9-1",
        0x23 : "Stage 9-1",
        0x24 : "Stage 9-2",
        0x25 : "Stage 9-3",
        0x26 : "Stage 4-2",
        0x27 : "Stage 10-1",
        0x28 : "Stage 11-1",
        0x29 : "Stage 11-2",
        0x2a : "Stage 11-2",
        0x2b : "Stage 11-2",
        0x2c : "Stage 11-3",
        0x2d : "Stage 11-4",
        0x2e : "Stage 7-3",
        0x2f : "Stage 6-2",
        0x30 : "Stage 8-2"
    }

    rich_presence_conditional_display(
        currSceneMode() < 0x0b,
        "{0}",
        rich_presence_lookup("Stage", currSceneIndex(), stageNameLookup)
    )

    rich_presence_conditional_display(
        nextSceneMode() < 0x0b,
        "{0}",
        rich_presence_lookup("Stage", nextSectionID(), stageNameLookup)
    )

    rich_presence_display("In Attract Mode")
    
// #endregion Rich Presence