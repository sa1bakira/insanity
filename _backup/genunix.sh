#!/usr/bin/env bash

data=$(curl -s https://alpha.genunix.com:4443/stats.txt)
streamer=$(printf "%s" "$data" | sed -n 3p | tr -d ' *')
formats=$(printf "%s" "$data" | grep https | tr -d ' ')

function len() {
    return ${#1}
}

# banner
#printf """
#
#  ####   ######  #    #  #    #  #    #  #  #    #
# #    #  #       ##   #  #    #  ##   #  #   #  #
# #       #####   # #  #  #    #  # #  #  #    ##
# #  ###  #       #  # #  #    #  #  # #  #    ##
# #    #  #       #   ##  #    #  #   ##  #   #  #
#  ####   ######  #    #   ####   #    #  #  #    #
#---------------------------------------------------
#
#"""

printf "                      Genunix\n"
printf "+++++++++++++++++++++++++++++++++++++++++++++++++++\n"

if [ $? -eq 28 ] || [ $? -eq 6 ]; then
    printf "Network error.\n\n"
elif [ -z "$streamer" ]; then
    printf "No one is streaming\n\n"
else
    printf "%$((((51 - ${#streamer} - 14) / 2)))s %s\n\n" " " "$streamer is streaming"

    printf "%s\n\n" "$formats"
    printf "rtmp://live.genunix.com/%s\n" "$streamer"
fi
