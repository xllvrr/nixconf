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
  xdg.configFile."niri/config.kdl".source = configRoot + "/niri/config.kdl";
  xdg.configFile."niri/wallpaper.png".source = wallpaper;

  home.packages = with pkgs; [
    cliphist
    nicotine-plus
    openssh
    swww
    wl-clipboard
  ];
}
