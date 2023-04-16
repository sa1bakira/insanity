#!/bin/sh

data=$(curl -s https://alpha.genunix.com:4443/stats.txt)
streamer=$(printf "%s" "$data" | sed -n 3p | tr -d ' *')
formats=$(printf "%s" "$data" | grep https | tr -d ' ')

printf    "            .genunix livestream.            \n"
printf -- "--------------------------------------------\n"
printf "status: "

if [ $? -eq 28 ] || [ $? -eq 6 ]; then
    printf "network error."
elif [ -z "$streamer" ]; then
    printf "offline."
else
    printf "%s is streaming" "$streamer"
    printf "\nlink: rtmp://live.genunix.com/%s" "$streamer"
fi
