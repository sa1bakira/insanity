#!/bin/sh

# Banner

HANG=5

while :; do
    printf "                                    \n"
    printf "░█▀▀░▄▀▀▄░█░░█░▄▀▀▄░█▀▀▄░█▀▀░▀█▀░█▀▀\n"
    printf "░▀▀▄░█▄▄█░█▄▄█░█▄▄█░█▄▄█░▀▀▄░░█░░█▀▀\n"
    printf "░▀▀▀░█░░░░▄▄▄▀░█░░░░▀░░▀░▀▀▀░░▀░░▀▀▀\n"
    printf "   %s                             \n\n" "$(date)"

    FLAG=0
    LINKS="$(grep -R -h -o "https://www.oetec.com/pastebin/.*[^\s]" ~/irclogs/ | cut -d ' ' -f1)"

    for PASTE in $(echo "$LINKS" | rev | cut -d '/' -f1 | rev); do
        if [ ! -f ~/spypaste/$PASTE ]; then
            FLAG=1
            printf "Downloading: %s\n" "$PASTE"
            wget "https://www.oetec.com/pastebin/plain/$PASTE" -O ~/spypaste/$PASTE -q --show-progress
            echo
        fi
    done

    if [ "$FLAG" -eq 0 ]; then
        printf "No new paste found.\n\n"
    fi
    
    printf "Waiting for new links...\n"
    sleep $HANG
done
