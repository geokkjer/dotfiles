{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  networking.hostName = "the-laptop"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable Sway compositor
  # programs.sway.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "no";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "no";

  # Enable CUPS to print documents.
  services.printing.enable = true;

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


  # User account.
  environment.localBinInPath = true;
  programs.fish.enable = true;
  users.users.geir = {
    isNormalUser = true;
    description = "Geir Okkenhaug Jerstad";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      # Browsers
      firefox google-chrome nyxt
      # Fonts
      fira-code fira-mono fira-code-symbols meslo-lgs-nf
      # Gnome
      gnome.gnome-tweaks
      arc-icon-theme beauty-line-icon-theme
      # tools
      htop glances
      # shells & terminals
      wezterm
      starship
      nushell
      fishPlugins.done
      fishPlugins.fzf-fish 
      fishPlugins.forgit
      fishPlugins.hydro
      fzf
      # Virtualisation
      virt-manager
      qemu
      # Emacs
      emacsPackages.vterm
      libvterm libtool
      # Coding
      sbcl
      racket
      guile
      python3Full
      go gotools
      rustup
      # language servers
      rnix-lsp
      gopls
      luajitPackages.lua-lsp
      nodePackages.bash-language-server
      vimPlugins.cmp-nvim-lsp
      # building software
      cmake
      gcc
      bintools
      gnutar
      sccache
      # Remote desktop
      remmina
      # DevSecOps
      kubectl
    ];

  };

  nixpkgs.config.permittedInsecurePackages = [
    "python-2.7.18.6"
    "python3.10-certifi-2022.9.24"
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     neovim emacs git
     wget curl screen
     neofetch inxi mlocate     
  ];

  # Turn on some experimental features for nix

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  system.stateVersion = "22.11";

}
