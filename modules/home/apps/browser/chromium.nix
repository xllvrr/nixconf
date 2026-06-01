# Chromium Setup (mirrors Firefox essentials)
{pkgs, ...}: {
  programs.chromium = {
    enable = true;

    # Match Firefox extensions:
    # - Bitwarden
    # - uBlock Origin
    # - Dark Reader
    # - Vimium C
    # - ShopBack
    # - Shopee Price Tracker (AliPrice)
    extensions = [
      {id = "nngceckbapebfimnlniiiahkandclblb";}
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";}
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";}
      {id = "hfjbmagddngcpeloejdejnfgbamkjaeg";}
      {id = "djjjmdgomejlopjnccoejdhgjmiappap";}
      {id = "oanlehpljgeknlohgbakodejdbingjpj";}
    ];
  };
}
