#!/bin/sh
sink=`xbacklight -get` 
sink=${sink%.*}
xbacklight -dec 10
notify-send "Brightness: $sink%" -t 1000

