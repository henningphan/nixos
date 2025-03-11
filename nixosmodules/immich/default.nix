{ config, pkgs, ... }:
let
  lib = pkgs.lib;
  immich_user = {
    immich = {
      uid = lib.mkForce 2100;
      isSystemUser = true;
      group = "immich";
    };
  };
in
{
  config.systemd.tmpfiles.rules = [
    "d /opt/immich 770 root immich - -"
    "d /opt/immich/media 770 root immich - -"
  ];
  config.users.users = immich_user;
  config.users.groups."immich".gid = 10002;
  config.sops = {
    gnupg.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets."immich_env" = {
      restartUnits = [ "container@immich.service" ];
      sopsFile = ../../secrets/immich.yaml;
    };
  };
  config.containers.immich = {
    autoStart = true;
    ephemeral = true;
    bindMounts = {
      "/opt/immich" = {
        hostPath = "/opt/immich";
        isReadOnly = false;
      };
      "/run/secrets/immich_env" = {
        hostPath = "/run/secrets/immich_env";
        isReadOnly = true;
      };
    };
    privateNetwork = true;
    macvlans = [ "enp1s0" ];
    config =
      { config, pkgs, ... }:
      {
        users.groups."immich".gid = 10002;
        networking.defaultGateway = "192.168.1.1";
        networking.firewall.enable = true;
        networking.interfaces.mv-enp1s0 = {
          ipv4.addresses = [
            {
              address = "192.168.1.14";
              prefixLength = 24;
            }
          ];
        };
        services.immich = {
          enable = true;
          openFirewall = true;
          secretsFile = "/run/secrets/immich_env";
          host = "192.168.1.14";
          mediaLocation = "/opt/immich/media";
          #services.immich.accelerationDevices

        };
      };
  };
}
