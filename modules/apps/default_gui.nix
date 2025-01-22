{ pkgs, ... }:

{
    # Always installed GUIs
    home.packages = with pkgs; [

        # Productivity
        obsidian
        syncthing
        pcmanfm

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
