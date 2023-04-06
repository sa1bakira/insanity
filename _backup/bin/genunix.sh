#!/usr/bin/env bash

data=$(curl -s https://alpha.genunix.com:4443/stats.txt)
streamer=$(printf "$data" | sed -n 3p | tr -d ' *')
formats=$(printf "$data" | grep https | tr -d ' ')

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
    printf "%$(echo $(((51 - ${#streamer} - 14) / 2)))s %s\n\n" " " "$streamer is streaming"

    printf "$formats\n\n"
    printf "rtmp://live.genunix.com/$streamer\n"
fi
