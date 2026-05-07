// Need for Speed: High Stakes
// #ID = 11303

// $10EA70: Pointer for P1
//          Offsets:
//          +0x264 = laps completed [32bit]
//          +0x360 = laps completed [32bit]
//          +0x368 = lap 1 time [32bit] is updated when lap is completed, is cleared at race results
//          +0x36c = lap 2 time [32bit] is updated when lap is completed, is cleared at race results
//          +0x370 = lap 3 time [32bit] is updated when lap is completed, is cleared at race results
//          +0x374 = lap 4 time [32bit] is updated when lap is completed, is cleared at race results
//          +0x388 = position [32bit]
//          +0x3a0 = warnings [32bit]
//          +0x3a4 = tickets [32bit]
//          +0x3a8 = arrest [32bit]
//          +0x3d4 = Total race time [32bit] Set to 0 during the race, is updated shortly before Replay
//          +0x8bc = car [16bit]
function pointerForP1() => dword(0x10EA70)
function pointerForP1Tbyte() => tbyte(0x10EA70)
function lapsCompleted() => word((pointerForP1() & 0xFFFFFF) + 0x000360)
function lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() => dword((pointerForP1() & 0xFFFFFF) + 0x000368)
function lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() => dword((pointerForP1() & 0xFFFFFF) + 0x00036C)
function lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() => dword((pointerForP1() & 0xFFFFFF) + 0x000370)
function lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() => dword((pointerForP1() & 0xFFFFFF) + 0x000374)
function position() => word((pointerForP1() & 0xFFFFFF) + 0x000388)
function warnings() => dword((pointerForP1() & 0xFFFFFF) + 0x0003A0)
function tickets() => dword((pointerForP1() & 0xFFFFFF) + 0x0003A4)
function totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() => dword((pointerForP1() & 0xFFFFFF) + 0x0003D4)
function car() => word((pointerForP1() & 0xFFFFFF) + 0x0008BC)

// $10F0B0: Set to 1 in race
function setTo1InRace() => byte(0x10F0B0)
function setTo1InRaceWord() => word(0x10F0B0)

// $113A24: Total laps for current race
function totalLapsForCurrentRace() => byte(0x113A24)
function totalLapsForCurrentRaceWord() => word(0x113A24)

// $1144DC: Loading screen cheats:
//          bit1 = heavy car or slow CPU cars (depends on game mode)
//          bit6 = drunken mode
//          bit7 = dashboard view
function loadingScreenCheats() => byte(0x1144DC)

// $1144E0: Current track id:
//          00 - Snowy ridge,
//          02 - Dolphin cove,
//          03 - Route adonf,
//          04 - Kindiak park,
//          05 - Celtic ruins,
//          06 - Landstrasse,
//          07 - Durham road,
//          08 - Raceway 2,
//          09 - Raceway,
//          0a - Raceway 3
function currentTrackId() => byte(0x1144E0)
function currentTrackIdWord() => word(0x1144E0)

// $114878: P1 car:
//          0 = Mercedes SLK 230
//          1 = BMW Z3 Roadster 2.8
//          2 = Holden HSV VT GTS
//          3 = Ford Falcon XR8
//          4 = Chevrolet Camaro Z28
//          5 = Pontiac Firebird T/A
//          6 = Aston Martin DB7
//          7 = Jaguar XKR
//          8 = BMW M5
//          9 = Chevrolet Corvette
//          0xa = Ferrari 550 Maranello
//          0xb = Porsche 911
//          0xc = Ferrari F50
//          0xd = Lamborghini Diablo SV
//          0xe = Mercedes CLK-GTR
//          0xf = McLaren F1 GTR
//          0x10 = Race 911
//          0x11 = Holden MHRT
//          0x12 = Race Corvette
//          0x13 = Phantom
//          0x14 = Titan
//          0x15 = Nissan Skyline GT-R R34
//          0x16 = Police Caprice
//          0x17 = Police HSV GTS VT
//          0x18 = Police M5
//          0x19 = Police Corvette
//          0x1a = Police 911
//          0x1b = Police Diablo SV
//          0x1c = Police helicopter
function p1Car() => byte(0x114878)
function p1CarWord() => word(0x114878)

// $1158BB: Player mode:
//          00 - single,
//          01 - two
function playerMode() => byte(0x1158BB)

