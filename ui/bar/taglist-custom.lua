-- TODO: make sure this works on vertical monitors
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local helpers = require("helpers")
local border_container = require("ui.widgets.border-container")


local animation = require("ui.bar.tmp.animation")

local super = "Mod4"

local client_filter = function(t)
    return function(c)
        for _, v in ipairs(c:tags()) do
            if v == t then
                return true
            end
        end
        return false
    end
end

local tasklist = function(t)
    local s = awful.screen.focused()
    return awful.widget.tasklist {
        screen = s,
        filter = client_filter(t),
        buttons = {
            awful.button(
                {}, 1, function(c)
                    if c == client.focus then
                        c.minimized = true
                    else
                        c.minimized = false
                        c:emit_signal('request::activate')
                        c:raise()
                    end
                end
            ), awful.button(
                {}, 2, function(c)
                    c:kill()
                end
            )
        },
        layout = {
            spacing_widget = nil,
            spacing = 8,
            layout = wibox.layout.fixed.horizontal
        },
        widget_template = {
            nil,
            {
                {
                    id = "clienticon",
                    forced_width = dpi(22),
                    widget = awful.widget.clienticon
                },
                widget = wibox.container.place
            },
            {
                id = "background_role",
                forced_height = dpi(2),
                widget = wibox.container.background
            },
            layout = wibox.layout.align.vertical,
            create_callback = function(self, c, index, objects)
                -- BLING: Toggle the popup on hover and disable it off hover
                self:connect_signal(
                    'mouse::enter', function()
                        awesome.emit_signal("bling::task_preview::visibility", s, true, c)
                        awesome.emit_signal("bling::tag_preview::visibility", s, false)
                    end
                )
                self:connect_signal(
                    'mouse::leave', function()
                        awesome.emit_signal("bling::task_preview::visibility", s, false, c)
                    end
                )
            end
        }
    }
end

local taglist_buttons = {
    awful.button(
        {}, 1, function(t)
            t:view_only()
        end
    ), awful.button(
        {super}, 1, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end
    ), awful.button(
        {}, 3, function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end
    ), awful.button(
        {super}, 3, function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end
    ), awful.button(
        {}, 4, function(t)
            awful.tag.viewnext(t.screen)
        end
    ), awful.button(
        {}, 5, function(t)
            awful.tag.viewprev(t.screen)
        end
    )
}

local grid_layout = wibox.layout {
    forced_num_cols = 2,
    forced_num_rows = 1,
    orientation = "vertical",
    expand = true,
    homogeneous = false,
    layout = wibox.layout.grid
}

local function adjust_grid_layout(s)
    local screen = s or awful.screen.focused()
    local is_horizontal = screen.geometry.height < screen.geometry.width
    if is_horizontal then
        return
    end

    local num_tags = 0
    for _, t in ipairs(screen.tags) do
        if t.selected or #t:clients() > 0 then
            num_tags = num_tags + 1
        end
    end

    if num_tags >= 4 then
        grid_layout.forced_num_cols = 4
        grid_layout.forced_num_rows = 2
    else
        grid_layout.forced_num_cols = math.max(num_tags, 1)
        grid_layout.forced_num_rows = 1
    end
end

