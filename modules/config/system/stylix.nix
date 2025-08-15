# Stylix Configuration
{pkgs, ...}: {
  stylix = {
    enable = true;
    autoEnable = true;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/eris.yaml";

    image = ./Wallpaper.png;

    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 20;

    fonts = {
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat Regular";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat Regular";
      };
      monospace = {
        package = pkgs.nerd-fonts.terminess-ttf;
        name = "Terminess Nerd Font Regular";
      };
      emoji = {
        package = pkgs.nerd-fonts.symbols-only;
        name = "Nerd Fonts Symbols Only";
      };
    };
  };
}
