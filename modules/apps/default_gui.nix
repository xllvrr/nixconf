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

    # Music
    cava
    pulsemixer
    qpwgraph

    # Terminal
    kitty
    fuzzel
  ];
}
