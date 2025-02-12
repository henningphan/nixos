{ config, pkgs, ... }:
let
        lib = pkgs.lib;
  cfg = config.servarr;
in
{
  config.containers.plex = lib.mkIf cfg.enable {
    autoStart = true;
    # enable plex hardware acceleration
    allowedDevices = lib.mkIf cfg.plexHardwareAcceleration [
      {
        modifier = "rw";
        node = "/dev/dri/card0";
      }
      {
        modifier = "rw";
        node = "/dev/dri/renderD128";
      }
    ];
    bindMounts = {
      "/opt/servarr" = {
        hostPath = "/opt/servarr";
        isReadOnly = false;
      };
      "/dev/dri" = {
        hostPath = "/dev/dri";
        isReadOnly = false;
      };

    };
    privateNetwork = true;
    macvlans = [ "enp1s0" ];
    config =
      { config, pkgs, ... }:
      {
        users.groups."servarr".gid = cfg.gid;
        users.users = cfg.servarr_users;
        networking.defaultGateway = "192.168.1.1";
        networking.firewall.enable = true;
        networking.interfaces.mv-enp1s0 = {
          ipv4.addresses = [
            {
              address = "192.168.1.13";
              prefixLength = 24;
            }
          ];
        };
        services.plex = {
          enable = true;
          dataDir = "/opt/servarr/plex";
          openFirewall = true;
          group = "servarr";
          user = "plex";
        };
        system.stateVersion = "23.11"; # Did you read the comment?
          nixpkgs.config.allowUnfreePredicate =
            pkg:
            builtins.elem (pkgs.lib.getName pkg) [
              "plexmediaserver"
            ];
      };
  };

}
