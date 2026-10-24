-- Keybindings
-- See https://wiki.hypr.land/Configuring/Basics/Binds/
--
-- Every bind carries a description; `hyprctl binds` shows them and the cheat
-- sheet (SUPER + /) is generated from them, so the two never drift apart.

local vars = require("vars")

local mainMod = vars.mainMod
local apps = vars.apps

-- -------  Window Management  -------
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { description = "Close the active window" })
hl.bind("ALT + F4", hl.dsp.window.close(), { description = "Close the active window" })
hl.bind(mainMod .. " + Delete", hl.dsp.exec_cmd(vars.scripts.wlogout), { description = "Open the logout menu" })
hl.bind(mainMod .. " + W", hl.dsp.window.float(), { description = "Toggle floating / tiled" })
hl.bind(mainMod .. " + G", hl.dsp.group.toggle(), { description = "Toggle the window group" })
hl.bind("SHIFT + F11", hl.dsp.window.fullscreen(), { description = "Toggle fullscreen" })
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"), { description = "Lock the screen" })
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.pin(), { description = "Pin to every workspace" })
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd(vars.scripts.wlogout), { description = "Open the logout menu" })
-- ignore_mods: the right-hand modifier keys never reach a bind as plain
-- modifiers, Hyprland compares the pressed mask exactly (ALT + CTRL != ALT).
hl.bind("ALT + Control_R", hl.dsp.exec_cmd(vars.scripts.waybarStyles), { ignore_mods = true, description = "Restart Waybar to reload its layout and style" })
hl.bind(mainMod .. " + CTRL + T", hl.dsp.exec_cmd(vars.scripts.waybarStyles), { description = "Restart Waybar to reload its layout and style" })

-- Group Navigation
hl.bind(mainMod .. " + CTRL + H", hl.dsp.group.prev(), { description = "Previous window in the group" })
hl.bind(mainMod .. " + CTRL + L", hl.dsp.group.next(), { description = "Next window in the group" })

-- Change Focus
for _, dir in ipairs({
    { key = "Left", direction = "left", label = "left" },
    { key = "Right", direction = "right", label = "right" },
    { key = "Up", direction = "up", label = "above" },
    { key = "Down", direction = "down", label = "below" },
}) do
    hl.bind(mainMod .. " + " .. dir.key, hl.dsp.focus({ direction = dir.direction }), { description = "Focus the window " .. dir.label })
end
hl.bind("ALT + Tab", hl.dsp.window.cycle_next(), { description = "Cycle through open windows" })

-- Resize Active Window
for _, dir in ipairs({
    { key = "Left", x = -vars.step, y = 0, label = "left" },
    { key = "Right", x = vars.step, y = 0, label = "right" },
    { key = "Up", x = 0, y = -vars.step, label = "shorter" },
    { key = "Down", x = 0, y = vars.step, label = "taller" },
}) do
    hl.bind(mainMod .. " + SHIFT + " .. dir.key, hl.dsp.window.resize({ x = dir.x, y = dir.y, relative = true }), { repeating = true, description = "Make the window " .. dir.label })
end

-- Move Active Window: shift floating windows, swap tiled ones with their neighbour
for _, dir in ipairs({
    { key = "Left", direction = "left", x = -vars.step, y = 0, label = "left" },
    { key = "Right", direction = "right", x = vars.step, y = 0, label = "right" },
    { key = "Up", direction = "up", x = 0, y = -vars.step, label = "up" },
    { key = "Down", direction = "down", x = 0, y = vars.step, label = "down" },
}) do
    hl.bind(mainMod .. " + SHIFT + CTRL + " .. dir.key, function()
        local win = hl.get_active_window()
        if win and win.floating then
            hl.dispatch(hl.dsp.window.move({ x = dir.x, y = dir.y, relative = true }))
        else
            hl.dispatch(hl.dsp.window.move({ direction = dir.direction }))
        end
    end, { repeating = true, description = "Move the window " .. dir.label })
end

-- Move & Resize with Mouse
-- The { mouse = true } flag is accepted but ignored by Hyprland 0.56; the mouse
-- behaviour comes from the dispatcher itself (drag/resize are the mouse variants).
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Drag the window with the mouse" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize the window with the mouse" })

-- -------  Launchers  -------
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(apps.terminal), { description = "Open a terminal" })
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(apps.browser), { description = "Open the browser (Zen)" })
hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd(apps.terminal .. " --class btop -e btop"), { description = "Open btop in a terminal" })
hl.bind(mainMod .. " + M", hl.dsp.focus({ workspace = "special:spotify" }), { description = "Open the Spotify scratchpad" })
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(apps.fileBrowser), { description = "Open the file manager" })

-- Rofi
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("pkill -x " .. apps.menu .. " || " .. apps.menu .. " -show drun"), { description = "Rofi app launcher" })
hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd("pkill -x " .. apps.menu .. " || " .. apps.menu .. " -show window"), { description = "Rofi window switcher" })
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("pkill -x " .. apps.menu .. " || cliphist-menu"), { description = "Clipboard history" })

-- -------  Hardware Controls  -------
-- Audio (wpctl via pipewire — already in your packages)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, description = "Toggle the audio mute" })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, description = "Toggle the microphone mute" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true, description = "Lower the volume" })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true, description = "Raise the volume" })

-- Media
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Play / pause the media" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Play / pause the media" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true, description = "Next track" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true, description = "Previous track" })

-- Brightness (brightnessctl is in nixpkgs)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true, description = "Raise the brightness" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true, description = "Lower the brightness" })

-- -------  Utilities  -------
hl.bind(mainMod .. " + K", hl.dsp.exec_cmd("hyprctl switchxkblayout all next"), { locked = true, description = "Switch the keyboard layout" })
hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd(vars.scripts.keyHints), { description = "Show the keybind cheat sheet" })

-- Screenshots (hyprshot is already in your packages.nix)
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("hyprpicker -an"), { description = "Pick a colour" })
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("hyprshot -m region"), { description = "Screenshot of the selected region" })
hl.bind(mainMod .. " + CTRL + P", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'), { description = "Copy screen area to clipboard" })
hl.bind(mainMod .. " + ALT + P", hl.dsp.exec_cmd("hyprshot -m output"), { description = "Screenshot of the output" })
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m output"), { description = "Screenshot of the output" })

-- -------  Workspaces  -------
for i = 1, 10 do
    local key = tostring(i % 10) -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }), { description = "Switch to workspace " .. i })
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), { description = "Move to workspace " .. i })
    hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }), { description = "Move to workspace " .. i .. " (silent)" })
end

hl.bind(mainMod .. " + CTRL + Right", hl.dsp.focus({ workspace = "r+1" }), { description = "Switch to the next workspace" })
hl.bind(mainMod .. " + CTRL + Left", hl.dsp.focus({ workspace = "r-1" }), { description = "Switch to the previous workspace" })
hl.bind(mainMod .. " + CTRL + Down", hl.dsp.focus({ workspace = "empty" }), { description = "Switch to the last empty workspace" })
hl.bind(mainMod .. " + CTRL + ALT + Right", hl.dsp.window.move({ workspace = "r+1" }), { description = "Move to the next workspace" })
hl.bind(mainMod .. " + CTRL + ALT + Left", hl.dsp.window.move({ workspace = "r-1" }), { description = "Move to the previous workspace" })

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Switch to the next workspace" })
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Switch to the previous workspace" })

-- Special workspaces
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("spotify"), { description = "Toggle the Spotify scratchpad" })
hl.bind(mainMod .. " + backslash", hl.dsp.workspace.toggle_special("terminal"), { description = "Toggle the terminal scratchpad" })
