#!/bin/sh

# https://www.oetec.com/pastebin
# Thanks to Owen!

# Banner
printf "\n"
printf " ┌─┐┌─┐┌┬┐┌─┐┌─┐\n"
printf " │ │├┤  │ ├┤ │  \n"
printf " └─┘└─┘ ┴ └─┘└─┘\n"
printf "     Pastebin   \n\n"


# Help
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    printf "Website: https://www.oetec.com/pastebin\n\n"
    printf "Usage: $0 [OPTIONS] <file> [HOURS]\n"
    printf " <file>         :Must be a regular file, max size = 10MB\n"
    printf " [HOURS]        :Positive integer between 1 and 48 (default = 4 if omitted)\n"
    printf "Options:\n"
    printf " -h, --help     :Show this help\n"
    printf "\n"
    exit 0
fi


# Check if:
# - file exist
# - is not larger than 10000000
if [ -f "$1" ]; then
    if [ "$(ls -l "$1" | cut -d ' ' -f5)" -gt 10000000 ]; then 
        printf  "ERROR: File size can't exceed 10MB.\n\n"
        exit 1 
    fi
else
    printf "ERROR: need a valid file.\n\n"
    exit 1
    
fi


# Check if $2:
# - exist
# - is a non negative integer number
# - is between 1 and 48
# otherwise set it to 4 (default)
if [ -n "$2" ]; then
    if [ "$2" -ge 0 ] 2>/dev/null || [ "$2" -lt 0 ] 2>/dev/null; then
    	if [ "$2" -gt 0 ] && [ "$2" -lt 49 ]; then
            hours="$2"
        else
            printf "ERROR: hours must be between 1 and 48.\n\n"
            exit 1
	fi
    else
        printf "ERROR: hours must be a positive integer.\n\n"
	exit 1
    fi
else
    hours='4'
fi


# Show file and expire time
printf "File    : %s\n" "$1"
printf "Expire  : %s hours\n\n" "$hours"


# Send paste to server via curl
# silent mode
# connection-timeout = 5
if data="$(curl \
         -o /tmp/bar.tmp \
                      -# \
       --connect-timeout 5 \
                  --data "post=pastebin & plain=true & hours=$hours" \
        --data-urlencode "paste@$1" \
        https://www.oetec.com/post \
        && cat /tmp/bar.tmp && rm /tmp/bar.tmp)"; then

    # Check if the server return an error message
    if echo "$data" | grep -i "fail"; then
        printf "ERROR: paste failed."
        exit 1
    else
        printf "\n"
        printf "HTML    : %s\n" "$(echo "$data" | sed '1p;d')"
        printf "Plain   : %s\n\n" "$(echo "$data" | sed '2p;d')"
    fi
else
    printf "ERROR: curl failed.\n\n"
    exit 1
fi

