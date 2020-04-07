#!/bin/bash

temp=$(sensors | awk '/^temp1/ {print $2}' | head -n 1)
temp=${temp#+*}
temp=${temp%.*}

echo "$temp°C"
echo "$temp°C"

# Set urgent flag below 5% or use orange below 20%
[ ${temp} -ge 60 ] && echo "#FF8000"
[ ${temp} -ge 70 ] && exit 33

exit 0
