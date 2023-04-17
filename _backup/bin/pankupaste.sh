#!/bin/sh

# Written by: panku, o1, deesix

# Global variables
 EXPIRE_TIME=4
     VERBOSE=0
       LINKS=""
     HISTORY=1
 SCRIPT_NAME="$(basename "$0")"
HISTORY_FILE="/tmp/$SCRIPT_NAME.history"
   TEXT_FLAG=1

# Banner
printf """
   ▄▀▀▄ █▀▀▄ █▀▀ ▀█▀ █▀▀ █▀▀▄  ▀  █▀▀▄
   █▄▄█ █▄▄█ ▀▀▄  █  █▀▀ █▀▀▄  █▀ █  █
   █    ▀  ▀ ▀▀▀  ▀  ▀▀▀ ▀▀▀▀ ▀▀▀ ▀  ▀

"""



# Usage
usage ()
{
    printf "Usage: %s [OPTIONS] <file> \n\n" "$(basename "$0")"
    printf "Options: \n"
    printf "  -t  \"text\"          :Paste text (in double quotes)             \n"
    printf "  -l  <format>        :Show history, formats: full, alive, dead    \n"
    printf "  -c  <url>           :Check expiration time                       \n"
    printf "  -f                  :Full mode, html and plain links             \n"
    printf "  -p                  :Plain mode, plain links only                \n"
    printf "  -m                  :HTML mode, html links only                  \n"
    printf "  -e  <1-48>          :Paste expiration time in hours, default = 4 \n"
    printf "  -s                  :Save paste in history file                  \n"
    printf "  -h                  :Show this help                            \n\n"
}



# Options parse
while getopts 'ht:l:c:o:fpme:s' OPTION; do
  case "$OPTION" in 
    # --- Help
    h) usage; exit 1 ;;

    
    # --- Text paste
    t)
        # Check if string is in between double quotes
        TEXT_PASTE="$OPTARG"
        TEXT_FLAG=0
    ;;


    # --- Show ali
    l)
        # Output history
        # Check if file exist
        if [ -f "$HISTORY_FILE" ]; then

            printf "Grabbing history from '%s'\n\n" "$HISTORY_FILE"
            
            case "$OPTARG" in
                full)  HISTORY_LINKS="$(cat "$HISTORY_FILE")" ;;
                alive) HISTORY_LINKS="$(awk -F\, '$2 > '"$(date +%s)"'' "$HISTORY_FILE")"  ;;
                dead)  HISTORY_LINKS="$(awk -F\, '$2 < '"$(date +%s)"'' "$HISTORY_FILE")"  ;;
                *)
                    printf "ERROR: bad argument.\n"
                    exit 1
                ;;
            esac
            
            printf    "Links \n"
            printf -- "------------\n"
            
            if [ -z "$HISTORY_LINKS" ]; then
                printf "No paste found.\n\n"
            else
                printf "%s\n" "$(echo "$HISTORY_LINKS" | cut -d ',' -f1)"
            fi
  
            exit 0
        else
            printf "ERROR: history file doesn't exist.\n"
            exit 1
        fi
        
    ;;

    # --- Check expiration time
    c)
        # Try to curl the url
        if HEADERS="$(curl -s -I "$OPTARG")"; then

            # Check if the header has the expire date
            if echo "$HEADERS" | grep "Expires: " 1>/dev/null; then

                # Parse all information
                HEADERS="$(echo "$HEADERS" | tr -d '\r')"

                BORN_DATE="$(echo "$HEADERS" | grep "Date: " | cut -d ' ' -f3-6 | tr -d ',')"
                EXPIRE_DATE="$(echo "$HEADERS" | grep "Expires: " | cut -d ' ' -f3-6 | tr -d ',')"

                BORN_SEC="$(date -d "$BORN_DATE" +%s 2>/dev/null || \
                            date -j -f %d%b%Y%H%M%S "$(echo "$BORN_DATE" | tr -d ' :')" +%s)"

                EXPIRE_SEC="$(date -d "$EXPIRE_DATE" +%s 2>/dev/null || \
                            date -j -f %d%b%Y%H%M%S  "$(echo "$EXPIRE_DATE" | tr -d ' :')" +%s)"

                DIFFERENCE=$(( EXPIRE_SEC - BORN_SEC ))

                printf "Created: %s\n" "$BORN_DATE"
                printf "Expires: %s\n" "$EXPIRE_DATE"

                printf "Timer  : %s hours %s minutes %s seconds\n\n" \
                      "$((  DIFFERENCE / 3600))" \
                      "$(( (DIFFERENCE % 3600) / 60))" \
                      "$((  DIFFERENCE % 60))"

                exit 0
            else
                printf "ERROR: broken link.\n"
                exit 1
            fi
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
        # Check if expiration time (default = 4 if omitted): 
        # - exist
        # - is a non negative integer number
        # - is between 1 and 48
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
    ;;
    
    # --- History
    s)
        # Check if:
        # - a history file has been created already
        # - create in /tmp/scriptname.sh.history
       
        HISTORY=0
 
        if [ ! -f "$HISTORY_FILE" ]; then
            if touch "$HISTORY_FILE"; then
                printf "History file '%s' created.\n" "$HISTORY_FILE"
            else
                printf "ERROR: failed to create history file.\n"
                exit 1
            fi
        fi
        
        printf "Paste session will be saved in: %s\n\n" "$HISTORY_FILE"
       
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
fi

