#!/bin/sh

# Banner

HANG=1
SPY_DIR=~/spypaste

printf "%12s.spypaste.\n" " "
printf "%3s%s\n"          " " "$(date)"
printf "%12sfiles: %s\n"  " " "$(ls -l "$SPY_DIR" | wc -l)" 

LINKS="$(grep -R -h -o "https://www.oetec.com/pastebin/.*[^\s]" ~/irclogs/ | cut -d ' ' -f1)"

for PASTE in $(echo "$LINKS" | rev | cut -d '/' -f1 | rev); do
    if [ ! -f $SPY_DIR/"$PASTE" ]; then
        if curl -s -I "https://www.oetec.com/pastebin/plain/$PASTE" | grep "Expires: " 1>/dev/null; then
            printf "      Downloading: %s            \n" "$PASTE"
            curl -s --connect-timeout 5 \ 
                 --max-time 60 \
                 -L "https://www.oetec.com/pastebin/plain/$PASTE" \
                 -o $SPY_DIR/"$PASTE" -q 1>/dev/null
        else
            printf "        %s expired.                \n" "$PASTE"
            echo "expired" > $SPY_DIR/"$PASTE"
        fi
    fi
done

printf "    ...waiting for new links...  \n"
