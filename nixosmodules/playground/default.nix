{ config, pkgs, ... }:
let
    lib = pkgs.lib;
  interface = "wlp0s20f3";
in
  {
  networking.macvlans."mv-${interface}-host" = {
            interface =interface;
          mode = "bridge";
          };
    networking.interfaces."mv-${interface}-host" = {
            ipv4.addresses = [ { address = "192.168.1.1"; prefixLength = 24; } ];
        };

  containers.play = {
      autoStart = true;
    # enable plex hardware acceleration
    # persist servarr config and media
    privateNetwork = false;
      macvlans = [ interface ];
      config =
        { config, pkgs, ... }:
        {

          nixpkgs.config.allowUnfree = true;
          networking.firewall.enable = false;
          networking.interfaces."mv-${interface}" = {
            ipv4.addresses = [
              {
                address = "192.168.1.13";
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

      system.stateVersion = "23.11"; # Did you read the comment?
    };

  };
}
