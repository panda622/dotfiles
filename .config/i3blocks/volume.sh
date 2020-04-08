#!/bin/sh

pkill -RTMIN+10 i3blocks
case $BLOCK_BUTTON in
	1) setsid "$TERMINAL" -e alsamixer & ;;
	2) amixer sset Master toggle ;;
	4) amixer sset Master 5%+ >/dev/null 2>/dev/null ;;
	5) amixer sset Master 5%- >/dev/null 2>/dev/null ;;
	3) pgrep -x dunst >/dev/null && notify-send "📢 Volume module" "\- Shows volume 🔊, 🔇 if muted.
- Middle click to mute.
- Scroll to change."
esac

volstat="$(amixer get Master)"

echo "$volstat" | grep "\[off\]" >/dev/null && printf "🔇\\n" && exit

vol=$(echo "$volstat" | grep -o "\[[0-9]\+%\]" | sed "s/[^0-9]*//g;1q")

if [ "$vol" -gt "70" ]; then
	icon="🔊"
elif [ "$vol" -lt "30" ]; then
	icon="🔈"
else
	icon="🔉"
fi

printf "%s %s%%\\n" "$icon" "$vol"
