# Chromium Setup (mirrors Firefox essentials)
{pkgs, ...}: {
  programs.chromium = {
    enable = true;

    # 1.3x UI/content scaling (roughly “130% zoom”).
    commandLineArgs = [
      "--force-device-scale-factor=1.2"
    ];

    # Match Firefox extensions:
    # - Bitwarden
    # - uBlock Origin
    # - Dark Reader
    # - Vimium C
    extensions = [
      {id = "nngceckbapebfimnlniiiahkandclblb";}
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";}
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";}
      {id = "hfjbmagddngcpeloejdejnfgbamkjaeg";}
    ];
  };

  # Some launchers/docks look up icons by desktop-file id (e.g. `chromium-browser`)
  # instead of honoring `Icon=chromium`. Provide an alias icon name.
  xdg.dataFile = let
    iconSizes = [
      "16x16"
      "24x24"
      "48x48"
      "64x64"
      "128x128"
      "256x256"
    ];
    mkIcon = size: {
      name = "icons/hicolor/${size}/apps/chromium-browser.png";
      value.source = "${pkgs.chromium}/share/icons/hicolor/${size}/apps/chromium.png";
    };
  in
    builtins.listToAttrs (map mkIcon iconSizes);
}
