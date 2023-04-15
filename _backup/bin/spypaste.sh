#!/bin/sh

# Banner

HANG=1
SPY_DIR=~/spypaste

while :; do
    printf "                                    \n"
    printf "░█▀▀░▄▀▀▄░█░░█░▄▀▀▄░█▀▀▄░█▀▀░▀█▀░█▀▀\n"
    printf "░▀▀▄░█▄▄█░█▄▄█░█▄▄█░█▄▄█░▀▀▄░░█░░█▀▀\n"
    printf "░▀▀▀░█░░░░▄▄▄▀░█░░░░▀░░▀░▀▀▀░░▀░░▀▀▀\n"
    printf "   %s                             \n\n" "$(date)"

    LINKS="$(grep -R -h -o "https://www.oetec.com/pastebin/.*[^\s]" ~/irclogs/ | cut -d ' ' -f1)"

    for PASTE in $(echo "$LINKS" | rev | cut -d '/' -f1 | rev); do
        if [ ! -f $SPY_DIR/"$PASTE" ]; then
            if curl -s -I "https://www.oetec.com/pastebin/plain/$PASTE" | grep "Expires: " 1>/dev/null; then
                printf "\nDownloading: %s\n" "$PASTE"
                wget "https://www.oetec.com/pastebin/plain/$PASTE" -O $SPY_DIR/"$PASTE" -q --show-progress
                echo
            else
                printf "%s expired.\n" "$PASTE"
                echo "expired" > $SPY_DIR/"$PASTE"
            fi
        fi
    done

    printf "\nWaiting for new links...\n"
    sleep $HANG
    clear
done
