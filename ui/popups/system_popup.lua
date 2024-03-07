local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")

local text_icon = require("ui.widgets.text-icon")

local popup_icon = text_icon {
    text = "\u{e050}",
    size = 80
}

local progressbar = wibox.widget {
    max_value = 100,
    value = 0,
    background_color = beautiful.black,
    color = beautiful.accent,
    shape = gears.shape.rounded_bar,
    bar_shape = helpers.rrect(beautiful.popup_border_radius),
    border_width = dpi(2),
    border_color = beautiful.focus,
    paddings = dpi(6),
    forced_height = dpi(44),
    widget = wibox.widget.progressbar
}

local system_popup = awful.popup {
    widget = {
        {
            {
                popup_icon,
                progressbar,
                spacing = dpi(4),
                layout = wibox.layout.fixed.vertical
            },
            margins = dpi(16),
            widget = wibox.container.margin
        },
        bg = beautiful.popup_bg,
        border_width = dpi(2),
        border_color = beautiful.focus,
        shape = helpers.rrect(beautiful.popup_border_radius),
        widget = wibox.container.background
    },
    minimum_width = beautiful.popup_size - dpi(28),
    maximum_height = beautiful.popup_size,
    maximum_width = beautiful.popup_size,
    placement = awful.placement.centered,
    ontop = true,
    visible = false
}

local timer = gears.timer {
    timeout = 1.6,
    single_shot = true,
    callback = function()
        system_popup.visible = false
    end
}

system_popup.show = function(icon_markup, value, color)
    popup_icon.markup = icon_markup

    if value >= 0 then
        progressbar.value = value
        progressbar.color = color
        progressbar.border_color = color
        progressbar.visible = true
    else
        progressbar.visible = false
    end

    awful.placement.centered(
        system_popup, {
            parent = awful.screen.focused()
        }
    )

    if system_popup.visible then
        timer:again()
    else
        system_popup.visible = true
        timer:start()
    end
end

return system_popup
