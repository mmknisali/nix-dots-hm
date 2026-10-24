-- Monitors
-- https://wiki.hypr.land/Configuring/Basics/Monitors/

require("monitors")

-- Window rules
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

require("windowrules")

-- Input, gestures and other personal preferences
-- https://wiki.hypr.land/Configuring/Basics/Variables/

require("userprefs")

-- Keyboard shortcuts
require("keybindings")

-- Autostart
-- https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
    hl.exec_cmd(os.getenv("HOME") .. "/.local/bin/zen-warmup")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("poweralertd")
    hl.exec_cmd("hyprctl setcursor rose-pine-hyprcursor 24")
end)
