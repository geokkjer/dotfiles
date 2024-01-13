{ pkgs, config, ... }:
{
  services.dhcpd4 = {
    enable = true;
    interfaces = [ "ens2" ];
    extraConfig = ''
               option domain-name-servers 192.168.1.1, 1.1.1.1;
               option subnet-mask 255.255.255.0;
               subnet 192.168.1.0 netmask 255.255.255.0
              {
               option broadcast-address 192.168.1.255;
               option routers 192.168.1.1;
               interface ens2;
               range 192.168.1.128 192.168.1.254
              }
                '';
  };
}
