{ config, pkgs, ... }:
{
  services.calibre-web = {
    enable = true;
    group = "media";
    options = {
      calibreLibrary = "/mnt/remote/media/books/calibre/";
      enableBookUploading = true;
      };
  };
}