# Check if no ARGUMENTS are passed when OPTIONS are given
if [ "$TEXT_FLAG" -eq 1 ]; then
    if [ $OPTIND -gt 1 ] && [ $# -eq 0 ]; then
        printf "ERROR: no file given.\n"
        exit 1
    else
        ARGS="$*"
    fi
else
    ARGS="$TEXT_PASTE"
fi
 


# Expiration time output
printf "Paste expires in %sh" "$EXPIRE_TIME"
printf " (%s)\n\n" "$(date -u -d "+${EXPIRE_TIME} hours" +'%H:%M:%S - %d/%B/%Y' 2>/dev/null || \
                      date -u -v "+${EXPIRE_TIME}H"      +'%H:%M:%S - %d/%B/%Y')"


# Looping through files
for FILE in $ARGS; do
    # Check if: 
    # - file exist
    # - is not empty
    # - is not larger than 1000000000 (100MB)

    # Check if it's a readable file
    if [ -n "$TEXT_PASTE" ]; then
        CONTENT="paste=$TEXT_PASTE"
    else
        if [ -f "$FILE" ]; then
            # Check if not empty
            if [ -s "$FILE" ]; then
                # Check if filesize is < 100MB
                if [ "$(wc -c < "$FILE")" -gt 100000000 ]; then
                    printf  "ERROR: %s is exceeding 100MB.\n\n" "$(basename "$FILE")"
                else
                    CONTENT="pastefile=@$FILE"
                fi
            else
                printf "ERROR: %s is empty.\n\n" "$FILE"
            fi    
        else
            printf "ERROR: '%s' is not a valid file.\n\n" "$FILE"
        fi
    fi
 

    if [ -n "$CONTENT" ]; then
        # Sending output
        printf "Sending -> " 
        
        if [ "$TEXT_FLAG" -eq 0 ]; then
            printf "%s\n" "$TEXT_PASTE"    
        else
            printf "%s\n" "$(basename "$FILE")"
        fi

        # Curl the file
        if DATA="$(curl                                            \
                   --progress-bar                                  \
                   --output - -#                                   \
                   --connect-timeout 5                             \
                   --form                     post=pastebin        \
                   --form                     plain=true           \
                   --form                     "hours=$EXPIRE_TIME" \
                   --form                     "$CONTENT"           \
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
                    printf "%s\n\n" "$(echo "$DATA" | sed '2p;d')" ;;
                1)
                    LINKS="$LINKS $(echo "$DATA" | sed '1p;d')"
                    LINKS="$LINKS $(echo "$DATA" | sed '2p;d')" ;;
                2)
                    LINKS="$LINKS $(echo "$DATA" | sed '2p;d')" ;;
                3)
                    LINKS="$LINKS $(echo "$DATA" | sed '1p;d')" ;;
            esac
            
            # History save
            if [ "$HISTORY" -eq 0 ]; then
                {
                    printf "%s" "$(echo "$DATA" | sed '2p;d')"
                    printf ","
                    printf "%s\n" "$(date -u -d "+${EXPIRE_TIME} hours" +'%s' 2>/dev/null || \
                                     date -u -v "+${EXPIRE_TIME}H"      +'%s')"
                } >> "$HISTORY_FILE" 
            fi
     
        else
            printf "ERROR: curl failed.\n\n"
        fi

    fi

    CONTENT=''
 
    if [ -n "$TEXT_PASTE" ]; then
        break
    fi
done



# When all files are uploaded print links
if [ -n "$LINKS" ]; then
    printf "\nLinks\n-----\n"

    for LINE in $LINKS; do
        printf "%s\n" "$LINE"
    done
    echo
fi

