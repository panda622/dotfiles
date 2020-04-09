#!/bin/sh
notify-send "Volume Mute Toggle" -t 1000
/usr/bin/pactl set-sink-mute 0 toggle && pkill -RTMIN+10 i3blocks

