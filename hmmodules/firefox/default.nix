{ config, pkgs, ...}:
let
  #lib = pkgs.lib;
  cfg = config.henning.firefox;
in
{
  options.henning.firefox = {
    enable = pkgs.lib.mkEnableOption "henning firefox";
    #    package = lib.mkPackageOption pkgs "firefox" {nullable=true;};
  };

  config = pkgs.lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      #package = cfg.package;
      profiles.default = {
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          consent-o-matic
          darkreader
          leechblock-ng
          privacy-badger
          tridactyl
          ublock-origin
          youtube-nonstop
        ];

        search.default = "DuckDuckGo";
        search.force = true;
        policies = {
          AppAutoUpdate = false;
          DisableAppUpdate = true;
          DisableFirefoxStudies = true;
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          OfferToSaveLogins = false;
          PasswordManagerEnabled = false;
        };

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

  };
}
