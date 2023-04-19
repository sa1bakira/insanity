#!/bin/sh

INTERFACE="enp0s3"

# Flushing iptables rules
#sudo iptables --flush
#sudo iptables --delete-chain
#sudo iptables -t nat --flush
#sudo iptables -t nat --delete-chain
#sudo iptables -P OUTPUT DROP

printf "Servers: \n\n%s\n\n" "$(find ~/.vpn/ -name "*.ovpn" -exec basename {} \; | sort)"
read -p '$ ' SERVER

IP="$(echo $SERVER | cut -d '.' -f1-3 )"

if ADDRESS="$(ping -c 1 "$IP")"; then
    printf "Setting up killswitch.\n"

    # Creating killswitch rules on iptables
    #sudo iptables -A INPUT -j ACCEPT -i lo
    #sudo iptables -A OUTPUT -j ACCEPT -o lo
    #sudo iptables -A INPUT --src 192.168.0.0/24 -j ACCEPT -i "$INTERFACE"
    #sudo iptables -A OUTPUT -d 192.168.0.0/24 -j ACCEPT -o "$INTERFACE"
    #sudo iptables -A OUTPUT -j ACCEPT -d "$ADDRESS" -o "$INTERFACE" -p udp -m udp --dport 1194
    #sudo iptables -A INPUT -j ACCEPT -s "$ADDRESS" -i "$INTERFACE" -p udp -m udp --sport 1194
    #sudo iptables -A INPUT -j ACCEPT -i tun0
    #sudo iptables -A OUTPUT -j ACCEPT -o tun0
    
    printf "Starting OpenVPN on: %s\n" "$SERVER" 
    
    sudo openvpn --config ~/.vpn/"$SERVER" --auth-user-pass ~/.vpn/credential.txt

    exit 0
fi
