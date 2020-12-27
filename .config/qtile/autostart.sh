#! /bin/bash 
function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

autorandr --change &
nitrogen --restore &