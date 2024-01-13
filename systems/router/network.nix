{ pkgs, config, ... }:
{

  #  externalInterface = "enp1s0";
  #  internalInterface = "enp3s0";
  #  wifi = "wlp2s0";

    networking = {
      useDHCP = false;
      hostName = "router";
      interfaces = {
        enp1s0 = {
          useDHCP = true;
          nameServer = [ "192.168.1.1" "9.9.9.9" ];
        };
        enp3s0 = {
          useDHCP = false; # lan
          ipv4.addresses = [{
            address = "192.168.1.1";
            prefixLength = 24;
          }];
        };
      };
      # Wifi
      # wpa_passphrase <SSID> <psk>
      #wifi = {
      #};
      # Bridges

    };
}
