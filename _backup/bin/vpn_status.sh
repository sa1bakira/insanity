#!/bin/sh

if ip link show proton0 2>/dev//null 1>/dev/null; then
    printf "VPN is ON: %s" "$(curl -s ifconfig.me)"
else
    printf "VPN is OFF"
fi
