# Papaj 21:37 Plugin

AMX Mod X plugin that applies a yellow screen filter and plays music at exactly 21:37 every day or on manual trigger.

## Features

- **Automatic trigger at 21:37** - Every day at 21:37 (9:37 PM), the effect activates automatically
- **Manual console trigger** - Players can activate it anytime via console command
- **Yellow screen filter** - Semi-transparent yellow overlay for all players
- **Music playback** - Plays `papaj2137.mp3` during the effect
- **60-second duration** - Effect lasts exactly one minute
- **Round-restart persistent** - Filter persists through round changes

## Installation

### 1. Compile the plugin

```bash
amxxpc papaj.sma
```

This will create `papaj.amxx`

### 2. Install the plugin

Copy `papaj.amxx` to your server:
```
addons/amxmodx/plugins/papaj.amxx
```

Add it to `addons/amxmodx/configs/plugins.ini`:
```
papaj.amxx
```

### 3. Add the sound file

Place your MP3 file in the sound directory:
```
cstrike/sound/papaj2137.mp3
```

**Sound file requirements:**
- Format: MP3
- Channels: Mono (recommended)
- Sample Rate: 22050 Hz or 44100 Hz
- Bit Rate: 96-128 kbps recommended
- Duration: ~60 seconds (to match filter duration)

### 4. Restart server or change map

```
amx_map de_dust2
```

## Usage

### Automatic Trigger
The plugin automatically activates at **21:37** (9:37 PM) server time every day. No action required.

### Manual Trigger
Players can trigger the effect manually:

1. Open console (press `~` key)
2. Type: `papaj2137`
3. Press Enter

**Note:** The console command is hidden - other players won't see who activated it in chat.

## Configuration

Edit these constants in `papaj.sma` before compiling:

```c
#define FILTER_DURATION 60.0          // Duration in seconds (default: 60)
#define SOUND_FILE "papaj2137.mp3"    // Sound file name
#define TASK_MAINTAIN 2137            // Task ID for filter maintenance
#define TASK_REMOVE 21370             // Task ID for filter removal
```

### Changing the sound file
1. Edit `SOUND_FILE` constant
2. Recompile the plugin
3. Place the new MP3 file in `cstrike/sound/`

### Changing duration
1. Edit `FILTER_DURATION` constant (in seconds)
2. Recompile the plugin
3. Make sure your MP3 file length matches the duration

## Technical Details

- **Filter color:** Yellow (RGB: 255, 255, 0)
- **Filter opacity:** 100/255 (semi-transparent)
- **Maintenance interval:** 0.5 seconds (to survive round restarts)
- **Time check interval:** 30 seconds
- **Works with:** All Counter-Strike 1.6 servers running AMX Mod X

## Troubleshooting

### Sound doesn't play
- Verify the MP3 file exists at `cstrike/sound/papaj2137.mp3`
- Check file format (must be MP3)
- Ensure file is mono, not stereo
- Try converting with lower bitrate (96 kbps)

### Filter disappears on round restart
- This should not happen with the current version
- If it does, check that the `maintain_yellow_filter` task is running
- Check server logs for errors

### Effect doesn't trigger at 21:37
- Verify server time: type `amx_time` in server console
- Check server logs for: `"Papaj effect auto-triggered at 21:37"`
- Ensure plugin is loaded: type `amx_plugins` in console

### Players can't download the sound file
- The MP3 is precached using `precache_generic()`
- Clients should automatically download it when connecting
- If not, check FastDL settings or add to resources.ini

## Credits

- **Plugin:** Papaj 21:37
- **Version:** 1.0
- **Author:** bordeux
- **Platform:** AMX Mod X

## License

Free to use and modify.