#!/bin/sh

# Script to easily edit and reconfiguring LXDE

printf "LXDE Config file\n"

printf "[>] Editing ...\n"
vim ~/.config/openbox/trisquel-mini-rc.xml

printf "[>] Reconfiguring ...\n"
openbox --reconfigure

