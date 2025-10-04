local spawn = require("awful.spawn")
local gtimer = require("gears.timer")

local json = require("away.third_party.dkjson")

local helpers = require("helpers")
local variables = require("configuration.variables")


local naughty = require("naughty")

local endpoint = "https://api.openweathermap.org/data/2.5/weather"
--local endpoint = "https://api.openweathermap.org/data/3.0/onecall"

local query_params = {
	appid = variables.openWeather.weather_api_key,
	lat = variables.openWeather.latitude,
	lon = variables.openWeather.longitude,
	units = variables.openWeather.units,
	-- TODO: add language to variables
	lang = "en",
}

local function table_to_query_string(query_params)
	local query_string = {}

	for key, value in pairs(query_params) do
		table.insert(query_string, string.format("%s=%s", key, value))
	end

	return table.concat(query_string, "&")
end

local function on_connection()
	local command = string.format("curl -s -m 7 '%s?%s'", endpoint, table_to_query_string(query_params))
	--!naughty.notify({text=command})
    spawn.easy_async_with_shell(command, function(stdout, stderr)
		awesome.emit_signal("weather::update", json.decode(stdout))
	end)
end

local timer = gtimer({
	timeout = 60 * 30,
	call_now = true,
	autostart = true,
	callback = function()
		helpers.check_internet_connection(on_connection)
	end,
})
