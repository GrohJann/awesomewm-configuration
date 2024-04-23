local spawn = require("awful.spawn")
local gfs = require("gears.filesystem")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal(
    "request::display_error", function(message, startup)
        naughty.notification {
            urgency = "critical",
            title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
            message = message
        }
    end
)

dpi = beautiful.xresources.apply_dpi

-- Autostart programs
spawn.with_shell(gfs.get_configuration_dir() .. "configuration/autostart.sh")

-- Theme + Configs
beautiful.init(gfs.get_configuration_dir() .. "theme/theme.lua")
--require("bindings")
require("configuration")


-- Set Wallpapers
--require("dynamic-multi-screen")
local awful_screen = require("awful.screen")
local bling = require("module/bling")

awful_screen.connect_for_each_screen(function(s)
    bling.module.wallpaper.setup {
        wallpaper = os.getenv("HOME") .. "/Pictures/Wallpapers/110014443_p0 2560x1440.png",
        position = "fit",
        screen = s,
    }
end)


-- Import UI + Signals
require("ui")
require("signals")

-- Garbage Collector Settings
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
