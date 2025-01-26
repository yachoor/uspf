# Changelog

## [7.3.6] - 2025-01-26

### Added

- Skipped tutorial skill point detection

### Fixed

- Folium Discognitum detection
- Wailing Prison skyshard detection when skipping quest


## [7.3.5] - 2024-10-28

### Fixed

- Wrong zoneId of Leftwheal public dungeon in West Weald (thx @MuMuQ)


## [7.3.4] - 2024-06-11

### Changed

- Merge all tutorial overrides together


## [7.3.3] - 2024-06-10

### Added

- Skill point from quest The Wing of the Crow in West Weald

### Fixed

- Multiple tutorials counted if user selected overrides


## [7.3.2] - 2024-06-05

### Fixed

- Incorrect quest checked for Crypt of Hearts I


## [7.3.1] - 2024-06-04

### Fixed

- Zone name formatting in languages other than english


## [7.3.0] - 2024-06-03

### Added

- Support for Gold Road chapter - new skillpoints:
* 8 from main quest
* 2 from public dungeons
* 6 from skyshards

### Changed

- Reorganized internal data structures to ease adding new zones, dungeons, etc


## [7.2.0] - 2024-04-20

### Changed

- Split group dungeons into 2-columns to reduce vertical height


## [7.1.0] - 2024-03-11

### Added

- Support for Scions of Ithelia DLC - 2 new dungeons


## [7.0.2] - 2023-12-11

### Fixed

- Lua error when deleting characters other than last
- GUI warning about bad use of resizeToFitDescendents (thx Baertram)


## [7.0.1] - 2023-11-15

### Added

- Endless Archive character completion tooltip


## [7.0.0] - 2023-11-02

### Changed

- Addon will no longer register characters until logging in with them (so you can disable it on some characters to not track them)


## [6.10.1] - 2023-11-01

### Fixed

- Display of Endless Archive name in languages other than english


## [6.10.0] - 2023-10-31

### Added

- Endless Archive quest skill point


## [6.9.0] - 2023-06-05

### Added

- Support for Necrom chapter - new skillpoints:
* 9 from main quest
* 2 from public dungeons
* 6 from skyshards


## [6.8.0] - 2023-03-13

### Added

- Support for Scribes of Fate DLC - 2 new dungeons


## [6.7.1] - 2022-12-03

### Added

- Chinese translation (justjavac)


## [6.7.0] - 2022-11-02

### Added

- Support for Firesong DLC (by MuMuQ) - skill points:
* 6 from main quest
* 3 from chapter epilogue
* 2 from skyshards

### Fixed

- incorrect skill point quests for Deshaan (thx for reporting AntonShan)


## [6.6.0] - 2022-08-19

### Added

- Support for Lost Depths DLC - 2 new dungeons


## [6.5.1] - 2022-06-16

### Added

- Two more quest skill points from public dungeon quests (thanks nerfarious)


## [6.5.0] - 2022-06-05

### Added

- Support for High Isle chapter - skill points:
* 3 from main quest line
* 6 from skyshard
* 2 from public dungeons

## [6.4.1] - 2022-04-09

### Added

- Switch to cursor mode when showing addon window

### Fixed

- Swapped Stros M'Kai with Betnikh and Bleakrock Isle with Bal Foyen skyshards


## [6.4.0] - 2022-02-14

### Added

- Support for Ascending Tide DLC - 2 new dungeons

### Fixed

- Skillpoints from quests and skyshards are not checked against achievements, which are global now
- Tootltips out of order with non-default sorting options


## [6.3.0] - 2021-10-31

### Added

- Support for The Deadlands DLC - new questlines and skyshards

### Fixed

- Russian translation improvements (K1nor)
- Character names are no longer capitalised


## [6.2.1] - 2021-09-16

### Added

- Russian translation by K1nor


## [6.2.0] - 2021-08-23

### Added

- Support for Waking Flame DLC - Red Petal Bastion and The Dread Cellar dungeons (@MuMuQ)


## [6.1.0] - 2021-06-30

### Added

- Fancy-pants tooltips that display condensed info for all the characters (remosito)
- Unspent skill point info (remosito)

### Fixed

- Don't mark Black Drake Villa as done when actual completion for the character is not yet known


## [6.0.3] - 2021-06-20

### Added

- Automatic building of release package to avoid problems with creating bad one in a hurry

### Fixed

- Minion confusing this addon for original - adding changelog to package should make enough difference


## [6.0.2] - 2021-06-08

