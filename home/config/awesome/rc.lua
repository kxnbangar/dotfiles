----------------------------------------
--    /\     |      ||  |\    /||
--   / \\    |  /\\ ||  | \  //||
--  /   \\   | /  \\||  |  \// ||
-- /     \\  |/    \||  |      ||
----------------------------------------
-- Author  : Arsh Bangar
-- Created : May 02, 2024
-- Modified: May 02, 2024
----------------------------------------

pcall(require, "luarocks.loader")

-----------------------
-- Importing modules --
-----------------------
local gears         = require("gears")
local awful         = require("awful")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")

require("awful.autofocus")
require("awful.hotkeys_popup.keys")

-- Importing local modules 
local vars = require("variables")

--require("keybindings") -- File already being imported by
                         -- another import namely "client-rules"
                         -- Please fix this duplication

--------------------
-- Error handling --
--------------------
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end


----------------------------
-- Loading the theme file --
----------------------------
beautiful.init(vars.style_dir)

----------------------
-- Layouts in order --
----------------------
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.max,
}


local function set_wallpaper(s)
   -- Wallpaper
   if beautiful.wallpaper then
      local wallpaper = beautiful.wallpaper
      -- If wallpaper is a function, call it with the screen
      if type(wallpaper) == "function" then
	 wallpaper = wallpaper(s)
      end
      gears.wallpaper.maximized(wallpaper, s, true)
   end
end


----------
-- Bars --
----------
bars = require("bars")
awful.screen.connect_for_each_screen(function(scr)
      set_wallpaper(scr)
      awful.tag({ " ", " ", " ", " ", "?" }, s, awful.layout.layouts[1])
      scr.status_bar = bars.create_status_bar(scr)
end)

--------------------------
-- Setting client rules --
--------------------------
require("client-rules")

-------------
-- Signals --
-------------
screen.connect_signal("property::geometry", set_wallpaper)

client.connect_signal("manage", function (c)
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
    c.shape = function(cr,w,h) gears.shape.rounded_rect(cr,w,h,beautiful.roundness) end
end)

-- Importing the titlebar signal
require("titlebar")

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
