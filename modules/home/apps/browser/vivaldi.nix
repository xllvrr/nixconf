# Vivaldi setup
{ pkgs, ... }:
{
  programs.vivaldi = {
    enable = true;
    package = pkgs.vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
    };

    # Match the previous Chromium extensions:
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
