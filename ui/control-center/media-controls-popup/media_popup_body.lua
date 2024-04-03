local beautiful = require("beautiful")
local wibox = require("wibox")

local border_popup = require("ui.widgets.border-popup")

local media_controls = require("ui.widgets.media.media-controls")
local media_image = require("ui.widgets.media.media-image")
local player_icon = require("ui.widgets.media.player_icon")

local interval = require("ui.control-center.media-controls-popup.media-interval")
local media_info = require("ui.control-center.media-controls-popup.media-info")
local progressbar = require("ui.control-center.media-controls-popup.media-progressbar")

local media_buttons = wibox.widget {
    media_controls.prev(16),
    media_controls.play(21),
    media_controls.next(16),
    media_controls.loop(16),
    spacing = dpi(1),
    layout = wibox.layout.fixed.horizontal
}

local cover = wibox.widget {
    {
        media_image(8),
        widget = wibox.container.place
    },
    {
        player_icon(25, "popup"),
        valign = "bottom",
        halign = "right",
        widget = wibox.container.place
    },
    horizontal_offset = dpi(8),
    layout = wibox.layout.stack
}

local body = wibox.widget {
    {
        {
            {
                {
                    media_info,
                    progressbar,
                    {
                        media_buttons,
                        nil,
                        interval,
                        layout = wibox.layout.flex.horizontal
                    },
                    spacing = dpi(8),
                    forced_width = dpi(200),
                    layout = wibox.layout.fixed.vertical
                },
                margins = dpi(8),
                widget = wibox.container.margin
            },
            {
                cover,
                widget = wibox.container.place
            },
            spacing = dpi(8),
            layout = wibox.layout.fixed.horizontal
        },
        margins = dpi(4),
        widget = wibox.container.margin
    },
    bg = beautiful.black,
    widget = wibox.container.background
}

return border_popup {
    widget = body,
    maximum_width = dpi(beautiful.control_center_width)
}
