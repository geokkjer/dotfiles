{ config, pkgs, ... }:
{
  services.calibre-web = {
    enable = true;
    #group = "media";
    options = {
      calibreLibrary = "/mnt/remote/media/books/calibre/";
      enableBookUploading = true;
      listen = {
        ip = "127.0.0.1";
        port = 8083;
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 8083 ];

}
