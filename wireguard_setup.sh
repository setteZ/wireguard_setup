#!/bin/bash

if [ "$1" ]; then
    ip=$1
else
    ip="10.8.0.1"
fi

if [ "$2" ]; then
    port=$2
else
    port="51820"
fi

# key generation
wg genkey | tee /etc/wireguard/private.key > /dev/null
chmod go= /etc/wireguard/private.key
cat /etc/wireguard/private.key | wg pubkey | tee /etc/wireguard/public.key

# config file generation (server side)
echo "[Interface]" > /etc/wireguard/wg0.conf
echo "PrivateKey = $(/etc/wireguard/private.key)" >> /etc/wireguard/wg0.conf
echo "Address = $ip" >> /etc/wireguard/wg0.conf
echo "ListenPort = $port" >> /etc/wireguard/wg0.conf
echo "SaveConfig = true" >> /etc/wireguard/wg0.conf

# enable forwarding
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sysctl -p
ip -o -4 route list default | cut -d" " -f5 | tee /tmp/interface
echo "PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o $(cat /tmp/interface) -j MASQUERADE" >> /etc/wireguard/wg0.conf
echo "PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o $(cat /tmp/interface) -j MASQUERADE" >> /etc/wireguard/wg0.conf

# update firewall
ufw allow $port/udp
ufw disable
ufw enable

# run wireguard
systemctl enable wg-quick@wg0.service
systemctl start wg-quick@wg0.service