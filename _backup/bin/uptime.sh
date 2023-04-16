#!/bin/sh

#printf "%s\n" "$(uptime -p)"
UPTIME="$(cat /proc/uptime | cut -d '.' -f1)"

printf "    Clock: %s\n" "$(uptime | cut -d ' ' -f2)"
printf "   Uptime: %0000dd %00dh %00dm %00ds" \
                     "$((UPTIME / 86400))" \
                     "$((UPTIME / 3600))" \
                     "$(( (UPTIME % 3600) / 60))" \
                     "$((UPTIME % 60))"
