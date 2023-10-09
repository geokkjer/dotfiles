{ configs, pkgs, ... }:
{
  services.audiobookshelf.enable = true;
  services.audiobookshelf.host = [ 0.0.0.0 ];
  services.audiobookshelf.port = 8000;
  services.audiobookshelf.openFirewall = true;
}
