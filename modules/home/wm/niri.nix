{
  pkgs,
  config,
  repoRoot,
  configRoot,
  ...
}: let
  wallpaper =
    if (config ? stylix && config.stylix ? image)
    then config.stylix.image
    else repoRoot + "/modules/nixos/theme/Wallpaper.png";
in {
  xdg.configFile."niri/config.kdl" = {
    source = configRoot + "/niri/config.kdl";
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
    swww
    wl-clipboard
  ];
}
