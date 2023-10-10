{ configs, pkgs, ... }:
let
  audioBookShelfPort = 8000;
  audioBookSHelfHost = 0.0.0.0;
in
{
  environment.systemPackages = [
    pkgs.audiobookshelf
  ];
  systemd.services = {
    sudiobookshelf = {
      description = "Audiobookshelf";
      wantedBy = ["multi-user.target"];
      restartIfChanged = true;
      environment = {
        PORT = builtins.toString audioBookShelfPort;
        HOST = builtins.toString audioBookShelfHost;
      };
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = "1";
        WorkingDirectory = "/soft";
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
