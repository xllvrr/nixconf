{ pkgs, ... }:

{
    # Always installed GUIs
    environment.systemPackages = with pkgs; [

        # Health
        safeeyes
        redshift

        # Music
        musikcube
        cava
        tidal-hifi
        pulsemixer
        qpwgraph

    ];
}
