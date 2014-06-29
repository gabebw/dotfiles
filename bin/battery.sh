#!/bin/bash

battery_percentage="$(pmset -g batt | sed -E '/^.*[[:space:]]([0-9]+)%.*/!d; s//\1/g')"
battery_time=$(pmset -g batt | grep Internal | awk '{print $4, $5}' | sed 's/;//')
message="${battery_percentage}% (${battery_time})"

if (( $battery_percentage < 20 ))
then
  # Print in red if we don't have a lot of battery left
  echo "#[fg=red]" "$message" "#[fg=default]"
else
  # Print in a crisp black that shows up against the status bar
  echo "#[fg=colour235]" "$message" "#[fg=default]"
fi
