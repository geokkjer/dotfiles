{ configs, pkgs, ... }:
let
  audioBookShelfPort = 8000;
in
{
  environment.systemPackages = [
    pkgs.audiobookshelf
  ];
  systemd.services = {
    audiobookshelf = {
      description = "Audiobookshelf";
      wantedBy = ["multi-user.target"];
      restartIfChanged = true;
      environment = {
        PORT = builtins.toString audioBookShelfPort;
        HOST = "0.0.0.0";
      };
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = "5";
        ExecStart = ''
                  ${pkgs.audiobookshelf}/bin/audiobookshelf
                  '';
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ audioBookShelfPort ];
  #services.audiobookshelf.enable = true;
  #services.audiobookshelf.host = 0.0.0.0 ;
  #services.audiobookshelf.port = 8000;
  #services.audiobookshelf.openFirewall = true;
}
