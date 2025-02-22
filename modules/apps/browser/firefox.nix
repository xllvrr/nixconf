# Firefox Setup
{ pkgs, inputs, ... }:

{
  programs.firefox = {

    enable = true;

    profiles.xllvr = {

      /* Extensions */

      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        ublock-origin
        darkreader
        vimium-c
      ];

      search.engines = {
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];
          definedAliases = ["@np"];
        };
        "Youtube" = {
          urls = [{
            template = "https://youtube.com/results?search_query={searchTerms}";
          }];
          definedAliases = ["@yt"];
        };
      };
      search.force = true;

    };

    /* Policies */

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      SearchBar = "unified";
    };


  };
}
