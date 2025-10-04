local awful_screen = require("awful.screen")
local awful_wibar = require("awful.wibar")

local beautiful = require("beautiful")
local wibox = require("wibox")

local taglist = require("ui.bar.taglist")
local taglist_new = require("ui.bar.taglist-new")
local taglist_custom = require("ui.bar.taglist-custom")
local taglist_animated = require("ui.bar.taglist-animated")
local notifications_and_datetime = require("ui.bar.notifications_and_datetime")
local control_center_button = require("ui.bar.control-center-button")

local dashboard_button = require("ui.bar.dashboard-button")
local waydroid_button = require("ui.bar.waydroid-button")
--local weather_info = require("ui.bar.widgets.weather_info")
local client_info = require("ui.bar.widgets.client_info")
local mediabar = require("ui.bar.mediabar")
local systray = require("ui.bar.widgets.systray")
local systray_new = require("ui.bar.widgets.systray-new")
local device_indicators = require("ui.bar.widgets.device_indicators")
local battery = require("ui.bar.widgets.battery")
local layoutbox = require("ui.bar.widgets.layoutbox")

local function top_bar(s)
	local is_vertical = s.geometry.height > s.geometry.width

	local bar = awful_wibar({
		type = "dock",
		screen = s,
		height = is_vertical and dpi(64) or dpi(40),
	})

	bar:setup({
		{
			{
				layout = wibox.layout.align.horizontal,
				expand = "none",
				-- start
				{
					layoutbox(s),
					wibox.widget.separator({
						orientation = "vertical",
						color = beautiful.xforeground .. "70",
						thickness = dpi(2),
						span_ratio = 0.6,
						forced_width = dpi(2),
					}),
					dashboard_button,
					waydroid_button,
					wibox.widget.separator({
						orientation = "vertical",
						color = beautiful.xforeground .. "70",
						thickness = dpi(2),
						span_ratio = 0.6,
						forced_width = dpi(2),
					}),
					--weather_info,
					--taglist_new(s),
					taglist_custom(s),
					--client_info,
					spacing = dpi(4),
					layout = wibox.layout.fixed.horizontal,
				},
				-- middle
				{
					--taglist(s),
					--taglist_custom(s),
					taglist_animated(s),
					left = dpi(8),
					right = dpi(8),
					widget = wibox.container.margin,
				},
				-- end
				{
					mediabar(s.geometry.width, is_vertical),
					device_indicators,
					--systray_new,
					systray,
					battery(is_vertical),
					notifications_and_datetime(is_vertical),
					control_center_button,

					layout = wibox.layout.fixed.horizontal,
				},
			},
			margins = dpi(4),
			widget = wibox.container.margin,
		},
		widget = wibox.container.background,
	})

	return bar
end

local function create_top_bar(s)
	s.bar = top_bar(s)
end

screen.connect_signal("request::desktop_decoration", create_top_bar)
