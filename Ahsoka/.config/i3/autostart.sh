#!/bin/bash

autorandr --change &
sleep 2
nitrogen --restore &
sleep 1
sh ~/.config/polybar/launch.sh &
picom &
