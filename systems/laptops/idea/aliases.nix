{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    tldr
    exa
    bat
    ripgrep
  ];
  environment.shellAliases = {
    vi = "nvim";
    vim = "nvim";
    h = "tldr";
    # oxidized
    ls = "exa -l";
    cat = "bat";
    grep = "rg";
    top = "btm --color gruvbox";
    # some tools

  };
}
