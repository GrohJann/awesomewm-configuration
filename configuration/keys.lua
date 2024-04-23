local awful = require("awful")
local naughty = require("naughty")

local revelation = require("away.third_party.revelation")

local helpers = require("helpers")
local system_controls = require("helpers.system_controls")

local playerctl = require("signals.playerctl")
local variables = require("configuration.variables")

local hotkeys_popup = require("ui.hotkeys_popup")
local menu = require("ui.menu")


local super = "Mod4"
local alt = "Mod1"
local ctrl = "Control"
local shift = "Shift"


-- Awesome stuff
awful.keyboard.append_global_keybindings({
	awful.key({}, "F1", hotkeys_popup.show_help, {
		description = "Show Help",
		group = "Awesome",
	}),
	awful.key({ super }, "F1", hotkeys_popup.show_help, {
		description = "Show Help",
		group = "Awesome",
	}),
	awful.key({ super, shift }, "r", awesome.restart, {
		description = "Reload Awesome",
		group = "Awesome",
	}),
	awful.key({ super, shift }, "q", awesome.quit, {
		description = "Quit Awesome",
		group = "Awesome",
	}),
	awful.key({ super }, "l", function()
		awesome.emit_signal("lockscreen::visible", true)
	end, {
		description = "Lock Screen",
		group = "Awesome",
	}),
    --TODO: figure out why this does nothing
    awful.key({}, "XF86PowerOff", function()
		awesome.emit_signal("exit_screen::show")
	end, {
		description = "show exit screen",
		group = "Awesome",
	}),
    awful.key({ super }, "n", function()
		awesome.emit_signal("notification_center::toggle")
	end, {
		description = "toggle notifcation center",
		group = "Awesome",
	}),
	awful.key({ super }, "s", helpers.toggle_silent_mode, {
		description = "toggle silent mode",
		group = "Awesome",
	}),
	awful.key({ super }, "c", function()
		awesome.emit_signal("control_center::toggle")
	end, {
		description = "toggle control center",
		group = "Awesome",
	}),
    awful.key({ super }, "Tab", revelation, {
		description = "use revelation",
		group = "Awesome",
	}),
	awful.key({ alt }, "Tab", function()
		awesome.emit_signal("bling::Client_switcher::turn_on")
	end, {
		description = "Client switcher",
		group = "Awesome",
	}),
	awful.key({ super }, "v", function()
		awful.spawn("diodon")
	end, {
		description = "Open Copy History",
		group = "Awesome",
	}),
    -- TODO: check if this works
	awful.key({ super, shift }, "n", function()
		if not naughty.suspended then
			naughty.destroy_all_notifications()
		end
		naughty.suspended = not naughty.suspended
		naughty.emit_signal("property::suspended", naughty, naughty.suspended)
	end, {
		description = "Toggle Do Not Disturb",
		group = "Awesome",
	}),
	awful.key({ super, shift }, "g", function(c)
		naughty.notification({
			text = "Garbage collected",
		})
		collectgarbage("collect")
	end, {
		description = "Collect Garbarge",
		group = "Awesome",
	}),
    awful.key({ super }, "m", function()
		awful.spawn.easy_async_with_shell("autorandr --cycle", function(stdout)
			naughty.notification({
				text = stdout,
			})
		end)
	end, {
		description = "cycle autorandr",
		group = "Awesome",
	}),
})


-- Screenshots
awful.keyboard.append_global_keybindings({
    awful.key({}, "Print", function()
        awful.spawn("flameshot gui")
    end, {
        description = "Take an Area Screenshot",
        group = "Screenshots",
    }),
    awful.key({ super, shift }, "s", function()
        awful.spawn("flameshot gui")
    end, {
        description = "Take an Area Screenshot",
        group = "Screenshots",
    }),
    awful.key({ alt }, "Print", function()
        awful.spawn("flameshot full")
    end, {
        description = "Take a Full Screenshot",
        group = "Screenshots",
    }),
})



