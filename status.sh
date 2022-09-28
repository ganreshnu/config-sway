#!/bin/bash

dateformatted=$(date +'%a %D %I:%M %p')

chargefull=$(cat /sys/class/power_supply/BAT0/charge_full)
chargenow=$(cat /sys/class/power_supply/BAT0/charge_now)
percent=$(awk "BEGIN { print ($chargenow / $chargefull) * 100 }")
#percent=$(( $((chargenow/chargefull)) * 100 ))
echo $(cut -d. -f1 <<<$percent)% \| $dateformatted
