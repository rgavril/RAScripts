// Bomberman II
// #ID = 1586

TRUE = 0x01
FALSE = 0x00

function area() => byte(0x004b) + 1
function subArea() => byte(0x004c) + 1

function sfx() => byte(0x0205)
function music() => byte(0x0206)
function demoMode() => byte(0x03ef)

rich_presence_conditional_display(
    // In Game Menus
        music() & 0x7f == 0x13 // Game Menu Theme
    // In Title Screen
        || sfx() & 0x7f == 0x01 // Title Screen Boom
        || music() & 0x7f == 0x0d // Title Screen Theme
    // Intro Animation
        || area() == 0x07 // Into Animation Area
    // Demo Mode On
        || demoMode() == TRUE,
    "Preparing to Play Bomberman II"
)

rich_presence_display("Playing Bomberman II")