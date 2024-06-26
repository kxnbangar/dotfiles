local awful         = require("awful")
local beautiful     = require("beautiful")
local gears         = require("gears")
local wibox         = require("wibox")
local naughty       = require("naughty")
local menubar       = require("menubar")

kbd = require("keybindings")

clientkeys = kbd.clientkeys
clientbuttons = kbd.clientbuttons

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {

   -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    { rule = { class = "Firefox" },
      properties = { screen = 1, tag = "2" } },

    { rule = { name = "py-gtk-widgets" },
      properties = { placement = awful.placement.right, ontop = true, 
      titlebars_enabled = false, border_width = 0, sticky = true } },

    { rule = { class = "Alacritty" },
      properties = { width = 1920*0.8, height = 1080*0.8,
      		     x     = 192,      y      = 108+32 } },
    { rule = { name = "powermenu" },
      properties = { titlebars_enabled = false } },
    { rule = { name = "KXN Dock" },
      properties = { titlebars_enabled = false, floating = true, is_fixed = true,
		     skip_taskbar = true, ontop = false, sticky = true,
		     border_width = beautiful.dock_border_width, focusable = false} },
}
