{ configs, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    river
  ];
  programs.river = {
    enable = true;
  };
}
