#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# ===================== Bangar ============================
# Set environment variables for xorg session here
export EDITOR="emacsclient -nc"
export MOZ_USE_XINPUT2=1
# =========================================================
# Some startup commands to configure the system
xinput set-prop 'ELAN0722:00 04F3:3139 Touchpad' 'libinput Tapping Enabled'           1 &
xinput set-prop 'ELAN0722:00 04F3:3139 Touchpad' 'libinput Natural Scrolling Enabled' 1 &
# =========================================================
# Some startup applications
pipewire &
picom &
emacs --daemon &
# =========================================================
exec dbus-run-session awesome
