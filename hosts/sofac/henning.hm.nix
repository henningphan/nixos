{ config, pkgs, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "henning";
  home.homeDirectory = "/home/henning";

  home.stateVersion = "23.05"; # Please read the comment before changing.
  imports = [
    ../../hmmodules/bash
    ../../hmmodules/macdotatoggle
    ../../hmmodules/neovim
    ../../hmmodules/tmux
  ];

  home.packages = with pkgs; [
    comma
    nix-index
    silver-searcher
  ];

  henning.tmux.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "Henning Phan";
    userEmail = "github@h.phan.se";
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
}
