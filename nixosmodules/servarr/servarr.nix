{ config, pkgs, ... }:
let
  lib = pkgs.lib;
  cfg = config.servarr;
in
{
  config.containers.servarr = lib.mkIf cfg.enable {
    enableTun = true;
    autoStart = true;
    # enable plex hardware acceleration
    allowedDevices = [
      {
        modifier = "rw";
        node = "/dev/dri/card0";
      }
      {
        modifier = "rw";
        node = "/dev/dri/renderD128";
      }
    ];
    # persist servarr config and media
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
      # TODO Maybe its possible to put the secret directly into the container
      # instead of bind mounting it
      "/run/secrets/deluge/authFile" = {
        hostPath = "/run/secrets/deluge/authFile";
        isReadOnly = true;
      };
      "/run/secrets/sabnzbd/config" = {
        hostPath = "/run/secrets/sabnzbd/config";
        isReadOnly = true;
      };
    };
    privateNetwork = true;
    macvlans = [ "enp1s0" ];

    config =
      { config, pkgs, ... }:
      {

        fileSystems."/var/lib/private/prowlarr" = {
          device = "/opt/servarr/prowlarr";
          options = [ "bind" ];
        };
        fileSystems."/var/lib/private/jellyseerr" = {
          device = "/opt/servarr/jellyseerr";
          options = [ "bind" ];
        };
        nixpkgs.config.allowUnfree = true;
        networking.defaultGateway = "192.168.1.1";
        networking.firewall.enable = true;
        networking.interfaces.mv-enp1s0 = {
          ipv4.addresses = [
            {
              address = "192.168.1.12";
              prefixLength = 24;
            }
          ];
        };
        users.groups."servarr".gid = cfg.gid;
        users.users = cfg.servarr_users;
        services = {

          tailscale = {
            enable = true;
            authKeyFile = "/root/tailscale_key";
            authKeyParameters.preauthorized = true;
            openFirewall = true;
            useRoutingFeatures = "both";
            extraUpFlags = [
            ];
          };
          sabnzbd = {
            enable = true;
            user = "sabnzbd";
            group = "servarr";
            openFirewall = true;
            configFile = "/run/secrets/sabnzbd/config";
          };
          deluge = {
            authFile = "/run/secrets/deluge/authFile";
            # To see available config options
            # https://git.deluge-torrent.org/deluge/tree/deluge/core/preferencesmanager.py#n37
            config = {
              download_location = "/opt/servarr/deluge/incomplete";
              move_completed = true;
              move_completed_path = "/opt/servarr/deluge/downloads";
              enabled_plugins = [ "Label" ];
            };
            dataDir = "/opt/servarr/deluge";
            declarative = true;
            enable = true;
            group = "servarr";
            user = "deluged";
            openFirewall = true;
            web = {
              enable = true;
              openFirewall = true;
              port = 8112;
            };
          };
          jellyseerr = {
            enable = true;
            openFirewall = true;
          };
          radarr = {
            enable = true;
            openFirewall = true;
            dataDir = "/opt/servarr/radarr";
            group = "servarr";
            user = "radarr";
          };
          prowlarr = {
            enable = true;
            openFirewall = true;
          };
          sonarr = {
            enable = true;
            openFirewall = true;
            dataDir = "/opt/servarr/sonarr";
            group = "servarr";
            user = "sonarr";
          };
        };
        nixpkgs.config.permittedInsecurePackages = [
          "dotnet-sdk-6.0.428"
          "aspnetcore-runtime-6.0.36"
        ];

        nixpkgs.config.allowUnfreePredicate =
          pkg:
          builtins.elem (pkgs.lib.getName pkg) [
            "plexmediaserver"
          ];
        environment.systemPackages = with pkgs; [
          vim
          silver-searcher
        ];

        system.stateVersion = "23.11"; # Did you read the comment?
      };
  };
}
