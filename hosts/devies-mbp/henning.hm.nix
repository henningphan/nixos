{ config, pkgs, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "henning";
  home.homeDirectory = "/Users/henning";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.
  imports = [
    ../../hmmodules/bash
    ../../hmmodules/macdotatoggle
    ../../hmmodules/neovim
    ../../hmmodules/tmux
    ../../mac/copy-to-spotlight.nix
  ];

  henning.tmux.enable = true;
  #  nixpkgs.config.allowUnfree = true; # has no effect https://github.com/nix-community/home-manager/issues/2942
  nixpkgs.config.allowUnfreePredicate = (_: true);
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    direnv
    kubectl
    silver-searcher
    spotify
    tmux

  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    profiles.default = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        onepassword-password-manager
        consent-o-matic
        darkreader
        firefox-translations
        leechblock-ng
        privacy-badger
        tridactyl
        ublock-origin
        youtube-nonstop
      ];
      search.default = "DuckDuckGo";
      search.force = true;
      settings = {
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "henning phan";
    userEmail = "henning.phan@devies.se";
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
