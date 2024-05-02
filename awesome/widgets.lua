local gears         = require("gears")
local awful         = require("awful")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local menubar       = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

widgets = {}

-- Some menus
widgets.myawesomemenu = {
   { "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "Manual", vars.terminal .. " -e man awesome" },
   { "Edit config", vars.editor_cmd .. " " .. awesome.conffile },
   { "Restart", awesome.restart },
   { "Quit", function() awesome.quit() end },
}

widgets.mymainmenu = awful.menu(
   { items = {
	{ "Awesome",
	  myawesomemenu,
	  beautiful.awesome_icon
	},
	{ "Terminal", vars.terminal }
   }
})

return widgets
