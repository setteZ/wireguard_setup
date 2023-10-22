# Server setup
This part consists of two bash scripts:
1. setup the wireguard configuration
2. create a config file for a new peer

## Dependencies
- [qrencode](https://fukuchi.org/works/qrencode/)

## Wireguard configuration
Download and run [wg_setup.sh](./wg_setup.sh) or
```bash
curl -s https://raw.githubusercontent.com/setteZ/wg_setup/master/server/wg_setup.sh | sudo bash
```
## Create new peer
Download [wg_new_peer.sh](./wg_new_peer.sh) with
```bash
curl -s https://raw.githubusercontent.com/setteZ/wg_setup/master/server/wg_new_peer.sh > wg_new_peer.sh
```
or
```bash
wget https://raw.githubusercontent.com/setteZ/wg_setup/master/server/wg_new_peer.sh
```
make it executable
```bash
chmod u+x wg_new_peer.sh
```
and launch it
```bash
./wg_new_peer.sh peer_name peer_ip
```

You will have a _peer_name_ folder with the brand new `peer_name.conf` file 