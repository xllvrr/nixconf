{ pkgs, ... }:
let
  vivaldi =
    (pkgs.vivaldi.override {
      enableWidevine = true;

      # Vivaldi 8.1 crashed during native Wayland initialization on this host.
      # Keep this retry on XWayland and do not prompt to become the default browser.
      commandLineArgs = "--ozone-platform=x11 --no-default-browser-check";
    }).overrideAttrs
      (old: {
        # The current vivaldi-ffmpeg-codecs library prevents Vivaldi 8.2 from
        # starting. Also disable Vivaldi's mutable fallback codec downloader.
        postFixup = (old.postFixup or "") + ''
          wrapProgram "$out/bin/vivaldi" --set VIVALDI_FFMPEG_AUTO 0
        '';
      });
in
{
  programs.vivaldi = {
    enable = true;
    package = vivaldi;

    # Selected Chromium extensions:
    # - Bitwarden
    # - Dark Reader
    # - Vimium C
    # - ShopBack
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; }
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; }
      { id = "hfjbmagddngcpeloejdejnfgbamkjaeg"; }
      { id = "djjjmdgomejlopjnccoejdhgjmiappap"; }
    ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "vivaldi-stable.desktop";
      "application/xhtml+xml" = "vivaldi-stable.desktop";
      "x-scheme-handler/http" = "vivaldi-stable.desktop";
      "x-scheme-handler/https" = "vivaldi-stable.desktop";
    };
  };
}
