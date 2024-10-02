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
{config, pkgs, ...}:
let
  deluge_web_port = 8112;
  plex_web_port = 32400;
  prowlarr_web_port = 9696;
  radarr_web_port = 7878;
  sonarr_web_port = 8989;
  torrent_port = 30527;
  servarr_group_gid = 10001;
  lib = pkgs.lib;
  servarr_users = {
      plex = { uid = lib.mkForce 2000; isSystemUser = true; group="servarr";};
      # prowlarr uses systemd dynamicUser instead
      # which gives it a random user id
      radarr = { uid = lib.mkForce 2002; isSystemUser = true;group="servarr";};
      sonarr = { uid = lib.mkForce 2003; isSystemUser = true;group="servarr";};
      deluged = { uid = lib.mkForce 2005; isSystemUser = true;group="servarr";};
  };
in
{
  systemd.tmpfiles.rules =
    [
      # setup persistent data files that servarr requires
      # see for definition: https://www.freedesktop.org/software/systemd/man/latest/tmpfiles.d.html
      "d /opt/servarr 770 root servarr - -"
      "d /opt/servarr/tv-shows 770 plex servarr - -"
    ];
  # Need to figure out how to provide non-default sops file
  # to isolate this module
  sops.defaultSopsFile = ../../secrets/servarr.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets."deluge/authFile" = {
      restartUnits = [ "container@servarr.service" ];
      owner = config.users.users.deluged.name;
  };

  users.groups."servarr".gid = servarr_group_gid;
  users.users = servarr_users;
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
          # TODO Maybe its possible to put the secret directly into the container
          # instead of bind mounting it
          "/run/secrets/deluge/authFile" = {
              hostPath = "/run/secrets/deluge/authFile" ;
              isReadOnly = true;
          };
      };
      privateNetwork = true;
      macvlans = [ "enp1s0" ];

      config = { config, pkgs, ...}:
      {

          fileSystems."/var/lib/private/prowlarr" = {
              device = "/opt/servarr/prowlarr";
              options = [ "bind" ];
          };
          networking.defaultGateway = "192.168.1.1";
          networking.firewall.enable = true;
          networking.interfaces.mv-enp1s0= {
              ipv4.addresses = [
              {
                  address = "192.168.1.12";
                  prefixLength = 24;
              }
              ];
          };
          users.users = servarr_users;
          services = {
              deluge = {
                  authFile = "/run/secrets/deluge/authFile";
                  # To see available config options
                  # https://git.deluge-torrent.org/deluge/tree/deluge/core/preferencesmanager.py#n37
                  config = {
                      download_location = "/opt/servarr/deluge/incomplete";
                      move_completed = true;
                      move_completed_path = "/opt/servarr/deluge/downloads";
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
                      port = deluge_web_port;
                  };
              };
              radarr = {
                  enable = true;
                  openFirewall = true;
                  dataDir = "/opt/servarr/radarr";
                  group = "servarr";
                  user = "radarr";
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
          };
          nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
              "plexmediaserver"
          ];
          environment.systemPackages = with pkgs; [
              vim
              silver-searcher
          ];

          users.groups."servarr".gid = servarr_group_gid;
          system.stateVersion = "23.11"; # Did you read the comment?
      };
  };

}
