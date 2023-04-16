#!/bin/sh

HOST="8.8.8.8"
PING="$(ping -c 1 -W 1 $HOST | sed '2p;d' | rev | cut -d '=' -f1 | rev)"

printf "Network: "

if [ ! -z "$PING" ]; then
    printf "%s" "$PING"
else
    printf "error" "$HOST"
fi

