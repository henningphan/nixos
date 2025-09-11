{ config, pkgs, ... }:
{
  # complement missing
  #home.username = "${cdsid}";
  # complement missing
  #home.homeDirectory = "/home/${cdsid}";

  home.stateVersion = "23.05"; # Please read the comment before changing.
  #  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [ "slack" "teams" "vimPlugins.copilot-vim" ];

  imports = [
    ../../hmmodules/bash
    ../../hmmodules/zsh
    ../../hmmodules/neovim
    ../../hmmodules/tmux
    ../../hmmodules/firefox
  ];

  henning.firefox.enable = true;
  henning.tmux.enable = true;
  henning.tmux.defaultShell = "~/.nix-profile/bin/zsh";
  home.packages = with pkgs; [
  ];

  programs.neovim.extraPlugins = with pkgs.vimPlugins; [ copilot-vim ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
