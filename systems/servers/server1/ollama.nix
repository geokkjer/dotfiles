{ config, pkgs, ... }:
let

in
{
  environment.systemPackages = with pkgs; [
    ollama
  ];
  systemd.services = {
    ollama = {
      description = "Ollama";
      after = ["network-online.target"];
      wantedBy = ["multi-user.target"];
      environment = {
        OLLAMA_HOST = "0.0.0.0";
      };
      serviceConfig = {
        Type = "simple";
        User = "ollama";
        Group = "ollama";
        Restart = "always";
        RestartSec = "3";
        ExecStart = ''
                  ${pkgs.ollama}/bin/ollama serve
                  '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 11434 ];

  users.users.ollama = {
    isSystemUser = true;
    group = "ollama";
    createHome = true; 
    };

  users.groups.ollama = {};
}
