(defcommand rotate-screen (orientation)
  ((:string "Orientation: "))
  (cond
    ((equal orientation "n")
     (run-shell-command "xrandr --output eDP1 --rotate normal")
     (run-shell-command "CTM=\"1 0 0 0 1 0 0 0 1\"; xinput set-prop 14 \"Coordinate Transformation Matrix\" $CTM")
     (run-shell-command "CTM=\"1 0 0 0 1 0 0 0 1\"; xinput set-prop 24 \"Coordinate Transformation Matrix\" $CTM"))

    ((equal orientation "i")
     (run-shell-command "xrandr --output eDP1 --rotate inverted")
     (run-shell-command "CTM=\"-1 0 1 0 -1 1 0 0 1\"; xinput set-prop 14 \"Coordinate Transformation Matrix\" $CTM")
     (run-shell-command "CTM=\"-1 0 1 0 -1 1 0 0 1\"; xinput set-prop 24 \"Coordinate Transformation Matrix\" $CTM"))

    ((equal orientation "l")
     (run-shell-command "xrandr --output eDP1 --rotate left")
     (run-shell-command "CTM=\"0 -1 1 1 0 0 0 0 1\"; xinput set-prop 14 \"Coordinate Transformation Matrix\" $CTM")
     (run-shell-command "CTM=\"0 -1 1 1 0 0 0 0 1\"; xinput set-prop 24 \"Coordinate Transformation Matrix\" $CTM"))

    ((equal orientation "r")
     (run-shell-command "xrandr --output eDP1 --rotate right")
     (run-shell-command "CTM=\"0 1 0 -1 0 1 0 0 1\"; xinput set-prop 14 \"Coordinate Transformation Matrix\" $CTM")
     (run-shell-command "CTM=\"0 1 0 -1 0 1 0 0 1\"; xinput set-prop 24 \"Coordinate Transformation Matrix\" $CTM"))))

(defcommand firefox () ()
  "Run or raise Firefox."
  (sb-thread:make-thread (lambda () (run-or-raise "firefox-bin" '(:class "Firefox") t nil))))
