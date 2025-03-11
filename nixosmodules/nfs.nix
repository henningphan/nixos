{ config, pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "d /exports 770 root 1000 - -"
  ];
  services.nfs.server = {
    enable = true;
    exports = ''
      /exports 192.168.1.0/24(anonuid=1000,anongid=1000,rw,insecure,sync,no_subtree_check,fsid=root,crossmnt,all_squash,mountpoint=/exports/black-masstorage)
      /exports/black-masstorage 192.168.1.0/24(anonuid=1000,anongid=1000,rw,insecure,sync,no_subtree_check,crossmnt,all_squash)
      /exports/tv-shows 192.168.1.0/24(anonuid=2003,anongid=10001,rw,insecure,sync,no_subtree_check,crossmnt,all_squash)
      /exports/movies 192.168.1.0/24(anonuid=2002,anongid=10001,rw,insecure,sync,no_subtree_check,crossmnt,all_squash)
    '';
  };
  networking.firewall.allowedTCPPorts = [
    2049
  ];
  fileSystems."/exports/tv-shows" = {
    device = "/exports/black-masstorage/tv-shows";
    options = [ "bind" ];
  };
  fileSystems."/exports/movies" = {
    device = "/exports/black-masstorage/movies";
    options = [ "bind" ];
  };
  fileSystems."/exports/black-masstorage" = {
    device = "/dev/disk/by-label/black-masstorage";
    fsType = "ext4";
  };
}
