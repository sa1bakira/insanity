#!/bin/sh

# Date and weather

printf "%s\n%s" "$(date)" "$(curl -s wttr.in/savona?format=2)"
