#!/bin/bash

# dont forget to: chmod +x ~/.config/waybar/powermenu.bash


entries=" Lock\n󰒲 Sleep\n󰍃 Logout\n⏻ Shutdown"

selected=$(echo -e $entries | tofi)

case $selected in
  " Lock")
    hyprlock
    ;;
  "󰒲 Sleep")
    systemctl suspend
    ;;
  "󰍃 Logout")
    hyprctl dispatch exit
    ;;
  "⏻ Shutdown")
    systemctl poweroff
    ;;
esac
