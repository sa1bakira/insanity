#!/bin/sh

if ip link show proton0 2>/dev/null 1>/dev/null; then
    if IP="$(curl -s --connect-timeout 1 ifconfig.me)"; then
        printf "VPN is ON: %s" "$IP"
    else
        printf "Network error."
    fi
else
    printf "VPN is OFF"
fi
