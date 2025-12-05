#include <amxmodx>
#include <amxmisc>

#define PLUGIN "Papaj 21:37"
#define VERSION "1.0"
#define AUTHOR "bordeux"

#define FILTER_DURATION 60.0 // Duration in seconds
#define SOUND_FILE "papaj2137.mp3" // Sound file path
#define TASK_MAINTAIN 2137 // Task ID for maintaining filter
#define TASK_REMOVE 21370 // Task ID for removing filter

new bool:g_bFilterActive = false // Track if filter is currently active
new bool:g_bTriggeredToday = false // Track if auto-trigger already happened today

public plugin_precache() {
    // Precache MP3 file so clients download it from the server
    new sound_path[64]
    format(sound_path, 63, "sound/%s", SOUND_FILE)
    precache_generic(sound_path)
}

public plugin_init() {
    register_plugin(PLUGIN, VERSION, AUTHOR)
    register_concmd("papaj2137", "cmd_papaj")

    // Check time every 30 seconds for auto-trigger at 21:37
    set_task(30.0, "check_time", 2138, "", 0, "b")
}

public cmd_papaj(id) {
    // Trigger the papaj effect
    trigger_papaj_effect()

    return PLUGIN_HANDLED
}

public apply_yellow_filter() {
    new players[32], num
    get_players(players, num, "a") // Get all alive and connected players

    for(new i = 0; i < num; i++) {
        new player = players[i]

        // Screen fade parameters
        // ScreenFade(duration, holdtime, flags, r, g, b, alpha)
        // Duration and holdtime are in special units (1/4096 of a second)
        // 60 seconds = 60 * 4096 = 245760 units

        message_begin(MSG_ONE, get_user_msgid("ScreenFade"), {0,0,0}, player)
        write_short(1<<12) // Duration: 1 second fade in
        write_short(floatround(FILTER_DURATION * 4096.0)) // Hold time: 60 seconds
        write_short(0x0004) // FFADE_STAYOUT flag
        write_byte(255) // Red
        write_byte(255) // Green
        write_byte(0)   // Blue (Yellow = Red + Green)
        write_byte(100) // Alpha (transparency, 0-255, 100 = semi-transparent)
        message_end()
    }
}

public maintain_yellow_filter() {
    // Continuously reapply the filter to ensure it stays on during round changes
    if(g_bFilterActive) {
        apply_yellow_filter()
    }
}

public check_time() {
    // Get current time
    new hour, minute, second
    time(hour, minute, second)

    // Check if it's 21:37
    if(hour == 21 && minute == 37) {
        // Only trigger once per day
        if(!g_bTriggeredToday) {
            g_bTriggeredToday = true

            // Trigger the papaj effect automatically
            trigger_papaj_effect()

            // Log the automatic trigger
            log_amx("Papaj effect auto-triggered at 21:37")
        }
    } else {
        // Reset the flag after 21:37 passes
        if(hour != 21 || minute != 37) {
            g_bTriggeredToday = false
        }
    }
}

public trigger_papaj_effect() {
    // Mark filter as active
    g_bFilterActive = true

    // Apply yellow filter to all players
    apply_yellow_filter()

    // Play MP3 sound to all players
    new players[32], num
    get_players(players, num, "a")
    for(new i = 0; i < num; i++) {
        client_cmd(players[i], "mp3 play sound/%s", SOUND_FILE)
    }

    // Set repeating task to maintain filter every 0.5 seconds (to survive round restarts)
    set_task(0.5, "maintain_yellow_filter", TASK_MAINTAIN, "", 0, "b")

    // Set timer to remove filter after 60 seconds
    set_task(FILTER_DURATION, "remove_yellow_filter", TASK_REMOVE)

    // Notify all players
    client_print(0, print_chat, "[Papaj] Papieski czas, kremowki w dlon!")
}

public remove_yellow_filter() {
    // Mark filter as inactive
    g_bFilterActive = false

    // Stop the repeating maintain task
    remove_task(TASK_MAINTAIN)

    new players[32], num
    get_players(players, num, "a") // Get all alive and connected players

    for(new i = 0; i < num; i++) {
        new player = players[i]

        // Clear the screen fade with FFADE_OUT flag
        message_begin(MSG_ONE, get_user_msgid("ScreenFade"), {0,0,0}, player)
        write_short(1<<12) // Duration: 1 second fade out
        write_short(0) // Hold time: 0
        write_short(0x0001) // FFADE_OUT flag - fade out and remove
        write_byte(0) // Red
        write_byte(0) // Green
        write_byte(0) // Blue
        write_byte(0) // Alpha
        message_end()

        // Stop the MP3 playback
        client_cmd(player, "mp3 stop")
    }

    // Notify all players that the filter has been removed
    client_print(0, print_chat, "[Papaj] Koniec papieskiego czasu!")
}