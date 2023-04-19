#!/bin/sh

INTERFACE='proton0'

if ip link show "$INTERFACE" >/dev/null 1>/dev/null; then
    if IP="$(curl -s --connect-timeout 1 --max-time 1 ifconfig.me)"; then
        printf "VPN is ON: %s" "$IP"
    else
        printf "Network error."
    fi
else
    printf "VPN is OFF"
fi
