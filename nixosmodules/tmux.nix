{ config, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [ wl-clipboard-x11 ];
}
