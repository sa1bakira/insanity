#!/bin/sh

# Written by: panku, o1, deesix

# Global variables
EXPIRE_TIME=4
    VERBOSE=0
      LINKS=""



# Banner
printf "                                \n" 
printf "   __   _   __ _|_  _  |  o     \n"
printf "   |-' |_|_ _\  |_ (/_ |] | |\| \n"
printf "                                \n"



# Usage
usage ()
{
    printf "Usage: %s [OPTIONS] <file>                                   \n\n" "$(basename "$0")"
    printf "Options:                                                       \n"
    printf "  -c  <url>       :Check expiration time                       \n"
    printf "  -f              :Full mode, html and plain links             \n"
    printf "  -p              :Plain mode, plain links only                \n"
    printf "  -m              :HTML mode, html links only                  \n"
    printf "  -e  <1-48>      :Paste expiration time in hours, default = 4 \n"
    printf "  -h              :Show this help                            \n\n"
    printf "Examples:                                                      \n"
    printf "  %s -p -e 10 file.txt                                         \n" "$(basename "$0")"
    printf "  %s *.sh                                                      \n" "$(basename "$0")"
    printf "  %s -f ~/file ~/bin/*.zip                                   \n\n" "$(basename "$0")"
}



# Options parse
while getopts 'hc:o:fpme:' OPTION; do
  case "$OPTION" in 
    # --- Help
    h) usage; exit 1 ;;

    # --- Check expiration time
    c)
        # Try to curl the url
        if HEADERS="$(curl -s -I "$OPTARG" | grep "Date: \|Expires: ")"; then

              BORN_DATE="$(echo "$HEADERS" | sed '1p;d' | cut -d ' ' -f2-)"
            EXPIRE_DATE="$(echo "$HEADERS" | sed '2p;d' | cut -d ' ' -f2-)"
               BORN_SEC="$(date -d "$BORN_DATE" +%s 2>/dev/null || \
                           date -v "$BORN_DATE" +%s)"
             EXPIRE_SEC="$(date -d "$EXPIRE_DATE" +%s 2>/dev/null || \
                           date -v "$EXPIRE_DATE" +%s)"
             DIFFERENCE=$(( $EXPIRE_SEC - $BORN_SEC ))

            printf "Created: %s\n" "$BORN_DATE"
            printf "Expires: %s\n" "$EXPIRE_DATE"

            perl -e 'printf ("Timer: %02d days %02d hours %02d minutes %02d seconds\n",(gmtime('$DIFFERENCE'))[3,2,1,0]);'

            exit 0
        else
            printf "ERROR: broken link.\n"
            exit 1
        fi
    ;;

    # --- Full mode
    f) VERBOSE=1 ;;

    # --- Plain mode
    p) VERBOSE=2 ;;

    # --- HTML mode
    m) VERBOSE=3 ;;

    # --- Expiration time
    e)
        # Check if expiration time: exist, is a non negative integer number, is between 1 and 48
        # Default = 4 if omitted
        if [ "$OPTARG" -ge 0 ] 2>/dev/null || [ "$OPTARG" -lt 0 ] 2>/dev/null; then
            if [ "$OPTARG" -gt 0 ] && [ "$OPTARG" -lt 49 ]; then
                EXPIRE_TIME="$OPTARG"
            else
                printf "ERROR: hours must be between 1 and 48.\n"
                exit 1
            fi
        else
            printf "ERROR: hours must be a positive integer.\n"
            exit 1
        fi

        EXPIRE_TIME="$OPTARG" 
    ;;
    
    # --- Illegal option
    *)
        printf "%s: try '-h' for more information.\n" "$(basename "$0")"
        exit 1
    ;;
    esac
done



# Shift arguments when getopt is done
shift $((OPTIND-1))

# Check if there are no OPTIONS or ARGUMENTS
if [ $OPTIND -eq 1 ] && [ $# -eq 0 ]; then
    printf "%s: try '-h' option for more information.\n" "$(basename "$0")"
    exit 1

# Check if no ARGUMENTS are passed when OPTIONS are given
elif [ $OPTIND -gt 1 ] && [ $# -eq 0 ]; then
    printf "ERROR: no file given.\n"
    exit 1
fi

 

# Expiration time output
printf "Paste expires in %sh" "$EXPIRE_TIME"
printf " (%s)\n" "$(date -u -d "+${EXPIRE_TIME} hours" +'%H:%M:%S - %d/%B/%Y' 2>/dev/null || \
                    date -u -v "+${EXPIRE_TIME}H"      +'%H:%M:%S - %d/%B/%Y')"



# Looping through FILES
for FILE in "$@"; do
    # Check if: 
    # - file exist
    # - is not larger than 1000000000 (100MB)
    if [ -f "$FILE" ]; then
        if [ -s "$FILE" ]; then
            # Check if filesize is < 100MB
            if [ "$(wc -c < "$FILE")" -gt 100000000 ]; then
                printf  "ERROR: %s is exceeding 100MB.\n\n" "$(basename "$FILE")"
            else
                # Sending output
                printf "\nSending -> %s\n" "$(basename "$FILE")"
            
                # Curl the file
                if DATA="$(curl                                            \
                           --progress-bar                                  \
                           --output - -#                                   \
                           --connect-timeout 5                             \
                           --form                     post=pastebin        \
                           --form                     plain=true           \
                           --form                     "hours=$EXPIRE_TIME" \
                           --form                     "paste=<$FILE"       \
                           https://www.oetec.com/post                      \
                           )"; then


                    # Check 404 from website
                    if echo "$DATA" | grep "404" 1>/dev/null; then
                        printf "ERROR: 404 - page not found.\n\n"
                        exit 1
                    fi

                    # Check if server return POST variables error
                    if echo "$DATA" | grep -i "fail" 1>/dev/null; then
                        printf "ERROR: POST failed, check variables.\n\n"
                        exit 1
                    fi

                    # Verbose output
                    # 0 - default output
                    # 1 - full
                    # 2 - plain
                    # 3 - html
                    case $VERBOSE in 
                        0)
                            printf "%s\n" "$(echo "$DATA" | sed '1p;d')"
                            printf "%s\n" "$(echo "$DATA" | sed '2p;d')" ;;
                        1)
                            LINKS="$LINKS $(echo "$DATA" | sed '1p;d')"
                            LINKS="$LINKS $(echo "$DATA" | sed '2p;d')" ;;
                        2)
                            LINKS="$LINKS $(echo "$DATA" | sed '2p;d')" ;;
                        3)
                            LINKS="$LINKS $(echo "$DATA" | sed '1p;d')" ;;
                    esac
                else
                    printf "ERROR: curl failed.\n"
                fi
            fi
        else
            printf "\nERROR: %s is empty.\n" "$FILE"
            exit 1 
        fi    
    else
        printf "\nERROR: '%s' is not a valid file.\n" "$FILE"
        exit 1 
    fi
done



# Check if LINKS is not empty
if [ -n "$LINKS" ]; then
    printf "\nLinks\n-----\n"

    # Print links
    for LINE in $LINKS; do
        printf "%s\n" "$LINE"
    done
fi

