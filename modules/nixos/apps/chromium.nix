{ ... }: {
  # System-wide Chromium/Chrome policies (applies to all users).
  programs.chromium = {
    enable = true;

    extraOpts = {
      # Rough equivalents to the Firefox policies in `modules/home/apps/browser/firefox.nix`.
      MetricsReportingEnabled = false;
      DefaultBrowserSettingEnabled = false;
      BlockThirdPartyCookies = true;

      # Startup behavior: restore the last session ("Continue where you left off").
      # See `chrome://policy` -> RestoreOnStartup.
      RestoreOnStartup = 1;

      # Default search engine (Google).
      DefaultSearchProviderEnabled = true;
      DefaultSearchProviderName = "Google";
      DefaultSearchProviderKeyword = "g";
      DefaultSearchProviderSearchURL = "https://www.google.com/search?q={searchTerms}";

      # Extra "Site search" entries (shortcuts: type `@<shortcut>` in the omnibox).
      # Note: Chromium may already ship some engines; these are added/managed by policy.
      SiteSearchSettings = [
        {
          name = "Google";
          shortcut = "g";
          url = "https://www.google.com/search?q={searchTerms}";
          featured = true;
          allow_user_override = true;
        }
        {
          name = "MyNixOS";
          shortcut = "myn";
          url = "https://mynixos.com/search?q={searchTerms}";
          featured = true;
          allow_user_override = true;
        }
        {
          name = "Youtube";
          shortcut = "yt";
          url = "https://youtube.com/results?search_query={searchTerms}";
          featured = true;
          allow_user_override = true;
        }
        {
          name = "Jisho";
          shortcut = "jsh";
          url = "https://jisho.org/search/{searchTerms}";
          allow_user_override = true;
        }
        {
          name = "KBBI";
          shortcut = "kbb";
          url = "https://kbbi.web.id/{searchTerms}";
          allow_user_override = true;
        }
        {
          name = "ProtonDB";
          shortcut = "pro";
          url = "https://www.protondb.com/search?q={searchTerms}";
          allow_user_override = true;
        }
      ];
    };
  };
}
