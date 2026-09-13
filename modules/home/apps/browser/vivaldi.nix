# Vivaldi setup mirrors Chromium extensions.
{ ... }:
{
  programs.vivaldi = {
    enable = true;

    # Match Chromium extensions:
    # - Bitwarden
    # - Ghostery
    # - Dark Reader
    # - Vimium C
    # - ShopBack
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; }
      { id = "mlomiejdfkolichcflejclcbmpeaniij"; }
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; }
      { id = "hfjbmagddngcpeloejdejnfgbamkjaeg"; }
      { id = "djjjmdgomejlopjnccoejdhgjmiappap"; }
    ];
  };
}
