-- Keybindings ----------------------------------------------------------------

local mainMod = "SUPER"

-- Layout detection: AZERTY if input_layout starts with "fr", otherwise QWERTY
local input_layout = dofile(os.getenv("HOME") .. "/.config/hypr/input_layout.lua")
local is_azerty = input_layout:sub(1, 2) == "fr"

-- Apps / session -------------------------------------------------------------
hl.workspace_rule({
    workspace = "special:dropdown",
    on_created_empty = "kitty --class kitty-dropdown",
    gaps_in = 0,
    gaps_out = 0,
})

hl.window_rule({
    match = { class = "^kitty-dropdown$" },
    float = true,
    size = { "monitor_w", "monitor_h*0.5" },
    move = { 0, 0 },
    rounding = 0,
})

hl.bind(mainMod .. " + Return", hl.dsp.workspace.toggle_special("dropdown"), { description = "Toggle dropdown kitty" })
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd("kitty"), { description = "Open kitty" })
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { description = "Close window" })
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exit(), { description = "Exit Hyprland" })

-- Window state ---------------------------------------------------------------
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }), { description = "Toggle Fullscreen" })
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }), { description = "Toggle Maximize Window" })
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle Floating" })
hl.bind(mainMod .. " + ALT + T", function()
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    hl.dispatch(hl.dsp.window.pin({ action = "toggle" }))
end, { description = "Toggle floating + pinned" })

-- Layout / groups ------------------------------------------------------------
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"), { description = "Toggle split" })
hl.bind(mainMod .. " + K", hl.dsp.layout("swapsplit"), { description = "Swapsplit" })
hl.bind(mainMod .. " + G", hl.dsp.group.toggle(), { description = "Toggle window group" })

-- Scratchpad -----------------------------------------------------------------
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("scratchpad"), { description = "Toggle special workspace scratchpad" })
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratchpad" }), { description = "Move window to special workspace scratchpad" })

-- Workspace navigation -------------------------------------------------------
for _, key in ipairs({ "LEFT", "L" }) do
    hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.focus({ workspace = "e-1" }), { description = "Move to previous workspace" })
    hl.bind(mainMod .. " + CTRL + SHIFT + " .. key, hl.dsp.window.move({ workspace = "e-1" }), { description = "Move window to previous workspace" })
end
for _, key in ipairs({ "RIGHT", "H" }) do
    hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.focus({ workspace = "e+1" }), { description = "Move to next workspace" })
    hl.bind(mainMod .. " + CTRL + SHIFT + " .. key, hl.dsp.window.move({ workspace = "e+1" }), { description = "Move window to next workspace" })
end

hl.bind(
	mainMod .. " + mouse_down",
	hl.dsp.focus({ workspace = "e+1" }),
	{ description = "Switch to next workspace" }
)

hl.bind(
	mainMod .. " + mouse_up",
	hl.dsp.focus({ workspace = "e-1" }),
	{ description = "Switch to previous workspace" }
)

-- Directional focus / move / resize -------------------------------------------
-- key name -> { direction, resize x, resize y }
local directions = {
    { keys = { "LEFT",  "H" }, dir = "left",  rx = -40, ry = 0 },
    { keys = { "DOWN",  "J" }, dir = "down",  rx = 0,   ry = 40 },
    { keys = { "UP",    "K" }, dir = "up",    rx = 0,   ry = -40 },
    { keys = { "RIGHT", "L" }, dir = "right", rx = 40,  ry = 0 },
}

for _, d in ipairs(directions) do
    for _, key in ipairs(d.keys) do
        -- SUPER+J / SUPER+K are taken by togglesplit / swapsplit, so skip them for focus
        if key ~= "J" and key ~= "K" then
            hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = d.dir }),
                { description = "Focus window " .. d.dir })
        end
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = d.dir }),
            { description = "Move window " .. d.dir })
        hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.window.resize({ x = d.rx, y = d.ry, relative = true }),
            { description = "Resize window " .. d.dir, repeating = true })
    end
end

hl.bind("ALT + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end)

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), {
    mouse = true,
})

hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), {
    mouse = true,
})

-- Workspaces by number -------------------------------------------------------
local qwerty_keys = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }
local azerty_keys = {
    "ampersand", "eacute", "quotedbl", "apostrophe", "parenleft",
    "minus", "egrave", "underscore", "ccedilla", "agrave",
}
local number_keys = is_azerty and azerty_keys or qwerty_keys

for i, key in ipairs(number_keys) do
    local ws = (i == 10) and 10 or i
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = ws }),
        { description = "Focus workspace " .. ws })
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = ws }),
        { description = "Move window to workspace " .. ws })
end

-- Media keys --------------------------------------------------------------------
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up"), { description = "Increase volume" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"), { description = "Decrease volume" })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia msg volume-mute"), { description = "Mute volume" })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up"), { description = "Increase brightness" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down"), { description = "Decrease brightness" })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { description = "Play/Pause media" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { description = "Next track" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { description = "Previous track" })
