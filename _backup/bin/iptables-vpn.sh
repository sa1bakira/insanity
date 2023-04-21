#!/bin/sh

INTERFACE="enp0s3"
IP="88.88.88.88"

iptables --flush
iptables --delete-chain
iptables -t nat --flush
iptables -t nat --delete-chain
iptables -P OUTPUT DROP
iptables -A INPUT -j ACCEPT -i lo
iptables -A OUTPUT -j ACCEPT -o lo
iptables -A INPUT --src 192.168.0.0/24 -j ACCEPT -i "$INTERFACE"
iptables -A OUTPUT -d 192.168.0.0/24 -j ACCEPT -o "$INTERFACE"
iptables -A OUTPUT -j ACCEPT -d "$IP" -o "$INTERFACE" -p udp -m udp --dport 1194
iptables -A INPUT -j ACCEPT -s "$IP" -i "$INTERFACE" -p udp -m udp --sport 1194
iptables -A INPUT -j ACCEPT -i tun0
iptables -A OUTPUT -j ACCEPT -o tun0
