local gears         = require("gears")
local awful         = require("awful")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local menubar       = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

status_bar = {}

mykeyboardlayout = awful.widget.keyboardlayout()
mytextclock = wibox.widget.textclock()

local function powermenu ()
   awful.spawn.with_shell("~/.config/rofi/powermenu/powermenu.sh")
end

local pb = wibox.widget {
   image  = beautiful.power_btn,
   widget = wibox.widget.imagebox
}

pb:buttons(gears.table.join(
	      pb:buttons(),
	      awful.button({}, 1, nil, powermenu)
))

local powerbutton = {
   {	 
      pb,
      layout = wibox.layout.flex.horizontal
   },
   shape = gears.shape.rounded_rect,
   widget = wibox.container.background
}

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
   awful.button({ }, 1, function(t) t:view_only() end),
   awful.button({ modkey }, 1, function(t)
	 if client.focus then
	    client.focus:move_to_tag(t)
	 end
   end),
   awful.button({ }, 3, awful.tag.viewtoggle),
   awful.button({ modkey }, 3, function(t)
	 if client.focus then
	    client.focus:toggle_tag(t)
	 end
   end),
   awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
   awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
   awful.button({ }, 1, function (c)
	 if c == client.focus then
	    c.minimized = true
	 else
	    c:emit_signal(
	       "request::activate",
	       "tasklist",
	       { raise = true }
	    )
	 end
   end),
   awful.button({ }, 3, function()
	 awful.menu.client_list({ theme = { width = 250 } })
   end),
   awful.button({ }, 4, function ()
	 awful.client.focus.byidx(1)
   end),
   awful.button({ }, 5, function ()
	 awful.client.focus.byidx(-1)
end))

--====================================================================

function status_bar.create_status_bar(s)

   -- Each screen has its own tag table.
   awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])

   -- Create a promptbox for each screen
   s.mypromptbox = awful.widget.prompt()
   -- Create an imagebox widget which will contain an icon indicating which layout we're using.
   -- We need one layoutbox per screen.
   s.mylayoutbox = awful.widget.layoutbox(s)
   s.mylayoutbox:buttons(
      gears.table.join(
	 awful.button({ }, 1, function () awful.layout.inc( 1) end),
	 awful.button({ }, 3, function () awful.layout.inc(-1) end),
	 awful.button({ }, 4, function () awful.layout.inc( 1) end),
	 awful.button({ }, 5, function () awful.layout.inc(-1) end)
      )
   )
   -- Create a taglist widget
   s.mytaglist = awful.widget.taglist {
      screen  = s,
      filter  = awful.widget.taglist.filter.all,
      buttons = taglist_buttons
   }

   local bar_battery =  wibox.widget {
      max_value     = 100,
      value         = 0,
      forced_width  = 600,
      shape = function (cr, width, height, rad)
	 gears.shape.rounded_rect(cr,width,height,beautiful.roundness)
      end,
      color         = beautiful.mocha_green,
      background_color = beautiful.mocha_red,
      widget = wibox.widget.progressbar
   }

   battery_widget = wibox.widget {
      {
	 bar_battery,
	 widget = wibox.container.place
      },
      layout = wibox.layout.flex.horizontal
   }

   s.current_task = awful.widget.tasklist {
      screen  = s,
      filter  = awful.widget.tasklist.filter.focused,
      layout = {
	 layout = wibox.layout.flex.horizontal
      },
      widget_template = {
	 {
	    {
	       id     = 'text_role',
	       align = "center",
	       forced_width = 500,
	       widget = wibox.widget.textbox,
	    },
	    widget = wibox.container.place
	 },
	 layout = wibox.layout.flex.horizontal
      }
   }

   gears.timer {
      timeout   = 60,
      call_now  = true,
      autostart = true,
      callback  = function()
	 awful.spawn.easy_async_with_shell(
	    "acpi | head -n1 | gawk \'{print $4}\'", function (out)
	       out = out:gsub("%%%,", "")
	       bar_battery:set_value(tonumber(out))
	 end)
      end
   }
   
   -- Create a tasklist widget
   s.hidden_tasks = awful.widget.tasklist {
      screen  = s,
      filter  = awful.widget.tasklist.filter.currenttags,
      buttons = tasklist_buttons,
      layout   = {
	 spacing_widget = {
	    {
	       forced_height = 24,
	       thickness     = 3,
	       color         = beautiful.fg_focus,
	       widget        = wibox.widget.separator
	    },
	    valign = 'center',
	    halign = 'center',
	    widget = wibox.container.place,
	 },
	 spacing = 12,
	 layout  = wibox.layout.fixed.horizontal
      },
      widget_template = {
	 {
	    {
	       id     = 'clienticon',
	       widget = awful.widget.clienticon,
	    },
	    margins = 3,
	    widget  = wibox.container.margin
	 },
	 create_callback = function(self, c, index, objects) --luacheck: no unused args
	    self:get_children_by_id('clienticon')[1].client = c
	 end,
	 shape = gears.shape.rounded_rect,
	 bg = beautiful.flamingo,
	 widget = wibox.container.background,
      },
   }

   -- Create the wibox
   s.mywibox = awful.wibar({
	 --height = beautiful.statusb_sz,
	 position = "top",
	 screen = s,
	 bg = "#ffffff00",
			   }
   )

   -- Add widgets to the wibox
   s.mywibox:setup {
      {
	 {
	    {
	       { -- Left widgets
		  layout = wibox.layout.fixed.horizontal,
		  s.mytaglist,
		  s.mypromptbox,
	       },
	       {
		  battery_widget,
		  s.current_task,
		  layout = wibox.layout.stack
	       },
	       { 
		  s.hidden_tasks,
		  mykeyboardlayout,
		  wibox.widget.systray(),
		  mytextclock,
		  s.mylayoutbox,
		  powerbutton,
		  spacing = 12,
		  layout = wibox.layout.fixed.horizontal,
	       },
	       layout = wibox.layout.align.horizontal,
	    },
	    margins = 6,
	    widget = wibox.container.margin
	 },
	 bg = beautiful.bg_normal,
	 shape = function (cr, width, height, rad)
	    gears.shape.rounded_rect(cr,width,height,beautiful.roundness)
	 end,
	 widget = wibox.container.background
      },
      top 	= 0,
      left 	= 0,
      right 	= 0,
      widget = wibox.container.margin
   }

   return s.mywibox
end

return status_bar
