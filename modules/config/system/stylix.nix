# Stylix Configuration
{ pkgs, ... }:


{
  stylix = {

    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

    image = ./Wallpaper.png;

    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";

    fonts = {
      monospace = {
        package = pkgs.jetbrains-mono;
        name = "Jet Brains Mono";
      };
      emoji = {
        package = pkgs.nerd-fonts.symbols-only;
        name = "Nerd Fonts Symbols Only";
      };
    };

  };
}
