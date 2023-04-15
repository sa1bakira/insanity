#!/bin/sh

COLUMNS="$(stty size | cut -d ' ' -f1)"
   ROWS="$(stty size | cut -d ' ' -f2)"

SIZE=$(($COLUMNS*$ROWS))

#while :; do
    INSANITY="$(tr -dc A-Za-z0-9 </dev/urandom | head -c $SIZE ; echo '')"
    #clear    
    #printf "\033c"
    printf "%s\r" "$INSANITY" 
    sleep 0.5
#done
