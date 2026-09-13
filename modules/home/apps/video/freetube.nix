{ lib, pkgs, ... }:
let
  settings = [
    {
      _id = "autoplayVideos";
      value = false;
    }
    {
      _id = "backendFallback";
      value = true;
    }
    {
      _id = "backendPreference";
      value = "local";
    }
    {
      _id = "barColor";
      value = true;
    }
    {
      _id = "baseTheme";
      value = "dracula";
    }
    {
      _id = "bounds";
      value = {
        x = 0;
        y = 0;
        width = 1644;
        height = 970;
        maximized = false;
        fullScreen = false;
      };
    }
    {
      _id = "checkForUpdates";
      value = false;
    }
    {
      _id = "currentLocale";
      value = "system";
    }
    {
      _id = "defaultAutoplayInterruptionIntervalHours";
      value = 3;
    }
    {
      _id = "defaultQuality";
      value = "1080";
    }
    {
      _id = "defaultVideoFormat";
      value = "dash";
    }
    {
      _id = "defaultViewingMode";
      value = "theatre";
    }
    {
      _id = "displayVideoPlayButton";
      value = true;
    }
    {
      _id = "expandSideBar";
      value = true;
    }
    {
      _id = "hideChannelSubscriptions";
      value = true;
    }
    {
      _id = "hideLabelsSideBar";
      value = true;
    }
    {
      _id = "hidePopularVideos";
      value = true;
    }
    {
      _id = "hideTrendingVideos";
      value = true;
    }
    {
      _id = "hideUpcomingPremieres";
      value = true;
    }
    {
      _id = "hideVideoViews";
      value = true;
    }
    {
      _id = "mainColor";
      value = "LightGreen";
    }
    {
      _id = "region";
      value = "SG";
    }
    {
      _id = "rememberSearchHistory";
      value = false;
    }
    {
      _id = "secColor";
      value = "Teal";
    }
    {
      _id = "sponsorBlockShowSkippedToast";
      value = false;
    }
    {
      _id = "useSponsorBlock";
      value = true;
    }
  ];
in
{
  home.packages = with pkgs; [
    freetube
  ];

  xdg.configFile."FreeTube/settings.db" = {
    force = true;
    text = lib.concatMapStringsSep "\n" builtins.toJSON settings + "\n";
  };
}
