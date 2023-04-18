#/bin/sh

# LXDE windows autostart

#vertical leap left
xterm -fg green -geom 2x66+3+8 -e 'tput civis; watch -n 0.1 -t ~/bin/vertical_leap.sh' &

#irssi
xterm -geom 102x31+30+8 -e 'irssi' &

# utility
xterm -geom 102x29+30+519 -e '~/bin/banner.sh; bash' &

#uptime
xterm -fg red -geom 27x2+30+1000 -e 'tput civis; watch -n 1 -t ~/bin/uptime.sh' &

# ping
xterm -fg green -geom 27x1+30+1050 -e 'tput civis; watch -n 1 -t ~/bin/icmp.sh' &

# widget
xterm -fg cyan -geom 30x2+262+1000 -e 'tput civis; watch -n 1 -t ~/bin/widget.sh' &

# vpn
xterm -fg yellow -geom 30x1+262+1050 -e 'tput civis; watch -n 1 -t ~/bin/vpn_status.sh' &

# genunix
xterm -fg yellow -geom 44x4+520+1000 -e 'tput civis; watch -n 5 -t ~/bin/genunix.sh' &

# coding
xterm -geom 128x61+856+8 -e 'cat ~/bin/banner.txt; bash' &

# spypaste
xterm -fg green -geom 35x4+900+1000 -e 'tput civis; watch -n 1 -t ~/bin/spypaste.sh' &

# inject
xterm -fg cyan -geom 42x4+1220+1000 -e 'tput civis; watch -n 0.1 -t ~/bin/inject.sh' &

# insanity
xterm -fg grey -geom 42x4+1555+1000 -e 'tput civis; watch -n 0.1 -t ~/bin/insanity.sh' &

#vertical leap right
xterm -fg green -geom 2x66+1895+8 -e 'tput civis; watch -n 0.1 -t ~/bin/vertical_leap.sh' &
