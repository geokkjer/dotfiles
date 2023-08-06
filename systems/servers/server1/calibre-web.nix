{ config, pkgs, ... }:
{
  services.calibre-web = {
    enable = true;
    group = "media";
    optinons = {
      calibreLibrary = "/mnt/remote/media/books/calibre/";
      enableBookUploading = true;
      };
  };
}
