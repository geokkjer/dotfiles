{ config, pkgs, lib, ... }:
  {
    networking.firewall.checkReversePath = "loose";
    networking.wg-quick.interfaces = {
      wg0 = {
        address = [ "192.168.100.3/24" ]; # "fdc9:281f:04d7:9ee9::2/64" 
        #dns = [ "192.168.100.1" "192.168.1.1" ]; # "fdc9:281f:04d7:9ee9::1"
        privateKeyFile = "/root/wireguard-keys/private";
        peers = [
          {
            publicKey = "";
            presharedKeyFile = "/root/wireguard-keys/preshared";
            allowedIPs = [ "192.168.100.1/24" ]; # "::/0"
            endpoint = "46.226.104.98:51820";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  }
