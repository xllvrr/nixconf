# Firefox Setup
{
  pkgs,
  inputs,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles.xllvr = {
      /*
      Extensions
      */

      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        ublock-origin
        darkreader
        vimium-c
      ];

      search.engines = {
        "MyNixOS" = {
          urls = [
            {
              template = "https://mynixos.com/search?q={searchTerms}";
            }
          ];
          definedAliases = ["@myn"];
        };
        "Youtube" = {
          urls = [
            {
              template = "https://youtube.com/results?search_query={searchTerms}";
            }
          ];
          definedAliases = ["@yt"];
        };
        "Jisho" = {
          urls = [
            {
              template = "https://jisho.org/search/{searchTerms}";
            }
          ];
          definedAliases = ["@jsh"];
        };
        "KBBI" = {
          urls = [
            {
              template = "https://kbbi.web.id/{searchTerms}";
            }
          ];
          definedAliases = ["@kbb"];
        };
      };
      search.force = true;
    };

    /*
    Policies
    */

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

  stylix.targets.firefox.profileNames = ["xllvr"];
}
