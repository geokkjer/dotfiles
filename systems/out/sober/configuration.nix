#
# This file is auto-generated from "the-sober-counsel.org"
#

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      ../system/fonts.nix
      ../system/tty.nix
      ../system/common.nix
      ../system/editors.nix
      ../system/nix-tools.nix
      ../system/dev.nix
      ../k8s/tools.nix
      ../services/virt.nix
      ../services/containers.nix
      ../desktop/apps.nix
      ../music-production/muprod.nix
      ../users/geir/home.nix

    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # NFS
  #fileSystems."/home/geir/media" = {
  #  device = "192.168.1.119:/mnt/storage/media";
  #  fsType = "nfs";
  #};

  services.fstrim.enable = true; 

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "the-sober-counsel"; # Define your hostname.

  #networking.useDHCP = true;
  #networking = {
  #  defaultGateway = { address = "192.168.1.1"; interface = "enp4s0"; };
  #  interfaces.enp4s0 = {
  #      ipv4.addresses = [
  #          { address = "192.168.1.100"; prefixLength = 24; }
  #      ];
  #   };
  #  interfaces.enp6s0 = {
  #      useDHCP = true;
  #    };

    #interfaces.br0 = {
    #  useDHCP = true;
    #};
    #bridges = {
    #"br0" = {
    #   interfaces = [ "enp6s0" ];
    #   };
    #};
    #nat.enable = true;
    #nat.internalIPs = [ "10.1.1.0/24" ];
    #nat.internalInterfaces = [ "br0" ];
    #nat.externalInterface = "enp4s0";
  # };
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv4.conf.default.forwarding" = 1;
    "net.ipv6.conf.all.forwarding" = "1";  
  };

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";
  # Configure console keymap
  console = {
     font = "Lat2-Terminus16";
     keyMap = "no";
   };


  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nb_NO.utf8";
    LC_IDENTIFICATION = "nb_NO.utf8";
    LC_MEASUREMENT = "nb_NO.utf8";
    LC_MONETARY = "nb_NO.utf8";
    LC_NAME = "nb_NO.utf8";
    LC_NUMERIC = "nb_NO.utf8";
    LC_PAPER = "nb_NO.utf8";
    LC_TELEPHONE = "nb_NO.utf8";
    LC_TIME = "nb_NO.utf8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable the Gnome Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  programs.steam.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "no";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable all unfree hardware support.
  hardware.firmware = with pkgs; [ firmwareLinuxNonfree ];
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim sshfs
    wget curl git
    htop glances
    microcodeAmd
    emacs screen
    calibre
  ];

  # List services that you want to enable:

  # OpenSSH daemon.
  services.openssh.enable = true;
  # Flatpack 
  services.flatpak.enable = true;
  # Fwupd
  services.fwupd.enable = true;
  # Tailscale
  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";

  # Enable home-manager
  # programs.home-manager = {
  #    enable = true;
  #   };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;


  system.stateVersion = "22.05";

}
