#/bin/sh


#vertical leap
xterm -fg green -geom 1x65+8+25 -e 'tput civis; watch -n 0.1 -t ~/bin/vertical_leap.sh' &

#irssi
xterm -geom 102x30+30+26 -e 'irssi' &

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
xterm -geom 130x60+860+25 -e '~/bin/banner.sh; bash' &

# spypaste
xterm -fg green -geom 35x4+910+1000 -e 'tput civis; watch -n 1 -t ~/bin/spypaste.sh' &

# inject
xterm -fg cyan -geom 42x4+1225+1000 -e 'tput civis; watch -n 0.1 -t ~/bin/inject.sh' &

# insanity
xterm -fg grey -geom 84x4+1230+1000 -e 'tput civis; watch -n 0.1 -t ~/bin/insanity.sh' &
