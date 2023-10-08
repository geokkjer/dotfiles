{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs;
    [
      zsh
      zsh-completions
      nix-zsh-completions
      starship
      direnv
    ];

  programs.zsh.enable = true;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.autosuggestions.enable = true;
  }
