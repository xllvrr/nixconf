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
}
