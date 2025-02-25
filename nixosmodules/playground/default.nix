{ config, pkgs, ... }:
let
  lib = pkgs.lib;
  interface = "enp0s13f0u3u1c2";
  shortInterface = builtins.substring 0 5 interface;
in
{
  networking.macvlans."mv-${shortInterface}-host" = {
    interface = interface;
    mode = "bridge";
  };
  networking.interfaces."mv-${shortInterface}-host" = {
    ipv4.addresses = [
      {
        address = "192.168.1.24";
        prefixLength = 24;
      }
    ];
  };

  containers.play = {
    autoStart = true;
    privateNetwork = true;
    macvlans = [ interface ];
    config =
      { config, pkgs, ... }:
      {

        nixpkgs.config.allowUnfree = true;
        networking.firewall.enable = false;
        networking.interfaces."mv-enp0s13ffGxe" = {
          ipv4.addresses = [
            {
              address = "192.168.1.25";
              prefixLength = 24;
            }
          ];
        };
        services.static-web-server = {
          enable = true;
          root = "/tmp";
          listen = "0.0.0.0:8787";
        };

        environment.systemPackages = with pkgs; [
          vim
          silver-searcher
        ];

        system.stateVersion = "23.11";
      };

  };
}
