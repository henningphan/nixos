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
    spotify

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
  home.sessionVariables =
    {
    };

  programs.firefox = {
    enable = true;
    package = pkgs.writeTextDir "firefox" "null";
    profiles.default = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        consent-o-matic
        darkreader
        firefox-translations
        leechblock-ng
        privacy-badger
        tridactyl
        ublock-origin
        youtube-nonstop
      ];
      isDefault = true;
      search.default = "DuckDuckGo";
      search.force = true;
      settings = {
        # enable installed extensions
        "extensions.autoDisableScopes" = 0;
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "dom.private-attribution.submission.enabled" = false;
        # I know what I'm doing
        "browser.aboutConfig.showWarning" = false;
        # https://en.wikipedia.org/wiki/IETF_language_tag
        "browser.translations.neverTranslateLanguages" = "en,sv";

        # privacy
        "beacon.enabled" = false; # bluetooth location tracking
        "browser.contentblocking.category" = "strict";
        "device.sensors.enabled" = false;
        "geo.enabled" = true;
        "privacy.clearOnShutdown.history" = false;
        "privacy.globalprivacycontrol.was_ever_enabled" = true;
        "privacy.globalprivacycontrol.enabled" = true;
        "privacy.bounceTrackingProtection.hasMigratedUserActivationData" = true;
        "privacy.donottrackheader.enabled" = true;
        # https://support.mozilla.org/en-US/kb/resist-fingerprinting, it blocks copy paste images into whatsapp
        #"privacy.resistFingerprinting" = true;
        "privacy.resistFingerprinting.pbmode" = true;

        "privacy.trackingprotection.cryptomining.enabled" = true;
        "privacy.trackingprotection.emailtracking.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.pbmode.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;

        # telemetry
        "browser.ping-centre.telemetry" = false;
        "browser.send_pings" = false;
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.urlbar.eventTelemetry.enabled" = false; # (default)
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "extensions.webcompat-reporter.enabled" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.unified" = false;

        # Addon recomendations
        "browser.discovery.enabled" = false;
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;

        # don't allow mozilla to test config changes
        "app.normandy.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;
        # misc
        "browser.contentblocking.report.lockwise.enabled" = false; # don't use firefox password manager
        "browser.uitour.enabled" = false; # no tutorial please
        # Auto-decline cookies
        "cookiebanners.service.mode" = 2;
        "cookiebanners.service.mode.privateBrowsing" = 2;
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