-- Apps
awful.keyboard.append_global_keybindings({
	awful.key({ super }, "space", function()
		awful.spawn(variables.apps.launcher)
	end, {
		description = "Open App Launcher",
		group = "Apps",
	}),
	awful.key({ super }, "Return", function()
		awful.spawn(variables.apps.terminal)
	end, {
		description = "open terminal",
		group = "Apps",
	}),
	awful.key({ super }, "e", function()
		awful.spawn(variables.apps.file_manager)
	end, {
		description = "Open File Manager",
		group = "Apps",
	}),
	awful.key({ super }, "b", function()
		awful.spawn(variables.apps.browser)
	end, {
		description = "Open Browser",
		group = "Apps",
	}),
	awful.key({ super, shift }, "b", function()
		awful.spawn(variables.apps.browser_private)
	end, {
		description = "Open Private Browser",
		group = "Apps",
	}),
--TODO: add terminal scratchpad
--	awful.key({ super, shift }, "Return", function()
--		terminal_scratchpad:reapply_geometry()
--		terminal_scratchpad:toggle()
--	end, {
--		description = "Toggle Termianal Scratchpad",
--		group = "Awesome",
--	}),
})


-- Client Bindings
awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { super },
		keygroup = "arrows",
		description = "Focus Client by Direction",
		group = "Client",
		on_press = function(key)
			awful.client.focus.bydirection(key:lower())
		end,
	}),
	awful.key({ super }, "x", function()
		if client.focus then
			client.focus:kill()
		end
	end, {
		description = "Close Client",
		group = "Client",
	}),
	awful.key({ super }, "h", function()
		awful.client.focus.bydirection("left")
	end, {
		description = "Focus Left Client",
		group = "Client",
	}),
	awful.key({ super }, "j", function()
		awful.client.focus.bydirection("down")
	end, {
		description = "Focus Down Client",
		group = "Client",
	}),
	awful.key({ super }, "k", function()
		awful.client.focus.bydirection("up")
	end, {
		description = "Focus Up Client",
		group = "Client",
	}),
	awful.key({ super }, "l", function()
		awful.client.focus.bydirection("right")
	end, {
		description = "Focus Right Client",
		group = "Client",
	}),
	awful.key({ super, "Shift" }, "j", function()
		awful.client.swap.byidx(1)
	end, {
		description = "Swap with Next Client",
		group = "Client",
	}),
	awful.key({ super, "Shift" }, "k", function()
		awful.client.swap.byidx(-1)
	end, {
		description = "Swap with Previous Client",
		group = "Client",
	}),
	awful.key({ super }, "u", awful.client.urgent.jumpto, {
		description = "Jump to Urgent Client",
		group = "Client",
	}),
	awful.key({ ctrl, shift, super }, "[", function()
		swap_all_clients_between_screens("left")
	end, {
		description = "move all clients to previous screen",
		group = "Client",
	}),
	awful.key({ ctrl, shift, super }, "]", function()
		swap_all_clients_between_screens("right")
	end, {
		description = "move all clients to next screen",
		group = "Client",
	}),
})


