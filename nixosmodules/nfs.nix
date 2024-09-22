{ config, pkgs, ... }:
{
  fileSystems."/home/henning/memories" = {
    device = "192.168.1.12:/";
    fsType = "nfs";
    options = [
      "x-systemd.automount"
      "noauto" # lazy-mount: mount when I access the directory
      "x-systemd.idle-timeout=600" # disconnect after inactivity (s)
    ];
  };
}
