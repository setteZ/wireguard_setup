# Peer configuration
## Configure
Test your actual public ip
```bash
curl -s ifconfig.me
```
add the wg0 interface
```bash
sudo ip link add dev wg0 type wireguard
```
copy the `peer.conf` file created with [Create new peer](/server/README.md#create-new-peer) to `/etc/wireguard/wg0.conf`. Down and up the interface
```bash
sudo wg-quick down wg0
sudo wg-quick up wg0
```
verify that the new public ip is the one of the wireguard server:
```bash
curl -s ifconfig.me
```
## Autostart in systemd
To have wireguard automatically up at system startup:
```bash
sudo wg-quick down wg0
sudo systemctl enable wg-quick@wg0.service
sudo systemctl daemon-reload
sudo systemctl start wg-quick@wg0
```
reboot the system and check the status:
```bash
sudo wg
```
## Remove the autostart and clean
To remove the service and clean up the system
```bash
sudo systemctl stop wg-quick@wg0
sudo systemctl disable wg-quick@wg0.service
sudo rm -i /etc/systemd/system/wg-quick@wg0*
sudo systemctl daemon-reload
sudo systemctl reset-failed
```