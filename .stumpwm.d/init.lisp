;; Title: KXN Stumpwm Configuration
;; Author: Arsh Bangar

(in-package :stumpwm)
(setf *default-package* :stumpwm)

(load "~/.stumpwm.d/init/commands.lisp")
(load "~/.stumpwm.d/init/variables.lisp")
(load "~/.stumpwm.d/init/keybindings.lisp")

(run-shell-command "xsetroot -cursor_name left_ptr")
(run-shell-command "xset s 300 300")
(run-shell-command "conky &")
(run-shell-command "picom --experimental-backends &")
(run-shell-command "~/.fehbg")

(when *initializing*
  (grename "Main")
  (gnew    "Home")
  (gnewbg  "Sci")
  (gnewbg  "X")
  (gnewbg  "Dump")
  (mode-line))

(load-module "ttf-fonts")
(load-module "battery-portable")
(load-module "wifi")
(load-module "swm-gaps")

(set-font (make-instance 'xft:font :family "Liberation Serif" :subfamily "Regular" :size 11))
(setf wifi:*wifi-modeline-fmt* "%e")
(setf swm-gaps:*outer-gaps-size* 8)
(setf swm-gaps:*inner-gaps-size* 8)
(swm-gaps:toggle-gaps)
