local awful_screen = require("awful.screen")

local bling = require("module.bling")
local rubato = require("module.rubato")

local variables = require("configuration.variables")

local anim_y = rubato.timed {
    easing = rubato.quadratic,
    intro = 0.1,
    duration = 0.3,
    awestore_compat = true
}

local scratchpad = bling.module.scratchpad {
    command = variables.apps.terminal,
--    rule = {
--        instance = "youtube music"
--    },
    sticky = true,
    autoclose = true,
    floating = true,
    reapply = true,
    dont_focus_before_close = false,
    rubato = {
        y = anim_y
    }
}

function scratchpad:reapply_geometry()
    local screen_geometry = awful_screen.focused().geometry
    local width = screen_geometry.width
    local height = screen_geometry.height

    local is_vertical = width < height

    scratchpad.geometry = {
        x = width / (is_vertical and 50 or 7),
        y = height / 8 + screen_geometry.y,
        width = width * (is_vertical and 0.96 or 0.7),
        height = height * 0.7
    }
end

return scratchpad
