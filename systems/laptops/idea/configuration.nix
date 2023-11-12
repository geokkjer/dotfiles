{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./zsh.nix
      ./sway.nix
      ./tty.nix
      ./aliases.nix
      ./k8s.nix
      ./tail.nix
    ];

  # Bootloader.
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # Enable all unfree hardware support.
  hardware.firmware = with pkgs; [ firmwareLinuxNonfree ];
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true;
  services.fwupd.enable = true;

  services.fstrim.enable = true;

  # Networking
  networking.networkmanager.enable = true;
  networking.hostName = "idea"; 

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "no";
    xkbVariant = "";
  };

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
  };

  # Enble flakes and other experimental features 
  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    package = pkgs.nixFlakes;
  };

  # User account.
  nix.settings.trusted-users = [ "root" "geir" ];
  environment.localBinInPath = true;
  users.users.geir = {
    isNormalUser = true;
    description = "Geir Okkenhaug Jerstad";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      # Browsers
      firefox qutebrowser
      # Fonts
      fira-code fira-mono fira-code-symbols meslo-lgs-nf
      # Monitoring tools
      htop glances zenith bottom fwupd
      # shells & terminals
      foot
      starship
      nushell
      fzf
      # Multiplexers
      screen
      tmux
      zellij
      # Editors & command line text utils
      mc 
      neovim
      poppler_utils
      emacs
      emacsPackages.vterm
      libvterm libtool
      magic-wormhole
      protonvpn-cli
      #
      mpv
      # DevSecOps
      kubectl
      k9s
      virt-manager
      # Audio tools  
      ncpamixer
    ];
  };

  environment.systemPackages = with pkgs; [
     git unzip
     wget curl
     neofetch inxi mlocate
     tailscale
     # Languages
     python3 python3Packages.pip
     guile
     go gotools golint
     rustup
     # language servers
     python3Packages.python-lsp-server
     rnix-lsp
     gopls
     luajitPackages.lua-lsp
     nodePackages.bash-language-server
     vimPlugins.cmp-nvim-lsp
     ccls
     # building software
     direnv
     cmake
     gcc
     bintools
     gnutar
     sccache
  ];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [ 22 ];
  networking.firewall.enable = true;
  system.stateVersion = "22.11";
}
