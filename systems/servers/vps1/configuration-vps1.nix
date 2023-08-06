{ pkgs, configs, ... }:

{
  imports = [ ./gandicloud.nix ];

  environment.systemPackages = with pkgs; [
    neovim curl htop glances neofetch
    wireguard-tools tailscale
  ];

  # Firewall 
  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPorts = [ 80 443 51820 ];
  };
  # Wireguard quick
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "192.168.100.1/24" ]; # "fdc9:281f:04d7:9ee9::1/64" 
      listenPort = 51820;
      privateKeyFile = "/root/wg-private";
      peers = [
        {
          # laptop
          publicKey = "G86mclNgIuxV+16AU60kwQI4nQhAbko0b5ehmXe3XAI=";
          presharedKeyFile = "/root/wg-preshared";
          allowedIPs = [ "192.168.100.1/24"]; # "fdc9:281f:04d7:9ee9::2/128" 
        }
        # More peers can be added here.
      ];
    };
  };
  # tailscale
  services.tailscale.enable = true;

  # nginx reverse proxy
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
       virtualHosts."test.geokkjer.eu" = { default = true; enableACME = false; addSSL = false; locations."/".proxyPass = "http://100.75.29.52:19999/"; };
  };

  # acme let's encrypt
  security.acme = {
    acceptTerms = true;
    email = "geokkjer@gmail.com";
  };
}
