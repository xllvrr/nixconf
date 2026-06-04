# Chromium Setup (mirrors Firefox essentials)
{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;

    # Match Firefox extensions:
    # - Bitwarden
    # - Ghostery
    # - Dark Reader
    # - Vimium C
    # - ShopBack
    # - Shopee Price Tracker (AliPrice)
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; }
      { id = "mlomiejdfkolichcflejclcbmpeaniij"; }
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; }
      { id = "hfjbmagddngcpeloejdejnfgbamkjaeg"; }
      { id = "djjjmdgomejlopjnccoejdhgjmiappap"; }
      { id = "oanlehpljgeknlohgbakodejdbingjpj"; }
    ];
  };
}
