#!/bin/sh
sink=`xbacklight -get` 
sink=${sink%.*}
xbacklight -inc 10
notify-send "Brightness: $sink%" -t 1000


