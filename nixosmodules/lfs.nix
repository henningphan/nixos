{ config, pkgs, ... }:
{
  virtualisation.virtualbox = {
    host.enable = true;
    guest.enable = true;
    guest.x11 = true;
  };
  users.extraGroups.vboxusers.members = [ "henning" ];

  environment.systemPackages = with pkgs; [ rsync ];
}
