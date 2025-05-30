# Stylix Configuration
{pkgs, ...}: {
  stylix = {
    enable = true;
    autoEnable = true;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

    image = ./Wallpaper.png;

    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 20;

    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.fira;
        name = "Fira Sans";
      };
      monospace = {
        package = pkgs.fira;
        name = "Fira Code";
      };
      emoji = {
        package = pkgs.nerd-fonts.symbols-only;
        name = "Nerd Fonts Symbols Only";
      };
    };
  };
}
