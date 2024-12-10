{ config, pkgs, ... }:
{
    systemd.tmpfiles.rules =
        [
        "d /exports 770 root henning - -"
    ];
    services.nfs.server = {
    enable = true;
        exports = ''
      /exports    192.168.1.0/24(anongid=20,rw,insecure,sync,no_subtree_check,fsid=root,crossmnt)
      /exports/tv-shows    192.168.1.0/24(anongid=20,rw,insecure,sync,no_subtree_check)
    '';
    };
  networking.firewall.allowedTCPPorts = [
    2049
  ];
    fileSystems."/exports/tv-shows" = {
    device = "/opt/servarr/tv-shows/";
    options = [ "bind" ];
  };
    fileSystems."/exports/movies" = {
    device = "/opt/servarr/movies";
    options = [ "bind" ];
  };
    fileSystems."/exports/black-masstorage" = {
    device = "/dev/disk/by-label/black-masstorage";
    fsType = "ext4";
  };
}
