local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local bling = require("module.bling") -- https://github.com/BlingCorp/bling
local rubato = require("module.rubato") -- https://github.com/andOrlando/rubato

local transition_duration = 0.3
--local dot_size = 10
local dot_size = 20
local number_of_tags = 10

local super = "Mod4"

taglist_buttons = awful.util.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ super }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({ super }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewprev(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewnext(t.screen)
	end)
)

local function create_resize_transition()
	return rubato.timed({
		pos = dpi(dot_size),
		intro = 0,
		duration = transition_duration,
		easing = rubato.linear,
	})
end

local taglist_item_transitions = {}
for i = 1, number_of_tags do
	taglist_item_transitions[i] = create_resize_transition()
end

local floating_indicator_transition = rubato.timed({
	pos = 0,
	intro = 0,
	duration = transition_duration,
	easing = rubato.linear,
})

local indicator_widget = wibox.widget({
	{
		forced_height = dpi(dot_size),
		forced_width = dpi(dot_size * 2),
		shape = gears.shape.rounded_bar,
		bg = beautiful.taglist_bg_focus,
		widget = wibox.container.background,
	},
	left = 0,
	widget = wibox.container.margin,
})

local TagList = function(s)
	-- Helper function that updates a taglist item
	local update_taglist = function(item, tag, index)
		if tag.selected then
			taglist_item_transitions[index].target = dpi(dot_size * 2 + #tag:clients() * 25)
			floating_indicator_transition.target = (beautiful.taglist_spacing + dot_size) * (index - 1)
		else
			taglist_item_transitions[index].target = dpi(dot_size)
		end
	end

	--    local update_taglist = function(item, tag, index)
	--        if tag.selected then
	--            taglist_item_transitions[index].target = dpi(dot_size * 2 + #tag:clients()*25)
	--            -- TODO: set taglist_spacing in theme
	--            floating_indicator_transition.target = (beautiful.taglist_spacing + dot_size) * (index - 1)
	--        elseif #tag:clients() > 0 then
	--            taglist_item_transitions[index].target = dpi(dot_size + #tag:clients()*10)
	--        else
	--            taglist_item_transitions[index].target = dpi(dot_size)
	--        end
	--    end

	local create_taglist = function(item, tag, index)
		-- bling: Only show widget when there are clients in the tag
		item:connect_signal("mouse::enter", function()
			if #tag:clients() > 0 then
				awesome.emit_signal("bling::tag_preview::update", tag)
				awesome.emit_signal("bling::tag_preview::visibility", s, true)
			end
		end)

		item:connect_signal("mouse::leave", function()
			-- bling: Turn the widget off
			awesome.emit_signal("bling::tag_preview::visibility", s, false)

			if item.has_backup then
				item.bg = item.backup
			end
		end)

		taglist_item_transitions[index]:subscribe(function(value)
			item.forced_width = value
		end)
		floating_indicator_transition:subscribe(function(value)
			indicator_widget.left = value
		end)

		--item:get_children_by_id("tasklist_placeholder")[1]:add(tasklist(tag))
		update_taglist(item, tag, index)
	end

	local tl = awful.widget.taglist({
		screen = s,
		filter = function(t)
			return t.index ~= 10 or t.selected
		end, -- show last tag only when viewing it
		buttons = taglist_buttons,
		layout = wibox.layout.fixed.horizontal,
		--widget_template = {
		--  {
		--    left = dpi(1),
		--    widget = wibox.container.margin
		--  },
		--  id = 'background_role',
		--  forced_width = dot_size,
		--  widget = wibox.container.background,
		--  create_callback = create_taglist,
		--  update_callback = update_taglist,
		--}

		widget_template = {
			{
				{
					id = "tasklist_placeholder",
					layout = wibox.layout.fixed.horizontal,
					widget = wibox.container.margin,
				},
				left = dpi(1),
				widget = wibox.container.margin,
			},
			id = "background_role",
			forced_width = dot_size,
			widget = wibox.container.background,
			create_callback = create_taglist,
			update_callback = update_taglist,
		},
	})

	return wibox.widget({
		{
			tl,
			{
				indicator_widget,
				widget = wibox.layout.fixed.horizontal,
			},
			layout = wibox.layout.stack,
		},
		top = dpi(6),
		bottom = dpi(6),
		--top = dpi(12),
		--bottom = dpi(12),
		widget = wibox.container.margin,
	})
end

-- Tag preview
bling.widget.tag_preview.enable({
	show_client_content = true,
	placement_fn = function(c)
		awful.placement.top_left(c, {
			margins = {
				--top = beautiful.top_bar_height + dpi(10),
				top = dpi(50), -- TODO: don't hard code this
				left = dpi(10),
			},
		})
	end,
	scale = 0.16,
	honor_padding = true,
	honor_workarea = true,
	background_widget = wibox.widget({
		widget = wibox.container.background,
		-- TODO: set wallpaper in theme.lua
		bg = beautiful.wallpaper,
	}),
})

return TagList
