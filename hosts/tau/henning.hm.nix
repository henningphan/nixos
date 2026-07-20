{ config, pkgs, ... }:
let
  scripts = pkgs.callPackage ../../scripts { };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "henning";
  home.homeDirectory = "/home/henning";

  home.stateVersion = "25.11"; # Please read the comment before changing.
  imports = [
    ../../hmmodules/bash
    ../../hmmodules/macdotatoggle
    ../../hmmodules/neovim
    ../../hmmodules/tmux
  ];

  home.packages = with pkgs; [
    comma
    nix-index
    silver-searcher-ng
    scripts.repo-fzf
  ];

  henning.tmux.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.fzf = {
    enable = true;
  };

  programs.git = {
    enable = true;
    settings.user.name = "Henning Phan";
    settings.user.email = "github@h.phan.se";
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
}
