#/bin/sh

#irssi window
xterm -geom 102x39+30+26 -e 'irssi' &

#vertical leap
xterm -fg darkgreen -geom 1x65+8+25 -e 'tput civis; watch -n 0.1 -t ~/bin/vertical_leap.sh' &

#uptime
xterm -fg red -geom 27x2+30+1000 -e 'tput civis; watch -n 1 -t ~/bin/uptime.sh' &

# ping
xterm -fg green -geom 27x1+30+1050 -e 'tput civis; watch -n 1 -t ~/bin/icmp.sh' &

# widget
xterm -fg cyan -geom 30x2+262+1000 -e 'tput civis; watch -n 1 -t ~/bin/widget.sh' &

# vpn
xterm -fg yellow -geom 30x1+262+1050 -e 'tput civis; watch -n 1 -t ~/bin/vpn_status.sh' &

# insanity
xterm -fg grey -geom 84x4+1230+1000 -e 'tput civis; watch -n 0.1 -t ~/bin/insanity.sh' &

# genunix
xterm -fg yellow -geom 44x4+520+1000 -e 'tput civis; watch -n 5 -t ~/bin/genunix.sh' &

# utility
xterm -geom 102x20+30+660 -e '~/bin/banner.sh; bash' &

# coding
xterm -geom 130x59+860+33 -e '~/bin/banner.sh; bash' &

# spypaste
xterm -fg green -geom 35x4+910+1000 -e 'tput civis; watch -n 1 -t ~/bin/spypaste.sh' &

# inject
xterm -fg darkcyan -geom 42x4+1225+1000 -e 'tput civis; watch -n 0.1 -t ~/bin/inject.sh' &
