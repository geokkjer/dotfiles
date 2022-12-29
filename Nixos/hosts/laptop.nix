{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      ../desktop/sway.nix
      ../k8s/tools.nix
      ../system/aliases.nix
      ../system/tty.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";
  # i18n.defaultKeyMap = "no";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # programs.sway.enable = true;
  # programs.ly.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "no";
  };


  # Configure console keymap
  console.keyMap = "no";

  # Fonts
  fonts.fonts = with pkgs; [
        fira-code
        fira-code-symbols
        meslo-lgs-nf
  ];

  # flatpak
  xdg.portal.enable = true; 
  services.flatpak.enable = true;

  # Docker
  virtualisation.docker.enable = true;

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.geir = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Geir Okkenhaug Jerstad";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim 
    wget git
    python httpie 
    firefox vscode chromium 
    btop htop glances neofetch 
    terminator
    gnome.gnome-software gnome.gnome-tweaks
    exa bat tldr
    nmap  
    emacs screen
    # zsh
    zsh
    zsh-completions 
    nix-zsh-completions 
    zsh-powerlevel10k
    fzf
  ];

  # Steam

  #programs.steam = {
  #  enable = true;
    #remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    #dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  #};

  #nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #  "steam"
  #  "steam-original"
  #  "steam-runtime"
  #];

  # zsh conf
  programs.zsh.enable = true;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.autosuggestions.enable = true;
  programs.zsh.interactiveShellInit = ''
  export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/
  export FZF_BASE=${pkgs.fzf}/share/fzf/


  # Customize your oh-my-zsh options here

  ZSH_THEME="agnoster"
  plugins=(git fzf )
  HISTFILESIZE=50000
  HISTSIZE=50000
  setopt SHARE_HISTORY
  setopt HIST_IGNORE_ALL_DUPS
  setopt HIST_IGNORE_DUPS
  setopt INC_APPEND_HISTORY
  autoload -U compinit && compinit
  unsetopt menu_complete
  setopt completealiases
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8

  if [ -f ~/.aliases ]; then
    source ~/.aliases
  fi



  source $ZSH/oh-my-zsh.sh

 '';
 programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leavecatenate(variables, "bootdev", bootdev)
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
