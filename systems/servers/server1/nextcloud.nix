{ pkgs, ... }:

{
  #  Nextcloud Config
  environment.etc."nextcloud-admin-pass".text = "siKKerhet666";
  services.nextcloud = {
    enable = true;
    hostname = "nextcloud.geokkjer.eu";

    # Ssl Let'encrypt
    #hostName = "cloud.geokkjer.eu";
    #https = true;

    # Auto-update Nextcloud Apps
    autoUpdateApps.enable = true;
    # Set what time makes sense for you
    autoUpdateApps.startAt = "05:00:00";
    # enable redis cache
    configureRedis = True;
    # Create db locally , maybe not needed with sqlite
    database.createLocally = true;
    # Config options
    config = {
      dbtype = "sqlite";
      adminpassFile = "/etc/nextcloud-admin-pass";
    };
  };
}
