{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./network.nix
    ];
  # Setting kernel options
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
  };
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = { 
    hostName = "router";
    nameservers = [ "127.0.0.1" "192.168.1.1" "1.1.1.1"  ];
    firewall.enable = false;
    interfaces = {

      enp1s0 = {
        useDHCP = true;
      };
      enp3s0 = {
        useDHCP = false;
        ipv4.addresses = [{
          address = "192.168.1.1";
          prefixLength = 24;
        }];
      };  
  };
  
  #nftables = {
  #    enable = true;
  #    ruleset = ''
  #      table ip filter {
  #        chain input {
  #          type filter hook input priority 0; policy drop;

#            iifname { "enp3s0" } accept comment "Allow local network to access the router"
#            iifname "enp1s0" ct state { established, related } accept comment "Allow established traffic"
#            iifname "enp1s0" icmp type { echo-request, destination-unreachable, time-exceeded } counter accept comment "Allow select ICMP"
#            iifname "enp1s0" counter drop comment "Drop all other unsolicited traffic from wan"
#          }
#          chain forward {
#            type filter hook forward priority 0; policy drop;
#            iifname { "enp3s0" } oifname { "enp1s0" } accept comment "Allow trusted LAN to WAN"
#            iifname { "enp1s0" } oifname { "enp3s0" } ct state established, related accept comment "Allow established back to LANs"
#          }
#        }

#        table ip nat {
#          chain postrouting {
#            type nat hook postrouting priority 100; policy accept;
#            oifname "enp1s0" masquerade
#          } 
#        }

#        table ip6 filter {
#	        chain input {
#            type filter hook input priority 0; policy drop;
#          }
#          chain forward {
#            type filter hook forward priority 0; policy drop;
#          }
#        }
#      '';
#    };
  };
  services = {
    openssh.enable = true;
    
    dnsmasq = {
      enable = true;
      settings = {
        server = [ "192.168.1.1" "9.9.9.9" "8.8.8.8" "1.1.1.1" ];
        # sensible behaviours
     	domain-needed = true;
      	bogus-priv = true;
      	no-resolv = true;

      	# Cache dns queries.
      	cache-size = 1000;

      	dhcp-range = [ "enp3s0,192.168.1.50,192.168.1.254,24h" ];
      	interface = "enp3s0";
      	dhcp-host = "192.168.1.1";

      	# local domains
      	local = "/lan/";
      	domain = "lan";
      	expand-hosts = true;

      	# don't use /etc/hosts as this would advertise surfer as localhost
      	no-hosts = true;
      	address = "/router.lan/192.168.1.1";
      };
    };
 
  #unbound = {
  #  enable = true;
  #  settings = {
  #    server = {
  #      interface = [ "127.0.0.1" "192.168.1.1" ];
  #      access-control = [
  #        "0.0.0.0/0 refuse"
  #        "127.0.0.0/8 allow"
  #        "192.168.1.0/24 allow"
  #     ];
  #  };
  # };
  #};
 }; 
  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "no";
  #   useXkbConfig = true; # use xkb.options in tty.
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.geir = {
    isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [

       tree
     ];
   };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim emacs-nox 
     wget git curl
     glances htop bottom
     pciutils 
     tcpdump
   ];


  # Enable the OpenSSH daemon.
  #services.openssh.enable = true;

  #networking.firewall.allowedTCPPorts = [ 22 ];
  #networking.firewall.allowedUDPPorts = [ 22 ];
  #networking.firewall.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?

}