local function create_taglist_callback(self, t, index, _)
    self:get_children_by_id("background_role")[1].forced_width = dpi(40)
    --self:get_children_by_id("background_role")[1].forced_height = dpi(40)
    if t.selected then
        self:get_children_by_id("background_role")[1].forced_width = dpi(40+#t:clients()*20)
    elseif #t:clients() > 0 then
        self:get_children_by_id("background_role")[1].forced_width = dpi(20+#t:clients()*10)
    else
        self:get_children_by_id("background_role")[1].forced_width = dpi(20)
    end

    self:get_children_by_id("tasklist_placeholder")[1]:add(tasklist(t))
    self:get_children_by_id("tasklist_placeholder")[1].visible = false
    if t.selected then
        self:get_children_by_id("index_role")[1].text = t.index
        self:get_children_by_id("tasklist_placeholder")[1].visible = true
    end
    self:connect_signal(
        "mouse::enter", function()
            if #t:clients() > 0 then
                awesome.emit_signal("bling::tag_preview::update", t)
                awesome.emit_signal("bling::tag_preview::visibility", s, true)
            end
        end
    )
    self:connect_signal(
        "mouse::leave", function()
            awesome.emit_signal("bling::tag_preview::visibility", s, false)
        end
    )
    helpers.add_hover_cursor(self)
    adjust_grid_layout(t.screen)
    
end

local function update_taglist_callback(self,t, index, _)
    if t.selected then
        self:get_children_by_id("tasklist_placeholder")[1].visible = true
        self:get_children_by_id("index_role")[1].text = t.index
    else
        self:get_children_by_id("tasklist_placeholder")[1].visible = false
        self:get_children_by_id("index_role")[1].text = ""
    end
    -- TODO: make this look more elegant
    if t.selected then
        self:get_children_by_id("background_role")[1].forced_width = dpi(40+#t:clients()*25)
    elseif #t:clients() > 0 then
        self:get_children_by_id("background_role")[1].forced_width = dpi(20+#t:clients()*10)
    else
        self:get_children_by_id("background_role")[1].forced_width = dpi(20)
    end
end

local taglist_test = function(s)
    local is_horizontal = s.geometry.height < s.geometry.width

    local custom_taglist = awful.widget.taglist {
        screen = s,
        filter = function (t) return t.index ~= 10 or t.selected end,
        layout = is_horizontal and wibox.layout.fixed.horizontal or grid_layout,
        widget_template = {
            {
                { -- Tag
					markup = "",
					shape = helpers.rrect(3),
					widget = wibox.widget.textbox,
				},
				valign = "center",
				id = "background_role",
				shape = helpers.rrect(1),
				widget = wibox.container.background,
				forced_width = 40,
				forced_height = 14,
            },
            widget = wibox.container.place,
			create_callback = function(self, tag)
				self.taganim = animation:new({
					duration = 0.25,
					easing = animation.easing.linear,
					update = function(_, pos)
						self:get_children_by_id("background_role")[1].forced_width = pos
					end,
				})
				self.update = function()
					if tag.selected then
						self.taganim:set(60)
					elseif #tag:clients() > 0 then
						self.taganim:set(40)
					else
						self.taganim:set(20)
					end
				end

				self.update()
			end,
			update_callback = function(self)
				self.update()
			end,
        },
        buttons = taglist_buttons
    }

    -- Update column and row number if vertical screen
    if not is_horizontal then
        tag.connect_signal(
            "property::selected", function()
                adjust_grid_layout()
            end
        )
    end

    return border_container {
        widget = custom_taglist
    }
end

local taglist = function(s)
    local is_horizontal = s.geometry.height < s.geometry.width

    local custom_taglist = awful.widget.taglist {
        screen = s,
        filter = function (t) return t.index ~= 10 or t.selected end, -- show last tag only when viewing it
        layout = is_horizontal and wibox.layout.fixed.horizontal or grid_layout,
        widget_template = {
            {
                {
                    -- tag
                    {

                        id = "index_role",
                        font = beautiful.font_name .. " Bold 14",
                        widget = wibox.widget.textbox

                    },
                    -- tasklist
                    {
                        id = "tasklist_placeholder",
                        layout = wibox.layout.fixed.horizontal,
                        widget = wibox.container.margin
                    },
                    spacing = dpi(4),
                    layout = wibox.layout.fixed.horizontal
                },
                left = dpi(8),
                right = dpi(8),
                widget = wibox.container.margin
            },
            id = "background_role",
            widget = wibox.container.background,

            create_callback = create_taglist_callback,
            update_callback = update_taglist_callback
        },
        buttons = taglist_buttons
    }

    -- Update column and row number if vertical screen
    if not is_horizontal then
        tag.connect_signal(
            "property::selected", function()
                adjust_grid_layout()
            end
        )
    end

    return border_container {
        widget = custom_taglist
    }
end



return taglist
