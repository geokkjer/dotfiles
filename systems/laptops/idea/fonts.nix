{ config, pkgs, ... }:
{
  fonts.packages = with pkgs; [
    # Fonts
    fira-code
    fira-mono
    fira-code-symbols
    meslo-lgs-nf
  ];
}
