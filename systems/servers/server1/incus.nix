{ config, pkgs, ... }
{
  virtualisation.incus.enable = true;

  environment.systemPackages = with pkgs; [
    incus
    lxc
  ];
}
