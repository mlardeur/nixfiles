#!/bin/bash

entries="Logout Suspend Reboot Shutdown"

selected=$(rofi -show menu -modi menu:$HOME/.config/rofi/rofi-power-menu.sh)

case $selected in
  logout)
    swaymsg exit;;
  suspend)
    exec systemctl suspend;;
  hibernate)
    exec systemctl hibernate;;
  reboot)
    exec systemctl reboot;;
  shutdown)
    exec systemctl poweroff -i;;
esac
