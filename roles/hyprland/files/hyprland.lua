local terminal = "kitty"
local mainMod = "SUPER"

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})

hl.config({
    general = {
        border_size = 2,
        gaps_in = 12,
        gaps_out = 12,
        layout = "scrolling",
        col = dofile(os.getenv("HOME") .. "/.config/hypr/colors.lua"),
    },

    decoration = {
        rounding = 12,
	    rounding_power = 2;

        blur = {
            enabled = true,
            brightness = 0.8,
            contrast = 2,
            noise = 0.05,
            vibrancy = 0.35,
            vibrancy_darkness = 0.35,
            passes = 2,
            size = 10,
            special = false,
        },

        shadow = {
            enabled = true,
            range = 10,
            render_power = 3,
        },
    },

    input = {
        kb_layout = "fr,ara",
    },
})

hl.window_rule({
  match   = { class = "kitty" },
  opacity = 0.90,
})

hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exit())

hl.bind(mainMod .. " + CTRL + LEFT", hl.dsp.exec_cmd("hyprctl dispatch workspace -1"))
hl.bind(mainMod .. " + CTRL + RIGHT", hl.dsp.exec_cmd("hyprctl dispatch workspace +1"))

hl.bind(mainMod .. " + SHIFT + LEFT", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspace -1"))
hl.bind(mainMod .. " + SHIFT + RIGHT", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspace +1"))

hl.bind("ALT + TAB", hl.dsp.window.cycle_next())
hl.bind("ALT + SHIFT + TAB", hl.dsp.exec_cmd("hyprctl dispatch cyclenext prev"))

local directions = {
    { direction = "left", keys = { "H", "LEFT" }, resize = { x = -40, y = 0 } },
    { direction = "down", keys = { "J", "DOWN" }, resize = { x = 0, y = 40 } },
    { direction = "up", keys = { "K", "UP" }, resize = { x = 0, y = -40 } },
    { direction = "right", keys = { "L", "RIGHT" }, resize = { x = 40, y = 0 } },
}

for _, movement in ipairs(directions) do
    for _, key in ipairs(movement.keys) do
        hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = movement.direction }))
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = movement.direction }))
        hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.window.resize({
            x = movement.resize.x,
            y = movement.resize.y,
            relative = true,
        }))
    end
end

for _, key in ipairs({ "H", "LEFT" }) do
    hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.exec_cmd("hyprctl dispatch workspace -1"))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.exec_cmd("hyprctl dispatch movetoworkspace -1"))
end

for _, key in ipairs({ "L", "RIGHT" }) do
    hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.exec_cmd("hyprctl dispatch workspace +1"))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.exec_cmd("hyprctl dispatch movetoworkspace +1"))
end

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia msg volume-mute"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))

dofile(os.getenv("HOME") .. "/.config/hypr/keybinds.lua")

local noctalia_hook = os.getenv("HOME") .. "/.config/hypr/noctalia.lua"
local noctalia_hook_file = io.open(noctalia_hook, "r")
if noctalia_hook_file then
    noctalia_hook_file:close()
    dofile(noctalia_hook)
end
