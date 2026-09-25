{ pkgs, ... }: {
    # Always installed GUIs
    home.packages = with pkgs; [
        # Productivity
        obsidian
        zathura
        system-config-printer

        # Health
        safeeyes

        # Music
        pulsemixer
        qpwgraph

        # Terminal
        fuzzel
    ];
}
