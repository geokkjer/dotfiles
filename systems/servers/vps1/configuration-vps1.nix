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
  let
    Host = "vps1.tail807ea.ts.net"
  in
    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts = {
        "cloud.geokkjer.eu" = {
          default = false;
          enableACME = true;
          addSSL = true;
        locations."/" = {
          proxyPass = "http://server1.tail807ea.ts.net";
        };
        };
        #virtualHosts."geokkjer.eu" = {
      #  default = true;
        #  forceSSL = true;
        #  enableACME = true;
        #  locations."/".proxyPass = "http://127.0.0.1/";
      #};
      };
    };
      # acme let's encrypt
  security.acme = {
    acceptTerms = true;
    email = "geokkjer@gmail.com";
  };
}
