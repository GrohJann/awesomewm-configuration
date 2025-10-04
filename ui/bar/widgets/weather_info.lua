--[[
    stolen edit of @rxyhn's 
    https://github.com/rxyhn/yoru/blob/main/config/awesome/ui/panels/info-panel/weather/init.lua
]]

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local filesystem = gears.filesystem
local json = require("helpers.json")
local icon_dir = filesystem.get_configuration_dir() .. "icons/weather/"

--- Weather Widget
--- ~~~~~~~~~~~~~~

local GET_FORECAST_CMD = [[bash -c "curl -s '%s'"]]

local icon_map = {
	["01d"] = "weather-clear-sky",
	["02d"] = "weather-few-clouds",
	["03d"] = "weather-clouds",
	["04d"] = "weather-few-clouds",
	["09d"] = "weather-showers-scattered",
	["10d"] = "weather-showers",
	["11d"] = "weather-strom",
	["13d"] = "weather-snow",
	["50d"] = "weather-fog",
	["01n"] = "weather-clear-night",
	["02n"] = "weather-few-clouds-night",
	["03n"] = "weather-clouds-night",
	["04n"] = "weather-clouds-night",
	["09n"] = "weather-showers-scattered",
	["10n"] = "weather-showers",
	["11n"] = "weather-strom",
	["13n"] = "weather-snow",
	["50n"] = "weather-fog",
}

local current_weather_widget = wibox.widget({
	{
		id = "icon",
		image = icon_dir .. "weather-showers.svg",
		resize = true,
		forced_height = dpi(42),
		forced_width = dpi(42),
		widget = wibox.widget.imagebox,
	},
	{
		{
			{
				id = "description",
				text = "Not Updated",
				font = beautiful.font_name .. "Bold 10",
				widget = wibox.widget.textbox,
			},
			{
				id = "feels_like",
				markup = "Feels like: 69<sup><span>°</span></sup>",
				font = beautiful.font_name .. "Light 7",
				widget = wibox.widget.textbox,
			},
			layout = wibox.layout.fixed.vertical,
		},
		{
			id = "tempareture_current",
			markup = "69<sup><span>°</span></sup>",
			align = "right",
			font = beautiful.font_name .. "Bold 15",
			widget = wibox.widget.textbox,
		},
		spacing = dpi(10),
		layout = wibox.layout.fixed.horizontal,
	},
	layout = wibox.layout.fixed.horizontal,
})

local weather_widget = wibox.widget({
	current_weather_widget,
	spacing = dpi(10),
	layout = wibox.layout.fixed.vertical,
})

--TODO: set vars centrally
local api_key = "70ba53c5bc150dff7c438bc85045243a"
local coordinates = {
	"49.00937", -- latitude
	"8.40444", -- longitude
}
local units = "metric"

local url = (
	"https://api.openweathermap.org/data/2.5/weather"
	.. "?lat="
	.. coordinates[1]
	.. "&lon="
	.. coordinates[2]
	.. "&appid="
	.. api_key
	.. "&units="
	.. units
)

awful.widget.watch(string.format(GET_FORECAST_CMD, url), 600, function(_, stdout, stderr)
	if stderr == "" and stdout ~= "" then
		local result = json.decode(stdout)
		-- Current weather setup
		local icon = current_weather_widget:get_children_by_id("icon")[1]
		local description = current_weather_widget:get_children_by_id("description")[1]
		local humidity = current_weather_widget:get_children_by_id("humidity")[1]
		local temp_current = current_weather_widget:get_children_by_id("tempareture_current")[1]
		local feels_like = current_weather_widget:get_children_by_id("feels_like")[1]
		icon.image = icon_dir .. icon_map[result.weather[1].icon] .. ".svg"
		icon:emit_signal("widget::redraw_needed")
		description:set_text(result.weather[1].description:gsub("^%l", string.upper))
		--TODO: fix humidity var
		--humidity:set_text("Humidity: " .. result.main.humidity .. "%")
		temp_current:set_markup(math.floor(result.main.temp) .. "<sup><span>°</span></sup>")
		feels_like:set_markup("Feels like: " .. math.floor(result.main.feels_like) .. "<sup><span>°</span></sup>")
	end
end)

return weather_widget
