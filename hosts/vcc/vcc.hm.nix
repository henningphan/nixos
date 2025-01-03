{ cdsid, email }:
{ config, pkgs, ... }:
{
  home.username = "${cdsid}";
  home.homeDirectory = "/home/${cdsid}";

  home.stateVersion = "23.05"; # Please read the comment before changing.
  #  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [ "slack" "teams" "vimPlugins.copilot-vim" ];

  imports = [
    ../../hmmodules/bash
    ../../hmmodules/zsh
    ../../hmmodules/neovim
    ../../hmmodules/tmux
  ];

  home.packages =
    let
      vpn = pkgs.writeShellScriptBin "vpn" ''
        #!/bin/bash
        set -e
        export POINTSHARP_TOKEN="$(cloak view vcc)"
        vccvpn "$@"
      '';
    in
    with pkgs;
    [
      brightnessctl
      cloak
      comma
      devenv
      direnv
      element-desktop
      git
      git-review
      libreoffice
      nh
      nix
      nix-direnv
      nix-index
      python311Packages.grip
      remmina
      silver-searcher
      slack
      spotify
      teams-for-linux
      ungoogled-chromium
      vpn
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
    userEmail = "${email}";
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
        "browser.translations.neverTranslateLanguages" = "en,sv";
      };
    };
  };

}
