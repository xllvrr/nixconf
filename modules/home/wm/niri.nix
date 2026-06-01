{
  pkgs,
  config,
  ...
}: let
  wallpaper =
    if (config ? stylix && config.stylix ? image)
    then config.stylix.image
    else ../../../modules/nixos/theme/Wallpaper.png;
in {
  xdg.configFile."niri/config.kdl" = {
    source = ../../../configs/niri/config.kdl;
    force = true;
  };
  xdg.configFile."niri/wallpaper.png" = {
    source = wallpaper;
    force = true;
  };

  home.packages = with pkgs; [
    cliphist
    nicotine-plus
    openssh
    awww
    wl-clipboard
  ];
}
