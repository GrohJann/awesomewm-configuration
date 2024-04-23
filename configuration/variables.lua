local gfs = require("gears.filesystem")

local HOME = os.getenv("HOME")

return {
	apps = {
		editor = "nvim",
		file_manager = "nautilus",
		terminal = "kitty",
		browser = "firefox",
		browser_private = "firefox --private-window",
		launcher = HOME .. "/.config/rofi/launchers/type-2/launcher.sh",
	},

	openWeather = {
		-- OpenWeather api key
		weather_api_key = "70ba53c5bc150dff7c438bc85045243a",
		latitude = 49.006,
		longitude = 8.403,
	},

	pfp = gfs.get_configuration_dir() .. "ui/assets/kirbeats.jpg",
	--pfp = HOME .. ".face",

	

	-- Optional variables
	-- Video wallpaper
	-- videowallpaper_path = HOME .. "/Videos/cyberpunk-city-pixel.mp4",
	-- videowallpaper_vertical_path = HOME .. "/Videos/cyberpunk-city-pixel-vertical.mp4",

	-- Dominantcolors script path
	-- dominantcolors_path = HOME .. "/.local/bin/dominantcolors",

	-- gcalendar requires output in json
	gcalendar_command = "gcalendar --output json --no-of-days 3",

	use_12_hour_clock = false,

	
}
