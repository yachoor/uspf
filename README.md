# Urich's Skill Point Finder (USPF)

ESO addon that tracks **where skill points can come from** on each character (quests, skyshards, dungeons, achievements, etc.) and compares progress against account-wide totals.

## Requirements

- **LibAddonMenu-2.0**
- **LibTableFunctions-1.0**

Install these in the same `AddOns` folder as USPF (for example from [ESOUI](https://www.esoui.com/) or the Minion addon manager).

## Installation

1. Copy the **`USPF`** folder into your ESO addons directory, for example:
   - **Windows:** `Documents\Elder Scrolls Online\live\AddOns`
   - **macOS:** `~/Documents/Elder Scrolls Online/live/AddOns`
2. Ensure the libraries above are installed and enabled.
3. In-game: **Settings → Add-Ons** → enable **Urich's Skill Point Finder** (and dependencies). Reload UI if prompted.

The folder must be named **`USPF`** and contain `USPF.txt` at the top level.

## Slash commands

| Command | Action |
|--------|--------|
| `/uspf` | Show or hide the **main** USPF window |
| `/uspf help` | Print slash-command help in chat |
| `/uspfmenu` | Open **LibAddonMenu** settings (fonts, colors, sort order, overrides) |
| `/uspdun` | Show or hide the **dungeon account** window (see below) |

You can also bind both windows under **Controls → Urich's Skill Point Finder** (main USPF and **Dungeon account window**).

## Main window — existing functionality

The primary UI is opened with **`/uspf`**. It includes:

- **Character selector** — Pick which character’s saved snapshot to view. Only characters that have logged in at least once with USPF enabled have complete data; tooltips explain this elsewhere in the UI.
- **General skill points** — Level, main quest, tutorial, Alliance War rank, Maelstrom Arena, Endless Archive quest, Folium Discognitum, etc., with progress vs maximum where applicable.
- **Storyline quests & skyshards** — Per-zone zone quest progress and skyshard counts (including totals).
- **Group dungeon quests** — One skill point per dungeon from the listed dungeon quest; shown in two columns, sortable via settings.
- **Public dungeon group boss events** — One skill point per public dungeon from the relevant achievement; sortable via settings.
- **Character total** — Sum of tracked sources vs theoretical maximum, plus unassigned skill points when known.

Data updates when you play on the **current** character (quests, achievements, skyshards, level, etc.); other characters show the last values saved when you last played them with the addon running.

**Settings** (`/uspfmenu`): fonts for each section, colors for complete/incomplete/progress states, table sort modes, and optional overrides (e.g. tutorial / Folium Discognitum).

## Dungeon account window — new functionality (`/uspdun`)

A separate window focused on **one dungeon at a time** across **all character slots** on the account:

1. Choose either a **public dungeon** or a **group dungeon** from the two dropdowns (the lists match USPF’s internal data). Public entries show **dungeon name (zone name)**. Use the sort button below the public list to order them **by dungeon name** or **by zone name** (saved account-wide). Selecting one dropdown clears the other.
2. Click **List characters** (enabled only after a dungeon is selected).
3. The list shows **every character** returned by the game’s character list (`GetNumCharacters` / `GetCharacterInfo`), in slot order.
4. For each name, **Skill point** shows:
   - **Yes** / **No** (green / red) when USPF has saved data for that character for that dungeon (same rules as the main tables: group = dungeon quest complete, public = achievement complete).
   - **No saved data** when that character has never logged in with USPF, so there is no snapshot in saved variables yet.

This does not replace the main window; it reuses the same saved data (`USPF_Settings` / per-character point tables).

## License / attribution

Not created by, affiliated with, or sponsored by ZeniMax Media Inc. See `USPF/USPF.txt` for the standard ESO add-on terms reference.
