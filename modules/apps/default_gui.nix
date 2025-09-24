{pkgs, ...}: {
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
    cava
    tidal-hifi
    pulsemixer
    qpwgraph

    # Terminal
    kitty
    fuzzel
  ];
}
