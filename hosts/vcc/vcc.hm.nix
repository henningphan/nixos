{ username }:
{ config, pkgs, ... }:
{
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "23.05"; # Please read the comment before changing.
  #  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [ "slack" "teams" "vimPlugins.copilot-vim" ];

  imports = [
    ../../hmmodules/bash
    ../../hmmodules/neovim
    ../../hmmodules/tmux
  ];

  home.packages = with pkgs; [
    devenv
    direnv
    git
    git-review
    libreoffice
    nh
    nix-direnv
    python311Packages.grip
    remmina
    silver-searcher
    slack
    teams-for-linux
    ungoogled-chromium
    xclip
    yq
  ];

  programs.neovim.extraPlugins = with pkgs.vimPlugins; [ copilot-vim ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
  programs.git = {
    enable = true;
    delta.enable = true;
    delta.options.side-by-side = true;
    userEmail = "${username}@volvocars.com";
    userName = "Henning phan";
    extraConfig.gitreview.remote = "origin";
  };

  programs.firefox = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
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

}
