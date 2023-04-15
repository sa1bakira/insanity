#/bin/sh

#irssi window
xterm -geom 105x37+10+50 -e 'irssi' &

#uptime
xterm -geom 33x2+20+950 -e 'watch -n 60 -t ~/bin/uptime.sh' &

# widget
xterm -geom 33x2+20+1000 -e 'watch -n 1 -t ~/bin/widget.sh' &

# ping
xterm -geom 60x2+320+1000 -e 'ping 8.8.8.8' &

# insanity
xterm -geom 70x3+1330+1010 -e 'watch -n 0.1 -t ~/bin/insanity.sh' &

# utility
xterm -geom 104x14+15+690 &

# genunix
xterm -geom 52x14+880+820 -e 'watch -n 5 -t ~/bin/genunix.sh' &

# coding
xterm -geom 127x47+880+45 &

# spypaste
xterm -geom 70x10+1330+820 -e '~/bin/spypaste.sh' &
