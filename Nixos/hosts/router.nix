# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      ../system/tty.nix
      ../system/common.nix
      ../system/zsh.nix
      ../k8s/tools.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Kernel 
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
  };

  # Networking 
  networking = {
    # Hostname
    hostName = "router";
    # firewall & NAT
    
    firewall.enable = true;
    firewall.interfaces.enp1s0.allowedTCPPorts = [ 53 ];
    firewall.interfaces.enp1s0.allowedUDPPorts = [ 53 ];
    
    nat.enable = true;
    nat.internalIPs = [ "10.1.1.0/24" ];
    nat.internalInterfaces = [ "enp1s0" ];
    nat.externalInterface = "enp3s0";
    # Interfaces
    defaultGateway = { address = "192.168.1.1"; interface = "enp3s0"; };
    interfaces.enp3s0 = { 
      ipv4.addresses = [ 
        { address = "192.168.1.2"; prefixLength = 24; }
      ];
    };
    interfaces.enp1s0 = {
        ipv4.addresses = [
            { address = "10.1.1.1"; prefixLength = 24; }
        ];
    };
  
  };

  # DHCP
  services.dhcpd4 = {
      enable = true;
      extraConfig = ''
      option subnet-mask 255.255.255.0;
      option routers 10.1.1.1;
      option domain-name-servers 10.1.1.1, 9.9.9.9, 8.8.8.8;
      subnet 10.1.1.0 netmask 255.255.255.0 {
          range 10.1.1.100 10.1.1.254;
      }
      '';
      interfaces = [ "enp1s0" ];
  };
  # DNS
  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = [ "127.0.0.1" "10.1.1.1" ];
        access-control =  [
          "0.0.0.0/0 refuse"
          "127.0.0.0/8 allow"
          "10.1.1.0/24 allow"
        ];
      };
    };
  };
      
  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "no";
  };


  # Define a user account.
  users.users.geir = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

