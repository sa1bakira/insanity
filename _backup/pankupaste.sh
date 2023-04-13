#!/bin/sh

# Written by: panku, o1, deesix
#/

# Global variables
#/
EXPIRE_TIME=4
    VERBOSE=0
      LINKS=""



# Banner
#/
printf "                                     \n"
printf " ▄▀▀▄ █▀▀▄ █▀▀ ▀█▀ █▀▀ █▀▀▄  ▀  █▀▀▄ \n"
printf " █▄▄█ █▄▄█ ▀▀▄  █  █▀▀ █▀▀▄  █▀ █  █ \n"
printf " █    ▀  ▀ ▀▀▀  ▀  ▀▀▀ ▀▀▀▀ ▀▀▀ ▀  ▀ \n"
printf "                                     \n"



# Usage
#/
usage ()
{
    printf "Usage: %s [OPTIONS] <file>                           \n\n" "$(basename "$0")"
    printf "Options:                                               \n"
    printf "  -f,             :Full mode, html and plain links    \n"
    printf "  -p,             :Plain mode, plain links only       \n"
    printf "  -m,             :HTML mode, html links only         \n"
    printf "  -e, <1-48>      :Expire time in hours, default = 4  \n"
    printf "  -h,             :Show this help                   \n\n"
}



# Arguments parser
#/
while getopts 'ho:fpme:' OPTION; do
  case "$OPTION" in 
    # --- Help
    h) usage; exit 1 ;;

    # --- Verbose mode
    f) VERBOSE=1 ;;

    # --- output only plain links
    p) VERBOSE=2 ;;

    # --- Output only plain links
    m) VERBOSE=3 ;;

    # --- Expire time
    e)
        # Check if expire time: exist, is a non negative integer number, is between 1 and 48
        # Default = 4 if omitted
        if [ "$OPTARG" -ge 0 ] 2>/dev/null || [ "$OPTARG" -lt 0 ] 2>/dev/null; then
            if [ "$OPTARG" -gt 0 ] && [ "$OPTARG" -lt 49 ]; then
                EXPIRE_TIME="$OPTARG"
            else
                printf "ERROR  : hours must be between 1 and 48.\n\n"
                exit 1
            fi
        else
            printf "ERROR  : hours must be a positive integer.\n\n"
            exit 1
        fi

        EXPIRE_TIME="$OPTARG" 
    ;;
    
    # --- Illegal optioon
    *)
        #printf "ERROR  : illegal option.\n\n"
        exit 1
    ;;
    esac
done



shift $((OPTIND-1))

# Check if OPTIONS and ARGUMENTS are empty
if [ $OPTIND -gt 1 ] && [ $# -eq 0 ]; then
    printf "ERROR    : missing file to paste.\n\n"
    exit 1
elif [ $OPTIND -eq 1 ] && [ $# -eq 0 ]; then
    usage
    exit 1
fi



# Pre-paste output
#/
printf "Expire  : %s %s\n" "$EXPIRE_TIME" "$([ "$EXPIRE_TIME" -eq 1 ] && printf "hour" || printf "hours")"
printf "Files   : %s\n\n"  "$(for F in "$@"; do printf "%s " "$(basename "$F" 2>/dev/null)"; done)"



# Files loop
#/
for FILE in "$@"; do
    # Check if: file exist and is not larger than 1000000000 (100MB)
    if [ -f "$FILE" ]; then
        # For the sake of POSIX
        if [ "$(wc -c < "$FILE")" -gt 100000000 ]; then
            printf  "ERROR   : %s is exceeding 100MB.\n\n" "$(basename "$FILE")"
        else

            printf "Sending : %s: \n" "$FILE"
        
            # Send paste to server via curl
            if DATA="$(curl                                            \
                       -o - -#                                         \
                       --connect-timeout 5                             \
                       --form                     post=pastebin        \
                       --form                     plain=true           \
                       --form                     "hours=$EXPIRE_TIME" \
                       --form                     "paste=<$FILE"       \
                       https://www.oetec.com/post                      \
                       )"; then

                # Check if the server return an error message
                if echo "$DATA" | grep -i "fail"; then
                    printf "ERROR   : paste failed.\n\n"
                    exit 1
                fi
                
                # Verbose check
                case $VERBOSE in 
                    0)
                        printf "HTML    : %s\n"   "$(echo "$DATA" | sed '1p;d')"
                        printf "Plain   : %s\n\n" "$(echo "$DATA" | sed '2p;d')" ;;
                    1)
                        LINKS="$LINKS $(echo "$DATA" | sed '1p;d')"
                        LINKS="$LINKS $(echo "$DATA" | sed '2p;d')" ;;
                    2)
                        LINKS="$LINKS $(echo "$DATA" | sed '2p;d')" ;;
                    3)
                        LINKS="$LINKS $(echo "$DATA" | sed '1p;d')" ;;
                esac
            else
                # Catches curl being silly
                printf "ERROR   : curl failed.\n\n"
                #exit 1
            fi
        fi
    else
        printf "ERROR   : %s is not a valid file.\n\n" "$FILE"
        #exit 1 

    fi
done



# Output links
#/
if [ -n "$LINKS" ]; then
    printf "\nLinks   : \n"

    # Loop links
    for LINE in $LINKS; do
        printf "%s\n" "$LINE"
    done
fi
