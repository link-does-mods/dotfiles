#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

# Auto-detect monitor setup
autorandr -c &

# Cursor active at boot
xsetroot -cursor_name left_ptr &

# Polybar
(sleep 2; run $HOME/.config/polybar/launch.sh)& 

# Set wallpaper with nitrogen
nitrogen --restore &

# Numlock on
numlockx on &

# Tray icons
run nm-applet &            # Network manager
blueberry-tray &           # Bluetooth
run xfce4-power-manager &  # Power manager

# Picom
picom --config $HOME/.config/picom/picom.conf &

# Policy manager
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# Notifications (notifyd)
/usr/lib/xfce4/notifyd/xfce4-notifyd &
