local gears         = require("gears")
local awful         = require("awful")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local menubar       = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

bars = {}

local function rectangle(cr, width, height, tl, tr, br, bl, rad)
   tl = tl or false
   tr = tr or false
   br = br or false
   bl = bl or false
   rad   = beautiful.roundness
   shape = gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, rad)
   return shape
end

local function powermenu ()
   awful.spawn.with_shell("~/.config/rofi/powermenu/powermenu.sh")
end

local tags_list_buttons = gears.table.join(
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

date_time = wibox.widget.textclock()

local bar_battery =  wibox.widget {
   max_value     = 100,
   value         = 0,
   shape = function (cr, w, h)
      rectangle(cr, w, h, true, true, true, true)
   end,
   color            = beautiful.mocha_green,
   background_color = beautiful.mocha_red,
   widget = wibox.widget.progressbar
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

battery_widget = wibox.widget {
   {
      bar_battery,
      { text = "Battery",
	align = "center",
	widget = wibox.widget.textbox },
      layout = wibox.layout.stack
   },
   forced_width = 100,
   layout = wibox.layout.fixed.horizontal
}

local tasklist_buttons = gears.table.join(
   awful.button({ }, 1, function (c)
	 if c == client.focus then
	    c.minimized = true
	 else
	    c:emit_signal(
	       "request::activate",
	       "tasklist",
	       { raise = true })
	 end
   end),
   awful.button({ }, 3, function()
	 awful.menu.client_list({ theme = { width = 250 } }) end),
   awful.button({ }, 4, function() awful.client.focus.byidx(1) end),
   awful.button({ }, 5, function() awful.client.focus.byidx(-1) end))

kbd_layouts_box = awful.widget.keyboardlayout()

local pb = wibox.widget {
   image  = beautiful.power_btn,
   widget = wibox.widget.imagebox
}

pb:buttons(gears.table.join(
	      pb:buttons(),
	      awful.button({}, 1, nil, powermenu)
))

local system_tray = wibox.widget.systray()

local powerbutton = {
   { pb,
     layout = wibox.layout.flex.horizontal },
   shape = gears.shape.rounded_rect,
   widget = wibox.container.background
}

function bars.create_status_bar(scr)

   scr.tags_list = awful.widget.taglist {
      screen  = scr,
      filter  = awful.widget.taglist.filter.all,
      buttons = tags_list_buttons
   }
   
   scr.tags_bar = awful.wibar({
	 position = "top",
	 screen = scr,
	 bg = beautiful.status_bar_bg_color,
	 --height = beautiful.status_bar_height,
   })

   scr.archaic_prompt = awful.widget.prompt()

   scr.opened_windows = awful.widget.tasklist {
      screen  = scr,
      filter  = awful.widget.tasklist.filter.currenttags,
      buttons = tasklist_buttons,
      layout   = {
	 --spacing = beautiful.status_bar_spacing,
	 layout  = wibox.layout.fixed.horizontal
      },
      widget_template = {
	 {
	    {
	       { id     = 'clienticon',
		 widget = awful.widget.clienticon },
	       margins = 3,
	       widget  = wibox.container.margin },
	    id = 'background_role',
	    widget = wibox.container.background },
	 create_callback = function(self, c, index, objects) --luacheck: no unused args
	    self:get_children_by_id('clienticon')[1].client = c
	 end,
	 margins = beautiful.status_bar_spacing,
	 widget = wibox.container.margin }
   }
   
   scr.layouts_box = awful.widget.layoutbox(scr)
   scr.layouts_box:buttons(
      gears.table.join(
	 awful.button({ }, 1, function () awful.layout.inc( 1) end),
	 awful.button({ }, 3, function () awful.layout.inc(-1) end),
	 awful.button({ }, 4, function () awful.layout.inc( 1) end),
	 awful.button({ }, 5, function () awful.layout.inc(-1) end)))

   left_bar = wibox.widget {
      { scr.tags_list,
	scr.archaic_prompt,
	layout = wibox.layout.fixed.horizontal },
      shape  = function(cr, w, h, tl, tr, br, bl)
	 rectangle(cr, w, h, false, false, true, false)
      end,
      bg     = beautiful.bg_normal,
      widget = wibox.container.background
   }

   middle_bar = wibox.widget {
      date_time,
      shape  = function(cr, w, h, tl, tr, br, bl)
	 rectangle(cr, w, h, false, false, true, true)
      end,
      bg     = beautiful.bg_normal,
      widget = wibox.container.background
   }

   right_bar = wibox.widget {
      { battery_widget,
	scr.opened_windows,
	kbd_layouts_box,
	scr.layouts_box,
	system_tray,
	powerbutton,
	layout = wibox.layout.fixed.horizontal
      },
      shape  = function(cr, w, h, tl, tr, br, bl)
	 rectangle(cr, w, h, false, false, false, true)
      end,
      bg     = beautiful.bg_normal,
      widget = wibox.container.background
   }
   
   scr.tags_bar:setup {
      left_bar,
      middle_bar,
      right_bar,
      expand = "none",
      layout = wibox.layout.align.horizontal
   }
   return scr.tags_bar
   
end

return bars
