#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

# Auto-detect monitor setup
autorandr -c &

sleep 2

# Set wallpaper with nitrogen
nitrogen --restore &

# Polybar
run $HOME/.config/polybar/launch.sh & 

# Cursor active at boot
xsetroot -cursor_name left_ptr &

# Numlock on
numlockx on &

# Picom
picom --config $HOME/.config/picom/picom.conf &

# Policy manager
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# Notifications (notifyd)
/usr/lib/xfce4/notifyd/xfce4-notifyd &
