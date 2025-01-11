# Stylix Configuration
{ pkgs, ... }:


{
    
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

    stylix.image = ./Wallpaper.png;

    stylix.cursor.package = pkgs.bibata-cursors;
    stylix.cursor.name = "Bibata-Modern-Ice";
   
}
