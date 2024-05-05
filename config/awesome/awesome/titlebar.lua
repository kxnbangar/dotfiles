local gears         = require("gears")
local awful         = require("awful")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local menubar       = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    c.sidebar = awful.titlebar(c,
	{
	   size      = beautiful.sidebar_sz,
	   position  = "left",
	   bg_normal = "#ffffff00",
	   bg_focus  = "#ffffff00",
	}
    )

    c.sidebar : setup {
       {
	  {
	     {
		awful.titlebar.widget.iconwidget(c),
		top = beautiful.sidebar_mg,
		left = beautiful.sidebar_mg,
		right = beautiful.sidebar_mg,
		bottom = beautiful.sidebar_mg * 2,
		widget = wibox.container.margin
	     },
	     buttons = buttons,
	     layout  = wibox.layout.fixed.horizontal
	  },
	  {
	     {
		awful.titlebar.widget.closebutton   (c),
		layout = wibox.layout.fixed.vertical()
	     },
	     margins = beautiful.sidebar_mg,
	     widget = wibox.container.margin
	  },
	  {  -- Drag area
	     buttons = buttons,
	     layout  = wibox.layout.flex.horizontal
	  },
	  fill_space = true,
	  layout = wibox.layout.fixed.vertical
       },
       id = "sidebar_background",
       bg = beautiful.bg_focus,
       --[[
       shape = function (cr, width, height, tl, tr, br, bl, rad)
	  gears.shape.partially_rounded_rect(cr,width,height,true,false,false,true,beautiful.roundness)
       end,
       ]]--
       widget = wibox.widget.background
		      }

    client.connect_signal("focus", function(c)
			     --c.sidebar:get_children_by_id("sidebar_background")[1]:set_bg(beautiful.bg_focus)
    end)
    
    client.connect_signal("unfocus", function(c)
			     --c.sidebar:get_children_by_id("sidebar_background")[1]:set_bg(beautiful.bg_normal)
    end)
    
end)
