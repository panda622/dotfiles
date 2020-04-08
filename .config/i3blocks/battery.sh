#!/bin/bash
# bat0=$(acpi -V | awk '/^Battery\s*0/ {print $4}' | head -n 1)
# bat1=$(acpi -V | awk '/^Battery\s*1/ {print $4}' | head -n 1) 

# bat0=${bat0%\%*}
# bat1=${bat0%\%*}
# total=$(((bat0+bat1)/2))

# # Full and short texts
# if $(acpi | grep -iq 'discharging'); then
# 	echo "$total% Discharging"
# 	echo "$total% Discharging"
# else
# 	echo "$total%"
# 	echo "$total%"
# fi


# # Set urgent flag below 5% or use orange below 20%
# [ ${total} -le 5 ] && exit 33
# [ ${total} -le 20 ] && echo "#FF8000"

# exit 0


#!/bin/sh

# Prints all batteries, their percentage remaining and an emoji corresponding
# to charge status (🔌 for plugged up, 🔋 for discharging on battery, etc.).

case $BLOCK_BUTTON in
    3) pgrep -x dunst >/dev/null && notify-send "🔋 Battery module" "🔋: discharging
🛑: not charging
♻: stagnant charge
🔌: charging
⚡: charged
❗: battery very low!" ;;
esac

# Loop through all attached batteries.
for battery in /sys/class/power_supply/BAT?
do
	# Get its remaining capacity and charge status.
	capacity=$(cat "$battery"/capacity) || break
	status=$(sed "s/Discharging/🔋/;s/Not charging/🛑/;s/Charging/🔌/;s/Unknown/♻️/;s/Full/⚡/" "$battery"/status)

	# If it is discharging and 25% or less, we will add a ❗ as a warning.
	 [ "$capacity" -le 25 ] && [ "$status" = "🔋" ] && warn="❗"

	printf "%s%s%s%%\n" "$status" "$warn" "$capacity"
	unset warn
done
