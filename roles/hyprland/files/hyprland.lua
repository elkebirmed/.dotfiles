local input_layout = dofile(os.getenv("HOME") .. "/.config/hypr/input_layout.lua")

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
        float_gaps = 12,
        -- layout = "scrolling",

        snap = {
            enabled = true,
        },

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
            xray = true,
        },

        shadow = {
            enabled = true,
            range = 10,
            render_power = 3,
        },
    },

    input = {
        kb_layout = input_layout,
        kb_options = "grp:alt_shift_toggle",
        sensitivity  = 0,
        follow_mouse = 1,
        numlock_by_default = true,

        touchpad     = {
            natural_scroll = true,
        },
    },

    binds = {
		pass_mouse_when_bound = false,
		scroll_event_delay = 1,
	},
})

hl.window_rule({
  match   = { class = "kitty" },
  opacity = 0.90,
})

hl.window_rule({
  match = { workspace = "1", },
  float = true,
})

dofile(os.getenv("HOME") .. "/.config/hypr/keybinds.lua")

local noctalia_hook = os.getenv("HOME") .. "/.config/hypr/noctalia.lua"
local noctalia_hook_file = io.open(noctalia_hook, "r")
if noctalia_hook_file then
    noctalia_hook_file:close()
    dofile(noctalia_hook)
end
