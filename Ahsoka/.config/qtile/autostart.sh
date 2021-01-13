#!/bin/bash

autorandr --change

sleep 2

nitrogen --restore &

picom &

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
