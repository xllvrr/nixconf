{ ... }:
let
  browserPolicy = {
    MetricsReportingEnabled = false;
    DefaultBrowserSettingEnabled = false;
    BlockThirdPartyCookies = true;

    # Startup behavior: restore the last session ("Continue where you left off").
    RestoreOnStartup = 1;

    # Default search engine (Ecosia).
    DefaultSearchProviderEnabled = true;
    DefaultSearchProviderName = "Ecosia";
    DefaultSearchProviderKeyword = "eco";
    DefaultSearchProviderSearchURL = "https://www.ecosia.org/search?q={searchTerms}";
    DefaultSearchProviderSuggestURL = "https://ac.ecosia.org/autocomplete?q={searchTerms}&type=list";
    DefaultSearchProviderIconURL = "https://www.ecosia.org/favicon.ico";

    # Extra "Site search" entries (shortcuts: type `@<shortcut>` in the address bar).
    SiteSearchSettings = [
      {
        name = "Ecosia";
        shortcut = "eco";
        url = "https://www.ecosia.org/search?q={searchTerms}";
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
in
{
  environment.etc."vivaldi/policies/managed/xllvr.json".text = builtins.toJSON browserPolicy;
}
