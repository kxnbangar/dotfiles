local gears         = require("gears")
local awful         = require("awful")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local menubar       = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

vars = {}

-- Some default variable declarations ===================

vars.terminal = "alacritty -e fish"
vars.editor = os.getenv("EDITOR") or "vim"
vars.editor_cmd = "alacritty -e " .. vars.editor
vars.modkey = "Mod4"

vars.style_dir = "~/.config/awesome/style/theme.lua"

menubar.utils.terminal = vars.terminal
vars.rofi_appsmenu  = "rofi -show drun -show-icons -theme launcher/style.rasi -icon-theme Papirus-Light"
vars.rofi_powermenu = "~/.config/rofi/powermenu/powermenu.sh"

return vars
