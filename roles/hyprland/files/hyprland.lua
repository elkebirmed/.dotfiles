local terminal = "kitty"
local mainMod = "SUPER"

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})

hl.config({
    input = {
        kb_layout = "fr,ara",
    },
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
    },
    decoration = {
        rounding = 5,
    },
})

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
