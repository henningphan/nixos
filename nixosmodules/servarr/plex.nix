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
      "/opt/servarr/movies" = {
        hostPath = "/exports/black-masstorage/movies";
        isReadOnly = false;
      };
      "/opt/servarr/tv-shows" = {
        hostPath = "/exports/black-masstorage/tv-shows";
        isReadOnly = false;
      };

    };
    privateNetwork = true;
    macvlans = [ "enp1s0" ];
    config =
      { config, pkgs, ... }:
      {
        hardware.opengl = {
          enable = true;
          extraPackages = with pkgs; [
            intel-media-driver
            intel-vaapi-driver # previously vaapiIntel
            vaapiVdpau
            libvdpau-va-gl
            intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
            vpl-gpu-rt # QSV on 11th gen or newer
            intel-media-sdk # QSV up to 11th gen
          ];
        };
        users.groups."servarr".gid = cfg.gid;
        users.groups.render.members = [ "jellyfin" ];
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
          enable = false;
          dataDir = "/opt/servarr/plex";
          openFirewall = true;
          group = "servarr";
          user = "plex";
        };
        services.jellyfin = {
          enable = true;
          openFirewall = true;
          dataDir = "/opt/servarr/jellyfin";
          group = "servarr";
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
