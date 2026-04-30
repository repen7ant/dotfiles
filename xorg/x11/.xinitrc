#!/bin/sh

redshift &
xset r rate 200 35 &
xwallpaper --zoom /home/ilya/walls/penguin.png
xrandr -s 1920x1080 &
flameshot &
exec i3
