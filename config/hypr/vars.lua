-- Shared constants, required by the other modules in this directory.
-- https://wiki.hypr.land/Configuring/Start/#using-multiple-configuration-files

local HOME = os.getenv("HOME") or "/home/ali"

return {
    mainMod = "SUPER",

    apps = {
        terminal = "kitty",

        -- The scratchpad terminal runs with its own class. The window rule that
        -- moves it into special:terminal matches that class only, so a regular
        -- kitty (SUPER + T) is not swallowed by the scratchpad.
        terminalScratch = "kitty --class kitty-scratch",

        browser = HOME .. "/.local/bin/zen-fast",
        music = "spotify",
        fileBrowser = "dolphin",
        menu = "rofi",
    },

    scripts = {
        waybarStyles = HOME .. "/.config/hypr/scripts/WaybarStyles.sh",
        keyHints = HOME .. "/.config/hypr/scripts/KeyHints.sh",
        wlogout = HOME .. "/.config/hypr/scripts/Wlogout.sh",
    },

    -- Pixels a tiled window shifts or grows per key press.
    step = 30,
}
