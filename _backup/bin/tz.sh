#!/bin/sh

if [ -z "$1" ]; then
    printf "Nope.\n"
    exit 1
fi

CITY="$1"
LEN=$((${#CITY}/2))

if TIMEZONE="$(find /usr/share/zoneinfo/ -maxdepth 2 -name "$CITY" | grep .)"; then
    printf "%s: " "$CITY"
    TZ="$( echo "$TIMEZONE" | cut -d ' ' -f2)" date
else
    printf "ERROR: Can't find the city.\n\n"
    printf "Maybe you were looking for: \n"
    grep -m1 "$(echo $CITY | head -c $LEN)" /usr/share/zoneinfo/tzdata.zi
fi
