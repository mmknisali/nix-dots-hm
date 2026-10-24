-- Personal preferences: input, gestures, special workspaces and misc tweaks
-- See https://wiki.hypr.land/Configuring/Basics/Variables/

local vars = require("vars")

local gestureFingers = 3

-- 🔗 See https://wiki.hypr.land/Configuring/Variables/#input
hl.config({
    input = {
        kb_layout = "us,tr",
        -- follow_mouse = 1,
        -- sensitivity = 0,
        -- force_no_accel = false,
        -- accel_profile = "flat",
        -- numlock_by_default = true,

        -- 🔗 See https://wiki.hypr.land/Configuring/Variables/#touchpad
        touchpad = {
            natural_scroll = true,
        },
    },
})

-- Misc tweaks: swallow windows like devour, variable refresh rate, ...
-- hl.config({
--     misc = {
--         enable_swallow = true,
--         swallow_regex = "(foot|kitty|allacritty|Alacritty|ghostty|Ghostty|org.wezfurlong.wezterm)",
--         vfr = false,
--     },
-- })

-- 🔗 See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- Only the terminal scratchpad gets a dedicated class; regular Kitty stays
-- on the workspace where it was launched.
hl.workspace_rule({ workspace = "special:spotify", on_created_empty = "spotify" })
hl.workspace_rule({ workspace = "special:terminal", on_created_empty = vars.apps.terminalScratch })

-- 🔗 See https://wiki.hypr.land/Configuring/Variables/#gestures
hl.gesture({ fingers = gestureFingers, direction = "horizontal", action = "workspace" })

-- Swipe down to lock the screen
hl.gesture({
    fingers = gestureFingers,
    direction = "down",
    action = function() hl.exec_cmd("hyprlock") end,
})

-- 🔗 See https://wiki.hypr.land/Configuring/Variables/#ecosystem
-- Don't show update news on first launch
-- hl.config({
--     ecosystem = {
--         no_update_news = true,
--     },
-- })
