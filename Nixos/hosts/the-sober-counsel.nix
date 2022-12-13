# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

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
      ../k8s/tools.nix
      ../services/virt.nix
      ../services/containers.nix
      ../desktop/apps.nix
      ../users/geir/home.nix

    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Disks
  fileSystems."/home/geir/media" = {
    device = "192.168.1.119:/mnt/storage/media";
    fsType = "nfs";
  };

  services.fstrim.enable = true;
  
  # Tailscale
  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";
  
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
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
  
  # Enable flatpack 
  services.flatpak.enable = true;
  # Fwupd
  services.fwupd.enable = true;

  # Enable home-manager
  # programs.home-manager = {
  #    enable = true;
  #   };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
