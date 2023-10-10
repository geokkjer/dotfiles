{ pkgs, modulesPath, libs, ... }:
let
  sshdPort = 8888;
  softServePort = 22;
in {
  networking.firewall.allowedTCPPorts = [ sshdPort, softServePort ];

  environment.systemPackages = with pkgs; [
    soft-serve
  ];
  systemd.services = {
    soft-serve = {
      description = "Soft Serve";
      wantedBy = ["multi-user.target"];
      restartIfChanged = true;
      environment = {
        SOFT_SERVE_PORT = builtins.toString softServePort;
        SOFT_SERVE_HOST = "git.geokkjer.eu";
      };
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = "1";
        WorkingDirectory = "/soft";
        ExecStart = ''
                  ${pkgs.soft-serve}/bin/soft serve
                  '';
      };
    };
  };
}
