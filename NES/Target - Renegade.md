# Entities
There is space for maximum four entities on screen at the same time. Most of the time this are enemies but they can also be weapons, enemy projectiles or enemy props.

Details about entities, are usually found in consecutive memory locations.
- Types: 0x03da, 0x03d9, 0x03d8, 0x03d7
- Vertical Position: 0x03e9, 0x03e8, 0x03e7, 0x03e6
- Horizontal Positions: 0x03e4, 0x03e3, 0x03e2, 0x03e1
- Hitbox Vertical Position: 0x0416, 0x0415, 0x0414, 0x413
- Enemy Energy: 0x0407, 0x0406, 0x0405, 0x0404

# Game Events
There is no memory location that have a stable value during specific game events. There are some locations that vary their value in a predictable way, in a squence of value changes, when certain events happen.

I've recorded some transitions and made some asumptions. Considering the fact that the samples I've extracted are limited and the game in certain scenarious might spit different values that I haven't considered, this assumptions might not be 100% stable!


## Memory Location 0x008f
Recordings:
`
	(na),0e,1e,20...20             = First Boot -> Attract Mode
	(20),5a,00,12,14,16,24,06...06 = Attract Mode -> Gameplay Demo
	(24),5a,00,12,14,16,24,06...06 = Attract Mode -> Gameplay Demo
	(06),18,24...24                = Gameplay Demo -> Attract Mode
	(24),1a...1a                   = Attract Mode -> Level Brief
	(1a),00,12,16,24,06...06       = Level Brief -> Gameplay
	(64),18,24,1a...1a             = Level Complete (Door Open) -> Level 2 Brief
	(06),18,24,78                  = Gameplay -> Game Over
	(78),10...10                   = Input Name Screen
	(10),0e,1e,20...20             = Input Name -> 20 Attract Mode
	(06),6c,06...06				   = Gameplay -> Level 7 Complete (Energy Restore)
	(06),52,06...06                = Gameplay -> Level 6 Complete (Energy Restore)
	(06),02,06...06                = Gameplay -> Level 4 Complete (Energy Restore)
	(06),28,06...06                = Gameplay -> Level 3 Complete (Energy Restore)
	(06),02,06...06                = Gameplay -> Level 1,2 Copmlete (Energy Restore)
	(06),64                        = Level Complete (Energy) -> Level Complete (Door Open)
`
Assumptions:
`
	0x06 = Gameplay with User/Demo Input
	0x10 = Name Input Screen Showing
	0x1a = Level Briefing Showing
	0x78 = Game Over Happened (?)
`

## Memory Location 0x01fc
Recording:
`
	(f1),b2,bb,cb     = Game Start to Briefing
	(cb),e2,f9,02,17  = Briefing to Start Game
	(17),17...17      = During Game
	(17),5d,60,6a,f1  = Game Over
	(17),35           = Level Complete
	(35),e2,f9,0d,17  = Start Next Level
`
Asumptions:
`
	When value changed from:
	0x17 to 0x35 = Level Completed
	0x17 to 0x5d = Game Over
`