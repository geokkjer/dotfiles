{ pkgs, configs, ... }:

{
  imports = [ ./gandicloud.nix ];

  environment.systemPackages = with pkgs; [
    neovim curl htop glances neofetch
    tailscale
  ];

  # Firewall 
  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPorts = [ 80 443 ];
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

       virtualHosts."test.geokkjer.eu" = {
         forceSSL = true;
         default = true;
         enableACME = true;
         addSSL = true;
         locations."/".proxyPass = "http://100.75.29.52:19999/";
       };
       virtualHosts."geokkjer.eu" = {
         default = true;
         forceSSL = true;
         enableACME = true;
         locations."/".proxyPass = "http://127.0.0.1/";
       };
  };
  # acme let's encrypt
  security.acme = {
    acceptTerms = true;
    email = "geokkjer@gmail.com";
  };
}
