# wireguard_setup
This repo consists of two bash scripts:
1. setup the wireguard configuration
2. create a new config file for a new peer

## Dependancies
- wireguard
- qrencode

## Wireguard configuration
Download and run [wireguard_setup.sh](https://raw.githubusercontent.com/setteZ/wireguard_setup/master/wireguard_setup.sh) or
```bash
curl -s https://raw.githubusercontent.com/setteZ/wireguard_setup/master/wireguard_setup.sh | sudo bash
```
## Create new peer
Download [wireguard_new_peer.sh](https://raw.githubusercontent.com/setteZ/wireguard_setup/master/wireguard_new_peer.sh) with
```bash
curl -s https://raw.githubusercontent.com/setteZ/wireguard_setup/master/wireguard_new_peer.sh > wireguard_new_peer.sh
```
or
```bash
wget https://raw.githubusercontent.com/setteZ/wireguard_setup/master/wireguard_new_peer.sh
```
make it executable
```bash
chmod u+x wireguard_new_peer.sh
```
and launch it
```bash
./wireguard_new_peer.sh peer_name peer_ip
```

You will have a _peer_name_ folder with the brand new `peer_name.conf` file 