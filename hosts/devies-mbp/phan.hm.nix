{ config, pkgs, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "phan";
  home.homeDirectory = "/Users/phan";
  #  launchd.enable = true;
  launchd.agents.FirefoxEnv = {
    enable = true;
    config.ProgramArguments = [
      "/bin/sh"
      "-c"
      "launchctl setenv MOZ_LEGACY_PROFILES 1"
    ];
    config.RunAtLoad = true;
  };

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
    ../../hmmodules/firefox
    ../../mac/copy-to-spotlight.nix
  ];

  henning.tmux.enable = true;
  #  nixpkgs.config.allowUnfree = true; # has no effect https://github.com/nix-community/home-manager/issues/2942
  nixpkgs.config.allowUnfreePredicate = (_: true);
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    comma
    direnv
    silver-searcher

  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/henningphan/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
  };

  henning.firefox = {
    enable = true;
    package = null;
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