-- Hotkeys
awful.keyboard.append_global_keybindings({
	-- Brightness Control
	awful.key({}, "XF86MonBrightnessUp", function()
		system_controls.brightness_control("increase")
	end, {
		description = "Increase Brightness",
		group = "Hotkeys",
	}),
	awful.key({}, "XF86MonBrightnessDown", function()
		system_controls.brightness_control("decrease")
	end, {
		description = "Decrease Brightness",
		group = "Hotkeys",
	}), -- Volume control
	awful.key({}, "XF86AudioRaiseVolume", function()
		system_controls.volume_control("increase", 5)
	end, {
		description = "Increase Volume",
		group = "Hotkeys",
	}),
	awful.key({}, "XF86AudioLowerVolume", function()
		system_controls.volume_control("decrease", 5)
	end, {
		description = "Decrease Volume",
		group = "Hotkeys",
	}),
	awful.key({}, "XF86AudioMute", function()
		system_controls.volume_control("mute")
	end, {
		description = "Mute Volume",
		group = "Hotkeys",
	}),
	awful.key({}, "XF86AudioMicMute", function()
		system_controls.mic_toggle()
	end, {
		description = "Mute Microphone",
		group = "Hotkeys",
	}), -- Music
	awful.key({}, "XF86AudioPlay", function()
		playerctl:play_pause()
	end, {
		description = "Toggle Media Playback",
		group = "Hotkeys",
	}),
	awful.key({}, "XF86AudioPrev", function()
		playerctl:previous()
	end, {
		description = "Play Previous Media",
		group = "Hotkeys",
	}),
	awful.key({}, "XF86AudioNext", function()
		playerctl:next()
	end, {
		description = "Play Next Media",
		group = "Hotkeys",
	}),
})
	
	
-- Screen
awful.keyboard.append_global_keybindings({
	awful.key({ super }, "]", function()
		awful.screen.focus(helpers.get_next_screen("right"))
	end, {
		description = "Focus the next Screen",
		group = "Screen",
	}),
	awful.key({ super }, "[", function()
		awful.screen.focus(helpers.get_next_screen("left"))
	end, {
		description = "Focus the previous Screen",
		group = "Screen",
	}),
})	
	
    
-- Layout
awful.keyboard.append_global_keybindings({
	awful.key({ super, ctrl }, "k", function()
		awful.tag.incmwfact(0.05)
	end, {
		description = "increase master width factor",
		group = "Layout",
	}),
	awful.key({ super, ctrl }, "j", function()
		awful.tag.incmwfact(-0.05)
	end, {
		description = "decrease master width factor",
		group = "Layout",
	}),
	awful.key({ super, ctrl }, "l", function()
		awful.tag.incncol(1, nil, true)
	end, {
		description = "increase #columns",
		group = "Layout",
	}),
	awful.key({ super, ctrl }, "h", function()
		awful.tag.incncol(-1, nil, true)
	end, {
		description = "decrease #columns",
		group = "Layout",
	}),
})


-- Tags
awful.keyboard.append_global_keybindings({
	--[[awful.key({ super }, ";", awful.tag.viewprev, {
		description = "View previous Workspace",
		group = "Workspace",
	}),
	awful.key({ super }, ",", awful.tag.viewnext, {
		description = "View next Workspace",
		group = "Workspace",
	}),]]
	awful.key({
		modifiers = { super },
		keygroup = "numrow",
		description = "View Workspace #",
		group = "Workspace",
		on_press = function(index)
			local tag = awful.screen.focused().tags[index]
			if tag then
				tag:view_only()
			end
		end,
	}),
	awful.key({
		modifiers = { super, "Control" },
		keygroup = "numrow",
		description = "Toggle Workspace",
		group = "Workspace",
		on_press = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end,
	}),
	awful.key({
		modifiers = { super, shift },
		keygroup = "numrow",
		description = "Move focused Window to Workspace",
		group = "Workspace",
		on_press = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end,
	}),
	awful.key({
		modifiers = { super, ctrl, shift },
		keygroup = "numrow",
		description = "Toggle focused Window on Workspace",
		group = "Workspace",
		on_press = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end,
	}),
})


