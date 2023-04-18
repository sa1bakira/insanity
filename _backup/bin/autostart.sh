#/bin/sh

#irssi window
xterm -geom 105x38+10+33 -e 'irssi' &

#uptime
xterm -fg red -geom 28x2+20+1000 -e 'tput civis; watch -n 1 -t ~/bin/uptime.sh' &

# widget
xterm -fg cyan -geom 30x2+262+1000 -e 'tput civis; watch -n 1 -t ~/bin/widget.sh' &

# ping
xterm -fg green -geom 28x1+20+1050 -e 'tput civis; watch -n 1 -t ~/bin/icmp.sh' &

# vpn
xterm -fg yellow -geom 30x1+262+1050 -e 'tput civis; watch -n 1 -t ~/bin/vpn_status.sh' &

# insanity
xterm -fg grey -geom 84x4+1230+1000 -e 'tput civis; watch -n 0.1 -t ~/bin/insanity.sh' &

# genunix
xterm -fg yellow -geom 44x4+520+1000 -e 'tput civis; watch -n 5 -t ~/bin/genunix.sh' &

# utility
xterm -geom 104x18+15+690 -e '~/bin/banner.sh; bash' &

# coding
xterm -geom 130x59+860+33 -e '~/bin/banner.sh; bash' &

# spypaste
xterm -fg green -geom 35x4+910+1000 -e 'tput civis; watch -n 1 -t ~/bin/spypaste.sh' &

# inject
xterm -fg grey -geom 42x4+1225+1000 -e 'tput civis; watch -n 0.1 -t ~/bin/inject.sh' &
