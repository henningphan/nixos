# This module provides the servarr, https://wiki.servarr.com/, and plex stack
# A set of applications that automatically grabs tv-shows, movies etc
#
# All applications are run in a systemd-nspawn container
# Where the network is isolated but we forward the application ports from our host system
#
# All application config and media movies are exposed at /opt/servarr
#
# The servarr have a similar setup interface that we control user, group, datadir
# except prowlarr that uses systemd dynamic user.
# https://0pointer.net/blog/dynamic-users-with-systemd.html
#
# Plex, first time visiting the website you have to have the path /web
# example 192.168.1.20:32400/web
{ config, pkgs, ... }:
let
  deluge_torrent_port = 30528;
  deluge_web_port = 8112;
  plex_web_port = 32400;
  prowlarr_web_port = 9696;
  radarr_web_port = 7878;
  sonarr_web_port = 8989;
  transmission_web_port = 9091;
  torrent_port = 30527;
  lib = pkgs.lib;
  servarr_users = {
    plex = {
      uid = lib.mkForce 2000;
      isNormalUser = true;
    };
    # prowlarr uses systemd dynamicUser instead
    # which gives it a random user id
    radarr = {
      uid = lib.mkForce 2002;
      isNormalUser = true;
    };
    sonarr = {
      uid = lib.mkForce 2003;
      isNormalUser = true;
    };
    transmission = {
      uid = lib.mkForce 2004;
      isNormalUser = true;
    };
  };
in
{
  systemd.tmpfiles.rules = [
    # setup persistent data files that servarr requires
    # see for definition: https://www.freedesktop.org/software/systemd/man/latest/tmpfiles.d.html
    "d /opt/servarr 770 root servarr - -"
    "d /opt/servarr/transmission 770 transmission servarr - -"
    "d /opt/servarr/transmission/.config 770 transmission servarr - -"
    "d /opt/servarr/transmission/.config/transmission-daemon 770 transmission servarr - -"
    "d /opt/servarr/tv-shows 770 plex servarr - -"
  ];

  users.groups."servarr".gid = 10001;
  users.users = servarr_users;
  networking.firewall.allowedTCPPorts = [
    deluge_web_port
    plex_web_port
    prowlarr_web_port
    radarr_web_port
    sonarr_web_port
    transmission_web_port
  ];
  containers.servarr = {
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
    };
    privateNetwork = false;
    macvlans = [ "enp1s0" ];

    forwardPorts = [
      { hostPort = transmission_web_port; }
      { hostPort = sonarr_web_port; }
      { hostPort = prowlarr_web_port; }
      { hostPort = radarr_web_port; }
    ];

    config =
      { config, pkgs, ... }:
      {
        fileSystems."/var/lib/private/prowlarr" = {
          device = "/opt/servarr/prowlarr";
          options = [ "bind" ];
        };
        networking.defaultGateway = "192.168.1.1";
        networking.firewall.enable = false;
        networking.interfaces.mv-enp1s0 = {
          ipv4.addresses = [
            {
              address = "192.168.1.12";
              prefixLength = 24;
            }
          ];
        };
        users.users = servarr_users;
        # https://github.com/NixOS/nixpkgs/issues/258793
        systemd.services.transmission = {
          serviceConfig = {
            RootDirectoryStartOnly = pkgs.lib.mkForce false;
            RootDirectory = pkgs.lib.mkForce "";
          };
        };
        services = {
          deluge = {
            config = {
              dht = false;
              lsd = false;
              utpex = false;
              upnp = false;
              natpmp = false;
              listen_interface = "0.0.0.0";
              listen_ports = [
                30528
                30529
              ];
              random_port = false;

            };
            authFile = "/opt/servarr/deluge/authFile";
            dataDir = "/opt/servarr/deluge";
            declarative = true;
            enable = true;
            group = "servarr";

            web = {
              enable = true;
              port = deluge_web_port;
              openFirewall = true;
            };

          };
          plex = {
            enable = true;
            dataDir = "/opt/servarr/plex";
            openFirewall = true;
            group = "servarr";
            user = "plex";
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
          radarr = {
            enable = true;
            openFirewall = true;
            dataDir = "/opt/servarr/radarr";
            group = "servarr";
            user = "radarr";
          };
          transmission = {
            enable = true;
            group = "servarr";
            user = "transmission";
            home = "/opt/servarr/transmission";
            downloadDirPermissions = "770";
            # https://github.com/NixOS/nixpkgs/issues/279049#issuecomment-1879501707
            # when the patch get merged we can remove webHome
            webHome = pkgs.flood-for-transmission;
            extraFlags = [
              "--logfile"
              "/opt/servarr/transmission/debug.log"
            ];
            settings = {
              peer-port = torrent_port;
              rpc-bind-address = "0.0.0.0";
              rpc-whitelist = "192.168.1.*,127.0.0.1";
              rpc-host-whitelist = "*";
              dht-enabled = false;
              pex-enabled = false;

            };
            openRPCPort = true;
          };
        };
        nixpkgs.config.allowUnfreePredicate =
          pkg: builtins.elem (pkgs.lib.getName pkg) [ "plexmediaserver" ];
        environment.systemPackages = with pkgs; [
          vim
          silver-searcher
        ];

        users.groups."servarr".gid = 10001;
        system.stateVersion = "23.11"; # Did you read the comment?
      };
  };

}
