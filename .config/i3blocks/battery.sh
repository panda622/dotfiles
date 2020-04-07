#!/bin/bash
bat0=$(acpi -V | awk '/^Battery\s*0/ {print $4}' | head -n 1)
bat1=$(acpi -V | awk '/^Battery\s*1/ {print $4}' | head -n 1) 

bat0=${bat0%\%*}
bat1=${bat0%\%*}
total=$(((bat0+bat1)/2))

# Full and short texts
echo "$total%"
echo "$total%"


# Set urgent flag below 5% or use orange below 20%
[ ${total} -le 5 ] && exit 33
[ ${total} -le 20 ] && echo "#FF8000"

exit 0
