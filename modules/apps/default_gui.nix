{ pkgs, ... }:

{
    # Always installed GUIs
    home.packages = with pkgs; [

        # Productivity
        obsidian
        syncthing
        zathura
        system-config-printer

        # Health
        safeeyes
        redshift

        # Music
        musikcube
        cava
        tidal-hifi
        pulsemixer
        qpwgraph

        # Security
        mullvad-vpn

        # Terminal
        kitty

    ];
}
