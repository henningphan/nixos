{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ gnome-network-displays ];
  xdg.portal.enable = true;

  xdg.portal.xdgOpenUsePortal = true;
  xdg.portal.extraPortals = [
    #pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-gnome
    pkgs.xdg-desktop-portal-wlr
  ];
  networking.firewall.trustedInterfaces = [ "p2p-wl+" ];

  networking.firewall.allowedTCPPorts = [
    7236
    7250
  ];
  networking.firewall.allowedUDPPorts = [
    7236
    5353
  ];
}
