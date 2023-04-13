#!/bin/sh

# Date and weather

# print date every seconds
# every hour curl data from wttr

#printf "%s\n%s" "$(date)" "$(curl -s wttr.in/savona?format=2)"

# if date +%M == 00 and %S == 00 then curl

weather="$(curl -s wttr.in/savona?format=2)"

if [ $(date +%M) -eq 00 ] && [ $(date +%S) -eq 00 ]; then
    weather="$(curl -s wttr.in/savona?format=2)"
    echo inside if
fi

printf "%s\n%s" "$(date)" "$weather"

