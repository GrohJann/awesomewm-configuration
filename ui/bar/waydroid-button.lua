local awful_button = require("awful.button")
local beautiful = require("beautiful")
local gtable = require("gears.table")
local wibox_container = require("wibox.container")
local wibox_widget = require("wibox.widget")

local helpers = require("helpers")

local text_icon = require("ui.widgets.text-icon")
local clickable_container = require("ui.widgets.clickable-container")

local awful = require("awful")

local dashboard_button = clickable_container({
	-- TODO get imagebox working
	--[[widget = wibox_widget.imagebox {
        image  = beautiful.awesome_icon,
        resize = false,
        
    },--]]
	widget = text_icon({
		--text = "\u{f0032} ",
		--text = "\u{e70e}",
		size = 20,
		--font = "Iosevka NF",
		font = "Material Symbols Rounded",
		text = "\u{e60e}",
	}),
	margins = {
		top = dpi(2),
		bottom = dpi(2),
		left = dpi(4),
		right = dpi(4),
	},
})

helpers.add_action(dashboard_button, function(c)
	-- TODO: make control_center toggle
	--awesome.emit_signal("control_center::toggle")
	awesome.emit_signal("dashboard::toggle")
	awful.spawn.with_shell("weston --shell=kiosk& \
env WAYLAND_DISPLAY=wayland-1 XDG_SESSION_TYPE=wayland waydroid show-full-ui")
end)

awesome.connect_signal("control_center::visible", function(visible)
	dashboard_button.bg = visible and beautiful.focus or beautiful.transparent
	dashboard_button.focused = visible
end)

return {
	dashboard_button,
	left = dpi(4),
	right = dpi(4),
	widget = wibox_container.margin,
}