// $11F390: Global timer, stops when paused
function globalTimerStopsWhenPaused() => dword(0x11F390)

// $13D9B0: Laps completed in current race
function lapsCompletedInCurrentRace() => byte(0x13D9B0)

leaderboard(
    id = 6856, title = "Landstrasse fastest lap (Class AAA)",
    description = "Complete lap as fast as you can driving any Class AAA car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 6 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 14 || p1CarWord() == 15 || p1CarWord() == 19 || p1CarWord() == 20) &&
             totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 && globalTimerStopsWhenPaused() >= 512 &&
             prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 6857, title = "Route Adonf fastest lap (Class AAA)",
    description = "Complete lap as fast as you can driving any Class AAA car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 3 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 14 || p1CarWord() == 15 || p1CarWord() == 19 || p1CarWord() == 20) &&
             totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 && globalTimerStopsWhenPaused() >= 512 &&
             prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 6858, title = "Kindiak Park fastest lap (Class AAA)",
    description = "Complete lap as fast as you can driving any Class AAA car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 4 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 14 || p1CarWord() == 15 || p1CarWord() == 19 || p1CarWord() == 20) &&
             totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 && globalTimerStopsWhenPaused() >= 512 &&
             prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 6860, title = "Durham Road fastest lap (Class AAA)",
    description = "Complete lap as fast as you can driving any Class AAA car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 7 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 14 || p1CarWord() == 15 || p1CarWord() == 19 || p1CarWord() == 20) &&
             totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 && globalTimerStopsWhenPaused() >= 512 &&
             prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 6859, title = "Celtic Ruins fastest lap (Class AAA)",
    description = "Complete lap as fast as you can driving any Class AAA car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 5 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 14 || p1CarWord() == 15 || p1CarWord() == 19 || p1CarWord() == 20) &&
             totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 && globalTimerStopsWhenPaused() >= 512 &&
             prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 6861, title = "Dolphin Cove fastest lap (Class AAA)",
    description = "Complete lap as fast as you can driving any Class AAA car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 2 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 14 || p1CarWord() == 15 || p1CarWord() == 19 || p1CarWord() == 20) &&
             totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 && globalTimerStopsWhenPaused() >= 512 &&
             prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 6862, title = "Snowy Ridge fastest lap (Class AAA)",
    description = "Complete lap as fast as you can driving any Class AAA car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 0 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 14 || p1CarWord() == 15 || p1CarWord() == 19 || p1CarWord() == 20) &&
             totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 && globalTimerStopsWhenPaused() >= 512 &&
             prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 6863, title = "Raceway fastest lap (Class AAA)",
    description = "Complete lap as fast as you can driving any Class AAA car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 9 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 14 || p1CarWord() == 15 || p1CarWord() == 19 || p1CarWord() == 20) &&
             totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 && globalTimerStopsWhenPaused() >= 512 &&
             prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 6855, title = "Raceway 2 fastest lap (Class AAA)",
    description = "Complete lap as fast as you can driving any Class AAA car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 8 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 14 || p1CarWord() == 15 || p1CarWord() == 19 || p1CarWord() == 20) &&
             totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 && globalTimerStopsWhenPaused() >= 512 &&
             prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 6864, title = "Raceway 3 fastest lap (Class AAA)",
    description = "Complete lap as fast as you can driving any Class AAA car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 10 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 14 || p1CarWord() == 15 || p1CarWord() == 19 || p1CarWord() == 20) &&
             totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 && globalTimerStopsWhenPaused() >= 512 &&
             prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66398, title = "Landstrasse fastest lap (Class AA)",
    description = "Complete lap as fast as you can driving any Class AA car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 6 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 8 || p1CarWord() == 10 || p1CarWord() == 11 || p1CarWord() == 12 || p1CarWord() == 13 ||
                 p1CarWord() == 16 || p1CarWord() == 17 || p1CarWord() == 21
             ) && totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 &&
             globalTimerStopsWhenPaused() >= 512 && prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66399, title = "Route Adonf fastest lap (Class AA)",
    description = "Complete lap as fast as you can driving any Class AA car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 3 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 8 || p1CarWord() == 10 || p1CarWord() == 11 || p1CarWord() == 12 || p1CarWord() == 13 ||
                 p1CarWord() == 16 || p1CarWord() == 17 || p1CarWord() == 21
             ) && totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 &&
             globalTimerStopsWhenPaused() >= 512 && prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66400, title = "Kindiak Park fastest lap (Class AA)",
    description = "Complete lap as fast as you can driving any Class AA car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 4 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 8 || p1CarWord() == 10 || p1CarWord() == 11 || p1CarWord() == 12 || p1CarWord() == 13 ||
                 p1CarWord() == 16 || p1CarWord() == 17 || p1CarWord() == 21
             ) && totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 &&
             globalTimerStopsWhenPaused() >= 512 && prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66401, title = "Durham Road fastest lap (Class AA)",
    description = "Complete lap as fast as you can driving any Class AA car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 7 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 8 || p1CarWord() == 10 || p1CarWord() == 11 || p1CarWord() == 12 || p1CarWord() == 13 ||
                 p1CarWord() == 16 || p1CarWord() == 17 || p1CarWord() == 21
             ) && totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 &&
             globalTimerStopsWhenPaused() >= 512 && prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66402, title = "Celtic Ruins fastest lap (Class AA)",
    description = "Complete lap as fast as you can driving any Class AA car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 5 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 8 || p1CarWord() == 10 || p1CarWord() == 11 || p1CarWord() == 12 || p1CarWord() == 13 ||
                 p1CarWord() == 16 || p1CarWord() == 17 || p1CarWord() == 21
             ) && totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 &&
             globalTimerStopsWhenPaused() >= 512 && prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66403, title = "Dolphin Cove fastest lap (Class AA)",
    description = "Complete lap as fast as you can driving any Class AA car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 2 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 8 || p1CarWord() == 10 || p1CarWord() == 11 || p1CarWord() == 12 || p1CarWord() == 13 ||
                 p1CarWord() == 16 || p1CarWord() == 17 || p1CarWord() == 21
             ) && totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 &&
             globalTimerStopsWhenPaused() >= 512 && prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66404, title = "Snowy Ridge fastest lap (Class AA)",
    description = "Complete lap as fast as you can driving any Class AA car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 0 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 8 || p1CarWord() == 10 || p1CarWord() == 11 || p1CarWord() == 12 || p1CarWord() == 13 ||
                 p1CarWord() == 16 || p1CarWord() == 17 || p1CarWord() == 21
             ) && totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 &&
             globalTimerStopsWhenPaused() >= 512 && prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66405, title = "Raceway fastest lap (Class AA)",
    description = "Complete lap as fast as you can driving any Class AA car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 9 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 8 || p1CarWord() == 10 || p1CarWord() == 11 || p1CarWord() == 12 || p1CarWord() == 13 ||
                 p1CarWord() == 16 || p1CarWord() == 17 || p1CarWord() == 21
             ) && totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 &&
             globalTimerStopsWhenPaused() >= 512 && prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66406, title = "Raceway 2 fastest lap (Class AA)",
    description = "Complete lap as fast as you can driving any Class AA car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 8 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 8 || p1CarWord() == 10 || p1CarWord() == 11 || p1CarWord() == 12 || p1CarWord() == 13 ||
                 p1CarWord() == 16 || p1CarWord() == 17 || p1CarWord() == 21
             ) && totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 &&
             globalTimerStopsWhenPaused() >= 512 && prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66407, title = "Raceway 3 fastest lap (Class AA)",
    description = "Complete lap as fast as you can driving any Class AA car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 10 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 8 || p1CarWord() == 10 || p1CarWord() == 11 || p1CarWord() == 12 || p1CarWord() == 13 ||
                 p1CarWord() == 16 || p1CarWord() == 17 || p1CarWord() == 21
             ) && totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 &&
             globalTimerStopsWhenPaused() >= 512 && prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66408, title = "Landstrasse fastest lap (Class A)",
    description = "Complete lap as fast as you can driving any Class A car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 6 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 2 || p1CarWord() == 3 || p1CarWord() == 4 || p1CarWord() == 5 || p1CarWord() == 6 ||
                 p1CarWord() == 7 || p1CarWord() == 9 || p1CarWord() == 18
             ) && totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 &&
             globalTimerStopsWhenPaused() >= 512 && prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66409, title = "Route Adonf fastest lap (Class A)",
    description = "Complete lap as fast as you can driving any Class A car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 3 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 2 || p1CarWord() == 3 || p1CarWord() == 4 || p1CarWord() == 5 || p1CarWord() == 6 ||
                 p1CarWord() == 7 || p1CarWord() == 9 || p1CarWord() == 18
             ) && totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 &&
             globalTimerStopsWhenPaused() >= 512 && prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66410, title = "Kindiak Park fastest lap (Class A)",
    description = "Complete lap as fast as you can driving any Class A car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 4 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 2 || p1CarWord() == 3 || p1CarWord() == 4 || p1CarWord() == 5 || p1CarWord() == 6 ||
                 p1CarWord() == 7 || p1CarWord() == 9 || p1CarWord() == 18
             ) && totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 &&
             globalTimerStopsWhenPaused() >= 512 && prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66411, title = "Durham Road fastest lap (Class A)",
    description = "Complete lap as fast as you can driving any Class A car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 7 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 2 || p1CarWord() == 3 || p1CarWord() == 4 || p1CarWord() == 5 || p1CarWord() == 6 ||
                 p1CarWord() == 7 || p1CarWord() == 9 || p1CarWord() == 18
             ) && totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 &&
             globalTimerStopsWhenPaused() >= 512 && prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66412, title = "Celtic Ruins fastest lap (Class A)",
    description = "Complete lap as fast as you can driving any Class A car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 5 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 2 || p1CarWord() == 3 || p1CarWord() == 4 || p1CarWord() == 5 || p1CarWord() == 6 ||
                 p1CarWord() == 7 || p1CarWord() == 9 || p1CarWord() == 18
             ) && totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 &&
             globalTimerStopsWhenPaused() >= 512 && prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66413, title = "Dolphin Cove fastest lap (Class A)",
    description = "Complete lap as fast as you can driving any Class A car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 2 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 2 || p1CarWord() == 3 || p1CarWord() == 4 || p1CarWord() == 5 || p1CarWord() == 6 ||
                 p1CarWord() == 7 || p1CarWord() == 9 || p1CarWord() == 18
             ) && totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 &&
             globalTimerStopsWhenPaused() >= 512 && prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66414, title = "Snowy Ridge fastest lap (Class A)",
    description = "Complete lap as fast as you can driving any Class A car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 0 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 2 || p1CarWord() == 3 || p1CarWord() == 4 || p1CarWord() == 5 || p1CarWord() == 6 ||
                 p1CarWord() == 7 || p1CarWord() == 9 || p1CarWord() == 18
             ) && totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 &&
             globalTimerStopsWhenPaused() >= 512 && prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66415, title = "Raceway fastest lap (Class A)",
    description = "Complete lap as fast as you can driving any Class A car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 9 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 2 || p1CarWord() == 3 || p1CarWord() == 4 || p1CarWord() == 5 || p1CarWord() == 6 ||
                 p1CarWord() == 7 || p1CarWord() == 9 || p1CarWord() == 18
             ) && totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 &&
             globalTimerStopsWhenPaused() >= 512 && prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66416, title = "Raceway 2 fastest lap (Class A)",
    description = "Complete lap as fast as you can driving any Class A car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 8 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 2 || p1CarWord() == 3 || p1CarWord() == 4 || p1CarWord() == 5 || p1CarWord() == 6 ||
                 p1CarWord() == 7 || p1CarWord() == 9 || p1CarWord() == 18
             ) && totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 &&
             globalTimerStopsWhenPaused() >= 512 && prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66417, title = "Raceway 3 fastest lap (Class A)",
    description = "Complete lap as fast as you can driving any Class A car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 10 &&
             totalLapsForCurrentRace() != 1 &&
             (p1CarWord() == 2 || p1CarWord() == 3 || p1CarWord() == 4 || p1CarWord() == 5 || p1CarWord() == 6 ||
                 p1CarWord() == 7 || p1CarWord() == 9 || p1CarWord() == 18
             ) && totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 &&
             globalTimerStopsWhenPaused() >= 512 && prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66418, title = "Landstrasse fastest lap (Class B)",
    description = "Complete lap as fast as you can driving any Class B car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 6 &&
             totalLapsForCurrentRace() != 1 && (p1CarWord() == 0 || p1CarWord() == 1) &&
             totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 && globalTimerStopsWhenPaused() >= 512 &&
             prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66419, title = "Route Adonf fastest lap (Class B)",
    description = "Complete lap as fast as you can driving any Class B car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 3 &&
             totalLapsForCurrentRace() != 1 && (p1CarWord() == 0 || p1CarWord() == 1) &&
             totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 && globalTimerStopsWhenPaused() >= 512 &&
             prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66420, title = "Kindiak Park fastest lap (Class B)",
    description = "Complete lap as fast as you can driving any Class B car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 4 &&
             totalLapsForCurrentRace() != 1 && (p1CarWord() == 0 || p1CarWord() == 1) &&
             totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 && globalTimerStopsWhenPaused() >= 512 &&
             prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66421, title = "Durham Road fastest lap (Class B)",
    description = "Complete lap as fast as you can driving any Class B car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 7 &&
             totalLapsForCurrentRace() != 1 && (p1CarWord() == 0 || p1CarWord() == 1) &&
             totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 && globalTimerStopsWhenPaused() >= 512 &&
             prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66422, title = "Celtic Ruins fastest lap (Class B)",
    description = "Complete lap as fast as you can driving any Class B car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 5 &&
             totalLapsForCurrentRace() != 1 && (p1CarWord() == 0 || p1CarWord() == 1) &&
             totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 && globalTimerStopsWhenPaused() >= 512 &&
             prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66423, title = "Dolphin Cove fastest lap (Class B)",
    description = "Complete lap as fast as you can driving any Class B car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 2 &&
             totalLapsForCurrentRace() != 1 && (p1CarWord() == 0 || p1CarWord() == 1) &&
             totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 && globalTimerStopsWhenPaused() >= 512 &&
             prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66424, title = "Snowy Ridge fastest lap (Class B)",
    description = "Complete lap as fast as you can driving any Class B car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 0 &&
             totalLapsForCurrentRace() != 1 && (p1CarWord() == 0 || p1CarWord() == 1) &&
             totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 && globalTimerStopsWhenPaused() >= 512 &&
             prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66425, title = "Raceway fastest lap (Class B)",
    description = "Complete lap as fast as you can driving any Class B car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 9 &&
             totalLapsForCurrentRace() != 1 && (p1CarWord() == 0 || p1CarWord() == 1) &&
             totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 && globalTimerStopsWhenPaused() >= 512 &&
             prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66426, title = "Raceway 2 fastest lap (Class B)",
    description = "Complete lap as fast as you can driving any Class B car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 8 &&
             totalLapsForCurrentRace() != 1 && (p1CarWord() == 0 || p1CarWord() == 1) &&
             totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 && globalTimerStopsWhenPaused() >= 512 &&
             prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 66427, title = "Raceway 3 fastest lap (Class B)",
    description = "Complete lap as fast as you can driving any Class B car, finish the race to submit",
    start  = setTo1InRace() == 1 && loadingScreenCheats() == 0 && currentTrackId() == 10 &&
             totalLapsForCurrentRace() != 1 && (p1CarWord() == 0 || p1CarWord() == 1) &&
             totalRaceTimesetTo0DuringTheRaceIsUpdatedShortlyBeforeReplay() == 0 && globalTimerStopsWhenPaused() >= 512 &&
             prev(globalTimerStopsWhenPaused()) < 512 && playerMode() == 0,
    cancel = (setTo1InRace() == 0 || globalTimerStopsWhenPaused() == 0),
    submit = totalLapsForCurrentRace() == lapsCompletedInCurrentRace(),
    value  = max_of(
                 measured(tally(0, always_false())),
                 measured(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless((lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless((lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0) &&
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ),
                 measured(lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() * 1.5625 + 0.0000001,
                     when=lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() != 0
                 ) &&
                 unless(lap1TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap2TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 ) &&
                 unless(lap3TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults() <
                     lap4TimeisUpdatedWhenLapIsCompletedIsClearedAtRaceResults()
                 )
             ),
    format = "MILLISECS", lower_is_better = true
)
