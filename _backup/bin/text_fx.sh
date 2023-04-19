#!/bin/sh


#cat /dev/random

#while :; do
#    tr -dc A-Za-z0-9 </dev/urandom | head -c 160; echo ''
#done


STRING="This is our world now... the world of the electron and the switch, the beauty of the baud.  We make use of a service already existing without paying for what could be dirt-cheap if it wasn't run by profiteering gluttons, and you call us criminals. We explore... and you call us criminals.  We seek after knowledge... and you call us criminals.  We exist without skin color, without nationality, without religious bias... and you call us criminals. You build atomic bombs, you wage wars, you murder, cheat, and lie to us and try to make us believe it's for our own good, yet we're the criminals."

tmp="$STRING"    # The loop will consume the variable, so make a temp copy first

while :; do
    while [ -n "$tmp" ]; do
        rest="${tmp#?}"           # All but the first character of the string
        first="${tmp%"$rest"}"    # Remove $rest, and you're left with the first character

        echo -n "$first"

        tmp="$rest"

        sleep 0.1
    done

    tmp="$STRING"    # The loop will consume the variable, so make a temp copy first
    clear

done
