# This module provides the servarr, https://wiki.servarr.com/, with plex media server,
# A set of applications that automatically grabs tv-shows, movies etc
#
# All applications are run in a systemd-nspawn container
# Where the network is isolated and the container uses macvlan to get its own mac address
# to present to the router and therefore looks like its own host to the router.
# Because of current network settings the host cannot contact the container on the network
#
# All application config and media movies are exposed at /opt/servarr
#
# The servarr have a similar setup interface that we control user, group, datadir
# except prowlarr that uses systemd dynamic user.
# https://0pointer.net/blog/dynamic-users-with-systemd.html
#
# Plex, first time visiting the website you have to append the path /web
# example 192.168.1.12:32400/web
#
# https://discourse.nixos.org/t/macvlan-network-devices-not-being-properly-cleaned-up/36501
# If after rebuild the network disappears it can be resolved by killing the proccess
# use "lsns -t net", to find culprit process
# kill -KILL <PID>
#
{ config, pkgs, ... }:
let
  deluge_web_port = 8112;
  jellyseerr_web_port = 5055;
  plex_web_port = 32400;
  prowlarr_web_port = 9696;
  radarr_web_port = 7878;
  sonarr_web_port = 8989;
  torrent_port = 30527;
  servarr_group_gid = 10001;
  lib = pkgs.lib;
  servarr_users = {
    plex = {
      uid = lib.mkForce 2000;
      isSystemUser = true;
      group = "servarr";
    };
    # prowlarr uses systemd dynamicUser instead
    # which gives it a random user id
    radarr = {
      uid = lib.mkForce 2002;
      isSystemUser = true;
      group = "servarr";
    };
    sonarr = {
      uid = lib.mkForce 2003;
      isSystemUser = true;
      group = "servarr";
    };
    deluged = {
      uid = lib.mkForce 2005;
      isSystemUser = true;
      group = "servarr";
    };
    sabnzbd = {
      uid = lib.mkForce 2006;
      isSystemUser = true;
      group = "servarr";
    };
    jellyfin = {
      uid = lib.mkForce 2007;
      isSystemUser = true;
      group = "servarr";
    };
  };
  cfg = config.servarr;
in
{
  options.servarr = {
    enable = lib.mkEnableOption "servarr";
    gid = lib.mkOption {
      type = lib.types.int;
      default = 10001;
      description = "shared group id between all services";
    };
    servarr_users = lib.mkOption {
      type = lib.types.attrs;
      default = servarr_users;
      description = "attrset of all service users";
    };
    plexHardwareAcceleration = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "mounts required devices into the container to enable hardware acceleration";
    };
  };

  #
  # imports contains the nixos-containers nspawn containers
  #
  imports = [
    ./plex.nix
    ./servarr.nix
  ];

  #
  # The following are things that need to exist on host, and maybe in the containers
  #
  config.systemd.tmpfiles.rules = lib.mkIf cfg.enable [
    # setup persistent data files that servarr requires
    # see for definition: https://www.freedesktop.org/software/systemd/man/latest/tmpfiles.d.html
    "d /opt/servarr 770 root servarr - -"
    "d /opt/servarr/tv-shows 770 plex servarr - -"
    "d /opt/servarr/movies 770 plex servarr - -"
    "d /opt/servarr/sabnzbd/complete 770 sabnzbd servarr - -"
    "d /opt/servarr/sabnzbd/incomplete 770 sabnzbd servarr - -"
  ];
  config.sops = lib.mkIf cfg.enable {
    # Need to figure out how to provide non-default sops file
    # to isolate this module
    gnupg.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets."deluge/authFile" = {
      owner = config.users.users.deluged.name;
      restartUnits = [ "container@servarr.service" ];
      sopsFile = ../../secrets/servarr.yaml;
    };
    secrets."sabnzbd/config" = {
      owner = config.users.users.sabnzbd.name;
      restartUnits = [ "container@servarr.service" ];
      sopsFile = ../../secrets/servarr.yaml;
    };
  };

  config.users.groups."servarr".gid = lib.mkIf cfg.enable cfg.gid;
  config.users.users = lib.mkIf cfg.enable cfg.servarr_users;

}