-- Client management keybinds
client.connect_signal(
    "request::default_keybindings", function()
        awful.keyboard.append_client_keybindings {
            awful.key(
                {super, ctrl}, "Up", function(c)
                    c.fullscreen = not c.fullscreen
                    c:raise()
                end, {
                    description = "toggle fullscreen",
                    group = "Client"
                }
            ), awful.key(
                {super, shift}, "a", function(c)
                    c.ontop = not c.ontop
                end, {
                    description = "toggle ontop",
                    group = "Client"
                }
            ), awful.key(
                {super, ctrl}, "a", function(c)
                    c.sticky = not c.sticky
                end, {
                    description = "toggle sticky",
                    group = "Client"
                }
            ), awful.key(
                {super}, "f", awful.client.floating.toggle, {
                    description = "toggle floating",
                    group = "Client"
                }
            ), awful.key(
                {super, ctrl}, "Down", function(c)
                    -- The client currently has the input focus, so it cannot be
                    -- minimized, since minimized clients can"t have the focus.
                    c.minimized = true
                end, {
                    description = "minimize",
                    group = "Client"
                }
            ), awful.key(
                {super}, "m", function(c)
                    c.maximized = not c.maximized
                    c:raise()
                end, {
                    description = "toggle maximize",
                    group = "Client"
                }
            ), awful.key(
                {super}, "x", function(c)
                    c:kill()
                end, {
                    description = "close window",
                    group = "Client"
                }
            ), awful.key(
                {alt}, "F4", function(c)
                    c:kill()
                end, {
                    description = "close window",
                    group = "Client"
                }
            ), -- Single tap: Center client. Double tap: Center client + Floating + Resize
            awful.key(
                {super}, "c", function(c)
                    awful.placement.centered(
                        c, {
                            honor_workarea = true,
                            honor_padding = true
                        }
                    )
                    helpers.single_double_tap(
                        nil, function()
                            local focused_screen_geometry = awful.screen.focused().geometry
                            helpers.float_and_resize(
                                c, focused_screen_geometry.width * 0.5,
                                    focused_screen_geometry.height * 0.5
                            )
                        end
                    )
                end, {
                    description = "center client",
                    group = "Client"
                }
            ), awful.key(
                {super, shift}, "Return", function(c)
                    c:swap(awful.client.getmaster())
                end, {
                    description = "move to master",
                    group = "Client"
                }
            ), awful.key(
                {super, shift}, "]", function(c)
                    move_client_to_screen(c, "right")
                end, {
                    description = "move client to next screen",
                    group = "Client"
                }
            ), awful.key(
                {super, shift}, "[", function(c)
                    move_client_to_screen(c, "left")
                end, {
                    description = "move client to previous screen",
                    group = "Client"
                }
            )
        }
    end
)


-- Mouse buttons on the client
client.connect_signal(
    "request::default_mousebindings", function()
        awful.mouse.append_client_mousebindings {
            awful.button(
                {}, 1, function(c)
                    c:activate{
                        context = "mouse_click"
                    }
                end
            ), awful.button(
                {super}, 1, function(c)
                    c:activate{
                        context = "mouse_click",
                        action = "mouse_move"
                    }
                end
            ), awful.button(
                {super}, 3, function(c)
                    c:activate{
                        context = "mouse_click",
                        action = "mouse_resize"
                    }
                end
            )
        }
    end
)


-- Mouse bindings on desktop
awful.mouse.append_global_mousebindings({
	-- Left click
	awful.button({}, 1, function()
		naughty.destroy_all_notifications()
		menu.main:hide()
	end), 
	-- Right click
	awful.button({}, 3, function()
		menu.main:toggle()
	end), -- Scroll wheel
	awful.button({ super }, 4, awful.tag.viewprev),
	awful.button({ super }, 5, awful.tag.viewnext),
})





-- TODO: implement this    
--[[	awful.key({ super }, "t", function(c)
		awful.titlebar.toggle(c, "top")
	end, {
		description = "Toggle Titlebar",
		group = "Client",
	}),
	awful.key({ super, shift }, "t", function(c)
		local clients = awful.screen.focused().clients
		for _, c in pairs(clients) do
			awful.titlebar.toggle(c, "top")
		end
	end, {
		description = "Toggle all Titlebars in Workspace",
		group = "Client",
	}),[[]]