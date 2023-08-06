{ config, pkgs, ... }:
{
  services.calibre-web = {
    enable = true;
    #group = "media";
    listen = {
        ip = "127.0.0.1";
        port = 8083;
    };
    options = {
      calibreLibrary = "/mnt/remote/media/books/calibre/";
      enableBookUploading = true;
    };
  };
  networking.firewall.allowedTCPPorts = [ 8083 ];
}
