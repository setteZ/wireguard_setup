#!/bin/bash

if [ "$1" ]; then
    peer_name=$1
else
    peer_name="peer"
fi

if [ -d "$peer_name" ]; then
    echo "${peer_name} already exists"
    exit 1
fi

if [ "$2" ]; then
    peer_ip=$2
else
    peer_ip="10.8.0.2/32"
fi

# make new peer folder
mkdir $peer_name
cd $peer_name
peerpath=`pwd`

#ip -o -4 route list default | cut -d" " -f9 | tee /tmp/pub_ip
curl -s ifconfig.me | tee /tmp/pub_ip
sudo cat /etc/wireguard/wg0.conf | grep ListenPort | cut -d" " -f3 | tee /tmp/wg_port > /dev/null

# key generation
wg genkey | tee $peer_name.key | wg pubkey > $peer_name.pub
wg genpsk > $peer_name.psk

# config file generation for client
echo "[Interface]" > $peer_name.conf
echo "Address = $peer_ip" >> $peer_name.conf
echo "PrivateKey = $(cat $peer_name.key)" >> $peer_name.conf
echo "ListenPort = $(cat /tmp/wg_port)" >> $peer_name.conf
#echo "DNS = 10.8.0.1" >> $peer_name.conf
echo "[Peer]" >> $peer_name.conf
echo "Endpoint = $(cat /tmp/pub_ip):$(cat /tmp/wg_port)" >> $peer_name.conf
echo "AllowedIPs = 0.0.0.0/0, ::/0" >> $peer_name.conf
echo "PublicKey = $(sudo cat /etc/wireguard/public.key)" >> $peer_name.conf
echo "PresharedKey = $(cat $peer_name.psk)" >> $peer_name.conf

# update wireguard config file
sudo wg-quick down wg0 > /dev/null
echo "" | sudo tee -a /etc/wireguard/wg0.conf
echo "[Peer]" | sudo tee -a /etc/wireguard/wg0.conf
echo "#$peer_name" | sudo tee -a /etc/wireguard/wg0.conf
echo "AllowedIPs = $peer_ip" | sudo tee -a /etc/wireguard/wg0.conf
echo "PublicKey = $(cat $peerpath/$peer_name.pub)" | sudo tee -a /etc/wireguard/wg0.conf
echo "PresharedKey = $(cat $peerpath/$peer_name.psk)" | sudo tee -a /etc/wireguard/wg0.conf
sudo wg-quick up wg0

# clean
sudo rm /tmp/pub_ip
sudo rm /tmp/wg_port

# show qr-code
qrencode -t ansiutf8 < $peer_name.conf
cd ..