### Fixed

- Lua error due to function being called before definition


## [6.0.1] - 2021-06-08

### Removed

- Some unnecessary/duplicated code

### Fixed

- Main quest skill point not being counted
- Quest tooltips not being updated when choosing different character
- Possibly an issue with folium discognitum detection on emperor characters


## [6.0.0] - 2021-06-06

### Changed

- Replaced quest name translations with new API to get quest name in game language


## [5.7.1] - 2021-05-31

### Fixed

- New dungeons overriding previous two


## [5.7.0] - 2021-05-22

#### Added

- Support for Blackwood chapter (@MuMuQ)

### Fixed

- Greymoor character override


## [5.6.1] - 2021-05-20

#### Fixed

- One of The Reach quests skill points
- Spent skill point counting (TemporalPersonage)


## [5.6.0] - 2021-03-10

#### Added

- Support for Flames of Ambition - Black Drake Villa and The Cauldron dungeons


## [5.5.0] - 2021-01-23

#### Added

- Support for Markarth - The Reach questline and skyshards

[7.3.6]: https://github.com/yachoor/uspf/compare/7.3.5...7.3.6
[7.3.5]: https://github.com/yachoor/uspf/compare/7.3.4...7.3.5
[7.3.4]: https://github.com/yachoor/uspf/compare/7.3.3...7.3.4
[7.3.3]: https://github.com/yachoor/uspf/compare/7.3.2...7.3.3
[7.3.2]: https://github.com/yachoor/uspf/compare/7.3.1...7.3.2
[7.3.1]: https://github.com/yachoor/uspf/compare/7.3.0...7.3.1
[7.3.0]: https://github.com/yachoor/uspf/compare/7.2.0...7.3.0
[7.2.0]: https://github.com/yachoor/uspf/compare/7.1.0...7.2.0
[7.1.0]: https://github.com/yachoor/uspf/compare/7.0.2...7.1.0
[7.0.2]: https://github.com/yachoor/uspf/compare/7.0.1...7.0.2
[7.0.1]: https://github.com/yachoor/uspf/compare/7.0.0...7.0.1
[7.0.0]: https://github.com/yachoor/uspf/compare/6.10.1...7.0.0
[6.10.1]: https://github.com/yachoor/uspf/compare/6.10.0...6.10.1
[6.10.0]: https://github.com/yachoor/uspf/compare/6.9.0...6.10.0
[6.9.0]: https://github.com/yachoor/uspf/compare/6.8.0...6.9.0
[6.8.0]: https://github.com/yachoor/uspf/compare/6.7.1...6.8.0
[6.7.1]: https://github.com/yachoor/uspf/compare/6.7.0...6.7.1
[6.7.0]: https://github.com/yachoor/uspf/compare/6.6.0...6.7.0
[6.6.0]: https://github.com/yachoor/uspf/compare/6.5.1...6.6.0
[6.5.1]: https://github.com/yachoor/uspf/compare/6.5.0...6.5.1
[6.5.0]: https://github.com/yachoor/uspf/compare/6.4.1...6.5.0
[6.4.1]: https://github.com/yachoor/uspf/compare/6.4.0...6.4.1
[6.4.0]: https://github.com/yachoor/uspf/compare/6.3.0...6.4.0
[6.3.0]: https://github.com/yachoor/uspf/compare/6.2.1...6.3.0
[6.2.1]: https://github.com/yachoor/uspf/compare/6.2.0...6.2.1
[6.2.0]: https://github.com/yachoor/uspf/compare/6.1.0...6.2.0
[6.1.0]: https://github.com/yachoor/uspf/compare/6.0.3...6.1.0
[6.0.3]: https://github.com/yachoor/uspf/compare/6.0.2...6.0.3
[6.0.2]: https://github.com/yachoor/uspf/compare/6.0.1...6.0.2
[6.0.1]: https://github.com/yachoor/uspf/compare/6.0.0...6.0.1
[6.0.0]: https://github.com/yachoor/uspf/compare/5.7.1...6.0.0
[5.7.1]: https://github.com/yachoor/uspf/compare/5.7.0...5.7.1
[5.7.0]: https://github.com/yachoor/uspf/compare/5.6.1...5.7.0
[5.6.1]: https://github.com/yachoor/uspf/compare/5.6.0...5.6.1
[5.6.0]: https://github.com/yachoor/uspf/compare/5.5.0...5.6.0
[5.5.0]: https://github.com/yachoor/uspf/releases/tag/5.5.0
