#!/bin/bash

INTERFACE="enp0s3"

# Blocking connections
sudo iptables -v --flush
sudo iptables -v --delete-chain
sudo iptables -v -t nat --flush
sudo iptables -v -t nat --delete-chain
sudo iptables -v -P OUTPUT DROP

while :; do
    NUMBER=$((1 + RANDOM % 150))
    CONFIG="nl-free-$NUMBER.protonvpn.net.udp.ovpn"

    if [ -f ~/.vpn/"$CONFIG" ]; then
        IP="$(grep -m1 "remote " ~/.vpn/"$CONFIG" | cut -d ' ' -f2)"

        printf "Setting up killswitch.\n"

        sudo iptables -v -A INPUT -j ACCEPT -i lo
        sudo iptables -v -A OUTPUT -j ACCEPT -o lo
        sudo iptables -v -A INPUT --src 192.168.0.0/24 -j ACCEPT -i "$INTERFACE"
        sudo iptables -v -A OUTPUT -d 192.168.0.0/24 -j ACCEPT -o "$INTERFACE"
        sudo iptables -v -A OUTPUT -j ACCEPT -d "$IP" -o "$INTERFACE" -p udp -m udp --dport 1194
        sudo iptables -v -A INPUT -j ACCEPT -s "$IP" -i "$INTERFACE" -p udp -m udp --sport 1194
        sudo iptables -v -A INPUT -j ACCEPT -i tun0
        sudo iptables -v -A OUTPUT -j ACCEPT -o tun0

        if sudo openvpn --config ~/.vpn/"$SERVER" --dev tun; then
            printf "Starting OpenVPN on: %s\n" "$SERVER" 
        fi
        exit 0
    fi
done

